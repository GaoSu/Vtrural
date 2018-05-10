//
//  VLXDingZhiCell.h
//  Vlvxing
//
//  Created by Michael on 17/5/26.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VLXDingZhiCell : UITableViewCell
+(instancetype)cellWithTableView:(UITableView * )tableview;
@property(nonatomic,strong)UILabel * leftlabel;
@property(nonatomic,strong)UILabel * midlabel;
@property(nonatomic,strong)UIView * footLine;

@end
