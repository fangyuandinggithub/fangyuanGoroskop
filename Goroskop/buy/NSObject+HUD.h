//
//  NSObject+HUD.h
//  BaseProject
//
//  Created by 牛犇 on 15/12/17.
//  Copyright © 2015年 牛犇. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MBProgressHUD.h>

@interface NSObject (HUD)

/** 弹出文字提示 */
- (void)showAlert:(NSString *)text;

/** 弹出文字提示 */
- (void)showAlert:(NSString *)text inView:(UIView *)view;

/** 显示忙 */
- (void)showBusy;

/** 显示忙 */
- (void)showBusyInView:(UIView *)view;
/** 隐藏提示 */
- (void)hideProgress;

- (void)hideProgressInView:(UIView *)view;

@end











