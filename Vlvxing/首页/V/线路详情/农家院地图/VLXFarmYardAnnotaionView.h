//
//  VLXFarmYardAnnotaionView.h
//  Vlvxing
//
//  Created by 王静雨 on 2017/6/23.
//  Copyright © 2017年 王静雨. All rights reserved.
//

//#import <BaiduMapAPI_Map/BaiduMapAPI_Map.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "VLXHomeDetailModel.h"
typedef void(^farmBlock)();
@interface VLXFarmYardAnnotaionView : BMKAnnotationView
-(void)createUIWithModel:(VLXHomeDetailModel *)detailModel;
@property (nonatomic,copy)farmBlock farmBlock;
@end
