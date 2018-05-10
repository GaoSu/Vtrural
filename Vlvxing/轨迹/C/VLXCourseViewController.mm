//
//  VLXCourseViewController.m
//  Vlvxing
//
//  Created by 王静雨 on 2017/5/18.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXCourseViewController.h"
#import "VLXCustomAlertView.h"
#import "VLXAddImageVC.h"

#import "VLXLTYearTB.h"//选择年月.郭荣明
#import "VLXMenuPopView.h"//弹出分享菜单栏
#import "ShareBtnView.h"



#import "VLXStartAnnotationView.h"//自定义起点大头针
#import "VLXEndAnnotationView.h"//自定义终点大头针
#import "VLXRecordAnnotationView.h"//事件大头针,自定义的大头针

#import "VLXCourseModel.h"
#import "VLXRecordDetailVC.h"//轨迹 详情

#import "VLXRecordImageDetailVC.h"//图片详情
#import "VLXCourseAlertView.h"
#import "VLXCourseDesVC.h"
#import "VLXRecordVideoDetailVC.h"
#import "VLXAddVideoVC.h"
#import "VLXLoginVC.h"
@interface VLXCourseViewController ()<BMKLocationServiceDelegate,BMKPoiSearchDelegate,BMKMapViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,BMKGeoCodeSearchDelegate,BMKSuggestionSearchDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,BMKRouteSearchDelegate,VLXLTYearTBDelegate,ShareBtnViewDelegate>
{
    UIImageView *_startImageView;
    UIView *_startView;
    UITextField *_searchTXT;
    NSString *_currentCity;//当前城市
}
@property (nonatomic,strong)UITableView *tableView;//
@property(nonatomic,strong) BMKMapView  * mapview;

@property(nonatomic,strong) UIView * nightView;//该死的变色1
@property(nonatomic,strong) UIImageView * nightImageview;//该死的变色2
@property(nonatomic,strong) UIView * yearView;//年份的view,点击选择

@property(nonatomic,strong) VLXLTYearTB * nianView;
@property(nonatomic,strong)UIImageView * yearImage;//年份的ImageView,点击选择
@property(nonatomic,strong) UIView * selectYear;////点击年份后的view,点击选择
@property(nonatomic,strong) UILabel * yearLabel;//点击年份后的label
@property (nonatomic,assign)BOOL isShowYear;//年份选择
@property (nonatomic,strong)VLXMenuPopView *menuView;//弹出分享菜单栏
@property (nonatomic,assign)BOOL isShowMenu;//分享 删除
@property(nonatomic,weak)UIView * blackView;
@property(nonatomic,weak)ShareBtnView *shareView;

@property(nonatomic,assign) CLLocationCoordinate2D  codinate2;//用于实时定位


@property (nonatomic,assign)CLLocationCoordinate2D leftTopCoord;//左上角经纬度
@property (nonatomic,assign)CLLocationCoordinate2D rightBottomCoord;//右下角经纬度
@property (nonatomic,strong)VLXRecordModel *recordModel;
@property(nonatomic,strong) NSMutableArray *allDataArr; // 存放所有的请求的数组数据





@property(nonatomic,assign) NSInteger level;//地图缩放级别
@property(nonatomic,strong)BMKLocationService * locService;
@property(nonatomic,assign)BOOL nightClicked;//是否夜间模式
@property(nonatomic,assign)BOOL WCClicked;//是否显示wc
@property (nonatomic,assign)BOOL isShow;//显示 隐藏 图片视频展示
@property(nonatomic,strong)BMKPoiSearch * searcher;
@property(nonatomic,strong)NSMutableArray *animationArray;//wc大头针数组
@property (nonatomic,strong)NSMutableArray *eventsArray;//事件数组(拍照或者视频)
@property (nonatomic,strong)NSMutableArray *eventsAnnotationsArray;//事件大头针数组
@property (nonatomic,assign)MapStatus mapStatus;
@property (nonatomic,strong)NSMutableArray *searchResultArray;//在线建议搜索结果数组
@property (nonatomic,strong)CLLocation *resultLocation;//搜索结果终点
/** 在线建议搜索服务 */
@property (nonatomic,strong)BMKSuggestionSearch *suggestSearcher;
/** geo搜索服务 */
@property(nonatomic,strong) BMKGeoCodeSearch *geocodesearch;
/** geo检索信息类 */
@property(nonatomic,strong)BMKGeoCodeSearchOption *geoCodeSearchOption;
/** 路线规划route搜索服务 */
@property (nonatomic,strong)BMKRouteSearch* routesearch;
/** 轨迹线 */
@property (nonatomic, strong) BMKPolyline *polyLine;
/** 位置数组 */
@property (nonatomic, strong) NSMutableArray *locationArrayM;
/** 起点大头针 */
@property (nonatomic, strong) BMKPointAnnotation *startPoint;
/** 终点大头针 */
@property (nonatomic, strong) BMKPointAnnotation *endPoint;
/** 记录当前位置 */
@property (nonatomic, strong) BMKUserLocation *userLocation;
/** 记录上一次的位置 */
@property (nonatomic, strong) CLLocation *preLocation;
/** 累计行驶距离 */
@property (nonatomic,assign) CGFloat sumDistance;
/** 轨迹名称 */
@property (nonatomic,copy)NSString *titleStr;
/** 轨迹描述 */
@property (nonatomic,copy)NSString *desStr;
/** 出发地名称 */
@property (nonatomic,copy)NSString *startLocationStr;
/** 目的地名称 */
@property (nonatomic,copy)NSString *endLocationStr;
@end

@implementation VLXCourseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"courseSingleEvents"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"courseEvents"];
    //初始化
    self.userLocation = nil;
    self.preLocation = nil;
    self.sumDistance = 0;
    _mapStatus=MapNormal;
    
    self.nightClicked=NO;
    self.WCClicked=NO;
    self.isShow=NO;
    self.level=17;
    _locationArrayM=[NSMutableArray array];//轨迹数组
    _eventsAnnotationsArray=[NSMutableArray array];//事件大头针数组
    [VLXMapTool setMapCustomStyleWithNight];//注：必须在BMKMapView对象初始化之前设置 夜间模式
    [self initGeoCodeSearch];//初始化地理编码服务
    [self initSuccessSearch];//初始化在线建议查询服务
    [self initRouteSearch];//初始化路线规划服务
    //
    [self createUI];
    [self.mapview setZoomLevel:self.level];
}
-(void)viewWillAppear:(BOOL)animated {
    [_mapview viewWillAppear];
    
    _mapview.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locService.delegate = self;
    if (_mapStatus==MapTrailStart) {//如果是开始录制
        //        [_eventsAnnotationsArray removeAllObjects];//清除数组
        // 移除之前拍的标注点
        NSArray* array = [NSArray arrayWithArray:_mapview.annotations];
        [_mapview removeAnnotations:array];
        [_eventsAnnotationsArray removeAllObjects];
        //事件数组(拍照或者视频)  轨迹
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        _eventsArray=[NSMutableArray arrayWithArray:[defaults objectForKey:@"courseEvents"]];//
        //        NSLog(@"%@",_eventsArray);
        if (_eventsArray&&_eventsArray.count>0) {
            VLXCourseModel *model=[NSKeyedUnarchiver unarchiveObjectWithData:_eventsArray.lastObject];
            CLLocation *location=[[CLLocation alloc] initWithLatitude:[model.lat floatValue] longitude:[model.lng floatValue]];
            BMKPointAnnotation *eventAnnotation= [self creatPointWithLocaiton:location title:model.pathName];
            
//            VLXRecordAnnotationView * eventTation = [[VLXRecordAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"abcID"];
            
            
            [_eventsAnnotationsArray addObject:eventAnnotation];//将大头针添加到事件大头针数组中
        }
    }else if (_mapStatus==MapSingleEvent)//单独拍照或者视频
    {
        // 移除之前拍的标注点
        NSArray* array = [NSArray arrayWithArray:_mapview.annotations];
        [_mapview removeAnnotations:array];
        [_eventsAnnotationsArray removeAllObjects];
        //事件数组(拍照或者视频)  单个事件
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        _eventsArray=[NSMutableArray arrayWithArray:[defaults objectForKey:@"courseSingleEvents"]];//
        //        NSLog(@"%@",_eventsArray);
        if (_eventsArray&&_eventsArray.count>0) {
            VLXCourseModel *model=[NSKeyedUnarchiver unarchiveObjectWithData:_eventsArray.lastObject];
            CLLocation *location=[[CLLocation alloc] initWithLatitude:[model.lat floatValue] longitude:[model.lng floatValue]];
            BMKPointAnnotation *eventAnnotation= [self creatPointWithLocaiton:location title:model.pathName];
            [_eventsAnnotationsArray addObject:eventAnnotation];//将大头针添加到事件大头针数组中
        }
    }
    
    
    
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [_mapview viewWillDisappear];
//        _mapview.delegate = nil; // 不用时，置nil//这两句代码打开了就会导致大头针不刷新,显示的时候,会没有图片和文字,只有背景色,
//        _locService.delegate = nil;
    
    //    _searcher.delegate = nil;
    //    _suggestSearcher.delegate = nil;
    //    _routesearch.delegate = nil; // 不用时，置nil
    
}
- (void)dealloc {
    if (_mapview) {
        _mapview = nil;
    }
    
}
#pragma mark---数据
#pragma mark---重置地图和相关数据
-(void)resetMapView
{
    _mapStatus=MapNormal;
    //清空事件大头针数组 清除轨迹线 清空wc
    [_animationArray removeAllObjects];
    [_locationArrayM removeAllObjects];
    [_eventsArray removeAllObjects];
    [_eventsAnnotationsArray removeAllObjects];
    //清除所有标注点和轨迹线
    NSArray* array = [NSArray arrayWithArray:_mapview.annotations];
    [_mapview removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapview.overlays];
    [_mapview removeOverlays:array];
}
#pragma mark 创建搜索
-(void)initRouteSearch
{
    _routesearch = [[BMKRouteSearch alloc]init];
    _routesearch.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}
/**
 *  初始化在线建议搜索服务
 */
-(void)initSuccessSearch
{
    //初始化检索对象
    _suggestSearcher =[[BMKSuggestionSearch alloc]init];
    _suggestSearcher.delegate = self;
    
}
/**
 *  初始化geo搜索服务
 */
- (void)initGeoCodeSearch{
    self.geocodesearch = [[BMKGeoCodeSearch alloc]init];
    self.geocodesearch.delegate=self;
    self.geoCodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
}
-(void)startGeocode:(NSString *)keyWord
{
    _geoCodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
    _geoCodeSearchOption.city= [ZYYCustomTool checkNullWithNSString:_currentCity];
    _geoCodeSearchOption.address = [ZYYCustomTool checkNullWithNSString:keyWord];
    BOOL flag = [_geocodesearch geoCode:_geoCodeSearchOption];
    if(flag)
    {
        [SVProgressHUD showWithStatus:@"正在查询位置"];
        NSLog(@"geo检索发送成功");
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"查询位置发送失败,请重新选择"];
        NSLog(@"geo检索发送失败");
    }
}
/**
 *  开始反geo搜索服务
 */
-(void)startReverseGeocode:(CLLocationCoordinate2D)pt
{
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = pt;
    BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    if(flag){
        
        [SVProgressHUD showWithStatus:@"正在搜索当前地址"];
        MyLog(@"反geo检索发送成功");
    }else{
        
        [SVProgressHUD showErrorWithStatus:@"当前地址获取失败,请重新标注"];
        MyLog(@"反geo检索发送失败");
    }
}
-(void)makeSearch//搜索附近wc
{
    _searcher =[[BMKPoiSearch alloc]init];
    _searcher.delegate = self;
    //发起检索
    BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc]init];
    option.pageIndex = 1;
    option.pageCapacity = 10;
    option.location =_userLocation.location.coordinate;
    option.keyword = @"厕所";
    BOOL flag = [_searcher poiSearchNearBy:option];
    if(flag)
    {
        [SVProgressHUD showWithStatus:@"正在搜索"];
        NSLog(@"周边检索发送成功");
    }
    else
    {
        NSLog(@"周边检索发送失败");
    }
}
/**
 *  坐标点随机抽希
 */
- (void)deleteMoreLocationPoint{
    if (self.locationArrayM.count > 500) {
        int index = arc4random() % self.locationArrayM.count;
        if (index == 0 || index == self.locationArrayM.count - 1) {
            [self deleteMoreLocationPoint];
        }else{
            [self.locationArrayM removeObjectAtIndex:index];
            [self deleteMoreLocationPoint];
        }
    }
}


-(void)loadDataWithRoute//保存轨迹
{
    [SVProgressHUD showWithStatus:@"正在保存"];
    NSMutableDictionary * dic=[NSMutableDictionary dictionary];
    
    dic[@"token"]=[NSString getDefaultToken];//
    dic[@"travelRoadTitle"]=[ZYYCustomTool checkNullWithNSString:_titleStr];//轨迹名称
    dic[@"description"]=[ZYYCustomTool checkNullWithNSString:_desStr];//轨迹描述
    dic[@"coordinate"]=[VLXMapTool changeLocationToStr:_locationArrayM];//行程路径：格式："lng#lat-lng#lat-lng#lat-lng#lat"(lng经度，lat纬度)
    dic[@"startArea"]=[ZYYCustomTool checkNullWithNSString:_startLocationStr];//出发地名称
    dic[@"destination"]=[ZYYCustomTool checkNullWithNSString:_endLocationStr];//终点名称
    dic[@"jsonPath"]=[VLXMapTool changeEventArrayToJsonStr:_eventsArray];//途中点 1 lng：经度  2 lat：纬度 3 picUrl：图片url,4. videoUrl：视频url ，5 time：标注点保存时间 6 pathName ：途中点名称 7. address  ：地图获取的地点名称  8coverUrl:视频截图地址 json格式传
    
    
    NSString * url=[NSString stringWithFormat:@"%@/TraRoadController/auth/saveTravelRoad.html",ftpPath];
    NSLog(@"%@",dic);
    [SPHttpWithYYCache postRequestUrlStr:url withDic:dic success:^(NSDictionary *requestDic, NSString *msg) {
        [SVProgressHUD dismiss];
        if ([requestDic[@"status"] integerValue]==1) {
            [SVProgressHUD showSuccessWithStatus:@"运动保存成功"];
            //清空数组
            [_locationArrayM removeAllObjects];//清除轨迹数组
            NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
            [defaults removeObjectForKey:@"courseEvents"];//清除事件数组
        }else
        {
            [SVProgressHUD showErrorWithStatus:msg];
        }
        
    } failure:^(NSString *errorInfo) {
        [SVProgressHUD dismiss];
        
    }];
}
#pragma mark---视图
/**
 *  绘制轨迹路线
 */
- (void)drawWalkPolyline
{
    //超过500点抽希
    [self deleteMoreLocationPoint];
    //轨迹点
    NSUInteger count = self.locationArrayM.count;
    
    // 手动分配存储空间，结构体：地理坐标点，用直角地理坐标表示 X：横坐标 Y：纵坐标
    
    BMKMapPoint *tempPoints = new BMKMapPoint[count];
    
    
    [self.locationArrayM enumerateObjectsUsingBlock:^(CLLocation *location, NSUInteger idx, BOOL *stop) {
        BMKMapPoint locationPoint = BMKMapPointForCoordinate(location.coordinate);
        tempPoints[idx] = locationPoint;
        //        MyLog(@"idx = %ld,tempPoints X = %f Y = %f",idx,tempPoints[idx].x,tempPoints[idx].y);
        
    }];
    
    //移除原有的绘图
    if (self.polyLine) {
        [self.mapview removeOverlay:self.polyLine];
    }
    
    // 通过points构建BMKPolyline
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_SERIAL, 0), ^{
        self.polyLine = [BMKPolyline polylineWithPoints:tempPoints count:count];
        dispatch_async(dispatch_get_main_queue(), ^{
            //添加路线,绘图
            if (self.polyLine) {
                [self.mapview addOverlay:self.polyLine];
            }
            
            // 清空 tempPoints 内存
            
            delete []tempPoints;
            
        });
    });
    [self mapViewFitPolyLine:self.polyLine];
}

-(void)createUI
{
    //设置地图样式的路径
    self.view.backgroundColor=[UIColor whiteColor];
    BMKMapView * mapview  =[[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth,ScreenHeight-64-49)];
    [self.view addSubview:mapview];
    //    mapview.mapType = BMKMapTypeStandard;
    
    self.mapview.zoomEnabledWithTap=YES;
    self.mapview=mapview;
    
    [self createNav];
    [self createlocation];
    [self createBtns];
    [self locationBtn];
    [self createThreeBtns];
    [self bottomThreeBtns];
    [self createSearchTableView];
    
    [self createYearView1];
    
}
#pragma mark---创建搜索地区列表
-(void)createSearchTableView
{
    _tableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.showsHorizontalScrollIndicator=NO;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor=[UIColor clearColor];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    [self.view addSubview:_tableView];
    //
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCellID"];
    //
    _tableView.hidden=YES;
}
#pragma mark---tableview delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _searchResultArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"UITableViewCellID" forIndexPath:indexPath];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    //    VLXSearchKeyWordDataModel *model=_keywordModel.data[indexPath.row];
    cell.textLabel.text=[ZYYCustomTool checkNullWithNSString:_searchResultArray[indexPath.row]];
    cell.textLabel.font=[UIFont systemFontOfSize:16];
    cell.textLabel.textColor=[UIColor hexStringToColor:@"#313131"];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_searchTXT resignFirstResponder];
    [self startGeocode:_searchResultArray[indexPath.row]];//进行正向地理编码
    _searchTXT.text=_searchResultArray[indexPath.row];
    tableView.hidden=YES;
    NSLog(@"%ld",indexPath.row);
}
#pragma mark 创建定位视图
-(void)createlocation
{
    _locService=[[BMKLocationService alloc]init];
    _locService.desiredAccuracy=kCLLocationAccuracyBest;//定位精度最高
    _locService.delegate=self;
    [_locService startUserLocationService];
    //
    _mapview.showsUserLocation = YES;//显示定位图层
    _mapview.userTrackingMode=BMKUserTrackingModeFollow;
    //去掉精度圈
    BMKLocationViewDisplayParam *param=[[BMKLocationViewDisplayParam alloc] init];
    param.isAccuracyCircleShow=NO;
    [_mapview updateLocationViewWithParam:param];
    //
    [[CCLocationManager shareLocation] getCity:^(NSString *addressString) {
        _currentCity=addressString;
    }];
    
    
}
-(void)createNav
{
    //    CGFloat leftHeight=14;
    //中间
    UIView *titleView=[[UIView alloc] initWithFrame:CGRectMake(0, 7, ScaleWidth(240), 44-7*2)];
    titleView.layer.cornerRadius=4;
    titleView.layer.masksToBounds=YES;
    titleView.layer.borderColor=orange_color.CGColor;
    titleView.layer.borderWidth=1;
    self.navigationItem.titleView=titleView;
    UIImageView *search=[[UIImageView alloc] initWithFrame:CGRectMake(11, (30-17)/2, 17, 17)];
    [search setImage:[UIImage imageNamed:@"search"]];
    [titleView addSubview:search];
    //
    _searchTXT=[[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(search.frame)+6, 0, titleView.frame.size.width-CGRectGetMaxX(search.frame)-6, CGRectGetHeight(titleView.frame))];
    _searchTXT.borderStyle=UITextBorderStyleNone;
    _searchTXT.placeholder=@"搜索地区";
    _searchTXT.font=[UIFont systemFontOfSize:14];
    [titleView addSubview:_searchTXT];
    [_searchTXT addTarget:self action:@selector(textfieldDidClick) forControlEvents:UIControlEventAllEditingEvents];
    //
    
    
    
    UILabel * rightlabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 57, 14)];
    rightlabel.text=@"路程规划";
    rightlabel.textColor=orange_color;
    rightlabel.font=[UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    UIBarButtonItem * rightItem=[[UIBarButtonItem alloc]initWithCustomView:rightlabel];
    self.navigationItem.rightBarButtonItem=rightItem;
    //添加手势
    rightlabel.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToRoutePlan:)];
    [rightlabel addGestureRecognizer:tap];
    
    
}
#pragma mark---textfield 监听
-(void)textfieldDidClick
{
    
    if ([_searchTXT.text isEqualToString:@""]||_searchTXT.text==NULL) {
        _tableView.hidden=YES;
        return;
        
    }else
    {
        //        MyLog(@"有变化了");
        NSLog(@"%@",_searchTXT.text);
        BMKSuggestionSearchOption* option = [[BMKSuggestionSearchOption alloc] init];
        
        option.cityname = [ZYYCustomTool checkNullWithNSString:_currentCity];
        option.keyword  = [ZYYCustomTool checkNullWithNSString:_searchTXT.text];
        BOOL flag = [_suggestSearcher suggestionSearch:option];
        if(flag)
        {
            [SVProgressHUD showWithStatus:@"正在搜索"];
            NSLog(@"建议检索发送成功");
        }
        else
        {
            NSLog(@"建议检索发送失败");
        }
        _tableView.hidden=NO;
        
    }
    
}
#pragma mark 创建右边那些Btn
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


//定位Btn
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

//创建三个Btns
-(void)createThreeBtns
{
    //创建厕所的view
    UIView * WCView=[[UIView alloc]initWithFrame:CGRectMake(ScreenWidth-ScaleWidth(6)-38, ScaleHeight(198.5), 38, 38)];
    WCView.backgroundColor=[UIColor whiteColor];
    WCView.layer.cornerRadius=4;
    WCView.layer.masksToBounds=YES;
    [self.view addSubview:WCView];
    
    
    //    创建image
    UIImageView * WCImageview=[UIImageView new];
    WCImageview.image=[UIImage imageNamed:@"WC"];
    [WCView addSubview:WCImageview];
    [WCImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(WCView.mas_centerX);
        make.centerY.equalTo(WCView.mas_centerY);
        make.width.mas_equalTo(23.5);
        make.height.mas_equalTo(11);
        
    }];
    
    
    //创建夜间模式
    
    _nightView=[[UIView alloc]initWithFrame:CGRectMake(ScreenWidth-ScaleWidth(6)-38, ScaleHeight(150.5), 38, 38)];
    _nightView.backgroundColor=[UIColor whiteColor];
    _nightView.layer.cornerRadius=4;
    _nightView.layer.masksToBounds=YES;
    [self.view addSubview:_nightView];
    
    //夜间模式中的图片//郭荣明修改,不要夜间模式,改为实时路况.下同
    _nightImageview=[UIImageView new];
    _nightImageview.image=[UIImage imageNamed:@"shishilukuang"];
    [_nightView addSubview:_nightImageview];
    
    
    
    [_nightImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_nightView.mas_centerX);
        make.centerY.equalTo(_nightView.mas_centerY);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
        
    }];
    
    
    
    //关闭图片
    
    UIView * closePic=[[UIView alloc]initWithFrame:CGRectMake(ScreenWidth-ScaleWidth(6)-38, ScaleHeight(97.5), 38, 38)];
    closePic.backgroundColor=[UIColor whiteColor];
    closePic.layer.cornerRadius=4;
    closePic.layer.masksToBounds=YES;
    [self.view addSubview:closePic];
    //关闭图片的image
    UIImageView * ClosePicImageview=[UIImageView new];
    ClosePicImageview.image=[UIImage imageNamed:@"conceal"];
    [closePic addSubview:ClosePicImageview];
    [ClosePicImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(closePic.mas_centerX);
        make.centerY.equalTo(closePic.mas_centerY);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(14);
        
    }];
    
    //分享的图片按钮
    UIView * sharePic = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth-ScaleWidth(6)-38, ScaleHeight(44.5), 38, 38)];
    sharePic.backgroundColor = [UIColor whiteColor];
    sharePic.layer.cornerRadius=4;
    sharePic.layer.masksToBounds=YES;
    [self.view addSubview:sharePic];
    //分享按钮的image
    UIImageView * sharePicImageview=[UIImageView new];
    sharePicImageview.image=[UIImage imageNamed:@"share-icon"];
    [sharePic addSubview:sharePicImageview];
    [sharePicImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(sharePic.mas_centerX);
        make.centerY.equalTo(sharePic.mas_centerY);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
        
    }];
    
    
    
    
    
    //创建点击事件
    UITapGestureRecognizer * closeTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeClick)];
    UITapGestureRecognizer * nightTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(nightClick)];
    UITapGestureRecognizer * wcTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(WCClick)];
    UITapGestureRecognizer * shareTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ShareClick)];
    
    sharePic.userInteractionEnabled=YES;
    closePic.userInteractionEnabled=YES;
    _nightView.userInteractionEnabled=YES;
    WCView.userInteractionEnabled=YES;
    [sharePic addGestureRecognizer:shareTap];
    [closePic addGestureRecognizer:closeTap];
    [_nightView addGestureRecognizer:nightTap];
    [WCView addGestureRecognizer:wcTap];
    
}



//底部三个Button
-(void)bottomThreeBtns
{
    //播放view
    UIView * bofangView=[[UIView alloc]initWithFrame:CGRectMake(ScaleWidth(71.5), ScreenHeight-59-48-64, 48, 48)];
    bofangView.backgroundColor=[UIColor whiteColor];
    bofangView.layer.masksToBounds=YES;
    bofangView.layer.cornerRadius=24;
    [self.view addSubview:bofangView];
    _startView=bofangView;
    //添加播放的图片
    UIImageView * bofangImage=[UIImageView new];
    bofangImage.image=[UIImage imageNamed:@"play"];
    [bofangView  addSubview:bofangImage];
    [bofangImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bofangView.mas_centerX);
        make.centerY.equalTo(bofangView.mas_centerY);
        make.width.mas_equalTo(14.5);
        make.height.mas_equalTo(18);
        
    }];
    _startImageView=bofangImage;
    ///创建拍照按钮
    UIView * paizhaoView=[[UIView alloc]initWithFrame:CGRectMake((ScreenWidth-48)/2, ScreenHeight-59-48-64, 48, 48)];
    paizhaoView.backgroundColor=[UIColor whiteColor];
    paizhaoView.layer.masksToBounds=YES;
    paizhaoView.layer.cornerRadius=24;
    [self.view addSubview:paizhaoView];
    
    //添加拍照的图片
    UIImageView * paizhaoimage=[UIImageView new];
    paizhaoimage.image=[UIImage imageNamed:@"GJ-camera"];
    [paizhaoView  addSubview:paizhaoimage];
    [paizhaoimage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(paizhaoView.mas_centerX);
        make.centerY.equalTo(paizhaoView.mas_centerY);
        make.width.mas_equalTo(22);
        make.height.mas_equalTo(18);
        
    }];
    
    //=====创建停止按钮
    UIView * stopView=[[UIView alloc]initWithFrame:CGRectMake(ScreenWidth-ScaleWidth(75.5)-48,  ScreenHeight-59-48-64, 48, 48)];
    stopView.backgroundColor=[UIColor whiteColor];
    stopView.layer.masksToBounds=YES;
    stopView.layer.cornerRadius=24;
    [self.view addSubview:stopView];
    
    //停止时候的按钮图片
    UIImageView * stopImage=[UIImageView new];
    stopImage.image=[UIImage imageNamed:@"jieshu"];
    [stopView addSubview:stopImage];
    [stopImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(stopView.mas_centerX);
        make.centerY.equalTo(stopView.mas_centerY);
        make.width.mas_equalTo(15);
        make.height.mas_equalTo(15);
    }];
    
    
    
    //底下横排的三个按钮的点击
    
    bofangView.userInteractionEnabled=YES;
    paizhaoView.userInteractionEnabled=YES;
    stopView.userInteractionEnabled=YES;
    
    UITapGestureRecognizer * bofangtap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(startClick)];
    [bofangView addGestureRecognizer:bofangtap];
    
    UITapGestureRecognizer * paizhaoTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(paizhaoClick)];
    [paizhaoView addGestureRecognizer:paizhaoTap];
    
    UITapGestureRecognizer * stoptap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(stopClick)];
    [stopView addGestureRecognizer:stoptap];
    
    
    
}
/**
 *  添加一个大头针
 */
- (BMKPointAnnotation *)creatPointWithLocaiton:(CLLocation *)location title:(NSString *)title;
{
    BMKPointAnnotation *point = [[BMKPointAnnotation alloc] init];
    point.coordinate = location.coordinate;
    point.title = title;
    [self.mapview addAnnotation:point];
    
    return point;
}









#pragma mark 地图相关的代理方法 逻辑处理方法
#pragma mark 在线建议查询回调
- (void)onGetSuggestionResult:(BMKSuggestionSearch*)searcher result:(BMKSuggestionResult*)result errorCode:(BMKSearchErrorCode)error{
    [SVProgressHUD  dismiss];
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        NSLog(@"%@",result);
        _searchResultArray=[NSMutableArray arrayWithArray:result.keyList];
        [_tableView reloadData];
    }
    else {
        [SVProgressHUD showErrorWithStatus:@"抱歉，未找到结果"];
        NSLog(@"抱歉，未找到结果");
    }
}
#pragma mark 处理位置信息更新
#pragma mark 处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    
    [_mapview updateLocationData:userLocation];
//    [_locService stopUserLocationService];//定位之后停止定位//注释掉代码才可以实时定位
    //NSLog(@"heading is %@",userLocation.heading);
}
#pragma mark 处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    [_mapview updateLocationData:userLocation];
    self.codinate2 =userLocation.location.coordinate;

    
    _userLocation=userLocation;
    if (_mapStatus==MapTrailStart) {//如果开始录制轨迹
        //        [self.locationArrayM addObject:userLocation.location];//将用户当前位置添加作为初始点
        if (self.preLocation) {
            // 计算本次定位数据与上次定位数据之间的距离
            CGFloat distance = [userLocation.location distanceFromLocation:self.preLocation];
            MyLog(@"与上一位置点的距离为:%f",distance);
            // (100米门限值，存储数组划线) 如果距离少于 100 米，则忽略本次数据直接返回该方法
            //            if (distance < 100) {
            //                MyLog(@"与前一更新点距离小于100m，直接返回该方法");
            //                return;
            //            }
            //test
            if (distance < 20) {
                MyLog(@"与前一更新点距离小于20m，直接返回该方法");
                return;
            }
            // 累加步行距离
            self.sumDistance += distance;
            MyLog(@"步行总距离为:%f",self.sumDistance);
        }
        // 2. 将符合的位置点存储到数组中
        [self.locationArrayM addObject:userLocation.location];
        [self didUpdateLocationArray:_locationArrayM];//根据数组画线
        //记录位置
        self.preLocation = userLocation.location;
        
        self.userLocation = userLocation;
    }
}
#pragma mark 实现PoiSearchDeleage处理回调结果(厕所)
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResultList errorCode:(BMKSearchErrorCode)error
{
    self.animationArray=[NSMutableArray array];
    NSMutableArray * animationArray=[NSMutableArray array];
    [SVProgressHUD dismiss];
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        //        BMKPoiInfo * info=poiResultList.poiInfoList[0];
        for (BMKPoiInfo * info in poiResultList.poiInfoList) {
            MyLog(@"%@---%f",info.name,info.pt.latitude);
        }
        for (BMKPoiInfo * info in poiResultList.poiInfoList) {
            BMKPointAnnotation * animation=[[BMKPointAnnotation alloc]init];
            animation.coordinate=info.pt;
            animation.title=info.name;
            animation.subtitle=@"WC";
            [animationArray addObject:animation];
        }
        
        [_mapview addAnnotations:animationArray];
        [self.animationArray addObjectsFromArray:animationArray];
    }
    else if (error == BMK_SEARCH_AMBIGUOUS_KEYWORD){
        //当在设置城市未找到结果，但在其他城市找到结果时，回调建议检索城市列表
        // result.cityList;
        //        NSLog(@"起始点有歧义");
        [SVProgressHUD showErrorWithStatus:@"起始点有歧义"];
    } else {
        //        NSLog(@"抱歉，未找到结果");
        [SVProgressHUD showInfoWithStatus:@"抱歉，未找到结果"];
    }
}


// Override
#pragma mark 大头针相关回调
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([[annotation subtitle] isEqualToString:@"WC"]) {//表示厕所 默认大头针
        return nil;}
    
    if (_mapStatus==MapTrailStart) {//表示开始录制轨迹
        if (_eventsArray&&_eventsArray.count>0) {//事件大头针
            //自定义annotation
            NSString *AnnotationViewID = @"AnimatedAnnotation";
            VLXRecordAnnotationView *annotationView = nil;
            if (annotationView == nil) {
                annotationView = [[VLXRecordAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
            }
            //    annotationView.titleLab.text=[annotationView.annotation title];//设置标题
            NSString *title=[annotation title];
            for (int i=0; i<_eventsArray.count; i++) {
                VLXCourseModel *model=[NSKeyedUnarchiver unarchiveObjectWithData:_eventsArray[i]];
                if ([title isEqualToString:model.pathName]) {
                    [annotationView createUIWithCourseModel:model];
                }
            }
            annotationView.canShowCallout=NO;
            return annotationView;
        }else
        {
            //起点
            //自定义annotation
            NSString *AnnotationViewID = @"VLXStartAnnotationViewID";
            VLXStartAnnotationView *annotationView = nil;
            if (annotationView == nil) {
                annotationView = [[VLXStartAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
            }
            //    annotationView.titleLab.text=[annotationView.annotation title];//设置标题
            
            annotationView.canShowCallout=NO;
            return annotationView;
        }
    }else if (_mapStatus==MapSingleEvent)//单独拍照或者视频
    {
        //自定义annotation
        NSString *AnnotationViewID = @"AnimatedAnnotation";
        VLXRecordAnnotationView *annotationView = nil;
        if (annotationView == nil) {
            annotationView = [[VLXRecordAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        }
        //    annotationView.titleLab.text=[annotationView.annotation title];//设置标题
        NSString *title=[annotation title];
        for (int i=0; i<_eventsArray.count; i++) {
            VLXCourseModel *model=[NSKeyedUnarchiver unarchiveObjectWithData:_eventsArray[i]];
            if ([title isEqualToString:model.pathName]) {
                [annotationView createUIWithCourseModel:model];
            }
        }
        annotationView.canShowCallout=NO;
        return annotationView;
    }
    else if (_mapStatus==MapTrailEnd)//表示结束轨迹
    {
        if ([[annotation title] isEqualToString:@"终点"]) {
            //终点
            //自定义annotation
            NSString *AnnotationViewID = @"VLXEndAnnotationViewID";
            VLXEndAnnotationView *annotationView = nil;
            if (annotationView == nil) {
                annotationView = [[VLXEndAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
            }
            //    annotationView.titleLab.text=[annotationView.annotation title];//设置标题
            annotationView.canShowCallout=NO;
            return annotationView;
        }else
        {
            //自定义annotation
            NSString *AnnotationViewID = @"AnimatedAnnotation";
            VLXRecordAnnotationView *annotationView = nil;
            if (annotationView == nil) {
                annotationView = [[VLXRecordAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
            }
            //    annotationView.titleLab.text=[annotationView.annotation title];//设置标题
            NSString *title=[annotation title];
            for (int i=0; i<_eventsArray.count; i++) {
                VLXCourseModel *model=[NSKeyedUnarchiver unarchiveObjectWithData:_eventsArray[i]];
                if ([title isEqualToString:model.pathName]) {
                    [annotationView createUIWithCourseModel:model];
                }
            }
            annotationView.canShowCallout=NO;
            return annotationView;
        }
        
    }
    else if (_mapStatus==MapRouteSearch)//表示路线规划
    {
        if ([[annotation title] isEqualToString:@"起点"]) {
            //起点
            //自定义annotation
            NSString *AnnotationViewID = @"VLXStartAnnotationViewID";
            VLXStartAnnotationView *annotationView = nil;
            if (annotationView == nil) {
                annotationView = [[VLXStartAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
            }
            //    annotationView.titleLab.text=[annotationView.annotation title];//设置标题
            
            annotationView.canShowCallout=NO;
            return annotationView;
        }else if ([[annotation title] isEqualToString:@"终点"])
        {
            //终点
            //自定义annotation
            NSString *AnnotationViewID = @"VLXEndAnnotationViewID";
            VLXEndAnnotationView *annotationView = nil;
            if (annotationView == nil) {
                annotationView = [[VLXEndAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
            }
            //    annotationView.titleLab.text=[annotationView.annotation title];//设置标题
            annotationView.canShowCallout=NO;
            return annotationView;
        }
    }
    //    if (_WCClicked) {//表示展示附近wc大头针
    //        if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
    //            BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
    //            newAnnotationView.pinColor = BMKPinAnnotationColorRed;
    //            newAnnotationView.animatesDrop = NO;// 设置该标注点动画显示
    //            newAnnotationView.canShowCallout=YES;
    //            return newAnnotationView;
    //        }
    //    }
    
    
    //如果没有进行录制或者拍照,直接走这儿,设置大头针
    NSString *AnnotationViewID = @"AnimatedAnnotation";
    VLXRecordAnnotationView *annotationView = nil;
    if (annotationView == nil) {
        annotationView = [[VLXRecordAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
    }
    //    annotationView.titleLab.text=[annotationView.annotation title];//设置标题
    NSString *title=[annotation title];
    
    for ( id obj in _allDataArr) {
        if ([obj isKindOfClass:[VLXRecordDataModel class]]) {
            VLXRecordDataModel *model = obj;
            if ([title isEqualToString:model.countNum]) {
                [annotationView createUIWithModel:model];
                break;
            }
        }else{
            VLXGuiJiModel *model = obj;
            if ([title isEqualToString:model.countNum]) {
                [annotationView createUIWithGuijiModel:model];
                break;
            }
        }
        
    }
    annotationView.canShowCallout=NO;
    return annotationView;
    
    
//    return nil;
}
#pragma mark 大头针点击事件
-(void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
//        [self.mapview deselectAnnotation:view.annotation animated:YES];//让大头针可以重复点击
    NSLog(@"打印大头针位置%@",view);
    
//    if ([view isKindOfClass:[VLXRecordAnnotationView class]]) {
//        [self.mapview deselectAnnotation:view.annotation animated:YES];//让大头针可以重复点击
//        NSString *title=[view.annotation title];
//        
//        for (int i=0; i<_eventsArray.count; i++) {
//            VLXCourseModel *model=[NSKeyedUnarchiver unarchiveObjectWithData:_eventsArray[i]];
//            if ([title isEqualToString:model.pathName]) {
//                if (![NSString checkForNull:model.picUrl]) {//表示图片
//                    VLXRecordImageDetailVC *vc=[[VLXRecordImageDetailVC alloc] init];
//                    //                        vc.model=model;
//                    vc.courseModel=model;
//                    [self.navigationController pushViewController:vc animated:YES];
//                }
//                else if (![NSString checkForNull:model.videoUrl])//表示视频
//                {
//                    VLXRecordVideoDetailVC *vc=[[VLXRecordVideoDetailVC alloc] init];
//                    vc.courseModel=model;
//                    [self.navigationController pushViewController:vc animated:YES];
//                }
//                
//            }
//        }
//        
//    }
    //这一坨代码我后来添加的,不知道啥
    for (id obj in _allDataArr) {
        NSString *title=[view.annotation title];
        if ([obj isKindOfClass:[VLXGuiJiModel class]]) {//如果travelroadid有值，表示轨迹
            VLXGuiJiModel *model = obj;
            if ([title isEqualToString:model.countNum]) {
//                NSLog(@"%@",title);
                VLXRecordDetailVC *vc=[[VLXRecordDetailVC alloc] init];
                vc.travelRoadId=model.travelroadid;
                [self.navigationController pushViewController:vc animated:YES];
                return;
            }
            
        }else
        {
            VLXRecordDataModel *model = obj;
            if ([title isEqualToString:model.countNum]) {
                
                if (![NSString checkForNull:model.picurl]) {//表示图片
                    VLXRecordImageDetailVC *vc=[[VLXRecordImageDetailVC alloc] init];
                    vc.model=model;
                    [self.navigationController pushViewController:vc animated:YES];
                    return;
                }
                else if (![NSString checkForNull:model.videourl])//表示视频
                {
                    VLXRecordVideoDetailVC *vc=[[VLXRecordVideoDetailVC alloc] init];
                    vc.model=model;
                    [self.navigationController pushViewController:vc animated:YES];
                    return;
                }
            }
            
        }
    }

    
    
}
/**
 *更新线路数组后，会调用此函数
 *@param locationArr 线路数组
 */
- (void)didUpdateLocationArray:(NSArray *)locationArr{
    //    [self.locationArrayM removeAllObjects];
    //    [self.locationArrayM addObjectsFromArray:locationArr];
    // 改变线条类型
    //    self.lineType = LineTypeRoadBook;
    // 绘图
    [self drawWalkPolyline];
}
// Override
#pragma mark 折线图相关回调(即轨迹)
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay{
    if ([overlay isKindOfClass:[BMKPolyline class]]){
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay] ;
        polylineView.strokeColor = green_color;
        polylineView.lineWidth = 2.5;
        return polylineView;
    }
    return nil;
}
#pragma mark---正向编码编码
//接收正向编码结果

- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    //    [SVProgressHUD showWithStatus:@"正在加载"];
    if (error == BMK_SEARCH_NO_ERROR) {
        [SVProgressHUD dismiss];
        NSLog(@"地理编码成功");
        //在此处理正常结果
        _resultLocation=[[CLLocation alloc] initWithLatitude:result.location.latitude longitude:result.location.longitude];
        _mapview.zoomLevel = 15;//先设置缩放比例,不然会第一次不显示搜索地方
        [_mapview setCenterCoordinate:result.location animated:YES];
        BMKPointAnnotation * bigPoint = [[BMKPointAnnotation alloc] init];
        bigPoint.coordinate = CLLocationCoordinate2DMake(result.location.latitude, result.location.longitude);
        [_mapview addAnnotation:bigPoint];//大头针
        
    }
    else {
        [SVProgressHUD showErrorWithStatus:@"抱歉，未找到该地点"];
        NSLog(@"抱歉，未找到结果");
    }
}
#pragma mark---反向地理编码
//接收反向地理编码结果
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result
                        errorCode:(BMKSearchErrorCode)error{
    [SVProgressHUD showWithStatus:@"正在加载"];
    if (error == BMK_SEARCH_NO_ERROR) {
        [SVProgressHUD dismiss];
        //      在此处理正常结果
        NSLog(@"%@",result);
        if (_mapStatus==MapTrailStart) {//起点名称
            _startLocationStr=[ZYYCustomTool checkNullWithNSString:result.sematicDescription];
        }else if (_mapStatus==MapTrailEnd)//终点名称
        {
            _endLocationStr=[ZYYCustomTool checkNullWithNSString:result.sematicDescription];
        }
    }
    else {
        [SVProgressHUD showErrorWithStatus:@"抱歉，未找到结果"];
        NSLog(@"抱歉，未找到结果");
    }
}
#pragma mark---步行路线规划
- (void)onGetWalkingRouteResult:(BMKRouteSearch*)searcher result:(BMKWalkingRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    NSLog(@"onGetWalkingRouteResult error:%d", (int)error);
    NSArray* array = [NSArray arrayWithArray:_mapview.annotations];
    [_mapview removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapview.overlays];
    [_mapview removeOverlays:array];
    if (error == BMK_SEARCH_NO_ERROR) {
        [SVProgressHUD dismiss];
        BMKWalkingRouteLine* plan = (BMKWalkingRouteLine*)[result.routes objectAtIndex:0];
        NSInteger size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKWalkingStep* transitStep = [plan.steps objectAtIndex:i];
            if(i==0){
                
                CLLocation *location=[[CLLocation alloc] initWithLatitude:plan.starting.location.latitude longitude:plan.starting.location.longitude];
                [self creatPointWithLocaiton:location title:@"起点"];
                
            }
            if(i==size-1){
                
                CLLocation *location=[[CLLocation alloc] initWithLatitude:plan.terminal.location.latitude longitude:plan.terminal.location.longitude];
                [self creatPointWithLocaiton:location title:@"终点"];
            }
            
            
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        
        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKWalkingStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [_mapview addOverlay:polyLine]; // 添加路线overlay
        delete []temppoints;
        [self mapViewFitPolyLine:polyLine];
    } else if (error == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR) {
        //检索地址有歧义,返回起点或终点的地址信息结果：BMKSuggestAddrInfo，获取到推荐的poi列表
        NSLog(@"检索地址有岐义，请重新输入。");
        //        [self showGuide];
        [SVProgressHUD showErrorWithStatus:@"检索地址有岐义，请重新输入"];
    }
}
#pragma mark---根据polyline设置地图范围
- (void)mapViewFitPolyLine:(BMKPolyline *) polyLine {
    CGFloat ltX, ltY, rbX, rbY;
    if (polyLine.pointCount < 1) {
        return;
    }
    BMKMapPoint pt = polyLine.points[0];
    ltX = pt.x, ltY = pt.y;
    rbX = pt.x, rbY = pt.y;
    for (int i = 1; i < polyLine.pointCount; i++) {
        BMKMapPoint pt = polyLine.points[i];
        if (pt.x < ltX) {
            ltX = pt.x;
        }
        if (pt.x > rbX) {
            rbX = pt.x;
        }
        if (pt.y > ltY) {
            ltY = pt.y;
        }
        if (pt.y < rbY) {
            rbY = pt.y;
        }
    }
    BMKMapRect rect;
    rect.origin = BMKMapPointMake(ltX , ltY);
    rect.size = BMKMapSizeMake(rbX - ltX, rbY - ltY);
    [_mapview setVisibleMapRect:rect];
    _mapview.zoomLevel = _mapview.zoomLevel - 0.3;
}
#pragma mark---拍照  拍视频
-(void)openCameraForPhoto//打开摄像头 用于拍照
{
    UIImagePickerController *imagePicker=[[UIImagePickerController alloc] init];
    imagePicker.delegate=self;
    //    imagePicker.allowsEditing=YES;
    NSLog(@"拍照片");
    if (![UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera]) {
        [SVProgressHUD showErrorWithStatus:@"相机不可用"];//RWNLocalizedString(@"SheZhi-TheCameraIsNotAvailable");
    }else
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}
-(void)openCameraForVideo//打开摄像头用于录像
{
    UIImagePickerController *imagePicker=[[UIImagePickerController alloc] init];
    imagePicker.delegate=self;
    //    imagePicker.allowsEditing=YES;
    NSLog(@"拍视频");
    if (![UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera]) {
        [SVProgressHUD showErrorWithStatus:@"相机不可用"];//RWNLocalizedString(@"SheZhi-TheCameraIsNotAvailable");
    }else
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.cameraDevice=UIImagePickerControllerCameraDeviceRear;//使用后置摄像头
        imagePicker.mediaTypes=@[(NSString *)kUTTypeMovie];//kUTTypeMovie（视频并带有声音）
        imagePicker.videoMaximumDuration=10;//视频最大录制时长，默认为10 s
        imagePicker.videoQuality=UIImagePickerControllerQualityTypeHigh;//高质量，适合蜂窝网传输
        imagePicker.cameraCaptureMode=UIImagePickerControllerCameraCaptureModeVideo;//视频录制模式
        imagePicker.cameraFlashMode=UIImagePickerControllerCameraFlashModeAuto;//自动闪光灯
        
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}
#pragma mark---imagePicker delegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    //    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {//如果是拍照
    //        NSLog(@"%@",info);
    //    }
    
    [picker dismissViewControllerAnimated:YES completion:^{
        if (_userLocation.location==nil||_userLocation==nil) {
            [SVProgressHUD showErrorWithStatus:@"无法获取您的位置信息，请移动两步试试"];
            return ;
        }
        CLLocation *location=_userLocation.location;//用户当前位置
        if ([mediaType isEqualToString:(NSString *)kUTTypeImage])//拍照
        {
            VLXAddImageVC *vc=[[VLXAddImageVC alloc] init];
            UIImage *resultImg = info[UIImagePickerControllerOriginalImage];
            resultImg = [self fixOrientation:resultImg];
            vc.image=resultImg;//用户拍照的照片
            NSLog(@"%@",_userLocation.location);
            
            vc.location=location;//用户当前位置
            if (_mapStatus==MapTrailStart) {//表示录制轨迹
                vc.type=2;
            }else//表示录制单个点
            {
                _mapStatus=MapSingleEvent;
                vc.type=1;
            }
            [self.navigationController pushViewController:vc animated:YES];
            
        }else if([mediaType isEqualToString:(NSString *)kUTTypeMovie]){//如果是录制视频
            //        NSLog(@"video...");
            NSURL *url=[info objectForKey:UIImagePickerControllerMediaURL];//视频路径
            NSData *oldData=[NSData dataWithContentsOfURL:url];
            NSLog(@"视频原大小:%fM",(float)oldData.length / 1024 / 1024);
            //        NSString *urlStr=[url path];
            VLXAddVideoVC *vc=[[VLXAddVideoVC alloc] init];
            vc.url=url;
            vc.location=location;
            if (_mapStatus==MapTrailStart) {//表示录制轨迹
                vc.type=2;
            }else//表示录制单个点
            {
                _mapStatus=MapSingleEvent;
                vc.type=1;
            }
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
}


- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"imagePickerControllerDidCancel");
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark---点击事件
-(void)tapToRoutePlan:(UITapGestureRecognizer *)tap
{
    if (_mapStatus==MapTrailStart) {//录制运动轨迹不能路线规划
        [SVProgressHUD showInfoWithStatus:@"请结束运动后再搜索"];
        return;
    }
    NSLog(@"路线规划");
    [self resetMapView];//重置地图和相关数据
    _mapStatus=MapRouteSearch;//表示进行路线规划
    if (_userLocation.location&&_resultLocation)
    {
        BMKPlanNode* start = [[BMKPlanNode alloc]init];
        
        start.pt=_userLocation.location.coordinate;
        BMKPlanNode* end = [[BMKPlanNode alloc]init];
        
        end.pt=_resultLocation.coordinate;
        
        BMKWalkingRoutePlanOption *walkingRouteSearchOption = [[BMKWalkingRoutePlanOption alloc]init];
        walkingRouteSearchOption.from = start;
        walkingRouteSearchOption.to = end;
        BOOL flag = [_routesearch walkingSearch:walkingRouteSearchOption];
        if(flag)
        {
            NSLog(@"walk检索发送成功");
            [SVProgressHUD showWithStatus:@"正在加载"];
        }
        else
        {
            NSLog(@"walk检索发送失败");
            [SVProgressHUD showErrorWithStatus:@"步行检索发送失败"];
        }
    }
    
    
    
}
-(void)addClick
{
    MyLog(@"添加");
    
    if (self.level<21) {
        ++self.level;
        [self.mapview setZoomLevel:self.level];
    }
    
}

-(void)minusClick
{
    if (self.level>3) {
        
        --self.level;
        [self.mapview setZoomLevel:self.level];
    }
    
    MyLog(@"减号");
    
}
#pragma mark 底下三个按钮点击
-(void)startClick
{
    MyLog(@"开始录制");
    //
    if ([NSString checkForNull:[NSString getDefaultToken]]) {
        
        if (![NSString getDefaultToken]) {
            [ZYYCustomTool userToLoginWithVC:self];
            return;
        }
        
    }
    [self resetMapView];//重置地图和相关数据
    //控制按钮状态
    _WCClicked=NO;
    _mapStatus=MapTrailStart;
    [_startImageView setImage:[UIImage imageNamed:@"zanting"]];
    _startView.userInteractionEnabled=NO;//关闭用户交互
    // 放置起点大头针
    if (_userLocation.location) {
        [self.locationArrayM addObject:_userLocation.location];//将用户当前位置添加作为初始点
        self.startPoint = [self creatPointWithLocaiton:_userLocation.location title:nil];
    }
    [self startReverseGeocode:_userLocation.location.coordinate];//反向地理编码起点位置
}
-(void)paizhaoClick
{
    MyLog(@"拍照");
    if (![NSString getDefaultToken]) {
        [ZYYCustomTool userToLoginWithVC:self];
        return;
    }
    if (_userLocation.location==nil||_userLocation==nil) {
        [SVProgressHUD showInfoWithStatus:@"无法获取您的位置信息，请移动两步试试"];
        return ;
    }
    __block VLXCourseViewController *blockSelf=self;
    VLXCustomAlertView *alertView=[[VLXCustomAlertView alloc] initWithTitle:@"拍照/拍视频" andContent1:@"拍照" andContent2:@"拍视频"];
    [[UIApplication sharedApplication].keyWindow addSubview:alertView];
    alertView.alertBlock=^(NSInteger index)
    {
        NSLog(@"index:%ld",index);
        if (index==1) {//拍照
            [blockSelf openCameraForPhoto];
        }else if (index==2)//拍视频
        {
            [blockSelf openCameraForVideo];
        }
    };
}
-(void)stopClick
{
    MyLog(@"停止");
    if (![NSString getDefaultToken]) {
        [ZYYCustomTool userToLoginWithVC:self];
        return;
    }
    
    NSLog(@"%@",_locationArrayM);
    if (_mapStatus==MapTrailStart||_mapStatus==MapTrailEnd) {
        //控制按钮状态
        
        VLXCourseAlertView *alert=[[VLXCourseAlertView alloc] initWithFrame:CGRectZero andType:1];
        [[UIApplication sharedApplication].keyWindow addSubview:alert];
        alert.courseBlock=^(NSInteger tag)
        {
            if (tag==101) {//保存
                _mapStatus=MapTrailEnd;
                [self stopToEvents];
            }else if (tag==100)//取消
            {
                _mapStatus=MapTrailStart;
            }
        };
    }
}
-(void)stopToEvents//录制结束后需要处理的事件
{
    
    __block VLXCourseViewController *blockSelf=self;
    //
    VLXCourseDesVC *desVC=[[VLXCourseDesVC alloc] init];
    [self.navigationController pushViewController:desVC animated:YES];
    desVC.desBlock=^(NSString *titleStr,NSString *desStr)//轨迹名称 轨迹描述
    {
        blockSelf.titleStr=titleStr;
        blockSelf.desStr=desStr;
        [blockSelf loadDataWithRoute];//保存轨迹
    };
    //
    [_startImageView setImage:[UIImage imageNamed:@"play"]];
    _startView.userInteractionEnabled=YES;//打开用户交互
    // 放置终点大头针
    if (_locationArrayM&&_locationArrayM.count>0) {
        CLLocation *lastLocation=[_locationArrayM lastObject];
        self.endPoint = [self creatPointWithLocaiton:[_locationArrayM lastObject] title:@"终点"];
        
        [self startReverseGeocode:lastLocation.coordinate];//反地理编码终点名称
    }
    //    //清空数组
    //    [_locationArrayM removeAllObjects];//清除轨迹数组
    //    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    //    [defaults removeObjectForKey:@"courseEvents"];//清除事件数组
}
#pragma mark 定位location
-(void)locationClick
{
    MyLog(@"定位locaton");
    self.mapview.centerCoordinate=self.codinate2;//self.userLocation.location.coordinate;
    
    //跟随态旋转角度是否生效
//    userlocationStyle.isAccuracyCircleShow = NO;
}
#pragma mark 关闭pic
-(void)closeClick
{
    
    if (![NSString getDefaultToken]) {
        [ZYYCustomTool userToLoginWithVC:self];
        return;
    }
    MyLog(@"关闭图片的展示");
    _isShow=!_isShow;
    if (_isShow) {
        [_mapview removeAnnotations:_eventsAnnotationsArray];
    }else
    {
        [_mapview addAnnotations:_eventsAnnotationsArray];
    }
    
}
#pragma mark  夜间模式
-(void)nightClick
{
    _nightClicked=!_nightClicked;
    if (_nightClicked) {
        
        //         [BMKMapView enableCustomMapStyle:YES];//打开个性化地图
        
        //打开实时路况//
        [_mapview setTrafficEnabled:YES];//不报错
        _nightImageview.image=[UIImage imageNamed:@"shishilukuang_selec"];
        
        
    }else
    {
        MyLog(@"点击夜间模式");
        //         [BMKMapView enableCustomMapStyle:NO];//打开个性化地图
        
        //关闭实时路况//
        [_mapview setTrafficEnabled:NO];
        _nightImageview.image=[UIImage imageNamed:@"shishilukuang"];
        
        
    }
    
}
//分享按钮
-(void)ShareClick{
    //    MyLog(@"点击右上角分享按钮");
    if (![NSString getDefaultToken]) {
        [ZYYCustomTool userToLoginWithVC:self];
        return;
    }
    __block VLXCourseViewController *blockSelf=self;
    _isShowMenu=!_isShowMenu;
    if (_isShowMenu) {
        _menuView=[[VLXMenuPopView alloc] initWithFrame:CGRectZero andType:3];
        _menuView.menuBlock=^(NSInteger index)
        {
            blockSelf.isShowMenu=NO;
            if (index==0) {
                NSLog(@"分享");
            }else if (index==200)
            {
                /*
                 dic[@"lng1"]=[NSString stringWithFormat:@"%f",_leftTopCoord.longitude];//手机左上角经度
                 dic[@"lat1"]=[NSString stringWithFormat:@"%f",_leftTopCoord.latitude];//手机左上角纬度
                 dic[@"lng2"]=[NSString stringWithFormat:@"%f",_rightBottomCoord.longitude];//手机右下角经度
                 dic[@"lat2"]=[NSString stringWithFormat:@"%f",_rightBottomCoord.latitude];//手机右下角纬度
                 */
                NSLog(@"分享");
                [blockSelf thirdShareWithUrl:[NSString stringWithFormat:@"%@/shareurl/auth/travelRoadShare.json?token=%@&year=%@&lng1=%f&lat1=%f&lng2=%f&lat2=%f",ftpPath,[NSString getDefaultToken],[ZYYCustomTool checkNullWithNSString:blockSelf.yearLabel.text],blockSelf.leftTopCoord.longitude,blockSelf.leftTopCoord.latitude,blockSelf.rightBottomCoord.longitude,blockSelf.rightBottomCoord.latitude]];
                //                NSLog(@"删除");
                //                VLXCourseAlertView *alert=[[VLXCourseAlertView alloc] initWithFrame:CGRectZero andType:2];
                //                [[UIApplication sharedApplication].keyWindow addSubview:alert];
                //                alert.courseBlock=^(NSInteger tag)
                //                {
                //                    if (tag==101) {//确定
                //                        [blockSelf loadDataWithDelete];
                //                    }else if (tag==100)//取消
                //                    {
                //
                //                    }
                //                };
            }
        };
        [self.view addSubview:_menuView];
    }else
    {
        [_menuView removeFromSuperview];
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
    __block VLXCourseViewController * blockSelf=self;;
    shareView.btnShareBlock=^(NSInteger tag)
    {
        
        
        MyLog(@"share:%ld",tag);
        //555,QQ 556,新浪微博 557,微信 558,朋友圈
        switch (tag) {
            case 555:
            {
                [ShareTool shareWebPageToPlatformType:UMSocialPlatformType_QQ andThumbURL:@"http://img3.2345.com/toolsimg/baike/collect/sheying/73b2150ajw1e6wsbsp5lbj20hs0hs3zs.jpg" andTitle:@"V旅行" andDesc:@"看世界、V旅行！" andWebPageUrl:url];
                [blockSelf clcikClose];
                
            }
                break;
            case 556:
            {
                
                [ShareTool shareWebPageToPlatformType:UMSocialPlatformType_Sina andThumbURL:@"http://img3.2345.com/toolsimg/baike/collect/sheying/73b2150ajw1e6wsbsp5lbj20hs0hs3zs.jpg" andTitle:@"V旅行" andDesc:@"看世界、V旅行！" andWebPageUrl:url];
                [blockSelf clcikClose];
            }
                break;
            case 557:
            {
                [ShareTool shareWebPageToPlatformType:UMSocialPlatformType_WechatSession andThumbURL:@"http://img3.2345.com/toolsimg/baike/collect/sheying/73b2150ajw1e6wsbsp5lbj20hs0hs3zs.jpg" andTitle:@"V旅行" andDesc:@"看世界、V旅行！" andWebPageUrl:url];
                [blockSelf clcikClose];
            }
                break;
            case 558:
            {
                [ShareTool shareWebPageToPlatformType:UMSocialPlatformType_WechatTimeLine andThumbURL:@"http://img3.2345.com/toolsimg/baike/collect/sheying/73b2150ajw1e6wsbsp5lbj20hs0hs3zs.jpg" andTitle:@"V旅行" andDesc:@"看世界、V旅行！" andWebPageUrl:url];
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

#pragma mark 点击厕所按钮
-(void)WCClick
{
    MyLog(@"点击厕所按钮");
    self.WCClicked=!self.WCClicked;
    if (!self.WCClicked) {
        [self.mapview removeAnnotations:self.animationArray];
        [self.animationArray removeAllObjects];//移除所有数据
    }else
    {
        [self makeSearch];
    }
    
}
#pragma mark---delegate
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark 郭荣明修改-创建左边的年份
-(void)createYearView1
{
    
    
    //   self.yearView =[[UIView alloc]initWithFrame:CGRectMake(0, ScaleHeight(338.5), 51, 48)];
    self.yearView =[[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight-215-49-64, 51, 48)];
    self.yearView.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.5];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.yearView.bounds      byRoundingCorners:UIRectCornerBottomRight | UIRectCornerTopRight     cornerRadii:CGSizeMake(25, 24)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.yearView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.yearView.layer.mask = maskLayer;
    [self.view addSubview:self.yearView];
    
    //创建图片
    self.yearImage =[UIImageView new];
    self.yearImage.image=[UIImage imageNamed:@"year"];//点击年份下拉view
    [self.yearView addSubview: self.yearImage];
    [ self.yearImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.yearView.mas_centerX);
        make.centerY.equalTo(self.yearView.mas_centerY);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
    
    
    //创建选择后的年份
    self.selectYear=[UIView new];
    self.selectYear.backgroundColor=orange_color;
    [self.yearView addSubview:self.selectYear];
    
    self.selectYear.layer.masksToBounds=YES;
    self.selectYear.layer.cornerRadius=20;
    [self.selectYear mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.yearView.mas_centerX);
        make.centerY.equalTo(self.yearView.mas_centerY);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
        
    }];
    self.selectYear.hidden=YES;
    //年份label
    self.yearLabel =[UILabel new];
    //    self.yearLabel.text=@"2017";
    self.yearLabel.textColor=[UIColor whiteColor];
    self.yearLabel.font=[UIFont  systemFontOfSize:12];
    self.yearLabel.textAlignment=NSTextAlignmentCenter;
    [self.selectYear addSubview:self.yearLabel];
    [self.yearLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.selectYear.mas_centerX);
        make.centerY.equalTo(self.selectYear.mas_centerY);
        make.width.mas_equalTo(35);
        make.height.mas_equalTo(12);
        
    }];
    
    
    //yearview的点击事件
    self.yearView.userInteractionEnabled=YES;
    UITapGestureRecognizer * yearTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickYear)];
    [self.yearView addGestureRecognizer:yearTap];
    
    //   self.nianView=[[VLXLTYearTB alloc]initWithFrame:CGRectMake(0, ScaleHeight(338.5), 74.5, 215)];
    self.nianView=[[VLXLTYearTB alloc]initWithFrame:CGRectMake(0, kScreenHeight-215-49-64, 74.5, 215)];
    [self.view addSubview:self.nianView];
    self.nianView.delegate = self;
    self.nianView.hidden=YES;
    __block VLXCourseViewController *blockSelf=self;
    self.nianView.yearBlock=^()
    {
        blockSelf.isShowYear=!blockSelf.isShowYear;
        if (blockSelf.isShowYear) {
            blockSelf.yearView.hidden=YES;
            blockSelf.nianView.hidden=NO;
        }else
        {
            blockSelf.yearView.hidden=NO;
            blockSelf.nianView.hidden=YES;
        }
    };
    
    
    
}

#pragma mark 点击了年月 ,grm
-(void)clickYear
{
    if (![NSString getDefaultToken]) {
        [ZYYCustomTool userToLoginWithVC:self];
        return;
    }
    _isShowYear=!_isShowYear; //
    if (_isShowYear) {
        self.yearView.hidden=YES;
        self.nianView.hidden=NO;
    }else
    {
        self.yearView.hidden=NO;
        self.nianView.hidden=YES;
    }
    
    MyLog(@"clickYear");
}


#pragma mark 自定义代理方法
-(void)tbSelcteyear:(NSInteger)year
{
    
    MyLog(@"123");
    self.isShowYear=!_isShowYear;
    
    self.nianView.hidden=YES;
    self.yearView.hidden=NO;
    self.selectYear.hidden=NO;
    self.yearLabel.text=[NSString stringWithFormat:@"%ld",(long)year];
    
    [self loadData];
}
#pragma mark---旅途首页（按周围四个角的范围）,郭荣明
-(void)loadData
{
    
    
    [SVProgressHUD showWithStatus:@"正在加载"];
    [self getScreenLocation];
    NSMutableDictionary * dic=[NSMutableDictionary dictionary];
    
    dic[@"token"]=[NSString getDefaultToken];//
    dic[@"year"]=[ZYYCustomTool checkNullWithNSString:_yearLabel.text];
    dic[@"lng1"]=[NSString stringWithFormat:@"%f",_leftTopCoord.longitude];//手机左上角经度
    dic[@"lat1"]=[NSString stringWithFormat:@"%f",_leftTopCoord.latitude];//手机左上角纬度
    dic[@"lng2"]=[NSString stringWithFormat:@"%f",_rightBottomCoord.longitude];//手机右下角经度
    dic[@"lat2"]=[NSString stringWithFormat:@"%f",_rightBottomCoord.latitude];//手机右下角纬度
    NSString * url=[NSString stringWithFormat:@"%@/TraRoadController/auth/TravelRoadList.html",ftpPath];
    NSLog(@"%@",dic);
    [SPHttpWithYYCache postRequestUrlStr:url withDic:dic success:^(NSDictionary *requestDic, NSString *msg) {
        
        //        NSLog(@"%@",requestDic.mj_JSONString);
        [self.allDataArr removeAllObjects];
        _recordModel=[[VLXRecordModel alloc] initWithDictionary:requestDic error:nil];
        for (int i = 0; i <_recordModel.data.count; i++) {
            VLXRecordDataModel *model = _recordModel.data[i];
            [self.allDataArr addObject:model];
            //            model.countNum = [NSString stringWithFormat:@"%d",i+1];
        }
        
        for (int i = 0; i <_recordModel.content.count; i++) {
            VLXGuiJiModel *model = _recordModel.content[i];
            [self.allDataArr addObject:model];
            //            model.countNum = [NSString stringWithFormat:@"%d",i+1];
        }
        
        for (int i = 0; i <_allDataArr.count; i++) {
            id obj = _allDataArr[i];
            if ([obj isKindOfClass:[VLXRecordDataModel class]]) {
                VLXRecordDataModel *model = obj;
                model.countNum = [NSString stringWithFormat:@"%d",i+1];
            }else{
                VLXGuiJiModel *model = obj;
                model.countNum = [NSString stringWithFormat:@"%d",i+1];
            }
            
        }
        
        if (_recordModel.status.integerValue==1) {
            [self createRecordAnnotation];
            [SVProgressHUD dismiss];
            
        }else
        {
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:msg];
        }
        
    } failure:^(NSString *errorInfo) {
        [SVProgressHUD dismiss];
        
    }];
    
    
    
    
}
#pragma mark---获取屏幕四周的经纬度,郭荣明
-(void)getScreenLocation//
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
#pragma mark---,郭荣明
-(NSMutableArray *)allDataArr{
    if (!_allDataArr) {
        _allDataArr = [NSMutableArray array];
    }
    return _allDataArr;
}

#pragma mark---创建记录大头针,郭荣明
-(void)createRecordAnnotation
{
    //移除之前所有的标注
    NSArray *mapAnnotationsArr=_mapview.annotations;
    if (mapAnnotationsArr&&mapAnnotationsArr.count>0) {
        [_mapview removeAnnotations:mapAnnotationsArr];
    }
    //
    NSMutableArray *annotationArray=[NSMutableArray array];
    
    for ( id obj in self.allDataArr) {
        if ([obj isKindOfClass:[VLXRecordDataModel class]]) {
            VLXRecordDataModel *model = obj;
            BMKPointAnnotation * point=[[BMKPointAnnotation alloc]init];
            CLLocationCoordinate2D code;
            code.latitude=[model.pathlat doubleValue];
            code.longitude=[model.pathlng doubleValue];
            point.coordinate=code;
            point.title=[ZYYCustomTool checkNullWithNSString:model.countNum];//用于标记 相当于tag
            [annotationArray addObject:point];
        }else{
            VLXGuiJiModel *model = obj;
            BMKPointAnnotation * point=[[BMKPointAnnotation alloc]init];
            CLLocationCoordinate2D code;
            code.latitude=[model.stratlat doubleValue];
            code.longitude=[model.stratlng doubleValue];
            point.coordinate=code;
            point.title=[ZYYCustomTool checkNullWithNSString:model.countNum];//用于标记 相当于tag
            [annotationArray addObject:point];
        }
        
    }

    [self.mapview addAnnotations:annotationArray];
}




@end
