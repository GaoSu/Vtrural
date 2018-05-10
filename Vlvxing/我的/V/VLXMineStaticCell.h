//
//  VLXMineStaticCell.h
//  Vlvxing
//
//  Created by 王静雨 on 2017/5/18.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VLXMineStaticCell : UITableViewCell

@property (nonatomic ,strong)UILabel * jianjieLb;

-(void)createUIWithIcon:(NSString *)iconName andTitleName:(NSString *)titleName;
@end
