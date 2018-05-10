//
//  VLX_TA_huatiVC.h
//  Vlvxing
//
//  Created by grm on 2018/2/6.
//  Copyright © 2018年 王静雨. All rights reserved.
//

#import "BaseViewController.h"

@interface VLX_TA_huatiVC : BaseViewController
@property (nonatomic,copy) void(^DidScrollBlock)(CGFloat scrollY);
@property (nonatomic,strong) UITableView *tableView3;

@property (nonatomic,strong)NSNumber * otherID3;

@end
