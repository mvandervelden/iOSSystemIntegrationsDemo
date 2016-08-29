#import <Foundation/Foundation.h>
#import "CucumberishTests-Swift.h"

__attribute__((constructor))
void CucumberishInit() {
    [CucumberishTests new];
}