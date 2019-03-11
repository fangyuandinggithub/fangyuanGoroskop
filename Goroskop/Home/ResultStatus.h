

#import <Foundation/Foundation.h>

@interface ResultStatus : NSObject

@property (nonatomic, retain) NSString *code;
@property (nonatomic, retain) NSString *format;
@property (nonatomic, retain) NSString *msg;
@property (nonatomic, retain) NSString *data1;
@property (nonatomic, retain) NSString *data;
@property (nonatomic, retain) NSDictionary *datadic;

@end
