//
//  VLX_mine_TAdynamic_cell.h
//  Vlvxing
//
//  Created by grm on 2018/3/12.
//  Copyright © 2018年 王静雨. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "SRVideoPlayer.h"//视频播放控件
#import "VLX_mine_TA_model.h"


@interface VLX_mine_TAdynamic_cell : UITableViewCell


@property (nonatomic,strong)UIImageView * headImgvw;//头像
@property (nonatomic,strong)UILabel * nameLb;//mingzi
@property (nonatomic,strong)UILabel * dateLb;//日期
@property (nonatomic,strong)UILabel * timeLb;//时间
@property (nonatomic,strong)UILabel * titleLb;//正文简介
@property (nonatomic,strong)UIView * sumView;//正文图片父视图

@property (nonatomic,strong)UIImageView * videoView;//正文视频view
@property (nonatomic,strong)SRVideoPlayer * SRvideoView;//正文视频控件
@property (nonatomic,strong)UIButton * playBt;//播放按钮
@property (nonatomic,strong)UIImageView * LittleImgV;//正文图片小图
@property (nonatomic,strong)UIImageView * areaImgvw;//地点
@property (nonatomic,strong)UILabel * areaLb;

@property (nonatomic,strong)UIImageView * watchImgvw;//查看次数
@property (nonatomic,strong)UILabel * watchLb;

@property (nonatomic,strong)UIImageView * pinglunImgvw;//评论次数
@property (nonatomic,strong)UILabel * pinglunLb;


@property (nonatomic,strong)UIButton * dianzanBt;////点赞次数

@property (nonatomic,assign)CGFloat  Cell_height;//只是文字高度

-(void)FillWithModel:(VLX_mine_TA_model *)model;

@end
