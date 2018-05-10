//
//  VLX_myOrderViewController.h
//  Vlvxing
//
//  Created by grm on 2017/10/13.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "BaseViewController.h"//~我的机票订单

@interface VLX_myOrderViewController : BaseViewController

@property (nonatomic,strong)NSString * biaoqian;//判断是从哪个控制器过来的,1是最开始的,2是买票成功的
@property (nonatomic,strong)NSString * dingdanID;//订单id


@end
