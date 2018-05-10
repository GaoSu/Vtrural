//
//  VLXCustomWKWebView.m
//  Vlvxing
//
//  Created by 王静雨 on 2017/5/25.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXCustomWKWebView.h"

@interface VLXCustomWKWebView ()<UIWebViewDelegate>

@end
@implementation VLXCustomWKWebView
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}
-(void)createUI
{
   
    //    //监听webview
//    [_webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}


-(void)setUrl:(NSString *)url{

    _url=url;
 
    
    if (self.webView) {
        [self.webView removeFromSuperview];
    }
    
    _webView=[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,1)];
    _webView.delegate=self;
    
    
    url = [self setImageStr:url];
//    NSString *scriptStr =[NSString stringWithFormat:@"<script> var imgs = document.getElementsByName(\"cellImage\");var width = %f;for(var i=0;i<imgs.length;i++){var img = imgs[i];var iWidth = img.offsetWidth;var iHeight = img.offsetHeight;var height = iHeight * width / iWidth;img.style.width = width + 'px';img.style.height = height + 'px';} </script>",ScreenSize.width-8];
//    
//    url = [NSString stringWithFormat:@"%@ %@",url,scriptStr];//html代码
//    
//    NSLog(@"图片地址吗:%@",url);
//
//    [self.webView loadHTMLString:url baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] resourcePath]]];
    
    //万能适用,自动匹配 fuck!
    NSMutableString *html = [NSMutableString string];
    [html appendString:@"<html>"];
    [html appendString:@"<head>"];
    [html appendString:@"<script src=\"http://code.jquery.com/jquery-2.1.1.min.js\">"];
    [html appendString:@"</script>"];
    [html appendString:@"</head>"];
    
    [html appendString:@"<body>"];
    [html appendString:url];
    [html appendString:@"<script>$('img').attr({width:'',height: ''}).css({width: '100%'})</script>"];
    [html appendString:@"</body>"];
    
    [html appendString:@"</html>"];
    [self.webView loadHTMLString:html baseURL:nil];
    

    


    

    
    [self addSubview:_webView];



}

-(NSString *)setImageStr:(NSString *)urlStr{
    
    NSArray *textArray = [urlStr componentsSeparatedByString:@"<img"];
    NSMutableArray *newArray = [NSMutableArray array];
    for(int i=0;i<textArray.count;i++){
        NSString *str = textArray[i];
        
//        NSLog(@"这是循环出每个图片:%@",str);
        if ([str isEqualToString:@""]) {
            continue;
        }
        
        str=[NSString stringWithFormat:@"<img name='cellImage'%@",str];
        [newArray addObject:str];
    }
    
    return [newArray componentsJoinedByString:@" "];
    
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
//    [self.webView removeFromSuperview];

   
    CGFloat sizeHeight = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] integerValue];
    if(self.webHeight != sizeHeight)
    {
        self.webHeight = sizeHeight;
        _webView.frame=CGRectMake(0, 0, kScreenWidth, sizeHeight+30);
        
        if (self.WkBlock) {
            self.WkBlock(sizeHeight+30);
        }
    }
    UIScrollView *webScrollView = (UIScrollView *)[[self.webView subviews] objectAtIndex:0];
    CGSize size = webScrollView.contentSize;
    size.height = 0;
    webScrollView.contentSize = size;
    [webScrollView setBounces:NO];
   
//    [self addSubview:_webView];

   
}


#pragma mark---webview delegate
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    NSLog(@"start");
    //不管怎么样，五秒菊花消失,多线程
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    NSLog(@"finish");
    [SVProgressHUD dismiss];
}
#pragma mark
//移除观察者

//-(void)dealloc
//
//{
//    
//    [self.webView.scrollView removeObserver:self forKeyPath:@"contentSize" context:nil];
//    
//}


@end
