//
//  RetuenBarButtonItem.h
//  Xlx
//
//  Created by 陈一 on 15-6-18.
//  Copyright (c) 2015年 handong001. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ReturnBarButtonItem;
@class MyBarButtomItem;

@protocol ReturnBarButtonDelegate <NSObject>

@optional
-(void)didClickReturnItem:(ReturnBarButtonItem *)buttonItem;
-(void)didClickMyButtonItem:(MyBarButtomItem *)buttonItem;
@end

@interface ReturnBarButtonItem : UIBarButtonItem

@property(nonatomic,weak) id<ReturnBarButtonDelegate> delegate;

@end

@interface MyBarButtomItem:UIBarButtonItem
@property(nonatomic,weak) UIButton *btn;
-(void)setBtnSize:(CGSize)btnSize;
-(instancetype)initWithImage:(UIImage *)image;
-(instancetype)initWithTitle:(NSString *)title;
-(instancetype)initWithTitle:(NSString *)title backgroundColor:(UIColor *)backgroundColor;
-(instancetype)initWithTitle:(NSString *)title backgroundColor:(UIColor *)backgroundColor tag:(NSInteger) tag;
-(instancetype)initWithTitle:(NSString *)title tag:(NSInteger)tag;
-(instancetype)initWithTitle:(NSString *)title titleColor:(UIColor *)titleColor;
-(instancetype)initWithTitle:(NSString *)title titleColor:(UIColor *)titleColor backgroundColor:(UIColor *)backgroundColor;
-(instancetype)initWithTitle:(NSString *)title titleColor:(UIColor *)titleColor backgroundColor:(UIColor *)backgroundColor tag:(NSInteger)tag;
-(instancetype)initWithTitle:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage;
@property(nonatomic,weak) id<ReturnBarButtonDelegate> delegate;

@end