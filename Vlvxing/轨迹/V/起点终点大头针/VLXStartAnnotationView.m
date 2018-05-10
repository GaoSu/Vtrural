//
//  VLXStartAnnotationView.m
//  Vlvxing
//
//  Created by 王静雨 on 2017/6/7.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXStartAnnotationView.h"

@implementation VLXStartAnnotationView
- (id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImage *image=[UIImage imageNamed:@"qidian"];
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
    _annotationImageView.image=[UIImage imageNamed:@"qidian"];
    [self addSubview:_annotationImageView];
    //
    _titleLab=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, _annotationImageView.frame.size.width, _annotationImageView.frame.size.height)];
    _titleLab.textColor=[UIColor whiteColor];
    _titleLab.font=[UIFont systemFontOfSize:14];
    _titleLab.textAlignment=NSTextAlignmentCenter;
    _titleLab.text=@"起";
    _titleLab.numberOfLines=1;
    [self addSubview:_titleLab];
    //

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
