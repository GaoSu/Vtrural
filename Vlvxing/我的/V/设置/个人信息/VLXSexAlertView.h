//
//  VLXSexAlertView.h
//  Vlvxing
//
//  Created by Michael on 17/5/23.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VLXSexAlertViewDelegate <NSObject>

-(void)bringBackMessage:(NSInteger)type;

@end


@interface VLXSexAlertView : UIView
@property(nonatomic,assign)id<VLXSexAlertViewDelegate>delegate;
@end
