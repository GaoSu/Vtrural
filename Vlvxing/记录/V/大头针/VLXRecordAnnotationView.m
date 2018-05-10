//
//  VLXRecordAnnotationView.m
//  Vlvxing
//
//  Created by 王静雨 on 2017/6/3.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXRecordAnnotationView.h"

@implementation VLXRecordAnnotationView
- (id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImage *image=[UIImage imageNamed:@"orange"];//图标
//        [self setBounds:CGRectMake(0.f, 0.f, 25.f, 30.f)];
        [self setBounds:CGRectMake(0.f, 0.f, image.size.width, image.size.height)];
        [self setBackgroundColor:[UIColor clearColor]];
        [self createUI];
    }
    return self;
}
-(void)createUI
{
    _annotationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
//    _annotationImageView.contentMode = UIViewContentModeCenter;
    _annotationImageView.image=[UIImage imageNamed:@"orange"];
    [self addSubview:_annotationImageView];
    //
    _titleLab=[[UILabel alloc] initWithFrame:CGRectMake(0, 2, _annotationImageView.frame.size.width, 8.5)];
    _titleLab.textColor=[UIColor whiteColor];
    _titleLab.font=[UIFont systemFontOfSize:11];
    _titleLab.textAlignment=NSTextAlignmentCenter;
//    _titleLab.text=@"1";
    _titleLab.numberOfLines=1;
    [self addSubview:_titleLab];
    //
    _iconImageView=[[UIImageView alloc] init];
    [self addSubview:_iconImageView];
}
-(void)createUIWithModel:(VLXRecordDataModel *)model
{
    
    UIImage *image;
    _titleLab.text = model.countNum;
//    if (![NSString checkForNull:model.travelroadid]) {//如果travelroadid有值，表示轨迹
//        image=[UIImage imageNamed:@"guiji"];
//    }else
//    {
        if (![NSString checkForNull:model.picurl]) {//表示图片
            image=[UIImage imageNamed:@"tupian"];
        }
        else if (![NSString checkForNull:model.videourl])//表示视频
        {
            image=[UIImage imageNamed:@"shipin"];
        }
//    }
    _iconImageView.frame=CGRectMake((self.frame.size.width-image.size.width)/2, CGRectGetMaxY(_titleLab.frame)+3, image.size.width, image.size.height);
    _iconImageView.image=image;
}

-(void)createUIWithGuijiModel:(VLXGuiJiModel *)model{
  
    UIImage *image;
    _titleLab.text = model.countNum;
     image=[UIImage imageNamed:@"guiji"];
    _iconImageView.frame=CGRectMake((self.frame.size.width-image.size.width)/2, CGRectGetMaxY(_titleLab.frame)+3, image.size.width, image.size.height);
    _iconImageView.image=image;
    
}

-(void)createUIWithCourseModel:(VLXCourseModel *)model//用于轨迹
{
    UIImage *image;
//    if (![NSString checkForNull:model.travelroadid]) {//如果travelroadid有值，表示轨迹
//        image=[UIImage imageNamed:@"guiji"];
//    }else
//    {
        if (![NSString checkForNull:model.picUrl]) {//表示图片
            image=[UIImage imageNamed:@"tupian"];
        }
        else if (![NSString checkForNull:model.videoUrl])//表示视频
        {
            image=[UIImage imageNamed:@"shipin"];
        }
//    }
    _iconImageView.frame=CGRectMake((self.frame.size.width-image.size.width)/2, CGRectGetMaxY(_titleLab.frame)+3, image.size.width, image.size.height);
    _iconImageView.image=image;
}
-(void)createUIWithRecordLine:(VLXRecordDetailInfoModel *)model
{
    UIImage *image;
    //    if (![NSString checkForNull:model.travelroadid]) {//如果travelroadid有值，表示轨迹
    //        image=[UIImage imageNamed:@"guiji"];
    //    }else
    //    {
    if (![NSString checkForNull:model.picurl]) {//表示图片
        image=[UIImage imageNamed:@"tupian"];
    }
    else if (![NSString checkForNull:model.videourl])//表示视频
    {
        image=[UIImage imageNamed:@"shipin"];
    }
    //    }
    _iconImageView.frame=CGRectMake((self.frame.size.width-image.size.width)/2, CGRectGetMaxY(_titleLab.frame)+3, image.size.width, image.size.height);
    _iconImageView.image=image;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
