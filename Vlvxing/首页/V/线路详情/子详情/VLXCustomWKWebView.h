//
//  VLXCustomWKWebView.h
//  Vlvxing
//
//  Created by 王静雨 on 2017/5/25.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
typedef void(^WkBlock)(CGFloat height);
@interface VLXCustomWKWebView : UIView
@property (nonatomic,strong)UIWebView *webView;
//@property(nonatomic,strong) UIWebView *webView;
@property(nonatomic,assign) CGFloat webHeight;

@property(nonatomic,copy)NSString *url ;

@property (nonatomic,strong)WkBlock WkBlock;
@end
