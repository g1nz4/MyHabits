import UIKit

protocol HabitsViewControllerDelegate: AnyObject {
    func didSelect(selectedHabit: Habit, selectedIndex: Int)
}

class HabitsViewController: UIViewController {
    
    weak var delegate: HabitsViewControllerDelegate?
    
    private lazy var habits: [Habit] = HabitsStore.shared.habits
    
    fileprivate enum Constants {
        static let leftSpacing: CGFloat = 16.0
        static let rightSpacing: CGFloat = 17.0
    }
    
    private lazy var habitsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 12.0
        layout.minimumInteritemSpacing = 16.0
        
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .myHabitsLightGray
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(
            ProgressCollectionViewCell.self,
            forCellWithReuseIdentifier: ProgressCollectionViewCell.reuseIdentifier
        )
        collectionView.register(
            HabitCollectionViewCell.self,
            forCellWithReuseIdentifier: HabitCollectionViewCell.reuseIdentifier
        )
      
        return collectionView
    }()
    
    private var selectedHabit: Habit?
    private var selectedIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        habitsCollectionView.reconfigureItems(at: habitsCollectionView.indexPathsForVisibleItems)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        habitsCollectionView.collectionViewLayout.invalidateLayout()
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
        navigationItem.largeTitleDisplayMode = .automatic
        navigationItem.title = "Сегодня"
    }
    
    private func setupCollectionView() {
        view.addSubview(habitsCollectionView)
    
        let safeAreaGuide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            habitsCollectionView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor),
            habitsCollectionView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor),
            habitsCollectionView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor),
            habitsCollectionView.widthAnchor.constraint(equalTo: safeAreaGuide.widthAnchor),
            habitsCollectionView.centerXAnchor.constraint(equalTo: safeAreaGuide.centerXAnchor),
            habitsCollectionView.centerYAnchor.constraint(equalTo: safeAreaGuide.centerYAnchor),
            habitsCollectionView.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor)
        ])
    }
 
    @objc private func didTapRightBarButton() {
        let habitCreateViewController = HabitCreateEditViewController()
        let navigationController = UINavigationController(rootViewController: habitCreateViewController)
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.navigationBar.prefersLargeTitles = false
        habitCreateViewController.navigationItem.title = "Создать"
        present(navigationController, animated: true)
    }
}

extension HabitsViewController: UICollectionViewDataSource {
   
    func numberOfSections(
        in collectionView: UICollectionView
    ) -> Int {
        2
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        if section == 0 {
            return 1
        }
        if section == 1 {
            return habits.count
        }
        
        return 0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ProgressCollectionViewCell.reuseIdentifier,
                for: indexPath) as! ProgressCollectionViewCell
          
            return cell
        }
        if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: HabitCollectionViewCell.reuseIdentifier,
                for: indexPath) as! HabitCollectionViewCell
            let habit = habits[indexPath.row]
            cell.setupCell(habit: habit)
            
            return cell
        }
        return UICollectionViewCell()
    }
}

extension HabitsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        if indexPath.section == 0 {
            let width = collectionView.bounds.width - (Constants.leftSpacing + Constants.rightSpacing)
            
            return CGSize(width: width, height: 60.0)
        }
        if indexPath.section == 1 {
            let width = collectionView.bounds.width - (Constants.leftSpacing + Constants.rightSpacing)
            
            return CGSize(width: width, height: 130.0)
        }
        return .zero
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        if section == 0 {
            let edgeInsetsProgress = UIEdgeInsets(
                top: 22.0,
                left: 16.0,
                bottom: 0.0,
                right: 17.0
            )
            return edgeInsetsProgress
        }
        if section == 1 {
            let edgeInsetsHabits = UIEdgeInsets(
                top: 18.0,
                left: 16.0,
                bottom: 16.0,
                right: 17.0
            )
            return edgeInsetsHabits
        }
        return .zero
    }
}

extension HabitsViewController: UICollectionViewDelegate {
   
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        if indexPath.section == 1 {
            selectedHabit = habits[indexPath.item]
            selectedIndex = indexPath.item
            let detailController = HabitDetailsViewController()
            detailController.didSelect(selectedHabit: selectedHabit!, selectedIndex: selectedIndex!)
            detailController.navigationItem.title = selectedHabit!.name
            detailController.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(detailController, animated: true)
        }
    }
}

    

