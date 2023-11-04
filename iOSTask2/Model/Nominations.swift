//
//  Nominations.swift
//  iOSTask2
//
//  Created by ARBAZ on 01/11/2023.
//

import Foundation

struct NominationData:Codable {
    var data: [Nomination]
}

struct Nomination: Codable {
    var nomination_id: String?
    var nominee_id: String
    var reason: String
    var process: String
    var date_submitted: String
    var closing_date: String
    
}

