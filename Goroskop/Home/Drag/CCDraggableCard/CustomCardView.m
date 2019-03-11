//
//  CustomCardView.m
//  CCDraggableCard-Master
//
//  Created by jzzx on 16/7/9.
//  Copyright © 2016年 Zechen Liu. All rights reserved.
//

#import "CustomCardView.h"

@interface CustomCardView ()

@property (strong, nonatomic) UIImageView *imageView;

@property (strong, nonatomic) UIImageView *iconImageView;

@property (strong, nonatomic) UILabel     *titleLabel;

@property (strong, nonatomic) UILabel     *timeLabel;

@end

@implementation CustomCardView

- (instancetype)init {
    if (self = [super init]) {
        [self loadComponent];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self loadComponent];
    }
    return self;
}

- (void)loadComponent {
    self.imageView = [[UIImageView alloc] init];
    self.titleLabel = [[UILabel alloc] init];
    self.iconImageView = [[UIImageView alloc] init];
    self.timeLabel = [[UILabel alloc] init];
    
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.imageView.layer setMasksToBounds:YES];
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.iconImageView.layer setMasksToBounds:YES];
    
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.font = [UIFont systemFontOfSize:20];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.timeLabel.textColor = [UIColor blackColor];
    self.timeLabel.font = [UIFont systemFontOfSize:16];
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.imageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.iconImageView];
    [self addSubview:self.timeLabel];
    self.backgroundColor = [UIColor colorWithRed:0.951 green:0.951 blue:0.951 alpha:1.00];
}

- (void)cc_layoutSubviews  {    
    self.imageView.frame   = CGRectMake(self.frame.size.width/2 - 100, 40, 200, 200);
    self.titleLabel.frame = CGRectMake(0, self.frame.size.height - 64, self.frame.size.width, 64);
    self.iconImageView.frame   = CGRectMake(40, CGRectGetMaxY(self.imageView.frame)+40, 80, 80);
    self.titleLabel.frame = CGRectMake(0, CGRectGetMaxY(self.imageView.frame)+50, self.frame.size.width, 40);
     self.timeLabel.frame = CGRectMake(0, CGRectGetMaxY(self.imageView.frame)+90, self.frame.size.width, 30);
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)installData:(NSDictionary *)element {
    self.imageView.image  = [UIImage imageNamed:element[@"image"]];
    self.imageView.transform = CGAffineTransformIdentity;
    self.iconImageView.image  = [UIImage imageNamed:element[@"iconImage"]];
    self.iconImageView.transform = CGAffineTransformIdentity;
    self.titleLabel.attributedText = [NSString singleLineStyleWithPara:element[@"title"] fontSize:20];
    self.titleLabel.transform = CGAffineTransformIdentity;
    self.timeLabel.attributedText = [NSString singleLineStyleWithPara:element[@"time"] fontSize:16];
    self.timeLabel.transform = CGAffineTransformIdentity;
}

@end
