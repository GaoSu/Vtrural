//
//  VLXWebViewVC.h
//  Vlvxing
//
//  Created by 王静雨 on 2017/6/1.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "BaseViewController.h"
@class VLXVHeadDataModel;
@interface VLXWebViewVC : BaseViewController
@property (nonatomic,copy)NSString *urlStr;
@property (nonatomic,assign)NSInteger type;//1 火车票 2 机票 3 v头条详情 4点击轮播图
@property(nonatomic,strong)NSString *shareUrl;
@property(nonatomic,strong)NSString *adTitle;//轮播图标题;grm新增
//@property (nonatomic,strong)NSString * description;//V头条具体内容
@property(nonatomic,strong) VLXVHeadDataModel *Vmodel; // 如果是v头条的话，就需要传这个参数

-(NSString *)filterHTML:(NSString *)html;

@end
