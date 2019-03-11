//
//  SMLProgressView.m
//  ShangMenle
//
//  Created by 牛犇 on 16/6/25.
//  Copyright © 2016年 shangmenle. All rights reserved.
//

#import "SMLProgressView.h"


#define DEFAULT_WIDTH 50

@interface SMLProgressView ()

@property (nonatomic, strong) UILabel *progressLabel;

@property (nonatomic, strong) UILabel *percentLabel;

@end

@implementation SMLProgressView

- (void)drawRect:(CGRect)rect {
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.width/2);
    
    CGFloat minWidth = MIN(self.bounds.size.width, self.bounds.size.height);
    
    [path addArcWithCenter:center radius:minWidth/2- 10 startAngle:M_PI_2 *3 endAngle:M_PI_2 * 3 + self.percentage * M_PI *2 clockwise:YES];
    [path addLineToPoint:center];
    [path closePath];
    
    if (self.progressColor) {
        
        [self.progressColor setFill];
        
    } else {
        
        [[UIColor colorWithWhite:1 alpha:0.7] setFill];
        
    }
    
    [path fill];
    
}

- (instancetype)init {
    
    if (self = [super init]) {
        
        self.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.5];
        
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5;
        
        self.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - DEFAULT_WIDTH - 10, [UIScreen mainScreen].bounds.size.height - DEFAULT_WIDTH - 100, DEFAULT_WIDTH, DEFAULT_WIDTH);
        
        UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        [self addGestureRecognizer:panGR];
        
    }
    return self;
    
}

- (void)pan:(UIPanGestureRecognizer *)gr {
    
    CGPoint point = [gr locationInView:[UIApplication sharedApplication].keyWindow];
    
    self.center = point;
    
}


- (void)dealloc {
    
    NSLog(@"progressView 释放");
    
}

#pragma mark --- progressLabel
- (void)setupProgressLabel {
        
    self.progressLabel = [[UILabel alloc] init];
    self.progressLabel.text = self.progressTitle;
    self.progressLabel.textAlignment = NSTextAlignmentCenter;
    self.progressLabel.lineBreakMode = NSLineBreakByClipping;

    if (self.progressTitleColor) {
        
        self.progressLabel.textColor = self.progressTitleColor;
        
    } else {
        
        self.progressLabel.textColor = [UIColor whiteColor];
        
    }

    if (self.titleFontSize) {
        
        self.progressLabel.font = [UIFont systemFontOfSize:self.titleFontSize];
        
    } else {
        
        self.progressLabel.font = [UIFont systemFontOfSize:12];
        
    }

    [self addSubview:self.progressLabel];
    
    if (self.percentLabel) {
        
        self.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - DEFAULT_WIDTH - 10, [UIScreen mainScreen].bounds.size.height - DEFAULT_WIDTH - 40 - 100, DEFAULT_WIDTH, DEFAULT_WIDTH + 40);
        self.progressLabel.frame = CGRectMake(0, self.frame.size.height - 40, self.frame.size.width, 20);
        self.percentLabel.frame = CGRectMake(0, CGRectGetMaxY(self.progressLabel.frame), self.frame.size.width, 20);
        
    } else {
        
        self.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - DEFAULT_WIDTH - 10, [UIScreen mainScreen].bounds.size.height - DEFAULT_WIDTH - 20 - 100, DEFAULT_WIDTH, DEFAULT_WIDTH + 20);
        self.progressLabel.frame = CGRectMake(0, self.frame.size.height - 20, self.frame.size.width, 20);
        
    }
    
    
}

#pragma mark --- percentLabel
- (void)setupPercentLabel {
    
    self.percentLabel = [[UILabel alloc] init];
    self.percentLabel.textAlignment = NSTextAlignmentCenter;
    self.percentLabel.lineBreakMode = NSLineBreakByClipping;
    
    if (self.progressTitleColor) {
        
        self.percentLabel.textColor = self.progressTitleColor;
        
    } else {
        
        self.percentLabel.textColor = [UIColor whiteColor];
        
    }
    
    if (self.titleFontSize) {
        
        self.percentLabel.font = [UIFont systemFontOfSize:self.titleFontSize];
        
    } else {
        
        self.percentLabel.font = [UIFont systemFontOfSize:12];
        
    }
    
    [self addSubview:self.percentLabel];
    
    if (self.progressLabel) {
        
        self.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - DEFAULT_WIDTH - 10, [UIScreen mainScreen].bounds.size.height - DEFAULT_WIDTH - 40 - 100, DEFAULT_WIDTH, DEFAULT_WIDTH + 40);
        self.progressLabel.frame = CGRectMake(0, self.frame.size.height - 40, self.frame.size.width, 20);
        self.percentLabel.frame = CGRectMake(0, CGRectGetMaxY(self.progressLabel.frame), self.frame.size.width, 20);
        
    } else {
        
        self.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - DEFAULT_WIDTH - 10, [UIScreen mainScreen].bounds.size.height - DEFAULT_WIDTH - 20 - 100, DEFAULT_WIDTH, DEFAULT_WIDTH + 20);
        self.percentLabel.frame = CGRectMake(0, self.frame.size.height - 20, self.frame.size.width, 20);
        
    }
    
    
}

#pragma mark --- set方法

- (void)setPercentage:(CGFloat)percentage {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        _percentage = percentage;
        
        [self setNeedsDisplay];
            
        if (self.percentLabel) {
            
            self.percentLabel.text = [NSString stringWithFormat:@"%.1f%%", percentage * 100];
            
        }
        
    });
    
    
}

- (void)setProgressTitle:(NSString *)progressTitle {
    
    _progressTitle = progressTitle;
    
    if (!self.progressLabel) {
        
        [self setupProgressLabel];
        
    } else {
        
        self.progressLabel.text = progressTitle;
        
    }
    
}

- (void)setProgressTitleColor:(UIColor *)progressTitleColor {
    
    _progressTitleColor = progressTitleColor;
    
    if (self.progressLabel) {
        
        self.progressLabel.textColor = progressTitleColor;
        
    }
    
}

- (void)setTitleFontSize:(NSInteger)titleFontSize {
    
    _titleFontSize = titleFontSize;
    
    if (self.progressLabel) {
        
        self.progressLabel.font = [UIFont systemFontOfSize:titleFontSize];
        
    }
    
}

- (void)setIsTitleShowPercentTage:(BOOL)isTitleShowPercentTage {
    
    _isTitleShowPercentTage = isTitleShowPercentTage;
    
    if (isTitleShowPercentTage) {
        
        if (!self.percentLabel) {
            
            [self setupPercentLabel];
            
        }
        
    } else {
        
        [self.percentLabel removeFromSuperview];
        
    }
    
}

#pragma mark --- show hidden
- (void)showProgress {
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
}

- (void)hiddenProgress {
    
    [self removeFromSuperview];
    
}

@end
