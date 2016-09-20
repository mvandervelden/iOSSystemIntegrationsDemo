import KIF
import Cucumberish
import Foundation

extension NSObject: KIFTestActorDelegate {
    public func fail(with exception: NSException!, stopTest stop: Bool) {
        CCISAssert(false, exception.debugDescription) ;
    }

    public func fail(withExceptions exceptions: [AnyObject]!, stopTest stop: Bool) {
        CCISAssert(false, exceptions.map({$0.debugDescription}).joined(separator: "\n")) ;
    }
}
