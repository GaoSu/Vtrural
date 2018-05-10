//
//  VLXRouteDetailVC.h
//  Vlvxing
//
//  Created by 王静雨 on 2017/5/24.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "BaseViewController.h"
@class VLXHomeRecommandDataModel;
@interface VLXRouteDetailVC : BaseViewController
@property (nonatomic,copy)NSString *travelproductID;
@property (nonatomic,copy)NSString *adpic;//第一张图片,用于分享


@property(nonatomic,strong) VLXHomeRecommandDataModel *detailModel;
@property (nonatomic,copy)NSString *biaoshi;//biaoshi
@property (nonatomic,copy)NSString *url;

@end
