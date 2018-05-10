//
//  HMStatusDetailTopToolbar.h
//  XingJu
//
//  Created by apple on 14-7-22.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    HMStatusDetailTopToolbarButtonTypeComment,
    HMStatusDetailTopToolbarButtonTypeLike,
    
} HMStatusDetailTopToolbarButtonType;

@class HMStatusDetailTopToolbar, HMStatus;

@protocol HMStatusDetailTopToolbarDelegate <NSObject>

@optional
- (void)topToolbar:(HMStatusDetailTopToolbar *)topToolbar didSelectedButton:(HMStatusDetailTopToolbarButtonType)buttonType;
@end

@interface HMStatusDetailTopToolbar : UIView
+ (instancetype)toolbar;

/** 收藏 */
@property (weak, nonatomic) IBOutlet UIButton *retweetedButton;
/** 评论 */
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
/** 点赞 */
@property (weak, nonatomic) IBOutlet UIButton *attitudeButton;

@property (nonatomic, weak) id<HMStatusDetailTopToolbarDelegate> delegate;
@property (nonatomic, assign) HMStatus *status;
@end
