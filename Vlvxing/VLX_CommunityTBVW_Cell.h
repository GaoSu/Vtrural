//
//  VLX_CommunityTBVW_Cell.h
//  Vlvxing
//
//  Created by grm on 2017/10/25.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import <UIKit/UIKit.h>
////#import "VLX_CommunityMdel.h"
#import "VLX_newCommnuityModel.h"
#import "SRVideoPlayer.h"//视频播放控件

@interface VLX_CommunityTBVW_Cell : UITableViewCell



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

//@property (nonatomic,strong)UIImageView * likeImgvw;//点赞次数
//@property (nonatomic,strong)UILabel * likeLb;
@property (nonatomic,strong)UIButton * dianzanBt;////点赞次数

@property (nonatomic,assign)CGFloat  Cell_height;//只是文字高度

//-(void)FillWithModel:(VLX_CommunityMdel *)model;
-(void)FillWithModel:(VLX_newCommnuityModel *)model;
//-(NSInteger )FillWithModel_SHULIANG:(VLX_newCommnuityModel *)model;//图片数量


@end
