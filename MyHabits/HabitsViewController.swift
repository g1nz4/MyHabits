import UIKit

class HabitsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setupView()
        setupNavigationBar()
    }
    
    private func setupView() {
        view.backgroundColor = .tabBarToolbar
    }
    
    private func setupNavigationBar() {
        let symbol = UIBarButtonItem(
            image: UIImage(named: "symbol_plus"),
            style: .plain,
            target: self,
            action: #selector(didTappedOnRightBarButton)
        )
        symbol.tintColor = .myHabitsPurple
        navigationItem.rightBarButtonItem = symbol
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Сегодня"
    }
    
    @objc func didTappedOnRightBarButton() {
        
    }
}
 
