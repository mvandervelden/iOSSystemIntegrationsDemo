import UIKit
import CoreSpotlight

let noteCellIdentifier = "NoteTableViewCell"
let imageCellIdentifier = "ImageTableViewCell"

protocol CellConfiguratorType {
    var reuseIdentifier: String { get }
    var cellClass: AnyClass { get }

    func updateCell(cell: UITableViewCell)
}

struct CellConfigurator<Cell where Cell:Updatable, Cell:UITableViewCell> {
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

    var items: [CellConfiguratorType] = []
    var itemToRestore: Indexable?

    lazy var storage : Storage = {
       return Storage()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        DataController.sharedInstance.delegate = self
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(_:)), forControlEvents: .ValueChanged)
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
                    destination.note = cellConfigurator.viewData.note
                } else if let cellConfigurator = items[selectedRow] as? CellConfigurator<ImageTableViewCell> {
                    destination.image = cellConfigurator.viewData.image
                } else if let cellConfigurator = items[selectedRow] as? CellConfigurator<ContactTableViewCell> {
                    destination.contact = cellConfigurator.viewData.contact
                }
            } else if let item = self.itemToRestore {
                if item is Note {
                    destination.note = item as? Note
                } else if item is Image {
                    destination.image = item as? Image
                } else if item is Contact {
                    destination.contact = item as? Contact
                }
            }
        }
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
        for item in storage.allItems() {
            if let note = item as? Note {
                items.append(CellConfigurator<NoteTableViewCell>(viewData: NoteCellViewData(note: note)))
            }
            if let image = item as? Image {
                downloadImage(image)
            }
            if let contact = item as? Contact {
                items.append(CellConfigurator<ContactTableViewCell>(viewData: ContactCellViewData(contact: contact)))
            }
        }
    }

    func downloadImage(image: Image) {
        image.downloadImage {
            (image) -> Void in
            dispatch_async(dispatch_get_main_queue()) {
                () -> Void in
                self.items.append(CellConfigurator<ImageTableViewCell>(viewData: ImageCellViewData(image: image)))
                self.refreshScreen()
            }
        }
    }
}

extension ViewController: DataControllerDelegate {
    func didInitializeStorage() {
        updateItems()
        refreshScreen()
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
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
}

extension ViewController : ActivityRestorator {
    func restoreFromWeb(activity:NSUserActivity) -> Bool {
        guard let paths = activity.webpageURL!.pathComponents
            where paths.count > 1
            else {
                return false
        }
        if paths[1] == "notes", let text = storage.getNoteByText(paths[2].capitalizedString) {
            restoreItem(text)
            return true
        } else if paths[1] == "images", let image = storage.getImageByTitle(paths[2].capitalizedString) {
            restoreItem(image)
            return true
        }
        return false
    }
    
    func restoreItem(item: Indexable) {
        self.itemToRestore = item
        self.performSegueWithIdentifier("showDetail", sender: self)
    }
    
    func restoreFromActivity(activity:NSUserActivity) -> Bool {
        restoreUserActivityState(activity)
        return true
    }
    
    override func restoreUserActivityState(activity: NSUserActivity) {
        if let type = activity.userInfo?["type"] {
            if type.isEqualToString("note") {
                let note = storage.getNoteByText(activity.userInfo?["name"] as! String)
                self.itemToRestore = note
            } else if type.isEqualToString("image") {
                let url = activity.userInfo?["id"] as! String
                self.itemToRestore = storage.getImageByURL(url)
            } else if type.isEqualToString("contact") {
                let email = activity.userInfo?["id"] as! String
                self.itemToRestore = storage.getContactByEmail(email)
            }
            
            self.performSegueWithIdentifier("showDetail", sender: self)
        }
    }
    
    func restoreFromSpotlight(activity:NSUserActivity) -> Bool {
        if let id = activity.userInfo?[CSSearchableItemActivityIdentifier] as? String {
            if let note = storage.getNoteById(id) {
                itemToRestore = note
            } else if let image = storage.getImageByURL(id) {
                itemToRestore = image
            } else if let contact = storage.getContactByEmail(id) {
                self.itemToRestore = contact
            }
            
            self.performSegueWithIdentifier("showDetail", sender: self)
            return true
        }
        return false
    }
}