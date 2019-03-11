//
//  ConstellationDetailViewController.m
//  Goroskop
//
//  Created by NGE on 2018/12/13.
//  Copyright © 2018年 NGE. All rights reserved.
//

#import "ConstellationDetailViewController.h"
#import "FortuneViewController.h"
#import "PureCamera.h"
#import "PurchaseViewController.h"
#import "ConstellationViewController.h"
@interface ConstellationDetailViewController ()<SMLSegmentViewDelegate,UITextViewDelegate>

// 分段控件
@property (nonatomic, strong) SMLSegmentView *segmentedControl;

@property (nonatomic, strong)NSArray *iconArray;

@property (nonatomic, strong)UIImageView *iconImageView;

@property (nonatomic, strong)UILabel *titleLabel;

@property (nonatomic, strong)UILabel *timeLabel;

@property (nonatomic, strong)UITextView *textView;

@property (nonatomic, strong)UIScrollView *scrollView;

@property (nonatomic, strong)NSArray *dataArray;

@end

@implementation ConstellationDetailViewController
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
     self.iconArray = @[@"025-aries",@"033-capricorn",@"027-gemini",@"028-cancer",@"029-leo",@"030-scorpio",@"030-virgo",@"031-libra",@"032-sagittarius",@"033-capricorn",@"035-aquarius",@"036-pisces"];
    [self initData];
    [self initUI];
    [self addBackItem];
    
}


//获取数据
- (void)initData{
    __weak typeof(self) weakSelf = self;
    [self showBusyInView:self.view];
    self.constellationId = [[NSUserDefaults standardUserDefaults] objectForKey:@"constellationId"];
    [[HoroscopesArtistDataManager manager] GetConstellationfortuneById:self.constellationId withBlock:^(NSDictionary *posts, ResultStatus *status, NSError *error) {
        [weakSelf hideProgressInView:weakSelf.view];
        if([status.code integerValue] == 0 && [status.msg isEqualToString:@"success"]){
            weakSelf.dataArray = posts[@"data"][@"details"];
            weakSelf.titleLabel.text = posts[@"data"][@"name"];
            weakSelf.timeLabel.text = [NSString stringWithFormat:@"%@-%@",posts[@"data"][@"start_time"],posts[@"data"][@"end_time"]];
            weakSelf.textView.attributedText = [NSString styleWithPara:weakSelf.dataArray[0][@"detail"] fontSize:18] ;
            weakSelf.textView.textColor = [UIColor whiteColor];
              weakSelf.iconImageView.image = [UIImage imageNamed:self.iconArray[[self.constellationId integerValue] - 1]];
        }
        
        
        
    }];
    
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initData];
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.scrollView.contentSize = CGSizeMake(kScreenWidth, 800);
}
- (void)addBackItem{
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithTitle: nil style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
    item2.image=[UIImage imageNamed:@"back"];
    item2.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = item2;
}
- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark --- 分段控件
- (void)initUI {
    UIImageView *bgImageView = [[UIImageView alloc]init];
    [self.view addSubview:bgImageView];
    bgImageView.image = [UIImage imageNamed:@"bg"];
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    self.scrollView = [[UIScrollView alloc]init];
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(0);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(kScreenHeight);
    }];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.scrollEnabled = YES;
  
    
    UIImageView *iconImageView = [[UIImageView alloc]init];
    self.iconImageView = iconImageView;
    [self.scrollView addSubview:iconImageView];
    iconImageView.image = [UIImage imageNamed:@"025-aries"];
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.top.mas_equalTo(100);
        make.width.height.mas_equalTo(40);
    }];
    UILabel *titleLabel = [[UILabel alloc]init];
    self.titleLabel = titleLabel;
    [self.scrollView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(iconImageView.mas_right).mas_equalTo(10);
        make.centerY.mas_equalTo(iconImageView).mas_equalTo(-15);
    }];
    titleLabel.text = @"Aries";
    titleLabel.font = [UIFont boldSystemFontOfSize:24];
    titleLabel.textColor = [UIColor whiteColor];
    UILabel *timeLabel = [[UILabel alloc]init];
    self.timeLabel = timeLabel;
    [self.scrollView addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(iconImageView.mas_right).mas_equalTo(10);
        make.centerY.mas_equalTo(iconImageView).mas_equalTo(15);
    }];
    timeLabel.text = @"03/21-04/19";
    timeLabel.font = [UIFont systemFontOfSize:20];
    timeLabel.textColor = [UIColor whiteColor];
    //down
    UIButton *downBtn = [[UIButton alloc]init];
    [self.scrollView addSubview:downBtn];
    [downBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-30);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(20);
        make.bottom.mas_equalTo(iconImageView);
    }];
    [downBtn setBackgroundImage:[UIImage imageNamed:@"down"] forState:UIControlStateNormal];
    
    [downBtn addTarget:self action:@selector(downBtnClick) forControlEvents:UIControlEventTouchUpInside];
    NSArray *array = @[@"Today", @"Tomorrow",@"Week",@"Month"];
    self.segmentedControl = [[SMLSegmentView alloc] initWithTitleArray:array];
    self.segmentedControl.delegate = self;
    self.segmentedControl.fontSize = 18;
    self.segmentedControl.textColor = [UIColor whiteColor];
    self.segmentedControl.bottomLineWidth = 72;
    self.segmentedControl.bottomLineColor = [UIColor colorWithRed:184/255.0 green:92/255.0 blue:186/255.0 alpha:1];
    self.segmentedControl.textSelectedColor =  [UIColor colorWithRed:184/255.0 green:92/255.0 blue:186/255.0 alpha:1];
    [self.scrollView addSubview:self.segmentedControl];
    [self.segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(150);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }];
    UIView *moreView = [[UIView alloc]init];
    [self.scrollView addSubview:moreView];
    [moreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.segmentedControl.mas_bottom).mas_equalTo(20);
        make.left.mas_equalTo(10);
        make.width.mas_equalTo(kScreenWidth - 20);
        make.height.mas_equalTo(280);
    }];
    moreView.backgroundColor = [UIColor colorWithWhite:255/255.0 alpha:0.3];
    moreView.layer.masksToBounds = YES;
    moreView.layer.cornerRadius = 8;
    UIButton *moreBtn = [[UIButton alloc]init];
    [self.scrollView addSubview:moreBtn];
    [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.width.height.mas_equalTo(40);
        make.top.mas_equalTo(moreView.mas_bottom).mas_equalTo(-10);
    }];
    [moreBtn setBackgroundImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
    
    [moreBtn addTarget:self action:@selector(moreBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UITextView *textView = [[UITextView alloc]init];
    self.textView = textView;
    [self.scrollView addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.segmentedControl.mas_bottom).mas_equalTo(20);
        make.left.mas_equalTo(10);
        make.width.mas_equalTo(kScreenWidth - 20);
        make.height.mas_equalTo(250);
    }];
    textView.backgroundColor = [UIColor clearColor];
    textView.layer.masksToBounds = YES;
    textView.layer.cornerRadius = 10;
    textView.userInteractionEnabled = YES;
    textView.delegate = self;
    textView.scrollEnabled = YES;
    textView.editable = NO;
    UIView *sacnView = [[UIView alloc]init];
    [self.view addSubview:sacnView];
    [sacnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.width.mas_equalTo(kScreenWidth - 20);
        make.top.mas_equalTo(moreBtn.mas_bottom).mas_equalTo(40);
        make.height.mas_equalTo(120);
    }];
    sacnView.backgroundColor = [UIColor colorWithWhite:255/255.0 alpha:0.3];
    sacnView.layer.masksToBounds = YES;
    sacnView.layer.cornerRadius = 8;
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapView)];
    [sacnView addGestureRecognizer:tapGR];
    //scanBtn
    
    UIButton *scanBtn = [[UIButton alloc]init];
    [sacnView addSubview:scanBtn];
    [scanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.width.height.mas_equalTo(60);
        make.top.mas_equalTo(10);
    }];
    [scanBtn setBackgroundImage:[UIImage imageNamed:@"scan"] forState:UIControlStateNormal];
    scanBtn.tintColor = [UIColor colorWithRed:158/255.0 green:83/255.0 blue:171/255.0 alpha:1];
    
    [scanBtn addTarget:self action:@selector(scanBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    //title
    UILabel *scanTitleLabel = [[UILabel alloc]init];
    [sacnView addSubview:scanTitleLabel];
    [scanTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(30);
        make.left.mas_equalTo(10);
    }];
    scanTitleLabel.text = @"Palm scan";
    scanTitleLabel.textColor = [UIColor whiteColor];
    scanTitleLabel.attributedText = [NSString styleWithPara:@"Palm scan" fontSize:18] ;
    //descrip
    UILabel *scanDescripLabel = [[UILabel alloc]init];
    [sacnView addSubview:scanDescripLabel];
    [scanDescripLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-15);
        make.left.mas_equalTo(10);
    }];
    scanDescripLabel.text = @"See your destiny through a palm scan";
    scanDescripLabel.attributedText = [NSString styleWithPara:@"See your destiny through a palm scan" fontSize:16] ;
    scanDescripLabel.textColor = [UIColor whiteColor];
    
}
- (void)scanBtnClick{
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"isVip"] isEqualToString:@"1"]){
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            PureCamera *homec = [[PureCamera alloc] init];
            __weak typeof(self) myself = self;
            homec.fininshcapture = ^(UIImage *ss) {
                if (ss) {
                    NSLog(@"照片存在");
                    
                }
            };
            [myself presentViewController:homec
                                 animated:NO
                               completion:^{
                               }];
        } else {
            NSLog(@"相机调用失败");
        }
        
    }else{
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        PurchaseViewController *purchase = [story instantiateViewControllerWithIdentifier:@"PurchaseViewController"];
        [self presentViewController:purchase animated:YES completion:nil];
    }
}

- (void)didTapView{
    
}

- (void)moreBtnClick{
    
    FortuneViewController *fortune = [[FortuneViewController alloc]init];
    fortune.constellationId = self.constellationId;
    [self.navigationController pushViewController:fortune animated:YES];
    
}
//选择星座
- (void)downBtnClick{
    ConstellationViewController *constellation = [[ConstellationViewController alloc]init];
    [self presentViewController:constellation animated:YES completion:nil];
    
}
#pragma mark --- SMLSegmentViewDelegate
- (void)segmentView:(SMLSegmentView *)segmentView valueChanged:(NSInteger)index {
    
    
    switch (index) {
            
        case 0:
        {
            self.textView.attributedText = [NSString styleWithPara:self.dataArray[0][@"detail"] fontSize:18] ;
            self.textView.textColor = [UIColor whiteColor];
           
        }
            
            break;
        case 1:
        {
            
            self.textView.attributedText = [NSString styleWithPara:self.dataArray[1][@"detail"] fontSize:18] ;
            self.textView.textColor = [UIColor whiteColor];
        }
            
            break;
        case 2:
        {
            self.textView.attributedText = [NSString styleWithPara:self.dataArray[2][@"detail"] fontSize:18] ;
            self.textView.textColor = [UIColor whiteColor];
        }
            
            break;
        case 3:
        {
            
        }
            self.textView.attributedText = [NSString styleWithPara:self.dataArray[3][@"detail"] fontSize:18] ;
            self.textView.textColor = [UIColor whiteColor];
            break;
            
            
        default:
            break;
    }
}

#pragma mark --- 左右滑动翻页
// 翻到下一页
- (void)gotoNextOrderListState:(UISwipeGestureRecognizer *)gr {
    if (self.segmentedControl.selectedIndex >= 2) {
        return;
    }
    self.segmentedControl.selectedIndex += 1;
    [self performAnimations:kCATransitionFromRight];
}

// 翻到上一页
- (void)gotoLastOrderListState:(UISwipeGestureRecognizer *)gr {
    if (self.segmentedControl.selectedIndex <= 0) {
        return;
    }
    self.segmentedControl.selectedIndex -= 1;
    [self performAnimations:kCATransitionFromLeft];
}

// 设置翻页动画
- (void)performAnimations:(NSString *)transition{
    CATransition *catransition = [CATransition animation];
    catransition.duration = 0.35;
    [catransition setTimingFunction:UIViewAnimationCurveEaseInOut];
    catransition.type = kCATransitionPush; //choose your animation
    catransition.subtype = transition;
   
    
}

@end
