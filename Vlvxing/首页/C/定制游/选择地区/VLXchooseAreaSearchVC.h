//
//  VLXchooseAreaSearchVC.h
//  Vlvxing
//
//  Created by 王静雨 on 2017/6/1.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "BaseViewController.h"
#import "VLXSearchKeyWordModel.h"
typedef void(^resultBlock)(VLXSearchKeyWordDataModel *model);
@interface VLXchooseAreaSearchVC : BaseViewController
@property (nonatomic,copy)NSString *searchStr;
@property (nonatomic,copy)resultBlock resultBlock;
@end
