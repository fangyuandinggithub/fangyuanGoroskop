#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

typedef enum {
    kIAPPurchSuccess = 0,       
    kIAPPurchFailed = 1,        
    kIAPPurchCancle = 2,        
    KIAPPurchVerFailed = 3,     
    KIAPPurchVerSuccess = 4,    
    kIAPPurchNotArrow = 5,      
}IAPPurchType;

typedef void (^IAPCompletionHandle)(IAPPurchType type,NSData *data);

@interface CUCKOO_IAPManager : NSObject

@property (nonatomic, assign) BOOL MA_isBusy;

//开始购买
- (void)CUCKOO_startPurchWithID:(NSString *)purchID completeHandle:(IAPCompletionHandle)handle;

//restore
- (void)CUCKOO_restoreTransactionWithCompleteHandle:(IAPCompletionHandle)handle;

//验证订单
- (void)CUCKOO_verifyPurchaseWithPaymentTransaction:(SKPaymentTransaction *)transaction isTestServer:(BOOL)flag Compl:(void(^)(NSDate *currentDate))compl;

//验证订单
- (BOOL)CUCKOO_verifyPurchaseWithPaymentTransaction:(SKPaymentTransaction *)transaction isTestServer:(BOOL)flag;

@end
