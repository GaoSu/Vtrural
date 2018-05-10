
//
//  VLXAboutUSVC.m
//  Vlvxing
//
//  Created by Michael on 17/5/22.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXAboutUSVC.h"

@interface VLXAboutUSVC ()<UIWebViewDelegate>
@property(nonatomic,strong)NSDictionary * dataDic;
@property(nonatomic,strong) UILabel * qiyeLabel;
@property(nonatomic,strong)UILabel * phonelabel;
@property(nonatomic,strong)UILabel * sublabel;
@property(nonatomic,strong) UIWebView *webView;
@property(nonatomic,assign) CGFloat webHeight;
@property(nonatomic,strong) UILabel *bigLabel;
@property(nonatomic,strong) UIView *midView;
@property(nonatomic,strong) UIView *bottomView;
@property(nonatomic,strong) UIScrollView *backScroll;


@end

@implementation VLXAboutUSVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self getNetWork];
}
-(void)createUI
{
    [self setNav];
    [self createHead];
    [self createMidview];
    [self createBottom];

}

-(void)getNetWork
{
    [SVProgressHUD showWithStatus:@"加载中..."];

    NSDictionary * dic=@{@"token":[NSString getDefaultToken]};
    NSString * url=[NSString stringWithFormat:@"%@/SysTextController/auth/aboutUs.json",ftpPath];
    [SPHttpWithYYCache postRequestUrlStr:url withDic:dic success:^(NSDictionary *requestDic, NSString *msg) {
        if ([requestDic[@"status"] integerValue]==1) {
            [SVProgressHUD dismiss];
            self.dataDic=requestDic[@"data"];
            [self reloadThisview];
        }else
        {
            [SVProgressHUD showErrorWithStatus:msg];

        }
        MyLog(@"%@",requestDic);
    } failure:^(NSString *errorInfo) {

        [SVProgressHUD dismiss];
    }];

}


#pragma mark 获取数据后刷新主UI
-(void)reloadThisview
{
    self.qiyeLabel.text=@"V旅行"; //self.dataDic[@"companyname"];
    self.phonelabel.text=self.dataDic[@"phonenum"];
    //self.sublabel.text=self.dataDic[@"textcontext"];
    // webView加载
    NSString *url = self.dataDic[@"textcontext"];

    url = [self setImageStr:url];
    NSString *scriptStr =[NSString stringWithFormat:@"<script> var imgs = document.getElementsByName(\"cellImage\");var width = %f;for(var i=0;i<imgs.length;i++){var img = imgs[i];var iWidth = img.offsetWidth;var iHeight = img.offsetHeight;var height = iHeight * width / iWidth;img.style.width = width + 'px';img.style.height = height + 'px';} </script>",ScreenSize.width-8];
    url = [NSString stringWithFormat:@"%@ %@",url,scriptStr];
    
    
    [self.webView loadHTMLString:url baseURL:nil];
    

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

-(void)createHead
{
    self.backScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, SCREEN_HEIGHT)];
    self.backScroll.backgroundColor = [UIColor clearColor];
    self.backScroll.contentSize = CGSizeMake(ScreenWidth, 1000);
    [self.view addSubview:self.backScroll];
    UIImageView * imageview=[UIImageView new];
    imageview.image=[UIImage imageNamed:@"mylogo"];
    [self.backScroll addSubview:imageview];
    [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(ScaleHeight(15));
        make.width.mas_equalTo(72);
        make.height.mas_equalTo(72);
    }];
    //企业名称title
    self.qiyeLabel=[UILabel new];
//    self.qiyeLabel.text=@"公司名称";
    self.qiyeLabel.textColor=[UIColor hexStringToColor:@"313131"];
    self.qiyeLabel.font=[UIFont fontWithName:@"FZZZHUNHJW--GB1-0c" size:19];
    self.qiyeLabel.textAlignment=NSTextAlignmentCenter;
    [self.backScroll addSubview:self.qiyeLabel];
    [self.qiyeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(imageview.mas_bottom).mas_offset(ScaleHeight(9.5));
        make.height.mas_equalTo(19);
        make.width.mas_equalTo(ScreenWidth);
    }];

}
-(void)createMidview
{
    UIView * midvie=[[UIView alloc]initWithFrame:CGRectMake(0, ScaleHeight(166), ScreenWidth, 156)];
    midvie.backgroundColor=[UIColor whiteColor];
    self.midView = midvie;
    [self.backScroll addSubview:midvie];

    UILabel * biglabel=[[UILabel alloc]initWithFrame:CGRectMake(ScaleWidth(19.5), ScaleHeight(16), ScreenWidth/2, 16)];
    biglabel.textColor=[UIColor hexStringToColor:@"000000"];
    biglabel.text=@"企业信息";
    biglabel.font=[UIFont fontWithName:@"PingFang-SC-Medium" size:16];
    self.bigLabel = biglabel;
    [midvie addSubview:biglabel];
//详细label
    /*
    self.sublabel=[[UILabel alloc]initWithFrame:CGRectMake(ScaleWidth(19.5), CGRectGetMaxY(biglabel.frame)+ScaleHeight(8.5), 343.5, 100.5)];
    self.sublabel.textColor=[UIColor hexStringToColor:@"666666"];
//    self.sublabel.text=@"中国领先的旅游服务平台，为旅游者提供国内外机票、酒店、会场、度假和签证服务的深度搜索，帮助中国旅游者做出更好的旅行选择，可以随时随地为旅行者提供国内外机票、酒店、度假、旅游团购、及旅行信息的深度搜索。";
    self.sublabel.lineBreakMode=YES;
    self.sublabel.numberOfLines=0;
    self.sublabel.textAlignment=NSTextAlignmentLeft;
    self.sublabel.font=[UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    [midvie addSubview:self.sublabel];*/
    
    // 设置webView加载
    _webView=[[UIWebView alloc]initWithFrame:CGRectMake(ScaleWidth(19.5), CGRectGetMaxY(biglabel.frame)+ScaleHeight(8.5), ScreenWidth-10, 100.5)];
    _webView.backgroundColor = [UIColor whiteColor];
    _webView.scrollView.scrollEnabled = NO;
    _webView.delegate=self;
    [midvie addSubview:_webView];

}
-(void)createBottom
{
    UIView * bottomview=[[UIView alloc]initWithFrame:CGRectMake(0, ScaleHeight(338), ScreenWidth, 73.5)];
    bottomview.backgroundColor=[UIColor whiteColor];
    self.bottomView = bottomview;
    [self.backScroll addSubview:bottomview];

    UILabel * lianxiLabel=[[UILabel alloc]initWithFrame:CGRectMake(ScaleWidth(20), ScaleHeight(16), ScreenWidth/2, 16)];
    lianxiLabel.text=@"联系方式";
    lianxiLabel.textColor=[UIColor hexStringToColor:@"000000"];
    lianxiLabel.font=[UIFont fontWithName:@"PingFang-SC-Medium" size:16];
    [bottomview addSubview:lianxiLabel];
///电话号码
   self.phonelabel =[[UILabel alloc]initWithFrame:CGRectMake(ScaleWidth(20), CGRectGetMaxY(lianxiLabel.frame)+ScaleHeight(16), ScreenWidth/2, 14)];
//    self.phonelabel.text=@"400-1234567";
    self.phonelabel.textColor=[UIColor hexStringToColor:@"666666"];
    self.phonelabel.font=[UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    [bottomview addSubview:self.phonelabel];

}
- (void)setNav{
    self.title = @"关于我们";
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
}


#pragma  mark 代理方法点击事件

-(void)tapLeftButton
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    
    CGFloat sizeHeight = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] integerValue];
    if(self.webHeight != sizeHeight)
    {
        self.webHeight = sizeHeight;
        _webView.frame=CGRectMake(ScaleWidth(19.5), CGRectGetMaxY(self.bigLabel.frame)+ScaleHeight(8.5), kScreenWidth-ScaleWidth(19.5)-8, sizeHeight+30);
        self.midView.frame = CGRectMake(0, ScaleHeight(166), ScreenWidth, sizeHeight+30+40);
        self.bottomView.frame = CGRectMake(0, CGRectGetMaxY(self.midView.frame)+15, ScreenWidth, 73.5);
        self.backScroll.contentSize = CGSizeMake(ScreenWidth, sizeHeight+134+230);
    }
    UIScrollView *webScrollView = (UIScrollView *)[[self.webView subviews] objectAtIndex:0];
    CGSize size = webScrollView.contentSize;
    size.height = 0;
    webScrollView.contentSize = size;
    [webScrollView setBounces:NO];
    
    
    
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
