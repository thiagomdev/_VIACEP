import XCTest
@testable import VIACEP

final class CEPViewModelTests: XCTestCase {
    typealias Sut = CEPViewModel
    
    func test_FetchCEP_WhenButtonWasPressed_ShouldReturnValidCEP() {
        let (sut, serviceSpy) = makeSut()
        let expected: CEP = .init(
            cep: "09431-300",
            logradouro: "Rua Irapurú",
            complemento: "",
            bairro: "Santa Luzia",
            localidade: "Ribeirão Pires",
            ibge: "3543303",
            gia: "5812",
            ddd: "11",
            siafi: "6967"
        )
                
        serviceSpy.result = .success(expected)
        
        sut.fetchCEP(expected.cep ?? String()) { _ in
            XCTAssertTrue(serviceSpy.wasCalled)
            XCTAssertEqual(serviceSpy.calledCounter, 1)
            XCTAssertEqual(serviceSpy.cep, expected.cep)
        }
    }
    
    func test_() {
        let (sut, serviceSpy) = makeSut()

        let err: Error = NSError()

        let expected: CEP = .init(
            cep: "09431-300",
            logradouro: "Rua Irapurú",
            complemento: "",
            bairro: "Santa Luzia",
            localidade: "Ribeirão Pires",
            ibge: "3543303",
            gia: "5812",
            ddd: "11",
            siafi: "6967"
        )
        
        serviceSpy.result = .failure(err)
        
        sut.fetchCEP(expected.cep ?? String()) { _ in
            XCTAssertTrue(serviceSpy.wasCalled)
            XCTAssertEqual(serviceSpy.calledCounter, 1)
            XCTAssertEqual(serviceSpy.cep, expected.cep)
        }
    }
    
    private func makeSut() -> (sut: CEPViewModel, spy: MockService) {
        let serviceSpy = MockService()
        let sut = CEPViewModel(service: serviceSpy)
        return (sut, serviceSpy)
    }
}

final class MockService: ServicingCEPProtocol {
    var result: (Result<CEP, Error>) = .init { .init(cep: String()) }
    
    private(set) var cep: String?
    private(set) var model: CEP?
    private(set) var wasCalled: Bool = false
    private(set) var calledCounter: Int = 0

    func request(cep: String, completion: @escaping (Result<VIACEP.CEP, Error>) -> Void) {
        wasCalled = true
        calledCounter += 1
        self.cep = cep
        completion(result)
    }
}
