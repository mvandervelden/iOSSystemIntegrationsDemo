
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
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl)
        
        updateItems()
        registerCells()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "showDetail" {
            if let destination = segue.destinationViewController as? DetailViewController {
                
                if let cellConfigurator = items[(tableView.indexPathForSelectedRow?.row)!] as? CellConfigurator<NoteTableViewCell> {
                    destination.note = cellConfigurator.viewData.title
                }
                else if let cellConfigurator = items[(tableView.indexPathForSelectedRow?.row)!] as? CellConfigurator<ImageTableViewCell>  {
                    destination.image = cellConfigurator.viewData.image
                }
            }
        }
    }
        
    @IBAction func refresh(refreshControl: UIRefreshControl) {
        updateItems()
        registerCells()
        tableView.reloadData()
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
                downloadImage(NSURL(string: image.url!)!)
            }
        }
    }
    
    func getDataFromUrl(url:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error)
            }.resume()
    }
    
    func downloadImage(url: NSURL){
        getDataFromUrl(url) { (data, response, error)  in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                guard let data = data where error == nil else { return }
                self.items.append(CellConfigurator<ImageTableViewCell>(viewData: ImageCellViewData(image:UIImage(data: data)!)))
                self.registerCells()
                self.tableView.reloadData()
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