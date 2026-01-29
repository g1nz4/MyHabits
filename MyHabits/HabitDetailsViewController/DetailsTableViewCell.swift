import UIKit

class DetailsTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "DetailsTableViewCell"
    
    private lazy var content: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.font = UIFont.systemFont(ofSize: 17.0, weight: .regular)
        
        return label
    }()
    
    private lazy var symbol: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.image = UIImage(named: "symbol")
        image.tintColor = .myHabitsPurple
        image.contentMode = .scaleAspectFit

        return image
    }()
    
    private lazy var separator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .tableSeparator
        
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupContent() {
        addSubview(content)
        [dateLabel, symbol, separator].forEach() {
            content.addSubview($0)
        }
        
        let safeArea = safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            content.topAnchor.constraint(equalTo: safeArea.topAnchor),
            content.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            content.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            content.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            content.heightAnchor.constraint(equalToConstant: 44.0),
            
            dateLabel.topAnchor.constraint(equalTo: content.topAnchor, constant: 11.0),
            dateLabel.leadingAnchor.constraint(equalTo: content.leadingAnchor, constant: 16.0),
            dateLabel.bottomAnchor.constraint(equalTo: content.bottomAnchor, constant: -11.0),
            
            symbol.trailingAnchor.constraint(equalTo: content.trailingAnchor, constant: -16.0),
            symbol.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor),
            symbol.widthAnchor.constraint(equalToConstant: 26.0),
            symbol.heightAnchor.constraint(equalToConstant: 44.0),
            
            separator.topAnchor.constraint(equalTo: content.topAnchor, constant: 43.5),
            separator.leadingAnchor.constraint(equalTo: content.leadingAnchor, constant: 16.0),
            separator.trailingAnchor.constraint(equalTo: content.trailingAnchor),
            separator.bottomAnchor.constraint(equalTo: content.bottomAnchor),
            separator.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }

    func setupCell(date: Date, habit: Habit) {
        let calendar = Calendar.current
        let today = Date()
        let startToday = calendar.startOfDay(for: today)
        let startDate  = calendar.startOfDay(for: date)

        if let differenceDays = calendar.dateComponents([.day], from: startDate, to: startToday).day {
            switch differenceDays {
            case 0:
                dateLabel.text = "Сегодня"
            case 1:
                dateLabel.text = "Вчера"
            case 2:
                dateLabel.text = "Позавчера"
            default:
                let formatter = DateFormatter()
                formatter.dateFormat = "dd.MM.yyyy"
                dateLabel.text = formatter.string(from: date)
            }
        }

        let isTracked = HabitsStore.shared.habit(habit, isTrackedIn: date)
       
        if isTracked == true {
            symbol.alpha = 0.74
        } else {
            symbol.alpha = 0.0
        }
    }
}
