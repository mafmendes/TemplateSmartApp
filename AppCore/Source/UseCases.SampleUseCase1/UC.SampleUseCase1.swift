//
//  Created by Ricardo Santos on 28/02/2021.
//

import Foundation
import Combine
import CoreData
import UIKit
//
import Common
import WebAPIDomain
import BaseDomain
import AppDomain
import DevTools
import AppConstants

#warning("Tutorial: UC.xxxxxUseCaseProtocol - Use Case(s) Protocol implementation")

public class SampleUseCase1: SampleUseCase1Protocol {

    public init() { }
    
    public var sampleRepository1: SampleRepository1Protocol! // Repository
    public var networkManager: WebAPIZipCodesProtocol!       // Repository
    
    #warning("Tutorial : UseCases can emit events to trigger navigation or scenes data information reload")
    public static var output = CommonNameSpace.GenericObservableObjectForHashable<SampleUseCase1ProtocolOutput>()

    internal let cancelBag = CancelBag()

    //
    // MARK: - Dummy
    //
    
    public func requestLoginWith(user: String, password: String) -> ResponseLoginWith {
        let useMockData = false
        if !useMockData {
            // Insert real implementation code like calling some api and so on
            var model = Model.Login()
            model.sucess = user == "123" && password == "123"
            if model.sucess {
                // Emit that user logged in, so that navigation on C.AppMainCoordinator.swift can be trigged
                DevTools.Log.debug("User did login. Trigger some navigation - Parte 1", .generic)
                SampleUseCase1.output.value.send(.userDidLogin(user: user))
            }
            return Just(model)
                .setFailureType(to: AppErrors.self)
                .eraseToAnyPublisher()
                .delay(seconds: AppConstantsNameSpace.TimeIntervals.defaultDelayMocks)
        } else {
            return SampleUseCase1Mock().requestLoginWith(user: user, password: password)
        }
    }
    
    public func requestZipCodesWhereStored() -> ResponseZipCodesWhereStored {
        self.sampleRepository1.requesExistsAnyZipCode()
    }
    
    public func requestZipCodes(filter: String) -> ResponseZipCodes {
        let useMockData = false
        if !useMockData {
            let dto = ModelDto.PortugueseZipCodeRequest(path: "codigos_postais.csv")
            let csvZipCodesIntoModel = CoreProtocolsResolved.networkManager.requestZipCodes(dto)
                .mapError { error in error.toAppError }
                .flatMap { (list) -> ResponseZipCodes in
                    let mapped = list.compactMap { $0.mapToModel }
                    return Just(mapped)
                        .setFailureType(to: AppErrors.self)
                        .eraseToAnyPublisher()
                }
            
            let existsAny = self.sampleRepository1.requesExistsAnyZipCode()
            return existsAny.flatMap { existsAnyZipCode -> ResponseZipCodes in
                if existsAnyZipCode {
                    // If we have records stored, return stored records
                    return self.sampleRepository1.requestZipCodes(with: filter)
                } else {
                    // Fetch the records
                    return csvZipCodesIntoModel.flatMap { records -> ResponseZipCodes in
                        // Store the records
                        self.sampleRepository1.requestSaveChunksCombined(models: records)
                        return csvZipCodesIntoModel.eraseToAnyPublisher()
                    }.eraseToAnyPublisher()
                }
            }.eraseToAnyPublisher()
        } else {
            return SampleUseCase1Mock().requestZipCodes(filter: filter)
        }
    }
        
}

extension Publisher {
  func genericError() -> AnyPublisher<Self.Output, Error> {
    return self
      .mapError({ (error: Self.Failure) -> Error in
        return error
      }).eraseToAnyPublisher()
  }
}
