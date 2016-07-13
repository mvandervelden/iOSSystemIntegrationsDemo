import Quick
import Nimble
@testable import MVImageViewer

class DetailViewControllerSpec: QuickSpec {
    override func spec() {
        describe("detail view controller") {
            var subject : DetailViewController!
            
            beforeEach() {
                let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
                subject = storyboard.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
            }
            
            context("given a detail item") {
                beforeEach() {
                    subject.detailItem = "some item"
                }
                
                context("when detail screen is shown") {
                    beforeEach() {
                        UIApplication.sharedApplication().keyWindow!.rootViewController = subject
                        let _ = subject.view
                    }
                    
                    it("sets the item's description in the detail label") {
                        expect(subject.detailDescriptionLabel.text).to(equal("some item"))
                    }
                    
                    context("detail item is changed") {
                        beforeEach() {
                            subject.detailItem = "changed"
                        }
                        
                        it("updates the label") {
                            expect(subject.detailDescriptionLabel.text).to(equal("changed"))
                        }
                    }
                }
            }
            
            context("given no detail item") {
                context("when detail screen is shown") {
                    beforeEach() {
                        UIApplication.sharedApplication().keyWindow!.rootViewController = subject
                        let _ = subject.view
                    }
                    
                    it("has an empty label") {
                        expect(subject.detailDescriptionLabel.text).to(equal(""))
                    }
                }
            }
        }
    }
}