//
//  SelectShipinCell.h
//  yinxin
//
//  Created by handong001 on 16/11/4.
//  Copyright © 2016年 RWN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectShipinCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *mainContentImg;
@property (weak, nonatomic) IBOutlet UIImageView *shipinIcon;
@property (weak, nonatomic) IBOutlet UIImageView *isSelectImg;
@property(nonatomic,assign) BOOL isSelect;

@end
