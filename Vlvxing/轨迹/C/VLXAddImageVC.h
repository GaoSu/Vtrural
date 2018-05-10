//
//  VLXAddImageVC.h
//  Vlvxing
//
//  Created by 王静雨 on 2017/6/6.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "BaseViewController.h"

@interface VLXAddImageVC : BaseViewController
@property (nonatomic,strong)UIImage *image;
@property (nonatomic,assign)NSInteger type;//1表示单个点  2表示轨迹
@property (nonatomic,strong)CLLocation *location;//当前用户位置

@end
