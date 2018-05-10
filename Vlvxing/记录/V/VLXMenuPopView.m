//
//  VLXMenuPopView.m
//  Vlvxing
//
//  Created by 王静雨 on 2017/6/15.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXMenuPopView.h"
@interface VLXMenuPopView ()
@property (nonatomic,assign)NSInteger type;
@end
@implementation VLXMenuPopView
-(instancetype)initWithFrame:(CGRect)frame andType:(NSInteger)type
{
    if (self=[super initWithFrame:frame]) {
        _type=type;
        if (_type==1) {
            self.frame=CGRectMake(kScreenWidth-92, 0, 92, 10+2*46.5);
        }else if (_type==2)
        {
            self.frame=CGRectMake(kScreenWidth-92, 0, 92, 10+3*46.5);
        }else if (_type==3)
        {
            self.frame=CGRectMake(kScreenWidth-92, 0, 92, 10+1*46.5);
        }
        
        [self createUI];
    }
    return self;
}
#pragma mark---数据
#pragma mark
#pragma mark---视图
-(void)createUI
{
    UIImageView *iconImage=[[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width-23, 0, 12, 10)];
    iconImage.image=[UIImage imageNamed:@"sanjiao"];
    [self addSubview:iconImage];
    if (_type==1) {
        NSArray *titleArray=@[@"分享",@"删除"];
        NSArray *imageArray=@[@"share-icon",@"delete"];
        for (int i=0; i<2; i++) {
            UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, i*46.5+CGRectGetMaxY(iconImage.frame), self.frame.size.width, 46.5)];
            view.backgroundColor=[UIColor whiteColor];
            [self addSubview:view];
            //添加手势
            view.tag=100+i;
            view.userInteractionEnabled=YES;
            UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToEvent:)];
            [view addGestureRecognizer:tap];
            //
            if (i==0) {
                UIView *line=[[UIView alloc] initWithFrame:CGRectMake(6, CGRectGetHeight(view.frame)-0.5, self.frame.size.width-6*2, 0.5)];
                line.backgroundColor=separatorColor1;
                [view addSubview:line];
            }
            UIImage *image=[UIImage imageNamed:imageArray[i]];
            UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(10, (46.5-image.size.height)/2, image.size.width, image.size.height)];
            imageView.image=image;
            [view addSubview:imageView];
            UILabel *titleLab=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+10, 0, self.frame.size.width-(CGRectGetMaxX(imageView.frame)+10), 46.5)];
            titleLab.text=titleArray[i];
            titleLab.textColor=[UIColor hexStringToColor:@"#666666"];
            titleLab.font=[UIFont systemFontOfSize:16];
            [view addSubview:titleLab];
        }
    }else if (_type==2)
    {
        NSArray *titleArray=@[@"分享",@"编辑",@"删除"];
        NSArray *imageArray=@[@"share-icon",@"edit-icon",@"delete"];
        for (int i=0; i<3; i++) {
            UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, i*46.5+CGRectGetMaxY(iconImage.frame), self.frame.size.width, 46.5)];
            view.backgroundColor=[UIColor whiteColor];
            [self addSubview:view];
            //添加手势
            view.tag=100+i;
            view.userInteractionEnabled=YES;
            UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToEvent:)];
            [view addGestureRecognizer:tap];
            //
            if (i==0||i==1) {
                UIView *line=[[UIView alloc] initWithFrame:CGRectMake(6, CGRectGetHeight(view.frame)-0.5, self.frame.size.width-6*2, 0.5)];
                line.backgroundColor=separatorColor1;
                [view addSubview:line];
            }
            UIImage *image=[UIImage imageNamed:imageArray[i]];
            UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(10, (46.5-image.size.height)/2, image.size.width, image.size.height)];
            imageView.image=image;
            [view addSubview:imageView];
            UILabel *titleLab=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+10, 0, self.frame.size.width-(CGRectGetMaxX(imageView.frame)+10), 46.5)];
            titleLab.text=titleArray[i];
            titleLab.textColor=[UIColor hexStringToColor:@"#666666"];
            titleLab.font=[UIFont systemFontOfSize:16];
            [view addSubview:titleLab];
        }
    }else if (_type==3)
    {
//        NSArray *titleArray=@[@"删除"];
//        NSArray *imageArray=@[@"delete"];
        NSArray *titleArray=@[@"分享"];
        NSArray *imageArray=@[@"share-icon"];
        for (int i=0; i<titleArray.count; i++) {
            UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, i*46.5+CGRectGetMaxY(iconImage.frame), self.frame.size.width, 46.5)];
            view.backgroundColor=[UIColor whiteColor];
            [self addSubview:view];
            //添加手势
            view.tag=200+i;
            view.userInteractionEnabled=YES;
            UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToEvent:)];
            [view addGestureRecognizer:tap];
            //
            if (i==0||i==1) {
                UIView *line=[[UIView alloc] initWithFrame:CGRectMake(6, CGRectGetHeight(view.frame)-0.5, self.frame.size.width-6*2, 0.5)];
                line.backgroundColor=separatorColor1;
                [view addSubview:line];
            }
            UIImage *image=[UIImage imageNamed:imageArray[i]];
            UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(10, (46.5-image.size.height)/2, image.size.width, image.size.height)];
            imageView.image=image;
            [view addSubview:imageView];
            UILabel *titleLab=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+10, 0, self.frame.size.width-(CGRectGetMaxX(imageView.frame)+10), 46.5)];
            titleLab.text=titleArray[i];
            titleLab.textColor=[UIColor hexStringToColor:@"#666666"];
            titleLab.font=[UIFont systemFontOfSize:16];
            [view addSubview:titleLab];
        }
    }
    
}
#pragma mark
#pragma mark---事件
-(void)tapToEvent:(UITapGestureRecognizer *)tap
{
    
    if (_type==1) {
        if (_menuBlock) {
            _menuBlock(tap.view.tag-100);
        }
    }else if (_type==2)
    {
        if (_menuBlock) {
            _menuBlock(tap.view.tag);
        }
    }else if (_type==3)
    {
        if (_menuBlock) {
            _menuBlock(tap.view.tag);
        }
    }
    [self removeFromSuperview];
    
}
#pragma mark
#pragma mark---delegate
#pragma mark
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
