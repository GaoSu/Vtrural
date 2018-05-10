//
//  VLX_youbianlanTableViewCell.h
//  Vlvxing
//
//  Created by grm on 2017/10/10.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import <UIKit/UIKit.h>




@interface VLX_youbianlanTableViewCell : UITableViewCell///右边栏
@property (assign, nonatomic) id delegate; // 代理
@property (nonatomic, strong) UILabel * youbianlanname;
@property (nonatomic, strong) UILabel * youbianlanJiage;
@property (nonatomic, strong)UIButton * selectBt;

@end
