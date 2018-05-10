//
//  VLX_message_CommTableViewCell.m
//  Vlvxing
//
//  Created by grm on 2017/10/30.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLX_message_CommTableViewCell.h"

@implementation VLX_message_CommTableViewCell

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
    _imgVw = [[UIImageView alloc]initWithFrame:CGRectMake(15, 20, 35, 30)];
    
    _titleLB = [[UILabel alloc]initWithFrame:CGRectMake(70, 22, 100, 18)];
    _titleLB.textColor = [UIColor grayColor];
    
    _xiaohongdianLb = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-20, 13, 12, 12)];
    _xiaohongdianLb.backgroundColor = orange_color;
    _xiaohongdianLb.layer.cornerRadius = 6;
    _xiaohongdianLb.clipsToBounds = YES;
    
    
    [self.contentView addSubview:_imgVw];
    [self.contentView addSubview:_titleLB];
    [self.contentView addSubview:_xiaohongdianLb];
    
    
}@end
