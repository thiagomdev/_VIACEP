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
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
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
    }
    
    // MARK: - Selectors
    @objc
    private func searchCep() {
        guard let cep = inputedCepTextField.text else { return }
        fetchedCEP(cep)
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
        stackView.addStacks(
            bairroLabel,
            logradouroLabel,
            localidadeLabel,
            ufLabel,
            ibgeLabel,
            giaLabel,
            dddLabel,
            siafiLabel
        )
        
        view.add(
            subviews:
            inputedCepTextField,
            searchCepButton,
            stackView
        )
    }
    
    func pin() {
        NSLayoutConstraint.activate([
            inputedCepTextField.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),
            
            inputedCepTextField.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: Layout.Padding.genericPadding
            ),
            
            inputedCepTextField.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -Layout.Padding.genericPadding
            ),
            
            inputedCepTextField.heightAnchor.constraint(
                equalToConstant: Layout.Padding.genericHeight
            ),
            
            searchCepButton.topAnchor.constraint(
                equalTo: inputedCepTextField.bottomAnchor,
                constant: Layout.Padding.genericPadding
            ),
            
            searchCepButton.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: Layout.Padding.genericPadding
            ),
            
            searchCepButton.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -Layout.Padding.genericPadding
            ),
            
            stackView.topAnchor.constraint(
                equalTo: searchCepButton.bottomAnchor,
                constant: Layout.Padding.genericPadding
            ),
            
            stackView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: Layout.Padding.genericPadding
            ),
            
            stackView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -Layout.Padding.genericPadding
            ),
        ])
    }
    
    func configureUI() {
        view.backgroundColor = .systemBackground
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

extension HomeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        shouldReturn(textField)
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        guard let text = textField.text else { return false }
        return !text.isEmpty
    }
}

// MARK: - Create Label Element
extension HomeViewController {
    private func makeLabel() -> UILabel {
        let element = UILabel()
        element.font = .systemFont(ofSize: 16, weight: .regular)
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
