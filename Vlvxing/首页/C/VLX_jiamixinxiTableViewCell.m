//
//  VLX_jiamixinxiTableViewCell.m
//  Vlvxing
//
//  Created by grm on 2017/11/20.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLX_jiamixinxiTableViewCell.h"

@implementation VLX_jiamixinxiTableViewCell

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
//    UIView * view2  = [[UIView alloc]initWithFrame:CGRectMake(0, 159+7+7 + 87*i, ScreenWidth, 135)];
//    view2.backgroundColor = [UIColor whiteColor];
    
    UILabel * chengjirenLb = [[UILabel alloc]initWithFrame:CGRectMake(10, 25, 56, 16)];
    chengjirenLb.text = @"乘机人";
    chengjirenLb.textColor =[UIColor lightGrayColor];
    chengjirenLb.font = [UIFont systemFontOfSize:16];
    
    _nameLb = [[UILabel alloc]initWithFrame:CGRectMake(82, 25, 70, 16)];
    _nameLb.text = @"臧三";
    _nameLb.font = [UIFont systemFontOfSize:16];
    //        NSLog(@"张三吗:%@",stringg);
    
    
    
    _shenfenzhengLb = [[UILabel alloc]initWithFrame:CGRectMake(82, 58, 235, 16)];
    NSString * sfz_a = @"123456789012345678";//_chengkexinxiAry[@"cardno"];
    NSString * sfz_b = [[NSString alloc]init];
    NSRange range_sfz=NSMakeRange (4, 10);//从第4位开始的10位数转换成****
    sfz_b= [sfz_a stringByReplacingCharactersInRange:range_sfz withString:@"****"];
    _shenfenzhengLb.text = [NSString stringWithFormat:@"身份证: %@",sfz_b];
    _shenfenzhengLb.font = [UIFont systemFontOfSize:16];
    
    UILabel * _line1 = [[UILabel alloc]initWithFrame:CGRectMake(15, 86, ScreenWidth-30, 1)];
    _line1.backgroundColor =rgba(240, 240, 240, 1);
    
    [self.contentView addSubview:_nameLb];
    [self.contentView addSubview:_shenfenzhengLb];
    [self.contentView addSubview:_line1];
    

}

-(void)FillWithModel:(VLX_jiamixinxiModel *)model{
    self.nameLb.text =model.name;//;
    self.shenfenzhengLb.text = model.cardno;
}



@end
