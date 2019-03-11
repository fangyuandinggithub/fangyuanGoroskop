//
//  SMLSegmentView.m
//  ShangMenle
//
//  Created by 牛犇 on 16/1/20.
//  Copyright © 2016年 shangmenle. All rights reserved.
//

#import "SMLSegmentView.h"
#import "Masonry.h"

#pragma mark --- SMLSegmentViewImage
@interface SMLSegmentViewImage : UIImageView

@property (nonatomic, assign) BOOL selected;

@property (nonatomic, strong) UIImage *selectedImage;

@property (nonatomic, strong) UIImage *normalImage;

@end

@implementation SMLSegmentViewImage

- (void)setSelected:(BOOL)selected {
    
    _selected = selected;
    
    if (selected) {
        
        self.image = self.selectedImage;
        
    } else {
        
        self.image = self.normalImage;
        
    }
    
}

@end


#pragma mark --- SMLSegmentView
@interface SMLSegmentView ()

@property (nonatomic, strong) UIView *bottomLineView;

@property (nonatomic, strong) NSMutableArray *buttonArray;

@property (nonatomic, strong) NSMutableArray *viewArray;

@end

@implementation SMLSegmentView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark --- 动画
- (void)setSelectedIndex:(NSInteger)selectedIndex {
    
    __weak typeof(self) weakSelf = self;
    
    if (_buttonArray) {
        
        UIButton *button = self.buttonArray[selectedIndex];
        UIButton *lastButton = self.buttonArray[_selectedIndex];
        
        lastButton.selected = NO;
        button.selected = YES;
        
    }
    
    if (_viewArray) {
        
        UIView *view = self.viewArray[selectedIndex];
        UIView *lastView = self.viewArray[_selectedIndex];
        
        for (UIView *subView in lastView.subviews) {
            
            if ([subView isKindOfClass:[UILabel class]]) {
                
                UILabel *titleLabel = (UILabel *)subView;
                titleLabel.textColor = self.textColor;
                
            } else if ([subView isKindOfClass:[SMLSegmentViewImage class]]) {
                
                SMLSegmentViewImage *imageView = (SMLSegmentViewImage *)subView;
                imageView.selected = NO;
                
            }
            
        }
        
        for (UIView *subView in view.subviews) {
            
            if ([subView isKindOfClass:[UILabel class]]) {
                
                UILabel *titleLabel = (UILabel *)subView;
                titleLabel.textColor = self.textSelectedColor;
                
            } else if ([subView isKindOfClass:[SMLSegmentViewImage class]]) {
                
                SMLSegmentViewImage *imageView = (SMLSegmentViewImage *)subView;
                imageView.selected = YES;
                
            }
            
        }
        
    }
    
    _selectedIndex = selectedIndex;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        [weakSelf performAnimationWithSelectedIndex:selectedIndex];
        
    }];
    
}

- (void)performAnimationWithSelectedIndex:(NSInteger)selectedIndex {
    [self.delegate segmentView:self valueChanged:selectedIndex];
    
    if (_buttonArray) {
        
        UIButton *button = self.buttonArray[selectedIndex];
        
        if (_bottomLineWidth == 0) {
            
            [self.bottomLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(0);
                make.left.right.width.mas_equalTo(button);
                make.height.mas_equalTo(2);
            }];
            
        } else {
            
            [self.bottomLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(0);
                make.centerX.mas_equalTo(button);
                make.height.mas_equalTo(2);
                make.width.mas_equalTo(_bottomLineWidth);
            }];
            
        }
        
        
        
    } else if (_viewArray) {
        
        UIView *view = self.viewArray[selectedIndex];
        
        if (_bottomLineWidth == 0) {
            
            [self.bottomLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(0);
                make.left.right.width.mas_equalTo(view);
                make.height.mas_equalTo(2);
            }];
            
        } else {
            
            [self.bottomLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(0);
                make.centerX.mas_equalTo(view);
                make.height.mas_equalTo(2);
                make.width.mas_equalTo(_bottomLineWidth);
            }];
            
        }
        
    }
    
    
    [self.bottomLineView setNeedsLayout];
    [self.bottomLineView layoutIfNeeded];
}

#pragma mark --- set方法
- (void)setBottomLineColor:(UIColor *)bottomLineColor {
    
    _bottomLineColor = bottomLineColor;
    
    if (self.bottomLineView) {
        self.bottomLineView.backgroundColor = bottomLineColor;
    }
    
}

- (void)setFontSize:(CGFloat)fontSize {
    
    _fontSize = fontSize;
    
    if (_buttonArray) {
        
        for (UIButton *btn in self.buttonArray) {
            btn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
        }
        
    }
    
    if (_viewArray) {
        
        for (UIView *view in self.viewArray) {
            for (UIView *subView in view.subviews) {
                if ([subView isKindOfClass:[UILabel class]]) {
                    UILabel *titleLabel = (UILabel *)subView;
                    titleLabel.font = [UIFont systemFontOfSize:fontSize];
                }
            }
        }
            
        [self setSpace:_space];
        
    }
    
}

- (void)setTextColor:(UIColor *)textColor {
    
    if (_buttonArray) {
        for (UIButton *btn in self.buttonArray) {
            [btn setTitleColor:textColor forState:UIControlStateNormal];
        }
    }
    
    if (_viewArray) {
        
        for (UIView *view in self.viewArray) {
            for (UIView *subView in view.subviews) {
                if ([subView isKindOfClass:[UILabel class]]) {
                    UILabel *titleLabel = (UILabel *)subView;
                    titleLabel.textColor = textColor;
                }
            }
        }
        
    }
    
    _textColor = textColor;
}

- (void)setTextSelectedColor:(UIColor *)textSelectedColor {
    
    if (_buttonArray) {
        
        for (UIButton *btn in self.buttonArray) {
            [btn setTitleColor:textSelectedColor forState:UIControlStateSelected];
        }
        
    }
    
    if (_viewArray) {
        
        UIView *view = self.viewArray[_selectedIndex];
        for (UIView *subView in view.subviews) {
            
            if ([subView isKindOfClass:[UILabel class]]) {
                
                UILabel *titleLabel = (UILabel *)subView;
                titleLabel.textColor = textSelectedColor;
                
            }
            
        }
        
    }
    
    _textSelectedColor = textSelectedColor;
    
}

- (void)setSpace:(SMLSegmentViewSpace)space {
    
    if (_viewArray) {
        
        for (UIView *view in self.viewArray) {
            
            UILabel *titleLabel = nil;
            UIImageView *imageView = nil;
            
            for (UIView *subView in view.subviews) {
                
                if ([subView isKindOfClass:[UILabel class]]) {
                    
                    titleLabel = (UILabel *)subView;
                    
                } else if ([subView isKindOfClass:[UIImageView class]]) {
                    
                    imageView = (UIImageView *)subView;
                    
                }
            }
            
            CGFloat titleHeight = [titleLabel.text sizeWithAttributes:@{NSFontAttributeName : titleLabel.font}].height;
            
            [titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                
                make.left.right.mas_equalTo(0);
                make.bottom.mas_equalTo(-space.titleBottom);
                
            }];
            
            [imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                
                make.top.mas_equalTo(space.imageTop);
                make.left.right.mas_equalTo(0);
                make.bottom.mas_equalTo(-space.titleBottom-titleHeight-space.imageTitleSpace);
                
            }];
            
        }
        
    }
    
}

- (void)setBottomLineWidth:(CGFloat)bottomLineWidth {
    
    _bottomLineWidth = bottomLineWidth;
    
    if (_buttonArray) {
        
        [self.bottomLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.centerX.mas_equalTo(self.buttonArray[0]);
            make.height.mas_equalTo(2);
            make.width.mas_equalTo(bottomLineWidth);
        }];
        
    } else if (_viewArray) {
        
        [self.bottomLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.centerX.mas_equalTo(self.viewArray[0]);
            make.height.mas_equalTo(2);
            make.width.mas_equalTo(bottomLineWidth);
        }];
        
    }
    
    
}

#pragma mark --- 懒加载
- (UIView *)bottomLineView {
    if (!_bottomLineView) {
//        _blueIamgeView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blueBar.png"]];
        _bottomLineView = [[UIView alloc] init];
        
        if (self.bottomLineColor) {
            
            _bottomLineView.backgroundColor = self.bottomLineColor;
            
        } else {
            
            _bottomLineView.backgroundColor = [UIColor blueColor];
            
        }
        
        [self addSubview:_bottomLineView];
    }
    return _bottomLineView;
}

- (NSMutableArray *)buttonArray {
    if (!_buttonArray) {
        _buttonArray = [NSMutableArray array];
    }
    return _buttonArray;
}

- (NSMutableArray *)viewArray {
    
    if (!_viewArray) {
        _viewArray = [NSMutableArray array];
    }
    return _viewArray;
}

#pragma mark --- 初始化
- (instancetype)initWithTitleArray:(NSArray *)titleArray{
    if (self = [super init]) {
        UIButton *lastButton = nil;
        for (int i = 0; i < titleArray.count; i++) {
            UIButton *button = [UIButton new];
            button.titleLabel.text = titleArray[i];
            [button setTitle:titleArray[i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//            [button setTitleColor:[UIColor colorWithRed:255.0/255 green:163.0/255 blue:53.0/255 alpha:1] forState:UIControlStateSelected];
            [self addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(0);
                make.bottom.mas_equalTo(0);
                if (i == 0) {
                    make.left.mas_equalTo(20);
                } else {
                    make.left.mas_equalTo(lastButton.mas_right);
                    make.width.mas_equalTo(lastButton.mas_width);
                    if (i == titleArray.count-1) {
                        make.right.mas_equalTo(-20);
                    }
                }
            }];
            [button addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchDown];
            
            [self.buttonArray addObject:button];
            lastButton = button;
        }
        
        if (self.hasBackgroundLine == YES) {
            UIView *view = [UIView new];
            view.backgroundColor = [UIColor colorWithWhite:220.0/255 alpha:1];
            [self addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(20);
                make.right.mas_equalTo(-20);
                make.bottom.mas_equalTo(0);
                make.height.mas_equalTo(1);
            }];
        }

        
        [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.left.right.width.mas_equalTo(self.buttonArray[0]);
            make.height.mas_equalTo(2);
        }];
        
        [self layoutIfNeeded];
        
    }
    self.selectedIndex = 0;
    return self;
}


- (instancetype)initWithTitleArray:(NSArray *)titleArray withImageArray:(NSArray *)imageArray withSelectedImageArray:(NSArray *)selectedImageArray {
    
    if (self = [super init]) {
        
        UIView *lastView = nil;
        
        _space = SMLSegmentViewSpaceMake(10, 8, 10);
        
        for (int i = 0; i < titleArray.count; i++) {
            UIView *view = [[UIView alloc] init];
            
            view.tag = 1000 + i;
            
            UILabel *titleLabel = [[UILabel alloc] init];
            titleLabel.text = titleArray[i];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.textColor = [UIColor blackColor];
            
            titleLabel.font = [UIFont systemFontOfSize:14];
            
            CGFloat titleHeight = [titleLabel.text sizeWithAttributes:@{NSFontAttributeName : titleLabel.font}].height;
            
            [view addSubview:titleLabel];
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.right.mas_equalTo(0);
                make.bottom.mas_equalTo(-8);
                
            }];
            
            SMLSegmentViewImage *imageView = [[SMLSegmentViewImage alloc] init];
            imageView.normalImage = [UIImage imageNamed:imageArray[i]];
            if (selectedImageArray) {
                
                imageView.selectedImage = [UIImage imageNamed:selectedImageArray[i]];
                
            }
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            [view addSubview:imageView];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.top.mas_equalTo(10);
                make.left.right.mas_equalTo(0);
                make.bottom.mas_equalTo(-8-titleHeight-7);
                
            }];
            
            imageView.selected = NO;
            
            //            [button setTitleColor:[UIColor colorWithRed:255.0/255 green:163.0/255 blue:53.0/255 alpha:1] forState:UIControlStateSelected];
            [self addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(0);
                make.bottom.mas_equalTo(0);
                if (i == 0) {
                    make.left.mas_equalTo(0);
                } else {
                    make.left.mas_equalTo(lastView.mas_right);
                    make.width.mas_equalTo(lastView.mas_width);
                    if (i == titleArray.count-1) {
                        make.right.mas_equalTo(0);
                    }
                }
            }];
            
            UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapView:)];
            [view addGestureRecognizer:tapGR];
            
            [self.viewArray addObject:view];
            lastView = view;
        }
        
        if (self.hasBackgroundLine == YES) {
            UIView *view = [UIView new];
            view.backgroundColor = [UIColor colorWithWhite:220.0/255 alpha:1];
            [self addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(20);
                make.right.mas_equalTo(-20);
                make.bottom.mas_equalTo(0);
                make.height.mas_equalTo(1);
            }];
        }
        
        
        [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.left.right.width.mas_equalTo(self.viewArray[0]);
            make.height.mas_equalTo(2);
        }];
        
        [self layoutIfNeeded];
        
    }
    self.selectedIndex = 0;
    return self;
    
}

#pragma mark --- 点击事件
- (void)didTapButton:(UIButton *)button {
    
    self.selectedIndex = [self.buttonArray indexOfObject:button];
}

- (void)didTapView:(UITapGestureRecognizer *)gr {
    
    UIView *view = gr.view;
    self.selectedIndex = view.tag - 1000;
    
    
}

@end
