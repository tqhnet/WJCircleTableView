//
//  WJCircleTabCell.m
//  WJCircleTableView
//
//  Created by tqh on 2017/8/4.
//  Copyright © 2017年 tqh. All rights reserved.
//

#import "WJCircleTabCell.h"
//static CGFloat height1 = 0;

@interface WJCircleTabCell ()

@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) UILabel *detailLabel;

@end

@implementation WJCircleTabCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self  = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.avatarImageView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.lineView];
        [self.contentView addSubview:self.detailLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
   
}

- (void)setDeviation:(CGFloat)deviation {
    _deviation = deviation;
    
    if (deviation < 0) {
        deviation = 0;
    }
    
    //20
//   100/
//    (100-60)
    CGFloat f = deviation/400;
    
//   CGFloat ff = fabs(deviation - 40)
    
//    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    CGFloat height_y = height*f + 60;
    CGFloat width_x = 120+height*f;
    self.avatarImageView.frame = CGRectMake(0, 0, height_y, height_y);
    self.avatarImageView.center = CGPointMake(height_y/2, height/2);
    self.avatarImageView.layer.masksToBounds = YES;
    self.avatarImageView.layer.cornerRadius = height_y/2;
    
    
    self.lineView.frame = CGRectMake(height_y, height/2, width_x, 1);
    self.titleLabel.frame = CGRectMake(height_y, height/2 - 40, width_x, 40);
    self.detailLabel.frame = CGRectMake(height_y, height/2, width_x, 40);

    self.titleLabel.font = [UIFont systemFontOfSize:f*height/4 + 10];
    self.detailLabel.font = [UIFont systemFontOfSize:f*height/4 + 10];

//    self.alpha = f + 3/4;
    
}

#pragma mark - Layz

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [UIImageView new];
        _avatarImageView.layer.borderWidth = 5;
        _avatarImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    }
    return _avatarImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
//        _titleLabel.layer.borderWidth = 1;
        _titleLabel.text = @"我心如梦幻～呀";
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = [UIColor whiteColor];
    }
    return _lineView;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [UILabel new];
        _detailLabel.text = @"说说 17 | 文章 12";
        _detailLabel.textColor = [UIColor whiteColor];
//        _detailLabel.layer.borderWidth = 1;
    }
    return _detailLabel;
}

//+ (CGFloat)cellHeight {
//    
//    return height1;
//}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
