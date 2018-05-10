//
//  VLX_guanzhuVC.h
//  Vlvxing
//
//  Created by grm on 2018/2/6.
//  Copyright © 2018年 王静雨. All rights reserved.
//

#import "BaseViewController.h"

//#import "WeatherModel.h";


@protocol JohnScrollViewDelegate<NSObject>

@optional
- (void)johnScrollViewDidScroll:(CGFloat)scrollY;

@end







@interface VLX_guanzhuVC : BaseViewController
@property (nonatomic,copy) void(^DidScrollBlock)(CGFloat scrollY);
@property (nonatomic,strong) UITableView *tableView1;

@property (nonatomic,strong)NSNumber * otherID;
@property (nonatomic,weak) id<JohnScrollViewDelegate>delegate;



@end
