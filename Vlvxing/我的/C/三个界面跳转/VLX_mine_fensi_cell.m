//
//  VLX_mine_fensi_cell.m
//  Vlvxing
//
//  Created by grm on 2018/3/12.
//  Copyright © 2018年 王静雨. All rights reserved.
//

#import "VLX_mine_fensi_cell.h"

@implementation VLX_mine_fensi_cell

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
    if (self) {
        [self UI2];
    }return self;
}

-(void)UI2
{
    //头像;
    _headImgvw2 = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 50, 50)];
    _headImgvw2.layer.cornerRadius = 25;
    _headImgvw2.layer.masksToBounds = YES;

    //名字;
    _nameLb2 = [[UILabel alloc]initWithFrame:CGRectMake(70, 15, 150, 20)];

    //性别
    _sxeImgvw2 = [[UIImageView alloc]initWithFrame:CGRectMake(72,42,12,13)];

    [self.contentView addSubview:_headImgvw2];
    [self.contentView addSubview:_nameLb2];
    [self.contentView addSubview:_sxeImgvw2];
}

-(void)FillWithModel:(VLX_mine_fensi_model *)model{
    [_headImgvw2 sd_setImageWithURL:[NSURL URLWithString:model.followWhoMember[@"userpic"]] placeholderImage:nil];
    _nameLb2.text = model.followWhoMember[@"usernick"];
    if ([model.followWhoMember[@"usersex"] isEqual:@1]) {
        _sxeImgvw2.image = [UIImage imageNamed:@"man-blue"];
    }else{
        _sxeImgvw2.image = [UIImage imageNamed:@"nv-red"];
    }
}

@end
