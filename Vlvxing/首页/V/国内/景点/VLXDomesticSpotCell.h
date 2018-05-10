//
//  VLXDomesticSpotCell.h
//  Vlvxing
//
//  Created by 王静雨 on 2017/5/23.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VLXHomeRecommandModel.h"
@interface VLXDomesticSpotCell : UITableViewCell
-(void)createUIWithModel:(VLXHomeRecommandDataModel *)model;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titlableHeight;


@end
