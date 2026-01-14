import UIKit

class HabitCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "HabitCollectionViewCell"
    
    private lazy var habitName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.font = UIFont.systemFont(ofSize: 17.0, weight: .semibold)
        label.numberOfLines = 2
        
        return label
    }()
    
    private lazy var habitTime: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.font = UIFont.systemFont(ofSize: 12.0, weight: .regular)
        label.textColor = .systemGray2
        
        return label
        
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.clipsToBounds = true
            
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.alignment = .leading
        stackView.spacing = 4.0
                
        stackView.addArrangedSubview(self.habitName)
        stackView.addArrangedSubview(self.habitTime)
        
        return stackView
        
    }()
    
    private lazy var counter: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.font = UIFont.systemFont(ofSize: 13.0, weight: .regular)
        label.textColor = .systemGray
        
        return label
        
    }()
    
    private lazy var checkButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 19.0
        button.layer.borderWidth = 2.0
        button.addTarget(self, action: #selector(didTapCheckButton), for: .touchUpInside)
        
        return button
        
    }()
    
    private lazy var symbol: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.image = UIImage(named: "myHabitsCheckmark")
        image.tintColor = .white
        image.contentMode = .scaleAspectFit
    
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupContent()
      
    }
       
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupContent() {
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 8.0
        contentView.backgroundColor = .white
        
        [stackView, counter, checkButton, symbol, symbol].forEach() {
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20.0),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20.0),
            stackView.widthAnchor.constraint(equalToConstant: 220.0),
            
            checkButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 46.0),
            checkButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -28.0),
            checkButton.widthAnchor.constraint(equalToConstant: 38.0),
            checkButton.heightAnchor.constraint(equalToConstant: 38.0),
            
            symbol.topAnchor.constraint(equalTo: checkButton.topAnchor),
            symbol.centerXAnchor.constraint(equalTo: checkButton.centerXAnchor),
            symbol.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            symbol.widthAnchor.constraint(equalToConstant: 17.0),
            symbol.heightAnchor.constraint(equalToConstant: 17.0),
            
            counter.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 92.0),
            counter.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20.0),
            counter.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20.0),
            counter.widthAnchor.constraint(equalToConstant: 188.0),
            counter.heightAnchor.constraint(equalToConstant: 18.0)
        ])
    }
    
    @objc private func didTapCheckButton() {
        let myhabit = HabitsStore.shared.habits.first(where: {$0.name == habitName.text!})
        let habitstore = HabitsStore.shared
        
        if myhabit?.isAlreadyTakenToday == false {
            habitstore.track(myhabit!)
            UIView.animate(withDuration: 0.5) {
                self.checkButton.backgroundColor = myhabit?.color
                self.symbol.alpha = 1.0
            }
        }
    }
    
    func setupCell(habit: Habit) {
        habitName.text = "\(habit.name)"
        habitName.textColor = habit.color
        habitTime.text = "\(habit.dateString)"
        checkButton.layer.borderColor = habit.color.cgColor
        counter.text = "Счетчик: \(habit.trackDates.count)"
        
        if habit.isAlreadyTakenToday == true {
            checkButton.backgroundColor = habit.color
            symbol.alpha = 1.0
        } else if habit.isAlreadyTakenToday == false {
            checkButton.backgroundColor = .white
            symbol.alpha = 0.0
        }
    }
}


