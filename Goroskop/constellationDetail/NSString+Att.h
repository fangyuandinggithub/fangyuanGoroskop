//
//  NSString+Att.h
//  分离字符串
//
//  Created by zhuchenglong on 16/7/27.
//  Copyright © 2016年 zhuchenglong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSString (Att)


/*
 string:               全部文本
 highlightSign:        开始高亮的标记
 length                开始高亮的文本后面的长度
 highlightColor        高亮的颜色
 */
+(NSMutableAttributedString *)string:(NSString *)string highlightSign:(NSString *)highlightString length:(NSInteger)length highlightColor:(UIColor *)highlightColor;



/*
 string:               全部文本
 fromIndex:            从第几个开始高亮(从0开始)
 length                开始高亮的文本后面的长度
 color
 highlightColor        高亮的颜色
 */
+(NSMutableAttributedString *)string:(NSString *)string fromIndex:(NSInteger)fromIndex length:(NSInteger)length highlightColor:(UIColor *)highlightColor;


/*
 string:               全部文本
 highlightString:      高亮的文本
 highlightColor        高亮的颜色
 highlightFont         高亮字体
 */
+(NSMutableAttributedString *)string:(NSString *)string highlightString:(NSString *)highlightString highlightColor:(UIColor *)highlightColor highlightFont:(CGFloat)highlightFont;


//根据字体大小获取某段文本内容的宽度
- (CGFloat)getWidthWithFont:(CGFloat)textFont;


//过滤字符串中的特殊符号(方法一)
+(NSString *)deleteSpace:(NSString *)telephoneNum;


//过滤字符串中的特殊符号(方法二)
+(NSString *)deleteCustomSign:(NSString *)string;

+ (NSAttributedString *)styleWithPara:(NSString *)paraStr fontSize:(NSInteger)fontsize;

+ (CGFloat)getSpaceLabelHeight:(NSString*)str withFont:(UIFont*)font withWidth:(CGFloat)width;

+ (NSAttributedString *)singleLineStyleWithPara:(NSString *)paraStr;

+ (NSAttributedString *)singleLineStyleWithPara:(NSString *)paraStr fontSize:(NSInteger)fontsize;
@end
