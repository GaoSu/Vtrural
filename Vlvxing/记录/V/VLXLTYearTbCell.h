//
//  VLXLTYearTbCell.h
//  Vlvxing
//
//  Created by Michael on 17/5/25.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VLXLTYearTbCell : UITableViewCell
+(instancetype)cellWithTableView:(UITableView *)tableView;
@property(nonatomic,strong)UILabel * yaerlabel;
@property(nonatomic,strong)UIView * point;
@property(nonatomic,strong)UIView * line;
@end
