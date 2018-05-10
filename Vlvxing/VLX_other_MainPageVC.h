//
//  VLX_other_MainPageVC.h
//  Vlvxing
//
//  Created by grm on 2018/2/6.
//  Copyright © 2018年 王静雨. All rights reserved.
//

#import "BaseViewController.h"

@interface VLX_other_MainPageVC : BaseViewController

@property(nonatomic,strong)NSDictionary * userDic;//用户字典
@property(nonatomic,strong)NSString * guanzhutitle;//关注否
@property(nonatomic,strong)NSString * myselfUserId;//本人ID

@property(nonatomic,assign)int typee;//从主贴头像直接跳转的0,评论的用户头像1,蓝色的用户名2;
@property(nonatomic,strong)NSString * nickNamme;//昵称



@end
