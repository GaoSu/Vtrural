
//
//  VLX_jiageTableViewCell.m
//  Vlvxing
//
//  Created by grm on 2017/10/10.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLX_jiageTableViewCell.h"

@implementation VLX_jiageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self makeUI];
    }
         return self;
}
-(void)makeUI{
    
    
    //开始时间
    _kaishiTimeLb = [[UILabel alloc]initWithFrame:CGRectMake(10, 38/2, 60, 20)];
    _kaishiTimeLb.text = @"12:31";
//    _kaishiTimeLb.backgroundColor = [UIColor yellowColor];
    _kaishiTimeLb.textColor = [UIColor blackColor];
    _kaishiTimeLb.textAlignment = NSTextAlignmentCenter;
    _kaishiTimeLb.font = [UIFont systemFontOfSize:20];
    //总时长
    _totalTimeLb = [[UILabel alloc]initWithFrame:CGRectMake(95*(ScreenWidth/375), 24, 80, 11)];
    _totalTimeLb.text = @"3小时10分钟";
    _totalTimeLb.textAlignment = NSTextAlignmentCenter;
    _totalTimeLb.textColor = [UIColor lightGrayColor];
    _totalTimeLb.font = [UIFont systemFontOfSize:11];
    
    UILabel * line = [[UILabel alloc]initWithFrame:CGRectMake(95*(ScreenWidth/375), 37, 80, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    //到达时间
    _daodaTimeLb = [[UILabel alloc]initWithFrame:CGRectMake(420/2*(ScreenWidth/375), 38/2, 60, 20)];
    _daodaTimeLb.text = @"12:31";
    _daodaTimeLb.textColor = [UIColor blackColor];
//    _daodaTimeLb.textAlignment = NSTextAlignmentCenter;
    _daodaTimeLb.font = [UIFont systemFontOfSize:20];
       //价格
    _jiageLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-75, 20, 70, 20)];
    _jiageLabel.text = @"¥1231";
    _jiageLabel.textAlignment = NSTextAlignmentLeft;
    _jiageLabel.textColor = [UIColor redColor];
    _jiageLabel.font = [UIFont systemFontOfSize:20];
    
    //起飞机场
    _qifeiAreaLb = [[UILabel alloc]initWithFrame:CGRectMake(10, 52, 85, 11)];
    _qifeiAreaLb.text = @"首都T2";
    _qifeiAreaLb.textColor = [UIColor lightGrayColor];
    _qifeiAreaLb.textAlignment = NSTextAlignmentLeft;
    _qifeiAreaLb.font = [UIFont systemFontOfSize:11];
    //到达机场
    _daodaAreaLb = [[UILabel alloc]initWithFrame:CGRectMake(430/2*(ScreenWidth/375), 52, 85, 11)];
    _daodaAreaLb.text = @"南极T4";
    _daodaAreaLb.textColor = [UIColor lightGrayColor];
    _daodaAreaLb.textAlignment = NSTextAlignmentLeft;
    _daodaAreaLb.font = [UIFont systemFontOfSize:11];
    //航班的图标
    _biaozhiImgVw = [[UIImageView alloc]initWithFrame:CGRectMake(10, 83, 19, 17)];
    _biaozhiImgVw.image = [UIImage imageNamed:@"航空标志小"];
    
    
    //航班名称 // 根据字体得到NSString的尺寸
    _hangbanNameLb = [[UILabel alloc]init];

    
    _hangbanNameLb_2 = [[UILabel alloc]init];//不设置尺寸,因为不需要展示
    
//    //分割线
   _xianLb2 = [[UILabel alloc]initWithFrame:CGRectMake(35+_hangbanNameLb.frame.size.width+3, 86, 1, 11)];
    _xianLb2.backgroundColor = [UIColor lightGrayColor];
    

    //飞机型号
    _planNoLb = [[UILabel alloc]initWithFrame:CGRectMake(35+_hangbanNameLb.frame.size.width+6, 86, 80, 11)];
    _planNoLb.text = @"吉利A330";
    _planNoLb.textAlignment = NSTextAlignmentLeft;
//    _planNoLb.backgroundColor = [UIColor yellowColor];
    _planNoLb.textColor = [UIColor lightGrayColor];
    _planNoLb.font = [UIFont systemFontOfSize:11];
    
    
    _jijian = [[UILabel alloc]initWithFrame:CGRectMake(1000, 86, 80, 11)];

//    _ranyou = [[UILabel alloc]initWithFrame:CGRectMake(1000, 86, 80, 11)];
    
    [self.contentView addSubview:_kaishiTimeLb];
    [self.contentView addSubview:_daodaTimeLb];
    [self.contentView addSubview:_totalTimeLb];
    [self.contentView addSubview:_jiageLabel];
    [self.contentView addSubview:_qifeiAreaLb];
    [self.contentView addSubview:_daodaAreaLb];
    [self.contentView addSubview:_biaozhiImgVw];
    
    [self.contentView addSubview:_hangbanNameLb];
    [self.contentView addSubview:_planNoLb];

    
    [self.contentView addSubview:_xianLb2];
    [self.contentView addSubview:line];
    
    [self.contentView addSubview:_hangbanNameLb_2];
    
    [self.contentView addSubview:_jijian];
//    [self.contentView addSubview:_ranyou];
    


}

-(void)FillWithModel:(VLX_SearchModel *)model
{
//    [_biaozhiImgVw sd_setImageWithURL:[NSURL URLWithString:model.imgUrl]placeholderImage:nil];
    
//    //地点
//    _areaLb.text = model.location;
    
    _kaishiTimeLb.text = model.dptTime;
    _daodaTimeLb.text = model.arrTime;
    _totalTimeLb.text = model.flightTimes;
    _jiageLabel.text = [NSString stringWithFormat:@"¥%.0f", model.barePrice];//不要小数点
    
    _qifeiAreaLb.text = model.dptAirport;
    _daodaAreaLb.text = model.arrAirport;
    
//w:_biaozhiImgVw];

    _hangbanNameLb.text = model.airlineName;
    UIFont *fnt = [UIFont fontWithName:@"HelveticaNeue" size:11.0f];
    _hangbanNameLb.font = fnt;
    CGSize StringSize = [_hangbanNameLb.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName,nil]];
    CGFloat hangbanLb_width = StringSize.width;
    _hangbanNameLb.frame = CGRectMake(35, 86, hangbanLb_width, 11);
    _hangbanNameLb.textColor = [UIColor lightGrayColor];
    
    //分割线

    _xianLb2.frame = CGRectMake(hangbanLb_width+35+3, 86, 1, 11);
//    [self.contentView addSubview:_xianLb2];
    _planNoLb.frame = CGRectMake(hangbanLb_width+35+2+6, 86, 80, 11);
    
    
    _planNoLb.text = model.flightTypeFullName;
    
    _hangbanNameLb_2.text = model.flightNum;
    
    _jijian.text = [NSString  stringWithFormat:@"%d",(model.arf + model.tof)];
    
}




@end
