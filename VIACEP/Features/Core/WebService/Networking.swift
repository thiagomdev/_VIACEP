import Foundation

protocol NetworkingProtocol {
    func execute<T: Decodable>(request: Request, responseType: T.Type, completion: @escaping (Result<T, Error>) -> Void) -> RequestTask
}

final class Networking: NetworkingProtocol {
    func execute<T>(request: Request, responseType: T.Type, completion: @escaping (Result<T, Error>) -> Void) -> RequestTask where T : Decodable {
        Tasking<T>(request: request, completion: completion)
    }
}
