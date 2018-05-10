//
//  VLXRecordDetailLineVC.m
//  Vlvxing
//
//  Created by 王静雨 on 2017/6/21.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXRecordDetailLineVC.h"
#import "VLXStartAnnotationView.h"
#import "VLXEndAnnotationView.h"
#import "VLXRecordAnnotationView.h"
#import "VLXRecordImageDetailVC.h"
#import "VLXRecordVideoDetailVC.h"
@interface VLXRecordDetailLineVC ()<BMKMapViewDelegate,BMKLocationServiceDelegate>
@property(nonatomic,strong)BMKMapView  * mapview;
@property(nonatomic,assign)NSInteger level;
@property(nonatomic,assign) CLLocationCoordinate2D  codinate;
@property(nonatomic,strong)BMKLocationService * locService;
/** 位置数组 */
@property (nonatomic, strong) NSMutableArray<CLLocation *> *locationArrayM;
/** 轨迹线 */
@property (nonatomic, strong) BMKPolyline *polyLine;
@end

@implementation VLXRecordDetailLineVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //初始化
    self.level=17;
    _locationArrayM=[NSMutableArray array];
    //
    [self createUI];
    [self loadData];
}
#pragma mark---数据
-(void)loadData
{
    if (![NSString checkForNull:_detailModel.data.coordinate]) {
        NSArray *locationArray=[_detailModel.data.coordinate componentsSeparatedByString:@"-"];
        for (int i=0; i<locationArray.count; i++) {
            NSString *locationStr=locationArray[i];
            NSArray *coorArray=[locationStr componentsSeparatedByString:@"#"];
            double lng=[[coorArray firstObject] doubleValue];
            double lat=[[coorArray lastObject] doubleValue];
            CLLocation *location=[[CLLocation alloc] initWithLatitude:lat longitude:lng];
            [_locationArrayM addObject:location];
            
        }
        [self drawWalkPolyline];
        // 放置起点 终点大头针
        if (_locationArrayM&&_locationArrayM.count>2) {
            [self creatPointWithLocaiton:[_locationArrayM firstObject] title:@"起点"];
            [self creatPointWithLocaiton:[_locationArrayM lastObject] title:@"终点"];
            self.mapview.centerCoordinate = [_locationArrayM firstObject].coordinate;
        }
        //放置事件大头针
        [self createRecordAnnotation];
    }
    
}
#pragma mark---创建记录大头针
-(void)createRecordAnnotation
{
    //移除之前所有的标注
//    NSArray *mapAnnotationsArr=_mapview.annotations;
//    if (mapAnnotationsArr&&mapAnnotationsArr.count>0) {
//        [_mapview removeAnnotations:mapAnnotationsArr];
//    }
    //
    NSMutableArray *annotationArray=[NSMutableArray array];
    for (int i=0; i<_detailModel.data.pathinfos.count; i++) {
        VLXRecordDetailInfoModel *model=_detailModel.data.pathinfos[i];
        //
        BMKPointAnnotation * point=[[BMKPointAnnotation alloc]init];
        CLLocationCoordinate2D code;
        code.latitude=[model.pathlat doubleValue];
        code.longitude=[model.pathlng doubleValue];
        point.coordinate=code;
        point.title=[ZYYCustomTool checkNullWithNSString:model.pathname];//用于标记 相当于tag
        [annotationArray addObject:point];
        
    }
    [self.mapview addAnnotations:annotationArray];
//    BMKPointAnnotation * point = annotationArray[0];
    
}
// 创建定位视图
-(void)Makelocation
{
    _locService=[[BMKLocationService alloc]init];
    _locService.delegate=self;
    [_locService startUserLocationService];
    //
    _mapview.showsUserLocation = YES;//显示定位图层
//    _mapview.userTrackingMode=BMKUserTrackingModeFollow;
    //去掉精度圈
    BMKLocationViewDisplayParam *param=[[BMKLocationViewDisplayParam alloc] init];
    param.isAccuracyCircleShow=NO;
    [_mapview updateLocationViewWithParam:param];
    
}
#pragma mark
#pragma mark---视图
-(void)createUI
{
    [self setNav];
    self.view.backgroundColor=[UIColor whiteColor];
    self.mapview=[[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];
    self.mapview.delegate=self;
    [self.mapview setZoomLevel:self.level];
    
    [self.view addSubview:self.mapview];
    [self createBtns];
    [self locationBtn];
    [self Makelocation];

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
- (void)setNav{
    
    
    self.view.backgroundColor=[UIColor whiteColor];
    self.title=@"轨迹线路";
    //左边按钮
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 20, 20);
    [leftBtn setImage:[UIImage imageNamed:@"return-red"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(tapLeftButton:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    //右边按钮
    //右边按钮
//    UIView * rightview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 20)];
//    rightview.backgroundColor=[UIColor whiteColor];
//    
//    UIImageView * rightimageview=[[UIImageView alloc]initWithFrame:CGRectMake(36, 0, 4, 20)];
//    rightimageview.image=[UIImage imageNamed:@"more"];
//    [rightview addSubview:rightimageview];
//    
//    UIBarButtonItem * rightBaritem=[[UIBarButtonItem alloc]initWithCustomView:rightview];
//    self.navigationItem.rightBarButtonItem=rightBaritem;
//    
//    rightview.userInteractionEnabled=YES;
//    UITapGestureRecognizer * rightTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rightClick)];
//    [rightview addGestureRecognizer:rightTap];
    
}
#pragma mark---添加一个大头针
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
#pragma mark---绘制轨迹
/**
 *  绘制轨迹路线
 */
- (void)drawWalkPolyline
{
    //超过500点抽希
//    [self deleteMoreLocationPoint];
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
            [self mapViewFitPolyLine:self.polyLine];
        });
    });
//    [self mapViewFitPolyLine:self.polyLine];
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

#pragma mark
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
    _level=_mapview.zoomLevel;
}
#pragma mark
#pragma mark
#pragma mark---事件
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

#pragma mark 定位location
-(void)locationClick
{
    MyLog(@"定位locaton");
    _mapview.userTrackingMode=BMKUserTrackingModeFollow;
    self.mapview.centerCoordinate=self.codinate;
    
}
-(void)tapLeftButton:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightClick
{
    MyLog(@"点击右上角分享按钮");
//    __block VLXRecordDetailVC *blockSelf=self;
//    _isShowMenu=!_isShowMenu;
//    if (_isShowMenu) {
//        _menuView=[[VLXMenuPopView alloc] initWithFrame:CGRectZero andType:1];
//        _menuView.menuBlock=^(NSInteger index)
//        {
//            blockSelf.isShowMenu=NO;
//            if (index==0) {
//                NSLog(@"分享");
//            }else if (index==1)
//            {
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
//            }
//        };
//        [self.view addSubview:_menuView];
//    }else
//    {
//        [_menuView removeFromSuperview];
//    }
}
#pragma mark
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
#pragma mark 定位的代理方法

//实现相关delegate 处理位置信息更新
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    
    [_mapview updateLocationData:userLocation];
    //NSLog(@"heading is %@",userLocation.heading);
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    [_mapview updateLocationData:userLocation];
    self.mapview.centerCoordinate = [_locationArrayM firstObject].coordinate;
    self.codinate=userLocation.location.coordinate;
    //    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
}
#pragma mark 大头针相关回调
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
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
        for (int i=0; i<_detailModel.data.pathinfos.count; i++) {
            VLXRecordDetailInfoModel *model=_detailModel.data.pathinfos[i];
            if ([title isEqualToString:model.pathname]) {
//                [annotationView createUIWithCourseModel:model];
                [annotationView createUIWithRecordLine:model];
            }
        }
        annotationView.canShowCallout=NO;
        return annotationView;
    }
    return nil;
}
-(void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    //    [self.mapview deselectAnnotation:view.annotation animated:YES];//让大头针可以重复点击
    NSLog(@"%@",view);
    
    if ([view isKindOfClass:[VLXRecordAnnotationView class]]) {
        [self.mapview deselectAnnotation:view.annotation animated:YES];//让大头针可以重复点击
        NSString *title=[view.annotation title];
        for (int i=0; i<_detailModel.data.pathinfos.count; i++) {
            VLXRecordDetailInfoModel *model=_detailModel.data.pathinfos[i];
            if ([title isEqualToString:model.pathname]) {
                if (![NSString checkForNull:model.picurl]) {//表示图片
                    VLXRecordImageDetailVC *vc=[[VLXRecordImageDetailVC alloc] init];
                    //                        vc.model=model;
                    vc.detailModel=model;
                    vc.isHiddenRight=YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                else if (![NSString checkForNull:model.videourl])//表示视频
                {
                    VLXRecordVideoDetailVC *vc=[[VLXRecordVideoDetailVC alloc] init];
                    vc.detailModel=model;
                    vc.isHiddenRight=YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                
            }
        }
        
    }
    
    
}
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
