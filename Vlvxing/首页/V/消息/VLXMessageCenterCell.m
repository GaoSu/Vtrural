//
//  VLXMessageCenterCell.m
//  Vlvxing
//
//  Created by Michael on 17/5/25.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXMessageCenterCell.h"

@implementation VLXMessageCenterCell

- (void)awakeFromNib {
    [super awakeFromNib];

}
+(instancetype)cellWithTableView:(UITableView *)tableView{

    VLXMessageCenterCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (cell==nil) {

        cell=[[VLXMessageCenterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([self class])];

    }
    return cell;

}

//高亮
-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    self.contentView.backgroundColor = [UIColor whiteColor];
//    self.pointview.hidden = YES;

}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.leftview];
        [self.leftview addSubview:self.leftimagmeview];
        [self.contentView addSubview:self.topleftlabel];
        [self.contentView addSubview:self.bottomLabel];
        [self.contentView addSubview:self.rightlabel];
        [self.leftview addSubview:self.pointview];
    }
    return self;
}
//
-(void)createUIWithModel:(VLXHomeMessageDataModel *)model
{
    if (model.hasNoRead.boolValue==1) {
        _pointview.hidden=NO;
    }else
    {
        _pointview.hidden=YES;
    }

    //
    _bottomLabel.text=[ZYYCustomTool checkNullWithNSString:model.messageText];//最近一条消息
    _rightlabel.text=[[NSString stringWithFormat:@"%@",model.lastRecordTime] RwnTimeExchange2];//事件
    if ([model.messageType isEqualToString:@"1"]) {
        _topleftlabel.text=@"系统公告";//cell
        _leftimagmeview.image=[UIImage imageNamed:@"informmoren"];
    }else if ([model.messageType isEqualToString:@"2"])
    {
        _topleftlabel.text=@"订单消息";
        _leftimagmeview.image=[UIImage imageNamed:@"xitongmoren"];
    }
}
//
-(UIView * )leftview
{
    if (!_leftview) {
        _leftview=[UIView new];
        _leftview.backgroundColor=[UIColor whiteColor];
        [self.contentView addSubview:_leftview];

        [_leftview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(ScaleWidth(11));
//            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.top.mas_equalTo(ScaleHeight(13));
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(60);

        }];
    }

    return _leftview;
}

-(UIImageView * )leftimagmeview
{
    if (!_leftimagmeview) {
        _leftimagmeview=[UIImageView new];
//        _leftimagmeview.image=[UIImage imageNamed:@"informmoren"];
        [self.leftview addSubview:_leftimagmeview];
        _leftimagmeview.layer.masksToBounds=YES;
        _leftimagmeview.layer.cornerRadius=4;
        [_leftimagmeview mas_makeConstraints:^(MASConstraintMaker *make) {

            make.centerY.mas_equalTo(self.leftview.mas_centerY);
            make.centerX.mas_equalTo(self.leftview.mas_centerX);
            make.width.mas_equalTo(52);
            make.height.mas_equalTo(52);
        }];

    }

    return _leftimagmeview;
}
-(UILabel * )topleftlabel
{
    if (!_topleftlabel) {
        _topleftlabel=[UILabel new];
        _topleftlabel.textColor=[UIColor hexStringToColor:@"444444"];
        _topleftlabel.font=[UIFont fontWithName:@"PingFang-SC-Medium" size:16];
        [self.contentView addSubview:_topleftlabel];
        [_topleftlabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.leftview.mas_right).mas_offset(8);
            make.top.mas_equalTo(ScaleHeight(13));
            make.height.mas_equalTo(16);
            make.right.mas_equalTo(self.rightlabel.mas_left).offset(-5);
        }];
    }

    return _topleftlabel;
}

-(UILabel * )bottomLabel
{
    if (!_bottomLabel) {
        _bottomLabel=[UILabel new];
//        _bottomLabel.text=@"恭喜您获得酒店“VIP准专享”特权！20万玩家发货单上看见";
        _bottomLabel.textColor=[UIColor hexStringToColor:@"666666"];
        _bottomLabel.numberOfLines = 0;
        _bottomLabel.font=[UIFont fontWithName:@"PingFang-SC-Medium" size:14];
        [self.contentView addSubview:_bottomLabel];
        [_bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {

            make.bottom.mas_equalTo(-10);
            make.top.mas_equalTo(self.topleftlabel.mas_bottom).mas_offset(12);
            make.left.mas_equalTo(self.leftview.mas_right).mas_offset(8);
            make.right.mas_equalTo(-ScaleWidth(15));
//            make.height.mas_equalTo(14);
            
        }];
    }

    return _bottomLabel;
}


-(UILabel * )rightlabel
{
    if (!_rightlabel) {
        _rightlabel=[UILabel new];
        _rightlabel.textColor=[UIColor hexStringToColor:@"999999"];
//        _rightlabel.text=@"昨天 14：20";
        _rightlabel.textAlignment=NSTextAlignmentRight;
        _rightlabel.font=[UIFont fontWithName:@"PingFang-SC-Medium" size:12];
        [self.contentView addSubview:_rightlabel];
        [_rightlabel mas_makeConstraints:^(MASConstraintMaker *make) {

            make.right.mas_equalTo(-ScaleWidth(15));
            make.top.mas_equalTo(ScaleHeight(15));
            make.height.mas_equalTo(12);
            make.width.mas_equalTo(72);
        }];
    }

    return _rightlabel;
}

-(UIView * )pointview
{
    if (!_pointview) {
        _pointview=[UIView new];
        _pointview.backgroundColor=orange_color;
//        [self.leftview addSubview:_pointview];
        [self.contentView addSubview:_pointview];
        _pointview.layer.masksToBounds=YES;
        _pointview.layer.cornerRadius=4;
        [_pointview mas_makeConstraints:^(MASConstraintMaker *make) {

            make.right.mas_equalTo(-ScaleWidth(15));
            make.top.mas_equalTo(ScaleHeight(45));
            make.height.mas_equalTo(8);
            make.width.mas_equalTo(8);
        }];
//        _pointview.hidden=YES;
    }



    return _pointview;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
