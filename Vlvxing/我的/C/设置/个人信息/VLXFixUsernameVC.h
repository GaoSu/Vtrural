//
//  VLXFixUsernameVC.h
//  Vlvxing
//
//  Created by Michael on 17/5/23.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^backBlock)(NSString * nameStr);

@interface VLXFixUsernameVC : BaseViewController
@property(nonatomic,copy)backBlock backblock;

@end
