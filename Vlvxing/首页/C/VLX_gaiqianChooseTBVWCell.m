
//
//  VLX_gaiqianChooseTBVWCell.m
//  Vlvxing
//
//  Created by grm on 2017/11/21.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLX_gaiqianChooseTBVWCell.h"

@implementation VLX_gaiqianChooseTBVWCell

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
    
    UILabel * line = [[UILabel alloc]initWithFrame:CGRectMake(115*(ScreenWidth/375), 37, 40, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    //到达时间
    _daodaTimeLb = [[UILabel alloc]initWithFrame:CGRectMake(420/2*(ScreenWidth/375), 38/2, 60, 20)];
    _daodaTimeLb.text = @"12:31";
    _daodaTimeLb.textColor = [UIColor blackColor];
    //    _daodaTimeLb.textAlignment = NSTextAlignmentCenter;
    _daodaTimeLb.font = [UIFont systemFontOfSize:20];
    //改签价格
    _gqLabel = [[UILabel alloc]initWithFrame:CGRectMake(2000, 20, 70, 20)];
    //升舱价格
    _upgradeFeelb= [[UILabel alloc]initWithFrame:CGRectMake(2000, 20, 70, 20)];
    
    //固定显示
    UILabel * gaiqinaLb = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-75, 44, 70, 17)];
    gaiqinaLb.text = @"改签费";
    gaiqinaLb.textColor = [UIColor lightGrayColor];
    gaiqinaLb.font = [UIFont systemFontOfSize:16];

    
    
    //起飞机场
    _qifeiAreaLb = [[UILabel alloc]initWithFrame:CGRectMake(10, 52, 115, 11)];
    _qifeiAreaLb.text = @"首都T2";
    _qifeiAreaLb.textColor = [UIColor lightGrayColor];
    _qifeiAreaLb.textAlignment = NSTextAlignmentLeft;
    _qifeiAreaLb.font = [UIFont systemFontOfSize:11];
    //到达机场
//    _daodaAreaLb = [[UILabel alloc]initWithFrame:CGRectMake(430/2*(ScreenWidth/375), 52, 85, 11)];
    _daodaAreaLb = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-75-115-5, 52, 115, 11)];
    _daodaAreaLb.text = @"南极T4";
    _daodaAreaLb.textColor = [UIColor lightGrayColor];
    _daodaAreaLb.textAlignment = NSTextAlignmentRight;
    _daodaAreaLb.font = [UIFont systemFontOfSize:11];
    //航班的图标
    _biaozhiImgVw = [[UIImageView alloc]initWithFrame:CGRectMake(10, 83, 19, 17)];
    _biaozhiImgVw.image = [UIImage imageNamed:@"航空标志小"];
    
    
    //航空公司名称 // 根据字体得到NSString的尺寸
    _hangbanNumberLb = [[UILabel alloc]init];
    _hangkonggsNameLb2 = [[UILabel alloc]init];
    
    _hangbanNameLb_2 = [[UILabel alloc]init];//不设置尺寸,因为不需要展示
    _cabinCodeLb     = [[UILabel alloc]init];//不设置尺寸,因为不需要展示
    
    _uniqKeyLb = [[UILabel alloc]init];

    
    //飞机型号
    _planNoLb = [[UILabel alloc]initWithFrame:CGRectMake(35+_hangbanNumberLb.frame.size.width+6, 86, 180, 11)];
    _planNoLb.text = @"吉利A330";
    _planNoLb.textAlignment = NSTextAlignmentLeft;
    //    _planNoLb.backgroundColor = [UIColor yellowColor];
    _planNoLb.textColor = [UIColor lightGrayColor];
    _planNoLb.font = [UIFont systemFontOfSize:11];
    
    
    _allfeeLb = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-75, 20, 70, 20)];//
    _allfeeLb.text = @"";
    _allfeeLb.textAlignment = NSTextAlignmentLeft;
    _allfeeLb.textColor = [UIColor redColor];
    _allfeeLb.font = [UIFont systemFontOfSize:20];
    
    [self.contentView addSubview:_kaishiTimeLb];
    [self.contentView addSubview:_daodaTimeLb];
    [self.contentView addSubview:_totalTimeLb];
    [self.contentView addSubview:_gqLabel];
    [self.contentView addSubview:_upgradeFeelb];
    [self.contentView addSubview:_qifeiAreaLb];
    [self.contentView addSubview:_daodaAreaLb];
    [self.contentView addSubview:_biaozhiImgVw];
    [self.contentView addSubview:gaiqinaLb];
    [self.contentView addSubview:_hangbanNumberLb];
    [self.contentView addSubview:_hangkonggsNameLb2];
    [self.contentView addSubview:_planNoLb];
    [self.contentView addSubview:_uniqKeyLb];
    
    [self.contentView addSubview:line];
    
    [self.contentView addSubview:_hangbanNameLb_2];
    
    [self.contentView addSubview:_allfeeLb];
    
    
}

-(void)FillWithModel:(VLX_gaiqianChooseModel *)model
{

}
@end
