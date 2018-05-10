//
//  VLXSpotAnnotationView.m
//  Vlvxing
//
//  Created by 王静雨 on 2017/6/2.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXSpotAnnotationView.h"
@interface VLXSpotAnnotationView ()
@property (nonatomic, strong) UIImageView *annotationImageView;

@end
@implementation VLXSpotAnnotationView
- (id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBounds:CGRectMake(0.f, 0.f, 14, 22)];
        [self setBackgroundColor:[UIColor clearColor]];
        [self createUI];
    }
    return self;
}
-(void)createUI
{
//    _annotationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (self.frame.size.height-22)/2, 14, 22)];
    _annotationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 14, 22)];
    _annotationImageView.contentMode = UIViewContentModeCenter;
    _annotationImageView.image=[UIImage imageNamed:@"location-red"];
    [self addSubview:_annotationImageView];
    //
    _titleLab=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_annotationImageView.frame), 0, self.frame.size.width-14, self.frame.size.height)];
    _titleLab.textColor=[UIColor hexStringToColor:@"#313131"];
    _titleLab.font=[UIFont systemFontOfSize:16];
    _titleLab.textAlignment=NSTextAlignmentCenter;
    _titleLab.numberOfLines=0;
//    [self addSubview:_titleLab];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
