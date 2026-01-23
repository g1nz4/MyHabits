import UIKit

class HabitCreateEditViewController: UIViewController{
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = true
        scrollView.isScrollEnabled = true
        
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "НАЗВАНИЕ"
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.font = UIFont.systemFont(ofSize: 13.0, weight: .semibold)
        
        return label
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Бегать по утрам, спать 8 часов и т.п..."
        textField.font = UIFont.preferredFont(forTextStyle: .body)
        textField.font = UIFont.systemFont(ofSize: 17.0, weight: .regular)
        
        return textField
    }()
    
    private lazy var colorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "ЦВЕТ"
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.font = UIFont.systemFont(ofSize: 13.0, weight: .semibold)
        
        return label
    }()
    
    private lazy var colorButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .myHabitsOrange
        button.clipsToBounds = true
        button.layer.cornerRadius = 15
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(didTapColorButton)
        )
        button.addGestureRecognizer(tap)
        
        return button
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "ВРЕМЯ"
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.font = UIFont.systemFont(ofSize: 13.0, weight: .semibold)
        
        return label
    }()
    
    private lazy var stringLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.font = UIFont.systemFont(ofSize: 17.0)
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.dateFormat = "HH:mm a"

        let time = formatter.string(from: datePicker.date)
    
        let attributedString = NSAttributedString(
            string: "Каждый день в ",
            attributes: [ .foregroundColor: UIColor.black]
        )
        let attributedStringTime = NSAttributedString(
            string: "\(time)",
            attributes: [ .foregroundColor: UIColor.myHabitsPurple]
        )
        let mutableAttributedString = NSMutableAttributedString()
        mutableAttributedString.append(attributedString)
        mutableAttributedString.append(attributedStringTime)
        
        label.attributedText = mutableAttributedString
        
        return label
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.datePickerMode = .time
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = Locale(identifier: "en_US_POSIX")
        datePicker.addTarget(
            self,
            action: #selector(didValueChanged(_:)),
            for: .valueChanged)
    
        return datePicker
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        button.setTitle("Удалить привычку", for: .normal)
        button.setTitleColor(UIColor.myDeleteButton, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17.0, weight: .regular)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        button.titleLabel?.textAlignment = .center
        button.addTarget(
            self,
            action: #selector(didTapDeleteButton),
            for: .touchUpInside
        )
        
        return button
    }()
    
    private var habit: Habit?
    private var index: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .tabBarToolbar
        setupNavigationBar()
        addSubviews()
        setupConstraint()
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Отменить",
            style: .plain,
            target: self,
            action: #selector(didTapBackButton)
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Сохранить",
            style: .plain,
            target: self,
            action: #selector(didTapSaveButton)
        )
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 17.0, weight: .semibold)], for: .normal)
        navigationItem.leftBarButtonItem?.tintColor = .myHabitsPurple
        navigationItem.rightBarButtonItem?.tintColor = .myHabitsPurple
    }
    
    private func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [titleLabel, textField, colorLabel, colorButton, timeLabel, stringLabel, datePicker, deleteButton].forEach() {
            contentView.addSubview($0)
        }
    }
    
    private func setupConstraint() {
        let safeAreaGuide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor),
            scrollView.widthAnchor.constraint(equalTo: safeAreaGuide.widthAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 21.0),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0),
            titleLabel.widthAnchor.constraint(equalToConstant: 74.0),
            titleLabel.heightAnchor.constraint(equalToConstant: 18.0),
            
            textField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 46.0),
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15.0),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0),
            textField.heightAnchor.constraint(equalToConstant: 22.0),
            
            colorLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 83.0),
            colorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0),
            colorLabel.widthAnchor.constraint(equalToConstant: 36.0),
            colorLabel.heightAnchor.constraint(equalToConstant: 18.0),
            
            colorButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 108.0),
            colorButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0),
            colorButton.widthAnchor.constraint(equalToConstant: 30.0),
            colorButton.heightAnchor.constraint(equalToConstant: 30.0),
            
            timeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 153.0),
            timeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0),
            timeLabel.widthAnchor.constraint(equalToConstant: 47.0),
            timeLabel.heightAnchor.constraint(equalToConstant: 18.0),
            
            stringLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 178.0),
            stringLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0),
            stringLabel.heightAnchor.constraint(equalToConstant: 22.0),
            
            datePicker.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 215.0),
            datePicker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            datePicker.heightAnchor.constraint(equalToConstant: 216.0),
            
            deleteButton.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 195.0),
            deleteButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0),
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0),
            deleteButton.heightAnchor.constraint(equalToConstant: 50.0),
            deleteButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
   
    private func loadHabitEditViewController(habit: Habit, index: Int) {
        textField.text = habit.name
        colorButton.backgroundColor = habit.color
        datePicker.date = habit.date
        deleteButton.isHidden = false
    }
    
    private func warningIsEmptyTextField() {
        let alertController = UIAlertController(
            title: "Введите название привычки",
            message: "",
            preferredStyle: .alert
        )
        let alertAction = UIAlertAction(
            title: "OK",
            style: .default
        ){
            (alert) in alertController.dismiss(animated: true)
        }
        alertController.addAction(alertAction)
        present(alertController, animated: true)
    }
    
    @objc private func didValueChanged(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.dateFormat = "HH:mm a"
        let time = formatter.string(from: sender.date)
        
        let attributedString = NSAttributedString(
            string: "Каждый день в ",
            attributes: [ .foregroundColor: UIColor.black]
        )
        let attributedStringTime = NSAttributedString(
            string: "\(time)",
            attributes: [ .foregroundColor: UIColor.myHabitsPurple]
        )
        let mutableAttributedString = NSMutableAttributedString()
        mutableAttributedString.append(attributedString)
        mutableAttributedString.append(attributedStringTime)
        
        stringLabel.attributedText = mutableAttributedString
    }
   
    @objc private func didTapColorButton() {
        let colorPicker = UIColorPickerViewController()
        colorPicker.delegate = self
        colorPicker.supportsAlpha = false
        colorPicker.selectedColor = colorButton.backgroundColor!
        present(colorPicker, animated: true)
    }
    
    @objc private func didTapBackButton() {
        dismiss(animated: true)
    }
    
    @objc private func didTapSaveButton(_ text: UITextField) {
        let store = HabitsStore.shared
        
           if habit == nil {
              
                if textField.text != "" {
                    let newHabit = Habit(
                        name: textField.text!,
                        date: datePicker.date,
                        color: colorButton.backgroundColor!
                    )
                    store.habits.append(newHabit)
                   dismiss(animated: true)
                } else {
                    warningIsEmptyTextField()
                }
               
           } else if habit != nil {
               
               if textField.text != "" {
                   store.habits[index!].name = textField.text!
                   store.habits[index!].color = colorButton.backgroundColor!
                   store.habits[index!].date = datePicker.date
                   store.save()
                   dismiss(animated: true)
               } else {
                   warningIsEmptyTextField()
               }
           }
    }
    
    @objc private func didTapDeleteButton() {
        let alertController = UIAlertController(
            title: "Удалить привычку",
            message: "Вы хотите удалить привычку \n \"\(habit!.name)\"?",
            preferredStyle: .alert
        )
        let cancel = UIAlertAction(
            title: "Отмена",
            style: .cancel
        ){
            (alert) in alertController.dismiss(animated: true)
        }
        let delete = UIAlertAction(
            title: "Удалить",
            style: .destructive
        ){
            (alert) in
            let store = HabitsStore.shared
            store.habits.remove(at: self.index!)
            self.dismiss(animated: true)
        }
        alertController.addAction(cancel)
        alertController.addAction(delete)
        present(alertController, animated: true)
    }
}

extension HabitCreateEditViewController: UIColorPickerViewControllerDelegate {
    
    func colorPickerViewController(
        _ viewController: UIColorPickerViewController,
        didSelect color: UIColor,
        continuously: Bool
    ) {
        let color = viewController.selectedColor
        colorButton.backgroundColor = color
    }
}

extension HabitCreateEditViewController: HabitsViewControllerDelegate {
    
    func didSelect(
        selectedHabit: Habit,
        selectedIndex: Int
    ) {
        habit = selectedHabit
        index = selectedIndex
        loadHabitEditViewController(habit: habit!, index: index!)
    }
}
