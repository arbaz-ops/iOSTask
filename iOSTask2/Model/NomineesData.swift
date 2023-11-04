//
//  NomineesData.swift
//  iOSTask2
//
//  Created by ARBAZ on 02/11/2023.
//

import Foundation

struct NomineesData:Codable {
    var data: [Nominees]
}

struct Nominees: Codable {
    var nominee_id: String?
    var first_name: String?
    var last_name: String?
}
