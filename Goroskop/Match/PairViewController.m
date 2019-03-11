//
//  PairViewController.m
//  Goroskop
//
//  Created by NGE on 2018/12/19.
//  Copyright © 2018年 NGE. All rights reserved.
//

#import "PairViewController.h"
#import "ConstellationViewController.h"
#import "HoroscopesArtistMatchViewController.h"
@interface PairViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *loveImageView;
@property (weak, nonatomic) IBOutlet UIButton *calculationBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *grilNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *grilConstellationNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *girlConstellationImageView;
@property (weak, nonatomic) IBOutlet UILabel *boyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *boyConstellationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *boyConstellationImageView;

@property (nonatomic, assign)BOOL isMatch;

@property (nonatomic, strong)NSArray *pairIconArray;

@end

@implementation PairViewController
- (NSArray *)pairIconArray{
    if(!_pairIconArray){
        _pairIconArray = [NSArray array];
    }
    return _pairIconArray;
}
- (IBAction)CalculationBtnClick:(id)sender {
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HoroscopesArtistMatchViewController *match = [story instantiateViewControllerWithIdentifier:@"HoroscopesArtistMatchViewController"];
    match.feMaleId = self.feMaleId;
    match.maleId = self.maleId;
    [self.navigationController pushViewController:match animated:YES];
}
- (IBAction)backBtnClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)initData{
    __weak typeof(self) weakSelf = self;
    [self showBusyInView:self.view];
    [[HoroscopesArtistDataManager manager] GetConstellationCompareByZFemaleId:self.feMaleId MaleId:self.maleId withBlock:^(NSDictionary *posts, ResultStatus *status, NSError *error) {
        [weakSelf hideProgressInView:weakSelf.view];
        if([status.code integerValue] == 0 && [status.msg isEqualToString:@"success"]){
            weakSelf.grilConstellationNameLabel.attributedText = [NSString singleLineStyleWithPara:posts[@"data"][@"female_name"] fontSize:18];
            weakSelf.boyConstellationLabel.attributedText = [NSString singleLineStyleWithPara:posts[@"data"][@"male_name"] fontSize:18];
        }
        
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.pairIconArray = @[@"color-aries ",@"color-capricorn",@"color-gemini ",@"color-cancer",@"color-leo ",@"color-taurus ",@"color-virgo",@"color-libra ",@"color-sagittarius",@"color-capricorn",@"color-aquarius ",@"color-pisces "];
    self.title = @"Constellation matching";
    self.calculationBtn.layer.masksToBounds = YES;
    self.calculationBtn.layer.cornerRadius = 10;
    self.calculationBtn.layer.borderWidth = 1;
    self.calculationBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.titleLabel.attributedText = [NSString singleLineStyleWithPara:@"Constellation matching" fontSize:20];
    self.grilNameLabel.attributedText = [NSString singleLineStyleWithPara:@"Girl" fontSize:18];
    self.boyNameLabel.attributedText = [NSString singleLineStyleWithPara:@"Boy" fontSize:18];
    UITapGestureRecognizer *grilConstellationTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapGrilConstellationView)];
    self.girlConstellationImageView.userInteractionEnabled = YES;
    [self.girlConstellationImageView addGestureRecognizer:grilConstellationTap];
    UITapGestureRecognizer *boyConstellationTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapBoyConstellationView)];
    self.boyConstellationImageView.userInteractionEnabled = YES;
    [self.boyConstellationImageView addGestureRecognizer:boyConstellationTap];
   
 
//    [self initData];
    [self addBackItem];
   
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor],
                                                                      NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold" size:20]}];
    if(self.isMatch){
        self.feMaleId = [[NSUserDefaults standardUserDefaults] objectForKey:@"feMaleId"];
        self.maleId = [[NSUserDefaults standardUserDefaults] objectForKey:@"maleId"];
    }
    self.girlConstellationImageView.image = [UIImage imageNamed:self.pairIconArray[[self.feMaleId intValue] - 1 ]];
    self.boyConstellationImageView.image = [UIImage imageNamed:self.pairIconArray[[self.maleId intValue] - 1 ]];
    [self initData];
    [self customAnimation];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],
                                                                      NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold" size:20]}];
}
- (void)addBackItem{
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithTitle: nil style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
    item2.image=[UIImage imageNamed:@"pairBack"];
    item2.tintColor = [UIColor blackColor];
    self.navigationItem.leftBarButtonItem = item2;
}
- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didTapGrilConstellationView{
    ConstellationViewController *constellation = [[ConstellationViewController alloc]init];
    constellation.feMaleId = self.feMaleId;
    constellation.maleId = self.maleId;
    constellation.isGril = YES;
    constellation.isMatch = YES;
    self.isMatch = YES;
    [self presentViewController:constellation animated:YES completion:nil];
    
}

- (void)didTapBoyConstellationView{
    ConstellationViewController *constellation = [[ConstellationViewController alloc]init];
    constellation.feMaleId = self.feMaleId;
    constellation.maleId = self.maleId;
    constellation.isGril = NO;
    constellation.isMatch = YES;
    self.isMatch = YES;
    [self presentViewController:constellation animated:YES completion:nil];
    
}
- (void)customAnimation{
    CABasicAnimation *animation =  [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    //默认是顺时针效果，若将fromValue和toValue的值互换，则为逆时针效果
    animation.fromValue = [NSNumber numberWithFloat:0.f];
    animation.toValue =  [NSNumber numberWithFloat: M_PI*2 ];
    animation.duration  = 4;
    animation.autoreverses = NO;
    animation.fillMode =kCAFillModeForwards;
    animation.repeatCount = MAXFLOAT; //如果这里想设置成一直自旋转，可以设置为MAXFLOAT，否则设置具体的数值则代表执行多少次
    [self.loveImageView.layer addAnimation:animation forKey:nil];
}

@end
