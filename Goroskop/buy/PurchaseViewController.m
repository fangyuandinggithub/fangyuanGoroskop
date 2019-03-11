//
//  PurchaseViewController.m
//  Goroskop
//
//  Created by NGE on 2018/12/18.
//  Copyright © 2018年 NGE. All rights reserved.
//

#import "PurchaseViewController.h"
#import "CUCKOO_IAPManager.h"
#import "HoroscopesArtistAgreementViewController.h"
#import <UIKit/UIKit.h>
#import "HoroscopesArtistDataManager.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <SVProgressHUD.h>
@interface PurchaseViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@property (nonatomic, strong)CUCKOO_IAPManager *manager;

@end

@implementation PurchaseViewController
- (IBAction)closeBtn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
     self.manager = [[CUCKOO_IAPManager alloc]init];
//   self.bgImageView.image = [[NSUserDefaults standardUserDefaults] objectForKey:@"imageData"];
    

  
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *imageFilePath = [path stringByAppendingPathComponent:@"MyImage"];
    UIImage *image = [UIImage imageWithContentsOfFile:imageFilePath];
    if(image){
        self.bgImageView.image = image;
    }else{
           [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:@"http://www.kiyjeoub.top/images/20181218/HoroscopesArtist/main.png"] placeholderImage:[UIImage imageNamed:@""]];
    }

    self.bgImageView.contentMode = UIViewContentModeCenter;
    
      self.bgImageView.transform = CGAffineTransformMakeScale(1.0/3, 1.0/3);
    
 
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    NSString *imageFilePath = [path stringByAppendingPathComponent:@"MyImage"];
//    UIImage *image = [UIImage imageWithContentsOfFile:imageFilePath];
//    if(image){
//        self.bgImageView.image = image;
//    }else{
//
//        [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:@"http://www.kiyjeoub.top/images/20181218/HoroscopesArtist/main.png"] placeholderImage:[UIImage imageNamed:@""]];
//    }
}
- (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize

{
    
    UIGraphicsBeginImageContext(newSize);

    
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
    
}
- (IBAction)buyBtnClick:(id)sender {
    
    [self.manager CUCKOO_startPurchWithID:@"1447599622" completeHandle:^(IAPPurchType type, NSData *data) {
        [SVProgressHUD dismiss];
        NSLog(@"=====%u======%@",type,data);
        if(type == kIAPPurchSuccess || type == KIAPPurchVerSuccess){
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"isVip"];
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self EDITOR_faceBookAnalyticsEvent:YES];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
    }];
}
-(void)EDITOR_faceBookAnalyticsEvent:(BOOL)success{
    static dispatch_once_t disOnce;
    dispatch_once(&disOnce,^ {
        //添加三个记录
        
        [FBSDKAppEvents logPurchase:1 currency:@"USD"];
        
        [FBSDKAppEvents logEvent:FBSDKAppEventNameStartTrial];
        
        [FBSDKAppEvents logEvent:FBSDKAppEventNameSubscribe];
        
    });
}
- (IBAction)pricyBtnClick:(id)sender {
    HoroscopesArtistAgreementViewController *agreement = [[HoroscopesArtistAgreementViewController alloc]init];
    agreement.urlStr = @"http://www.kiyjeoub.top/policy/horoscopes&artist/c9bac213/dfy/hor/h9c/PrivacyPolicy.html";
    [self presentViewController:agreement animated:YES completion:nil];
}

- (IBAction)restore:(id)sender {
    [self.manager CUCKOO_restoreTransactionWithCompleteHandle:^(IAPPurchType type, NSData *data) {
        [SVProgressHUD dismiss];
        NSLog(@"=====%u======%@",type,data);
        if(type == kIAPPurchSuccess || type == KIAPPurchVerSuccess){
            [self showAlert:@"restore success" inView:self.view];
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"isVip"];
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            [self showAlert:@"restore fail" inView:self.view];
        }
    }];
}
- (IBAction)termOfServicesBtnClick:(id)sender {
    
    HoroscopesArtistAgreementViewController *agreement = [[HoroscopesArtistAgreementViewController alloc]init];
    agreement.urlStr = @"http://www.kiyjeoub.top/policy/horoscopes&artist/c9bac213/dfy/hor/h9c/TermsofUse.html";
    [self presentViewController:agreement animated:YES completion:nil];
    
}



@end
