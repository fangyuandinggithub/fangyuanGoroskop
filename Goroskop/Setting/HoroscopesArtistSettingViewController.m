//
//  SettingViewController.m
//  Constellation
//
//  Created by NGE on 2018/12/5.
//  Copyright © 2018年 NGE. All rights reserved.
//

#import "HoroscopesArtistSettingViewController.h"
#import "HoroscopesArtistAgreementViewController.h"
@interface HoroscopesArtistSettingViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIView *termsOfServiceView;
@property (weak, nonatomic) IBOutlet UIView *privacyPolicyView;
@property (weak, nonatomic) IBOutlet UIView *setBgView;

@end

@implementation HoroscopesArtistSettingViewController
- (IBAction)backBtnClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bgImageView.contentMode =  UIViewContentModeScaleAspectFill;
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    self.termsOfServiceView.userInteractionEnabled = YES;
    UITapGestureRecognizer *termsOfServiceTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapTermsOfServiceView)];
    [self.termsOfServiceView addGestureRecognizer:termsOfServiceTap];
    
    self.privacyPolicyView.userInteractionEnabled = YES;
    UITapGestureRecognizer *privacyPolicyTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapPrivacyPolicyView)];
    [self.privacyPolicyView addGestureRecognizer:privacyPolicyTap];
    self.setBgView.layer.masksToBounds = YES;
    self.setBgView.layer.cornerRadius = 10;
    
}
- (void)didTapTermsOfServiceView{
    HoroscopesArtistAgreementViewController *agreement = [[HoroscopesArtistAgreementViewController alloc]init];
    agreement.type = 1;
    agreement.urlStr = @"http://www.kiyjeoub.top/policy/horoscopes&artist/c9bac213/dfy/hor/h9c/TermsofUse.html";
    [self presentViewController:agreement animated:YES completion:nil];
}
- (void)didTapPrivacyPolicyView{
    HoroscopesArtistAgreementViewController *agreement = [[HoroscopesArtistAgreementViewController alloc]init];
    agreement.type = 2;
    agreement.urlStr = @"https://docs.google.com/document/d/1HDmBA1u2SwSjQ88fZqDX8TlNlyKCiJY10oRVsIXmHx8/edit?usp=sharing";
    [self presentViewController:agreement animated:YES completion:nil];
}
- (void)didTapAboutView{
}


@end
