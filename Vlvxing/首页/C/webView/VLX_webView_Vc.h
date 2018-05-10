//
//  VLX_webView_Vc.h
//  Vlvxing
//
//  Created by grm on 2018/2/23.
//  Copyright © 2018年 王静雨. All rights reserved.
//

#import <UIKit/UIKit.h>//用来处理http的url

@interface VLX_webView_Vc : UIViewController
@property (nonatomic,strong)NSString *urlStr;
@property (nonatomic,assign)NSInteger type;//1 火车票 2 机票 3 v头条详情 4点击轮播图
@property(nonatomic,strong)NSString *shareUrl;
@property(nonatomic,strong)NSString *adTitle;//轮播图标题;grm新增
@end
