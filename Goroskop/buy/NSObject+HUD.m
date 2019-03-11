//
//  NSObject+HUD.m
//  BaseProject
//
//  Created by 牛犇 on 15/12/17.
//  Copyright © 2015年 牛犇. All rights reserved.
//

#import "NSObject+HUD.h"

@implementation NSObject (HUD)
//获取当前屏幕的最上方正在显示的那个view
- (UIView *)currentView{
    UIViewController *vc=[UIApplication sharedApplication].keyWindow.rootViewController;
// vc: 导航控制器, 标签控制器, 普通控制器
    if ([vc isKindOfClass:[UITabBarController class]]) {
        vc = [(UITabBarController *)vc selectedViewController];
    }
    if ([vc isKindOfClass:[UINavigationController class]]) {
        vc = [(UINavigationController *)vc visibleViewController];
    }
    return vc.view;
}

/** 弹出文字提示 */
- (void)showAlert:(NSString *)text{
//防止在非主线程中调用此方法,会报错
    dispatch_async(dispatch_get_main_queue(), ^{
        //    弹出新的提示之前,先把旧的隐藏掉
//        [self hideProgress];
        [MBProgressHUD hideHUDForView:[self currentView] animated:YES];
//        [MBProgressHUD hideAllHUDsForView:[self currentView] animated:YES];
        MBProgressHUD *progressHUD=[MBProgressHUD showHUDAddedTo:[self currentView] animated:YES];
        progressHUD.mode = MBProgressHUDModeText;
        progressHUD.label.text = text;
        [progressHUD hideAnimated:YES afterDelay:2];
    });
}

/** 弹出文字提示 */
- (void)showAlert:(NSString *)text inView:(UIView *)view {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //    弹出新的提示之前,先把旧的隐藏掉
        //        [self hideProgress];
        [MBProgressHUD hideHUDForView:view animated:YES];
//        [MBProgressHUD hideAllHUDsForView:view animated:YES];
        MBProgressHUD *progressHUD=[MBProgressHUD showHUDAddedTo:view animated:YES];
        progressHUD.mode = MBProgressHUDModeText;
        progressHUD.label.text = text;
        [progressHUD hideAnimated:YES afterDelay:2];
    });
    
}

/** 显示忙 */
- (void)showBusy{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//        
////        [self hideProgress];
//        [MBProgressHUD hideAllHUDsForView:[self currentView] animated:YES];
//        MBProgressHUD *progressHUD=[MBProgressHUD showHUDAddedTo:[self currentView] animated:YES];
//        
//        progressHUD.mode = MBProgressHUDModeCustomView;
//        
////        UIImage *image = [UIImage animatedImageNamed:@"loading_" duration:1/5.0*5];
//        
//        progressHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loading.png"]];
//        
//        [self transformRotationWithView:progressHUD.customView];
//        
//        progressHUD.color = [UIColor colorWithWhite:1 alpha:0.5];
//        progressHUD.opacity = 0.5;
//        
//        //最长显示30秒
//        [progressHUD hide:YES afterDelay:30];
        
        //        [self hideProgress];
        [MBProgressHUD hideHUDForView:[self currentView] animated:YES];
//        [MBProgressHUD hideAllHUDsForView:[self currentView] animated:YES]; 
        MBProgressHUD *progressHUD=[MBProgressHUD showHUDAddedTo:[self currentView] animated:YES];
        //最长显示30秒
        [progressHUD hideAnimated:YES afterDelay:30];
        
    }];

}

-(void)transformRotationWithView:(UIView *)view
{
    CABasicAnimation *anim = [CABasicAnimation animation];
    anim.keyPath = @"transform.rotation";
    anim.toValue = @(M_PI*2);
    anim.duration = 1.5;
    anim.repeatCount = MAXFLOAT;
    [view.layer addAnimation:anim forKey:nil];
}

/** 显示忙 */
- (void)showBusyInView:(UIView *)view {
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
//        //        [self hideProgress];
//        [MBProgressHUD hideAllHUDsForView:view animated:YES];
//        MBProgressHUD *progressHUD=[MBProgressHUD showHUDAddedTo:view animated:YES];
//        
//        progressHUD.mode = MBProgressHUDModeCustomView;
//        
//        UIImage *image = [UIImage animatedImageNamed:@"loading_" duration:1/8.0*5];
//        
//        progressHUD.customView = [[UIImageView alloc] initWithImage:image];
////        progressHUD.color = [UIColor blackColor];
//        progressHUD.opacity = 0.5;
//        //最长显示30秒
//        [progressHUD hide:YES afterDelay:30];
        
        
        //        [self hideProgress];
        [MBProgressHUD hideHUDForView:view animated:YES];
//        [MBProgressHUD hideAllHUDsForView:view animated:YES];
        MBProgressHUD *progressHUD=[MBProgressHUD showHUDAddedTo:view animated:YES];
        //最长显示30秒
        [progressHUD hideAnimated:YES afterDelay:30];
//        
    }];
}


/** 隐藏提示 */
- (void)hideProgress{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [MBProgressHUD hideHUDForView:[self currentView ] animated:YES];
//        [MBProgressHUD hideAllHUDsForView:[self currentView] animated:YES];
    }];
}

- (void)hideProgressInView:(UIView *)view {
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [MBProgressHUD hideHUDForView:view animated:YES];
//        [MBProgressHUD hideAllHUDsForView:view animated:YES];
    }];
    
}

@end








