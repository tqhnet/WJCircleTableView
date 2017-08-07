//
//  WJCircleTableViewInterceptor.h
//  WJCircleTableView
//
//  Created by tqh on 2017/8/4.
//  Copyright © 2017年 tqh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJCircleTableViewInterceptor : NSObject

@property (nonatomic, readwrite, weak) id receiver;
@property (nonatomic, readwrite, weak) id middleMan;

@end
