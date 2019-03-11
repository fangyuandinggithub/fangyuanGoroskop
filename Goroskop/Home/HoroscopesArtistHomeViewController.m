//
//  HomeViewController.m
//  Goroskop
//
//  Created by NGE on 2018/12/13.
//  Copyright © 2018年 NGE. All rights reserved.
//

#import "HoroscopesArtistHomeViewController.h"
#import "WSDatePickerView.h"
#import "HoroscopesArtistSettingViewController.h"
#import "ConstellationDetailViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "DHGuidePageHUD.h"
#import "PurchaseViewController.h"
#import "CCDraggableContainer.h"
#import "CustomCardView.h"
@interface HoroscopesArtistHomeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,CCDraggableContainerDataSource,
CCDraggableContainerDelegate>

@property (nonatomic, strong) CCDraggableContainer *container;

@property (nonatomic, strong) NSMutableArray *dataSources;

@property (nonatomic, strong)NSArray *imgNameArray;

@property (nonatomic, strong)NSArray *dataArray;

@property (nonatomic, strong)NSArray *iconArray;

@property (nonatomic, assign) CGFloat offer;

@property (nonatomic, assign)NSInteger index;

@property (nonatomic, strong)NSString *notiNetInfo;

@property (nonatomic, strong)NSArray *nameArray;

@property (nonatomic, strong)UIButton *chooseBrithdayBtn;

@property (nonatomic, strong)UIView *line;


@end

@implementation HoroscopesArtistHomeViewController
- (NSArray *)imgNameArray{
    if(!_imgNameArray){
        _imgNameArray = [NSArray array];
    }
    return _imgNameArray;
}
- (NSArray *)iconArray{
    if(!_iconArray){
        _iconArray = [NSArray array];
    }
    return _iconArray;
}
- (NSArray *)dataArray{
    if(!_dataArray){
        _dataArray = [NSArray array];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //facebook统计
//    [self  EDITOR_faceBookAnalyticsEvent:YES];
    self.imgNameArray = @[@"aries",@"taurus",@"gemini",@"cancer",@"lion",@"zodiac",@"scale",@"scorpion",@"sagittarius",@"capricorn",@"aquarius",@"fish"];
    self.nameArray = @[@"Aries",@"Taurus",@"Gemini",@"Cancer",@"Lion",@"Zodiac",@"Scale",@"Scorpion",@"Sagittarius",@"Capricorn",@"Aquarius",@"Fish"];
    self.iconArray = @[@"color-aries ",@"color-capricorn",@"color-gemini ",@"color-cancer",@"color-leo ",@"color-taurus ",@"color-virgo",@"color-libra ",@"color-sagittarius",@"color-capricorn",@"color-aquarius ",@"color-pisces "];
    //设置导航栏透明
    [self.navigationController.navigationBar setTranslucent:true];
    //把背景设为空
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    //处理导航栏有条线的问题
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],
                                                                      NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold" size:20]}];
    self.title = @"Choose  Constellation";
    self.index = 0;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNetWorkInfo:) name:@"receiveNetInfo" object:nil];
    [self addRightItem];
     [self buildUI];
     [self initData];
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"isVip"] isEqualToString:@"1"]){
        
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"isHidden"];
       [self setStaticGuidePage];
    }
   
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"isHidden"] isEqualToString:@"YES"]){
        self.navigationController.navigationBarHidden = YES;
    }else{
         self.navigationController.navigationBarHidden = NO;
    }
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)addRightItem{
    UIBarButtonItem *settingItem = [[UIBarButtonItem alloc] initWithTitle: nil style:UIBarButtonItemStylePlain target:self action:@selector(settingBtnClick)];
    settingItem.image=[UIImage imageNamed:@"set"];
    settingItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = settingItem;
    
}
- (void)settingBtnClick{
    HoroscopesArtistSettingViewController *set = [[HoroscopesArtistSettingViewController alloc]init];
    [self presentViewController:set animated:YES completion:nil];
    
}
#pragma mark - 设置APP静态图片引导页
- (void)setStaticGuidePage {
  
    DHGuidePageHUD *guidePage = [[DHGuidePageHUD alloc] dh_initWithFrame:self.view.frame videoURL:[NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:@"flower"ofType:@"mp4"]]];
    [guidePage setBlock:^{
        if([self.notiNetInfo isEqualToString:@"NO"]){
            [self showAlert:@"Please check the network" inView:self.view];
            return ;
        }
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *imageFilePath = [path stringByAppendingPathComponent:@"MyImage"];
        UIImage *image = [UIImage imageWithContentsOfFile:imageFilePath];
        if(image){
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            PurchaseViewController *purchase = [story instantiateViewControllerWithIdentifier:@"PurchaseViewController"];
            [self presentViewController:purchase animated:YES completion:nil];
            [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"isHidden"];
        }
      
       
     
    }];
    guidePage.slideInto = YES;
    [self.view addSubview:guidePage];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"receiveNetInfo" object:nil];
}
//接收网络检测发来的通知
- (void)receiveNetWorkInfo:(NSNotification *)noti {
    if([noti.userInfo[@"notiNetInfo"] isEqualToString:@"NO"]){
        self.notiNetInfo = @"NO";
       
        [self showAlert:@"Please check the network" inView:self.view];
        
    }else if ([noti.userInfo[@"notiNetInfo"] isEqualToString:@"YES"]){
        
        self.notiNetInfo = @"YES";
         [self initData];
    }
    
     [[NSUserDefaults standardUserDefaults] setObject:self.notiNetInfo forKey:@"notiNetInfo"];
    
    
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
//获取数据
- (void)initData{
    __weak typeof(self) weakSelf = self;
    [self showBusyInView:self.view];
    [[HoroscopesArtistDataManager manager] GetConstellationListBlock:^(NSDictionary *posts, ResultStatus *status, NSError *error) {
        [weakSelf hideProgressInView:weakSelf.view];
        if([status.code integerValue] == 0 && [status.msg isEqualToString:@"success"]){
            weakSelf.dataArray = posts[@"data"];
            [weakSelf loadData];
        }
    }];
    
}
-(void)buildUI
{
    self.view.backgroundColor = [UIColor clearColor];
    UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:bgImageView];
    bgImageView.image = [UIImage imageNamed:@"bg"];
    bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.container = [[CCDraggableContainer alloc] initWithFrame:CGRectMake(0, 120, CCWidth, CCHeight*0.7) style:CCDraggableStyleUpOverlay];
    self.container.delegate = self;
    self.container.dataSource = self;
    self.container.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.container];
    // 重启加载
    [self.container reloadData];
    
    self.chooseBrithdayBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - 100, self.view.frame.size.height - 70, 200, 30)];
    [self.view addSubview:self.chooseBrithdayBtn];
    [self.chooseBrithdayBtn setTitle:@"Choose your birthday~?" forState:UIControlStateNormal];
    [self.chooseBrithdayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.chooseBrithdayBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.chooseBrithdayBtn addTarget:self action:@selector(chooseBrithday) forControlEvents:UIControlEventTouchUpInside];
    self.line = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - 100, CGRectGetMaxY(self.chooseBrithdayBtn.frame)+5, 200, 1)];
    [self.view addSubview:self.line];
    self.line.backgroundColor = [UIColor whiteColor];

}


- (void)chooseBrithday{
    //年-月-日-时-分
    WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowMonthDay CompleteBlock:^(NSDate *selectDate) {
        
        NSString *dateString = [selectDate stringWithFormat:@"MM-dd"];
        //测试数据
        [self showBusyInView:self.view];
        [[HoroscopesArtistDataManager manager] GetConstellationInfoByTime:dateString withBlock:^(NSDictionary *posts, ResultStatus *status, NSError *error) {
            [self hideProgressInView:self.view];
            ConstellationDetailViewController *detail = [[ConstellationDetailViewController alloc]init];
            detail.constellationId = posts[@"data"][0][@"id"];
            [self.navigationController pushViewController:detail animated:YES];
            
        }];
        
        NSLog(@"选择的日期：%@",dateString);
        
    }];
    [self.view addSubview:datepicker];
    datepicker.dateLabelColor = [UIColor whiteColor];;//年-月-日-时-分 颜色
    datepicker.datePickerColor = [UIColor whiteColor];//滚轮日期颜色
    datepicker.doneButtonColor = [UIColor clearColor];//确定按钮的颜色
    [datepicker show];
}




- (void)loadData {
    
    _dataSources = [NSMutableArray array];
    
    for (int i = 0; i < self.imgNameArray.count; i++) {
        NSDictionary *dict = @{@"image" : self.imgNameArray[i],
                               @"title" : self.nameArray[i],
                               @"iconImage" : self.iconArray[i],
                               @"time" : [NSString stringWithFormat:@"%@-%@",self.dataArray[i][@"start_time"],self.dataArray[i][@"end_time"]]
                               };
        [_dataSources addObject:dict];
    }
}

#pragma mark - CCDraggableContainer DataSource

- (CCDraggableCardView *)draggableContainer:(CCDraggableContainer *)draggableContainer viewForIndex:(NSInteger)index {
    
    CustomCardView *cardView = [[CustomCardView alloc] initWithFrame:draggableContainer.bounds];
    [cardView installData:[_dataSources objectAtIndex:index]];
    return cardView;
}

- (NSInteger)numberOfIndexs {
    return _dataSources.count;
}

#pragma mark - CCDraggableContainer Delegate

- (void)draggableContainer:(CCDraggableContainer *)draggableContainer draggableDirection:(CCDraggableDirection)draggableDirection widthRatio:(CGFloat)widthRatio heightRatio:(CGFloat)heightRatio {
    
    CGFloat scale = 1 + ((kBoundaryRatio > fabs(widthRatio) ? fabs(widthRatio) : kBoundaryRatio)) / 4;
    if (draggableDirection == CCDraggableDirectionLeft) {
        // self.disLikeButton.transform = CGAffineTransformMakeScale(scale, scale);
    }
    if (draggableDirection == CCDraggableDirectionRight) {
        // self.likeButton.transform = CGAffineTransformMakeScale(scale, scale);
    }
}

- (void)draggableContainer:(CCDraggableContainer *)draggableContainer cardView:(CCDraggableCardView *)cardView didSelectIndex:(NSInteger)didSelectIndex {
    ConstellationDetailViewController *detail = [[ConstellationDetailViewController alloc]init];
    [[NSUserDefaults standardUserDefaults] setObject:self.dataArray[didSelectIndex][@"id"] forKey:@"constellationId"];
    [self.navigationController pushViewController:detail animated:YES];
    NSLog(@"点击了Tag为%ld的Card", (long)didSelectIndex);
}

- (void)draggableContainer:(CCDraggableContainer *)draggableContainer finishedDraggableLastCard:(BOOL)finishedDraggableLastCard {
    
    [draggableContainer reloadData];
}
@end
