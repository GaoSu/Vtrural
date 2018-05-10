//
//  VLX_buyTicketTableViewCell_3.h
//  Vlvxing
//
//  Created by grm on 2017/10/13.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VLX_buyTicketTableViewCell_3 : UITableViewCell

@property (nonatomic,strong)UIImageView * jiaobiaoImgvw;//cell左上角角标
@property(nonatomic,strong)UILabel * jiaobiaoLb;//cell左上角角标数字
@property (nonatomic,strong)UILabel * nameLb;//姓名
@property (nonatomic,strong)UILabel * ID_Card;//身份证


@property (nonatomic,strong)UITextField * nameTxfd;//姓名
@property (nonatomic,strong)UITextField * ID_CardTxfd;//身份证号
@property (nonatomic,strong)UIButton * deletBT;//删除乘客


@end
