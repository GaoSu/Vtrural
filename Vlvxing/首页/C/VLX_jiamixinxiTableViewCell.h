//
//  VLX_jiamixinxiTableViewCell.h
//  Vlvxing
//
//  Created by grm on 2017/11/20.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import <UIKit/UIKit.h> ///////乘客信息加密查看,列表
#import "VLX_jiamixinxiModel.h"
@interface VLX_jiamixinxiTableViewCell : UITableViewCell

//@property  (nonatomic,strong)NSString * Name_Str;//姓名
//
//@property  (nonatomic,strong)NSString * ID_cardNoStr;//身份证号
//
//@property (nonatomic,strong)NSString * Phone_NoStr;//手机号

@property  (nonatomic,strong)UILabel * nameLb;//姓名

@property  (nonatomic,strong)UILabel * shenfenzhengLb;//身份证号

//@property (nonatomic,strong)NSString * PhoneONLb;//手机号

-(void)FillWithModel:(VLX_jiamixinxiModel *)model;



@end
