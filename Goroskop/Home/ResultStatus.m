
#import "ResultStatus.h"

@implementation ResultStatus
@synthesize code;
@synthesize format;
@synthesize msg;
@synthesize data1;
@synthesize data;
- (id)init
{
    self = [super init];
    if (self != nil) {
        code     = @"";
        format   = @"";
        msg      = @"";
        data1   =   @"";
        data   =   @"";
    }
    return self;
}

@end
