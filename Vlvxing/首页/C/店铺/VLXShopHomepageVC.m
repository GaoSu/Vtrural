//
//  VLXShopHomepageVC.m
//  Vlvxing
//
//  Created by Michael on 17/5/25.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXShopHomepageVC.h"
#import <WebKit/WebKit.h>
#import "VLXShopDetailModel.h"
#import "ShareBtnView.h"
@interface VLXShopHomepageVC ()<UIWebViewDelegate,ShareBtnViewDelegate>
@property(nonatomic,strong)UIScrollView * scrollview;
@property(nonatomic,strong)UIWebView * webview;
@property(nonatomic,strong) UIView * headview;
@property (nonatomic,strong)VLXShopDetailModel *shopModel;
//
@property (nonatomic,strong)UIImageView *iconImageView;
@property (nonatomic,strong)UILabel *titleLab;
@property (nonatomic,strong)UILabel *detailLab;
@property(nonatomic,weak)UIView * blackView;
@property(nonatomic,weak)ShareBtnView*shareView;
//
@end

@implementation VLXShopHomepageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self loadData];
//    [self.webview.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];

}
#pragma mark---数据
-(void)loadData
{
    [SVProgressHUD showWithStatus:@"正在加载"];
    NSMutableDictionary * dic=[NSMutableDictionary dictionary];
    
    dic[@"businessId"]=[ZYYCustomTool checkNullWithNSString:_businessId];//商家id
    NSString * url=[NSString stringWithFormat:@"%@/BusBusinessController/ getBusBusinessDetail.json",ftpPath];
    NSLog(@"%@",dic);
    [SPHttpWithYYCache postRequestUrlStr:url withDic:dic success:^(NSDictionary *requestDic, NSString *msg) {
        [SVProgressHUD dismiss];
        NSLog(@"%@",requestDic.mj_JSONString);
        _shopModel=[[VLXShopDetailModel alloc] initWithDictionary:requestDic error:nil];
        if (_shopModel.status.integerValue==1) {
            [self changeUI];
        }else
        {
            [SVProgressHUD showErrorWithStatus:msg];
        }
        
    } failure:^(NSString *errorInfo) {
        [SVProgressHUD dismiss];
        
    }];
}
-(void)changeUI
{
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:[ZYYCustomTool checkNullWithNSString:_shopModel.data.businesspic]] placeholderImage:[UIImage imageNamed:@"banner-tiantan"]];
    _titleLab.text=[ZYYCustomTool checkNullWithNSString:_shopModel.data.businessname];
    CGFloat height = [_shopModel.data.businessname sizeWithFont:[UIFont systemFontOfSize:18] maxSize:CGSizeMake(SCREEN_WIDTH-155, MAXFLOAT)].height;
//    rect.size.height = height;
//    _titleLab.frame = rect;
 
    if (height>18) {
        [_titleLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(height);
        }];
    }
   
    
    CGRect rectTwo = _detailLab.frame;
    rectTwo.origin.y = CGRectGetMaxY(_titleLab.frame)+10;
    CGFloat heightTwo = [_shopModel.data.descraption sizeWithFont:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(SCREEN_WIDTH-155, MAXFLOAT)].height;
    if (heightTwo>30) {
        [_detailLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(heightTwo);
        }];
        
    }
//    _detailLab.frame = rectTwo;
    
    _detailLab.text=[ZYYCustomTool checkNullWithNSString:_shopModel.data.descraption];
    
    if (height>18 && heightTwo > 30) {
        self.headview.frame = CGRectMake(0, 0, ScreenWidth, 50+height+heightTwo);
    }else{
        self.headview.frame = CGRectMake(0, 0, ScreenWidth, 113);
    }
    
    
    
    // 更改webview的位置
    CGRect webViewF = self.webview.frame;
    webViewF.origin.y = CGRectGetMaxY(self.headview.frame)+8;
    self.webview.frame = webViewF;
    
    //
    NSMutableString * string = [NSMutableString string];
    
    for(VLXShopDetailProjectModel *model in _shopModel.data.projects){
        [string appendString:[ZYYCustomTool checkNullWithNSString:model.descraption]];
        
    }
    NSLog(@"------%@",string);
    NSString *urlStr = [NSString stringWithFormat:@"%@",string];
    urlStr = [self setImageStr:urlStr];
    NSString *scriptStr =[NSString stringWithFormat:@"<script> var imgs = document.getElementsByName(\"cellImage\");var width = %f;for(var i=0;i<imgs.length;i++){var img = imgs[i];var iWidth = img.offsetWidth;var iHeight = img.offsetHeight;var height = iHeight * width / iWidth;img.style.width = width + 'px';img.style.height = height + 'px';} </script>",ScreenSize.width-8];
    urlStr = [NSString stringWithFormat:@"%@ %@",urlStr,scriptStr];
    
    
    [self.webview loadHTMLString:urlStr baseURL:nil];
//    [_webview loadHTMLString:[ZYYCustomTool checkNullWithNSString:string] baseURL:nil];
}

-(NSString *)setImageStr:(NSString *)urlStr{
    
    NSArray *textArray = [urlStr componentsSeparatedByString:@"<img"];
    NSMutableArray *newArray = [NSMutableArray array];
    for(int i=0;i<textArray.count;i++){
        NSString *str = textArray[i];
        
        if ([str isEqualToString:@""]) {
            continue;
        }
        
        str=[NSString stringWithFormat:@"<img name='cellImage'%@",str];
        [newArray addObject:str];
    }
    
    return [newArray componentsJoinedByString:@" "];
}


#pragma mark
//- (void)dealloc {
//    [self.webview.scrollView removeObserver:self forKeyPath:@"contentSize" context:nil];
//}
//- (void)observeValueForKeyPath:(NSString *)keyPath
//                      ofObject:(id)object
//                        change:(NSDictionary *)change
//                       context:(void *)context
//{
//    if (object == self.webview.scrollView && [keyPath isEqual:@"contentSize"]) {
//        // we are here because the contentSize of the WebView's scrollview changed.
//
//        UIScrollView *scrollView = self.webview.scrollView;
//        NSLog(@"New contentSize: %f x %f", scrollView.contentSize.width, scrollView.contentSize.height);
//        self.scrollview.contentSize=CGSizeMake(ScreenWidth, scrollView.contentSize.height+119);
//        self.webview.size=CGSizeMake(ScreenWidth, scrollView.contentSize.height);
//    }
//}
-(void)createUI
{
    [self setNav];
    [self createScrollView];
    [self createHead];
}
#pragma mark 创建scrollview
-(void)createScrollView
{
    self.scrollview=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];
    self.scrollview.backgroundColor=[UIColor hexStringToColor:@"f3f3f4"];
    self.scrollview.contentSize=CGSizeMake(ScreenWidth, ScreenHeight+64);
    _scrollview.showsVerticalScrollIndicator=NO;
    _scrollview.showsHorizontalScrollIndicator=NO;
    [self.view addSubview:self.scrollview];


}

-(void)createHead
{
  self.headview =[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 113)];
    self.headview.backgroundColor=[UIColor whiteColor];
    [self.scrollview addSubview:self.headview];


//创建左边的图片
    UIImageView * leftimageview=[[UIImageView alloc]initWithFrame:CGRectMake(ScaleWidth(13), ScaleHeight(17), 100, 80)];
//    leftimageview.image=[UIImage imageNamed:@"banner-tiantan"];
    [self.headview addSubview:leftimageview];
    _iconImageView=leftimageview;
    
    ///打电话的button
    UIButton * phoneBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.headview addSubview:phoneBtn];
    [phoneBtn setImage:[UIImage imageNamed:@"call-blue"] forState:UIControlStateNormal];
    [phoneBtn addTarget:self action:@selector(makePhone) forControlEvents:UIControlEventTouchUpInside];
    [phoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-ScaleWidth(12));
        make.top.mas_equalTo(ScaleHeight(14.5));
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];
    
    //众信旅游 title
    UILabel * toplabel=[UILabel new];
//    toplabel.text=@"众信旅游";
    toplabel.textColor=[UIColor hexStringToColor:@"111111"];
    toplabel.numberOfLines = 0;
    toplabel.font=[UIFont fontWithName:@"PingFang-SC-Bold" size:18];
    [self.headview addSubview:toplabel];
    [toplabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(leftimageview.mas_right).mas_offset(ScaleWidth(11));
        make.top.mas_equalTo(ScaleHeight(15.5));
        make.height.mas_equalTo(18);
        make.right.mas_equalTo(phoneBtn.mas_left).mas_offset(-15);
    }];
    _titleLab=toplabel;

//公司介绍详情
    UILabel * detailLabel=[UILabel new];
//    detailLabel.text=@"公司成立于1980年12月5日，是实力至强，美誉度至高的旅行社，国内唯一获得“中国用户满意鼎”的综合性强社";
    detailLabel.textColor=[UIColor hexStringToColor:@"313131"];
    detailLabel.font=[UIFont fontWithName:@"PingFang-SC-Medium" size:12];
    detailLabel.lineBreakMode=YES;
    detailLabel.numberOfLines=0;
    [self.headview addSubview:detailLabel];
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.mas_equalTo(leftimageview.mas_right).mas_offset(ScaleWidth(11));
        make.right.mas_equalTo(ScaleWidth(-44.5));
        make.top.mas_equalTo(toplabel.mas_bottom).offset(ScaleHeight(5));
//        make.bottom.mas_equalTo(-ScaleHeight(8));
        make.height.mas_equalTo(30);
    }];
    _detailLab=detailLabel;
//创建下面的Webview

    _webview=[[UIWebView alloc] initWithFrame:CGRectMake(-3, CGRectGetMaxY(self.headview.frame)+8, ScreenWidth, ScreenHeight-113-64)];
    _webview.delegate=self;

    /*
    self.webview.UIDelegate=self;
    [self.scrollview addSubview:self.webview];
//    NSURL * url=[NSURL URLWithString:@"http://www.sina.com"];
//    NSURLRequest * request=[NSURLRequest requestWithURL:url];

    WKWebViewConfiguration *config = [WKWebViewConfiguration new];
    //初始化偏好设置属性：preferences
    config.preferences = [WKPreferences new];
    //The minimum font size in points default is 0;
    config.preferences.minimumFontSize = 10;
    //是否支持JavaScript
    config.preferences.javaScriptEnabled = YES;
    //不通过用户交互，是否可以打开窗口
    config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
    self.webview=[[WKWebView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headview.frame)+8, ScreenWidth, 300)configuration:config];
//    WKWebView *webView = [[WKWebView alloc]initWithFrame:self.view.frame configuration:config];
//    [self.webview loadRequest:request];*/

    [self.scrollview addSubview:self.webview];
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{


}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    
    CGFloat sizeHeight = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] integerValue];
    
    CGFloat height = [_shopModel.data.businessname sizeWithFont:[UIFont systemFontOfSize:18] maxSize:CGSizeMake(SCREEN_WIDTH-155, MAXFLOAT)].height;
    CGFloat heightTwo = [_shopModel.data.descraption sizeWithFont:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(SCREEN_WIDTH-155, MAXFLOAT)].height;
    if (height>18 && heightTwo > 30) {
       _webview.frame=CGRectMake(-3, CGRectGetMaxY(self.headview.frame)+8, kScreenWidth, sizeHeight+30+50+height+heightTwo);
        self.scrollview.contentSize=CGSizeMake(ScreenWidth, sizeHeight+30+50+height+heightTwo);
    }else{
        _webview.frame=CGRectMake(-3, CGRectGetMaxY(self.headview.frame)+8, kScreenWidth, sizeHeight+30+113);
        self.scrollview.contentSize=CGSizeMake(ScreenWidth, sizeHeight+30+113);
    }
   
   
    
    UIScrollView *webScrollView = (UIScrollView *)[[self.webview subviews] objectAtIndex:0];
    CGSize size = webScrollView.contentSize;
    size.height = 0;
    webScrollView.contentSize = size;
    [webScrollView setBounces:NO];
    
}

#pragma mark 电话点击事件
-(void)makePhone
{
//    MyLog(@"make啊");

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",_shopModel.data.tel]]];

}

- (void)setNav{

    self.title = @"店铺主页";
    self.view.backgroundColor=[UIColor hexStringToColor:@"f3f3f4"];
    //左边按钮
//    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    leftBtn.frame = CGRectMake(0, 0, 20, 20);
//    [leftBtn setImage:[UIImage imageNamed:@"return-red"] forState:UIControlStateNormal];
//    [leftBtn addTarget:self action:@selector(tapLeftButton) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
//    self.navigationItem.leftBarButtonItem = leftBarButton;

    UIBarButtonItem *leftButon = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return-red"] style:UIBarButtonItemStylePlain target:nil action:nil];
    [leftButon setTarget:self];
    self.navigationItem.leftBarButtonItem = leftButon;
    self.navigationController.navigationBar.tintColor = orange_color;//原色;
    self.navigationItem.leftBarButtonItem.customView.frame = CGRectMake(0, 0, 100, 50);
    [self.navigationItem.leftBarButtonItem setAction:@selector(tapLeftButton)];
    //右边按钮
    UIView * rightview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 22)];
    rightview.backgroundColor=[UIColor whiteColor];

    UIImageView * rightimageview=[[UIImageView alloc]initWithFrame:CGRectMake(20, 0, 21.5, 22)];
    rightimageview.image=[UIImage imageNamed:@"share-red"];
    [rightview addSubview:rightimageview];

    UIBarButtonItem * rightBaritem=[[UIBarButtonItem alloc]initWithCustomView:rightview];
    self.navigationItem.rightBarButtonItem=rightBaritem;

    rightview.userInteractionEnabled=YES;
    UITapGestureRecognizer * rightTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rightClick)];
    [rightview addGestureRecognizer:rightTap];

}
-(void)tapLeftButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightClick
{

    MyLog(@"share");
    [self thirdShareWithUrl:[NSString stringWithFormat:@"%@/shareurl/businessinfoshare.json?businessId=%@",ftpPath,_businessId]];
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
    __block VLXShopHomepageVC * blockSelf=self;;
    shareView.btnShareBlock=^(NSInteger tag)
    {
        NSString *titleStr;
        NSString *contentStr;
        if ([NSString checkForNull:_shopModel.data.businessname]) {
           titleStr = @"旅行";
        }else{
            titleStr = _shopModel.data.businessname;
        }
        
        if ([NSString checkForNull:_shopModel.data.descraption]) {
           contentStr = @"看世界、V旅行！";
        }else{
            contentStr =_shopModel.data.descraption;
        }
        
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
