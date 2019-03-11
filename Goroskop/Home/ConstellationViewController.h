//
//  ConstellationViewController.h
//  Constellation
//
//  Created by NGE on 2018/12/5.
//  Copyright © 2018年 NGE. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ConstellationViewController : UIViewController

@property (nonatomic, strong)NSNumber *maleId;

@property (nonatomic, strong)NSNumber *feMaleId;

@property (nonatomic, assign)BOOL isGril;

@property (nonatomic, assign)BOOL isMatch;

@end

NS_ASSUME_NONNULL_END
