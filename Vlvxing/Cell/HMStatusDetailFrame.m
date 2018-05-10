//
//  HMStatusDetailFrame.m
//  XingJu
//
//  Created by apple on 14-7-14.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "HMStatusDetailFrame.h"
#import "HMStatus.h"
#import "HMStatusOriginalFrame.h"
#import "HMStatusRetweetedFrame.h"

@implementation HMStatusDetailFrame

- (void)setStatus:(HMStatus *)status
{
    _status = status;
    
    // 1.计算原创微博的frame
    HMStatusOriginalFrame *originalFrame = [[HMStatusOriginalFrame alloc] init];
    originalFrame.status = status;
    self.originalFrame = originalFrame;

    // 2.计算转发微博的frame
    CGFloat h = 0;
    h = CGRectGetMaxY(originalFrame.frame);

    // 自己的frame
    CGFloat x = 0;
    CGFloat y = HMStatusCellMargin;
    CGFloat w = ScreenWidth;
    self.frame = CGRectMake(x, y, w, h);
}

@end
