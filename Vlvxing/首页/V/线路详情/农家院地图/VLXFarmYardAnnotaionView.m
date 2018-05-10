//
//  VLXFarmYardAnnotaionView.m
//  Vlvxing
//
//  Created by 王静雨 on 2017/6/23.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXFarmYardAnnotaionView.h"
@interface VLXFarmYardAnnotaionView ()
@property (nonatomic,strong)UILabel *titleLab;
@property (nonatomic,strong)UILabel *distanceLab;

@end
@implementation VLXFarmYardAnnotaionView
- (id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {


        [self setBounds:CGRectMake(0.f, 0.f, ScaleWidth(320), 32+66)];
        [self setBackgroundColor:[UIColor clearColor]];
        [self createUI];
    }
    return self;
}
-(void)createUI
{
    UIView *topView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 52)];
    topView.backgroundColor=[UIColor whiteColor];
    [self addSubview:topView];
    topView.layer.cornerRadius=5;
    topView.layer.masksToBounds=YES;
    //三角图标
    UIImage *sjImage=[UIImage imageNamed:@"nongjialesanjiao"];
    UIImageView *sanjiao=[[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width-sjImage.size.width)/2, CGRectGetMaxY(topView.frame), sjImage.size.width, sjImage.size.height)];
    sanjiao.image=sjImage;
    [self addSubview:sanjiao];
    //
    UIView *rightView=[[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width-52, 0, 52, 52)];
    rightView.backgroundColor=blue_color;
    [topView addSubview:rightView];
    
    //添加手势
    rightView.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToGo:)];
    [rightView addGestureRecognizer:tap];
    
    //
    UIImage *goImage=[UIImage imageNamed:@"go-here"];
    UIImageView *goImageView=[[UIImageView alloc] initWithFrame:CGRectMake((rightView.frame.size.width-goImage.size.width)/2, 4.5, goImage.size.width, goImage.size.height)];
    goImageView.image=goImage;
    [rightView addSubview:goImageView];
    UILabel *goLab=[[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(goImageView.frame)+6, rightView.frame.size.width, 11)];
    goLab.text=@"去这里";
    goLab.textColor=[UIColor whiteColor];
    goLab.textAlignment=NSTextAlignmentCenter;
    goLab.font=[UIFont systemFontOfSize:11];
    [rightView addSubview:goLab];
    //
    _titleLab=[[UILabel alloc] initWithFrame:CGRectMake(8, 8, self.frame.size.width-CGRectGetWidth(rightView.frame), 13)];
    _titleLab.textColor=[UIColor hexStringToColor:@"#313131"];
    _titleLab.font=[UIFont systemFontOfSize:14];
    _titleLab.textAlignment=NSTextAlignmentLeft;
    _titleLab.text=@"北京红螺寺路5号院";
    [topView addSubview:_titleLab];
    _distanceLab=[[UILabel alloc] initWithFrame:CGRectMake(_titleLab.frame.origin.x, CGRectGetMaxY(_titleLab.frame)+8, _titleLab.frame.size.width, 11)];
    _distanceLab.textColor=[UIColor hexStringToColor:@"#666666"];
    _distanceLab.font=[UIFont systemFontOfSize:11];
    _distanceLab.textAlignment=NSTextAlignmentLeft;
    _distanceLab.text=@"据您5.3公里";
    [topView addSubview:_distanceLab];
    
    //
    //底部大头针
    UIImage *image=[UIImage imageNamed:@"location-red"];
    UIImageView *iconImageView=[[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width-21)/2, self.frame.size.height-32, 16, 25)];
    iconImageView.image=image;
    [self addSubview:iconImageView];
}
-(void)createUIWithModel:(VLXHomeDetailModel *)detailModel
{
    
    _titleLab.text=[ZYYCustomTool checkNullWithNSString:detailModel.data.address];
    _distanceLab.text=[NSString stringWithFormat:@"据您%@公里",[ZYYCustomTool checkNullWithNSString:[NSString stringWithFormat:@"%.2f",detailModel.data.distance.floatValue/1000]]];
}
-(void)tapToGo:(UITapGestureRecognizer *)tap
{
    NSLog(@"去这里");
    if (_farmBlock) {
        _farmBlock();
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
