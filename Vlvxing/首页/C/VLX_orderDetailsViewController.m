//
//  VLX_orderDetailsViewController.m
//  Vlvxing
//
//  Created by grm on 2017/10/16.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLX_orderDetailsViewController.h"//订单详情 ////--------------已作废

#import <QuartzCore/QuartzCore.h>
//////////////////////////////////统一主色调 rgba(230, 87, 36, 1)

@interface VLX_orderDetailsViewController ()


@property (nonatomic,strong)UIImageView * imgvw1;
@property (nonatomic,strong)UIImageView * imgvw2;

//@property (nonatomic,strong)UIL

@property (nonatomic,strong)UILabel * HeadLb1;
@property (nonatomic,strong)UILabel * HeadLb2;
@property (nonatomic,assign)NSInteger tags;

@property (nonatomic,strong)UIView * bigVw1;//下部分大背景
@property (nonatomic,strong)UIView * bigVw2;
//一堆控件
@property (nonatomic,strong)UIImageView * HeadImgvw;
@property (nonatomic,strong)UILabel * NameLb;
@property (nonatomic,strong)UILabel * dateLb;
@property (nonatomic,strong)UILabel * starLb;
@property (nonatomic,strong)UIImageView * jiantouVw;//箭头

@property (nonatomic,strong)UILabel * DateLb;
@property (nonatomic,strong)UILabel * flyAreaLb;
@property (nonatomic,strong)UILabel * flyTimeLb;
@property (nonatomic,strong)UILabel * downAreaLb;
@property (nonatomic,strong)UILabel * downTimeLb;

@property (nonatomic,strong)UILabel * hangbanNoLb;//航班号
@property (nonatomic,strong)UILabel * classLb;////座舱级别(经济舱)
@property (nonatomic,strong)UILabel * typeLb;//成人票
@property (nonatomic,strong)UILabel * jiageLb;

@property (nonatomic,strong)UILabel * isDoneLb;//已支付
@property (nonatomic,strong)UILabel * jichangLb;//机场接送

@property (nonatomic,strong)UIButton * changeBt;//改签按钮


@property (nonatomic,strong)UIImageView * HeadImgvw2;
@property (nonatomic,strong)UILabel * NameLb2;
@property (nonatomic,strong)UILabel * dateLb2;
@property (nonatomic,strong)UILabel * starLb2;

@property (nonatomic,strong)UIImageView * jiantouVw2;//箭头


@property (nonatomic,strong)UILabel * DateLb2;
@property (nonatomic,strong)UILabel * flyAreaLb2;
@property (nonatomic,strong)UILabel * flyTimeLb2;
@property (nonatomic,strong)UILabel * downAreaLb2;
@property (nonatomic,strong)UILabel * downTimeLb2;

@property (nonatomic,strong)UILabel * hangbanNoLb2;//航班号
@property (nonatomic,strong)UILabel * classLb2;////座舱级别(经济舱)
@property (nonatomic,strong)UILabel * typeLb2;//成人票
@property (nonatomic,strong)UILabel * jiageLb2;//价格
@property (nonatomic,strong)UILabel * isDoneLb2;//已支付

@property (nonatomic,strong)UILabel * ID_messageLb;//旅客证件
@property (nonatomic,strong)UILabel * ID_cardNoLb;//证号码
@property (nonatomic,strong)UILabel * ID_cardType;//证类型
@property (nonatomic,strong)UIButton * returnTicketBt;//退票按钮

@property (nonatomic,strong)UIView * popBackGroundVw1;
@property (nonatomic,strong)UIView * popBackGroundVw2;

@end

@implementation VLX_orderDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //左边按钮
//    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    leftBtn.frame = CGRectMake(0, 0, 20, 20);
//    [leftBtn setImage:[UIImage imageNamed:@"return-red"] forState:UIControlStateNormal];
//    [leftBtn addTarget:self action:@selector(tapLeftButton4) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
//    self.navigationItem.leftBarButtonItem = leftBarButton;

    UIBarButtonItem *leftButon = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return-red"] style:UIBarButtonItemStylePlain target:nil action:nil];
    [leftButon setTarget:self];
    self.navigationItem.leftBarButtonItem = leftButon;
    self.navigationController.navigationBar.tintColor = orange_color;//原色;
    self.navigationItem.leftBarButtonItem.customView.frame = CGRectMake(0, 0, 100, 50);
    [self.navigationItem.leftBarButtonItem setAction:@selector(tapLeftButton4)];

    _tags = 1;//默认的显示第一个 '改签'
    self.title = @"订单详情";
    
    self.view.backgroundColor = rgba(235, 235, 235, 1);
//    [self makeHeadUI];
    [self makeMineUI];
    
}
-(void)tapLeftButton4
{
    [self.navigationController popViewControllerAnimated:YES];
}

//废了
-(void)makeHeadUI
{

    _imgvw1 = [[UIImageView alloc]initWithFrame:CGRectMake(8, 18, (ScreenWidth-16)/2, 40)];
    _imgvw1.backgroundColor = rgba(230, 87, 36, 1);
    
    _imgvw1.userInteractionEnabled = YES;
    /*
     * UIRectCornerTopLeft//左上
     * UIRectCornerTopRight//右上
     * UIRectCornerBottomLeft左下
     * UIRectCornerBottomRight//右下
     * UIRectCornerAllCorners

     */
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_imgvw1.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(20, 20)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = _imgvw1.bounds;
    maskLayer.path = maskPath.CGPath;
    _imgvw1.layer.mask = maskLayer;
    
    CALayer * layer1=[_imgvw1 layer];
    [layer1 setMasksToBounds:YES];     //是否设置边框以及是否可见
//    [layer1 setBorderWidth:0.5];       //设置边框线的宽
//    [layer1 setBorderColor:[[UIColor lightGrayColor] CGColor]];   //设置边
    
    UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pressimg1)];
    [_imgvw1 addGestureRecognizer:tap1];
    
    
    _imgvw2 = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth/2, 18, (ScreenWidth-16)/2, 40)];
    _imgvw2.userInteractionEnabled = YES;

    _imgvw2.backgroundColor = [UIColor whiteColor];
    UIBezierPath *maskPath2 = [UIBezierPath bezierPathWithRoundedRect:_imgvw2.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(20, 20)];
    CAShapeLayer *maskLayer2 = [[CAShapeLayer alloc] init];
    maskLayer2.frame = _imgvw2.bounds;
    maskLayer2.path = maskPath2.CGPath;
    _imgvw2.layer.mask = maskLayer2;
  
    CALayer * layer2=[_imgvw2 layer];
    [layer2 setMasksToBounds:YES];
//    _imgvw2.clipsToBounds = YES;
//是否设置边框以及是否可见
//    [layer2 setBorderWidth:0.5];       //设置边框线的宽
//    [layer2 setBorderColor:[[UIColor lightGrayColor] CGColor]];   //设置边
    UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pressimg2)];
    [_imgvw2 addGestureRecognizer:tap2];
    
    
    
    _HeadLb1 = [[UILabel alloc]initWithFrame:CGRectMake(_imgvw1.frame.size.width/2 - 10, 9, 40, 20)];
    _HeadLb1.text = @"改签";
    _HeadLb1.textColor = [UIColor whiteColor];
    
    _HeadLb2 = [[UILabel alloc]initWithFrame:CGRectMake(_imgvw1.frame.size.width/2 - 10, 9, 40, 20)];
    _HeadLb2.text = @"退票";
    _HeadLb2.textColor = rgba(230, 87, 36, 1);
    

    
    
    
    [_imgvw1 addSubview:_HeadLb1];
    [_imgvw2 addSubview:_HeadLb2];

    
    [self.view addSubview:_imgvw1];
    [self.view addSubview:_imgvw2];

    
    
}

-(void)pressimg1
{
    _tags = 1;
    
    _HeadLb1.textColor = [UIColor whiteColor];
    _imgvw1.backgroundColor = rgba(230, 87, 36, 1);
    
    _HeadLb2.textColor = rgba(230, 87, 36, 1);
    _imgvw2.backgroundColor = [UIColor whiteColor];
    
    _bigVw1.hidden = NO;
    _bigVw2.hidden = YES;
    
}
-(void)pressimg2
{
    _tags = 2;
    
    _HeadLb1.textColor = rgba(230, 87, 36, 1);
    _imgvw1.backgroundColor = [UIColor whiteColor];
    
    _HeadLb2.textColor = [UIColor whiteColor];
    _imgvw2.backgroundColor = rgba(230, 87, 36, 1);
    
    
    _bigVw1.hidden = YES;
    _bigVw2.hidden = NO;
}
-(void)makeMineUI
{
    
    _bigVw1 = [[UIView alloc]initWithFrame:CGRectMake(0, 190/2, ScreenWidth, 360)];
    _bigVw1.backgroundColor = rgba(235, 235, 235, 1);

    
    _HeadImgvw = [[UIImageView alloc]initWithFrame:CGRectMake(10, 13, 22, 22)];
    _HeadImgvw.image = [UIImage imageNamed:@""];
    
    _NameLb = [[UILabel alloc]initWithFrame:CGRectMake(35, 13, 150, 22)];
    _NameLb.text = @"海南时候回或uhb";
    _NameLb.textColor= [UIColor grayColor];
    
    _dateLb = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-136, 13, 90, 22)];
    _dateLb.text = @"2017-10-10";
    _dateLb.textColor= [UIColor grayColor];
    
    UILabel * line =[[ UILabel alloc]initWithFrame:CGRectMake(0, 50,ScreenWidth, 0.5)];
    
    line.backgroundColor = [UIColor lightGrayColor];
    
    _starLb = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-44, 13+5, 90, 16)];
    _starLb.text = @"周四";
    _starLb.font = [UIFont systemFontOfSize:12];
    _starLb.textColor= [UIColor grayColor];
    
    //一堆控件11111
    _DateLb = [[UILabel alloc]initWithFrame:CGRectMake(12, 89, 66, 22)];
    _DateLb.text = @"2017-10-10";
    _DateLb.font = [UIFont systemFontOfSize:12];
    _DateLb.textColor= [UIColor grayColor];
    
    _flyAreaLb = [[UILabel alloc]init];
    _flyAreaLb.text = @"北京首都机场";
    _flyAreaLb.font = [UIFont systemFontOfSize:12];
    _flyAreaLb.textColor= [UIColor grayColor];
    // 设置Label的字体 HelveticaNeue  Courier
    UIFont *font1 = [UIFont fontWithName:@"Courier New" size:12.0f];
    _flyAreaLb.font = font1;
    // 根据字体得到NSString的尺寸
    CGSize size1 = [_flyAreaLb.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font1,NSFontAttributeName,nil]];
    // 名字的W
    CGFloat nameW = size1.width;
    _flyAreaLb.frame = CGRectMake(80,89, nameW,22);
    
    
    
    
    
    
    _flyTimeLb = [[UILabel alloc]init];
    _flyTimeLb.text = @"10:36";
    _flyTimeLb.font = [UIFont systemFontOfSize:12];
    _flyTimeLb.textColor= rgba(229, 112, 66, 1);
    UIFont *font2 = [UIFont fontWithName:@"Courier New" size:12.0f];
    _flyTimeLb.font = font2;
    CGSize size2 = [_flyTimeLb.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font2,NSFontAttributeName,nil]];
    CGFloat nameW2 = size2.width;
    _flyTimeLb.frame = CGRectMake(80 + _flyAreaLb.frame.size.width+1,89, nameW2,22);
    
    
    
    
    _jiantouVw = [[UIImageView alloc]initWithFrame:CGRectMake(80 + _flyAreaLb.frame.size.width+1 + _flyTimeLb.frame.size.width +1, 90, 35, 15)];
    _jiantouVw.image = [UIImage imageNamed:@"目的地"];
    
    
    
    //目的地.png
    _downAreaLb = [[UILabel alloc]init];
    _downAreaLb.text = @"深圳";
    _downAreaLb.font = [UIFont systemFontOfSize:12];
    _downAreaLb.textColor= [UIColor grayColor];
    UIFont *font3 = [UIFont fontWithName:@"Courier New" size:12.0f];
    _downAreaLb.font = font3;
    CGSize size3 = [_downAreaLb.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font3,NSFontAttributeName,nil]];
    CGFloat nameW3 = size3.width;
    _downAreaLb.frame = CGRectMake(80 + _flyAreaLb.frame.size.width+1 + _flyTimeLb.frame.size.width +1+1+35,89, nameW3,22);

    
    
    
    _downTimeLb = [[UILabel alloc]initWithFrame:CGRectMake(282, 89, 40, 22)];
    _downTimeLb.text = @"12:37";
    _downTimeLb.font = [UIFont systemFontOfSize:12];
    _downTimeLb.textColor= rgba(229, 112, 66, 1);
    UIFont *font4 = [UIFont fontWithName:@"Courier New" size:12.0f];
    _downTimeLb.font = font4;
    CGSize size4 = [_downTimeLb.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font4,NSFontAttributeName,nil]];
    CGFloat nameW4 = size4.width;
    _downTimeLb.frame = CGRectMake(80 + _flyAreaLb.frame.size.width+1 + _flyTimeLb.frame.size.width +1+1+35 +_downAreaLb.frame.size.width+1,89, nameW4,22);
    
    
    
    //
    _hangbanNoLb = [[UILabel alloc]initWithFrame:CGRectMake(18, 164, (ScreenWidth-18)/4, 22)];
    _hangbanNoLb.text = @"DEGD31";
    _hangbanNoLb.font = [UIFont systemFontOfSize:16];
    _hangbanNoLb.textColor= [UIColor grayColor];
    
    _classLb = [[UILabel alloc]initWithFrame:CGRectMake(18+(ScreenWidth-18)/4, 164, (ScreenWidth-18)/4, 22)];
    _classLb.text = @"经济舱";
    _classLb.font = [UIFont systemFontOfSize:16];
    _classLb.textColor= [UIColor grayColor];
    
    _typeLb = [[UILabel alloc]initWithFrame:CGRectMake(18+(ScreenWidth-18)/4*2, 164, (ScreenWidth-18)/4, 22)];
    _typeLb.text = @"成人票";
    _typeLb.font = [UIFont systemFontOfSize:16];
    _typeLb.textColor= [UIColor grayColor];
    
    _jiageLb = [[UILabel alloc]initWithFrame:CGRectMake(18+(ScreenWidth-18)/4*3, 164, (ScreenWidth-18)/4, 22)];
    _jiageLb.text = @"¥998";
    _jiageLb.font = [UIFont systemFontOfSize:16];
    _jiageLb.textColor = rgba(229, 112, 66, 1);
    
    
    _isDoneLb = [[UILabel alloc]initWithFrame:CGRectMake(18, 458/2, 200, 22)];
    _isDoneLb.text = @"机票状态:已支付";
    _isDoneLb.textColor = rgba(229, 112, 66, 1);
    
    _jichangLb = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth - 95, 530/2, 100, 22)];
    _jichangLb.text = @"机场接送 >";
    _jichangLb.font = [UIFont systemFontOfSize:16];
    _jichangLb.textColor = [UIColor grayColor];
    
    _changeBt = [[UIButton alloc]initWithFrame:CGRectMake(40, 622/2, ScreenWidth-80, 38)];
    _changeBt.backgroundColor = rgba(229, 112, 66, 1);
    [_changeBt setTitle:@"改签(一张)" forState:UIControlStateNormal];
    [_changeBt addTarget:self action:@selector(pop1) forControlEvents:UIControlEventTouchUpInside];
    _changeBt.layer.cornerRadius = 6.0;
    
    
    [_bigVw1 addSubview:_HeadImgvw];
    [_bigVw1 addSubview:_NameLb];
    [_bigVw1 addSubview:_dateLb];
    [_bigVw1 addSubview:_starLb];
    [_bigVw1 addSubview:line];
    
    [_bigVw1 addSubview:_DateLb];
    [_bigVw1 addSubview:_flyAreaLb];
    [_bigVw1 addSubview:_flyTimeLb];
    [_bigVw1 addSubview:_jiantouVw];
    [_bigVw1 addSubview:_downAreaLb];
    [_bigVw1 addSubview:_downTimeLb];
    
    [_bigVw1 addSubview:_hangbanNoLb];
    [_bigVw1 addSubview:_classLb];
    [_bigVw1 addSubview:_typeLb];
    [_bigVw1 addSubview:_jiageLb];
    
    [_bigVw1 addSubview:_isDoneLb];
    [_bigVw1 addSubview:_jichangLb];
    [_bigVw1 addSubview:_changeBt];
    

//
    _bigVw2 = [[UIView alloc]initWithFrame:CGRectMake(0, 178/2, ScreenWidth, 400)];
    _bigVw2.backgroundColor =rgba(235, 235, 235, 1);
    
    
    
    
    _HeadImgvw2 = [[UIImageView alloc]initWithFrame:CGRectMake(10, 13, 22, 22)];
    _HeadImgvw2.image = [UIImage imageNamed:@""];
    
    _NameLb2 = [[UILabel alloc]initWithFrame:CGRectMake(35, 13, 150, 22)];
    _NameLb2.text = @"海南时候回或uhb";
    _NameLb2.textColor= [UIColor grayColor];
    
    _dateLb2 = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-136, 13, 90, 22)];
    _dateLb2.text = @"2017-10-10";
    _dateLb2.textColor= [UIColor grayColor];
    
    UILabel * line2 =[[ UILabel alloc]initWithFrame:CGRectMake(0, 50,ScreenWidth, 0.5)];
    
    line2.backgroundColor = [UIColor lightGrayColor];
    
    _starLb2 = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-44, 13+5, 90, 16)];
    _starLb2.text = @"周四";
    _starLb2.font = [UIFont systemFontOfSize:12];
    _starLb2.textColor= [UIColor grayColor];
    
    _DateLb2 = [[UILabel alloc]initWithFrame:CGRectMake(12, 89, 66, 22)];
    _DateLb2.text = @"2017-10-10";
    _DateLb2.font = [UIFont systemFontOfSize:12];
    _DateLb2.textColor= [UIColor grayColor];
    
    _flyAreaLb2 = [[UILabel alloc]initWithFrame:CGRectMake(80, 89, 80, 22)];
    _flyAreaLb2.text = @"北京首都机场";
    _flyAreaLb2.font = [UIFont systemFontOfSize:12];
    _flyAreaLb2.textColor= [UIColor grayColor];
    
    _flyTimeLb2 = [[UILabel alloc]initWithFrame:CGRectMake(161, 89, 40, 22)];
    _flyTimeLb2.text = @"10:36";
    _flyTimeLb2.font = [UIFont systemFontOfSize:12];
    _flyTimeLb2.textColor= rgba(229, 112, 66, 1);
    
    _jiantouVw2 = [[UIImageView alloc]initWithFrame:CGRectMake(200, 90, 40, 15)];
    _jiantouVw2.image = [UIImage imageNamed:@"目的地"];
    
    _downAreaLb2 = [[UILabel alloc]initWithFrame:CGRectMake(241, 89, 40, 22)];//*(ScreenWidth/375)
    _downAreaLb2.text = @"深圳";
    _downAreaLb2.font = [UIFont systemFontOfSize:12];
    _downAreaLb2.textColor= [UIColor grayColor];
    
    _downTimeLb2 = [[UILabel alloc]initWithFrame:CGRectMake(282, 89, 40, 22)];
    _downTimeLb2.text = @"12:37";
    _downTimeLb2.font = [UIFont systemFontOfSize:12];
    _downTimeLb2.textColor= rgba(229, 112, 66, 1);
    
    //
    _hangbanNoLb2 = [[UILabel alloc]initWithFrame:CGRectMake(18, 164, (ScreenWidth-18)/4, 22)];
    _hangbanNoLb2.text = @"DEGD31";
    _hangbanNoLb2.font = [UIFont systemFontOfSize:16];
    _hangbanNoLb2.textColor= [UIColor grayColor];
    
    _classLb2 = [[UILabel alloc]initWithFrame:CGRectMake(18+(ScreenWidth-18)/4, 164, (ScreenWidth-18)/4, 22)];
    _classLb2.text = @"经济舱";
    _classLb2.font = [UIFont systemFontOfSize:16];
    _classLb2.textColor= [UIColor grayColor];
    
    _typeLb2 = [[UILabel alloc]initWithFrame:CGRectMake(18+(ScreenWidth-18)/4*2, 164, (ScreenWidth-18)/4, 22)];
    _typeLb2.text = @"成人票";
    _typeLb2.font = [UIFont systemFontOfSize:16];
    _typeLb2.textColor= [UIColor grayColor];
    
    _jiageLb2 = [[UILabel alloc]initWithFrame:CGRectMake(18+(ScreenWidth-18)/4*3, 164, (ScreenWidth-18)/4, 22)];
    _jiageLb2.text = @"¥998";
    _jiageLb2.font = [UIFont systemFontOfSize:16];
    _jiageLb2.textColor = rgba(229, 112, 66, 1);
    
    _ID_messageLb = [[UILabel alloc]initWithFrame:CGRectMake(5, 456/2, 70, 22)];
    _ID_messageLb.text = @"旅客信息:";
    _ID_messageLb.font = [UIFont systemFontOfSize:14];
    _ID_messageLb.textColor= [UIColor grayColor];
    
    _ID_cardNoLb = [[UILabel alloc]initWithFrame:CGRectMake(76, 456/2, 183, 22)];
    _ID_cardNoLb.text = @"4123456789012345678";
    _ID_cardNoLb.font = [UIFont systemFontOfSize:14];
//    _ID_cardNoLb.textAlignment = NSTextAlignmentCenter;
    _ID_cardNoLb.textColor= [UIColor grayColor];
   
    _ID_cardType = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-78, 456/2, 75, 22)];
    _ID_cardType.text = @"二代身份证";
    _ID_cardType.font = [UIFont systemFontOfSize:14];
    _ID_cardType.textColor= [UIColor grayColor];
    
    _isDoneLb2 = [[UILabel alloc]initWithFrame:CGRectMake(18, 570/2, 200, 22)];
    _isDoneLb2.text = @"机票状态:已支付";
    _isDoneLb2.textColor = rgba(229, 112, 66, 1);

    _returnTicketBt = [[UIButton alloc]initWithFrame:CGRectMake(40, 700/2, ScreenWidth-80, 38)];
    _returnTicketBt.backgroundColor = rgba(229, 112, 66, 1);
    [_returnTicketBt setTitle:@"退票(一张)" forState:UIControlStateNormal];
    [_returnTicketBt addTarget:self action:@selector(pop2) forControlEvents:UIControlEventTouchUpInside];
    _returnTicketBt.layer.cornerRadius = 6.0;

    
    
    
    [_bigVw2 addSubview:_HeadImgvw2];
    [_bigVw2 addSubview:_NameLb2];
    [_bigVw2 addSubview:_dateLb2];
    [_bigVw2 addSubview:_starLb2];
    [_bigVw2 addSubview:line2];

    [_bigVw2 addSubview:_DateLb2];
    [_bigVw2 addSubview:_flyAreaLb2];
    [_bigVw2 addSubview:_flyTimeLb2];
    [_bigVw2 addSubview:_jiantouVw2];
    [_bigVw2 addSubview:_downAreaLb2];
    [_bigVw2 addSubview:_downTimeLb2];
    
    [_bigVw2 addSubview:_hangbanNoLb2];
    [_bigVw2 addSubview:_classLb2];
    [_bigVw2 addSubview:_typeLb2];
    [_bigVw2 addSubview:_jiageLb2];
    
    [_bigVw2 addSubview:_ID_messageLb];
    [_bigVw2 addSubview:_ID_cardNoLb];
    [_bigVw2 addSubview:_ID_cardType];
    [_bigVw2 addSubview:_isDoneLb2];
    
    [_bigVw2 addSubview:_returnTicketBt];
    
    
    
    
    
    
    
    [self.view addSubview:_bigVw1];
    [self.view addSubview:_bigVw2];
    
    _bigVw2.hidden = YES;


}
-(void)pop1
{
    
        _popBackGroundVw2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _popBackGroundVw2.backgroundColor =rgba(112, 112, 112, 0.5);
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeView)];
    [_popBackGroundVw2 addGestureRecognizer:tap];
    
    
    UIView * popVw2 = [[UIView alloc]initWithFrame:CGRectMake(10, 129, ScreenWidth-20, 294)];
    popVw2.backgroundColor = [UIColor whiteColor];
    
    
    UILabel * returnLb = [[UILabel alloc]initWithFrame:CGRectMake(10, 18, 75, 22)];
    returnLb.text = @"改签信息:";
    returnLb.font = [UIFont systemFontOfSize:16];
    returnLb.textColor= [UIColor grayColor];
    
    UILabel * shouxufeiLb = [[UILabel alloc]initWithFrame:CGRectMake(20, 44, ScreenWidth / 2 -30, 22)];
    shouxufeiLb.text = @"改签费¥14元";
    shouxufeiLb.textAlignment = NSTextAlignmentRight;
    shouxufeiLb.textColor= [UIColor grayColor];
    // 创建Attributed
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:shouxufeiLb.text];
    // 需要改变的第一个文字的位置
    NSUInteger firstLoc = [[noteStr string] rangeOfString:@"费"].location + 1;
    // 需要改变的最后一个文字的位置
    NSUInteger secondLoc = [[noteStr string] rangeOfString:@"元"].location;
    // 需要改变的区间
    NSRange range = NSMakeRange(firstLoc, secondLoc - firstLoc);
    // 改变颜色
    [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
    // 改变字体大小及类型
    [noteStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"AppleGothic" size:14] range:range];
    // 为label添加Attributed
    [shouxufeiLb setAttributedText:noteStr];
    
    
    
    UILabel * yingtuikuanLb = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth / 2 + 10, 44, ScreenWidth / 2 -30, 22)];
    yingtuikuanLb.text = @"实际付款¥634元";
    yingtuikuanLb.textAlignment = NSTextAlignmentLeft;
    yingtuikuanLb.textColor= [UIColor grayColor];
    // 创建Attributed
    NSMutableAttributedString *noteStr2 = [[NSMutableAttributedString alloc] initWithString:yingtuikuanLb.text];
    // 需要改变的第一个文字的位置
    NSUInteger firstLoc2 = [[noteStr2 string] rangeOfString:@"款"].location + 1;
    // 需要改变的最后一个文字的位置
    NSUInteger secondLoc2 = [[noteStr2 string] rangeOfString:@"元"].location;
    // 需要改变的区间
    NSRange range2 = NSMakeRange(firstLoc2, secondLoc2 - firstLoc2);
    // 改变颜色
    [noteStr2 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range2];
    // 改变字体大小及类型
    [noteStr2 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"AppleGothic" size:14] range:range2];
    // 为label添加Attributed
    [yingtuikuanLb setAttributedText:noteStr2];

    
    UITextView * txvw = [[UITextView alloc]initWithFrame:CGRectMake(7, 75, popVw2.frame.size.width-14, 258/2)];
    txvw.backgroundColor = [UIColor lightGrayColor];
    txvw.editable = NO;
    txvw.selectable = NO; //不能选择
    txvw.text = @"温馨提示:";
    
    
    UIButton * reBt = [[UIButton alloc]initWithFrame:CGRectMake(85, 454/2, ScreenWidth-170, 38)];
    reBt.backgroundColor = rgba(229, 112, 66, 1);
    [reBt setTitle:@"确定改签" forState:UIControlStateNormal];
    [reBt addTarget:self action:@selector(press_ChangeBt) forControlEvents:UIControlEventTouchUpInside];
    reBt.layer.cornerRadius = 6.0;
    
    
    
    [popVw2 addSubview:returnLb];
    [popVw2 addSubview:shouxufeiLb];
    [popVw2 addSubview:yingtuikuanLb];
    [popVw2 addSubview:txvw];
    [popVw2 addSubview:reBt];
    
    [_popBackGroundVw2 addSubview:popVw2];
    
    [self.view addSubview:_popBackGroundVw2];
    
    
}
-(void)pop2
{
    _popBackGroundVw1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _popBackGroundVw1.backgroundColor =rgba(112, 112, 112, 0.8);
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeView)];
    [_popBackGroundVw1 addGestureRecognizer:tap];
    
    UIView * popVw1 = [[UIView alloc]initWithFrame:CGRectMake(10, 129, ScreenWidth-20, 294)];
    popVw1.backgroundColor = [UIColor whiteColor];
    
    
   UILabel * returnLb = [[UILabel alloc]initWithFrame:CGRectMake(10, 18, 75, 22)];
    returnLb.text = @"退款信息:";
    returnLb.font = [UIFont systemFontOfSize:16];
    returnLb.textColor= [UIColor grayColor];
    
    UILabel * shouxufeiLb = [[UILabel alloc]initWithFrame:CGRectMake(20, 44, ScreenWidth / 2 -30, 22)];
    shouxufeiLb.text = @"退款费¥34元";
    shouxufeiLb.textAlignment = NSTextAlignmentRight;
    shouxufeiLb.textColor= [UIColor grayColor];
    // 创建Attributed
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:shouxufeiLb.text];
    // 需要改变的第一个文字的位置
    NSUInteger firstLoc = [[noteStr string] rangeOfString:@"费"].location + 1;
    // 需要改变的最后一个文字的位置
    NSUInteger secondLoc = [[noteStr string] rangeOfString:@"元"].location;
    // 需要改变的区间
    NSRange range = NSMakeRange(firstLoc, secondLoc - firstLoc);
    // 改变颜色
    [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
    // 改变字体大小及类型
    [noteStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"AppleGothic" size:14] range:range];
    // 为label添加Attributed
    [shouxufeiLb setAttributedText:noteStr];
    
    
    UILabel * yingtuikuanLb = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth / 2 + 10, 44, ScreenWidth / 2 -30, 22)];
    yingtuikuanLb.text = @"应退款¥234元";
    yingtuikuanLb.textAlignment = NSTextAlignmentLeft;
    yingtuikuanLb.textColor= [UIColor grayColor];
    // 创建Attributed
    NSMutableAttributedString *noteStr2 = [[NSMutableAttributedString alloc] initWithString:yingtuikuanLb.text];
    // 需要改变的第一个文字的位置
    NSUInteger firstLoc2 = [[noteStr2 string] rangeOfString:@"款"].location + 1;
    // 需要改变的最后一个文字的位置
    NSUInteger secondLoc2 = [[noteStr2 string] rangeOfString:@"元"].location;
    // 需要改变的区间
    NSRange range2 = NSMakeRange(firstLoc2, secondLoc2 - firstLoc2);
    // 改变颜色
    [noteStr2 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range2];
    // 改变字体大小及类型
    [noteStr2 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"AppleGothic" size:14] range:range2];
    // 为label添加Attributed
    [yingtuikuanLb setAttributedText:noteStr2];
    
    
    UITextView * txvw = [[UITextView alloc]initWithFrame:CGRectMake(7, 75, popVw1.frame.size.width-14, 258/2)];
    txvw.backgroundColor = [UIColor lightGrayColor];
    txvw.editable = NO;
    txvw.selectable = NO; //不能选择
    txvw.text = @"温馨提示:";
    
    
    UIButton * reBt = [[UIButton alloc]initWithFrame:CGRectMake(85, 454/2, ScreenWidth-170, 38)];
    reBt.backgroundColor = rgba(229, 112, 66, 1);
    [reBt setTitle:@"确定退票" forState:UIControlStateNormal];
    [reBt addTarget:self action:@selector(press_reBt) forControlEvents:UIControlEventTouchUpInside];
    reBt.layer.cornerRadius = 6.0;

    
    
    [popVw1 addSubview:returnLb];
    [popVw1 addSubview:shouxufeiLb];
    [popVw1 addSubview:yingtuikuanLb];
    [popVw1 addSubview:txvw];
    [popVw1 addSubview:reBt];
    
    [_popBackGroundVw1 addSubview:popVw1];
    
    [self.view addSubview:_popBackGroundVw1];
}
-(void)removeView{
    [_popBackGroundVw1 removeFromSuperview];
    [_popBackGroundVw2 removeFromSuperview];
    
}
-(void)press_reBt
{
    NSLog(@"退票");//OK
}
-(void)press_ChangeBt
{
    NSLog(@"改签");//OK
}

@end
