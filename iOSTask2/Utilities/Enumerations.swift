//
//  Enumerations.swift
//  iOSTask2
//
//  Created by ARBAZ on 31/10/2023.
//

import Foundation

enum ViewControllers: String {
    case CustomNavigationController
    case HomeViewController
    case CreateNominationViewController
    case AreYouSureViewController
    case NominationSubmittedViewController
}

enum Storyboards: String {
    case Main
}

enum TableViewCellIdentifier: String {
    case NomineeTableViewCell
}


enum Endpoints: String {
    case login = "https://cube-academy-api.cubeapis.com/api/login"
    case getAllNominations = "https://cube-academy-api.cubeapis.com/api/nomination"
    case getNominees = "https://cube-academy-api.cubeapis.com/api/nominee"
    case deleteNomination = "https://cube-academy-api.cubeapis.com/api/nomination/"
}
