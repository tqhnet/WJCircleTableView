//
//  WJCircleTableViewInterceptor.m
//  WJCircleTableView
//
//  Created by tqh on 2017/8/4.
//  Copyright © 2017年 tqh. All rights reserved.
//

#import "WJCircleTableViewInterceptor.h"

@implementation WJCircleTableViewInterceptor

@synthesize receiver = _receiver;
@synthesize middleMan = _middleMan;

- (id) forwardingTargetForSelector:(SEL)aSelector {
    
    if ([_middleMan respondsToSelector:aSelector])
        return _middleMan;
    
    if ([_receiver respondsToSelector:aSelector])
        return _receiver;
    
    return	[super forwardingTargetForSelector:aSelector];
    
}

- (BOOL) respondsToSelector:(SEL)aSelector {
    
    if ([_middleMan respondsToSelector:aSelector])
        return YES;
    
    if ([_receiver respondsToSelector:aSelector])
        return YES;
    
    return [super respondsToSelector:aSelector];
    
}

@end
