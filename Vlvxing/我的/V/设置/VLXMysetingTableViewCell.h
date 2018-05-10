//
//  VLXMysetingTableViewCell.h
//  Vlvxing
//
//  Created by Michael on 17/5/19.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SetCellSwicthDelegate <NSObject>

-(void)changeSwitchStatusWithSwitch:(UISwitch *)mySwitch;

@end

@interface VLXMysetingTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *leftimageview;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightlabel;
@property (weak, nonatomic) IBOutlet UIView *footerline;
@property (weak, nonatomic) IBOutlet UISwitch *switchview;

@property(nonatomic,weak) id<SetCellSwicthDelegate> delegate;

@end
