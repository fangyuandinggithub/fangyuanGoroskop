//
//  PalmScanResultViewController.m
//  Constellation
//
//  Created by NGE on 2018/12/4.
//  Copyright © 2018年 NGE. All rights reserved.
//

#import "HoroscopesArtistPalmScanResultViewController.h"
#import "PalmScanTableViewCell.h"
@interface HoroscopesArtistPalmScanResultViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong)NSDictionary *dataDict;

@end

@implementation HoroscopesArtistPalmScanResultViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self bulidUI];
    [self requestData];
}
- (void)requestData{
        __weak typeof(self) weakSelf = self;
    [self showBusyInView:self.view];
    [[HoroscopesArtistDataManager manager] GetConstellationRandomPalmsBlock:^(NSDictionary *posts, ResultStatus *status, NSError *error) {
        [weakSelf hideProgressInView:weakSelf.view];
        if([status.code integerValue] == 0 && [status.msg isEqualToString:@"success"]){
            weakSelf.dataDict = posts[@"data"][0];
        }
        [weakSelf.tableView reloadData];
        
    }];
}
- (void)bulidUI{
    CGFloat top = 30;
    if(IS_IPHONE_X == YES){
        top = 54;
    }
    UIImageView *bgImageView = [[UIImageView alloc]init];
    [self.view addSubview:bgImageView];
    bgImageView.image = [UIImage imageNamed:@"bg"];
    bgImageView.contentMode =  UIViewContentModeScaleAspectFill;
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    UIButton *backBtn = [[UIButton alloc]init];
    [self.view addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(top);
        make.width.height.mas_equalTo(30);
    }];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.tableView = [[UITableView alloc] init];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(0);
        make.top.mas_equalTo(100);
        
    }];
    [self.tableView registerNib:[UINib nibWithNibName:@"PalmScanTableViewCell" bundle:nil] forCellReuseIdentifier:@"PalmScanTableViewCell"];
    
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
- (void)backBtnClick{
//    FeatureViewController *feature = [[FeatureViewController alloc]init];
//    [self presentViewController:feature animated:YES completion:nil];

    [self dismissViewControllerAnimated:YES completion:nil];
    
}
#pragma mark --- UITableViewDelegate tableView的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 6;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PalmScanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PalmScanTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    if(indexPath.row == 0){
        cell.zhishuLabel.text = [NSString stringWithFormat:@"Life_line:%ld", [self.dataDict[@"life_line_index"] integerValue] ];
        cell.descripLabel.text = self.dataDict[@"life_line_essay"];
        [cell.handLineImageView  sd_setImageWithURL:[NSURL URLWithString:self.dataDict[@"life_line_img"]] placeholderImage:[UIImage imageNamed:@"fortune"]];
        
        cell.starView.starScore = [self.dataDict[@"life_line_index"] floatValue];
    }else if (indexPath.row == 1){
        cell.zhishuLabel.text = [NSString stringWithFormat:@"intelligence_line:%ld",[self.dataDict[@"intelligence_lineIndex"] integerValue]];
        cell.descripLabel.text = self.dataDict[@"intelligence_lineEssay"];
        [cell.handLineImageView  sd_setImageWithURL:[NSURL URLWithString:self.dataDict[@"intelligence_img"]] placeholderImage:[UIImage imageNamed:@"fortune"]];
        cell.starView.starScore = [self.dataDict[@"intelligence_lineIndex"] floatValue];
    }else if (indexPath.row == 2){
        cell.zhishuLabel.text = [NSString stringWithFormat:@"Sentiment_line:%ld",[self.dataDict[@"sentiment_line_index"] integerValue]];
        cell.descripLabel.text = self.dataDict[@"sentiment_line_essay"];
        [cell.handLineImageView  sd_setImageWithURL:[NSURL URLWithString:self.dataDict[@"sentiment_line_img"]] placeholderImage:[UIImage imageNamed:@"fortune"]];
         cell.starView.starScore = [self.dataDict[@"sentiment_line_index"] floatValue];
    }else if (indexPath.row == 3){
        cell.zhishuLabel.text = [NSString stringWithFormat:@"line_index:%ld",[self.dataDict[@"line_index"] integerValue]];
        cell.descripLabel.text = self.dataDict[@"line_essay"];
        [cell.handLineImageView  sd_setImageWithURL:[NSURL URLWithString:self.dataDict[@"line_img"]] placeholderImage:[UIImage imageNamed:@"fortune"]];
         cell.starView.starScore = [self.dataDict[@"line_index"] floatValue];
    }else if (indexPath.row == 4){
        cell.zhishuLabel.text = [NSString stringWithFormat:@"wealth_line:%ld",[self.dataDict[@"wealth_line_index"] integerValue]];
        cell.descripLabel.text = self.dataDict[@"wealth_line_essay"];
        [cell.handLineImageView  sd_setImageWithURL:[NSURL URLWithString:self.dataDict[@"wealth_line_img"]] placeholderImage:[UIImage imageNamed:@"fortune"]];
         cell.starView.starScore = [self.dataDict[@"wealth_line_index"] floatValue];
    }else if (indexPath.row == 5){
        cell.zhishuLabel.text = [NSString stringWithFormat:@"composite_line:%ld",[self.dataDict[@"composite_index"] integerValue]];
        cell.descripLabel.text = self.dataDict[@"composite_essay"];
        [cell.handLineImageView  sd_setImageWithURL:[NSURL URLWithString:self.dataDict[@"composite_img"]] placeholderImage:[UIImage imageNamed:@"fortune"]];
         cell.starView.starScore = [self.dataDict[@"composite_index"] floatValue];
    }
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *textStr = @"";
    //设置内容高度
    if(indexPath.row == 0){
        textStr = self.dataDict[@"life_line_essay"];
     
    }else if (indexPath.row == 1){
        textStr = self.dataDict[@"intelligence_lineEssay"];
   
    }else if (indexPath.row == 2){
        textStr = self.dataDict[@"sentiment_line_essay"];
      
    }else if (indexPath.row == 3){
        textStr = self.dataDict[@"line_essay"];
    
    }else if (indexPath.row == 4){
        textStr = self.dataDict[@"wealth_line_essay"];
       
    }else if (indexPath.row == 5){
        textStr = self.dataDict[@"composite_essay"];
    }
    CGFloat height = [self getHeightWithText:textStr Width:kScreenWidth - 100 font:14];
    
    return  height + 120;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    UIView *view = [[UIView alloc]init];
//    view.backgroundColor = [UIColor clearColor];
//    UILabel *footerLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 10, kScreenWidth - 80, 30)];
//    footerLabel.text = @"The above results may not provide 100% accuracy for reference only.";
//    footerLabel.textColor = [UIColor whiteColor];
//    footerLabel.numberOfLines = 0;
//    footerLabel.font = [UIFont systemFontOfSize:12];
//    [view addSubview:footerLabel];
//    return view;
//}
//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section{
//    return 50;
//}

//根据高度度求宽度  text 计算的内容  Height 计算的高度 font字体大小
- (CGFloat)getHeightWithText:(NSString *)text Width:(CGFloat)width font:(CGFloat)font{
    
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]}
                                     context:nil];
    return rect.size.height;
}
@end
