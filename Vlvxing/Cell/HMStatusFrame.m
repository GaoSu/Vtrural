//
//  HMStatusFrame.m
//  XingJu
//
//  Created by apple on 14-7-14.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "HMStatusFrame.h"
#import "HMStatus.h"
#import "HMStatusDetailFrame.h"

#import "HMDynamic.h"

//vlx
#import "VLX_status.h"
#import "VLX_User.h"
#import "VLX_photo.h"

@implementation HMStatusFrame

- (void)setStatus:(HMStatus *)status
{
    _status = status;
    
    // 1.计算微博具体内容（微博整体）
    [self setupDetailFrame];
    
    // 2.计算底部工具条
    [self setupToolbarFrame];
    
    // 3.计算cell的高度
    self.cellHeight = CGRectGetMaxY(self.toolbarFrame);
    NSLog(@"计算cell的高度%f",self.cellHeight);
}

//计算微博具体内容（微博整体）
- (void)setupDetailFrame
{
    HMStatusDetailFrame *detailFrame = [[HMStatusDetailFrame alloc] init];
    detailFrame.status = self.status;
    
//    NSLog(@"计算%zd",self.status.dynamic.images.count);
    NSLog(@"文本类容::%@",self.status.dynamic.content);
    self.detailFrame = detailFrame;
    NSLog(@"xx的%f", CGRectGetMaxY(self.detailFrame.frame));
}

//计算底部工具条
- (void)setupToolbarFrame
{
    CGFloat toolbarX = 0;
    CGFloat toolbarY = CGRectGetMaxY(self.detailFrame.frame);
    CGFloat toolbarW = ScreenWidth;//HMScreenW;
    CGFloat toolbarH = 35;
    self.toolbarFrame = CGRectMake(toolbarX, toolbarY, toolbarW, toolbarH);
    NSLog(@"toolbarFrame高度就是cell的高度👌%f",CGRectGetMaxY(self.toolbarFrame));
}

-(void)setStatus_vlx:(VLX_status *)status{

    _vlx_status = status;

    // 1.计算微博具体内容（微博整体）
    [self setupDetailFrame];

    // 2.计算底部工具条
    [self setupToolbarFrame];

    // 3.计算cell的高度
    self.cellHeight = CGRectGetMaxY(self.toolbarFrame);
    NSLog(@"计算cell的高度%f",self.cellHeight);
}


@end
