import Foundation

protocol ServicingCEPProtocol {
    func request(cep: String, completion: @escaping (Result<CEP, Error>) -> Void)
}

final class ServiceCEP: ServicingCEPProtocol {
    private let network: NetworkingProtocol
    private var task: RequestTask?
    
    init(network: NetworkingProtocol = Networking()) {
        self.network = network
    }
    
    func request(cep: String, completion: @escaping (Result<CEP, Error>) -> Void) {
        task = network.execute(request: RequestCEP.default(cep: cep), responseType: CEP.self, completion: { result in
            switch result {
            case let .success(cep):
                completion(.success(cep))
                dump(cep)
            case let .failure(err):
                completion(.failure(err))
            }
        })
        task?.resumeTask()
    }
}
