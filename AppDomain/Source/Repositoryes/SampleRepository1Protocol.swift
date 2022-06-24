//
//  Created by Santos, Ricardo Patricio dos  on 29/06/2021.
//

import Foundation
import Combine
//
import BaseDomain
import Common

public typealias FetchZipCodesResponse = AnyPublisher<[Model.PortugueseZipCode], AppErrors>

public protocol SampleRepository1Protocol {
    func requesExistsAnyZipCode() -> AnyPublisher<Bool, AppErrors>
    func requestZipCodesCount() -> AnyPublisher<Int, AppErrors>
    func requestZipCodes(with filter: String) -> FetchZipCodesResponse
    func requestDeleteAllZipCodes()
    func requestSaveChunksCombined(models: [Model.PortugueseZipCode])
}
