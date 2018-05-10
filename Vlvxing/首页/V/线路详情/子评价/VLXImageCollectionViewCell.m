//
//  VLXImageCollectionViewCell.m
//  Vlvxing
//
//  Created by 王静雨 on 2017/5/24.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXImageCollectionViewCell.h"
@interface VLXImageCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@end
@implementation VLXImageCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)createUIWithImage:(NSString *)imageStr
{
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:nil];
}
@end
