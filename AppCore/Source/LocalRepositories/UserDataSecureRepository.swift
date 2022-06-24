//
//  Created by Santos, Ricardo Patricio dos  on 30/08/2021.
//

import Foundation
import CoreData
import Combine
//
import AppDomain
import BaseDomain
import Common
import DevTools

class SampleRepository {
    
    fileprivate var cancelBag = CancelBag()
    fileprivate static var db: (name: String, bundle: String) = ("CoreDataDB", "com.you.app.id.AppDomain")

    /// Async DataBase connection (Combine framework)
    fileprivate static var nonSecureInstanceAsyncInstance: Common_FRPCDataStore?
    fileprivate static var nonSecureInstanceAsync: Common_FRPCDataStore {
        if nonSecureInstanceAsyncInstance == nil {
            nonSecureInstanceAsyncInstance = Common_FRPCDataStore(name: db.name, bundle: db.bundle)
        }
        return nonSecureInstanceAsyncInstance!
    }
    
    /// Sync DataBase connection (Combine framework)
    fileprivate static var nonSecureInstanceSyncInstance: Common_NonFRPCDataStore?
    fileprivate static var nonSecureInstanceSync: Common_NonFRPCDataStore {
        if nonSecureInstanceSyncInstance == nil {
            nonSecureInstanceSyncInstance = Common_NonFRPCDataStore(name: db.name, bundle: db.bundle)
        }
        return nonSecureInstanceSyncInstance!
    }
    
    init() { }
}

extension SampleRepository: SampleRepository1Protocol {
    func requesExistsAnyZipCode() -> AnyPublisher<Bool, AppErrors> {
        return requestZipCodesCount()
            .compactMap { $0 > 0 }
            .mapError { _ in AppErrors.ok }
            .eraseToAnyPublisher()
    }
    
    func requestZipCodesCount() -> AnyPublisher<Int, AppErrors> {
        return requestZipCodes(with: "")
            .compactMap { $0.count }
            .mapError { _ in AppErrors.ok }
            .eraseToAnyPublisher()
    }
    
    func requestZipCodes(with filter: String) -> FetchZipCodesResponse {

        let request = NSFetchRequest<ZipCodeCoreDataEntety>(entityName: ZipCodeCoreDataEntety.entityName)
        if !filter.trim.isEmpty {
            request.predicate = NSPredicate.with(filter: filter.trim)
        }
        let recordsModel = Self.nonSecureInstanceAsync.publisher(fetch: request)
            .mapError { _ in AppErrors.ok }.eraseToAnyPublisher()
            .flatMap { (list) -> FetchZipCodesResponse in
                let mapped = list.compactMap { $0.mapToModel }
                return Just(mapped)
                    .setFailureType(to: AppErrors.self)
                    .eraseToAnyPublisher()
            }
        return recordsModel
            .eraseToAnyPublisher()
    }
    
    func requestDeleteAllZipCodes() {
        let request = NSFetchRequest<ZipCodeCoreDataEntety>(entityName: ZipCodeCoreDataEntety.entityName)
        Self.nonSecureInstanceAsync
            .publisher(delete: request)
            .sink { _ in } receiveValue: { _ in
                DevTools.Log.debug("Deleting \(ZipCodeCoreDataEntety.entityName) succeeded", .repository)
            }
            .store(in: cancelBag)
    }
    
    func requestSaveChunksCombined(models: [Model.PortugueseZipCode]) {
        // Split the 340k records into 1000 size chunckss
        let chuckSize = 1000
        let chunks = models.chunked(into: chuckSize)
        chunks.forEach { (chunk) in
            autoreleasepool { [weak self] in
                // Save all the 340 arrays of 1000 elements using save2
                self?.syncSave(models: chunk)
            }
        }
    }
}

fileprivate extension SampleRepository {
    func syncSave(models: [Model.PortugueseZipCode]) {
        let managedObjectContext = Self.nonSecureInstanceSync.privateQueue
        managedObjectContext.perform {
            models.forEach { (model) in
                autoreleasepool {
                    if let record = NSEntityDescription.insertNewObject(forEntityName: ZipCodeCoreDataEntety.entityName,
                                                                        into: managedObjectContext) as? ZipCodeCoreDataEntety {
                        record.nomeLocalidade = model.nomeLocalidade
                        record.numCodPostal   = model.numCodPostal
                        record.extCodPostal   = model.extCodPostal
                        record.desigPostal    = model.desigPostal
                        record.id = UUID()
                        do {
                            DevTools.Log.debug("saving \(model.numCodPostal)-\(model.extCodPostal)", .repository)
                            try managedObjectContext.save()
                        } catch {
                            DevTools.Log.error("\(error)", .repository)
                        }
                        managedObjectContext.reset()
                    }
                }
            }
        }
    }
    
    func syncSave(model: Model.PortugueseZipCode) {
        aSyncSave(model: model)
            .sink { completion in
                if case .failure(let error) = completion {
                    DevTools.Log.error(error.localizedDescription, .repository)
                }
            } receiveValue: { _ in
                DevTools.Log.debug("Saved \(model.desigPostal) \(model.extCodPostal)", .repository)
            }
            .store(in: cancelBag)
    }
    
    func aSyncSave(model: Model.PortugueseZipCode) -> CDataFRPEntitySavePublisher {
        let action: FRPCDataStorePublisherAction = {
            let record: ZipCodeCoreDataEntety = Self.nonSecureInstanceAsync.createEntity()
            record.nomeLocalidade = model.nomeLocalidade
            record.numCodPostal   = model.numCodPostal
            record.extCodPostal   = model.extCodPostal
            record.desigPostal    = model.desigPostal
        }
        return Self.nonSecureInstanceAsync.publisher(save: action)
    }
}
