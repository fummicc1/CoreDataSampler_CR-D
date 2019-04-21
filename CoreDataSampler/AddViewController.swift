import UIKit
import CoreData

class AddViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    
    var appDelegate: AppDelegate? {
        return UIApplication.shared.delegate as? AppDelegate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setupDelegate() {
        nameTextField.delegate = self
        ageTextField.delegate = self
    }
    
    func saveSample() {
        guard let container = appDelegate?.persistentContainer else { return }
        let sample = Sample(context: container.viewContext)
        if let age = Int32(ageTextField.text ?? "0") {
            sample.age = age
        }
        sample.name = nameTextField.text
        appDelegate?.saveContext()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pressedSaveButton(_ sender: Any) {
        saveSample()
    }
}

extension AddViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
