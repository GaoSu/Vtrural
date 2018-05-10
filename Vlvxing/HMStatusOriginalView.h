//
//  HMStatusOriginalView.h
//  XingJu
//
//  Created by apple on 14-7-14.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HMStatusOriginalFrame,HMStatusOriginalView;

@protocol HMStatusOriginalViewDelegate <NSObject>

@optional
- (void)statusOriginalViewDidClickPlayButton:(HMStatusOriginalView *)statusOriginalView;

@end

@interface HMStatusOriginalView : UIView

@property (nonatomic, strong) HMStatusOriginalFrame *originalFrame;

/** 点击播放按钮代理 */
@property (nonatomic,assign) id<HMStatusOriginalViewDelegate> delegate;

@end
