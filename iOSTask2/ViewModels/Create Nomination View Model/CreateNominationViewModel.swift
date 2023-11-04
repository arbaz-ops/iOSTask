//
//  CreateNominationViewModel.swift
//  iOSTask2
//
//  Created by ARBAZ on 02/11/2023.
//

import Foundation

protocol CreateNominationService {
    func getNominees()
    func createNomination(nomineeID: String?, reason: String?,process: String?, completion: @escaping (Nomination) -> Void)
}
class CreateNominationViewModel: CreateNominationService {
   
    var nominees: [Nominees]?
    let networkManager: Managing
    init(networkManager: Managing) {
        self.networkManager = networkManager
        getNominees()
    }
    func getNominees() {
        networkManager.getNominees { result in
            switch result {
            case .success(let success):
                self.nominees = success.data
            case .failure(let failure):
                print(failure)
            }
        }
    }
    func createNomination(nomineeID: String?, reason: String?,process: String?, completion: @escaping (Nomination) -> Void) {
        networkManager.createNomination(nomineeID: nomineeID, reason: reason, process: process) { result in
            switch result {
            case .success(let success):
                print(success)
                completion(success.data)
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    
    
}
