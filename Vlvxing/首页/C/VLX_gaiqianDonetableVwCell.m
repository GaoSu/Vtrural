//
//  VLX_gaiqianDonetableVwCell.m
//  Vlvxing
//
//  Created by grm on 2017/11/23.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLX_gaiqianDonetableVwCell.h"

@implementation VLX_gaiqianDonetableVwCell

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
    
    //
    _nameLb5 = [[UILabel alloc]initWithFrame:CGRectMake(44, 17, 65, 20)];
    _nameLb5.text = @"张三";
    _nameLb5.textColor = [UIColor blackColor];
    _nameLb5.textAlignment = NSTextAlignmentCenter;
    _nameLb5.font = [UIFont systemFontOfSize:18];
    //
    _ticketType = [[UILabel alloc]initWithFrame:CGRectMake(115, 19, 65, 20)];
    _ticketType.text = @"成人票";
    _ticketType.textColor = [UIColor grayColor];
    _ticketType.textAlignment = NSTextAlignmentCenter;
    _ticketType.font = [UIFont systemFontOfSize:15];
    //
    _numberLB5 = [[UILabel alloc]initWithFrame:CGRectMake(44, 43, 240, 20)];
    _numberLB5.text = @"";//@"身份证 411522199909090909";
    _numberLB5.textColor = [UIColor grayColor];
    _numberLB5.textAlignment = NSTextAlignmentCenter;
    _numberLB5.font = [UIFont systemFontOfSize:15];
    
    
    [self.contentView addSubview:_nameLb5];
    [self.contentView addSubview:_numberLB5];
    [self.contentView addSubview:_ticketType];
    
    
}


@end
