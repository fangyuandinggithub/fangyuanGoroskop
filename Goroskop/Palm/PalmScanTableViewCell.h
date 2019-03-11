//
//  PalmScanTableViewCell.h
//  Constellation
//
//  Created by NGE on 2018/12/10.
//  Copyright © 2018年 NGE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYStarView.h"
NS_ASSUME_NONNULL_BEGIN

@interface PalmScanTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *handLineImageView;
@property (weak, nonatomic) IBOutlet UILabel *zhishuLabel;
@property (weak, nonatomic) IBOutlet UILabel *descripLabel;
@property (weak, nonatomic) IBOutlet YYStarView *starView;

@end

NS_ASSUME_NONNULL_END
