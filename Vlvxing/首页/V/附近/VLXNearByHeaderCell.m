//
//  VLXNearByHeaderCell.m
//  Vlvxing
//
//  Created by 王静雨 on 2017/5/22.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXNearByHeaderCell.h"
@interface VLXNearByHeaderCell ()
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *viewArray;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *imageViewArray;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *titleLabArray;
@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *imageWidthArray;
@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *imageHeightArray;

@end
@implementation VLXNearByHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];// Initialization code
    self.contentView.backgroundColor=backgroun_view_color;
    //上部分视图
    NSArray *imageArray=@[@"ios自驾游@3x",@"ios周末游@3x",@"ios农家院@3x",@"ios景点用车@3x"];
    NSArray *titleArray=@[@"自驾游",@"周末游",@"农家院",@"景点用车"];
    for (int i=0; i<imageArray.count; i++) {
        //得到图片的宽度
        UIImage *image=[UIImage imageNamed:imageArray[i]];
        NSLayoutConstraint *width=_imageWidthArray[i];
        NSLayoutConstraint *height=_imageHeightArray[i];
        width.constant=image.size.width;//修改图片的宽度
        height.constant=image.size.height;//修改图片的高度
        //设置图片
        UIImageView *imageView=_imageViewArray[i];
        [imageView setImage:image];
        //设置标题
        UILabel *titleLab=_titleLabArray[i];
        titleLab.text=titleArray[i];
        titleLab.textColor=[UIColor hexStringToColor:@"#7d7d7d"];
        //添加手势
        UIView *topView=_viewArray[i];
        topView.tag=900+i;
        topView.userInteractionEnabled=YES;
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTopViewToEvent:)];
        [topView addGestureRecognizer:tap];
        
    }
}
#pragma mark---事件
-(void)tapTopViewToEvent:(UITapGestureRecognizer *)tap
{
    NSLog(@"%ld",tap.view.tag);
    if (_headBlock) {
        _headBlock(tap.view.tag-900);
    }
}
#pragma mark
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
