import UIKit

protocol HabitsViewControllerDelegate: AnyObject {
    func didSelect(selectedHabit: Habit, selectedIndex: Int)
}

class HabitsViewController: UIViewController {
    
    weak var delegate: HabitsViewControllerDelegate?
    
    private var habits: [Habit] {
        HabitsStore.shared.habits
    }
    
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
    private func updateProgressCell() {
        let progressIndex = IndexPath(item: 0, section: 0)
        if habitsCollectionView.indexPathsForVisibleItems.contains(progressIndex) {
            habitsCollectionView.reloadItems(at: [progressIndex])
        }
    }
    
    private func deleteHabit(at index: Int) {
        guard index >= 0, index < HabitsStore.shared.habits.count else { return }

        HabitsStore.shared.habits.remove(at: index)

        let deleteIndex = IndexPath(item: index, section: 1)
        habitsCollectionView.performBatchUpdates({
            habitsCollectionView.deleteItems(at: [deleteIndex])
        }, completion: { _ in
            self.updateProgressCell()
        })
    }
 
    @objc private func didTapRightBarButton() {
        let habitCreateViewController = HabitCreateEditViewController()
        habitCreateViewController.delegate = self
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
                for: indexPath
            ) as! ProgressCollectionViewCell
            let progress = HabitsStore.shared.todayProgress
            cell.percentageOfProgress(value: progress)
            
            return cell
            
        } else {
            
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: HabitCollectionViewCell.reuseIdentifier,
                for: indexPath
            ) as! HabitCollectionViewCell
            guard indexPath.row < habits.count else {
                return cell
            }
            let habit = habits[indexPath.row]
            cell.setupCell(habit: habit)
            
            return cell
        }
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
            self.selectedHabit = habits[indexPath.item]
            self.selectedIndex = indexPath.item
            let detailController = HabitDetailsViewController()
            detailController.didSelect(selectedHabit: selectedHabit!, selectedIndex: selectedIndex!)
            detailController.navigationItem.title = selectedHabit!.name
            detailController.editDelegate = self
            detailController.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(detailController, animated: true)
        }
    }
}
extension HabitsViewController: HabitCreateEditDelegate {
    
    func didDelete(deleteIndex: Int) {
        deleteHabit(at: deleteIndex)
    }
    
    func didCreate(newhabit: Habit) {
        let newHabitIndex = HabitsStore.shared.habits.count - 1
        let indexPath = IndexPath(item: newHabitIndex, section: 1)
        habitsCollectionView.insertItems(at: [indexPath])
        updateProgressCell()
    }
    
    func didUpdateHabit(index: Int) {
       let habitUpdateIndex = IndexPath(item: index, section: 1)
       if habitsCollectionView.indexPathsForVisibleItems.contains(habitUpdateIndex) {
           habitsCollectionView.reloadItems(at: [habitUpdateIndex])
       }
        updateProgressCell()
   }
}
