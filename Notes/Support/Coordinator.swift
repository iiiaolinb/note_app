import UIKit
import CoreData

class Coordinator {
    
    static func buildMainScreen() -> UIViewController {
        let viewController = MainTableViewController()
        viewController.presenter = MainTablePresenter()
        
        return viewController
    }
    
    static func openNoteScreen(_ note: Note?, withData persisteneContainer: NSPersistentContainer) -> UIViewController {
        let presenter = NotePresenter(persistentContainer: persisteneContainer)
        presenter.note = note
        let viewController = NoteViewController(presenter: presenter)
        
        return viewController
    }
}
