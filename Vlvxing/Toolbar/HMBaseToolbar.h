//
//  HMBaseToolbar.h
//  XingJu
//
//  Created by apple on 14-7-22.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HMStatus,HMDynamic;

typedef enum {
    HM_Area,//地区
    HMBaseToolbarCollection, //收藏
    HM_Liulanliang,//浏览量
    HMBaseToolbarComment, //评论
    HMBaseToolbarLike  //喜欢
} HMBaseToolbarType;

@class HMStatus,HMBaseToolbar;

@protocol HMBaseToolbarDelegage <NSObject>

@optional
- (void)toolBar:(HMBaseToolbar *)toolBar didClickButtonType:(HMBaseToolbarType)buttonType button:(UIButton *)button dynamic:(HMDynamic *)dynamic;

@end


@interface HMBaseToolbar : UIView

//@property (nonatomic, assign) HMStatus *status;
/** 动态详情模型 */
@property (nonatomic,strong) HMDynamic *dynamic;


/** 点击工具条代理 */
@property (nonatomic,assign) id<HMBaseToolbarDelegage> delegate;


@end
