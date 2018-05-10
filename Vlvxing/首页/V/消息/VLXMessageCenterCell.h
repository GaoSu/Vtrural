//
//  VLXMessageCenterCell.h
//  Vlvxing
//
//  Created by Michael on 17/5/25.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VLXHomeMessageModel.h"
@interface VLXMessageCenterCell : UITableViewCell
+(instancetype)cellWithTableView:(UITableView *)tableView;
@property(nonatomic,strong)UIView * leftview;
@property(nonatomic,strong)UIImageView * leftimagmeview;
@property(nonatomic,strong)UIView * pointview;
@property(nonatomic,strong)UILabel * topleftlabel;
@property(nonatomic,strong)UILabel * rightlabel;
@property(nonatomic,strong)UILabel * bottomLabel;
-(void)createUIWithModel:(VLXHomeMessageDataModel *)model;
@end
