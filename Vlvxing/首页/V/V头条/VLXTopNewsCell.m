//
//  VLXTopNewsCell.m
//  Vlvxing
//
//  Created by 王静雨 on 2017/5/24.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXTopNewsCell.h"
@interface VLXTopNewsCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@end
@implementation VLXTopNewsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _titleLab.textColor=[UIColor hexStringToColor:@"#313131"];
    _dateLab.textColor=[UIColor hexStringToColor:@"#999999"];
    _timeLab.textColor=[UIColor hexStringToColor:@"#999999"];
    //
    UIView *line=[[UIView alloc] initWithFrame:CGRectMake(12, self.frame.size.height-0.5, kScreenWidth-12*2, 0.5)];
    line.backgroundColor=separatorColor1;
    [self.contentView addSubview:line];
}
-(void)createUIWithModel:(VLXVHeadDataModel *)model
{
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:[ZYYCustomTool checkNullWithNSString:model.headpic]] placeholderImage:smallNoDataImage];
    _titleLab.text=[ZYYCustomTool checkNullWithNSString:model.headname];
    NSString *timeStr=[NSString stringWithFormat:@"%@",model.time];
    _dateLab.text=[timeStr RwnTimeExchange3];
    _timeLab.text=[timeStr RwnTimeExchange2];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
