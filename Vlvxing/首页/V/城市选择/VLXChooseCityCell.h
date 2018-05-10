//
//  VLXChooseCityCell.h
//  Vlvxing
//
//  Created by Michael on 17/5/27.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VLXChooseCityCell : UITableViewCell
+(instancetype)cellWithTableView:(UITableView * )tableview;
@property(nonatomic,strong)UILabel * leftlabel;
@property(nonatomic,strong)UIView * footLine;
@end
