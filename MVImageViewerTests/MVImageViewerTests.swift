import Quick
import Nimble
@testable import MVImageViewer

class DetailViewControllerSpec: QuickSpec {
	override func spec() {
		describe("showing the view controller") {
            var subject : UIViewController!
            
            beforeEach() {
				let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
				 subject = storyboard.instantiateViewControllerWithIdentifier("DetailViewController")
			}
			
			it("shows the detail description") {
				expect(subject).to(beAKindOf(DetailViewController))
			}
		}
	}
}