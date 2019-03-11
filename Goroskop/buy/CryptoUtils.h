//
//  CryptoUtils.h
//  OCTest
//
//  Created by wenqiang on 2018/8/7.
//  Copyright © 2018年 wenqiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CryptoUtils : NSObject

//AES解密
+ (NSString*)decryptUseAES:(NSString *)content
                       key:(NSString *)key;

//DES加密
+ (NSString *) encryptUseDES:(NSString *)plainText
                         key:(NSString *)key;


//DES解密
+ (NSString *) decryptUseDES:(NSString*)cipherText
                         key:(NSString*)key;


@end

