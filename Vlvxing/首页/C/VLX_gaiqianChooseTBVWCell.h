//
//  VLX_gaiqianChooseTBVWCell.h
//  Vlvxing
//
//  Created by grm on 2017/11/21.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VLX_gaiqianChooseModel.h"

@interface VLX_gaiqianChooseTBVWCell : UITableViewCell

@property (nonatomic,strong)UILabel * kaishiTimeLb;//开始时间
@property (nonatomic,strong)UILabel * daodaTimeLb;//到达时间

@property (nonatomic,strong)UILabel * totalTimeLb;//总时长

@property (nonatomic,strong)UILabel * gqLabel;//改签价格
@property(nonatomic,strong)UILabel * upgradeFeelb;//升舱费
@property (nonatomic,strong)UILabel * qifeiAreaLb;//起飞机场
@property (nonatomic,strong)UILabel * daodaAreaLb;//到达机场

@property (nonatomic,strong)UIImageView * biaozhiImgVw;//航班的图标

@property (nonatomic,strong)UILabel * hangbanNumberLb;//不展示,航班号
@property (nonatomic,strong)UILabel * cabinCodeLb;//不展示,改签用字段
@property (nonatomic,strong)UILabel * hangkonggsNameLb2;//航空公司名称 这个不展示,只向下传递

@property (nonatomic,strong)UILabel * hangbanNameLb_2;//航班名称2,这个不展示,只用来传递一下航班,不然空荡荡
@property (nonatomic,strong)UILabel * planNoLb;//飞机型号
@property (nonatomic,strong)UILabel * xianLb2;//分割线

@property (nonatomic,strong)UILabel * allfeeLb;//又一个价格
//@property (nonatomic,strong)UILabel * ranyou;//燃油
@property (nonatomic,strong)UILabel * uniqKeyLb;//uniqKey用于传值


-(void)FillWithModel:(VLX_gaiqianChooseModel *)model;



@end
