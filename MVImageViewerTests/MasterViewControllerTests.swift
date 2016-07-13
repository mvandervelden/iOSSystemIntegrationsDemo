// Created by mmvdv on 13/07/16.

import Quick
import Nimble
@testable import MVImageViewer

class MasterViewControllerSpec : QuickSpec {
    override func spec() {
        describe("master view controller") {
            var subject : MasterViewController!
            
            beforeEach() {
                subject = UIViewController.loadViewController(withIdentifier: "MasterViewController", fromStoryboard: "Main") as! MasterViewController
            }
            
            it("exists") {
                expect(subject).to(beAKindOf(MasterViewController))
            }
        }
    }
}
