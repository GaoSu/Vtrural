//
//  VLX_CommunityTBVW_Cell.m
//  Vlvxing
//
//  Created by grm on 2017/10/25.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLX_CommunityTBVW_Cell.h"
//#import "VLX_CommunityMdel.h"


@implementation VLX_CommunityTBVW_Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    self.contentView.backgroundColor = [UIColor whiteColor];
    
}
//高亮
-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    self.contentView.backgroundColor = [UIColor whiteColor];
    
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self UI];
    }return self;
}

-(void)UI
{
    self.contentView.userInteractionEnabled = YES;//打开交互

    _headImgvw = [[UIImageView alloc]initWithFrame:CGRectMake(11, 8, 48, 48)];
//    _headImgvw.backgroundColor =[UIColor lightGrayColor];
    [_headImgvw setImage:[UIImage imageNamed:@"touxiang-moren"]];
    _headImgvw.layer.cornerRadius = 24;
    _headImgvw.clipsToBounds = YES;

    
    _nameLb = [[UILabel alloc]init];
    _nameLb.text = @"蛋蛋";

    _timeLb = [[UILabel alloc]init];//WithFrame:CGRectMake(70+6+ nameW+6, 32, 155, 9)];//
    _timeLb.textColor = [UIColor lightGrayColor];
    _timeLb.font = [UIFont systemFontOfSize:9];
    _timeLb.text = @"22:34";

    _titleLb = [[UILabel alloc]initWithFrame:CGRectMake(11, 67,ScreenWidth-11-20 , 17)];
    _titleLb.font = [UIFont systemFontOfSize:15];
    _titleLb.numberOfLines = 1;
//    _titleLb.text = @"正文正文正文正文正文正文正文正文正文正文正文正文正文正文正文正文正文正文正文正文正文正文正文正文正文正文正文正文正文正文正文正文正文正文正文正文正文正文正文正文正文正文正文正文正文正文";

    _sumView = [[UIView alloc]init];//WithFrame:CGRectMake(11, 92, ScreenWidth-22, 108)];//正文图片

    for (int i = 0 ; i<3; i++) {
        _LittleImgV = [[UIImageView alloc]initWithFrame:CGRectMake(0+(ScreenWidth-22)/3 *i, 0,(ScreenWidth-44)/3, 108)];
        _LittleImgV.tag = 100+i;//
        [_sumView addSubview:_LittleImgV];
    }
//    _sumView.userInteractionEnabled = YES
//视频
    _videoView = [[UIImageView alloc]init];
    _videoView.backgroundColor = rgba(240, 240, 240, 1);

    _playBt = [UIButton buttonWithType:UIButtonTypeCustom];
    [_playBt setImage:[UIImage imageNamed:@"video.png"] forState:UIControlStateNormal];
    [_playBt addTarget:self action:@selector(playVIDEO) forControlEvents:UIControlEventTouchUpInside];
//    [_videoView addSubview:_playBt];


//地点
    _areaImgvw = [[UIImageView alloc]init];//WithFrame:CGRectMake(11, 94+_sumView.frame.size.height, 12, 15)];
    _areaImgvw.image = [UIImage imageNamed:@"dizhiii"];//后期要改
    _areaLb = [[UILabel alloc]init];//WithFrame:CGRectMake(11+12+2, 97+_sumView.frame.size.height,60 , 11)];
    _areaLb.textColor = [UIColor grayColor];
    _areaLb.font = [UIFont systemFontOfSize:11];
    _areaLb.text = @"北京";
 //查看数
    _watchImgvw = [[UIImageView alloc]init];//WithFrame:CGRectMake(ScreenWidth - 230, 94+_sumView.frame.size.height, 18, 15)];
    _watchImgvw.image = [UIImage imageNamed:@"xianshi2"];//后期要改;
    
    _watchLb = [[UILabel alloc]init];//WithFrame:CGRectMake(ScreenWidth - 230 + 18 + 3, 97+_sumView.frame.size.height,39 , 11)];
    _watchLb.textColor = [UIColor lightGrayColor];
    _watchLb.font = [UIFont systemFontOfSize:11];
    _watchLb.text = @"2344";
//评论数
    _pinglunImgvw = [[UIImageView alloc]init];//WithFrame:CGRectMake(ScreenWidth - 130, 94+_sumView.frame.size.height, 18, 15)];
    _pinglunImgvw.image = [UIImage imageNamed:@"comment-"];//后期要改;

    _pinglunLb = [[UILabel alloc]init];//WithFrame:CGRectMake(ScreenWidth - 130 + 18 + 3, 97+_sumView.frame.size.height,39 , 11)];
    _pinglunLb.textColor = [UIColor lightGrayColor];
    _pinglunLb.font = [UIFont systemFontOfSize:12];
    _pinglunLb.text = @"235";




//点赞数
    _dianzanBt = [[UIButton alloc]init];//WithFrame:CGRectMake(ScreenWidth-65, 97+_sumView.frame.size.height, 39, 19)];
    _dianzanBt.titleLabel.font = [UIFont systemFontOfSize:10];
    _dianzanBt.titleLabel.text = @"2";
    _dianzanBt.titleLabel.textColor = [UIColor lightGrayColor];
    _dianzanBt.titleLabel.textAlignment = NSTextAlignmentCenter;




    [self.contentView addSubview:_headImgvw];
    [self.contentView addSubview:_nameLb];
    [self.contentView addSubview:_dateLb];
    [self.contentView addSubview:_timeLb];
    [self.contentView addSubview:_titleLb];
    [self.contentView addSubview:_sumView];
    [self.contentView addSubview:_videoView];
    [self.contentView addSubview:_areaImgvw];
    [self.contentView addSubview:_areaLb];
    [self.contentView addSubview:_watchImgvw];
    [self.contentView addSubview:_watchLb];
    [self.contentView addSubview:_pinglunImgvw];
    [self.contentView addSubview:_pinglunLb];
    [self.contentView addSubview:_dianzanBt];
//    [self.contentView addSubview:_likeLb];

    
}

-(void)FillWithModel:(VLX_newCommnuityModel *)model{

    if ([model.content isEqualToString:@""]) {
        _Cell_height = 0.0f;
    }
    else{
        _Cell_height = 18.0f;
    }

    if(![model.member[@"userpic"] isKindOfClass:[NSNull class]]){
        [_headImgvw sd_setImageWithURL:[NSURL URLWithString:model.member[@"userpic"]] placeholderImage:nil];
    }
    NSTimeInterval interval   = [model.createTime doubleValue]/1000;
    NSDate *date              = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd :HH:mm"];
    _timeLb.text =  [formatter stringFromDate: date];

    if ([model.member[@"usernick"] isKindOfClass:[NSNull class]]) {
        _nameLb.text = @"";
    }else{
        _nameLb.text = model.member[@"usernick"];
    }
    UIFont *fnt = [UIFont fontWithName:@"Courier New" size:15.0f];
    _nameLb.font = fnt;
    // 根据字体得到NSString的尺寸
    CGSize size1 = [_nameLb.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName,nil]];
    CGFloat nameW1 = size1.width;
    _nameLb.frame = CGRectMake(70,7, nameW1,22);
    _timeLb.frame = CGRectMake(70, 34, 155, 9);//(70+6+ nameW1+6, 32, 155, 9);
//////判断图片
    if (model.pictures.count==0) {
        _sumView.frame =CGRectMake(11, -20+89+_Cell_height, ScreenWidth-22, 0);

        UIImageView *imgvw1   = (UIImageView *)[self.contentView viewWithTag:(100)];
        imgvw1.hidden = YES;

        UIImageView *imgvw2   = (UIImageView *)[self.contentView viewWithTag:(101)];
        imgvw2.hidden = YES;

        UIImageView *imgvw3   = (UIImageView *)[self.contentView viewWithTag:(102)];
        imgvw3.hidden = YES;

    }else{
        _sumView.frame =CGRectMake(11, -20+89+_Cell_height, ScreenWidth-22, 108);
        NSMutableArray * aryIMG = [NSMutableArray array];

        for(NSDictionary * dic in model.pictures){
            [aryIMG addObject:dic[@"path"]];
        }

        for(int i=0; i<model.pictures.count;i++){

            UIImageView *imgvw   = (UIImageView *)[self.contentView viewWithTag:(100+i)];
            [imgvw sd_setImageWithURL: [NSURL URLWithString:aryIMG[i]]];
            imgvw.contentMode =UIViewContentModeScaleAspectFill;//这两句代码是为了防止图片呗拉伸或挤压变形
            imgvw.clipsToBounds = YES;

        }

    }
//////判断视频
    CGFloat vHeightt = 0.0f;
    if (model.videoUrl == nil){
        vHeightt = 0.0f;
        _videoView.frame = CGRectMake(0, 0, 0, 0);
//        [_playBt removeFromSuperview];
    }else{
        vHeightt = ScreenWidth*9/16;
        CGSize size = [self getImageSizeWithURL:[NSURL URLWithString:model.thumbnail]];
        CGFloat videoWidth = ScreenWidth*9/16 * (size.width/size.height);
        _videoView.frame = CGRectMake((ScreenWidth - videoWidth)/2, -20+89+_Cell_height, videoWidth, ScreenWidth*9/16);
      
        [_videoView sd_setImageWithURL: [NSURL URLWithString:model.thumbnail]];
        _SRvideoView = [SRVideoPlayer playerWithVideoURL:[NSURL URLWithString:model.videoUrl] playerView:_videoView playerSuperView:_videoView.superview];
        _SRvideoView.playerEndAction = SRVideoPlayerEndActionStop;
        [_videoView addSubview:_playBt];
        _playBt.frame = CGRectMake(_videoView.frame.size.width/2 - 18, _videoView.frame.size.height/2 -18, 36, 36);
//        _playBt.backgroundColor = [UIColor redColor];
        if(_SRvideoView.playerState == YES){
            NSLog(@"bbb");
        }
    }



    NSAttributedString * attributeStr = [self attributedStringWithHTMLString:model.content];
    _titleLb.attributedText = attributeStr;
    //富文本方式设置行间距
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineSpacing = 10.0f;
    NSDictionary *attributes = @{ NSFontAttributeName:[UIFont systemFontOfSize:15.0f], NSParagraphStyleAttributeName:paragraphStyle};
    _titleLb.attributedText = [[NSAttributedString alloc]initWithString:_titleLb.text attributes:attributes];
    [_titleLb sizeToFit];
    //将样式改回在末尾显示省略号的样式
    _titleLb.lineBreakMode = NSLineBreakByTruncatingTail;

    if (model.areaname == nil){
        _areaLb.text = @"北京市";
    }else{
        _areaLb.text = model.areaname;
    }
    _watchLb.text = [NSString  stringWithFormat:@"%@",model.allpageview];
    _pinglunLb.text = [NSString stringWithFormat:@"%@",model.commentCount];
    //文字高度
//    CGRect rect = [_titleLb.text boundingRectWithSize:CGSizeMake(ScreenWidth-32, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
//    NSLog(@"高度%.f",rect.size.height);
//    _Cell_height = rect.size.height;//代码ok
//    if ([model.content isEqualToString:@""]) {
//        _Cell_height = 0.0f;
//    }
//    else{
//        _Cell_height = 18.0f;
//    }
    _titleLb.frame = CGRectMake(11, 67,ScreenWidth-11-20 ,_Cell_height);

    _areaImgvw.frame = CGRectMake(11, 67+_Cell_height +_sumView.frame.size.height+12*2+vHeightt, 12, 15);
    _areaLb.frame = CGRectMake(11+12+2, 67+_Cell_height +_sumView.frame.size.height+12*2+vHeightt, 60, 15);

    _watchImgvw.frame = CGRectMake(ScreenWidth - 230, 67+_Cell_height +_sumView.frame.size.height+12*2+vHeightt, 18, 15);
    _watchLb.frame = CGRectMake(ScreenWidth - 230 + 18 + 3, 67+_Cell_height +_sumView.frame.size.height+12*2+vHeightt, 39, 15);

    _pinglunImgvw.frame = CGRectMake(ScreenWidth - 130, 67+_Cell_height +_sumView.frame.size.height+12*2+vHeightt, 18, 15);
    _pinglunLb.frame = CGRectMake(ScreenWidth - 130 + 18 + 3, 67+_Cell_height +_sumView.frame.size.height+12*2+vHeightt, 39, 15);

    _dianzanBt.frame = CGRectMake(ScreenWidth - 65, 66+_Cell_height +_sumView.frame.size.height+12*2+vHeightt, 60, 16);
    if([model.isFavor isEqual: @1]){//已经点赞

        [_dianzanBt setImage:[UIImage imageNamed:@"like_highlighted"] forState:UIControlStateNormal];

        NSString * str = [NSString stringWithFormat:@"%@",model.favor];
        int zan = [str intValue];
        zan+=1;
        NSString * str2 = [NSString stringWithFormat:@"%d",zan];
         [_dianzanBt setTitle: str2 forState:UIControlStateNormal];
        _dianzanBt.imageEdgeInsets = UIEdgeInsetsMake(0,3,0,_dianzanBt.titleLabel.frame.size.width+8);
        [_dianzanBt setTitleColor:rgba(244, 83, 73, 1) forState:UIControlStateNormal];
    }else{//未点赞
        [_dianzanBt setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
        NSString * str = [NSString stringWithFormat:@"%@",model.favor];
        int zan = [str intValue];
        NSString * str2 = [NSString stringWithFormat:@"%d",zan];
        [_dianzanBt setTitle: str2 forState:UIControlStateNormal];
        _dianzanBt.imageEdgeInsets = UIEdgeInsetsMake(0,3,0,_dianzanBt.titleLabel.frame.size.width+8);
        [_dianzanBt setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }


}
//播放
-(void)playVIDEO{
//    [_playBt removeFromSuperview];
    _playBt.hidden = YES;
    [_SRvideoView play];
    double delayInSeconds = 11.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);

    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        //执行事件
        _playBt.hidden = NO;
    });
}

- (NSAttributedString *)attributedStringWithHTMLString:(NSString *)htmlString
{
    NSDictionary *options = @{ NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType,
                               NSCharacterEncodingDocumentAttribute :@(NSUTF8StringEncoding) };

    NSData *data = [htmlString dataUsingEncoding:NSUTF8StringEncoding];

    return [[NSAttributedString alloc] initWithData:data options:options documentAttributes:nil error:nil];
}


/**
 根据图片的url返回尺寸

 @param URL url
 @return size
 */
- (CGSize)getImageSizeWithURL:(id)URL{
    NSURL * url = nil;
    if ([URL isKindOfClass:[NSURL class]]) {
        url = URL;
    }
    if ([URL isKindOfClass:[NSString class]]) {
        url = [NSURL URLWithString:URL];
    }
    if (!URL) {
        return CGSizeZero;
    }
    CGImageSourceRef imageSourceRef =     CGImageSourceCreateWithURL((CFURLRef)url, NULL);
    CGFloat width = 0, height = 0;
    if (imageSourceRef) {
        CFDictionaryRef imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSourceRef, 0, NULL);
        if (imageProperties != NULL) {
            CFNumberRef widthNumberRef = CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelWidth);
            if (widthNumberRef != NULL) {
                CFNumberGetValue(widthNumberRef, kCFNumberFloat64Type, &width);
            }
            CFNumberRef heightNumberRef = CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelHeight);
            if (heightNumberRef != NULL) {
                CFNumberGetValue(heightNumberRef, kCFNumberFloat64Type, &height);
            }
            CFRelease(imageProperties);
        }
        CFRelease(imageSourceRef);
    }
    return CGSizeMake(width, height);
}



@end
