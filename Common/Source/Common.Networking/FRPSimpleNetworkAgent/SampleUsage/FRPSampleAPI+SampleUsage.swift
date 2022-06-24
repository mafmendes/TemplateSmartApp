//
//  Created by Ricardo P Santos on 2020.
//  2020 © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import Combine
//
private var cancelBag = CancelBag()

// swiftlint:disable multiple_closures_with_trailing_closure logs_rule_1

public extension NetworkinNameSpace {

    static func frpSampleAPIUseCase() {
        
        let api: FRPSampleAPIRequestProtocol = FRPSampleAPI()

        let request1Dto = FRPSampleAPI.RequestDto.Employee(someParam: "aaa")
        let request2Dto = FRPSampleAPI.RequestDto.PortugueseZipCode(someParam: "aaa")
        let request2AssyncDto = FRPSampleAPI.RequestDto.Employee(someParam: "aaa")

        // Combine with CSV result
        api.sampleRequestCVS(request2Dto).sink { (_) in } receiveValue: { (response) in
            Common_Logs.debug(response.prefix(3))
        }.store(in: cancelBag)

        // Combine with JSON result
        api.sampleRequestJSON(request1Dto).sink { (_) in } receiveValue: { (response) in
            Common_Logs.debug(response.data.prefix(3))
        }.store(in: cancelBag)
        
        // Task + wayt with CSV result
        if #available(iOS 15.0, *) {
            Task(priority: .background) {
                do {
                    let response = try await api.sampleRequestCVSAssync(request2AssyncDto)
                    Common_Logs.debug("\(response)")
                } catch {
                    Common_Logs.error(error)
                }
            }
        }
    }
}
