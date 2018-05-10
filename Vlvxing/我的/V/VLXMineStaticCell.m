//
//  VLXMineStaticCell.m
//  Vlvxing
//
//  Created by 王静雨 on 2017/5/18.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXMineStaticCell.h"
@interface VLXMineStaticCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
//@property (nonatomic ,strong)UILabel * jianjieLb;
@end

@implementation VLXMineStaticCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _iconImageView.layer.cornerRadius=10;
    _iconImageView.layer.masksToBounds=YES;
    _titleLab.textColor=[UIColor hexStringToColor:@"#444444"];
    UIView *lineView=[[UIView alloc] initWithFrame:CGRectMake(50, self.contentView.frame.size.height-0.5, ScreenWidth-50, 0.5)];
    lineView.backgroundColor=separatorColor1;
    _jianjieLb = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-190, 26, 150, 14)];
    _jianjieLb.font = [UIFont systemFontOfSize:10];
    _jianjieLb.textColor =[UIColor lightGrayColor];
    _jianjieLb.textAlignment = NSTextAlignmentRight;
    
    [self.contentView addSubview:_jianjieLb];
    [self.contentView addSubview:lineView];
}
-(void)createUIWithIcon:(NSString *)iconName andTitleName:(NSString *)titleName
{
    [_iconImageView setImage:[UIImage imageNamed:[ZYYCustomTool checkNullWithNSString:iconName]]];
    _titleLab.text=[ZYYCustomTool checkNullWithNSString:titleName];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
