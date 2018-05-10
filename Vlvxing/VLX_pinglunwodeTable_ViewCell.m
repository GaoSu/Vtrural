//
//  VLX_pinglunwodeTable_ViewCell.m
//  Vlvxing
//
//  Created by grm on 2017/10/30.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLX_pinglunwodeTable_ViewCell.h"//评论我的Cell

@implementation VLX_pinglunwodeTable_ViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    //选中色
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
    if (self) {
        [self UI];
    }return self;
}

-(void)UI{
    //头像;
    _headImgvw1 = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 50, 50)];
    _headImgvw1.layer.cornerRadius = 25;
    _headImgvw1.layer.masksToBounds = YES;

    //名字;
    _nameLb1 = [[UILabel alloc]initWithFrame:CGRectMake(70, 15, 150, 20)];

    //
    _useridLb1 = [[UILabel alloc]initWithFrame:CGRectMake(7, 1, 0, 0)];

//    _sxeImgvw1 = [[UIImageView alloc]initWithFrame:CGRectMake(72,42,12,13)];

    [self.contentView addSubview:_headImgvw1];
    [self.contentView addSubview:_nameLb1];
//    [self.contentView addSubview:_sxeImgvw1];

}

-(void)FillWithModel:(VLX_plwdModel *)model{

    [_headImgvw1 sd_setImageWithURL:[NSURL URLWithString:model.userpic] placeholderImage:nil];
    _nameLb1.text = model.usernick;
    _useridLb1.text = [NSString stringWithFormat:@"%@",model.userid];
//    if ([model.usersex isEqual:@1]) {
//        _sxeImgvw1.image = [UIImage imageNamed:@"man-blue"];
//    }else{
//        _sxeImgvw1.image = [UIImage imageNamed:@"nv-red"];
//    }

}


@end
