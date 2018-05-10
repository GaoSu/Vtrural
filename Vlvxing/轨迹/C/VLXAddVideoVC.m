//
//  VLXAddVideoVC.m
//  Vlvxing
//
//  Created by 王静雨 on 2017/6/13.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXAddVideoVC.h"
#import "ZYYOSSUploader.h"
#import "ShiPinModel.h"
@interface VLXAddVideoVC ()<UITextFieldDelegate,BMKGeoCodeSearchDelegate>
@property (nonatomic,strong)UIImageView *imageView;
@property (nonatomic,strong)UIView *titleView;
@property (nonatomic,strong)UITextField *titleTXT;//标注点名称
@property (nonatomic,copy)NSString *address;//当前地址
@property (nonatomic,strong)UIImage *image;//封面图
//@property (nonatomic,copy)NSString *videoName;//上传视频文件名
@property (nonatomic,strong)ShiPinModel *shipinModel;
/** geo搜索服务 */
@property(nonatomic,strong) BMKGeoCodeSearch *geocodesearch;
/** geo检索信息类 */
@property(nonatomic,strong)BMKGeoCodeSearchOption *geoCodeSearchOption;
@end

@implementation VLXAddVideoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    NSLog(@"%@",_location);
    [self initGeoCodeSearch];
    [self startReverseGeocode:_location.coordinate];
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _geocodesearch.delegate = nil;
    //移除观察者
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
#pragma mark---数据
/**
 *  初始化geo搜索服务
 */
- (void)initGeoCodeSearch{
    self.geocodesearch = [[BMKGeoCodeSearch alloc]init];
    self.geocodesearch.delegate=self;
    self.geoCodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
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
        
        [SVProgressHUD showWithStatus:@"正在获取当前地址"];
        MyLog(@"反geo检索发送成功");
    }else{
        
        [SVProgressHUD showErrorWithStatus:@"当前地址获取失败,请重新标注"];
        MyLog(@"反geo检索发送失败");
    }
}
#pragma mark //上传视频
-(void)postVideo//上传视频
{

        //进行视频压缩
        [SVProgressHUD showWithStatus:@"正在压缩"];
    NSLog(@"本地路径:%@",_url);
        [JFCompressionVideo compressedVideoOtherMethodWithURL:_url compressionType:AVAssetExportPresetHighestQuality compressionResultPath:^(NSString *resultPath, float memorySize, NSString *fileName) {
            NSLog(@"视频压缩后大小: %f",memorySize);
//            NSInteger size= lroundf(memorySize);//取整
            //oss对象储存方法上传
            ZYYOSSUploader *uploader=[ZYYOSSUploader sharedInstance];
            [uploader setupEnvironment];//初始化各种设置
            [SVProgressHUD showWithStatus:@"正在上传"];
            NSLog(@"%@",resultPath);
            NSLog(@"%@",fileName);
            [uploader uploadObjectAsyncWithFileUrl:resultPath andFileName:fileName];
            uploader.uploaderBlock=^(BOOL isSuccess)
            {
                NSLog(@"视频上传是否成功:%d",isSuccess);
                if (_type==1&&isSuccess==1) {
                    [SVProgressHUD showWithStatus:@"正在保存"];
                    [UploadImageTool UploadImage:_image upLoadProgress:^(float progress) {
                        NSLog(@"progress:%f",progress);
                    } successUrlBlock:^(NSString *url) {
                        NSMutableDictionary * dic=[NSMutableDictionary dictionary];
            
                        dic[@"token"]=[NSString getDefaultToken];//
                        dic[@"pathName"]=[ZYYCustomTool checkNullWithNSString:_titleTXT.text];//标注点名称
                        dic[@"address"]=[ZYYCustomTool checkNullWithNSString:_address];//当前地址名称
                        dic[@"lng"]=[NSString stringWithFormat:@"%f",_location.coordinate.longitude];//经度
                        dic[@"lat"]=[NSString stringWithFormat:@"%f",_location.coordinate.latitude];//纬度
//                        dic[@"picUrl"]=[ZYYCustomTool checkNullWithNSString:url];//图片地址（图片地址和视频地址必须有一个有值）
                        //1496832642.712460
                        dic[@"coverUrl"]=[ZYYCustomTool checkNullWithNSString:url];//封面图
                        dic[@"videoUrl"]=[NSString stringWithFormat:@"http://vlxingout.oss-cn-hangzhou.aliyuncs.com/videoout/%@",_shipinModel.fileName];//视频地址
                        dic[@"time"]=[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];//创建时间
                        NSString * saveUrl=[NSString stringWithFormat:@"%@/TraRoadController/auth/saveTravelPathInfo.html",ftpPath];
            
                        NSLog(@"视频上传成功返回OK%@",dic);
                        [SPHttpWithYYCache postRequestUrlStr:saveUrl withDic:dic success:^(NSDictionary *requestDic, NSString *msg) {
                            [SVProgressHUD dismiss];
                            if ([requestDic[@"status"] integerValue]==1) {
                                [SVProgressHUD showSuccessWithStatus:@"保存成功"];
                                //将数据保存到model
                                VLXCourseModel *model=[[VLXCourseModel alloc] init];
                                model.lng=[NSString stringWithFormat:@"%f",_location.coordinate.longitude];
                                model.lat=[NSString stringWithFormat:@"%f",_location.coordinate.latitude];
                                model.picUrl=@"";
                                model.videoUrl=[NSString stringWithFormat:@"http://vlxingout.oss-cn-hangzhou.aliyuncs.com/videoout/%@",_shipinModel.fileName];
                                model.coverUrl=[ZYYCustomTool checkNullWithNSString:url];
                                model.time=[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
                                model.pathName=[ZYYCustomTool checkNullWithNSString:_titleTXT.text];
                                model.address=[ZYYCustomTool checkNullWithNSString:_address];
                                //保存到本地
                                NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
                                NSMutableArray *eventsArray=[NSMutableArray arrayWithArray:[defaults objectForKey:@"courseSingleEvents"]];
                                NSData *data=[NSKeyedArchiver archivedDataWithRootObject:model];
                                [eventsArray addObject:data];
                                [defaults setObject:eventsArray forKey:@"courseSingleEvents"];
                                //
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                    [self.navigationController popViewControllerAnimated:YES];
                                });
                            }else
                            {
                                [SVProgressHUD showErrorWithStatus:msg];
                            }
                            
                        } failure:^(NSString *errorInfo) {
                            [SVProgressHUD dismiss];
                            
                        }];
                    } failBlock:^(NSString *error) {
                        [SVProgressHUD showErrorWithStatus:@"图片上传失败"];
                        NSLog(@"%@",error);
                    }];
                }
            };

            //将录制视频保存到shipinModel中
            _shipinModel=[[ShiPinModel alloc] init];
            _shipinModel.fileName=fileName;
            _shipinModel.filePath=resultPath;
            _shipinModel.pic=[ZYYCustomTool getImage:resultPath];
            _shipinModel.isSelected=YES;

            //将视频保存到相册  异步
            if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(resultPath)) {

                //保存视频到相簿，注意也可以使用ALAssetsLibrary来保存
                UISaveVideoAtPathToSavedPhotosAlbum(resultPath, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);//保存视频到相簿
            }
        }];
}

#pragma mark 视频保存后的回调
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error) {
        NSLog(@"保存视频过程中发生错误，错误信息:%@",error.localizedDescription);
    }else{
        NSLog(@"视频保存到相册成功.");

        
    }
}
#pragma mark---视图
-(void)createUI
{
    [self setNav];
    UIView *topView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 240)];
    topView.backgroundColor=[UIColor blackColor];
    [self.view addSubview:topView];
    _imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, topView.frame.size.height)];
    //得到封面图
    _image=[ZYYCustomTool getImage:[_url path]];
    _imageView.image=_image;
    _imageView.contentMode=UIViewContentModeScaleAspectFill;
    _imageView.layer.masksToBounds = YES;
    _imageView.userInteractionEnabled=YES;
    [topView addSubview:_imageView];
    UIButton *playBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    playBtn.center=_imageView.center;
    playBtn.bounds=CGRectMake(0, 0, 36, 36);
    [playBtn setImage:[UIImage imageNamed:@"video"] forState:UIControlStateNormal];
    [playBtn addTarget:self action:@selector(btnClickedToPlay:) forControlEvents:UIControlEventTouchUpInside];
    [_imageView addSubview:playBtn];
    //
    _titleView=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topView.frame)+8, kScreenWidth, 60)];
    _titleView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_titleView];
    _titleTXT=[[UITextField alloc] initWithFrame:CGRectMake(12, 12, kScreenWidth-12-90, _titleView.frame.size.height-12*2)];
    _titleTXT.placeholder=@"请输入标注名称";
    _titleTXT.delegate=self;
    _titleTXT.layer.cornerRadius=4;
    _titleTXT.layer.masksToBounds=YES;
    _titleTXT.layer.borderColor=[UIColor hexStringToColor:@"#999999"].CGColor;
    _titleTXT.layer.borderWidth=0.5;
    [_titleView addSubview:_titleTXT];
    UIButton *saveBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame=CGRectMake(CGRectGetMaxX(_titleTXT.frame)+15, _titleTXT.frame.origin.y, 60, _titleTXT.frame.size.height);
    saveBtn.backgroundColor=orange_color;
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    saveBtn.layer.cornerRadius=4;
    saveBtn.layer.masksToBounds=YES;
    [saveBtn addTarget:self action:@selector(btnClickedToSave:) forControlEvents:UIControlEventTouchUpInside];
    [_titleView addSubview:saveBtn];
    
}
- (void)setNav{
    
    self.title = @"编辑视频标注点";//记录模块里边的
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

#pragma mark 当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //    //获取键盘的高度
    //    NSDictionary *userInfo = [aNotification userInfo];
    //    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    //    CGRect keyboardRect = [aValue CGRectValue];
    //    int height = keyboardRect.size.height;
    [UIView animateWithDuration:0.28 animations:^{
        self.view.bounds=CGRectMake(0, 100, kScreenWidth, kScreenHeight);
    }];
    
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification{
    [UIView animateWithDuration:0.28 animations:^{
        self.view.bounds=CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    }];
}
#pragma mark---事件
-(void)btnClickedToPlay:(UIButton *)sender
{
    NSLog(@"video");
    KYLocalVideoPlayVC *pushViewController = [[KYLocalVideoPlayVC alloc] init];
    pushViewController.title = @"短视频";
    
    pushViewController.URLString=[_url path];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;
    [self.navigationController pushViewController:pushViewController animated:YES];
}
-(void)tapLeftButton
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)btnClickedToSave:(UIButton *)sender//保存记录（单个图片或视频）
{
//    if ([NSString checkForNull:_titleTXT.text]) {
//        [SVProgressHUD showInfoWithStatus:@"请填写标注点名称"];
//        return;
//    }
    NSLog(@"保存视频");
    if (_type==1) {//1表示单个点
        [self postVideo];
    }else if (_type==2)//2表示轨迹
    {
        [SVProgressHUD showWithStatus:@"正在压缩"];
        [JFCompressionVideo compressedVideoOtherMethodWithURL:_url compressionType:AVAssetExportPresetHighestQuality compressionResultPath:^(NSString *resultPath, float memorySize, NSString *fileName) {
            NSLog(@"视频压缩后大小: %f",memorySize);
            //            NSInteger size= lroundf(memorySize);//取整
            //oss对象储存方法上传
            ZYYOSSUploader *uploader=[ZYYOSSUploader sharedInstance];
            [uploader setupEnvironment];//初始化各种设置
            [SVProgressHUD showWithStatus:@"正在上传"];
            [uploader uploadObjectAsyncWithFileUrl:resultPath andFileName:fileName];
            uploader.uploaderBlock=^(BOOL isSuccess)
            {
                NSLog(@"视频上传是否成功:%d",isSuccess);
                if (isSuccess==1) {
                    [SVProgressHUD showWithStatus:@"正在保存"];
                    [UploadImageTool UploadImage:_image upLoadProgress:^(float progress) {
                        NSLog(@"%f",progress);
                    } successUrlBlock:^(NSString *url) {
                        [SVProgressHUD showSuccessWithStatus:@"保存成功"];
                        //将数据保存到model
                        VLXCourseModel *model=[[VLXCourseModel alloc] init];
                        model.lng=[NSString stringWithFormat:@"%f",_location.coordinate.longitude];
                        model.lat=[NSString stringWithFormat:@"%f",_location.coordinate.latitude];
                        model.picUrl=@"";
                        model.videoUrl=[NSString stringWithFormat:@"http://vlxingout.oss-cn-hangzhou.aliyuncs.com/videoout/%@",_shipinModel.fileName];
                        model.coverUrl=[ZYYCustomTool checkNullWithNSString:url];
                        model.time=[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
                        model.pathName=[ZYYCustomTool checkNullWithNSString:_titleTXT.text];
                        model.address=[ZYYCustomTool checkNullWithNSString:_address];
                        //保存到本地
                        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
                        NSMutableArray *eventsArray=[NSMutableArray arrayWithArray:[defaults objectForKey:@"courseEvents"]];
                        NSData *data=[NSKeyedArchiver archivedDataWithRootObject:model];
                        [eventsArray addObject:data];
                        [defaults setObject:eventsArray forKey:@"courseEvents"];
                        //
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self.navigationController popViewControllerAnimated:YES];
                        });
                    } failBlock:^(NSString *error) {
                        [SVProgressHUD showErrorWithStatus:@"图片上传失败"];
                        NSLog(@"%@",error);
                    }];
                }
                
            };
            
            //将录制视频保存到shipinModel中
            _shipinModel=[[ShiPinModel alloc] init];
            _shipinModel.fileName=fileName;
            _shipinModel.filePath=resultPath;
            _shipinModel.pic=[ZYYCustomTool getImage:resultPath];
            _shipinModel.isSelected=YES;
            
            //将视频保存到相册  异步
            if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(resultPath)) {
                
                //保存视频到相簿，注意也可以使用ALAssetsLibrary来保存
                UISaveVideoAtPathToSavedPhotosAlbum(resultPath, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);//保存视频到相簿
            }
        }];

        
        

    }
}
#pragma mark---反向地理编码
//接收反向地理编码结果
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:
(BMKReverseGeoCodeResult *)result
                        errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
        //      在此处理正常结果
        [SVProgressHUD dismiss];
        NSLog(@"%@",result);
        _address=[ZYYCustomTool checkNullWithNSString:result.sematicDescription];
    }
    else {
        [SVProgressHUD showErrorWithStatus:@"抱歉，无法获取当前地址"];
        NSLog(@"抱歉，未找到结果");
    }
}

#pragma mark---textfield delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
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
