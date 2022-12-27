import UIKit
import CoreData

    //MARK: view -> presenter

protocol MainTablePresenterInput {
    var fetchedResultsController: NSFetchedResultsController<Note> { get }
    func setView(_ view: MainTablePresenterOutput)
    func setDelegate(_ delegate: UITableViewDelegate)
    func setDataSource(_ dataSource: UITableViewDataSource)
    func openNoteScreen(note: Note?, with navigationController: UINavigationController)
    func configureCell(_ data: Note) -> UITableViewCell
    func delete(note: Note?)
    func save()
}

    //MARK: view <- presenter

protocol MainTablePresenterOutput {
    var myTableView: UITableView { get }
    func reloadTable() 
}

final class MainTablePresenter: NSObject {
    
        //support you to understand
        //whether the app has already been launched
    private let defaults: UserDefaults = {
        let defaults = UserDefaults.standard
        defaults.data(forKey: Constants.Keys.isFirstRun)
        return defaults
    }()
    
    private var viewController: MainTablePresenterOutput?
    
    private let persistentContainer = NSPersistentContainer(name: "NotesModel")
    lazy var fetchedResultsController: NSFetchedResultsController<Note> = {
        
        let fetchRequest = Note.fetchRequest()
        var sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: persistentContainer.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    override init() {
        super.init()
        loadPersistentStores()
    }
    
    private func loadPersistentStores() {
        persistentContainer.loadPersistentStores { (NSPersistentStoreDescription, error) in
            if let error = error {
                print("Error load persistent stores : \(error.localizedDescription)")
            } else {
                    
                self.isFirstRun() ? self.createSampleNote() : nil

                do { try self.fetchedResultsController.performFetch() }
                catch { print("Error perform fetch : \(error.localizedDescription)") }
            }
        }
    }
    
        //is the app starting for the first time?
    private func isFirstRun() -> Bool {
        print("DEFAULT - \(defaults.bool(forKey: Constants.Keys.isFirstRun))")
        switch defaults.bool(forKey: Constants.Keys.isFirstRun) {
        case false:
            defaults.set(true, forKey: Constants.Keys.isFirstRun)
            return true
        case true:
            return false
        }
    }
    
        //function create new note with name "Sample note"
        //for the first run app
    private func createSampleNote() {
        let note = Note.init(entity: NSEntityDescription.entity(forEntityName: "Note",
                                                                in: self.persistentContainer.viewContext)!,
                             insertInto: self.persistentContainer.viewContext)
        note.name = "Sample note"
        
        do { try note.managedObjectContext?.save() }
        catch { print("Error save context on first run : \(error.localizedDescription)") }
    }
}

extension MainTablePresenter: MainTablePresenterInput {

    func setView(_ view: MainTablePresenterOutput) {
        self.viewController = view
    }
    
    func setDelegate(_ delegate: UITableViewDelegate) {
        self.viewController?.myTableView.delegate = delegate
    }
    
    func setDataSource(_ dataSource: UITableViewDataSource) {
        self.viewController?.myTableView.dataSource = dataSource
    }
    
    func openNoteScreen(note: Note?, with navigationController: UINavigationController) {
        navigationController.pushViewController(Coordinator.openNoteScreen(note, withData: persistentContainer), animated: true)
    }
    
    func configureCell(_ data: Note) -> UITableViewCell {
        guard let cell = viewController?.myTableView.dequeueReusableCell(withIdentifier: MainTableViewCell.cellIdentifier) as? MainTableViewCell else { return UITableViewCell() }
        
        cell.imageBlock.attributedText = data.text
        cell.imageBlock.backgroundColor = Constants.Colors.superBlack
        cell.imageBlock.font = UIFont.systemFont(ofSize: 5)
        cell.imageBlock.textColor = Constants.Colors.white
        cell.imageBlock.isEditable = false
        cell.nameLabel.text = data.name
        cell.dateLabel.text = data.date
        
        return cell
    }
    
    func delete(note: Note?) {
        guard let note = note else { return }
        persistentContainer.viewContext.delete(note)
    }
    
    func save() {
        do {
            try persistentContainer.viewContext.save()
        } catch {
            print("Error save context : \(error.localizedDescription)")
        }
    }
}

    //MARK: - core data function

extension MainTablePresenter: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        viewController?.myTableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    
        switch type {
        case .insert:
            if newIndexPath != nil {
                
                    //we will insert each new cell to the top of the table
                viewController?.myTableView.insertRows(at: [IndexPath(indexes: [0, 0])], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath {
                viewController?.myTableView.deleteRows(at: [indexPath], with: .automatic)
            }
        case .move:
            print("move")
        case .update:
            print("update")
        @unknown default:
            fatalError()
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        viewController?.myTableView.endUpdates()
    }
}
