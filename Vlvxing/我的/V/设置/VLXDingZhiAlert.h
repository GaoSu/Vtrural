//
//  VLXDingZhiAlert.h
//  Vlvxing
//
//  Created by Michael on 17/5/22.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VLXDingZhiAlertDelegate <NSObject>

-(void)BringBackValue:(NSInteger)num;

@end




@interface VLXDingZhiAlert : UIView
@property(nonatomic,strong)UIView *alertview;
@property(nonatomic,strong)UILabel * tishilabel;
@property(nonatomic,strong)UIView * orangeview;
@property(nonatomic,strong)UILabel * midlabel;
@property(nonatomic,strong)UILabel * leftlabel;
@property(nonatomic,strong)UIView * midview;
@property(nonatomic,strong)UILabel * rightlabel;
@property(nonatomic,strong)UIView * line;
@property(nonatomic,strong)UIButton * leftBtn;
@property(nonatomic,strong)UIButton * rightBtn;
@property(nonatomic,assign)id<VLXDingZhiAlertDelegate>delegate;

@end
