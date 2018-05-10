//
//  VLXRecordMarkCell.m
//  Vlvxing
//
//  Created by 王静雨 on 2017/6/3.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXRecordMarkCell.h"
@interface VLXRecordMarkCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UIImageView *playImageView;
@property (weak, nonatomic) IBOutlet UIImageView *closeImageView;


@end
@implementation VLXRecordMarkCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    //
    _titleLab.textColor=orange_color;
    _dateLab.textColor=[UIColor hexStringToColor:@"#666666"];
    //
    _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    _iconImageView.layer.masksToBounds=YES;
    _closeImageView.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToClose:)];
    [_closeImageView addGestureRecognizer:tap];
    //
    _playImageView.hidden=YES;
    //
    UIView *line=[[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-0.5, kScreenWidth, 0.5)];
    line.backgroundColor=separatorColor1;
    [self.contentView addSubview:line];
}
//
-(void)createUIWithModel:(VLXRecordDetailInfoModel *)model
{
    _titleLab.text=[ZYYCustomTool checkNullWithNSString:model.pathname];
    _dateLab.text=[[NSString stringWithFormat:@"%@",model.createtime] RwnTimeExchange5];
//    _iconImageView.contentMode=UIViewContentModeScaleAspectFill;
    if ([NSString checkForNull:model.videourl]||[model.videourl isEqualToString:@"0"]) {
        _playImageView.hidden=YES;
        [_iconImageView sd_setImageWithURL:[NSURL URLWithString:[ZYYCustomTool checkNullWithNSString:model.picurl]] placeholderImage:ADNoDataImage];
    }else
    {
        _playImageView.hidden=NO;
        [_iconImageView sd_setImageWithURL:[NSURL URLWithString:[ZYYCustomTool checkNullWithNSString:model.coverurl]] placeholderImage:ADNoDataImage];
    }
}
//
-(void)tapToClose:(UITapGestureRecognizer *)tap
{
    NSLog(@"close");
    if (_cellBlock) {
        _cellBlock();
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
