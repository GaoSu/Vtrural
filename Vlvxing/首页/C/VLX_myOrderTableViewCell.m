//
//  VLX_myOrderTableViewCell.m
//  Vlvxing
//
//  Created by grm on 2017/10/13.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLX_myOrderTableViewCell.h"

@implementation VLX_myOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self UI];
    }
    return self;
}
-(void)UI{
    
    
    //订单状态
    _typelb = [[UILabel alloc]initWithFrame:CGRectMake(9, 12, 100, 11)];
    _typelb.text = @"订单状态: 已完成";
    _typelb.textColor = [UIColor lightGrayColor];
    _typelb.font = [UIFont systemFontOfSize:11];

    _typelbNO = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 1, 0)];//(100, 1, 1, 0)

    
    _area1Lb = [[UILabel alloc]initWithFrame:CGRectMake(9, 46, 50, 20)];
    _area1Lb.text = @"北京";
    _area1Lb.textAlignment = NSTextAlignmentCenter;
    _area1Lb.textColor = [UIColor grayColor];
    _area1Lb.font = [UIFont systemFontOfSize:19];
    
    UILabel * henggang =[[UILabel alloc]initWithFrame:CGRectMake(61, 55 ,23 , 1.5)];//横杠
    henggang.backgroundColor = [UIColor grayColor];
    
    _area2Lb = [[UILabel alloc]initWithFrame:CGRectMake(86, 46, 50, 20)];
    _area2Lb.text = @"上海";
    _area2Lb.textAlignment = NSTextAlignmentCenter;
    _area2Lb.textColor = [UIColor grayColor];
    _area2Lb.font = [UIFont systemFontOfSize:19];
    
    _jiageLb= [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-80, 50, 70, 20)];
    _jiageLb.text = @"¥1234";
    _jiageLb.textColor = [UIColor grayColor];
    _jiageLb.font = [UIFont systemFontOfSize:19];
    
    _hangbanNoLb = [[UILabel alloc]initWithFrame:CGRectMake(9, 83, 55, 10)];
    _hangbanNoLb.text = @"DG3456";
    _hangbanNoLb.textColor = [UIColor grayColor];
    _hangbanNoLb.font = [UIFont systemFontOfSize:10];
    
    _timeLb =  [[UILabel alloc]initWithFrame:CGRectMake(65, 83, 80, 10)];
    _timeLb.text = @"17-10-23";
    _timeLb.textColor = [UIColor grayColor];
    _timeLb.font = [UIFont systemFontOfSize:10];
    
    _flyLb =  [[UILabel alloc]initWithFrame:CGRectMake(150, 83, 50, 10)];
    _flyLb.text = @"起: 12:12";
    _flyLb.textColor = [UIColor grayColor];
    _flyLb.font = [UIFont systemFontOfSize:10];
    
    _downLb =  [[UILabel alloc]initWithFrame:CGRectMake(5000, 83, 50, 10)];//就是要超出屏幕
//    _flyLb.text = @"起: 12:12";
//    _flyLb.textColor = [UIColor grayColor];
//    _flyLb.font = [UIFont systemFontOfSize:10];
    _zongshichangLb =  [[UILabel alloc]initWithFrame:CGRectMake(5000, 83, 50, 10)];//就是要超出屏幕
    _arriairportcity =  [[UILabel alloc]initWithFrame:CGRectMake(5000, 83, 50, 10)];//就是要超出屏幕;//降落机场
    _deptairportcity =  [[UILabel alloc]initWithFrame:CGRectMake(5000, 83, 50, 10)];//就是要超出屏幕;//起飞机场
    _orderidLb =  [[UILabel alloc]initWithFrame:CGRectMake(5000, 83, 50, 10)];//超出屏幕;
    _ordernoLb =  [[UILabel alloc]initWithFrame:CGRectMake(5000, 83, 50, 10)];//要超出屏幕

    
    
    [self.contentView addSubview:_typelb];
    [self.contentView addSubview:_typelbNO];
    [self.contentView addSubview:_area1Lb];
    [self.contentView addSubview:henggang];
    [self.contentView addSubview:_area2Lb];
    [self.contentView addSubview:_jiageLb];
    [self.contentView addSubview:_hangbanNoLb];
    [self.contentView addSubview:_timeLb];
    [self.contentView addSubview:_flyLb];
    [self.contentView addSubview:_downLb];
    [self.contentView addSubview:_zongshichangLb];
    
    [self.contentView addSubview:_arriairportcity];
    [self.contentView addSubview:_deptairportcity];
    
    [self.contentView addSubview:_ordernoLb];
    [self.contentView addSubview:_orderidLb];

    
    
}
-(void)FillWithModel:(VLX_myOrderModel *)model
{
//    UIImageView * imgv = [[UIImageView alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    
//    [imgv sd_setImageWithURL:[NSURL URLWithString:model.timeStr] placeholderImage:nil];

    self.typelb.text =model.statusdesc;//;
    self.typelbNO.text = [NSString stringWithFormat:@"%d",model.status];//model.status;//;

    self.area1Lb.text = model.deptcity;
    self.area2Lb.text = model.arricity;
    self.jiageLb.text = [NSString stringWithFormat:@"%d",model.nopayamount];
    self.hangbanNoLb.text = model.flightnum;//航班号
    self.timeLb.text = model.deptdate;//日期时间
    self.flyLb.text = [NSString stringWithFormat:@"起: %@",model.depttime];//起飞时间
    self.downLb.text = model.arritime;//落地时间
    self.zongshichangLb.text = model.flighttimes;//总时长
    self.arriairportcity.text = model.arriairportcity;
    self.deptairportcity.text = model.deptairportcity;
    
    self.orderidLb.text = model.orderid;
    self.ordernoLb.text = model.orderno;
    
    
}


@end
