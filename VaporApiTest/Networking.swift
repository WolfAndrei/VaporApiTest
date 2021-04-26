//
//  Networking.swift
//  VaporApiTest
//
//  Created by Andrei Volkau on 26.04.2021.
//

import Foundation


protocol Networking {
    func request(completion: @escaping (Data?, Error?) -> Void)
}
class NetworkService: Networking {
    
    func createURL() -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "http"
        urlComponents.host = "127.0.0.1"
        urlComponents.port = 8080
        urlComponents.path = "/api/acronyms/sorted"
        
        guard let url = urlComponents.url else { return nil }
        return url
    }
    
    func createDataTask(from urlRequest: URLRequest, completion: @escaping (Data?, Error?) -> Void) -> URLSessionTask {
         URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
            DispatchQueue.main.async {
                completion(data, error)
            }
        }
    }
    
    func request(completion: @escaping (Data?, Error?) -> Void) {
            guard let url = createURL() else { return }
            let request = URLRequest(url: url)
            let task = createDataTask(from: request, completion: completion)
            task.resume()
    }
}

protocol Parsing: class {
    func receiveError(err: Error)
    func receiveData(data: Any)
}


class NetworkParser {
    
    var networking: Networking
    weak var parseDelegate: Parsing?
    
    init(networking: Networking) {
        self.networking = networking
    }
    
    func parse() {
        networking.request { (data, error) in
            if let err = error {
                self.parseDelegate?.receiveError(err: err)
            } else if let data = data,
                      let JSONData = try? JSONSerialization.jsonObject(with: data, options: []) {
                self.parseDelegate?.receiveData(data: JSONData)
            }
        }
    }
}


enum DataError: Error {
    case corruptedData
}
