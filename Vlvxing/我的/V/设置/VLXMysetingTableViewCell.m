//
//  VLXMysetingTableViewCell.m
//  Vlvxing
//
//  Created by Michael on 17/5/19.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXMysetingTableViewCell.h"

@implementation VLXMysetingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.switchview addTarget:self action:@selector(ClickSwitchAction:) forControlEvents:UIControlEventTouchUpInside];
    // Initialization code
}

-(void)ClickSwitchAction:(UISwitch *)mySwitch{
    if (_delegate && [_delegate respondsToSelector:@selector(changeSwitchStatusWithSwitch:)]) {
        [_delegate changeSwitchStatusWithSwitch:mySwitch];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
