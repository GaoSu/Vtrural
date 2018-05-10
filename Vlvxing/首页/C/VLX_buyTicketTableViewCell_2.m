
//
//  VLX_buyTicketTableViewCell_2.m
//  Vlvxing
//
//  Created by grm on 2017/10/13.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLX_buyTicketTableViewCell_2.h"

@implementation VLX_buyTicketTableViewCell_2

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

-(instancetype)
initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier ];
    if (self) {
        [self UI];
    }return self;
}
-(void)UI
{
    _ticket_jiageLb =  [[UILabel alloc]init];
    _ticket_jiageLb.text = @"票价:¥3475";
    UIFont *fnt = [UIFont fontWithName:@"HelveticaNeue" size:17.0f];
    _ticket_jiageLb.font = fnt;
    CGSize StringSize = [_ticket_jiageLb.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName,nil]];
    CGFloat hangbanLb_width = StringSize.width;
    _ticket_jiageLb.frame = CGRectMake(22, 20, hangbanLb_width, 18);
    
    _other_jiageLb =  [[UILabel alloc]initWithFrame:CGRectMake(22+10+hangbanLb_width, 20, 145, 18)];
    _other_jiageLb.text = @"基建+燃油:¥55";
    _other_jiageLb.font = fnt;
    
    [self.contentView addSubview:_ticket_jiageLb];
    [self.contentView addSubview:_other_jiageLb];
}
//ticket_jiageLb;//票价
//other_jiageLb;//其他费用

@end
