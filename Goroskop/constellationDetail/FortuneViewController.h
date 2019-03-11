//
//  FortuneViewController.h
//  Goroskop
//
//  Created by NGE on 2018/12/15.
//  Copyright © 2018年 NGE. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FortuneViewController : UIViewController
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loveWidth;

@property (nonatomic, strong) NSNumber *constellationId;
@property (weak, nonatomic) IBOutlet UIView *bgContentView;

@end

NS_ASSUME_NONNULL_END
