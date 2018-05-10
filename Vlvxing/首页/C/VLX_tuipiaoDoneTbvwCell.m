
//
//  VLX_tuipiaoDoneTbvwCell.m
//  Vlvxing
//
//  Created by grm on 2017/11/27.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLX_tuipiaoDoneTbvwCell.h"

@implementation VLX_tuipiaoDoneTbvwCell

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
    _nameLb6 = [[UILabel alloc]initWithFrame:CGRectMake(44, 10, 65, 20)];
    _nameLb6.text = @"唐唐";
    _nameLb6.textColor = [UIColor blackColor];
    _nameLb6.font = [UIFont systemFontOfSize:18];
    //
    _ticketTyp6 = [[UILabel alloc]initWithFrame:CGRectMake(150, 12, 65, 20)];
    _ticketTyp6.text = @"成人票";
    _ticketTyp6.textColor = [UIColor grayColor];
    _ticketTyp6.font = [UIFont systemFontOfSize:15];
    //
    _numberLB6 = [[UILabel alloc]initWithFrame:CGRectMake(44, 37, 240, 20)];
    _numberLB6.text = @"";//@"身份证 411522199909090909";
    _numberLB6.textColor = [UIColor grayColor];
    _numberLB6.font = [UIFont systemFontOfSize:15];
    
    
    [self.contentView addSubview:_nameLb6];
    [self.contentView addSubview:_ticketTyp6];
    [self.contentView addSubview:_numberLB6];
    
    
}


@end
