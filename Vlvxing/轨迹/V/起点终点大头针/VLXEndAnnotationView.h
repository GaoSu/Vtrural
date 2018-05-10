//
//  VLXEndAnnotationView.h
//  Vlvxing
//
//  Created by 王静雨 on 2017/6/7.
//  Copyright © 2017年 王静雨. All rights reserved.
//

//#import <BaiduMapAPI_Map/BaiduMapAPI_Map.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
@interface VLXEndAnnotationView : BMKAnnotationView
@property (nonatomic, strong) UIImageView *annotationImageView;
@property (nonatomic,strong)UILabel *titleLab;//标题
@end
