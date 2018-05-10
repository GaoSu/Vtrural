#import "VLXFindPalaceVC.h"
#import "VLXBusinessModel.h"
#import "VLXSpotAnnotationView.h"
#import "VLXShopHomepageVC.h"// 店铺
@interface VLXFindPalaceVC ()<BMKMapViewDelegate,BMKLocationServiceDelegate>
@property(nonatomic,strong)BMKMapView * mapview;
@property(nonatomic,assign)NSInteger level;
@property(nonatomic,assign)CLLocationCoordinate2D  codinate;
@property(nonatomic,assign)NSInteger num;
@property(nonatomic,strong)BMKLocationService * locSearch;
@property (nonatomic,strong)VLXBusinessModel *businessModel;
@property (nonatomic,assign)CLLocationCoordinate2D leftTopCoord;//左上角经纬度
@property (nonatomic,assign)CLLocationCoordinate2D rightBottomCoord;//右下角经纬度
@end

@implementation VLXFindPalaceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化
    self.num=0;
    self.level=17;
    //
    [self createUI];

}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //
    [self loadData];
}
-(void)viewWillAppear:(BOOL)animated {
    [_mapview viewWillAppear];
    _mapview.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放

}

-(void)viewWillDisappear:(BOOL)animated {
    [_mapview viewWillDisappear];
    _mapview.delegate = nil; // 不用时，置nil

}
- (void)dealloc {
    if (_mapview) {
        _mapview = nil;
    }
}
#pragma mark---视图
-(void)createUI
{
    [self setNav];
    [self createMapView];
    [self createBtns];
    [self locationBtn];
    [self makelocation];
}
#pragma mark

-(void)getScreenLocation//获取屏幕四周的经纬度
{
    //当前屏幕中心点的经纬度
    CGFloat centerLongitude = self.mapview.region.center.longitude;
    CGFloat centerLatitude = self.mapview.region.center.latitude;
    //当前屏幕显示范围的经纬度
    CLLocationDegrees pointssLongitudeDelta = self.mapview.region.span.longitudeDelta;
    CLLocationDegrees pointssLatitudeDelta=self.mapview.region.span.latitudeDelta;
    //左上角
    CGFloat leftUpLong = centerLongitude - pointssLongitudeDelta/2.0;//经度
    CGFloat leftUpLati = centerLatitude + pointssLatitudeDelta/2.0;//纬度
    //记录
    _leftTopCoord.longitude=leftUpLong;
    _leftTopCoord.latitude=leftUpLati;
    //右下角
    CGFloat rightDownLong = centerLongitude + pointssLongitudeDelta/2.0;
    CGFloat rightDownLati = centerLatitude - pointssLatitudeDelta/2.0;
    //记录
    _rightBottomCoord.longitude=rightDownLong;
    _rightBottomCoord.latitude=rightDownLati;

}

#pragma mark---数据
-(void)loadData
{

    [SVProgressHUD showWithStatus:@"正在加载"];
    [self getScreenLocation];
    NSMutableDictionary * dic=[NSMutableDictionary dictionary];
    dic[@"areaId"]=[NSString getAreaID];//分类id(0:首页，1国内，2国外，3附近)
    dic[@"PathLng"]=[NSString getLongtitude];//当前位置精度
    dic[@"PathLat"]=[NSString getLatitude];//当前位置纬度
    dic[@"lng1"]=[NSString stringWithFormat:@"%f",_leftTopCoord.longitude];//手机左上角经度
    dic[@"lat1"]=[NSString stringWithFormat:@"%f",_leftTopCoord.latitude];//手机左上角纬度
    dic[@"lng2"]=[NSString stringWithFormat:@"%f",_rightBottomCoord.longitude];//手机右下角经度
    dic[@"lat2"]=[NSString stringWithFormat:@"%f",_rightBottomCoord.latitude];//手机右下角纬度

    NSString * url=[NSString stringWithFormat:@"%@/BusBusinessController/nearBusBusiness.json",ftpPath];
    NSLog(@"请求参数::%@",dic);
    [SPHttpWithYYCache postRequestUrlStr:url withDic:dic success:^(NSDictionary *requestDic, NSString *msg) {
        NSLog_JSON(@"返回OK:::%@",requestDic);
        [SVProgressHUD dismiss];
        _businessModel=[[VLXBusinessModel alloc] initWithDictionary:requestDic error:nil];
        if (_businessModel.status.integerValue==1) {
            [self createBusinessAnnotation];
        }else
        {
            [SVProgressHUD showErrorWithStatus:msg];
        }


    } failure:^(NSString *errorInfo) {
        [SVProgressHUD dismiss];

    }];
}
#pragma mark
#pragma mark---创建商家大头针
-(void)createBusinessAnnotation
{
    NSMutableArray *annotationArray=[NSMutableArray array];
    for (int i=0; i<_businessModel.data.count; i++) {
        VLXBusinessDataModel *model=_businessModel.data[i];
        //
        BMKPointAnnotation * point=[[BMKPointAnnotation alloc]init];
        CLLocationCoordinate2D code;
        code.latitude=[model.pathlat doubleValue];
        code.longitude=[model.pathlng doubleValue];
        point.coordinate=code;
        point.title=[ZYYCustomTool checkNullWithNSString:model.businessname];
        [annotationArray addObject:point];
        [self.mapview addAnnotation:point];
    }
}
#pragma mark
#pragma mark 获取定位
-(void)makelocation
{

    self.locSearch=[[BMKLocationService alloc]init];
    self.locSearch.delegate=self;
    [self.locSearch startUserLocationService];
    _mapview.showsUserLocation = YES;//显示定位图层
    _mapview.userTrackingMode=BMKUserTrackingModeFollow;
    //去掉精度圈
    BMKLocationViewDisplayParam *param=[[BMKLocationViewDisplayParam alloc] init];
    param.isAccuracyCircleShow=NO;
    [_mapview updateLocationViewWithParam:param];

}

#pragma mark 定位代理方法
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [_mapview updateLocationData:userLocation];
    //    NSLog(@"heading is:%@",userLocation.heading);
}
-(void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{

    [_mapview updateLocationData:userLocation];
    self.codinate=userLocation.location.coordinate;
    if (self.num==0) {
        [self.mapview setCenterCoordinate:userLocation.location.coordinate];
        self.num++;
    }
    self.codinate=userLocation.location.coordinate;
}



-(void)createBtns
{
    UIView * bottomView=[[UIView alloc]initWithFrame:CGRectMake(ScreenWidth-ScaleWidth(6)-38,ScaleHeight(391.5), 38, 79)];
    bottomView.backgroundColor=[UIColor whiteColor]
    ;
    //加号view
    UIView * jiahaoView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 38, 39)];
    jiahaoView.backgroundColor=[UIColor whiteColor];
    [bottomView addSubview:jiahaoView];
    //减号View
    UIView * jianhaoView=[[UIView alloc]initWithFrame:CGRectMake(0, 39, 38, 39)];
    jianhaoView.backgroundColor=[UIColor whiteColor];
    [bottomView addSubview:jianhaoView];
    [self.view addSubview:bottomView];

    UIImageView * jiahaoimageview=[UIImageView new];
    jiahaoimageview.image=[UIImage imageNamed:@"fangda"];
    [jiahaoView addSubview:jiahaoimageview];
    [jiahaoimageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(jiahaoView.mas_centerX);
        make.centerY.equalTo(jiahaoView.mas_centerY);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
    }];

    UIImageView * jianhaoimageview=[UIImageView new];
    jianhaoimageview.image=[UIImage imageNamed:@"GJ_jianhao"];
    [jianhaoView addSubview:jianhaoimageview];
    [jianhaoimageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(jianhaoView.mas_centerX);
        make.centerY.equalTo(jianhaoView.mas_centerY);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(2);
    }];

    //加号减号view添加点击手势
    UITapGestureRecognizer * addTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addClick)];
    jiahaoView.userInteractionEnabled=YES;
    [jiahaoView addGestureRecognizer:addTap];

    UITapGestureRecognizer * minusTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(minusClick)];
    jianhaoView.userInteractionEnabled=YES;
    [jianhaoView addGestureRecognizer:minusTap];

    //设置圆角
    bottomView.layer.masksToBounds=YES;
    bottomView.layer.cornerRadius=YES;
}

#pragma mark---定位Btn
-(void)locationBtn
{
    UIView * locationView=[[UIView alloc]initWithFrame:CGRectMake(ScreenWidth-ScaleWidth(6)-38, ScaleHeight(340.5), 38, 38)];
    locationView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:locationView];
    locationView.layer.masksToBounds=YES;
    locationView.layer.cornerRadius=4;

    //创建image
    UIImageView * locationImageview=[UIImageView new];
    locationImageview.image=[UIImage imageNamed:@"Navigate"];
    [locationView addSubview:locationImageview];
    [locationImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(locationView.mas_centerX);
        make.centerY.equalTo(locationView.mas_centerY);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);

    }];

    locationView.userInteractionEnabled=YES;
    UITapGestureRecognizer * locationTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(locationClick)];
    [locationView addGestureRecognizer:locationTap];



}

#pragma mark 创建百度地图
-(void)createMapView
{
    self.mapview=[[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];
    self.mapview.delegate=self;
    [self.mapview setZoomLevel:12];//self.level];
    [self.view addSubview:self.mapview];


}

#pragma mark 大头针重写方法
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        //        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;//紫色大头针
        //        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        newAnnotationView.image = [UIImage imageNamed:@"ios—定位—大"];
        return newAnnotationView;
    }
    //    return nil;

    //自定义annotation
    NSString *AnnotationViewID = @"AnimatedAnnotation";
    VLXSpotAnnotationView *annotationView = nil;
    if (annotationView == nil) {
        annotationView = [[VLXSpotAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
    }
    annotationView.titleLab.text=[annotationView.annotation title];//设置标题
    annotationView.canShowCallout=YES;
    return annotationView;
}

#pragma mark---大头针点击事件
-(void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    NSLog(@"我view%@",view);
    NSString *title=[view.annotation title];
    for (VLXBusinessDataModel *model in _businessModel.data) {
        if ([title isEqualToString:model.businessname]) {
            VLXShopHomepageVC *shopVC=[[VLXShopHomepageVC alloc] init];
            shopVC.businessId=[NSString stringWithFormat:@"%@",model.businessid];
            [self.navigationController pushViewController:shopVC animated:YES];
        }
    }

}
#pragma mark
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


#pragma mark---点击事件
-(void)addClick//放大
{
    MyLog(@"添加");

    if (self.level<21) {
        ++self.level;
        [self.mapview setZoomLevel:self.level];
    }

}

-(void)minusClick//缩小
{
    if (self.level>3) {

        --self.level;
        [self.mapview setZoomLevel:self.level];
    }

    MyLog(@"减号");

}
#pragma mark 定位location
-(void)locationClick//定位
{
    MyLog(@"定位locaton");
    self.mapview.centerCoordinate=self.codinate;
    [self.mapview setZoomLevel:self.level];
}
- (void)didReceiveMemoryWarning {[super didReceiveMemoryWarning];}
@end
