//
//  ShareBtnView.h
//  ZuoXun
//
//  Created by handong001 on 17/4/27.
//  Copyright © 2017年 handong001. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShareBtnViewDelegate <NSObject>
@optional
-(void)didClickCloseBtn;

@end
typedef void(^btnShareBlock)(NSInteger tag);
@interface ShareBtnView : UIView

//@property(nonatomic,weak)id<shareDelegate>delegate;
@property (nonatomic,copy)btnShareBlock btnShareBlock;
@property(nonatomic,weak) id <ShareBtnViewDelegate> delegate;

@end
