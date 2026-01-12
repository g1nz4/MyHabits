import UIKit

class HabitsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .tabBarToolbar
        
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    private func setupNavigationBar() {
        let symbol = UIBarButtonItem(
            image: UIImage(named: "symbol_plus"),
            style: .plain,
            target: self,
            action: #selector(didTapRightBarButton)
        )
        symbol.tintColor = .myHabitsPurple
        navigationItem.rightBarButtonItem = symbol
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Сегодня"
    }
 
    @objc private func didTapRightBarButton() {
        let habitCreateController = HabitCreateEditViewController()
        habitCreateController.navigationItem.title = "Создать"
        habitCreateController.navigationItem.largeTitleDisplayMode = .never
        let navigationController = UINavigationController(rootViewController: habitCreateController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
}
