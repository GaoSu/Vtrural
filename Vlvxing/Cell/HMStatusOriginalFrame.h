//
//  HMStatusOriginalFrame.h
//  XingJu
//
//  Created by apple on 14-7-14.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HMStatus;

@interface HMStatusOriginalFrame : NSObject

/** 微博数据 */
@property (nonatomic, strong) HMStatus *status;

/** 昵称 */
@property (nonatomic, assign) CGRect nameFrame;
/** 正文 */
@property (nonatomic, assign) CGRect textFrame;
/** 头像 */
@property (nonatomic, assign) CGRect iconFrame;
/** 会员图标 */
@property (nonatomic, assign) CGRect vipFrame;
/** 配图相册  */
@property (nonatomic, assign) CGRect photosFrame;

/** 视频 */
@property (nonatomic,assign) CGRect videoViewFrame;
/** 视频上默认显示的图片 */
@property (nonatomic,assign) CGRect videoImageFrame;
/** 播放按钮 */
@property (nonatomic,assign) CGRect playBtnFrame;


/** 自己的frame */
@property (nonatomic, assign) CGRect frame;



@end
