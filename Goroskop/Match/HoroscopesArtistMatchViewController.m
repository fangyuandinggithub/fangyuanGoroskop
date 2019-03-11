//
//  MatchViewController.m
//  Constellation
//
//  Created by NGE on 2018/12/12.
//  Copyright © 2018年 NGE. All rights reserved.
//

#import "HoroscopesArtistMatchViewController.h"
#import "YYStarView.h"

@interface HoroscopesArtistMatchViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ScrollViewHeight;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *leftImgView;

@property (weak, nonatomic) IBOutlet UIImageView *rightImgView;
@property (weak, nonatomic) IBOutlet UILabel *leftTitleNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightTitleNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *pariingIndexLabel;
@property (weak, nonatomic) IBOutlet UILabel *pairingWeightLabel;

@property (weak, nonatomic) IBOutlet YYStarView *loveHappniessStar;
@property (weak, nonatomic) IBOutlet YYStarView *everLastStar;
@property (weak, nonatomic) IBOutlet UILabel *adviceLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;


@property (nonatomic, strong) NSDictionary *dataDict;

@property (nonatomic, strong)NSArray *constellationArray;

@property (nonatomic, strong)NSArray *constellationNameArray;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgHeight;

@property (nonatomic, assign)CGFloat height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;

@end

@implementation HoroscopesArtistMatchViewController
- (NSArray *)constellationArray{
    if(!_constellationArray){
        _constellationArray = [NSArray array];
    }
    return _constellationArray;
}
- (NSArray *)constellationNameArray{
    if(!_constellationNameArray){
        _constellationNameArray = [NSArray array];
    }
    return _constellationNameArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
      self.constellationArray = @[@"color-aries ",@"color-capricorn",@"color-gemini ",@"color-cancer",@"color-leo ",@"color-taurus ",@"color-virgo",@"color-libra ",@"color-sagittarius",@"color-capricorn",@"color-aquarius ",@"color-pisces "];
      self.constellationNameArray = @[@"Aries",@"Taurus",@"Gemini",@"Cancer",@"Leo",@"Virge",@"Libra",@"Scorpio",@"Sagittarius",@"Capricorn",@"Aquarius",@"Pisces"];
    [self initData];
    [self addBackItem];
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 10;
    self.scrollView.scrollEnabled = YES;
    if(IS_IPHONE_X){
        self.top.constant = 90;
    }else{
        self.top.constant = 70;
    }
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
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
//    self.ScrollViewHeight.constant = 300 + self.height;
    self.scrollView.contentSize = CGSizeMake(kScreenWidth, 300 + self.height);
    self.bgHeight.constant = 200 + self.height;
   
}

- (void)initData{
    __weak typeof(self) weakSelf = self;
    [self showBusyInView:self.view];
    [[HoroscopesArtistDataManager manager] GetConstellationCompareByZFemaleId:self.feMaleId MaleId:self.maleId withBlock:^(NSDictionary *posts, ResultStatus *status, NSError *error) {
        [weakSelf hideProgressInView:weakSelf.view];
        if([status.code integerValue] == 0 && [status.msg isEqualToString:@"success"]){
            weakSelf.dataDict = posts[@"data"];
            [weakSelf reloadData];
        }
        
    }];
}
- (void)reloadData{
    
    self.leftImgView.image = [UIImage imageNamed:self.constellationArray[[self.maleId intValue] - 1 ]];
    self.rightImgView.image = [UIImage imageNamed:self.constellationArray[[self.feMaleId intValue] - 1]];
    NSString *leftTitle= [NSString stringWithFormat:@"%@",self.constellationNameArray[[self.maleId intValue] - 1]];
    self.leftTitleNameLabel.attributedText = [NSString singleLineStyleWithPara:leftTitle];
   NSString *rightTitle = [NSString stringWithFormat:@"%@",self.constellationNameArray[[self.feMaleId intValue] - 1]];
     self.rightTitleNameLabel.attributedText = [NSString singleLineStyleWithPara:rightTitle];
  
   NSString *pairingIndex  = [NSString stringWithFormat:@"Pair-Index:%@",self.dataDict[@"pair_index"]];
    self.pariingIndexLabel.attributedText = [NSString singleLineStyleWithPara:pairingIndex];

   NSString *pairingWeight  = [NSString stringWithFormat:@"Pair-Weight:%@",[self.dataDict[@"pair_weight"] isEqual:[NSNull null]]  ?@"":self.dataDict[@"pair_weight"] ];
    self.pairingWeightLabel.attributedText = [NSString singleLineStyleWithPara:pairingWeight];
    NSString *loveAdvice = [NSString stringWithFormat:@"love_advice:\n%@",[self.dataDict[@"description"] isEqual:[NSNull null]]  ?@"":self.dataDict[@"description"] ];
    self.adviceLabel.attributedText = [NSString styleWithPara:loveAdvice fontSize:16];
    
    self.height = [NSString getSpaceLabelHeight:loveAdvice withFont:[UIFont systemFontOfSize:18] withWidth:kScreenWidth - 120];
   
   
   self.loveHappniessStar.starScore = [self.dataDict[@"mutual_love_and_happiness_index"] floatValue];
      self.everLastStar.starScore = [self.dataDict[@"everlasting_index"] floatValue];
    
}

- (void)backBtnClick{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
