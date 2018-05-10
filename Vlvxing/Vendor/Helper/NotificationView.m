//
//  NotificationView.m
//  judian
//
//  Created by hdkj005 on 15/12/30.
//  Copyright © 2015年 handong001. All rights reserved.
//

#import "NotificationView.h"
#define ScreenSize [UIScreen mainScreen].bounds.size

@interface NotificationView ()

@property(nonatomic,assign) BOOL isShow;

@end

@implementation NotificationView

-(instancetype)initWithTitle:(NSString *)title{
    if(self = [super init]){
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.8;
        self.isShow = NO;
        self.frame = CGRectMake(0, 20, ScreenSize.width, 64);
        self.userInteractionEnabled=YES;
        [self addSubviewsWithTitle:title];
        
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moveToNotification:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

-(void)addSubviewsWithTitle:(NSString *)title{
    
    UIImageView *iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 15, 30, 30)];
    iconImageView.image  =[UIImage imageNamed:@"login_logo"];
    [self addSubview:iconImageView];
    
    UILabel * nameLable=[[UILabel alloc] initWithFrame:CGRectMake(60, 12, ScreenSize.width - 60, 15)];
    nameLable.backgroundColor = [UIColor clearColor];
    nameLable.numberOfLines = 0;
    nameLable.text = @"g系统消息";
    nameLable.textColor = [UIColor whiteColor];
    nameLable.font = [UIFont systemFontOfSize:13];
    [self addSubview:nameLable];
    
    
    
    UILabel *NoticeLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 30, ScreenSize.width - 60, 30)];
    NoticeLabel.backgroundColor = [UIColor clearColor];
    NoticeLabel.numberOfLines = 0;
    NoticeLabel.text = title;
    NoticeLabel.textColor = [UIColor whiteColor];
    NoticeLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:NoticeLabel];
    
}

-(void)show{
    if(!self.isShow){
        self.isShow = YES;
        [UIView animateWithDuration:0.25 animations:^{
            UIView *view = [[UIApplication sharedApplication].windows lastObject];
            self.frame = CGRectMake(0, 0, ScreenSize.width, 64);
            [view addSubview:self];
        } completion:^(BOOL finished) {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.25 animations:^{
                    self.frame = CGRectMake(0, 0, ScreenSize.width, 64);
                } completion:^(BOOL finished) {
                    [self removeFromSuperview];
                    self.isShow = NO;
                }];
            });
            
        }];
    }
}

-(void)moveToNotification:(UITapGestureRecognizer *)tap{

    if ([self.notiDelegate respondsToSelector:@selector(NotificationDidSelected)]) {
        
        [self.notiDelegate NotificationDidSelected];
    }

}




@end
