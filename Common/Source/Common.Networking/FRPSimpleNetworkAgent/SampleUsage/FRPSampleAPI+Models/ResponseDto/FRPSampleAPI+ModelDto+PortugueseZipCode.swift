//
//  Created by Ricardo P Santos on 2020.
//  2020 © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation

//typealias SampleResponse2Dto = FRPSampleAPI.ResponseDto.PortugueseZipCode

extension FRPSampleAPI.ResponseDto {

    struct PortugueseZipCode: Codable, Hashable {
        let codConcelho, codLocalidade, nomeLocalidade, codArteria: String?
        let codDistrito, tipoArteria: String?
        let prep1: String?
        let tituloArteria, prep2, nomeArteria, localArteria: String?
        let troco, porta, cliente: String?
        let numCodPostal: String?
        let extCodPostal, desigPostal: String?

        enum CodingKeys: String, CodingKey {
            case codDistrito = "cod_distrito"
            case codConcelho = "cod_concelho"
            case codLocalidade = "cod_localidade"
            case nomeLocalidade = "nome_localidade"
            case codArteria = "cod_arteria"
            case tipoArteria = "tipo_arteria"
            case prep1
            case tituloArteria = "titulo_arteria"
            case prep2
            case nomeArteria = "nome_arteria"
            case localArteria = "local_arteria"
            case troco, porta, cliente
            case numCodPostal = "num_cod_postal"
            case extCodPostal = "ext_cod_postal"
            case desigPostal = "desig_postal"
        }
    }
}
