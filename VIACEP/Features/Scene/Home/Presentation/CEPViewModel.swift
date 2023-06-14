import Foundation

protocol CepViewModeling {
    func errorInvalidCep(_ invalidCep: String, callback: @escaping (Result<CEP, Error>) -> Void)
    func fetchCEP(_ cep: String, completion: @escaping (Result<CEP, Error>) -> Void)
}

final class CEPViewModel {
    private var cep: CEP
    private let service: ServicingCEPProtocol
    var showAlert: ((String) -> Void)?
    
    init(cep: CEP = .init(),
         service: ServicingCEPProtocol = ServiceCEP()) {
        self.cep = cep
        self.service = service
    }
    
    func errorInvalidCep(_ invalidCep: String, callback: @escaping (Result<CEP, Error>) -> Void) {
        if cep.cep == nil {
            callback(.success(cep))
        }
    }
}

extension CEPViewModel: CepViewModeling {
    func fetchCEP(_ cep: String, completion: @escaping (Result<CEP, Error>) -> Void) {
        service.request(cep: cep) { [weak self] result in
            switch result {
            case let .success(cep):
                self?.cep = cep
                completion(.success(cep))
            case let .failure(err):
                completion(.failure(err))
            }
        }
    }
}

extension CEPViewModel {
    var uf: String {
        "UF: \(cep.uf ?? "")"
    }
    
    var ibge: String {
        "Ibge: \(cep.ibge ?? "")"
    }
    
    var gia: String {
        "Gia: \(cep.gia ?? "")"
    }
    
    var ddd: String {
        "DDD: \(cep.ddd ?? "")"
    }
    
    var siafi: String {
        "Siafi: \(cep.siafi ?? "")"
    }
    
    var clearField: String? {
        nil
    }
    
    var logradouro: String {
        "Logradouro: \(cep.logradouro?.uppercased() ?? "")"
    }
    
    var localidade: String {
        "Localidade: \(cep.localidade?.uppercased() ?? "")"
    }
    
    var bairro: String {
        "Bairro: \(cep.bairro?.uppercased() ?? "")"
    }
    
    var complemento: String {
        "Complemento: \(cep.complemento ?? "")"
    }
}
