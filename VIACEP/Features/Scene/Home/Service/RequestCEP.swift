import Foundation

enum RequestCEP: Request {
    case `default`(cep: String)
    
    var endpoint: String {
        switch self {
        case let .default(cep: cep):
            return "ws/\(cep)/json/"
        }
    }
    
    var method: HttpMethod {
        .get
    }
    
    var params: [String : String]? { nil }
    var headers: [String : String]? { nil }
    var body: Data? { nil }
}
