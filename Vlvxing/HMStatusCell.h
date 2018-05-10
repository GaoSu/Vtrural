//
//  HMStatusCell.h
//  XingJu
//
//  Created by apple on 14-7-14.
//  Copyright (c) 2014年 heima. All rights reserved.
//  微博cell


#import <UIKit/UIKit.h>
@class HMStatusFrame,HMStatusDetailView,HMStatusToolbar;


@interface HMStatusCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) HMStatusFrame *statusFrame;
//详情
@property (nonatomic, weak) HMStatusDetailView *detailView;

//工具条
@property (nonatomic, weak) HMStatusToolbar *toolbar;

@end
