//
//  VLXGPSLocationVC.h
//  Vlvxing
//
//  Created by Michael on 17/5/26.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "BaseViewController.h"
typedef void(^gpsBlock)(NSInteger index);
@interface VLXGPSLocationVC : BaseViewController
@property (nonatomic,copy)gpsBlock gpsBlock;
@end
