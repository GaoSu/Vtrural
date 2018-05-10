//
//  VLX_buyTicketTableViewCell_5.h
//  Vlvxing
//
//  Created by grm on 2017/10/13.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VLX_buyTicketTableViewCell_5;//防止报红
@protocol xieyi <NSObject>

-(void)abc:(VLX_buyTicketTableViewCell_5 *)cel;


@end
@interface VLX_buyTicketTableViewCell_5 : UITableViewCell

@property (nonatomic,strong)UILabel * nameLb;//名称
@property (nonatomic,strong)UILabel * jiageLb;//价格
@property (nonatomic,strong)UILabel * tipsLb;//小提示
@property (nonatomic,strong)UIButton * selectBt;//选择按钮图标

@property(nonatomic,assign)id<xieyi>delegaie;


@end
