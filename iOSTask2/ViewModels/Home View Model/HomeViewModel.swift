//
//  HomeViewModel.swift
//  iOSTask2
//
//  Created by ARBAZ on 01/11/2023.
//

import Foundation

protocol HomeService {
    func getAllNominations(completion: @escaping () -> Void)
    func deleteNomination(nominationID: String, completion: @escaping (Bool) -> Void)

}

class HomeViewModel: HomeService {
  
    
    let networkManager: Managing
    var nominations = [Nomination]()
    init(networkManager: Managing) {
        self.networkManager = networkManager
       
    }
    func getAllNominations(completion: @escaping () -> Void) {
        networkManager.getAllNominations { result in
            switch result {
            case .success(let data):
                self.nominations = data.data
                print(self.nominations)
                completion()
            case .failure(let failure):
                print(failure)
            }
        }
    }
    func appendData(nomination: Nomination) {
        self.nominations.append(nomination)
    }
    
    func deleteNomination(nominationID: String, completion: @escaping (Bool) -> Void)
    {
        self.networkManager.deleteNomination(nominationID: nominationID) { result in
            switch result {
            case .success(let success):
                if success {
                   completion(true)
                }
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    
}
