//
//  Created by Santos, Ricardo Patricio dos  on 05/12/2021.
//

import Foundation
//
import BaseDomain

public extension ModelDto {

    /// `ModelDto.PortugueseZipCodeResponse` and `Model.PortugueseZipCode` are related
    /// `ModelDto` is to be used to map _foreingn enteties_ and `Model` is used by the app (views)
    /// `ModelDto` usually ends with _Response_ keyoword
    struct PortugueseZipCodeResponse: ModelDtoProtocol {
        public let nomeLocalidade: String?
        public let numCodPostal: String?
        public let extCodPostal: String?
        public let desigPostal: String?
        
        public init(nomeLocalidade: String,
                    numCodPostal: String,
                    extCodPostal: String,
                    desigPostal: String) {
            self.nomeLocalidade = nomeLocalidade
            self.numCodPostal = numCodPostal
            self.extCodPostal = extCodPostal
            self.desigPostal = desigPostal
        }
        
        enum CodingKeys: String, CodingKey {
            case nomeLocalidade = "nome_localidade"
            case numCodPostal = "num_cod_postal"
            case extCodPostal = "ext_cod_postal"
            case desigPostal = "desig_postal"
        }
    }
}
