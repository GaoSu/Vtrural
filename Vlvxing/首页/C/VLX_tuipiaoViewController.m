//
//  VLX_tuipiaoViewController.m
//  Vlvxing
//
//  Created by grm on 2017/11/13.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLX_tuipiaoViewController.h"

#import "VLX_tuipiao_OK_VC.h"


@interface VLX_tuipiaoViewController ()

@end

@implementation VLX_tuipiaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //左边按钮
//    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    leftBtn.frame = CGRectMake(0, 0, 20, 20);
//    [leftBtn setImage:[UIImage imageNamed:@"return-red"] forState:UIControlStateNormal];
//    [leftBtn addTarget:self action:@selector(tapLeftButton52) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
//    self.navigationItem.leftBarButtonItem = leftBarButton;

    UIBarButtonItem *leftButon = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return-red"] style:UIBarButtonItemStylePlain target:nil action:nil];
    [leftButon setTarget:self];
    self.navigationItem.leftBarButtonItem = leftButon;
    self.navigationController.navigationBar.tintColor = orange_color;//原色;
    self.navigationItem.leftBarButtonItem.customView.frame = CGRectMake(0, 0, 100, 50);
    [self.navigationItem.leftBarButtonItem setAction:@selector(tapLeftButton52)];

    self.title = @"退票";
    
    self.view.backgroundColor = rgba(245, 245, 245, 1);
    [self makeMineUI52];
    
}
-(void)tapLeftButton52
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)makeMineUI52{
 
    //一,scvw
    UIScrollView * scrView = [[UIScrollView alloc]init];
    scrView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-64);
    scrView.contentSize = CGSizeMake(0, ScreenHeight-64+10+57*_chengkexinxiAry1.count);
    scrView.showsHorizontalScrollIndicator = NO;
    scrView.showsVerticalScrollIndicator = NO;
    
    UIView * view1  = [[UIView alloc]initWithFrame:CGRectMake(0, 5, ScreenWidth, 185)];
    view1.backgroundColor = [UIColor whiteColor];

    UILabel * hangbanLb = [[UILabel alloc]initWithFrame:CGRectMake(8, 8, 95, 16)];
    hangbanLb.text = _hangbanNoStr1;//@"UFO-x007";
    hangbanLb.textColor =[UIColor lightGrayColor];
    hangbanLb.font = [UIFont systemFontOfSize:15];

    UILabel * datexingqi = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-10-165, 8, 165, 16)];
    datexingqi.text = [NSString stringWithFormat:@"%@%@",_flyDatesStr1,_xingqijiStr1];//@"2017-12-31星期五";
    datexingqi.textAlignment = NSTextAlignmentRight;
    datexingqi.textColor =[UIColor lightGrayColor];
    datexingqi.font = [UIFont systemFontOfSize:15];
    

    UILabel * _areaLb1 = [[UILabel alloc]initWithFrame:CGRectMake(8, 55, 100, 23)];
    _areaLb1.text = _flyCityStr1;//黑龙江
    UIFont *font1 = [UIFont fontWithName:@"Verdana-Bold" size:20.0f];
    _areaLb1.font = font1;
    
        UILabel * _time1 = [[UILabel alloc]initWithFrame:CGRectMake(8+3+66, 64, 100, 14)];
    _time1.text = _flyTimeStr1;
    _time1.textColor = rgba(230, 87, 36, 1);
    _time1.font = [UIFont systemFontOfSize:14];
    
    //zongshichang1//

    
    UILabel * zongshichangLb = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/2 - 50, 52, 100, 5)];
    zongshichangLb.text = _zongshichang1;
    zongshichangLb.textColor = [UIColor lightGrayColor];;
    zongshichangLb.textAlignment = NSTextAlignmentCenter;
    zongshichangLb.font = [UIFont systemFontOfSize:14];
    //箭头
    UIImageView * imgvw = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth/2 - 50, 52+15, 100, 5)];
    imgvw.image = [UIImage imageNamed:@"ios—去往—大grm.psd"];
    
    
    
    UILabel * _areaLb2 = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-122, 55, 100, 23)];
    _areaLb2.text = _downCityStr1;//@"长白山";
    UIFont *font2 = [UIFont fontWithName:@"Verdana-Bold" size:20.0f];
    _areaLb2.font = font2;
    
    UILabel * _time2 = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-50, 64, 100, 14)];
    _time2.text = _downTimeStr1;
    _time2.textColor = rgba(230, 87, 36, 1);
    _time2.font = [UIFont systemFontOfSize:14];
    
    
    for (int i=0; i<_chengkexinxiAry1.count; i++) {
        
 
    UIView * backgrdView = [[UIView alloc]initWithFrame:CGRectMake(0, 92, ScreenWidth, 57)];
    backgrdView.backgroundColor = [UIColor whiteColor];
    //小头像
    UIImageView * imgvw2 = [[UIImageView alloc]initWithFrame:CGRectMake(10, 20, 14, 15)];
    imgvw2.image = [UIImage imageNamed:@"ios—我的"];
    
    UILabel * nameLb = [[UILabel alloc]initWithFrame:CGRectMake(26, 20, 60, 15)];
        nameLb.text = _chengkexinxiAry1[i][@"name"];//_Name_Str1;//@"张三";
    nameLb.font = [UIFont systemFontOfSize:14];
    
    UILabel * id_cardLb = [[UILabel alloc]initWithFrame:CGRectMake(98, 20, 88, 15)];
    id_cardLb.text = @"二代身份证";
    id_cardLb.font = [UIFont systemFontOfSize:14];
    
    UILabel * typeLb = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-160, 20, 52, 15)];
    typeLb.text = @"成人票";
    typeLb.font = [UIFont systemFontOfSize:14];
    
    UILabel * jiageLb = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-109, 18, 104, 23)];
    jiageLb.text = [NSString stringWithFormat:@"%@元",_jiageStr1];
    jiageLb.textColor = rgba(230, 87, 36, 1);
    jiageLb.font = [UIFont systemFontOfSize:21];
        
        [backgrdView addSubview:imgvw2];
        [backgrdView addSubview:nameLb];
        [backgrdView addSubview:id_cardLb];
        [backgrdView addSubview:typeLb];
        [backgrdView addSubview:jiageLb];
    }
    
    UILabel * shifouzhifuLb = [[UILabel alloc]initWithFrame:CGRectMake(10, 156+57*(_chengkexinxiAry1.count-1), 154, 15)];
    shifouzhifuLb.text = _statusdescStr1;
    shifouzhifuLb.textColor = rgba(230, 87, 36, 1);
    shifouzhifuLb.font = [UIFont systemFontOfSize:14];
    
    
    [view1 addSubview:hangbanLb];
    [view1 addSubview:datexingqi];
    [view1 addSubview:_areaLb1];
    [view1 addSubview:_time1];
    [view1 addSubview:zongshichangLb];
    [view1 addSubview:imgvw];
    [view1 addSubview:_areaLb2];
    [view1 addSubview:_time2];

    [view1 addSubview:shifouzhifuLb];

    
    
    UIButton * changeBt1 =[[ UIButton alloc]initWithFrame:CGRectMake(15, 248, ScreenWidth-30, 42)];
    changeBt1.layer.cornerRadius = 6;
    changeBt1.backgroundColor = rgba(230, 87, 36, 1);
    [changeBt1 setTitle:@"确认退票" forState:UIControlStateNormal];
    [changeBt1 addTarget:self action:@selector(presstuipiaoBt) forControlEvents:UIControlEventTouchUpInside];
    

    
    
    
    
    
    [scrView addSubview:changeBt1];
    [scrView addSubview:view1];
    
    [self.view addSubview:scrView];
}


- (void)presstuipiaoBt{
    
    VLX_tuipiao_OK_VC * okVC = [[VLX_tuipiao_OK_VC alloc]init];
    okVC.orderno1 = _orderno1;
//    okVC.passengeridArray = [NSMutableArray array];
//    okVC.passengeridArray = _passengeridArray;

    [self.navigationController pushViewController:okVC animated:YES];


}



@end
