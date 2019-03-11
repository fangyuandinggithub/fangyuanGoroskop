
//

#import <Foundation/Foundation.h>
#import "ResultStatus.h"
#import "AFNetworking.h"

@interface HoroscopesArtistDataManager : NSObject
@property (nonatomic, strong) AFHTTPSessionManager *httpmanager;
+ (instancetype)manager;


//Sticker Gif
- (NSURLSessionDataTask *)GetStickListWithBlock:(void (^)(NSArray *posts,ResultStatus *status,NSError *error))block;
- (NSURLSessionDataTask *)GetStickInlist:(NSInteger )count WithBlock:(void (^)(NSArray *posts,ResultStatus *status,NSError *error))block;
- (NSURLSessionDataTask *)GetStickInlist:(NSInteger )count Page:(NSInteger )Page WithBlock:(void (^)(NSArray *posts,ResultStatus *status,NSError *error))block;


- (NSURLSessionDataTask *)GetNewPicMsg:(NSString *)page WithBlock:(void (^)(NSArray *posts,ResultStatus *status,NSError *error))block;
- (NSURLSessionDataTask *)GetPopularPicMsgpage:(NSString *)page WithBlock:(void (^)(NSDictionary *posts,ResultStatus *status,NSError *error))block;
- (NSURLSessionDataTask *)GetClassPicMsg:(NSString *)cid page:(NSString *)page WithBlock:(void (^)(NSArray *posts,ResultStatus *status,NSError *error))block;
- (NSURLSessionDataTask *)GetPicClass:(NSString *)page pk:(NSString *)pkg WithBlock:(void (^)(NSArray *posts,ResultStatus *status,NSError *error))block;

- (NSURLSessionDataTask *)GetRestore:(NSString *)Uid WithBlock:(void(^)(NSDictionary *posts,ResultStatus *status,NSError *error))block;
- (NSURLSessionDataTask *)InsertRestore:(NSString *)Uid WithBlock:(void(^)(NSDictionary *posts,ResultStatus *status,NSError *error))block;

//banner
- (NSURLSessionDataTask *)GetBannerPicMsgpage:(NSString *)page WithBlock:(void (^)(NSDictionary *posts,ResultStatus *status,NSError *error))block;

//获取星座列表

- (NSURLSessionDataTask *)GetConstellationListBlock:(void (^)(NSDictionary *posts,ResultStatus *status,NSError *error))block;
//根据时间查询所属星座
- (NSURLSessionDataTask *)GetConstellationInfoByTime:(NSString *)time withBlock:(void (^)(NSDictionary *posts,ResultStatus *status,NSError *error))block;
//获取星座描述
- (NSURLSessionDataTask *)GetConstellationDescripById:(NSNumber *)constellationId withBlock:(void (^)(NSDictionary *posts,ResultStatus *status,NSError *error))block;

//随机手相数据
- (NSURLSessionDataTask *)GetConstellationRandomPalmsBlock:(void (^)(NSDictionary *posts,ResultStatus *status,NSError *error))block;

//星座运势
- (NSURLSessionDataTask *)GetConstellationfortuneById:(NSNumber *)constellationId withBlock:(void (^)(NSDictionary *posts,ResultStatus *status,NSError *error))block;

//星座配对
- (NSURLSessionDataTask *)GetConstellationCompareByZFemaleId:(NSNumber *)femaleId MaleId:(NSNumber *)maleId withBlock:(void (^)(NSDictionary *posts,ResultStatus *status,NSError *error))block;

@end
