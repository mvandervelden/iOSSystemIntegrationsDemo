import KIF
import Cucumberish
import Foundation

extension NSObject: KIFTestActorDelegate {
    public func failWithException(exception: NSException!, stopTest stop: Bool) {
        CCISAssert(false, exception.debugDescription) ;
    }

    public func failWithExceptions(exceptions: [AnyObject]!, stopTest stop: Bool) {
        CCISAssert(false, exceptions.map({$0.debugDescription}).joinWithSeparator("\n")) ;
    }
}