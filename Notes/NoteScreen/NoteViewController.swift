import UIKit

final class NoteViewController: UIViewController, NotePresenterOutput {
    
    private var presenter: NotePresenterInput?
    
    init(presenter: NotePresenter) {
        super.init(nibName: nil, bundle: nil)
        self.presenter = presenter
        presenter.loadNote()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal lazy var dateLabel: UILabel = {
        let date = UILabel()
        date.textAlignment = .center
        date.textColor = Constants.Colors.gray
        date.font = Constants.Font.textMain
        date.text = presenter?.note?.date
        date.translatesAutoresizingMaskIntoConstraints = false
        return date
    }()
    
    internal lazy var nameTextField: UITextField = {
        let name = UITextField()
        name.backgroundColor = .clear
        name.layer.cornerRadius = Constants.Sizes.cornerRadius
        name.clipsToBounds = true
        name.textColor = Constants.Colors.white
        name.attributedPlaceholder = NSAttributedString(string: "Notes name",
                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        name.text = presenter?.note?.name
        name.translatesAutoresizingMaskIntoConstraints = false
        return name
    }()
    
    internal lazy var mainTextView: UITextView = {
        let text = UITextView()
        text.backgroundColor = .clear
        text.layer.cornerRadius = Constants.Sizes.cornerRadius
        text.clipsToBounds = true
        text.textColor = Constants.Colors.white
        text.font = Constants.Font.textMain
        text.attributedText = presenter?.note?.text
        text.allowsEditingTextAttributes = true
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    private lazy var customTabBar: UIView = {
        let tabBar = UIView()
        tabBar.backgroundColor = Constants.Colors.black
        tabBar.alpha = Constants.Sizes.alpha
        tabBar.translatesAutoresizingMaskIntoConstraints = false
        return tabBar
    }()
    
    private lazy var newNoteButton: UIButton = {
        let button = UIButton(title: "", target: self, selector: #selector(onNewNoteButtonTapped))
        button.backgroundColor = .clear
        button.setImage(UIImage(named: "note_white"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var addImageButton: UIButton = {
        let button = UIButton(title: "", target: self, selector: #selector(onAddImageButtonTapped))
        button.backgroundColor = .clear
        button.setImage(UIImage(named: "image_white"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var trashButton: UIButton = {
        let button = UIButton(title: "", target: self, selector: #selector(onTrashButtonTapped))
        button.backgroundColor = .clear
        button.setImage(UIImage(named: "garbage_white"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    internal lazy var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.Colors.black
        
        presenter?.setView(self)
        setupNavigationBar()
        setupConstraints()
    }
    
    private func setupNavigationBar() {
        let leftBarButtonItem = buildNavigationBarButton(imageName: "arrow_white", title: nil, color: .clear, target: self, action: #selector(onBackButtonTapped))
        
        navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    @objc private func onBackButtonTapped() {
        guard let navigationController = navigationController else { return }
        presenter?.saveContext()
        presenter?.backToMainScreen(with: navigationController)
    }
    
    @objc private func onNewNoteButtonTapped() {
        guard let navigationController = navigationController else { return }
        presenter?.saveContext()
        presenter?.openNewNoteScreen(with: navigationController)
    }
    
    @objc private func onAddImageButtonTapped() {
        guard let navigationController = navigationController else { return }
        presenter?.showImagePicker(with: navigationController)
    }
    
    @objc private func onTrashButtonTapped() {
        guard let navigationController = navigationController else { return }
        presenter?.clearData()
        presenter?.saveContext()
        presenter?.backToMainScreen(with: navigationController)
    }
}


    //MARK: - setup constraints

extension NoteViewController {
    private func setupConstraints() {
        let topBarHeight: CGFloat = Constants.Sizes.screenHeight / 10
        let tabBarHeight: CGFloat = Constants.Sizes.screenHeight / 15
        
        view.addSubview(dateLabel)
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: topBarHeight),
            dateLabel.heightAnchor.constraint(equalToConstant: 20),
            dateLabel.widthAnchor.constraint(equalToConstant: Constants.Sizes.screenWidth),
            dateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        view.addSubview(nameTextField)
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 20),
            nameTextField.heightAnchor.constraint(equalToConstant: 40),
            nameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameTextField.widthAnchor.constraint(equalToConstant: Constants.Sizes.screenWidth - 32)
        ])

        view.addSubview(mainTextView)
        NSLayoutConstraint.activate([
            mainTextView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20),
            mainTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Constants.Sizes.inset),
            mainTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainTextView.widthAnchor.constraint(equalToConstant: Constants.Sizes.screenWidth - 32)
        ])
        
        view.addSubview(customTabBar)
        NSLayoutConstraint.activate([
            customTabBar.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.Sizes.screenHeight - tabBarHeight - Constants.Sizes.inset),
            customTabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.Sizes.inset),
            customTabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.Sizes.inset),
            customTabBar.heightAnchor.constraint(equalToConstant: tabBarHeight)
        ])
        
        view.addSubview(newNoteButton)
        view.addSubview(addImageButton)
        view.addSubview(trashButton)
        NSLayoutConstraint.activate([
            newNoteButton.centerYAnchor.constraint(equalTo: customTabBar.centerYAnchor),
            newNoteButton.widthAnchor.constraint(equalToConstant: tabBarHeight / 2),
            newNoteButton.trailingAnchor.constraint(equalTo: customTabBar.trailingAnchor),
            newNoteButton.heightAnchor.constraint(equalToConstant: tabBarHeight / 2),
            
            addImageButton.centerYAnchor.constraint(equalTo: customTabBar.centerYAnchor),
            addImageButton.widthAnchor.constraint(equalToConstant: tabBarHeight / 2),
            addImageButton.centerXAnchor.constraint(equalTo: customTabBar.centerXAnchor),
            addImageButton.heightAnchor.constraint(equalToConstant: tabBarHeight / 2),
            
            trashButton.centerYAnchor.constraint(equalTo: customTabBar.centerYAnchor),
            trashButton.widthAnchor.constraint(equalToConstant: tabBarHeight / 2),
            trashButton.leadingAnchor.constraint(equalTo: customTabBar.leadingAnchor),
            trashButton.heightAnchor.constraint(equalToConstant: tabBarHeight / 2),
        ])
    }
}
