//
//  VLXAddVideoVC.h
//  Vlvxing
//
//  Created by 王静雨 on 2017/6/13.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "BaseViewController.h"

@interface VLXAddVideoVC : BaseViewController

@property (nonatomic,strong)NSURL *url;//本地路径
@property (nonatomic,assign)NSInteger type;//1表示单个点  2表示轨迹
@property (nonatomic,strong)CLLocation *location;//当前用户位置
@end
