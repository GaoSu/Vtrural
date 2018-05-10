//
//  HMStatusOriginalView.m
//  XingJu
//
//  Created by apple on 14-7-14.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "HMStatusOriginalView.h"
#import "HMStatusOriginalFrame.h"
#import "HMStatus.h"
#import "HMUser.h"
#import "UIImageView+WebCache.h"
#import "HMStatusPhotosView.h"
#import "HMStatusLabel.h"
#import "HMDynamic.h"
#import "HMVideo.h"
#import "ZTHUserIdentity.h"

//#import "ZTHSeriesDetailController.h"//视频

@interface HMStatusOriginalView()
/** 昵称 */
@property (nonatomic, weak) UILabel *nameLabel;
/** 正文 */
@property (nonatomic, weak) HMStatusLabel *textLabel;
/** 来源 */
//@property (nonatomic, weak) UILabel *sourceLabel;

/** 已认证 */
@property (nonatomic, weak) UILabel *certificateLabel;
/** 时间 */
@property (nonatomic, weak) UILabel *timeLabel;

/** 头像 */
@property (nonatomic, weak) UIImageView *iconView;
/** 会员图标 */
@property (nonatomic, weak) UIImageView *vipView;
/** 配图相册 */
@property (nonatomic, weak) HMStatusPhotosView *photosView;

/** 视频 */
@property (nonatomic,weak) UIView *videoView;
/** 视频上默认显示的图片 */
@property (nonatomic,weak) UIImageView *videoImage;
/** 播放按钮 */
@property (nonatomic,weak) UIButton *playBtn;


@end

@implementation HMStatusOriginalView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // 1.头像
        UIImageView *iconView = [[UIImageView alloc] init];
        [self addSubview:iconView];
        self.iconView = iconView;
        
        // 2.昵称
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.font = HMStatusOrginalNameFont;
        [self addSubview:nameLabel];
        self.nameLabel = nameLabel;
        
        // 2.正文（内容）
        HMStatusLabel *textLabelgrm = [[HMStatusLabel alloc] init];
        [self addSubview:textLabelgrm];
        self.textLabel = textLabelgrm;
//        NSLog(@"正文frame:::%@",NSStringFromCGRect(self.textLabel.frame));

        // 3.时间
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.textColor = HMColor(153, 153, 153);
        timeLabel.font = HMStatusOrginalTimeFont;
        [self addSubview:timeLabel];
        self.timeLabel = timeLabel;
        
//        // 4.来源
//        UILabel *sourceLabel = [[UILabel alloc] init];
//        sourceLabel.textColor = [UIColor orangeColor];
//        sourceLabel.font = HMStatusOrginalSourceFont;
//        [self addSubview:sourceLabel];
//        self.sourceLabel = sourceLabel;
        
        
//        // 6.会员图标
//        UIImageView *vipView = [[UIImageView alloc] init];
//        vipView.contentMode = UIViewContentModeCenter;
//        [self addSubview:vipView];
//        self.vipView = vipView;
        
        //5.是否认证
        UILabel *certificateLabel = [[UILabel alloc] init];
//        certificateLabel.text = @"已认证";
        certificateLabel.textColor = HMColor(247, 76, 60);
        certificateLabel.font = HMStatusOrginalSourceFont;
        [self addSubview:certificateLabel];
        self.certificateLabel = certificateLabel;
        
        //6.视频
        UIView *videoView = [[UIView alloc] init];
//        videoView.backgroundColor = [UIColor orangeColor];
        [self addSubview:videoView];
        self.videoView = videoView;
        
        //视频显示的默认图片
        UIImageView *videoImage = [[UIImageView alloc] init];
//        videoImage.backgroundColor = [UIColor redColor];
        videoImage.userInteractionEnabled = YES;
        [videoView addSubview:videoImage];
        self.videoImage = videoImage;
        
        //播放按钮
        UIButton *playBtn = [[UIButton alloc] init];
        [playBtn addTarget:self action:@selector(playButton) forControlEvents:UIControlEventTouchUpInside];
        [videoView addSubview:playBtn];
        self.playBtn = playBtn;
        
        
        // 7.配图相册
        HMStatusPhotosView *photosView = [[HMStatusPhotosView alloc] init];
        [self addSubview:photosView];
        self.photosView = photosView;
    }
    return self;
}

//点击播放按钮
- (void)playButton
{
    if ([self.delegate respondsToSelector:@selector(statusOriginalViewDidClickPlayButton:)]) {
        [self.delegate statusOriginalViewDidClickPlayButton:self];
    }
}

- (void)setOriginalFrame:(HMStatusOriginalFrame *)originalFrame
{
    _originalFrame = originalFrame;
    
    self.frame = originalFrame.frame;
    
    // 取出微博数据
    HMStatus *status = originalFrame.status;
    // 取出用户数据
    HMUser *user = status.user;
    //取出动态内容数据
    HMDynamic *dynamic = originalFrame.status.dynamic;
    
    // 1.头像
    self.iconView.frame = originalFrame.iconFrame;
    self.iconView.layer.masksToBounds = YES;
    self.iconView.layer.cornerRadius = self.iconView.width * 0.5;
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:user.userHeadUrl] placeholderImage:[UIImage imageWithName:@"me"]];
    
    // 2.昵称
    self.nameLabel.text = user.userName;
    self.nameLabel.frame = originalFrame.nameFrame;
    
    //已认证
    
//    HMLog(@"%zd",user.userIdentity[0]);
    
   

    
//    if (user.userIdentity.count == 0 || user.userIdentity[0] == [NSNumber numberWithInt:201003]) {
//        self.certificateLabel.text = @"未认证";
//    }else if (user.userIdentity.count > 0 && (int)user.userIdentity[0] == 201002){
//        self.certificateLabel.text = @"审核中";
//    }else if (user.userIdentity.count > 0 && user.userIdentity[0] == [NSNumber numberWithInt:201001]){
//        self.certificateLabel.text = @"已认证";
//    }
    
    
    CGFloat certificateLabelX = CGRectGetMaxX(self.nameLabel.frame) + 10;
    CGFloat certificateLabelY = self.nameLabel.y;
    CGFloat certificateLabelW = 50;
    CGFloat certificateLabelH = self.nameLabel.height;
    
//    
//    HMLog(@"user.userIdentity.count-%zd",user.userIdentity.count);
    //把NSNumber转成int类型
//    HMLog(@"user.userIdentity[0]-%zd",[user.userIdentity[0] intValue]);
 
        if (user.userIdentity.count == 0 || [user.userIdentity[0] intValue] == 201003){
            self.certificateLabel.text = @"未认证";
        }else if ([user.userIdentity[0] intValue] == 201002){
            self.certificateLabel.text = @"审核中";
        }else if ([user.userIdentity[0] intValue] == 201001){
            self.certificateLabel.text = @"已认证";
        }
    
    self.certificateLabel.frame = CGRectMake(certificateLabelX, certificateLabelY, certificateLabelW, certificateLabelH);
    

    
    // 3.正文（内容）
    NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc]initWithString:dynamic.content];
    self.textLabel.attributedText = attStr;
    self.textLabel.frame = originalFrame.textFrame;
    
#warning 需要时刻根据现在的时间字符串来计算时间label的frame
    // 4.时间
//    NSString *time = status.created_at;
    NSString *time = [NSString stringWithFormat:@"%zd",dynamic.date];
    self.timeLabel.text = [time stringWithTimeStamp:@(dynamic.date)]; // 刚刚 --> 1分钟前 --> 10分钟前
    CGFloat timeX = CGRectGetMinX(self.nameLabel.frame);
    CGFloat timeY = CGRectGetMaxY(self.nameLabel.frame) + HMStatusCellInset * 0.5;
    CGSize timeSize = [time sizeWithFont:HMStatusOrginalTimeFont];
    self.timeLabel.frame = (CGRect){{timeX, timeY}, timeSize};
    
    // 4.来源
//    self.sourceLabel.text = status.source;
//    CGFloat sourceX = CGRectGetMaxX(self.timeLabel.frame) + HMStatusCellInset;
//    CGFloat sourceY = timeY;
//    CGSize sourceSize = [status.source sizeWithFont:HMStatusOrginalSourceFont];
//    self.sourceLabel.frame = (CGRect){{sourceX, sourceY}, sourceSize};
    
//    //5.视频
    if (dynamic.video.videoId.length) { //有视频
        
        self.videoView.frame = originalFrame.videoViewFrame;
        
        self.videoImage.frame = self.videoView.bounds;
//        self.videoImage.image = [UIImage imageNamed:@"minion_01"];
        [self.videoImage sd_setImageWithURL:[NSURL URLWithString:dynamic.video.imgUrl] placeholderImage:[UIImage imageNamed:@"video"]];
        
        self.playBtn.frame = originalFrame.playBtnFrame;
        [self.playBtn setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        self.videoView.hidden = NO;
        self.videoImage.hidden = NO;
        self.playBtn.hidden = NO;
        
    }else{
        
        self.videoView.hidden = YES;
        self.videoImage.hidden = YES;
        self.playBtn.hidden = YES;
    }
    
    
    // 6.配图相册
    if (dynamic.images.count) { // 有配图
        
//        NSLog(@"%zd",dynamic.images.count);
        
        self.photosView.frame = originalFrame.photosFrame;
        self.photosView.images = dynamic.images;
        self.photosView.hidden = NO;
    } else {
        self.photosView.hidden = YES;
    }
}

@end
