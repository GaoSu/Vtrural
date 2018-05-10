//
//  VLXWebViewVC.m
//  Vlvxing
//
//  Created by 王静雨 on 2017/6/1.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXWebViewVC.h"
#import <WebKit/WebKit.h>
#import "ShareBtnView.h"
#import "VLXVHeadModel.h"
@interface VLXWebViewVC ()<ShareBtnViewDelegate,UIWebViewDelegate>
@property (nonatomic,strong)UIWebView *webView;

@property (nonatomic ,strong)NSString *contentStrs;

@property (strong,nonatomic)NSString *currentURL;
@property (strong,nonatomic)NSString *currentTitle;
@property (strong,nonatomic)NSString *currentHTML;



@property(nonatomic,weak)UIView * blackView;
@property(nonatomic,weak)ShareBtnView*shareView;
@end

@implementation VLXWebViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    NSLog(@"type什么:%ld",(long)_type);

    NSLog(@"轮播地址::%@",_urlStr);
//    //2.匹配字符串
    NSString *string = _Vmodel.vDescription;
    if(string.length)
    {
    NSLog(@"过滤之后:%@",[self filterHTML:string]);
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; //去除掉首尾的空白字符和换行字符
    string = [string stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSLog(@"再次过滤之后:%@",[self filterHTML:string]);
    _contentStrs = [self filterHTML:string];
    }


}
-(NSString *)filterHTML:(NSString *)html
{
      NSScanner * scanner = [NSScanner scannerWithString:html];
      NSString * text = nil;
      while([scanner isAtEnd]==NO)
    {
            //找到标签的起始位置
            [scanner scanUpToString:@"<" intoString:nil];
            //找到标签的结束位置
             [scanner scanUpToString:@">" intoString:&text];
             //替换字符
             html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];

         }
       return html;
   }
-(void)createUI
{
    
    [self setNav];
    _webView=[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64)];
    _webView.backgroundColor=[UIColor whiteColor];
    _webView.delegate = self;
//    _webView.scrollView.scrollEnabled = NO;
    _webView.scrollView.bouncesZoom = NO;
    _webView.scalesPageToFit = YES;
    _webView.scrollView.showsVerticalScrollIndicator=NO;
    _webView.scrollView.showsHorizontalScrollIndicator=NO;


    if (self.type == 3) {//V头条,都是h5
        [self shezhiUrlStr];
    }else{

        NSLog(@"%@",_urlStr);
      [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[ZYYCustomTool checkNullWithNSString:_urlStr]]]];
    }
    [self.view addSubview:_webView];

}

-(void) webViewDidFinishLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible =NO;
//    self.title = [_webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.inner"];//获取当前页面的title
//    self.title = [_webView stringByEvaluatingJavaScriptFromString:@"document.body.inner"];
//    self.title = [_webView stringByEvaluatingJavaScriptFromString:@"location.hosname"];
//    self.title = [_webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.innerText"];
    _currentTitle =[_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
//    self.currentURL = webView.request.URL.absoluteString;
//    NSString *lJs = @"document.documentElement.innerHTML";
//    self.currentHTML = [webView stringByEvaluatingJavaScriptFromString:lJs];



 if (self.type == 3) {//3是网页,需要用该方法修改文字
    NSString *str = @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '220%'";
    [_webView stringByEvaluatingJavaScriptFromString:str];
 }


}
-(void)shezhiUrlStr{//h5界面设置

             NSString *resultStr =_urlStr;
//    //郭荣明9.29修改
//             resultStr = [self setImageStr:resultStr];
//             NSString *scriptStr =[NSString stringWithFormat:@"<script> var imgs = document.getElementsByName(\"cellImage\");var width = %f;for(var i=0;i<imgs.length;i++){var img = imgs[i];var iWidth = img.offsetWidth;var iHeight = img.offsetHeight;var height = iHeight * width / iWidth;img.style.width = width + 'px';img.style.height = height + 'px';} </script>",ScreenSize.width-8];
//
//             resultStr = [NSString stringWithFormat:@"%@ %@",resultStr,scriptStr];
//             [self.webView loadHTMLString:resultStr baseURL:nil];

//////万能适用,自动匹配//sglh源码↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓

    NSMutableString *html = [NSMutableString string];
    [html appendString:@"<html>"];
    [html appendString:@"<head>"];
    [html appendString:@"<script src=\"http://code.jquery.com/jquery-2.1.1.min.js\">"];
    [html appendString:@"</script>"];
    [html appendString:@"</head>"];
    [html appendString:@"<body>"];
//        [html appendString:@"<body style=\"font-size:24px\">"];//
    [html appendString:resultStr];
    [html appendString:@"<script>$('img').attr({width:'',height:''}).css({width:'100%'})</script>"];
    [html appendString:@"</body>"];
    [html appendString:@"</html>"];
    [self.webView loadHTMLString:html baseURL:nil];
//////万能适用,自动匹配//sglh源码↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑




    


}

//-(NSString *)setImageStr:(NSString *)urlStr{
//    
//    NSArray *textArray = [urlStr componentsSeparatedByString:@"<img"];
//    NSMutableArray *newArray = [NSMutableArray array];
//    for(int i=0;i<textArray.count;i++){
//        NSString *str = textArray[i];
//        
//        if ([str isEqualToString:@""]) {
//            continue;
//        }
//        
//        str=[NSString stringWithFormat:@"<img name='cellImage'%@",str];
//        [newArray addObject:str];
//    }
//    
//    return [newArray componentsJoinedByString:@" "];
//}

-(void)setNav
{
    NSLog(@"等于多少%ld",(long)_type);
    //设置标题
    if(_type==0){
        self.title=@"详情";
    }
    else if (_type==1) {
        self.title=@"火车票";
    }else if (_type==2)
    {
        self.title=@"机票";
    }else if (_type==3)
    {
        self.title=@"详情";
        //右边按钮
        UIView * rightview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 22)];
        rightview.backgroundColor=[UIColor whiteColor];
        
        UIImageView * rightimageview=[[UIImageView alloc]initWithFrame:CGRectMake(20, 0, 21.5, 22)];
        rightimageview.image=[UIImage imageNamed:@"share-red"];
        [rightview addSubview:rightimageview];
        
        UIBarButtonItem * rightBaritem=[[UIBarButtonItem alloc]initWithCustomView:rightview];
        self.navigationItem.rightBarButtonItem=rightBaritem;
        
        rightview.userInteractionEnabled=YES;
        UITapGestureRecognizer * rightTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rightClick2)];
        [rightview addGestureRecognizer:rightTap];
    }
    else if (_type==4){//所有轮播图就是4,(包括信用卡轮播图)
        self.title=@"详情";
        UIView * rightview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 22)];
        rightview.backgroundColor=[UIColor whiteColor];

        UIImageView * rightimageview=[[UIImageView alloc]initWithFrame:CGRectMake(20, 0, 21.5, 22)];
        rightimageview.image=[UIImage imageNamed:@"share-red"];
        [rightview addSubview:rightimageview];

        UIBarButtonItem * rightBaritem=[[UIBarButtonItem alloc]initWithCustomView:rightview];
        self.navigationItem.rightBarButtonItem=rightBaritem;

        rightview.userInteractionEnabled=YES;
        UITapGestureRecognizer * rightTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rightClick2)];
        [rightview addGestureRecognizer:rightTap];

    }
   
    self.view.backgroundColor=[UIColor whiteColor];
    //左边按钮
//    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//
//    leftBtn.frame = CGRectMake(0, 0, 20, 20);
//    [leftBtn setImage:[UIImage imageNamed:@"return-red"] forState:UIControlStateNormal];
//    [leftBtn addTarget:self action:@selector(tapLeftButton:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
//    self.navigationItem.leftBarButtonItem = leftBarButton;

    UIBarButtonItem *leftButon = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return-red"] style:UIBarButtonItemStylePlain target:nil action:nil];
    [leftButon setTarget:self];
    self.navigationItem.leftBarButtonItem = leftButon;
    self.navigationController.navigationBar.tintColor = orange_color;//原色;
    self.navigationItem.leftBarButtonItem.customView.frame = CGRectMake(0, 0, 100, 50);
    [self.navigationItem.leftBarButtonItem setAction:@selector(tapLeftButton:)];
}

-(void)tapLeftButton:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightClick2
{
    if (self.type == 3) {
        MyLog(@"这是分享的3333333");//V头条
        NSLog_JSON(@"33333_0:::%@",_shareUrl);
        NSLog_JSON(@"33333_1:::%@",_urlStr);//有,html

        [self thirdShareWithUrl:[NSString stringWithFormat:@"%@",_shareUrl]];
    }else{
        MyLog(@"这是分享的4444444");
        NSLog(@"44444url_0::%@",_urlStr);
//        NSLog(@"Type:%ld",_type);// =4

        [self thirdShareWithUrl:[NSString stringWithFormat:@"%@",_urlStr]];
    }
}
#pragma mark 三方分享调用
-(void)thirdShareWithUrl:(NSString * )url
{
    UIWindow*window=[UIApplication sharedApplication].keyWindow;
    UIView*blackView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    self.blackView=blackView;
    blackView.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.3];
    [window addSubview:blackView];
    UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clcikClose)];
    [blackView addGestureRecognizer:tap];
    ShareBtnView*shareView=[[ShareBtnView alloc]init];
    shareView.delegate = self;
    __block VLXWebViewVC * blockSelf=self;;
    shareView.btnShareBlock=^(NSInteger tag)
    {
        NSString *titleStr;
        NSString *contentStr;
        if(!_contentStrs == nil){
            contentStr = _contentStrs;
        }else{
            contentStr = _currentTitle;
        }
//        contentStr = _contentStrs;
        if (self.type == 3) {
        if ([NSString checkForNull:_Vmodel.headname]) {
          titleStr = @"V旅行";
        }else{
            titleStr = _Vmodel.headname;
        }
        }
        else if (self.type == 4){
            titleStr = _adTitle;
        }

//           contentStr = @"看世界、V旅行！";
        MyLog(@"share:%ld",tag);
        //555,QQ 556,新浪微博 557,微信 558,朋友圈
        switch (tag) {
            case 555:
            {
                [ShareTool shareWebPageToPlatformType:UMSocialPlatformType_QQ andThumbURL:@"http://img3.2345.com/toolsimg/baike/collect/sheying/73b2150ajw1e6wsbsp5lbj20hs0hs3zs.jpg" andTitle:titleStr andDesc:contentStr andWebPageUrl:url];
                [blockSelf clcikClose];
                
            }
                break;
            case 556:
            {

                [ShareTool shareWebPageToPlatformType:UMSocialPlatformType_Sina andThumbURL:@"http://img3.2345.com/toolsimg/baike/collect/sheying/73b2150ajw1e6wsbsp5lbj20hs0hs3zs.jpg" andTitle:titleStr andDesc:contentStr andWebPageUrl:url];
                [blockSelf clcikClose];
            }
                break;
            case 557:
            {
                [ShareTool shareWebPageToPlatformType:UMSocialPlatformType_WechatSession andThumbURL:@"http://img3.2345.com/toolsimg/baike/collect/sheying/73b2150ajw1e6wsbsp5lbj20hs0hs3zs.jpg" andTitle:titleStr andDesc:contentStr andWebPageUrl:url];
                [blockSelf clcikClose];
            }
                break;
            case 558:
            {
                [ShareTool shareWebPageToPlatformType:UMSocialPlatformType_WechatTimeLine andThumbURL:@"http://img3.2345.com/toolsimg/baike/collect/sheying/73b2150ajw1e6wsbsp5lbj20hs0hs3zs.jpg" andTitle:titleStr andDesc:contentStr andWebPageUrl:url];
                [blockSelf clcikClose];
            }
                break;
            default:
                break;
        }
    };
    [window addSubview:shareView];
    self.shareView=shareView;
    
}
#pragma mark--点击关闭按钮
-(void)clcikClose
{
    [self.shareView removeFromSuperview];
    [self .blackView removeFromSuperview];
}
#pragma mark---wkwebview delegate
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
//    [SVProgressHUD showWithStatus:@"正在加载"];
    NSLog(@"start");
}
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    NSLog(@"finish");
    [SVProgressHUD dismiss];
}
-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    NSLog(@"fail");
    [SVProgressHUD dismiss];
}

#pragma mark
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
