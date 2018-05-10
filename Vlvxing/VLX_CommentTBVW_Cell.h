//
//  VLX_CommentTBVW_Cell.h
//  Vlvxing
//
//  Created by grm on 2017/10/26.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "VLX_detailhuifuModel.h"
#import "AttributeLabel.h"
@interface VLX_CommentTBVW_Cell : UITableViewCell



@property (nonatomic,strong)UIImageView * headImgvw;//头像
@property (nonatomic,strong)UILabel * nameLb;//mingzi
@property (nonatomic,strong)UILabel * louceng;//楼层或楼主
@property (nonatomic,strong)UILabel * dateLb;//日期
@property (nonatomic,strong)UILabel * timeLb;//时间
@property (nonatomic,strong)AttributeLabel* MUT_titleLb;//评论正文简介(富文本)
@property (nonatomic,strong)UIImageView* huifuImgvW;//评论回复中的图片(单张)

@property (nonatomic, assign)CGFloat textViewHeight;

@property (nonatomic,strong)UIView * sumView;//正文图片

@property (nonatomic,strong)UIImageView * areaImgvw;//地点
@property (nonatomic,strong)UILabel * areaLb;

@property (nonatomic,strong)UIImageView * watchImgvw;//查看次数
@property (nonatomic,strong)UILabel * watchLb;

@property (nonatomic,strong)UIButton * commentBt;//右上方评论按钮
//@property (nonatomic,strong)UILabel * commentLb;//

@property (nonatomic,assign)CGFloat  Cell_height_wz;//只是文字高度

-(void)FillWithModel:(VLX_detailhuifuModel *)model;


@end
