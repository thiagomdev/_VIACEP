import Foundation

protocol NetworkingProtocol {
    func execute<T: Codable>(request: Request, responseType: T.Type, completion: @escaping (Result<T, Error>) -> Void) -> RequestTask
}

final class Networking: NetworkingProtocol {
    func execute<T>(request: Request, responseType: T.Type, completion: @escaping (Result<T, Error>) -> Void) -> RequestTask where T : Codable {
        Tasking<T>(request: request, completion: completion)
    }
}
