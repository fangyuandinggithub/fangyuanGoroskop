
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>
#import "HoroscopesArtistDataManager.h"
#define KHost @"www.kiyjeoub.top"
#define packgename @"com.Horoscopes-Artist.Horoscopes-Artist.www"
#define Key @"c9bac213"
//#define KHost @"10.0.2.161:81"
//#define packgename @"www.test.do"
//#define Key @"cd8q4e3t"

@implementation HoroscopesArtistDataManager
+ (instancetype)manager {
    
    static HoroscopesArtistDataManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[HoroscopesArtistDataManager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    if (self = [super init]) {
        
        NSString *baseUrl;
        baseUrl = KHost;
        
         self.httpmanager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:baseUrl]];
        AFHTTPRequestSerializer* serializer = [AFJSONRequestSerializer serializer];
         AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
        self.httpmanager.requestSerializer = serializer;
        self.httpmanager.responseSerializer = responseSerializer;
        [serializer setTimeoutInterval:10];//等待服务器处理时间
    }
    return self;
}
- (NSDictionary *)StringToDic:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
//dic to json
-(NSString *)convertToJsonData:(NSDictionary *)dict
{
NSError *error;
NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
NSString *jsonString;
if (!jsonData) {
    NSLog(@"%@",error);
}else{
jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
}
NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
NSRange range = {0,jsonString.length};
//去掉字符串中的空格
[mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
NSRange range2 = {0,mutStr.length};
//去掉字符串中的换行符
[mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
return mutStr;
}
//base connect
//- (NSURLSessionDataTask *)hubSearchByName:(NSString *)hubName WithBlock:(void (^)(NSArray *posts,ResultStatus *status,NSError *error))block{
////
////
////    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
////    [dic setValue:hubName forKey:@"hubName"];
////    //[dic setValue:chatId forKey:@"chatId"];
////    AFHTTPSessionManager *url = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:KHost]];
////
////    return [url POST:@"app/hubServer/hubSearchByName.do" parameters:dic success:^(NSURLSessionDataTask * __unused task, id JSON) {
////        NSArray *arrayFromResponse = [JSON valueForKey:@"data"];
////        ResultStatus *status = [[ResultStatus alloc] init];
////        status.msg = [JSON valueForKey:@"msg"];
////        status.code = [JSON valueForKey:@"code"];
////        status.data1 = [JSON valueForKey:@"data1"];
////    //
////
////        if (block) {
////            block(arrayFromResponse,status,nil);
////        }
////    }failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
////        if (block) {
////            block([NSArray array],nil,error);
////        }
////    }];
////
//}

//other connect get
- (NSURLSessionDataTask *)GetStickListWithBlock:(void (^)(NSArray *posts,ResultStatus *status,NSError *error))block{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
     NSString *jsonsUrl = [NSString stringWithFormat:@"http://api.giphy.com/v1/stickers/packs"];
    NSMutableDictionary * parameters = [NSMutableDictionary dictionaryWithCapacity:1];

    [parameters setValue:@"Zhg8U9VHwZ3goXNuzyLlhA7zx1SfFSEb" forKey:@"api_key"];

   //@{@"api_key":@"Zhg8U9VHwZ3goXNuzyLlhA7zx1SfFSEb",@"tag": @"burrito", @"fmt": @"json"}
    
    return [manager GET:jsonsUrl parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull JSON) {
    
    
        NSArray *arrayFromResponse = [JSON valueForKey:@"data"];
        ResultStatus *status = [[ResultStatus alloc] init];
        status.msg = [JSON valueForKey:@"msg"];
        status.code = [JSON valueForKey:@"code"];
   
        if (block) {
            block(arrayFromResponse,status,nil);
        }
    }failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block([NSArray array],nil,error);
        }
    }];
}

- (NSURLSessionDataTask *)GetStickInlist:(NSInteger )count WithBlock:(void (^)(NSArray *posts,ResultStatus *status,NSError *error))block{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *jsonsUrl = [NSString stringWithFormat:@"http://api.giphy.com/v1/stickers/packs/%ld/stickers",count];
    NSMutableDictionary * parameters = [NSMutableDictionary dictionaryWithCapacity:1];
    
    [parameters setValue:@"Zhg8U9VHwZ3goXNuzyLlhA7zx1SfFSEb" forKey:@"api_key"];
    [parameters setValue:@(1)  forKey:@"pack_id"];
    [parameters setValue:@(20) forKey:@"limit"  ];
    [parameters setValue:@(5)  forKey:@"offset" ];
    
    //@{@"api_key":@"Zhg8U9VHwZ3goXNuzyLlhA7zx1SfFSEb",@"tag": @"burrito", @"fmt": @"json"}
    
    return [manager GET:jsonsUrl parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull JSON) {
        
        
        NSArray *arrayFromResponse = [JSON valueForKey:@"data"];
        ResultStatus *status = [[ResultStatus alloc] init];
        status.msg = [JSON valueForKey:@"msg"];
        status.code = [JSON valueForKey:@"code"];
        status.datadic= [JSON valueForKey:@"data"];
        if (block) {
            block(arrayFromResponse,status,nil);
        }
    }failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block([NSArray array],nil,error);
        }
    }];
}
- (NSURLSessionDataTask *)GetStickInlist:(NSInteger )count Page:(NSInteger )Page WithBlock:(void (^)(NSArray *posts,ResultStatus *status,NSError *error))block{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *jsonsUrl = [NSString stringWithFormat:@"http://api.giphy.com/v1/stickers/packs/%ld/stickers",count];
    NSMutableDictionary * parameters = [NSMutableDictionary dictionaryWithCapacity:1];
    NSInteger Limit=20*Page;
    [parameters setValue:@"Zhg8U9VHwZ3goXNuzyLlhA7zx1SfFSEb" forKey:@"api_key"];
    [parameters setValue:@(1)  forKey:@"pack_id"];
    [parameters setValue:@(Limit) forKey:@"limit"  ];
    [parameters setValue:@(5)  forKey:@"offset" ];
    
    //@{@"api_key":@"Zhg8U9VHwZ3goXNuzyLlhA7zx1SfFSEb",@"tag": @"burrito", @"fmt": @"json"}
    
    return [manager GET:jsonsUrl parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull JSON) {
        
        
        NSArray *arrayFromResponse = [JSON valueForKey:@"data"];
        ResultStatus *status = [[ResultStatus alloc] init];
        status.msg = [JSON valueForKey:@"msg"];
        status.code = [JSON valueForKey:@"code"];
        status.datadic= [JSON valueForKey:@"data"];
        if (block) {
            block(arrayFromResponse,status,nil);
        }
    }failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block([NSArray array],nil,error);
        }
    }];
}   
//2.4最新 壁纸 - 分页
- (NSURLSessionDataTask *)GetNewPicMsg:(NSString *)page WithBlock:(void (^)(NSArray *posts,ResultStatus *status,NSError *error))block{
    NSMutableDictionary * parameters = [NSMutableDictionary dictionaryWithCapacity:1];
    [parameters setValue:packgename forKey:@"pkg"];
    [parameters setValue:page forKey:@"page"];
    
    AFHTTPSessionManager *url = [[AFHTTPSessionManager alloc] init];
    url.requestSerializer = [AFJSONRequestSerializer serializer];
    url.responseSerializer = [AFHTTPResponseSerializer serializer];
    url.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"text/html",@"application/json",@"text/javascript",@"text/json",@"text/plain",@"charset=UTF-8", nil];
    url.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    
    NSString *dicstr=[self convertToJsonData:parameters];
    NSString *jsons = [NSString stringWithFormat:@"http://%@/core/wp/v1/getnewlist",KHost];
    
    return [url POST:jsons parameters:dicstr success:^(NSURLSessionDataTask * __unused task, id JSON) {
        
        
        NSData *base64Data = [[NSData alloc] initWithBase64EncodedData:JSON
                                                               options:NSDataBase64DecodingIgnoreUnknownCharacters];
        
        NSString *cipherText = [[NSString alloc] initWithData:base64Data
                                                     encoding:NSUTF8StringEncoding];
        NSString *result2 = [self decryptUseDES:cipherText
                                            key:Key];
        NSDictionary *ResultDic=[self StringToDic:result2];
        NSArray *arrayFromResponse= [ResultDic valueForKey:@"data"];
        ResultStatus *status = [[ResultStatus alloc] init];
        status.msg = [ResultDic valueForKey:@"msg"];
        status.code = [ResultDic valueForKey:@"code"];
        status.data = [ResultDic valueForKey:@"data"];
        
        
        if (block) {
            block(arrayFromResponse,status,nil);
        }
    }failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block([NSArray array],nil,error);
        }
    }];
    
}
//获取banner
- (NSURLSessionDataTask *)GetBannerPicMsgpage:(NSString *)page WithBlock:(void (^)(NSDictionary *posts,ResultStatus *status,NSError *error))block{
    NSMutableDictionary * parameters = [NSMutableDictionary dictionaryWithCapacity:1];
    [parameters setValue:packgename forKey:@"pkg"];
    [parameters setValue:page forKey:@"version"];
    
    AFHTTPSessionManager *url = [[AFHTTPSessionManager alloc] init];
    url.requestSerializer = [AFJSONRequestSerializer serializer];
    url.responseSerializer = [AFHTTPResponseSerializer serializer];
    url.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"text/html",@"application/json",@"text/javascript",@"text/json",@"text/plain",@"charset=UTF-8", nil];
    url.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    
    NSString *dicstr=[self convertToJsonData:parameters];
     NSString *jsons = [NSString stringWithFormat:@"http://%@/core/wp/v1/getnewlist",KHost];
    
    return [url POST:jsons parameters:dicstr success:^(NSURLSessionDataTask * __unused task, id JSON) {
        
        
        NSData *base64Data = [[NSData alloc] initWithBase64EncodedData:JSON
                                                               options:NSDataBase64DecodingIgnoreUnknownCharacters];
        
        NSString *cipherText = [[NSString alloc] initWithData:base64Data
                                                     encoding:NSUTF8StringEncoding];
        NSString *result2 = [self decryptUseDES:cipherText
                                            key:Key];
        NSDictionary *ResultDic=[self StringToDic:result2];
        //        NSArray *arrayFromResponse= [ResultDic valueForKey:@"data"];
        ResultStatus *status = [[ResultStatus alloc] init];
        status.msg = [ResultDic valueForKey:@"description"];
        status.code = [ResultDic valueForKey:@"status"];
        status.data = [ResultDic valueForKey:@"free_trial_description_one"];
        
        
        if (block) {
            block(ResultDic,status,nil);
        }
    }failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block([NSDictionary dictionary],nil,error);
        }
    }];
    
}
//2.3最流行壁纸 - 分页
- (NSURLSessionDataTask *)GetPopularPicMsgpage:(NSString *)page WithBlock:(void (^)(NSDictionary *posts,ResultStatus *status,NSError *error))block{
    NSMutableDictionary * parameters = [NSMutableDictionary dictionaryWithCapacity:1];
    [parameters setValue:packgename forKey:@"pkg"];
    [parameters setValue:page forKey:@"version"];
   
    AFHTTPSessionManager *url = [[AFHTTPSessionManager alloc] init];
    url.requestSerializer = [AFJSONRequestSerializer serializer];
    url.responseSerializer = [AFHTTPResponseSerializer serializer];
    url.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"text/html",@"application/json",@"text/javascript",@"text/json",@"text/plain",@"charset=UTF-8", nil];
    url.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    
    NSString *dicstr=[self convertToJsonData:parameters];
    NSString *jsons = [NSString stringWithFormat:@"http://%@/core/version/v2/fetch",KHost];
    
    return [url POST:jsons parameters:dicstr success:^(NSURLSessionDataTask * __unused task, id JSON) {
        
        
        NSData *base64Data = [[NSData alloc] initWithBase64EncodedData:JSON
                                                               options:NSDataBase64DecodingIgnoreUnknownCharacters];
        
        NSString *cipherText = [[NSString alloc] initWithData:base64Data
                                                     encoding:NSUTF8StringEncoding];
        NSString *result2 = [self decryptUseDES:cipherText
                                            key:Key];
        NSDictionary *ResultDic=[self StringToDic:result2];
//        NSArray *arrayFromResponse= [ResultDic valueForKey:@"data"];
        ResultStatus *status = [[ResultStatus alloc] init];
        status.msg = [ResultDic valueForKey:@"description"];
        status.code = [ResultDic valueForKey:@"status"];
        status.data = [ResultDic valueForKey:@"free_trial_description_one"];
        
        
        if (block) {
            block(ResultDic,status,nil);
        }
    }failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block([NSDictionary dictionary],nil,error);
        }
    }];
    
}
// pkg + cid + page 获取壁纸 - 分页
- (NSURLSessionDataTask *)GetClassPicMsg:(NSString *)cid page:(NSString *)page WithBlock:(void (^)(NSArray *posts,ResultStatus *status,NSError *error))block{
    NSMutableDictionary * parameters = [NSMutableDictionary dictionaryWithCapacity:1];
    [parameters setValue:packgename forKey:@"pkg"];
    [parameters setValue:page forKey:@"page"];
    [parameters setValue:cid forKey:@"cid"];
    AFHTTPSessionManager *url = [[AFHTTPSessionManager alloc] init];
    url.requestSerializer = [AFJSONRequestSerializer serializer];
    url.responseSerializer = [AFHTTPResponseSerializer serializer];
    url.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"text/html",@"application/json",@"text/javascript",@"text/json",@"text/plain",@"charset=UTF-8", nil];
    url.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    
    NSString *dicstr=[self convertToJsonData:parameters];
    NSString *jsons = [NSString stringWithFormat:@"http://%@/core/wp/v1/pkgcidpage",KHost];
    
    return [url POST:jsons parameters:dicstr success:^(NSURLSessionDataTask * __unused task, id JSON) {
        
        
        NSData *base64Data = [[NSData alloc] initWithBase64EncodedData:JSON
                                                               options:NSDataBase64DecodingIgnoreUnknownCharacters];
        
        NSString *cipherText = [[NSString alloc] initWithData:base64Data
                                                     encoding:NSUTF8StringEncoding];
        NSString *result2 = [self decryptUseDES:cipherText
                                            key:Key];
        NSDictionary *ResultDic=[self StringToDic:result2];
        NSArray *arrayFromResponse= [ResultDic valueForKey:@"data"];
        ResultStatus *status = [[ResultStatus alloc] init];
        status.msg = [ResultDic valueForKey:@"msg"];
        status.code = [ResultDic valueForKey:@"code"];
        status.data = [ResultDic valueForKey:@"data"];
        
        
        if (block) {
            block(arrayFromResponse,status,nil);
        }
    }failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block([NSArray array],nil,error);
        }
    }];
    
}

- (NSURLSessionDataTask *)GetPicClass:(NSString *)page pk:(NSString *)pkg WithBlock:(void (^)(NSArray *posts,ResultStatus *status,NSError *error))block{
     NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    //NSMutableDictionary * parameters = [NSMutableDictionary dictionaryWithCapacity:1];
    [parameters setValue:packgename forKey:@"pkg"];
    AFHTTPSessionManager *url = [[AFHTTPSessionManager alloc] init];
    //-1016或者会有编码问题
    url.requestSerializer = [AFJSONRequestSerializer serializer];
    ///不设置会报 error 3840
    url.responseSerializer = [AFHTTPResponseSerializer serializer];
    //可怕的接口
    url.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/javascript",@"text/json",@"text/plain",@"charset=UTF-8", nil];
    //不设置会：什么也不发生
    url.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];

    NSString *dicstr=[self convertToJsonData:parameters];
     NSString *jsons = [NSString stringWithFormat:@"http://%@/core/wp/v1/wpctg",KHost];
 
    return [url POST:jsons parameters:dicstr success:^(NSURLSessionDataTask * __unused task, id JSON) {

  
        NSData *base64Data = [[NSData alloc] initWithBase64EncodedData:JSON
                                                               options:NSDataBase64DecodingIgnoreUnknownCharacters];
        
        NSString *cipherText = [[NSString alloc] initWithData:base64Data
                                                     encoding:NSUTF8StringEncoding];
        NSString *result2 = [self decryptUseDES:cipherText
                                                   key:Key];
        NSDictionary *ResultDic=[self StringToDic:result2];
        NSArray *arrayFromResponse= [ResultDic valueForKey:@"data"];
        ResultStatus *status = [[ResultStatus alloc] init];
        status.msg = [ResultDic valueForKey:@"msg"];
        status.code = [ResultDic valueForKey:@"code"];
        status.data = [ResultDic valueForKey:@"data"];
   
        
        if (block) {
            block(arrayFromResponse,status,nil);
        }
    }failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block([NSArray array],nil,error);
        }
    }];
 
}
- (NSURLSessionDataTask *)GetStoreAes:(NSString *)version WithBlock:(void(^)(NSDictionary *response,ResultStatus *status,NSError *error))block{
    // {"pkg":"com.colorful.wallpaper","type":0,"cid":0,"page":1,"num":1,"limit":6}
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
 
    [dic setValue:version forKey:@"version"];
    [dic setValue:packgename forKey:@"pkg"];
    
    AFHTTPSessionManager *url = [[AFHTTPSessionManager alloc] init];
    url.requestSerializer=[AFJSONRequestSerializer serializer];
    url.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"text/html",@"application/json",@"text/javascript",@"text/json",@"text/plain",@"charset=UTF-8", nil];
    // NSString *jsons = [self convertToJsonData:dic];
    NSString *jsons = [NSString stringWithFormat:@"http://%@/Bolsk/wieor",KHost];
    return [url POST:jsons parameters:dic success:^(NSURLSessionDataTask * __unused task, id JSON) {
       // NSData *jsonData = [[self decryptUseAES:[JSON valueForKey:@"data"]] dataUsingEncoding:NSUTF8StringEncoding];
      //  NSDictionary *arrayFromResponse = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *arrayFromResponse ;
        //=[self dictionaryWithJsonString:[self decryptUseAES:[JSON valueForKey:@"data"]]];
    //    NSLog(@"9999%@",[self decryptUseAES:[JSON valueForKey:@"data"]]);
        //arrayFromResponse=arrayFromResponse[0];
        ResultStatus *status = [[ResultStatus alloc] init];
        status.msg = [JSON valueForKey:@"msg"];
        status.code =  [JSON valueForKey:@"code"];
        
        
    
  //  status.data =  [self decryptUseAES:[JSON valueForKey:@"data"]];
      
      
        
        if (block) {
            block(arrayFromResponse,status,nil);
        }
    }failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block([NSDictionary dictionary],nil,error);
        }
    }];
    
}


- (NSString*)decryptUseAES:(NSString *)content
                       key:(NSString *)key{
    // 利用 GTMBase64 解碼 Base64 字串
    NSData *cipherData = [[NSData alloc] initWithBase64EncodedString:content
                                                             options:0];
    unsigned char buffer[1024 * 100];
    memset(buffer, 0, sizeof(char));
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding,
                                          [key UTF8String],
                                          kCCKeySizeAES128,
                                          //[@"01234567" UTF8String],
                                          NULL,
                                          [cipherData bytes],
                                          [cipherData length],
                                          buffer,
                                          1024 * 100,
                                          &numBytesDecrypted);
    NSString* plainText = nil;
    if (cryptStatus == kCCSuccess) {
        NSData* data = [NSData dataWithBytes:buffer
                                      length:(NSUInteger)numBytesDecrypted];
        plainText = [[NSString alloc] initWithData:data
                                          encoding:NSUTF8StringEncoding];
        
    }
    return plainText;
}


//DES加密
- (NSString *) encryptUseDES:(NSString *)plainText
                         key:(NSString *)key {
    NSData *plainData = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding|kCCOptionECBMode,
                                          [key UTF8String],
                                          kCCKeySizeDES,
                                          NULL,
                                          [plainData bytes],
                                          [plainData length],
                                          buffer,
                                          1024,
                                          &numBytesEncrypted);
    NSString *ciphertext = nil;
    if (cryptStatus == kCCSuccess) {
        NSData *data = [NSData dataWithBytes:buffer
                                      length:(NSUInteger)numBytesEncrypted];
        ciphertext = [self convertDataToHexStr:data];
        ciphertext = [ciphertext uppercaseString];
    }
    return ciphertext;
    
}

//DES加密
- (NSString *) encryptUseDESString:(NSString *)plainText
                               key:(NSString *)key {
    NSData *plainData = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding|kCCOptionECBMode,
                                          [key UTF8String],
                                          kCCKeySizeDES,
                                          NULL,
                                          [plainData bytes],
                                          [plainData length],
                                          buffer,
                                          1024,
                                          &numBytesEncrypted);
    NSString *ciphertext = nil;
    if (cryptStatus == kCCSuccess) {
        NSData *data = [NSData dataWithBytes:buffer
                                      length:(NSUInteger)numBytesEncrypted];
        ciphertext = [self convertDataToHexStr:data];
        ciphertext = [ciphertext uppercaseString];
        
        NSData *cipherdData = [[ciphertext dataUsingEncoding:NSUTF8StringEncoding] base64EncodedDataWithOptions: NSDataBase64Encoding64CharacterLineLength];
        ciphertext = [[NSString alloc] initWithData:cipherdData encoding:NSUTF8StringEncoding];
    }
    return ciphertext;
    
}


//DES解密
- (NSString *)decryptUseDES:(NSString*)cipherText
                        key:(NSString*)key {
    NSData* cipherData = [self convertHexStrToData:cipherText];
    unsigned char buffer[1024 * 128];
    memset(buffer, 0, sizeof(char));
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding|kCCOptionECBMode,
                                          [key UTF8String],
                                          kCCKeySizeDES,
                                          NULL,
                                          [cipherData bytes],
                                          [cipherData length],
                                          buffer,
                                          1024 * 128,
                                          &numBytesDecrypted);
    NSString* plainText = nil;
    if (cryptStatus == kCCSuccess) {
        NSData* data = [NSData dataWithBytes:buffer
                                      length:(NSUInteger)numBytesDecrypted];
        
        plainText = [[NSString alloc] initWithData:data
                                          encoding:NSUTF8StringEncoding];
    }
    return plainText;
}

//DES解密
- (NSString *)decryptUseDESData:(NSData*)data
                            key:(NSString*)key {
    NSData *base64Data = [[NSData alloc] initWithBase64EncodedData:data
                                                           options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSString *cipherText = [[NSString alloc] initWithData:base64Data
                                                 encoding:NSUTF8StringEncoding];
    NSData* cipherData = [self convertHexStrToData:cipherText];
    unsigned char buffer[1024 * 1000];
    memset(buffer, 0, sizeof(char));
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding|kCCOptionECBMode,
                                          [key UTF8String],
                                          kCCKeySizeDES,
                                          NULL,
                                          [cipherData bytes],
                                          [cipherData length],
                                          buffer,
                                          1024 * 1024,
                                          &numBytesDecrypted);
    NSString* plainText = nil;
    if (cryptStatus == kCCSuccess) {
        NSData* data = [NSData dataWithBytes:buffer
                                      length:(NSUInteger)numBytesDecrypted];
        plainText = [[NSString alloc] initWithData:data
                                          encoding:NSUTF8StringEncoding];
        
    }
    return plainText;
}



//将NSData转成16进制
- (NSString *)convertDataToHexStr:(NSData *)data {
    if (!data || [data length] == 0) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    return string;
    
}

//将16进制字符串转成NSData
- (NSData *)convertHexStrToData:(NSString *)str {
    if (!str || [str length] == 0) {
        return nil;
    }
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:8];
    NSRange range;
    if ([str length] % 2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [str length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [str substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        range.location += range.length; range.length = 2;
    }
    return hexData;
}

- (void)files {
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray<NSURL *> * urls = [manager URLsForDirectory:NSDocumentationDirectory
                                              inDomains:NSAllDomainsMask];
    NSLog(@"URLs: %@", urls);
}
- (NSURLSessionDataTask *)GetRestore:(NSString *)Uid WithBlock:(void(^)(NSDictionary *posts,ResultStatus *status,NSError *error))block{
    
    
    
    NSMutableDictionary * parameters = [NSMutableDictionary dictionaryWithCapacity:1];
    [parameters setValue:packgename forKey:@"pkg"];
    [parameters setValue:[self getUUIDfromKeychain] forKey:@"uid"];
     NSLog(@"购买后%@",[self getUUIDfromKeychain] );
    AFHTTPSessionManager *url = [[AFHTTPSessionManager alloc] init];
    //-1016或者会有编码问题
    url.requestSerializer = [AFJSONRequestSerializer serializer];
    ///不设置会报 error 3840
    url.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    url.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/javascript",@"text/json",@"text/plain",@"charset=UTF-8", nil];
    //不设置会：什么也不发生
    url.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    
    NSString *dicstr=[self convertToJsonData:parameters];
    NSString *jsons = [NSString stringWithFormat:@"http://%@/core/order/v1/getinfo",KHost];
    
    return [url POST:jsons parameters:dicstr success:^(NSURLSessionDataTask * __unused task, id JSON) {
        
        
        NSData *base64Data = [[NSData alloc] initWithBase64EncodedData:JSON
                                                               options:NSDataBase64DecodingIgnoreUnknownCharacters];
        
        NSString *cipherText = [[NSString alloc] initWithData:base64Data
                                                     encoding:NSUTF8StringEncoding];
        NSString *result2 = [self decryptUseDES:cipherText
                                            key:Key];
        NSDictionary *ResultDic=[self StringToDic:result2];
        //NSArray *arrayFromResponse= [ResultDic valueForKey:@"data"];
        ResultStatus *status = [[ResultStatus alloc] init];
        status.msg = [ResultDic valueForKey:@"msg"];
        status.code = [ResultDic valueForKey:@"code"];
        status.data = [ResultDic valueForKey:@"data"];
        
        
        if (block) {
            block(ResultDic,status,nil);
        }
    }failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block([NSDictionary dictionary],nil,error);
        }
    }];
    
    
}
- (NSURLSessionDataTask *)InsertRestore:(NSString *)Uid WithBlock:(void(^)(NSDictionary *posts,ResultStatus *status,NSError *error))block{
    
    NSMutableDictionary * parameters2 = [NSMutableDictionary dictionaryWithCapacity:1];
    [parameters2 setValue:packgename forKey:@"pkg"];
    [parameters2 setValue:[self getUUIDfromKeychain] forKey:@"uid"];
    NSLog(@"购买前%@",[self getUUIDfromKeychain] );
    NSString *JsonData= [self convertToJsonData:parameters2];
    JsonData=[self base64EncodeString:JsonData];
    NSLog(@"%@",[self getUUIDfromKeychain]);
    NSMutableDictionary * parameters = [NSMutableDictionary dictionaryWithCapacity:1];
    [parameters setValue:packgename forKey:@"pkg"];
    [parameters setValue:JsonData forKey:@"msg"];
    AFHTTPSessionManager *url = [[AFHTTPSessionManager alloc] init];
    //-1016或者会有编码问题
    url.requestSerializer = [AFJSONRequestSerializer serializer];
    ///不设置会报 error 3840
    url.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    url.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/javascript",@"text/json",@"text/plain",@"charset=UTF-8", nil];
    //不设置会：什么也不发生
    url.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    
    NSString *dicstr=[self convertToJsonData:parameters];
    NSString *jsons = [NSString stringWithFormat:@"http://%@/core/order/v1/setinfo",KHost];
    
    return [url POST:jsons parameters:dicstr success:^(NSURLSessionDataTask * __unused task, id JSON) {
        
        
        NSData *base64Data = [[NSData alloc] initWithBase64EncodedData:JSON
                                                               options:NSDataBase64DecodingIgnoreUnknownCharacters];
        
        NSString *cipherText = [[NSString alloc] initWithData:base64Data
                                                     encoding:NSUTF8StringEncoding];
        NSString *result2 = [self decryptUseDES:cipherText
                                            key:Key];
        NSDictionary *ResultDic=[self StringToDic:result2];
        //NSArray *arrayFromResponse= [ResultDic valueForKey:@"data"];
        ResultStatus *status = [[ResultStatus alloc] init];
        status.msg = [ResultDic valueForKey:@"msg"];
        status.code = [ResultDic valueForKey:@"code"];
        status.data = [ResultDic valueForKey:@"data"];
        
        if (block) {
            block(ResultDic,status,nil);
        }
    }failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block([NSDictionary dictionary],nil,error);
        }
    }];
}

- (NSMutableDictionary *)getKeychainQuery:(NSString *)service
{
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (__bridge id)(kSecClassGenericPassword), kSecClass,
            service, kSecAttrService,
            service, kSecAttrAccount,
            kSecAttrAccessibleAfterFirstUnlock, kSecAttrAccessible,
            nil];
}

// 保存数据到keychain中
- (BOOL)saveDate:(id)date withService:(NSString *)service
{
    // 1. 创建dictonary
    NSMutableDictionary * keychainQuery = [self getKeychainQuery:service];
    // 2. 先删除
    SecItemDelete((CFDictionaryRef)keychainQuery);
    // 3. 添加到date到query中
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:date] forKey:(id<NSCopying>)kSecValueData];
    // 4. 存储到到keychain中
    OSStatus status = SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
    
    return status == noErr ? YES : NO;
}

// 从keychain中查找数据
- (id)searchDateWithService:(NSString *)service
{
    id retsult = nil;
    NSMutableDictionary * keychainQuery = [self getKeychainQuery:service];
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id<NSCopying>)kSecReturnData];
    [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id<NSCopying>)kSecMatchLimit];
    
    CFTypeRef resultDate = NULL;
    if (SecItemCopyMatching((CFDictionaryRef)keychainQuery, &resultDate)== noErr) {
        @try{
            retsult = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)resultDate];
        }
        @catch(NSException *e){
            NSLog(@"查找数据不存在");
        }
        @finally{
            
        }
    }
    if (resultDate) {
        CFRelease(resultDate);
    }
    return retsult;
}

// 更新keychain中的数据
- (BOOL)updateDate:(id)date withService:(NSString *)service
{
    NSMutableDictionary * searchDictonary = [self getKeychainQuery:service];
    
    if (!searchDictonary) {return  NO;}
    
    NSMutableDictionary * updateDictonary = [NSMutableDictionary dictionary];
    [updateDictonary setObject:[NSKeyedArchiver archivedDataWithRootObject:date] forKey:(id<NSCopying>)kSecValueData];
    OSStatus status = SecItemUpdate((CFDictionaryRef)searchDictonary, (CFDictionaryRef)updateDictonary);
    return status == noErr ? YES : NO;
}

// 删除keychain中的数据
- (BOOL)deleteDateiWithService:(NSString *)service
{
    NSMutableDictionary * keychainQuery = [self getKeychainQuery:service];
    OSStatus status = SecItemDelete((CFDictionaryRef)keychainQuery);
    return status == noErr ? YES : NO;
}
/**
 先从keychain里面加载uuid 如果没有 就获取uuid并加载到keychain中
 */
- (NSString *)getUUIDfromKeychain
{
    NSString * uuid = NULL;
    uuid = [self searchDateWithService:Key];
    if (uuid) {
        return uuid;
    }else{
        uuid = [self getRandomUUID];
        if([self saveDate:uuid withService:Key]){
            return uuid;
        }else{
            return NULL;
        }
    }
}

- (NSString *)getRandomUUID
{
    return [NSUUID UUID].UUIDString;
}
- (NSString *)base64EncodeString:(NSString *)string

{
    
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    return [data base64EncodedStringWithOptions:0];
    
}

//获取星座列表
- (NSURLSessionDataTask *)GetConstellationListBlock:(void (^)(NSDictionary *posts,ResultStatus *status,NSError *error))block{
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:packgename forKey:@"pkg"];
    AFHTTPSessionManager *url = [[AFHTTPSessionManager alloc] init];
    //-1016或者会有编码问题
    url.requestSerializer = [AFJSONRequestSerializer serializer];
    ///不设置会报 error 3840
    url.responseSerializer = [AFHTTPResponseSerializer serializer];
    //可怕的接口
    url.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/javascript",@"text/json",@"text/plain",@"charset=UTF-8", nil];
    //不设置会：什么也不发生
    url.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    
    NSString *dicstr=[self convertToJsonData:parameters];
    NSString *jsons = [NSString stringWithFormat:@"http://%@/core/cons/v1/fconshpd",KHost];
    
    return [url POST:jsons parameters:dicstr success:^(NSURLSessionDataTask * __unused task, id JSON) {
        
        
        NSData *base64Data = [[NSData alloc] initWithBase64EncodedData:JSON
                                                               options:NSDataBase64DecodingIgnoreUnknownCharacters];
        
        NSString *cipherText = [[NSString alloc] initWithData:base64Data
                                                     encoding:NSUTF8StringEncoding];
        NSString *result2 = [self decryptUseDES:cipherText
                                            key:Key];
        NSDictionary *ResultDic=[self StringToDic:result2];
        ResultStatus *status = [[ResultStatus alloc] init];
        status.msg = [ResultDic valueForKey:@"msg"];
        status.code = [ResultDic valueForKey:@"code"];
        status.data = [ResultDic valueForKey:@"data"];
        
        
        if (block) {
            block(ResultDic,status,nil);
        }
    }failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block([NSDictionary dictionary],nil,error);
        }
    }];
    
}
//根据时间查询所属星座

- (NSURLSessionDataTask *)GetConstellationInfoByTime:(NSString *)time withBlock:(void (^)(NSDictionary *posts,ResultStatus *status,NSError *error))block{
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:packgename forKey:@"pkg"];
    [parameters setValue:time forKey:@"time"];
    AFHTTPSessionManager *url = [[AFHTTPSessionManager alloc] init];
    //-1016或者会有编码问题
    url.requestSerializer = [AFJSONRequestSerializer serializer];
    ///不设置会报 error 3840
    url.responseSerializer = [AFHTTPResponseSerializer serializer];
    //可怕的接口
    url.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/javascript",@"text/json",@"text/plain",@"charset=UTF-8", nil];
    //不设置会：什么也不发生
    url.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    
    NSString *dicstr=[self convertToJsonData:parameters];
    NSString *jsons = [NSString stringWithFormat:@"http://%@/core/cons/v1/qconsbt",KHost];
    
    return [url POST:jsons parameters:dicstr success:^(NSURLSessionDataTask * __unused task, id JSON) {
        
        
        NSData *base64Data = [[NSData alloc] initWithBase64EncodedData:JSON
                                                               options:NSDataBase64DecodingIgnoreUnknownCharacters];
        
        NSString *cipherText = [[NSString alloc] initWithData:base64Data
                                                     encoding:NSUTF8StringEncoding];
        NSString *result2 = [self decryptUseDES:cipherText
                                            key:Key];
        NSDictionary *ResultDic=[self StringToDic:result2];
        ResultStatus *status = [[ResultStatus alloc] init];
        status.msg = [ResultDic valueForKey:@"msg"];
        status.code = [ResultDic valueForKey:@"code"];
        status.data = [ResultDic valueForKey:@"data"];
        
        
        if (block) {
            block(ResultDic,status,nil);
        }
    }failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block([NSDictionary dictionary],nil,error);
        }
    }];
    
}


//获取星座描述
- (NSURLSessionDataTask *)GetConstellationDescripById:(NSNumber *)constellationId withBlock:(void (^)(NSDictionary *posts,ResultStatus *status,NSError *error))block{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:packgename forKey:@"pkg"];
    [parameters setValue:constellationId forKey:@"id"];
    AFHTTPSessionManager *url = [[AFHTTPSessionManager alloc] init];
    //-1016或者会有编码问题
    url.requestSerializer = [AFJSONRequestSerializer serializer];
    ///不设置会报 error 3840
    url.responseSerializer = [AFHTTPResponseSerializer serializer];
    //可怕的接口
    url.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/javascript",@"text/json",@"text/plain",@"charset=UTF-8", nil];
    //不设置会：什么也不发生
    url.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    
    NSString *dicstr=[self convertToJsonData:parameters];
    NSString *jsons = [NSString stringWithFormat:@"http://%@/core/cons/v1/fconsdes",KHost];
    
    return [url POST:jsons parameters:dicstr success:^(NSURLSessionDataTask * __unused task, id JSON) {
        
        
        NSData *base64Data = [[NSData alloc] initWithBase64EncodedData:JSON
                                                               options:NSDataBase64DecodingIgnoreUnknownCharacters];
        
        NSString *cipherText = [[NSString alloc] initWithData:base64Data
                                                     encoding:NSUTF8StringEncoding];
        NSString *result2 = [self decryptUseDES:cipherText
                                            key:Key];
        NSDictionary *ResultDic=[self StringToDic:result2];
        ResultStatus *status = [[ResultStatus alloc] init];
        status.msg = [ResultDic valueForKey:@"msg"];
        status.code = [ResultDic valueForKey:@"code"];
        status.data = [ResultDic valueForKey:@"data"];
        
        
        if (block) {
            block(ResultDic,status,nil);
        }
    }failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block([NSDictionary dictionary],nil,error);
        }
    }];
    
}

//随机手相数据
- (NSURLSessionDataTask *)GetConstellationRandomPalmsBlock:(void (^)(NSDictionary *posts,ResultStatus *status,NSError *error))block{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:packgename forKey:@"pkg"];
    AFHTTPSessionManager *url = [[AFHTTPSessionManager alloc] init];
    //-1016或者会有编码问题
    url.requestSerializer = [AFJSONRequestSerializer serializer];
    ///不设置会报 error 3840
    url.responseSerializer = [AFHTTPResponseSerializer serializer];
    //可怕的接口
    url.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/javascript",@"text/json",@"text/plain",@"charset=UTF-8", nil];
    //不设置会：什么也不发生
    url.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    
    NSString *dicstr=[self convertToJsonData:parameters];
    NSString *jsons = [NSString stringWithFormat:@"http://%@/core/conspal/v1/fconsp",KHost];
    
    return [url POST:jsons parameters:dicstr success:^(NSURLSessionDataTask * __unused task, id JSON) {
        
        
        NSData *base64Data = [[NSData alloc] initWithBase64EncodedData:JSON
                                                               options:NSDataBase64DecodingIgnoreUnknownCharacters];
        
        NSString *cipherText = [[NSString alloc] initWithData:base64Data
                                                     encoding:NSUTF8StringEncoding];
        NSString *result2 = [self decryptUseDES:cipherText
                                            key:Key];
        NSDictionary *ResultDic=[self StringToDic:result2];
        ResultStatus *status = [[ResultStatus alloc] init];
        status.msg = [ResultDic valueForKey:@"msg"];
        status.code = [ResultDic valueForKey:@"code"];
        status.data = [ResultDic valueForKey:@"data"];
        
        
        if (block) {
            block(ResultDic,status,nil);
        }
    }failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block([NSDictionary dictionary],nil,error);
        }
    }];
}

//星座运势
- (NSURLSessionDataTask *)GetConstellationfortuneById:(NSNumber *)constellationId withBlock:(void (^)(NSDictionary *posts,ResultStatus *status,NSError *error))block{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:constellationId forKey:@"id"];
    [parameters setValue:packgename forKey:@"pkg"];
    
    AFHTTPSessionManager *url = [[AFHTTPSessionManager alloc] init];
    //-1016或者会有编码问题
    url.requestSerializer = [AFJSONRequestSerializer serializer];
    ///不设置会报 error 3840
    url.responseSerializer = [AFHTTPResponseSerializer serializer];
    //可怕的接口
    url.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/javascript",@"text/json",@"text/plain",@"charset=UTF-8", nil];
    //不设置会：什么也不发生
    url.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    
    NSString *dicstr=[self convertToJsonData:parameters];
    NSString *jsons = [NSString stringWithFormat:@"http://%@/core/cons/v1/fortune",KHost];
    
    return [url POST:jsons parameters:dicstr success:^(NSURLSessionDataTask * __unused task, id JSON) {
        
        
        NSData *base64Data = [[NSData alloc] initWithBase64EncodedData:JSON
                                                               options:NSDataBase64DecodingIgnoreUnknownCharacters];
        
        NSString *cipherText = [[NSString alloc] initWithData:base64Data
                                                     encoding:NSUTF8StringEncoding];
        NSString *result2 = [self decryptUseDES:cipherText
                                            key:Key];
        NSDictionary *ResultDic=[self StringToDic:result2];
        ResultStatus *status = [[ResultStatus alloc] init];
        status.msg = [ResultDic valueForKey:@"msg"];
        status.code = [ResultDic valueForKey:@"code"];
        status.data = [ResultDic valueForKey:@"data"];
        
        
        if (block) {
            block(ResultDic,status,nil);
        }
    }failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block([NSDictionary dictionary],nil,error);
        }
    }];
}

//星座配对
- (NSURLSessionDataTask *)GetConstellationCompareByZFemaleId:(NSNumber *)femaleId MaleId:(NSNumber *)maleId withBlock:(void (^)(NSDictionary *posts,ResultStatus *status,NSError *error))block{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:femaleId forKey:@"femaleId"];
    [parameters setValue:maleId forKey:@"maleId"];
    [parameters setValue:packgename forKey:@"pkg"];
    
    AFHTTPSessionManager *url = [[AFHTTPSessionManager alloc] init];
    //-1016或者会有编码问题
    url.requestSerializer = [AFJSONRequestSerializer serializer];
    ///不设置会报 error 3840
    url.responseSerializer = [AFHTTPResponseSerializer serializer];
    //可怕的接口
    url.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/javascript",@"text/json",@"text/plain",@"charset=UTF-8", nil];
    //不设置会：什么也不发生
    url.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    
    NSString *dicstr=[self convertToJsonData:parameters];
        NSString *jsons = [NSString stringWithFormat:@"http://%@/core/cons/v1/match",KHost];

    
    return [url POST:jsons parameters:dicstr success:^(NSURLSessionDataTask * __unused task, id JSON) {
        
        
        NSData *base64Data = [[NSData alloc] initWithBase64EncodedData:JSON
                                                               options:NSDataBase64DecodingIgnoreUnknownCharacters];
        
        NSString *cipherText = [[NSString alloc] initWithData:base64Data
                                                     encoding:NSUTF8StringEncoding];
        NSString *result2 = [self decryptUseDES:cipherText
                                            key:Key];
        NSDictionary *ResultDic=[self StringToDic:result2];
        ResultStatus *status = [[ResultStatus alloc] init];
        status.msg = [ResultDic valueForKey:@"msg"];
        status.code = [ResultDic valueForKey:@"code"];
        status.data = [ResultDic valueForKey:@"data"];
        
        
        if (block) {
            block(ResultDic,status,nil);
        }
    }failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block([NSDictionary dictionary],nil,error);
        }
    }];
}
@end
