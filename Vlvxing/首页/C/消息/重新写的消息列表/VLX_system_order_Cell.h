//
//  VLX_system_order_Cell.h
//  Vlvxing
//
//  Created by grm on 2017/12/12.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VLX_system_Order_Model.h"
@interface VLX_system_order_Cell : UITableViewCell

@property(nonatomic,strong)UIView * leftview;
@property(nonatomic,strong)UIImageView * leftimagmeview;
@property(nonatomic,strong)UIView * pointview;
@property(nonatomic,strong)UILabel * topleftlabel;
@property(nonatomic,strong)UILabel * rightlabel;
@property(nonatomic,strong)UILabel * bottomLabel;

@property(nonatomic,strong)UILabel * orderid;


-(void)FillWithModel:(VLX_system_Order_Model *)model;

@end
