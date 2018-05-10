//
//  VLXContactInputVC.h
//  Vlvxing
//
//  Created by 王静雨 on 2017/6/26.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "BaseViewController.h"
typedef void(^backBlock)(NSString * text);
@interface VLXContactInputVC : BaseViewController
@property(nonatomic,copy)backBlock backblock;
@property (nonatomic,copy)NSString *titleStr;//标题名称
@end
