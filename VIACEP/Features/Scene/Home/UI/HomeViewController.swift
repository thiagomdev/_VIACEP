import UIKit

protocol HomeViewControllerDisplaying {
    func fetchedCEP(_ cep: String)
}

final class HomeViewController: UIViewController {
    fileprivate enum Layout { }
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
            inputedCepTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Layout.Padding.genericPadding),
            inputedCepTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Layout.Padding.genericPadding),
            inputedCepTextField.heightAnchor.constraint(equalToConstant: Layout.Padding.genericHeight),
            
            searchCepButton.topAnchor.constraint(equalTo: inputedCepTextField.bottomAnchor, constant: Layout.Padding.genericPadding),
            searchCepButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Layout.Padding.genericPadding),
            searchCepButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Layout.Padding.genericPadding),
            
            bairroLabel.topAnchor.constraint(equalTo: searchCepButton.bottomAnchor, constant: Layout.Padding.genericPadding),
            bairroLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Layout.Padding.genericPadding),
            
            logradouroLabel.topAnchor.constraint(equalTo: bairroLabel.bottomAnchor, constant: Layout.Padding.genericValue),
            logradouroLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Layout.Padding.genericPadding),
            
            localidadeLabel.topAnchor.constraint(equalTo: logradouroLabel.bottomAnchor, constant: Layout.Padding.genericValue),
            localidadeLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Layout.Padding.genericPadding),
            
            ufLabel.topAnchor.constraint(equalTo: localidadeLabel.bottomAnchor, constant: Layout.Padding.genericValue),
            ufLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Layout.Padding.genericPadding),
            
            ibgeLabel.topAnchor.constraint(equalTo: ufLabel.bottomAnchor, constant: Layout.Padding.genericValue),
            ibgeLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Layout.Padding.genericPadding),
            
            giaLabel.topAnchor.constraint(equalTo: ibgeLabel.bottomAnchor, constant: Layout.Padding.genericValue),
            giaLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Layout.Padding.genericPadding),
            
            dddLabel.topAnchor.constraint(equalTo: giaLabel.bottomAnchor, constant: Layout.Padding.genericValue),
            dddLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Layout.Padding.genericPadding),
            
            siafiLabel.topAnchor.constraint(equalTo: dddLabel.bottomAnchor, constant: Layout.Padding.genericValue),
            siafiLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Layout.Padding.genericPadding),
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

private extension HomeViewController.Layout {
    enum Padding {
        static let genericPadding: CGFloat = 16
        static let genericValue: CGFloat = 4
        static let genericHeight: CGFloat = 48
    }
}
