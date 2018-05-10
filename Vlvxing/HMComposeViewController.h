//
//  HMComposeViewController.h
//  XingJu
//
//  Created by apple on 14-7-7.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import <UIKit/UIKit.h>

//1）首先在创建论坛列表定义@protocol并为该协议定义一个delegate
@protocol createDelegate;



@interface HMComposeViewController : UIViewController


@property (nonatomic,weak) id<createDelegate> createTargetDelegate;
@property (nonatomic,strong)UIView * fangzhiimgVw;//放置选择好的单张图片

@property (nonatomic,assign)int tags;//区分是图片或视频, 0=图片  1=视频,2=已经选好了视频
@end

@protocol createDelegate <NSObject>
@required




- (void)didFinishCreateTopic:(HMComposeViewController*)create;//用户返回时候自动刷新


@end
