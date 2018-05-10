//
//  NotificationView.h
//  judian
//
//  Created by hdkj005 on 15/12/30.
//  Copyright © 2015年 handong001. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NotificationViewDelegate<NSObject>

-(void)NotificationDidSelected;

@end


@interface NotificationView : UIView

@property(nonatomic,weak)id<NotificationViewDelegate>notiDelegate;

-(instancetype)initWithTitle:(NSString *)title;
-(void)show;

@end
