import Foundation

protocol Request {
    var baseURL: String { get }
    var endpoint: String { get }
    var params: [String: String]? { get }
    var headers: [String: String]? { get }
    var body: Data? { get }
    var method: HttpMethod { get }
}

protocol RequestTask {
    var request: Request { get }
    func resumeTask()
    func cancelTask()
}

extension Request {
    var baseURL: String { "https://viacep.com.br/" }
    
    var url: String {
        switch self.method {
        case .get:
            
            var component = URLComponents()
            let params = params ?? [:]
            var queryItems: [URLQueryItem] = []
            
            params.forEach { key, value in
                queryItems.append(
                    URLQueryItem(
                        name: key,
                        value: value.addingPercentEncoding(
                            withAllowedCharacters: .urlPathAllowed
                        )
                    ))
            }
            
            component.queryItems = queryItems
            return baseURL + endpoint + component.path
        }
    }
}
