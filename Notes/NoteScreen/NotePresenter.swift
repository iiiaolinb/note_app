import UIKit
import CoreData

    //MARK: view -> presenter

protocol NotePresenterInput: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    var persistentContainer: NSPersistentContainer? { get }
    var note: Note? { get }
    func setView(_ view: NotePresenterOutput)
    func loadNote()
    func saveContext()
    func clearData()
    func dateToString() -> String
    func showImagePicker(with navigationController: UINavigationController)
    func backToMainScreen(with navigationController: UINavigationController)
    func openNewNoteScreen(with navigationController: UINavigationController)
}

    //MARK: view <- presenter

protocol NotePresenterOutput {
    var dateLabel: UILabel { get set }
    var nameTextField: UITextField { get set }
    var mainTextView: UITextView { get set }
    var imagePicker: UIImagePickerController { get set }
}

final class NotePresenter: NSObject {
    var note: Note?
    private var viewController: NotePresenterOutput? = nil
    var persistentContainer: NSPersistentContainer?
    
    init(persistentContainer: NSPersistentContainer) {
        super.init()
        self.persistentContainer = persistentContainer
    }
}

extension NotePresenter: NotePresenterInput {
    func setView(_ view: NotePresenterOutput) {
        self.viewController = view
    }
    
        //loading a note from coredata (for the selected cell)
    func loadNote() {
        guard let note = note else { return }

        if note.date == nil {
            viewController?.dateLabel.text = dateToString()
        } else {
            viewController?.dateLabel.text = note.date
        }
        viewController?.mainTextView.attributedText = note.text
        viewController?.nameTextField.text = note.name
    }
    
        //the function saves the changes made in the storage
    func saveContext() {
        
        //checking if the note is new
        guard let note = note else {
            createNewNote(name: viewController?.nameTextField.text, text: viewController?.mainTextView.attributedText)
            return
        }
        
        //checking if the note is empty
        if (note.name?.count == 0 && note.text?.length == 0) || (note.name == "" && note.text == NSAttributedString(string: "")) {
            
        //if the note is empty then delete it
            persistentContainer?.viewContext.delete(note)
            do {
                try persistentContainer?.viewContext.save()
            } catch {
                print("Error save context : \(error.localizedDescription)")
            }
        
        //else save it
        } else {
            note.date = viewController?.dateLabel.text
            note.name = viewController?.nameTextField.text
            note.text = viewController?.mainTextView.attributedText
            do {
                try note.managedObjectContext?.save()
            } catch {
                print("Error save context : \(error.localizedDescription)")
            }
        }
    }
    
        //the function creates a new storage item
    private func createNewNote(name: String?, text: NSAttributedString?) {
        guard let persistentContainer = persistentContainer,
                name != "" || text != NSAttributedString(string: "")
        else { return }
        
        note = Note.init(entity: NSEntityDescription.entity(forEntityName: "Note",
                                                            in: persistentContainer.viewContext)!,
                         insertInto: persistentContainer.viewContext)
        note?.date = dateToString()
        note?.name = name
        note?.text = text
        
        do {
            try note?.managedObjectContext?.save()
        } catch {
            print("Error save context : \(error.localizedDescription)")
        }
    }
    
        //clearing all UI screen elements
    func clearData() {
        note?.date = ""
        note?.name = ""
        note?.text = NSAttributedString(string: "")
        viewController?.dateLabel.text = ""
        viewController?.nameTextField.text = ""
        viewController?.mainTextView.text = ""
    }
        
        //the function convert current date to string
    func dateToString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd 'at' HH:mm"
        return dateFormatter.string(from: Date())
    }
    
    func showImagePicker(with navigationController: UINavigationController) {
        guard let viewController = viewController else { return }
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.savedPhotosAlbum) {
            viewController.imagePicker.delegate = self
            viewController.imagePicker.sourceType = UIImagePickerController.SourceType.savedPhotosAlbum
            viewController.imagePicker.allowsEditing = true
            navigationController.present(viewController.imagePicker, animated: true, completion: nil)
        }
    }
    
    func backToMainScreen(with navigationController: UINavigationController) {
        navigationController.popToRootViewController(animated: true)
    }
    
    func openNewNoteScreen(with navigationController: UINavigationController) {
        guard let persistentContainer = persistentContainer else { return }
        navigationController.pushViewController(Coordinator.openNoteScreen(nil, withData: persistentContainer), animated: true)
    }
}

    //MARK: - image picker delegate

extension NotePresenter: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)

    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        picker.dismiss(animated:true, completion: nil)
        
        let textAttachment = NSTextAttachment()

        if let selectedImage = selectedImage,
           let cgImage = selectedImage.cgImage
            {

            let scaleFactor = selectedImage.size.width * 2 / (viewController?.mainTextView.bounds.width ?? 100)
            textAttachment.image = UIImage(cgImage: cgImage, scale: scaleFactor, orientation: .up)
            
            let attributedString = NSAttributedString(attachment: textAttachment)
            
            viewController?.mainTextView.textStorage.insert(attributedString, at: (viewController?.mainTextView.selectedRange.location)!)
            viewController?.mainTextView.textColor = Constants.Colors.white
            viewController?.mainTextView.font = Constants.Font.textMain
        }
    }
}
