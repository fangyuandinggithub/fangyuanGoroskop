//
//  SMLSegmentView.h
//  ShangMenle
//
//  Created by 牛犇 on 16/1/20.
//  Copyright © 2016年 shangmenle. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef struct {
    
    CGFloat imageTop;
    
    CGFloat imageTitleSpace;
    
    CGFloat titleBottom;
    
} SMLSegmentViewSpace;

CG_INLINE SMLSegmentViewSpace
SMLSegmentViewSpaceMake(CGFloat imageTop, CGFloat imageTitleSpace, CGFloat titleBottom)
{
    SMLSegmentViewSpace space;
    space.titleBottom = titleBottom; space.imageTop = imageTop;
    space.imageTitleSpace = imageTitleSpace;
    return space;
}




@class SMLSegmentView;
@protocol SMLSegmentViewDelegate <NSObject>

- (void)segmentView:(SMLSegmentView *)segmentView valueChanged:(NSInteger)index;

@end



@interface SMLSegmentView : UIView

@property (nonatomic, weak) id<SMLSegmentViewDelegate> delegate;

/// 字体大小
@property (nonatomic, assign) CGFloat fontSize;

/// 选中的分段索引
@property (nonatomic, assign) NSInteger selectedIndex;

/// 文字颜色
@property (nonatomic, strong) UIColor *textColor;

/// 文字选中后的颜色
@property (nonatomic, strong) UIColor *textSelectedColor;

/// 底部滑动线条颜色
@property (nonatomic, strong) UIColor *bottomLineColor;

/// 底部滚动线条 长度 默认 空间宽度／titleArray.count
@property (nonatomic, assign) CGFloat bottomLineWidth;

///是否有底部背景线条
@property (nonatomic, assign) BOOL hasBackgroundLine;

/// （图片顶部边距、图片标题间距、标题底部边距）
@property (nonatomic, assign) SMLSegmentViewSpace space;


- (instancetype)initWithTitleArray:(NSArray *)titleArray;

/** selectedImageArray 若无选中效果 传nil */
- (instancetype)initWithTitleArray:(NSArray *)titleArray withImageArray:(NSArray *)imageArray withSelectedImageArray:(NSArray *)selectedImageArray;

@end
