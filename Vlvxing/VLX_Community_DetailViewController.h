//
//  VLX_Community_DetailViewController.h
//  Vlvxing
//
//  Created by grm on 2017/10/25.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "BaseViewController.h"

//1）首先在创建论坛列表定义@protocol并为该协议定义一个delegate
@protocol commnuity_DetailVcDelegate;


@interface VLX_Community_DetailViewController : BaseViewController

@property (nonatomic,assign)NSDictionary * detailDic;//主题详情
@property (nonatomic,assign)NSDictionary * userDic;//主题发布者,内含主题发布者id
@property(nonatomic,strong)NSString * myselfUserId;//本人ID
@property (nonatomic,strong)NSString * dynamic_id;//帖子id

@property (nonatomic,weak) id<commnuity_DetailVcDelegate> createTargetDelegate;
@property (nonatomic,strong)UIView * fangzhiimgVw2;//放置选择好的单张图片

@property (nonatomic,assign)int tagss;//判断是从哪儿跳转,(null)=cell跳转 ,1=点击评论跳转的

@property(nonatomic,assign)int typee2;//判断是从"我的话题"跳转过来的(1) 还是从"TA的"跳转过来的(2),


@end

@protocol commnuity_DetailVcDelegate <NSObject>
@required
- (void)didFinishCreateTopic:(VLX_Community_DetailViewController * )create;//用户返回时候自动刷新
@end
