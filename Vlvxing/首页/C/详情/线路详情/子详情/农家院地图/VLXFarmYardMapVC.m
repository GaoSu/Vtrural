//
//  VLXFarmYardMapVC.m
//  Vlvxing
//
//  Created by 王静雨 on 2017/6/23.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXFarmYardMapVC.h"
#import "VLXFarmYardAnnotaionView.h"
@interface VLXFarmYardMapVC ()<BMKMapViewDelegate,BMKLocationServiceDelegate>
@property(nonatomic,assign)NSInteger level;
//@property(nonatomic,assign)NSInteger num;
@property(nonatomic,strong)BMKMapView * mapview;
@property(nonatomic,strong)BMKLocationService * locSearch;
@property(nonatomic,assign)CLLocationCoordinate2D  codinate;
@end

@implementation VLXFarmYardMapVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //初始化
//    self.num=0;
    self.level=17;
    //
    [self createUI];
}
#pragma mark---数据
-(void)planToBaiduMap
{
    if (!CLLocationCoordinate2DIsValid(self.codinate)) {
        [SVProgressHUD showInfoWithStatus:@"无法获取您的位置信息,请移动两步试试"];
        return;
    }
    BMKOpenWalkingRouteOption *opt=[[BMKOpenWalkingRouteOption alloc] init];
    opt.isSupportWeb=true;
    opt.appScheme=@"vlvxing://";
    //初始化起点节点
    BMKPlanNode *start=[[BMKPlanNode alloc] init];
    //
    CLLocationCoordinate2D coor1;
    coor1.latitude=_codinate.latitude;
    coor1.longitude=_codinate.longitude;
    start.name=@"我的位置";
    start.pt=coor1;
    opt.startPoint=start;
    //初始化终点节点
    BMKPlanNode *end=[[BMKPlanNode alloc] init];
    CLLocationCoordinate2D coor2;
    coor2.latitude=[_detailModel.data.pathlat doubleValue];
    coor2.longitude=[_detailModel.data.pathlng doubleValue];
    end.pt=coor2;
    end.name=[ZYYCustomTool checkNullWithNSString:_detailModel.data.address];
    opt.endPoint=end;
    BMKOpenErrorCode code=[BMKOpenRoute openBaiduMapWalkingRoute:opt];
    NSLog(@"%d",code);
    return;
}
#pragma mark
#pragma mark---视图
-(void)createUI
{
    [self setNav];
    [self createMapView];
    [self makelocation];
    //
    CLLocation *location=[[CLLocation alloc] initWithLatitude:[_detailModel.data.pathlat floatValue] longitude:[_detailModel.data.pathlng floatValue]] ;
    //
    [self creatPointWithLocaiton:location title:[ZYYCustomTool checkNullWithNSString:_detailModel.data.productname]];
    self.mapview.centerCoordinate=location.coordinate;
}
#pragma mark 获取定位
-(void)makelocation
{
    
    self.locSearch=[[BMKLocationService alloc]init];
    self.locSearch.delegate=self;
    [self.locSearch startUserLocationService];
    [SVProgressHUD showWithStatus:@"正在定位当前位置"];
//    _mapview.showsUserLocation = YES;//显示定位图层
//    _mapview.userTrackingMode=BMKUserTrackingModeFollow;
//    //去掉精度圈
//    BMKLocationViewDisplayParam *param=[[BMKLocationViewDisplayParam alloc] init];
//    param.isAccuracyCircleShow=NO;
//    [_mapview updateLocationViewWithParam:param];
    
}
#pragma mark 创建百度地图
-(void)createMapView
{
    self.mapview=[[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];
    self.mapview.delegate=self;
    [self.mapview setZoomLevel:self.level];
    [self.view addSubview:self.mapview];
}
/**
 *  添加一个大头针
 *
 *  @param location
 */
- (BMKPointAnnotation *)creatPointWithLocaiton:(CLLocation *)location title:(NSString *)title;
{
    BMKPointAnnotation *point = [[BMKPointAnnotation alloc] init];
    point.coordinate = location.coordinate;
    point.title = title;
    [self.mapview addAnnotation:point];
    
    return point;
}
- (void)setNav{
    
    self.title = @"发现景点";
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

-(void)tapLeftButton
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark

#pragma mark---事件
#pragma mark
#pragma mark 定位代理方法
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    
    [_mapview updateLocationData:userLocation];
    //NSLog(@"heading is %@",userLocation.heading);
}
-(void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    

    [SVProgressHUD dismiss];
    self.codinate=userLocation.location.coordinate;
}
#pragma mark 大头针重写方法

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{

    
    //自定义annotation
    NSString *AnnotationViewID = @"AnimatedAnnotation";
    VLXFarmYardAnnotaionView *annotationView = nil;
    if (annotationView == nil) {
        annotationView = [[VLXFarmYardAnnotaionView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
    }
    [annotationView createUIWithModel:_detailModel];
//    annotationView.titleLab.text=[annotationView.annotation title];//设置标题
    annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
    annotationView.annotation = annotation;
    annotationView.canShowCallout=NO;
    __block VLXFarmYardMapVC *blockSelf=self;
    annotationView.farmBlock=^()//点击去这里
    {
        NSLog(@"farmBlock");
        [blockSelf planToBaiduMap];
        
    };
    return annotationView;
}
#pragma mark---大头针点击事件
//-(void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
//{
//    NSLog(@"%@",view);
//    NSString *title=[view.annotation title];
//    for (VLXBusinessDataModel *model in _businessModel.data) {
//        if ([title isEqualToString:model.businessname]) {
//            VLXShopHomepageVC *shopVC=[[VLXShopHomepageVC alloc] init];
//            shopVC.businessId=[NSString stringWithFormat:@"%@",model.businessid];
//            [self.navigationController pushViewController:shopVC animated:YES];
//        }
//    }
//    
//}
#pragma mark
#pragma mark---delegate
#pragma mark
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
