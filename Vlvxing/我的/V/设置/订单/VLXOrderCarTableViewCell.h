//
//  VLXOrderCarTableViewCell.h
//  Vlvxing
//
//  Created by Michael on 17/5/23.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VLXMyOrderModel.h"
@interface VLXOrderCarTableViewCell : UITableViewCell
+(instancetype)cellWithTableView:(UITableView * )tableview;
@property(nonatomic,strong)UIImageView * leftimageview;
@property(nonatomic,strong)UILabel * toplalbel;
@property(nonatomic,strong)UILabel * midlable;
@property(nonatomic,strong)UIButton * rightBtn;
@property(nonatomic,strong)UIView * footerview;
-(void)createUIWithModel:(VLXMyOrderDataModel *)model;
@end
