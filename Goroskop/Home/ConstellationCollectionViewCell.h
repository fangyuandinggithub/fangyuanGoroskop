//
//  ConstellationCollectionViewCell.h
//  Constellation
//
//  Created by NGE on 2018/12/5.
//  Copyright © 2018年 NGE. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ConstellationCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *time;

@end

NS_ASSUME_NONNULL_END
