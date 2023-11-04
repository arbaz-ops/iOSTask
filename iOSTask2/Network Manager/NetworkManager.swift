//
//  NetworkManager.swift
//  iOSTask2
//
//  Created by ARBAZ on 01/11/2023.
//

import Foundation

enum ErrorType: Error {
    case BadResponse(String, Error?)
    case invalidURLStatus(Int)
    case InternetUnavailability
}


protocol Managing {
    func getAllNominations(completion: @escaping (Result<NominationData, ErrorType>) -> Void)
    func getNominees(completion: @escaping(Result<NomineesData, ErrorType>) -> Void)
    func createNomination(nomineeID: String?, reason: String?,process: String?, completion: @escaping (Result<CreateNominationData, ErrorType>) -> Void)
    func deleteNomination(nominationID: String, completion: @escaping (Result<Bool,ErrorType>) -> Void)
}

class NetworkManager: Managing {
    
    
    private var urlSession = URLSession.shared
    
    func getAPIKey() -> String {
        guard let filePath = Bundle.main.path(forResource: "Keys", ofType: "plist") else {
              fatalError("Couldn't find file")
            }
        let plist = NSDictionary(contentsOfFile: filePath)
           guard let value = plist?.object(forKey: "API_KEY") as? String else {
             fatalError("Couldn't find key 'API_KEY'")
           }
        if (value.starts(with: "_")) {
              fatalError("")
            }
        return value
    }
    func getAllNominations(completion: @escaping (Result<NominationData, ErrorType>) -> Void) {
        let urlString = Endpoints.getAllNominations.rawValue
        
        let urlComponents = URLComponents(string: urlString)
       
        guard let url = URL(string: urlComponents?.url?.absoluteString ?? "") else { return }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        urlRequest.addValue(getAPIKey(), forHTTPHeaderField: "Authorization")
        print("GET URL: \(url)")
        
            urlSession.dataTask(with: urlRequest) { data, response, error in
                if let httpResponse = response as? HTTPURLResponse,
                   httpResponse.statusCode != 200 {
                    completion(.failure(.invalidURLStatus(httpResponse.statusCode)))
                    print("Status Code: \(httpResponse.statusCode)")
                }
                
                guard let dataToDecode = data, error == nil else {
                    completion(.failure(.BadResponse("Bad Response from server", error!)))
                    return
                }
                
                do {
                    let jsonData = try JSONDecoder().decode(NominationData.self,
                                                            from: dataToDecode)
                    completion(.success(jsonData))
                } catch let error {
                    completion(.failure(.BadResponse("Bad Response while decoding json", error)))
                }
                
            }.resume()
        
    }
    
    func getNominees(completion: @escaping(Result<NomineesData, ErrorType>) -> Void) {
        let urlString = Endpoints.getNominees.rawValue
        
        let urlComponents = URLComponents(string: urlString)
       
        guard let url = URL(string: urlComponents?.url?.absoluteString ?? "") else { return }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        urlRequest.addValue(getAPIKey(), forHTTPHeaderField: "Authorization")
        print("GET URL: \(url)")
        
            urlSession.dataTask(with: urlRequest) { data, response, error in
                if let httpResponse = response as? HTTPURLResponse,
                   httpResponse.statusCode != 200 {
                    completion(.failure(.invalidURLStatus(httpResponse.statusCode)))
                    print("Status Code: \(httpResponse.statusCode)")
                }
                
                guard let dataToDecode = data, error == nil else {
                    completion(.failure(.BadResponse("Bad Response from server", error!)))
                    return
                }
                
                do {
                    let jsonData = try JSONDecoder().decode(NomineesData.self,
                                                            from: dataToDecode)
                    completion(.success(jsonData))
                } catch let error {
                    completion(.failure(.BadResponse("Bad Response while decoding json", error)))
                }
                
            }.resume()
    }

    func createNomination(nomineeID: String?, reason: String?,process: String?, completion: @escaping (Result<CreateNominationData, ErrorType>) -> Void) {
        guard let url = URL(string: "https://cube-academy-api.cubeapis.com/api/nomination") else { return }
        
        
        
        let json: [String: Any] = ["nominee_id": "\(nomineeID ?? "")",
                                   "reason": "\(reason ?? "")",
                                   "process": "\(process ?? "")"]
        
        let data = json.percentEncoded()
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue(getAPIKey(), forHTTPHeaderField: "Authorization")
        if let data = data {
            urlRequest.httpBody = data
            print("POST URL DATA: \(String(data: data, encoding: .utf8) ?? "")")
        }
        
        print("POST URL Request Send: \(url)")
        
        urlSession.dataTask(with: urlRequest) { data, response, error in
           
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 201 {
                    guard let data = data else {
                        return
                    }
                    
                    let dataString = String(data: data, encoding: .utf8) ?? ""

                    completion(.failure(.BadResponse(dataString, error)))
                    
                    print("Status Code: \(httpResponse.statusCode)")
                } else {
                    guard let dataToDecode = data, error == nil else {
                        completion(.failure(.BadResponse("Bad Response from server", error!)))
                        return
                    }
                    do {
                        let jsonData = try JSONDecoder().decode(CreateNominationData.self,
                                                                from: dataToDecode)
                        completion(.success(jsonData))
                    }
                    catch let error {
                        completion(.failure(.BadResponse("Bad Response while decoding json", error)))
                    }
                }
            }
            
           
            
        }.resume()
    }
    
    func deleteNomination(nominationID: String, completion: @escaping (Result<Bool,ErrorType>) -> Void) {
        let urlString = Endpoints.deleteNomination.rawValue + "\(nominationID)"
        
        let urlComponents = URLComponents(string: urlString)
       
        guard let url = URL(string: urlComponents?.url?.absoluteString ?? "") else { return }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "DELETE"
        
        urlRequest.addValue(getAPIKey(), forHTTPHeaderField: "Authorization")
        print("GET URL: \(url)")
        
            urlSession.dataTask(with: urlRequest) { data, response, error in
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode != 200 {
                        guard let data = data else {
                            return
                        }
                        let dataString = String(data: data, encoding: .utf8) ?? ""

                        completion(.failure(.BadResponse(dataString, error)))
                
                        print("Status Code: \(httpResponse.statusCode)")
                    } else {
                        completion(.success(true))
                    }
                }
                
                guard let _ = data, error == nil else {
                    completion(.failure(.BadResponse("Bad Response from server", error!)))
                    return
                }
            }.resume()
    }

}
