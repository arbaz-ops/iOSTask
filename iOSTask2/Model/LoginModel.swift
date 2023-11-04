//
//  LoginModel.swift
//  iOSTask2
//
//  Created by ARBAZ on 04/11/2023.
//

import Foundation


struct LoginModel: Codable {
    var data: Auth
}

struct Auth: Codable {
    var authToken: String?
}
