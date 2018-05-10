//
//  VLX_buyTicketTableViewCell_8.h
//  Vlvxing
//
//  Created by grm on 2017/11/15.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import <UIKit/UIKit.h>


@class VLX_buyTicketTableViewCell_8;//防止报红
@protocol xieyi_xieyi <NSObject>

-(void)abcd:(VLX_buyTicketTableViewCell_8 *)cel;
@end

@interface VLX_buyTicketTableViewCell_8 : UITableViewCell

@property (nonatomic,strong)UIButton * baoxiaoBt;//选择图标
@property (nonatomic,strong)UILabel * nameLb;//名称
@property (nonatomic,strong)UILabel * jiageLb3;//金额
@property (nonatomic,strong)UITextField *txfds2;//输入框




@property(nonatomic,assign)id<xieyi_xieyi>delegaie;


@end
