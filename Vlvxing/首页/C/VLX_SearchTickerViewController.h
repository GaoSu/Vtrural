//
//  VLX_SearchTickerViewController.h
//  Vlvxing
//
//  Created by grm on 2017/10/9.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "BaseViewController.h"



@class VLX_SearchTickerViewController;
@protocol vlx_searchSCROLLVEW_Delegate <NSObject>

//协议传值,设置滚动尺滚动恰到好处
-(void)MyTargetVC:(VLX_SearchTickerViewController *)write ValueChange:(int )value;

@end
#define rgba(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
@interface VLX_SearchTickerViewController : BaseViewController
@property (nonatomic,strong)NSString * area1;//起飞机场
@property (nonatomic,strong)NSString * area2;//达到机场
@property (nonatomic,strong)NSString * bookDateStr;//用户选择的起飞时间
@property (nonatomic,strong) NSString *locationStr;//当前时间
@property (nonatomic,strong )NSString * xingqijiStr;//星期几

@property (nonatomic,strong)NSString * ex_trackStr;//特惠




//self.backgroundColor = rgba(240, 240, 240, 0.8);
@property (nonatomic, weak) id<vlx_searchSCROLLVEW_Delegate> delegate;


@end
