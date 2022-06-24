//
//  Created by Santos, Ricardo Patricio dos  on 05/12/2021.
//

import Foundation
//
import BaseDomain
import WebAPIDomain
import AppDomain

extension ModelDto.PortugueseZipCodeResponse {
    var mapToModel: Model.PortugueseZipCode {
        Model.PortugueseZipCode(nomeLocalidade: nomeLocalidade ?? "",
                                numCodPostal: numCodPostal ?? "",
                                extCodPostal: extCodPostal ?? "",
                                desigPostal: desigPostal ?? "",
                                id: "")
    }
}

extension Model.PortugueseZipCode {
    static func with(some: ModelDto.PortugueseZipCodeResponse) -> Model.PortugueseZipCode {
        some.mapToModel
    }
    
    var mapToDBModel: ZipCodeCoreDataEntety {
        let some = ZipCodeCoreDataEntety()
        some.nomeLocalidade = nomeLocalidade
        some.numCodPostal   = numCodPostal
        some.extCodPostal   = extCodPostal
        some.desigPostal    = desigPostal
        return some
    }
}

extension ZipCodeCoreDataEntety {
    var mapToModel: Model.PortugueseZipCode {
        Model.PortugueseZipCode(nomeLocalidade: nomeLocalidade ?? "",
                                numCodPostal: numCodPostal ?? "",
                                extCodPostal: extCodPostal ?? "",
                                desigPostal: desigPostal ?? "",
                                id: id?.description ?? "")
    }
}
