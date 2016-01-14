
import UIKit

let noteCellIdentifier = "NoteTableViewCell"
let imageCellIdentifier = "ImageTableViewCell"

protocol CellConfiguratorType {
    var reuseIdentifier: String { get }
    var cellClass: AnyClass { get }
    
    func updateCell(cell: UITableViewCell)
}

struct CellConfigurator<Cell where Cell: Updatable, Cell: UITableViewCell> {
    
    let viewData: Cell.ViewData
    let reuseIdentifier: String = NSStringFromClass(Cell)
    let cellClass: AnyClass = Cell.self
    
    func updateCell(cell: UITableViewCell) {
        if let cell = cell as? Cell {
            cell.updateWithViewData(viewData)
        }
    }
}

extension CellConfigurator: CellConfiguratorType {
}

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var items : [CellConfiguratorType] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        updateItems()
        registerCells()
    }
    
    @IBAction func refresh() {
        updateItems()
    }
    func registerCells() {
        for cellConfigurator in items {
            tableView.registerClass(cellConfigurator.cellClass, forCellReuseIdentifier: cellConfigurator.reuseIdentifier)
        }
    }
    
    func updateItems() {
        for note in Storage.notes() {
            items.append(CellConfigurator<NoteTableViewCell>(viewData: NoteCellViewData(title:note.text!)))
        }
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellConfigurator = items[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(cellConfigurator.reuseIdentifier, forIndexPath: indexPath)
        cellConfigurator.updateCell(cell)
        return cell
    }
}