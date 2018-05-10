//
//  VLXHomeHotCell.m
//  Vlvxing
//
//  Created by 王静雨 on 2017/5/19.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXHomeHotCell.h"
@interface VLXHomeHotCell ()
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *imageViewArray;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *desLabArray;

@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@end
@implementation VLXHomeHotCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor=backgroun_view_color;
    _titleLab.textColor=[UIColor hexStringToColor:@"#2c2c2c"];
    for (int i =0; i<_imageViewArray.count; i++) {
        UIImageView *imageView=_imageViewArray[i];
        imageView.layer.cornerRadius=5;
        imageView.layer.masksToBounds=YES;
        imageView.tag=100+i;
//        //添加手势
//        imageView.userInteractionEnabled=YES;
//        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToEvent:)];
//        [imageView addGestureRecognizer:tap];
    }
}
#pragma mark---数据
-(void)createUIWithModel:(VLXHomeHotModel *)model
{
    if (model.data.count<=3) {
        for (int i=0; i<model.data.count; i++) {
            VLXHomeHotDataModel *dataModel=model.data[i];
            //
            UIImageView *imageView=_imageViewArray[i];
            [imageView sd_setImageWithURL:[NSURL URLWithString:[ZYYCustomTool checkNullWithNSString:dataModel.pic]] placeholderImage:nil];
            //
            UILabel *desLab=_desLabArray[i];
            desLab.text=[ZYYCustomTool checkNullWithNSString:dataModel.areaname];
            //添加手势
            imageView.userInteractionEnabled=YES;
            UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToEvent:)];
            [imageView addGestureRecognizer:tap];
        }
    }else
    {
        for (int i=0; i<3; i++) {
            VLXHomeHotDataModel *dataModel=model.data[i];
            //
            UIImageView *imageView=_imageViewArray[i];
            [imageView sd_setImageWithURL:[NSURL URLWithString:[ZYYCustomTool checkNullWithNSString:dataModel.pic]] placeholderImage:nil];
            //
            UILabel *desLab=_desLabArray[i];
            desLab.text=[ZYYCustomTool checkNullWithNSString:dataModel.areaname];
            //添加手势
            imageView.userInteractionEnabled=YES;
            UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToEvent:)];
            [imageView addGestureRecognizer:tap];
        }
    }
//    for (int i=0; i<model.data.count; i++) {
//        VLXHomeHotDataModel *dataModel=model.data[i];
//        //
//        UIImageView *imageView=_imageViewArray[i];
//        [imageView sd_setImageWithURL:[NSURL URLWithString:[ZYYCustomTool checkNullWithNSString:dataModel.pic]] placeholderImage:nil];
//        //
//        UILabel *desLab=_desLabArray[i];
//        desLab.text=[ZYYCustomTool checkNullWithNSString:dataModel.areaname];
//        //添加手势
//        imageView.userInteractionEnabled=YES;
//        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToEvent:)];
//        [imageView addGestureRecognizer:tap];
//    }
}
#pragma mark---事件
-(void)tapToEvent:(UITapGestureRecognizer *)tap
{
    if (_homeHotBlock) {
        _homeHotBlock(tap.view.tag-100);
    }
}
#pragma mark
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
