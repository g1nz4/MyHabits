import UIKit

class HabitDetailsViewController: UIViewController {
    
    weak var editDelegate: HabitCreateEditDelegate?
    
    fileprivate lazy var dates = {
        var dates = HabitsStore.shared.dates
        dates.reverse()
        
        return dates
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(
            frame: .zero,
            style: .plain
        )
        tableView.translatesAutoresizingMaskIntoConstraints = false
       
        return tableView
    }()
    
    private var habit: Habit?
    private var index: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .myHabitsLightGray
        setupNavigationBar()
        setupTableView()
        notificationOfDelete()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = habit!.name
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func notificationOfDelete() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(habitDeleted(_:)),
            name: .habitDeleted,
            object: nil
        )
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "arrow"),
            style: .plain,
            target: self,
            action: #selector(didTapLeftBarButton)
        )
        navigationItem.leftBarButtonItem?.tintColor = .myHabitsPurple
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Править",
            style: .plain,
            target: self,
            action: #selector(didTapRightBarButton)
        )
        navigationItem.rightBarButtonItem?.tintColor = .myHabitsPurple
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.backgroundColor = .myHabitsLightGray
        tableView.register(
            DetailsTableViewCell.self,
            forCellReuseIdentifier: DetailsTableViewCell.reuseIdentifier
        )
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 44.0
        
        let headerView = DetailsTableHeaderView()
        tableView.tableHeaderView = headerView
        tableView.estimatedSectionHeaderHeight = 20.0
        tableView.separatorColor = .clear
        
        let safeAreaGuide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor)
        ])
    }
    
    @objc private func didTapRightBarButton() {
            let habitEditViewController = HabitCreateEditViewController()
            habitEditViewController.delegate = editDelegate
            if let habit = habit, let index = index {
                habitEditViewController.didSelect(selectedHabit: habit, selectedIndex: index)
            }
            let navigationController = UINavigationController(rootViewController: habitEditViewController)
            navigationController.modalPresentationStyle = .fullScreen
            navigationController.navigationBar.prefersLargeTitles = false
            habitEditViewController.navigationItem.title = "Править"
            present(navigationController, animated: true)
    }
    
    @objc private func didTapLeftBarButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func habitDeleted(_ notification: Notification) {
        guard let info = notification.userInfo,
              let deletedIndex = info["index"] as? Int,
              let currentIndex = index else { return }
        if deletedIndex == currentIndex {
            navigationController?.popViewController(animated: true)
        }
    }
}

extension HabitDetailsViewController: UITableViewDataSource, UITableViewDelegate {
   
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        dates.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: DetailsTableViewCell.reuseIdentifier,
                    for: indexPath) as? DetailsTableViewCell else {
                        return UITableViewCell()
                    }
        let date = dates[indexPath.row]
        cell.setupCell(date: date, habit: habit!)
        
        return cell
    }
}

extension HabitDetailsViewController: HabitsViewControllerDelegate {
    
    func didSelect(
        selectedHabit: Habit,
        selectedIndex: Int
    ) {
        habit = selectedHabit
        index = selectedIndex
    }
}
