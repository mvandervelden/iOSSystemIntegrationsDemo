
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
    var itemToRestore: AnyObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl)
        
        updateItems()
        refreshScreen()
    }
    
    func refreshScreen() {
        registerCells()
        tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if let destination = segue.destinationViewController as? DetailViewController
            where segue.identifier == "showDetail" {
            
            if let selectedRow = self.tableView.indexPathForSelectedRow?.row {
            
                if let cellConfigurator = items[selectedRow] as? CellConfigurator<NoteTableViewCell> {
                    destination.note = cellConfigurator.viewData.title
                }
                else if let cellConfigurator = items[selectedRow] as? CellConfigurator<ImageTableViewCell>  {
                    destination.image = cellConfigurator.viewData.image
                }
            }
            else if let item = self.itemToRestore {
                if item is NSString {
                    destination.note = item as? String
                }
                else if item is UIImage {
                    destination.image = item as? UIImage
                }
            }
        }
    }
    
    override func restoreUserActivityState(activity: NSUserActivity) {
        
        //TODO: itemToRestore should be of class Note, Image or Contact
        if let type = activity.userInfo?["type"] {
            if type.isEqualToString("note") {
                self.itemToRestore = (activity.userInfo?["name"])!
            }
            else if type.isEqualToString("image"){
                let imageData = activity.userInfo?["data"] as! NSData
                self.itemToRestore = UIImage(data: imageData)!
            }
            
            self.performSegueWithIdentifier("showDetail", sender: self)
        }
    }
    
    func restoreItem(item: AnyObject) {
        self.itemToRestore = item
        self.performSegueWithIdentifier("showDetail", sender: self)
    }
        
    @IBAction func refresh(refreshControl: UIRefreshControl) {
        updateItems()
        refreshScreen()
        refreshControl.endRefreshing()
    }
    
    func registerCells() {
        for cellConfigurator in items {
            tableView.registerClass(cellConfigurator.cellClass, forCellReuseIdentifier: cellConfigurator.reuseIdentifier)
        }
    }
    
    func updateItems() {
        items.removeAll()
        for item in Storage.allItems() {
            if let note = item as? Note {
                items.append(CellConfigurator<NoteTableViewCell>(viewData: NoteCellViewData(title:note.text!)))
            }
            if let image = item as? Image {
                downloadImage(image)
            }
        }
    }
    
    
    func downloadImage(image : Image){
        image.downloadImage { (image) -> Void in
                if let uiImage = image.image {
                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
                        self.items.append(CellConfigurator<ImageTableViewCell>(viewData: ImageCellViewData(image:uiImage)))
                        self.refreshScreen()
                }
            }
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

extension ViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("showDetail", sender: self)
    }
}