//
//  HMStatusDetailBottomToolbar.h
//  XingJu
//
//  Created by apple on 14-7-22.
//  Copyright (c) 2014年 heima. All rights reserved.
//  微博详情的底部toolbar


typedef enum {
    HMBottomToolbarCollection, //收藏
    HMBottomToolbarComment, //评论
    HMBottomToolbarLike  //喜欢
} HMBottomToolbarType;

#import <UIKit/UIKit.h>
@class HMStatus,HMStatusDetailBottomToolbar;

@protocol HMStatusDetailBottomToolbarDelegage <NSObject>

@optional
- (void)bottoToolBar:(HMStatusDetailBottomToolbar *)bottomToolBar didClickButtonType:(HMBottomToolbarType)buttonType button:(UIButton *)button status:(HMStatus *)status;

@end

@interface HMStatusDetailBottomToolbar : UIView

/** 点击工具条代理 */
@property (nonatomic,assign) id<HMStatusDetailBottomToolbarDelegage> delegate;

/** 模型 */
@property (nonatomic,strong) HMStatus *status;


@end
