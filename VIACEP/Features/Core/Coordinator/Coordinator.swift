import UIKit

protocol Coortinating {
    var navigation: UINavigationController { get }
    init(navigation: UINavigationController)
}

enum HomeAction {
    case home
}

protocol MainCoordinating: Coortinating {
    func perform(_ action: HomeAction)
}

final class Coordinator: MainCoordinating {
    var navigation: UINavigationController
    
    init(navigation: UINavigationController) {
        self.navigation = navigation
    }
    
    func perform(_ action: HomeAction) {
        switch action {
        case .home:
            let home = HomeViewController(viewModel: .init())
            navigation.pushViewController(home, animated: true)
        }
    }
}
