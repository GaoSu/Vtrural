//
//  RetuenBarButtonItem.m
//  Xlx
//
//  Created by 陈一 on 15-6-18.
//  Copyright (c) 2015年 handong001. All rights reserved.
//

#import "ReturnBarButtonItem.h"
#import "NSString+WigthAndHeight.h"
@implementation ReturnBarButtonItem

-(instancetype)init
{
    if(self = [super init]){
        UIButton *btn = [[UIButton alloc]init];
        [btn setImage:[UIImage imageNamed:@"icon_fanhui"] forState:UIControlStateNormal];
        [btn setTitle:@"返回" forState:UIControlStateNormal];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(5, 0, 5, 36)];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [btn setTitleColor:[UIColor hexStringToColor:@"#cdcdcd"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(returnBtnClick:) forControlEvents:UIControlEventTouchDown];
        btn.frame = CGRectMake(0, 0, 60, 30);
        self.customView = btn;
    }
    return  self;
}

-(void)returnBtnClick:(UIButton *)btn
{
    if([self.delegate respondsToSelector:@selector(didClickReturnItem:)]){
        [self.delegate didClickReturnItem:self];
    }
}

@end

@interface MyBarButtomItem()

//@property(nonatomic,weak) UIButton *btn;

@end

@implementation MyBarButtomItem

-(instancetype)init
{
    if(self = [super init]){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        //[btn setTitle:@"设置" forState:UIControlStateNormal];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(xlxBtnClick:) forControlEvents:UIControlEventTouchDown];
        btn.layer.cornerRadius = 8;
        btn.frame = CGRectMake(0, 0, 50, 30);
        self.customView = btn;
        self.btn = btn;
    }
    return  self;
}

-(instancetype)initWithTitle:(NSString *)title
{
    if(self = [self init]){
        CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:16] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        [self.btn setTitle:title forState:UIControlStateNormal];
        self.btn.frame = CGRectMake(0, 0, size.width + 10, 30);
    }
    return self;
}

-(instancetype)initWithTitle:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage
{
    if(self = [self init])
    {
        CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        [self.btn setTitle:title forState:UIControlStateNormal];
        [self.btn setImage:image forState:UIControlStateNormal];
        [self.btn setImage:selectedImage forState:UIControlStateSelected];
        self.btn.frame = CGRectMake(0, 0, size.width + 30, 30);
        
    }
    return  self;
}

-(void)setBtnSize:(CGSize)btnSize{
    CGRect btnFrame = self.btn.frame;
    btnFrame.size = btnSize;
    self.btn.frame = btnFrame;
}

-(instancetype)initWithTitle:(NSString *)title backgroundColor:(UIColor *)backgroundColor
{
    if(self = [self initWithTitle:title]){
        self.btn.backgroundColor = backgroundColor;
    }
    return  self;
}

-(instancetype)initWithTitle:(NSString *)title backgroundColor:(UIColor *)backgroundColor tag:(NSInteger) tag
{
    if(self = [self initWithTitle:title backgroundColor:backgroundColor]){
        self.tag = tag;
    }
    return self;
}
-(instancetype)initWithTitle:(NSString *)title tag:(NSInteger)tag
{
    if(self = [self initWithTitle:title]){
        self.tag = tag;
    }
    return self;
}
-(instancetype)initWithTitle:(NSString *)title titleColor:(UIColor *)titleColor
{
    if(self = [self initWithTitle:title]){
        [self.btn setTitleColor:titleColor forState:UIControlStateNormal];
    }
    return self;
}
-(instancetype)initWithTitle:(NSString *)title titleColor:(UIColor *)titleColor backgroundColor:(UIColor *)backgroundColor
{
    if(self = [self initWithTitle:title titleColor:titleColor ]){
        self.btn.backgroundColor = backgroundColor;
    }
    return self;
}
-(instancetype)initWithTitle:(NSString *)title titleColor:(UIColor *)titleColor backgroundColor:(UIColor *)backgroundColor tag:(NSInteger)tag
{
    if(self = [self initWithTitle:title titleColor:titleColor backgroundColor:backgroundColor]){
        self.tag =tag;
    }
    return self;
}

-(instancetype)initWithImage:(UIImage *)image{
    if(self = [self init]){

        [self.btn setImage:image forState:UIControlStateNormal];
        self.btn.imageView.contentMode = UIViewContentModeLeft;
        self.btn.imageView.frame = self.btn.bounds;
        [self.btn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        self.btn.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    }
    return self;
}
-(void)xlxBtnClick:(UIButton *)btn
{
    if([self.delegate respondsToSelector:@selector(didClickMyButtonItem:)]){
        [self.delegate didClickMyButtonItem:self];
    }
}
@end
