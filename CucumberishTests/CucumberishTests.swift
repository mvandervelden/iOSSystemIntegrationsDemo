import Foundation
import Cucumberish

class CucumberishTests: NSObject {
    override init() {
        super.init()
        loadSteps()
        startTests(for:nil)
    }

    func loadSteps() {
        beforeStart() {
            () -> Void in
            StepDefinitions.setup();
        }
    }

    func startTests(for tags:Array<String>?) {
        let bundle = NSBundle(forClass: CucumberishTests.self)
        Cucumberish.instance().parserFeaturesInDirectory("Features", fromBundle: bundle, includeTags: tags, excludeTags: nil)
        Cucumberish.instance().fixMissingLastScenario = true
        Cucumberish.instance().testTargetFolderName = "CucumberishTests"
        Cucumberish.instance().beginExecution()
    }
}