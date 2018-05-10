//
//  VLX_fujinAreaVC.m
//  Vlvxing
//
//  Created by grm on 2018/3/16.
//  Copyright © 2018年 王静雨. All rights reserved.
//

#import "VLX_fujinAreaVC.h"

@interface VLX_fujinAreaVC ()<BMKLocationServiceDelegate,BMKPoiSearchDelegate,BMKMapViewDelegate,BMKGeoCodeSearchDelegate,BMKSuggestionSearchDelegate,BMKRouteSearchDelegate,UITableViewDelegate,UITableViewDataSource>{

    float _latitude; //存储用户当前位置的经纬度
    float _longitude;

    BMKGeoCodeSearch * _geocodesearch; //地理编码对象
//    NSString * _startLocationName; //起点位置名称
    NSMutableArray * areaArray ;
}
@property (nonatomic,strong)UITableView *tableVw;

@end

@implementation VLX_fujinAreaVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.


    self.title = @"请选择您的位置";
    //获取经纬度 经度longtitude, 纬度latitude
        NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
        NSString * weidu = [NSString stringWithFormat:@"%f",[userDefaultes floatForKey:@"latitude"]];
        NSLog(@"纬度:%@",weidu);
        NSString * jingdu = [NSString stringWithFormat:@"%f",[userDefaultes floatForKey:@"longtitude"]];
        NSLog(@"经du:%@",jingdu);
    float  weidu_LA = [weidu floatValue];
    float jingdu_LO = [jingdu floatValue];

    areaArray = [NSMutableArray array];
    //根据起点经纬度,发起反地理编码,协议方法获得name
    [self ReverGeoCoderWithLatitude:weidu_LA andLongitude:jingdu_LO];

    [self navUI];
    [self mineUI];
}
-(void)navUI{
//    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    leftBtn.frame = CGRectMake(0, 0, 20, 20);
//    [leftBtn setImage:[UIImage imageNamed:@"return-red"] forState:UIControlStateNormal];
//    [leftBtn addTarget:self action:@selector(tapLeftButton1) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
//    self.navigationItem.leftBarButtonItem = leftBarButton;

    UIBarButtonItem *leftButon = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return-red"] style:UIBarButtonItemStylePlain target:nil action:nil];
    [leftButon setTarget:self];
    self.navigationItem.leftBarButtonItem = leftButon;
    self.navigationController.navigationBar.tintColor = orange_color;//原色;
    self.navigationItem.leftBarButtonItem.customView.frame = CGRectMake(0, 0, 100, 50);
    [self.navigationItem.leftBarButtonItem setAction:@selector(tapLeftButton1)];
}
-(void)mineUI{
    self.tableVw = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
    self.tableVw.delegate =self;
    self.tableVw.dataSource = self;
    //去除多余的分割线
    self.tableVw.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];

    [self.view addSubview:self.tableVw];

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return areaArray.count;
}

-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (areaArray.count > 0) {
        cell.textLabel.text = areaArray[indexPath.row];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * areaStr = areaArray[indexPath.row];


    //发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeDynamicArea" object:areaStr userInfo:@{}];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)tapLeftButton1{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)ReverGeoCoderWithLatitude:(CLLocationDegrees)latitude andLongitude:(CLLocationDegrees)longitude
{
    //实例化地理编码对象
    _geocodesearch = [[BMKGeoCodeSearch alloc]init];
    _geocodesearch.delegate = self;

    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = CLLocationCoordinate2DMake(latitude, longitude);
    BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    if(flag){
        NSLog(@"反geo检索发送成功");
    }else{
        NSLog(@"反geo检索发送失败");
    }
}

#pragma mark - 反地理编码协议方法,获得位置名称
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
//    if (error == 0) {
//        _startLocationName = result.address;
//        NSLog(@"起点名称:%@",_startLocationName);
//    }

    for(BMKPoiInfo *poiInfo in result.poiList)
    {
        NSLog(@"所有名称%@",poiInfo.address);
        [areaArray addObject:poiInfo.address];
    }
    [self.tableVw reloadData];

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
