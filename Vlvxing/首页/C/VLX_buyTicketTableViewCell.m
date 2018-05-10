
//
//  VLX_buyTicketTableViewCell.m
//  Vlvxing
//
//  Created by grm on 2017/10/13.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLX_buyTicketTableViewCell.h"

@implementation VLX_buyTicketTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    self.contentView.backgroundColor = [UIColor whiteColor];
    
}
//高亮
-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self ui];
    }
    return self;
}
-(void)ui{
    
    _timeLb =  [[UILabel alloc]init];
    _timeLb.text = @"2017年10月23日";
//    _timeLb.textColor = [UIColor grayColor];
    _timeLb.font = [UIFont systemFontOfSize:17];
    UIFont *fnt = [UIFont fontWithName:@"HelveticaNeue" size:17.0f];
    _timeLb.font = fnt;
    CGSize StringSize = [_timeLb.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName,nil]];
    CGFloat wth = StringSize.width;
    _timeLb.frame = CGRectMake(22, 20, wth, 18);
    
    
    
    
    
    _xingqiLb = [[UILabel alloc]initWithFrame:CGRectMake(22+wth + 10, 21, 55, 18)];
    _xingqiLb.text = @"周五";
    //    _flyLb.textColor = [UIColor grayColor];
    _xingqiLb.font = [UIFont systemFontOfSize:16];

    
    
//    _flyLb =  [[UILabel alloc]initWithFrame:CGRectMake(105, 20, 70, 18)];
//    _flyLb.text = @"起飞: 12:12";
////    _flyLb.textColor = [UIColor grayColor];
//    _flyLb.font = [UIFont systemFontOfSize:17];
    
    [self.contentView addSubview:_timeLb];
    [self.contentView addSubview:_xingqiLb];

//    [self.contentView addSubview:_flyLb];
    

    
}



@end
