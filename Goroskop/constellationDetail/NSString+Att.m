//
//  NSString+Att.m
//  分离字符串
//
//  Created by zhuchenglong on 16/7/27.
//  Copyright © 2016年 zhuchenglong. All rights reserved.
//

#import "NSString+Att.h"

@implementation NSString (Att)

/*
 string:               全部文本
 highlightSign:        开始高亮的标记
 length                开始高亮的文本后面的长度
 highlightColor        高亮的颜色
 */
+(NSMutableAttributedString *)string:(NSString *)string highlightSign:(NSString *)highlightString length:(NSInteger)length highlightColor:(UIColor *)highlightColor{
    
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc]initWithString:string];
    
    NSRange highLightRange = NSMakeRange([[attString string]rangeOfString:highlightString].location,length);
    
    [attString addAttribute:NSForegroundColorAttributeName value:highlightColor range:highLightRange];
    
    return attString;
}

/*
 string:               全部文本
 fromIndex:            从第几个开始高亮(从0开始)
 length                开始高亮的文本后面的长度
 highlightColor        高亮的颜色
 */
+(NSMutableAttributedString *)string:(NSString *)string fromIndex:(NSInteger)fromIndex length:(NSInteger)length highlightColor:(UIColor *)highlightColor{
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:string];
    
    NSRange highLightRange = NSMakeRange(fromIndex,length);
    
    [attString addAttribute:NSForegroundColorAttributeName value:highlightColor range:highLightRange];
    
    return attString;
    
}


/*
 string:               全部文本
 highlightString:      高亮的文本
 highlightColor        高亮的颜色
 highlightFont         高亮字体
 */
+(NSMutableAttributedString *)string:(NSString *)string highlightString:(NSString *)highlightString highlightColor:(UIColor *)highlightColor highlightFont:(CGFloat)highlightFont{
    
    
    NSMutableAttributedString *att =[[NSMutableAttributedString alloc]initWithString:string];
    NSRange range = [string rangeOfString:highlightString];
    [att addAttribute:NSForegroundColorAttributeName value:[UIColor redColor]range:range];
    [att addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:highlightFont]range:range];
    
    return att;
}

//获取文本内容的长度
- (CGFloat)getWidthWithFont:(CGFloat)textFont{
    
    //如果没有设置vc的title，设置抛异常
    if ([self isKindOfClass:[NSNull class]]) {
        NSException *exception = [NSException exceptionWithName:@"NSString+AttributeException" reason:@"未设置对应的title属性" userInfo:nil];
        [exception raise];
    }
    
    CGRect titleBounds = [self boundingRectWithSize:CGSizeMake(MAXFLOAT, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:textFont]} context:nil];
    
    return titleBounds.size.width;
}


//删除号码中的空格和横线(方法一)
+(NSString *)deleteSpace:(NSString *)telephoneNum{
    //处理电话号码中的空格
    NSString *telephoneStr1 = [telephoneNum stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    //处理号码中的 -
    NSString *telephoneStr2 = [telephoneStr1 stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    return telephoneStr2;
}

//过滤字符串中的特殊符号(方法二)
+(NSString *)deleteCustomSign:(NSString *)string{
    
    //定义一个特殊字符的集合
    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"@／：；（）¥「」＂‘、! ;[]{}#%-*+=_\\|~＜＞$€^•'@#$%^&*()_+'\""];
    
    //stringByTrimmingCharactersInSet能做到的仅仅是把字符串两端的非法字符过滤，但是包含在字符串里非法字符则无能为力。
    NSString *newString = [[string componentsSeparatedByCharactersInSet:characterSet]componentsJoinedByString:@""];
    
    return newString;
}
+ (NSAttributedString *)styleWithPara:(NSString *)paraStr fontSize:(NSInteger)fontsize{
    NSMutableParagraphStyle*paraStyle = [[NSMutableParagraphStyle alloc]init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentJustified;
    paraStyle.lineSpacing = 10;//设置行间距
    paraStyle.firstLineHeadIndent = 14.0;//首行缩进
    paraStyle.paragraphSpacingBefore= 10.0;//段首行空白空间
//    paraStyle.headIndent=10.0;//头部缩进，相当于左padding首行除外
//    paraStyle.tailIndent= -10.0;//相当于右padding
    NSDictionary*dic =@{NSFontAttributeName:[UIFont systemFontOfSize:fontsize],NSParagraphStyleAttributeName:paraStyle,NSKernAttributeName:@1.5f};
    NSAttributedString *attributeStr  = [[NSAttributedString alloc]initWithString:paraStr attributes:dic];
    
    return attributeStr;
}

+ (CGFloat)getSpaceLabelHeight:(NSString*)str withFont:(UIFont*)font withWidth:(CGFloat)width {
    
    NSMutableParagraphStyle*paraStyle = [[NSMutableParagraphStyle alloc]init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentJustified;
    paraStyle.lineSpacing = 10;//设置行间距
    paraStyle.firstLineHeadIndent = 14.0;//首行缩进
    paraStyle.paragraphSpacingBefore=5.0;//段首行空白空间
    paraStyle.headIndent=10.0;//头部缩进，相当于左padding首行除外
    paraStyle.tailIndent= -10.0;//相当于右padding
    
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle
                          };
    CGSize size = [str boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    
    return  ceilf(size.height);
    
}
+ (NSAttributedString *)singleLineStyleWithPara:(NSString *)paraStr{
    NSMutableParagraphStyle*paraStyle = [[NSMutableParagraphStyle alloc]init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentJustified;
    NSDictionary*dic =@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSParagraphStyleAttributeName:paraStyle,NSKernAttributeName:@1.5f};
    NSAttributedString *attributeStr  = [[NSAttributedString alloc]initWithString:paraStr attributes:dic];
    
    return attributeStr;
}

+ (NSAttributedString *)singleLineStyleWithPara:(NSString *)paraStr fontSize:(NSInteger)fontsize{
    NSMutableParagraphStyle*paraStyle = [[NSMutableParagraphStyle alloc]init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentJustified;
    NSDictionary*dic =@{NSFontAttributeName:[UIFont systemFontOfSize:fontsize],NSParagraphStyleAttributeName:paraStyle,NSKernAttributeName:@1.5f};
    NSAttributedString *attributeStr  = [[NSAttributedString alloc]initWithString:paraStr attributes:dic];
    
    return attributeStr;
}
@end
