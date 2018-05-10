//
//  HMStatusDetailView.h
//  XingJu
//
//  Created by apple on 14-7-14.
//  Copyright (c) 2014年 heima. All rights reserved.
//  微博的具体内容 = 原创微博 + 转发微博

#import <UIKit/UIKit.h>
@class HMStatusDetailFrame,HMStatusOriginalView;

@interface HMStatusDetailView : UIImageView
@property (nonatomic, strong) HMStatusDetailFrame *detailFrame;

//原创
@property (nonatomic, weak) HMStatusOriginalView *originalView;
@end
