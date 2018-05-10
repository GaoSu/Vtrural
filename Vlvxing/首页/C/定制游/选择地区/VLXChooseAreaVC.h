//
//  VLXChooseAreaVC.h
//  Vlvxing
//
//  Created by Michael on 17/5/26.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "BaseViewController.h"
#import "VLXChooseAreaModel.h"
typedef void(^areaBlock)(VLXChooseAreaListModel *listModel);
@interface VLXChooseAreaVC : BaseViewController
@property (nonatomic,copy)areaBlock areaBlock;
@end
