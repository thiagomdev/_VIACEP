import UIKit

protocol HomeViewControllerDisplaying {
    func fetchedCEP(_ cep: String)
    func displayInvalid( _ cep: String)
}

final class HomeViewController: UIViewController {
    fileprivate enum Layout { }
    // MARK: - Properties
    private let viewModel: CEPViewModel
    private let defaults = UserDefaults.standard
    
    // MARK: - Components
    private lazy var containerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var inputedCepTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "CEP"
        textField.borderStyle = .roundedRect
        textField.delegate = self
        textField.returnKeyType = .done
        textField.clearButtonMode = .whileEditing
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private lazy var searchCepButton: UIButton = {
        let element = UIButton(type: .system)
        element.setTitle("search cep", for: .normal)
        element.addTarget(self, action: #selector(searchCep), for: .touchUpInside)
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var bairroLabel = makeLabel()
    private lazy var logradouroLabel = makeLabel(font: .boldSystemFont(ofSize: 16))
    private lazy var localidadeLabel = makeLabel(font: .boldSystemFont(ofSize: 16))
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
    }
    
    private func hideComponentsOnInvalidCEP() {
        bairroLabel.isHidden = true
        logradouroLabel.isHidden = true
        localidadeLabel.isHidden = true
        ufLabel.isHidden = true
        ibgeLabel.isHidden = true
        giaLabel.isHidden = true
        dddLabel.isHidden = true
        siafiLabel.isHidden = true
    }
    
    private func showComponentsOnValidCEP() {
        bairroLabel.isHidden = false
        logradouroLabel.isHidden = false
        localidadeLabel.isHidden = false
        ufLabel.isHidden = false
        ibgeLabel.isHidden = false
        giaLabel.isHidden = false
        dddLabel.isHidden = false
        siafiLabel.isHidden = false
    }
    
    // MARK: - Selectors
    @objc
    private func searchCep() {
        guard let cep = inputedCepTextField.text else { return }
        viewModel.displayNotifications(cep: cep)
        fetchedCEP(cep)
    }
}
// MARK: - HomeViewControllerDisplaying
extension HomeViewController: HomeViewControllerDisplaying {
    func fetchedCEP(_ cep: String) {
        viewModel.fetchCEP(cep) { [weak self] _ in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.bairroLabel.text = self.viewModel.bairro
                self.localidadeLabel.text = self.viewModel.localidade
                self.logradouroLabel.text = self.viewModel.logradouro
                
                self.ufLabel.text = self.viewModel.uf
                self.ibgeLabel.text = self.viewModel.ibge
                self.giaLabel.text = self.viewModel.gia
                
                self.dddLabel.text = self.viewModel.ddd
                self.siafiLabel.text = self.viewModel.siafi
            }
        }
        inputedCepTextField.text = viewModel.clearField
    }
    
    func displayInvalid(_ cep: String) {
        viewModel.invalid(cep: cep) { value in
            let alert = UIAlertController(title: "ALERTA!", message: "O CEP \(value) não existe.\nFavor tentar um CEP válido.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.hideComponentsOnInvalidCEP()
            self.present(alert, animated: true)
        }
    }
}

// MARK: - Layout Configuration
extension HomeViewController {
    func buildViews() {
        containerStackView.addStacks(
            inputedCepTextField,
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
        view.add(subviews: containerStackView)
    }
    
    func pin() {
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: Layout.Padding.genericPadding
            ),
            
            containerStackView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: Layout.Padding.genericPadding
            ),
            
            containerStackView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -Layout.Padding.genericPadding
            )
        ])
    }
    
    func configureUI() {
        view.backgroundColor = .systemBackground
    }
}

extension HomeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        shouldReturn(textField)
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        guard let text = textField.text else { return false }
        return !text.isEmpty
    }
}

// MARK: - HomeViewController Extensions
extension HomeViewController {
    private func makeLabel(font: UIFont = .systemFont(ofSize: 16)) -> UILabel {
        let label = UILabel()
        label.font = font
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func shouldReturn(_ textField: UITextField) -> Bool {
        if textField.returnKeyType == .done {
            guard let cep = textField.text else { return false }
            view.endEditing(textField.text != nil)
            fetchedCEP(cep)
        }
        return textField == inputedCepTextField
    }
}

private extension HomeViewController.Layout {
    enum Padding {
        static let genericPadding: CGFloat = 16
        static let genericValue: CGFloat = 4
        static let genericHeight: CGFloat = 40
    }
}
