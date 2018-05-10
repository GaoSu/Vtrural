//
//  VLX_buyTicketTableViewCell_3.m
//  Vlvxing
//
//  Created by grm on 2017/10/13.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLX_buyTicketTableViewCell_3.h"

@implementation VLX_buyTicketTableViewCell_3

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
    
//    self.contentView.backgroundColor = [UIColor whiteColor];
    
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self ){
        [self UI];
    }
    return self;
}

-(void)UI
{
//     jiaobiaoImgvw;//cell左上角角标
//    nameLb;//姓名
//    ID_Card;//身份证
//    nameTxfd;//姓名
//     ID_CardTxfd;//身份证号
//     deletImgvw;//删除乘客
    _jiaobiaoImgvw = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 32, 32)];
    _jiaobiaoImgvw.image = [UIImage imageNamed:@"标签"];
    
    _jiaobiaoLb = [[UILabel alloc]initWithFrame:CGRectMake(3, 1, 26, 15)];
    _jiaobiaoLb.font = [UIFont systemFontOfSize:13];
//    _jiaobiaoLb.text = @"1";
    _jiaobiaoLb.textColor = [UIColor whiteColor];
    _nameLb = [[UILabel alloc]initWithFrame:CGRectMake(23, 32, 50, 18)];
    _nameLb.text = @"姓名";
    
    _nameTxfd = [[UITextField alloc]initWithFrame:CGRectMake(111, 32, 150, 18)];
    _nameTxfd.placeholder = @"乘客姓名";
    
    
    
    
    _ID_Card =[[UILabel alloc]initWithFrame:CGRectMake(23, 73, 55, 18)];
    _ID_Card.text = @"身份证";
    
    _ID_CardTxfd = [[UITextField alloc]initWithFrame:CGRectMake(111, 73, 190, 18)];
    _ID_CardTxfd.placeholder = @"18位身份证号";
    
    _deletBT = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-57, 42, 21, 21)];
    [_deletBT setImage:[UIImage imageNamed:@"减"] forState:UIControlStateNormal];
    

    
    [self.contentView addSubview:_jiaobiaoImgvw];
    [self.contentView addSubview:_jiaobiaoLb];
    [self.contentView addSubview:_nameLb];
    [self.contentView addSubview:_nameTxfd];
    [self.contentView addSubview:_ID_Card];
    [self.contentView addSubview:_ID_CardTxfd];
    [self.contentView addSubview:_deletBT];

    

}


//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    if ([_nameTxfd isFirstResponder] || [_ID_CardTxfd isFirstResponder]) {
//        
//        [_nameTxfd resignFirstResponder];
//        [_ID_CardTxfd resignFirstResponder];
//        }
//
//    
//}


@end
