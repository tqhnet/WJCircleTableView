//
//  WJCircleTabCell.h
//  WJCircleTableView
//
//  Created by tqh on 2017/8/4.
//  Copyright © 2017年 tqh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WJCircleTabCell : UITableViewCell

@property (nonatomic,strong) UIImageView *avatarImageView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,assign) CGFloat deviation; //偏移

//- (void)change

+ (CGFloat)cellHeight;

@end
