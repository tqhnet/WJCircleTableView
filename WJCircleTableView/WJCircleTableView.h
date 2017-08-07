//
//  WJCircleTableView.h
//  WJCircleTableView
//
//  Created by tqh on 2017/8/4.
//  Copyright © 2017年 tqh. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum _WJCircleContentAlignment
{
    WJCircleTableViewContentAlignmentLeft,  //左边
    WJCircleTableViewContentAlignmentRight  //右边
}WJCircleTableViewContentAlignment;


@interface WJCircleTableView : UITableView

@property(nonatomic, assign, getter = isInfiniteScrollingEnabled)BOOL enableInfiniteScrolling;
@property(nonatomic, assign) WJCircleTableViewContentAlignment contentAlignment;
@property(nonatomic, assign) CGFloat horizontalRadiusCorrection;//value from 1.0 - 0.5;

@end
