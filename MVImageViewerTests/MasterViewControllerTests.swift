// Created by mmvdv on 13/07/16.

import Quick
import Nimble
@testable import MVImageViewer

class InsertionTableView : UITableView {
    var insertedIndexPath : NSIndexPath?
    
    override func insertRowsAtIndexPaths(indexPaths: [NSIndexPath], withRowAnimation animation: UITableViewRowAnimation) {
        insertedIndexPath = indexPaths.first
    }
}


class MasterViewControllerSpec : QuickSpec {
    override func spec() {
        describe("master view controller") {
            var subject : MasterViewController!
            
            beforeEach() {
                subject = UIViewController.loadViewController(withIdentifier: "MasterViewController", fromStoryboard: "Main") as! MasterViewController
            }
            
            context("showing the screen") {
                beforeEach() {
                    subject.show()
                }
                
                describe("adding a new object") {
                    var tableView : InsertionTableView!
                    beforeEach() {
                        tableView = InsertionTableView()
                        subject.tableView = tableView
                        subject.insertNewObject(self)
                    }
                    
                    it("adds an object to the view model") {
                        expect(subject.objects).to(haveCount(1))
                    }
                    
                    it("adds an object the start of the table") {
                        expect(tableView.insertedIndexPath).to(equal(NSIndexPath(forRow: 0, inSection: 0)))
                    }
                }
            }
        }
    }
}
