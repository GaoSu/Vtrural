//
//  VLX_jiageTableViewCell.h
//  Vlvxing
//
//  Created by grm on 2017/10/10.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VLX_SearchModel.h"


@interface VLX_jiageTableViewCell : UITableViewCell


@property (nonatomic,strong)UILabel * kaishiTimeLb;//开始时间
@property (nonatomic,strong)UILabel * daodaTimeLb;//到达时间

@property (nonatomic,strong)UILabel * totalTimeLb;//总时长

@property (nonatomic,strong)UILabel * jiageLabel;//价格

@property (nonatomic,strong)UILabel * qifeiAreaLb;//起飞机场
@property (nonatomic,strong)UILabel * daodaAreaLb;//到达机场

@property (nonatomic,strong)UIImageView * biaozhiImgVw;//航班的图标
@property (nonatomic,strong)UILabel * hangbanNameLb;//航班名称
@property (nonatomic,strong)UILabel * hangbanNameLb_2;//航班名称2,这个不展示,只用来传递一下航班,不然空荡荡
@property (nonatomic,strong)UILabel * planNoLb;//飞机型号
@property (nonatomic,strong)UILabel * xianLb2;//分割线

@property (nonatomic,strong)UILabel * jijian;//基建 //燃油
//@property (nonatomic,strong)UILabel * ranyou;//燃油


-(void)FillWithModel:(VLX_SearchModel *)model;


@end
