import UIKit

final class MainTableViewController: UITableViewController {
    
    var presenter: MainTablePresenterInput?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    private func setupNavigationBar() {
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        
        navigationItem.title = Constants.Localization.notes
        navigationController?.navigationBar.largeTitleTextAttributes =
            [NSAttributedString.Key.foregroundColor: Constants.Colors.white,
             NSAttributedString.Key.font: Constants.Font.textHeader ?? UIFont.systemFont(ofSize: 30)]
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = Constants.Colors.white
        navigationItem.largeTitleDisplayMode = .always
        
        let rightBarButtonItem = buildNavigationBarButton(imageName: "note_white", title: nil, color: .clear, target: self, action: #selector(onNewNoteTapped))
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    private func setupTableView() {
        presenter?.setView(self)
        presenter?.setDelegate(self)
        presenter?.setDataSource(self)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.cellIdentifier)
        tableView.separatorColor = Constants.Colors.white
        tableView.backgroundColor = Constants.Colors.black
    }
    
    @objc private func onNewNoteTapped() {
        guard let navigationController = navigationController else { return }
        presenter?.openNoteScreen(note: nil, with: navigationController)
    }
}

extension MainTableViewController: MainTablePresenterOutput {
    var myTableView: UITableView {
        get { return tableView }
    }
    
    func reloadTable() {
        tableView.reloadData()
    }
}

    //MARK: - table view function

extension MainTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return presenter?.fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let note = presenter?.fetchedResultsController.object(at: indexPath) else { return UITableViewCell() }
        return presenter?.configureCell(note) ?? UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            if let note = presenter?.fetchedResultsController.object(at: indexPath) {
                presenter?.delete(note: note)
                presenter?.save()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let navigationController = navigationController else { return }
        let note = presenter?.fetchedResultsController.object(at: indexPath)
        presenter?.openNoteScreen(note: note, with: navigationController)
    }
}
