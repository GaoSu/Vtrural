
//
//  VLX_guanzhutixing_TableViewCell.m
//  Vlvxing
//
//  Created by grm on 2017/10/30.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLX_guanzhutixing_TableViewCell.h"

@implementation VLX_guanzhutixing_TableViewCell//关注提醒cell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self UI];
    }
    return self;
}
-(void)UI
{
    _HeadimgVw = [[UIImageView alloc]initWithFrame:CGRectMake(15, 25, 36, 36)];
    _HeadimgVw.backgroundColor = [UIColor lightGrayColor];
    _HeadimgVw.layer.cornerRadius = 18;
    _HeadimgVw.clipsToBounds = YES;
    
    _nameLB = [[UILabel alloc]init];
    _nameLB.text = @"我是王小二";
    UIFont *font1 = [UIFont fontWithName:@"Courier New" size:17.0f];
    _nameLB.font = font1;
    CGSize size1 = [_nameLB.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font1,NSFontAttributeName,nil]];
    CGFloat nameW = size1.width;
    _nameLB.frame = CGRectMake(63,30, nameW,17);
    
    _timeLb = [[UILabel alloc]initWithFrame:CGRectMake(63 +_nameLB.frame.size.width, 34, 105, 10)];//年月日
    _timeLb.font = [UIFont systemFontOfSize:9];
    _timeLb.text = @"2017-11-11 -- --- -";
    _timeLb.textColor =[UIColor grayColor];
    
    _tishiLb = [[UILabel alloc]initWithFrame:CGRectMake(60, 70,ScreenWidth - 75, 13)];//提示文字
    _tishiLb.text = @"Hi!我已经关注了你,成为您的粉丝,快来和我一起V旅行吧!";
    _tishiLb.textColor =[ UIColor lightGrayColor];
    _tishiLb.font = [UIFont systemFontOfSize:12];
    
    
    [self.contentView addSubview:_HeadimgVw];
    [self.contentView addSubview:_nameLB];
    [self.contentView addSubview:_timeLb];
    [self.contentView addSubview:_tishiLb];
    
}

- (void)FillWithModel:(VLX_plwdModel *)model{
    
    [_HeadimgVw sd_setImageWithURL:[NSURL URLWithString:model.userpic] placeholderImage:nil];
    NSTimeInterval interval = [model.createTime doubleValue]/1000.0;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-mm-dd HH:mm:ss"];
    NSString *dateString = [formatter stringFromDate:date];
    _timeLb.text = dateString;
    _nameLB.text = model.usernick;
}

@end
