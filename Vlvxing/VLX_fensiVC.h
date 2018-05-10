//
//  VLX_fensiVC.h
//  Vlvxing
//
//  Created by grm on 2018/2/6.
//  Copyright © 2018年 王静雨. All rights reserved.
//

#import "BaseViewController.h"

@interface VLX_fensiVC : BaseViewController

@property (nonatomic,copy) void(^DidScrollBlock)(CGFloat scrollY);

@property (nonatomic,strong) UITableView *tableView2;
@property (nonatomic,strong)NSNumber * otherID2;

@end
