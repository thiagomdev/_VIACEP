import UIKit

protocol HomeViewControllerDisplaying {
    func fetchedCEP(_ cep: String)
}

final class HomeViewController: UIViewController {
    // MARK: - Properties
    private let viewModel: CEPViewModel
    
    // MARK: - Elements
    private lazy var inputedCepTextField: UITextField = {
        let element = UITextField()
        element.placeholder = "CEP"
        element.borderStyle = .roundedRect
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var searchCepButton: UIButton = {
        let element = UIButton(type: .system)
        element.setTitle("search cep", for: .normal)
        element.addTarget(self, action: #selector(searchCep), for: .touchUpInside)
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var bairroLabel = makeLabel()
    private lazy var logradouroLabel = makeLabel()
    private lazy var localidadeLabel = makeLabel()
    private lazy var ufLabel = makeLabel()
    private lazy var ibgeLabel = makeLabel()
    private lazy var giaLabel = makeLabel()
    private lazy var dddLabel = makeLabel()
    private lazy var siafiLabel = makeLabel()

    // MARK: - Initializers
    init(viewModel: CEPViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        buildViews()
        pin()
        configureUI()
        showCepError()
    }
    
    // MARK: - Selectors
    @objc
    private func searchCep() {
        guard let cep = inputedCepTextField.text else { return }
        fetchedCEP(cep)
        viewModel.errorInvalid(cep)
    }
    
    private func showCepError() {
        viewModel.invalidCepAlert = { [weak self] in
            let alert = UIAlertController(title: "ALERTA!", message: "CEP inválido. Por favor,\ncoloque um CEP válido.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(alert, animated: true)
        }
    }
}
// MARK: - HomeViewControllerDisplaying
extension HomeViewController: HomeViewControllerDisplaying {
    func fetchedCEP(_ cep: String) {
        viewModel.fetchCEP(cep) { [weak self] _ in
            DispatchQueue.main.async {
                self?.bairroLabel.text = self?.viewModel.bairro
                self?.localidadeLabel.text = self?.viewModel.localidade
                self?.logradouroLabel.text = self?.viewModel.logradouro
                
                self?.ufLabel.text = self?.viewModel.uf
                self?.ibgeLabel.text = self?.viewModel.ibge
                self?.giaLabel.text = self?.viewModel.gia
                
                self?.dddLabel.text = self?.viewModel.ddd
                self?.siafiLabel.text = self?.viewModel.siafi
            }
        }
        inputedCepTextField.text = viewModel.clearField
    }
}

// MARK: - Layout Configuration
extension HomeViewController {
    func buildViews() {
        view.add(
            subviews: inputedCepTextField,
            searchCepButton,
            bairroLabel,
            logradouroLabel,
            localidadeLabel,
            ufLabel,
            ibgeLabel,
            giaLabel,
            dddLabel,
            siafiLabel
        )
    }
    
    func pin() {
        NSLayoutConstraint.activate([
            inputedCepTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            inputedCepTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            inputedCepTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            inputedCepTextField.heightAnchor.constraint(equalToConstant: 48),
            
            searchCepButton.topAnchor.constraint(equalTo: inputedCepTextField.bottomAnchor, constant: 16),
            searchCepButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            searchCepButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            bairroLabel.topAnchor.constraint(equalTo: searchCepButton.bottomAnchor, constant: 16),
            bairroLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            logradouroLabel.topAnchor.constraint(equalTo: bairroLabel.bottomAnchor, constant: 4),
            logradouroLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            
            localidadeLabel.topAnchor.constraint(equalTo: logradouroLabel.bottomAnchor, constant: 4),
            localidadeLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            ufLabel.topAnchor.constraint(equalTo: localidadeLabel.bottomAnchor, constant: 4),
            ufLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            ibgeLabel.topAnchor.constraint(equalTo: ufLabel.bottomAnchor, constant: 4),
            ibgeLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            giaLabel.topAnchor.constraint(equalTo: ibgeLabel.bottomAnchor, constant: 4),
            giaLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            dddLabel.topAnchor.constraint(equalTo: giaLabel.bottomAnchor, constant: 4),
            dddLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            siafiLabel.topAnchor.constraint(equalTo: dddLabel.bottomAnchor, constant: 4),
            siafiLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
        ])
    }
    
    func configureUI() {
        view.backgroundColor = .systemBackground
    }
}

// MARK: - Create Label Element
extension HomeViewController {
    private func makeLabel() -> UILabel {
        let element = UILabel()
        element.font = .systemFont(ofSize: 14, weight: .regular)
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }
}
