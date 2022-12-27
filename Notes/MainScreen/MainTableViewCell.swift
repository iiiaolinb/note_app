import UIKit

class MainTableViewCell: UITableViewCell {
    static let cellIdentifier = "MainTableViewCell"
    
    let widthInset: CGFloat = 15
    let heightInset: CGFloat = 5
    let imageSize: CGFloat = 70
    
    lazy var imageBlock: UITextView = {
        let label = UITextView()
        label.backgroundColor = .clear
        label.font = Constants.Font.textExtraSmall
        label.textColor = Constants.Colors.superWhite
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = Constants.Font.textMain
        label.textColor = Constants.Colors.white
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = Constants.Font.textSmall
        label.textColor = Constants.Colors.white
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let mainStack = UIStackView()
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        mainStack.axis = .horizontal
        mainStack.backgroundColor = .clear
        mainStack.layer.cornerRadius = Constants.Sizes.cornerRadius
        mainStack.clipsToBounds = true
        
        mainStack.layer.shadowColor = Constants.Colors.white.cgColor
        mainStack.layer.shadowRadius = 5
        mainStack.layer.shadowOpacity = 1
        mainStack.layer.masksToBounds = false
        
        let rightStack = UIStackView()
        rightStack.axis = .vertical
        
        rightStack.addArrangedSubview(nameLabel)
        rightStack.addArrangedSubview(dateLabel)
        
        mainStack.addArrangedSubview(imageBlock)
        mainStack.addArrangedSubview(rightStack)
        
        return mainStack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        layer.cornerRadius = Constants.Sizes.cornerRadius
        clipsToBounds = true
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Error")
    }
    
    private func setupConstraints() {
        
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: widthInset),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -widthInset),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -widthInset),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: widthInset)
        ])
        
        NSLayoutConstraint.activate([
            imageBlock.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: widthInset),
            imageBlock.centerYAnchor.constraint(equalTo: stackView.centerYAnchor),
            imageBlock.heightAnchor.constraint(equalToConstant: imageSize),
            imageBlock.widthAnchor.constraint(equalToConstant: imageSize)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: widthInset * 2 + imageSize),
            nameLabel.topAnchor.constraint(equalTo: stackView.topAnchor, constant: heightInset),
            nameLabel.heightAnchor.constraint(equalToConstant: imageSize / 2),
            nameLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -widthInset)
        ])
        
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: widthInset * 2 + imageSize),
            dateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            dateLabel.heightAnchor.constraint(equalToConstant: imageSize / 2),
            dateLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -widthInset)
        ])
    }
}
