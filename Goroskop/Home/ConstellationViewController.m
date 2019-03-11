//
//  ConstellationViewController.m
//  Constellation
//
//  Created by NGE on 2018/12/5.
//  Copyright © 2018年 NGE. All rights reserved.
//

#import "ConstellationViewController.h"
#import "ConstellationCollectionViewCell.h"
#import "WSDatePickerView.h"
#import "HoroscopesArtistDataManager.h"
#import "HoroscopesArtistSettingViewController.h"
#import "DHGuidePageHUD.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "ConstellationDetailViewController.h"
#import "PairViewController.h"
@interface ConstellationViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) UIButton *closeBtn;

@property (nonatomic, strong)NSArray *constellationArray;

@end



@implementation ConstellationViewController
#pragma mark - Lazy load

- (NSArray *)constellationArray{
    if(!_constellationArray){
        _constellationArray = [NSArray array];
    }
    return _constellationArray;
}
- (NSArray *)dataArray{
    if(!_dataArray){
        _dataArray = [NSArray array];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.constellationArray  = @[@"aries",@"taurus",@"gemini",@"cancer",@"lion",@"zodiac",@"scale",@"scorpion",@"sagittarius",@"capricorn",@"aquarius",@"fish"];
//     [self EDITOR_faceBookAnalyticsEvent:YES];
    [self initData];
    [self setupUI];

}

//获取数据
- (void)initData{
     __weak typeof(self) weakSelf = self;
    [self showBusyInView:self.view];
    [[HoroscopesArtistDataManager manager] GetConstellationListBlock:^(NSDictionary *posts, ResultStatus *status, NSError *error) {
        [weakSelf hideProgressInView:weakSelf.view];
        if([status.code integerValue] == 0 && [status.msg isEqualToString:@"success"]){
            weakSelf.dataArray = posts[@"data"];
        }
        [weakSelf.collectionView reloadData];
    }];
    
}
- (void)setupUI {
   
    UIImageView *bgImageView = [[UIImageView alloc]init];
    [self.view addSubview:bgImageView];
    bgImageView.image = [UIImage imageNamed:@"bg"];
    bgImageView.contentMode =  UIViewContentModeScaleAspectFill;
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.edges.equalTo(self.view);
    }];
    
    UIView *naviView = [[UIView alloc]init];
    [self.view addSubview:naviView];
    [naviView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(30);
        make.height.mas_equalTo(50);
    }];
    naviView.backgroundColor = [UIColor clearColor];
    //close
    
    UIButton *closeBtn = [[UIButton alloc]init];
    self.closeBtn = closeBtn;
    [naviView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.width.height.mas_equalTo(25);
        make.centerY.mas_equalTo(0);
    }];
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    closeBtn.tintColor = [UIColor whiteColor];
    [closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];

    //title
    UILabel *titleLabel = [[UILabel alloc]init];
    [naviView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.mas_equalTo(0);
    }];
    titleLabel.text = @"Choose Your Constellation";
    titleLabel.font = [UIFont systemFontOfSize:22];
    titleLabel.textColor = [UIColor whiteColor];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerNib:[UINib nibWithNibName:@"ConstellationCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ConstellationCollectionViewCell"];
  
    [self.view addSubview:self.collectionView];
  
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-80);
        make.top.mas_equalTo(naviView.mas_bottom).mas_equalTo(10);
    }];
    UIButton *chooseConstellationBtn = [[UIButton alloc]init];
    [self.view addSubview:chooseConstellationBtn];
    [chooseConstellationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.collectionView.mas_bottom);
        make.left.mas_equalTo(60);
        make.right.mas_equalTo(-60);
        make.height.mas_equalTo(50);
    }];
    [chooseConstellationBtn setBackgroundImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
    [chooseConstellationBtn setTitle:@"I don't know my constellation?" forState:UIControlStateNormal];
    [chooseConstellationBtn setTitleColor:[UIColor colorWithWhite:51/255.0 alpha:1] forState:UIControlStateNormal];
    chooseConstellationBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [chooseConstellationBtn addTarget:self action:@selector(chooseConstellationBtnClick) forControlEvents:UIControlEventTouchUpInside];
  
}
//关闭按钮
- (void)closeBtnClick{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)chooseConstellationBtnClick{
    
//    __weak typeof(self) weakSelf = self;
    
    //年-月-日-时-分
    WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowMonthDay CompleteBlock:^(NSDate *selectDate) {
        
        NSString *dateString = [selectDate stringWithFormat:@"MM-dd"];
        //测试数据
        [self showBusyInView:self.view];
        [[HoroscopesArtistDataManager manager] GetConstellationInfoByTime:dateString withBlock:^(NSDictionary *posts, ResultStatus *status, NSError *error) {
            [self hideProgressInView:self.view];
            ConstellationDetailViewController *detail = [[ConstellationDetailViewController alloc]init];
            detail.constellationId = posts[@"data"][0][@"id"];
            [self presentViewController:detail animated:YES completion:nil];
            
        }];
     
        NSLog(@"选择的日期：%@",dateString);
      
    }];
    [self.view addSubview:datepicker];
    datepicker.dateLabelColor = [UIColor whiteColor];;//年-月-日-时-分 颜色
    datepicker.datePickerColor = [UIColor whiteColor];//滚轮日期颜色
    datepicker.doneButtonColor = [UIColor clearColor];//确定按钮的颜色
    [datepicker show];
    
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ConstellationCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ConstellationCollectionViewCell" forIndexPath:indexPath];
    cell.img.image = [UIImage imageNamed:self.constellationArray[indexPath.row]];
//    [cell.img sd_setImageWithURL:[NSURL URLWithString:self.dataArray[indexPath.row][@"img"]] placeholderImage:[UIImage imageNamed:@"aries"]];
    cell.name.text = self.dataArray[indexPath.row][@"name"];
      cell.time.text = [NSString stringWithFormat:@"%@-%@",self.dataArray[indexPath.row][@"start_time"],self.dataArray[indexPath.row][@"end_time"]];
    if(indexPath.row % 2 ==0 ){
        cell.line.hidden = NO;
    }else{
        cell.line.hidden = YES;
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if(self.isMatch){
        if(self.isGril){
             [[NSUserDefaults standardUserDefaults] setObject:self.dataArray[indexPath.row][@"id"] forKey:@"feMaleId"];
             [[NSUserDefaults standardUserDefaults] setObject:self.maleId forKey:@"maleId"];
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            [[NSUserDefaults standardUserDefaults] setObject:self.dataArray[indexPath.row][@"id"] forKey:@"maleId"];
            [[NSUserDefaults standardUserDefaults] setObject:self.feMaleId forKey:@"feMaleId"];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
      
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:self.dataArray[indexPath.row][@"id"] forKey:@"constellationId"];
        [self dismissViewControllerAnimated:YES completion:nil];
    

    }
   
   
}

#pragma mark - UICollectionViewDelegateFlowLayout
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return  CGSizeMake(kScreenWidth/3, 170);
}

//设置每个item的UIEdgInsets 相对于上左下右四个边界的位移
- (UIEdgeInsets) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

//设置每个item的水平间距
- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

//行间距
- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}


@end
