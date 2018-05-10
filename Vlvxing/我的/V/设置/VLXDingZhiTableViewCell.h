//
//  VLXDingZhiTableViewCell.h
//  Vlvxing
//
//  Created by Michael on 17/5/22.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VLXDingZhiTableViewCell : UITableViewCell
+(instancetype)cellWithTableView:(UITableView * )tableview;
@property(nonatomic,strong)UIImageView * leftImage;
@property(nonatomic,strong)UILabel * htoplabel;
@property(nonatomic,strong)UILabel  * hmidlabel;
@property(nonatomic,strong)UILabel * hbottomLabel;
@property(nonatomic,strong)UILabel * rtoplabel;
@property(nonatomic,strong)UILabel * rmidlabel;
@property(nonatomic,strong)UILabel * rbottomlabel;
@property(nonatomic,strong) UIView *footLine;
@end
