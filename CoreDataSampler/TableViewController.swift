import UIKit
import CoreData

class TableViewController: UIViewController {

    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var sampleList: [Sample] = []
    var appDelegate: AppDelegate? {
        return UIApplication.shared.delegate as? AppDelegate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetch()
    }
    
    func fetch() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Sample")
        guard let samples = try? appDelegate?.persistentContainer.viewContext.fetch(request) as? [Sample] else { return }
        sampleList = samples
        tableView.reloadData()
    }
    
    func setup() {
        addButton.layer.cornerRadius = 30
        addButton.layer.masksToBounds = true
        tableView.tableFooterView = UIView()
    }
    
    @IBAction func pressedAddButton() {
        guard let addViewController = UIStoryboard(name: "AddViewController", bundle: nil).instantiateInitialViewController() else { return }
        present(addViewController, animated: true, completion: nil)
    }
}

extension TableViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") else { return UITableViewCell() }
        cell.textLabel?.text = sampleList[indexPath.row].name
        let age = sampleList[indexPath.row].age
        cell.detailTextLabel?.text = "\(age)歳になりましたー"
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sampleList.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let container = appDelegate?.persistentContainer else { return }
            let sample = sampleList[indexPath.row]
            container.viewContext.delete(sample)
            sampleList.remove(at: indexPath.row)
            do {
                try container.viewContext.save()
            } catch {
                fatalError("\(error)")
            }
            let alert = UIAlertController(title: "削除完了", message: "\(sample.name ?? "")を削除しました。", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] action in
                self?.tableView.reloadData()
            }))
            present(alert, animated: true, completion: nil)
        }
    }
}

