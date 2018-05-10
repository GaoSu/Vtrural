//
//  VLXDingzhiTitleCell.m
//  Vlvxing
//
//  Created by 王静雨 on 2017/6/5.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXDingzhiTitleCell.h"
@interface VLXDingzhiTitleCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;

@end
@implementation VLXDingzhiTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _titleLab.textColor=[UIColor hexStringToColor:@"#666666"];
    _contentLab.textColor=[UIColor hexStringToColor:@"#313131"];
    UIView *line=[[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-0.5, kScreenWidth, 0.5)];
    line.backgroundColor=separatorColor1;
    [self.contentView addSubview:line];
}
-(void)createUIWithTitle:(NSString *)title andContent:(NSString *)content
{
    _titleLab.text=[ZYYCustomTool checkNullWithNSString:title];
    _contentLab.text=[ZYYCustomTool checkNullWithNSString:content];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
