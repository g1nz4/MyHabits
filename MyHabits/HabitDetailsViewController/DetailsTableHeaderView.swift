import UIKit

class DetailsTableHeaderView: UIView {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.font = UIFont.systemFont(ofSize: 13.0, weight: .regular)
        label.textColor = .tableHeader
        label.text = "АКТИВНОСТЬ"
        label.textAlignment = .left
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContent()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupContent() {
        addSubview(titleLabel)
        backgroundColor = .myHabitsLightGray
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16.0),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.0),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 10.0),
            titleLabel.heightAnchor.constraint(equalToConstant: 18.0)
        ])
    }
}
