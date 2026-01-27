import UIKit

class ProgressCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "ProgressCollectionViewCell"
    
    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.progressTintColor = .myHabitsPurple
        
        return progressView
    }()
    
    private lazy var statuslabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.font = UIFont.systemFont(ofSize: 13.0, weight: .semibold)
        label.textColor = .systemGray
        label.textAlignment = .left
        label.text = "Вcё получится!"
        
        return label
    }()
    
    private lazy var progresslabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.font = UIFont.systemFont(ofSize: 13.0, weight: .semibold)
        label.textColor = .systemGray
        label.textAlignment = .right
        
        return label
    }()
    
    private var newValueOfProgress: Float = 0.0
    
    override init(frame: CGRect) {
       super.init(frame: frame)
       setupView()
   }
       
   required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
   }
    
    private func setupView() {
        contentView.backgroundColor = .white
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 8.0
        
        [statuslabel, progresslabel, progressView].forEach() {
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            statuslabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10.0),
            statuslabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12.0),
            statuslabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32.0),
            
            progresslabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10.0),
            progresslabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12.0),
            progresslabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32.0),
            
            progressView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 38.0),
            progressView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12.0),
            progressView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12.0),
            progressView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15.0)
        ])
    }
    
    func percentageOfProgress(value: Float) {
        let onePercent = Float(1) / 100
        let percentageOfProgress = value / onePercent
        progresslabel.text = "\(Int(percentageOfProgress))%"
        progressView.setProgress(Float(1 / 100 * percentageOfProgress), animated: true)
    }
}
