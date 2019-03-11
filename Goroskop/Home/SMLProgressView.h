//
//  SMLProgressView.h
//  ShangMenle
//
//  Created by 牛犇 on 16/6/25.
//  Copyright © 2016年 shangmenle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMLProgressView : UIView

/// 百分比 0-1
@property (nonatomic, assign) CGFloat percentage;

/// 进度颜色，默认白色70%不透明度
@property (nonatomic, strong) UIColor *progressColor;

/// 标题
@property (nonatomic, strong) NSString *progressTitle;

/// 标题颜色 默认白色
@property (nonatomic, strong) UIColor *progressTitleColor;

/// 标题字体大小 默认12
@property (nonatomic, assign) NSInteger titleFontSize;

/// 标题 是否显示 百分比, 默认不显示
@property (nonatomic, assign) BOOL isTitleShowPercentTage;

/// 显示
- (void)showProgress;

/// 隐藏
- (void)hiddenProgress;

@end
