//
//  VLXUnLoginHeaderView.h
//  Vlvxing
//
//  Created by 王静雨 on 2017/5/18.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^loginBlock)(NSInteger type);//type  1表示登录   2表示点设置
@interface VLXUnLoginHeaderView : UIView//没有登录
@property (nonatomic,copy)loginBlock loginBlock;
@end
