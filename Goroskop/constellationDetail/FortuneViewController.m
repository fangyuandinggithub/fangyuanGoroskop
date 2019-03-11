//
//  FortuneViewController.m
//  Goroskop
//
//  Created by NGE on 2018/12/15.
//  Copyright © 2018年 NGE. All rights reserved.
//

#import "FortuneViewController.h"
#import "RAShareChartView.h"
#import "PurchaseViewController.h"
#import "PairViewController.h"
@interface FortuneViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollHeight;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (nonatomic, assign)NSInteger index;

@property (weak, nonatomic) IBOutlet UIView *randarBgView;

@property (nonatomic, strong)RAShareChartView *chartView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


@property (weak, nonatomic) IBOutlet UIImageView *loveImageView;
@property (weak, nonatomic) IBOutlet UIImageView *friendImageView;
@property (weak, nonatomic) IBOutlet UIImageView *careerImageView;

@property (nonatomic, strong)NSArray *dataArray;

@property (nonatomic, strong)NSArray *iconArray;

@property (nonatomic, strong)NSArray *pairIconArray;

@property (nonatomic, strong)NSMutableArray *randarArray;


@end

@implementation FortuneViewController
- (NSArray *)iconArray{
    if(!_iconArray){
        _iconArray = [NSArray array];
    }
    return _iconArray;
}
- (NSArray *)pairIconArray{
    if(!_pairIconArray){
        _pairIconArray = [NSArray array];
    }
    return _pairIconArray;
}
- (NSArray *)dataArray{
    if(!_dataArray){
        _dataArray = [NSArray array];
    }
    return _dataArray;
}
- (NSMutableArray *)randarArray{
    if(!_randarArray){
        _randarArray = [NSMutableArray array];
    }
    return _randarArray;
}
- (IBAction)backBtnClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.index = 0;
      self.iconArray = @[@"025-aries",@"033-capricorn",@"027-gemini",@"028-cancer",@"029-leo",@"030-scorpio",@"030-virgo",@"031-libra",@"032-sagittarius",@"033-capricorn",@"035-aquarius",@"036-pisces"];
    self.pairIconArray = @[@"color-aries ",@"color-capricorn",@"color-gemini ",@"color-cancer",@"color-leo ",@"color-taurus ",@"color-virgo",@"color-libra ",@"color-sagittarius",@"color-capricorn",@"color-aquarius ",@"color-pisces "];
    self.loveWidth.constant = kScreenWidth/3;
    self.bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self initUI];
    [self initData];
    [self addBackItem];
    
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
//获取数据
- (void)initData{
    __weak typeof(self) weakSelf = self;
    [self showBusyInView:self.view];
    [[HoroscopesArtistDataManager manager] GetConstellationfortuneById:self.constellationId withBlock:^(NSDictionary *posts, ResultStatus *status, NSError *error) {
        [weakSelf hideProgressInView:weakSelf.view];
        if([status.code integerValue] == 0 && [status.msg isEqualToString:@"success"]){
            weakSelf.dataArray = posts[@"data"][@"details"];
            weakSelf.nameLabel.text = posts[@"data"][@"name"];
            weakSelf.timeLabel.text = [NSString stringWithFormat:@"%@-%@",posts[@"data"][@"start_time"],posts[@"data"][@"end_time"]];
            self.iconImageView.image = [UIImage imageNamed:self.iconArray[[self.constellationId integerValue] - 1]];
              [weakSelf reloadDataWithIndex:weakSelf.index];
        }
        
        
        
    }];
    
}
- (void)initUI{
    
    NSArray *array = @[@"Today", @"Tomorrow",@"Week",@"Month"];
    [self.segmentControl initWithItems:array];
 
    [self.segmentControl setTintColor:[UIColor whiteColor]];
    
    //设置选项卡被选中的颜色
    [self.segmentControl setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor orangeColor]} forState:UIControlStateSelected];
    //设置选中的选项卡
    self.segmentControl.selectedSegmentIndex = 0;
    
    [self.segmentControl addTarget:self action:@selector(segmentControlDidChangedValue:) forControlEvents:UIControlEventValueChanged];//注意，这里是UIControlEventValueChanged
    
    
   
    self.randarBgView.layer.masksToBounds = YES;
    self.randarBgView.layer.cornerRadius = 10;
  
    self.loveImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.friendImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.careerImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.chartView = [[RAShareChartView alloc] init];
    [self.randarBgView addSubview:self.chartView];
    [self.chartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    self.chartView.center = self.bgContentView.center;
    
    UITapGestureRecognizer *lovetapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapLoveImageView)];
    self.loveImageView.userInteractionEnabled = YES;
    [self.loveImageView addGestureRecognizer:lovetapGR];
    
    UITapGestureRecognizer *friendtapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapFriendImageView)];
    self.friendImageView.userInteractionEnabled = YES;
    [self.friendImageView addGestureRecognizer:friendtapGR];
    
    self.careerImageView.userInteractionEnabled = YES;
     UITapGestureRecognizer *careertapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapCareerImageView)];
    [self.careerImageView addGestureRecognizer:careertapGR];
    
}
- (void)didTapCareerImageView{
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"isVip"] isEqualToString:@"1"]){
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        PairViewController *pair = [story instantiateViewControllerWithIdentifier:@"PairViewController"];
        pair.feMaleId = self.constellationId;
        pair.maleId = self.dataArray[self.index][@"work"];
          [self.navigationController pushViewController:pair animated:YES];

    }else{
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        PurchaseViewController *purchase = [story instantiateViewControllerWithIdentifier:@"PurchaseViewController"];
        [self presentViewController:purchase animated:YES completion:nil];
    }
}

- (void)didTapFriendImageView{
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"isVip"] isEqualToString:@"1"]){
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        PairViewController *pair = [story instantiateViewControllerWithIdentifier:@"PairViewController"];
        pair.feMaleId = self.constellationId;
        pair.maleId = self.dataArray[self.index][@"friend"];
          [self.navigationController pushViewController:pair animated:YES];
    }else{
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        PurchaseViewController *purchase = [story instantiateViewControllerWithIdentifier:@"PurchaseViewController"];
        [self presentViewController:purchase animated:YES completion:nil];
    }
}

- (void)didTapLoveImageView{
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"isVip"] isEqualToString:@"1"]){
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        PairViewController *pair = [story instantiateViewControllerWithIdentifier:@"PairViewController"];
        pair.feMaleId = self.constellationId;
        pair.maleId = self.dataArray[self.index][@"love"];
        [self.navigationController pushViewController:pair animated:YES];
      
    }else{
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        PurchaseViewController *purchase = [story instantiateViewControllerWithIdentifier:@"PurchaseViewController"];
        [self presentViewController:purchase animated:YES completion:nil];
    }
    
}
- (void)segmentControlDidChangedValue:(UISegmentedControl *)sender
{
    self.index =  sender.selectedSegmentIndex ;
    [self reloadDataWithIndex:self.index];
    if(sender.selectedSegmentIndex == 1 || sender.selectedSegmentIndex == 2 || sender.selectedSegmentIndex == 3){
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"isVip"] isEqualToString:@"1"]){

        }else{
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            PurchaseViewController *purchase = [story instantiateViewControllerWithIdentifier:@"PurchaseViewController"];
            [self presentViewController:purchase animated:YES completion:nil];
        }
    }
    
    
}
- (void)reloadDataWithIndex:(NSInteger)currentIndex{
    NSDictionary *dict = self.dataArray[currentIndex];
    [self.randarArray removeAllObjects];
    [self.randarArray addObject:dict[@"loveStar"]];
     [self.randarArray addObject:dict[@"familyStar"]];
     [self.randarArray addObject:dict[@"healthStar"]];
     [self.randarArray addObject:dict[@"wealthStar"]];
     [self.randarArray addObject:dict[@"totalStar"]];
    self.chartView.scoresArray = self.randarArray;

    NSLog(@"%@===%@===%@========%@",self.pairIconArray[[dict[@"love"] integerValue] - 1],self.pairIconArray[[dict[@"friend"] integerValue] - 1],self.pairIconArray[[dict[@"work"] integerValue] - 1],self.randarArray);
    self.loveImageView.image = [UIImage imageNamed:self.pairIconArray[[dict[@"love"] integerValue] - 1]];
 
    self.friendImageView.image = [UIImage imageNamed:self.pairIconArray[[dict[@"friend"] integerValue] - 1]];
   
    self.careerImageView.image =[UIImage imageNamed:self.pairIconArray[[dict[@"work"] integerValue] - 1]];
    
}

@end
