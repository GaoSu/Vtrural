
//
//  ComposeVc_videos.m
//  Vlvxing
//
//  Created by grm on 2018/3/22.
//  Copyright © 2018年 王静雨. All rights reserved.
//

#import "ComposeVc_videos.h"


//相机相关
#import <AssetsLibrary/AssetsLibrary.h>//将拍摄好的照片写入系统相册中需要的类
#import "ZYYOSSUploader.h"//阿里


#import "ShiPinModel.h"//拍视频用

#import "HMEmotionTextView.h"

#import "VLX_fujinAreaVC.h"

@interface ComposeVc_videos ()<UITextViewDelegate,UIImagePickerControllerDelegate>
{

    UIView * VIDEO_VW;//承载视频截图的view

    UIView * areaView;//地区view,承载 小图标,地区名和箭头
    UILabel * areaLabel;//地点
    UIButton * fabiaoBt;//发表按钮

    
}

@property (nonatomic,strong)HMEmotionTextView *textVw;
@property (nonatomic, strong) NSURL *bendiURL;//本地路径
@property (nonatomic, strong) UIImage * v_Image;//视频截图
@property (nonatomic,strong)ShiPinModel *shipinModel2;

//@property (nonatomic,assign)int paiORchoose;//拍摄的1  相册选取的2


@end

@implementation ComposeVc_videos

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //接收通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NotiDynamicArea:) name:@"changeDynamicArea" object:nil];
}

-(void)NotiDynamicArea:(NSNotification * )notiif{

    NSLog(@"%@",notiif.object);
    areaLabel.text = notiif.object;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"发布视频";
    [self navUI];
    [self makeTextVw];
    [self makeVIdeoView];//放置视频的view
    [self makeAreaAndBt];//地区和按钮

}
-(void)navUI{
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 40, 20);
    [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(tapLeftButton31) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftBarButton;
}
-(void)tapLeftButton31{
    [self.navigationController popViewControllerAnimated: YES];
}

-(void)makeTextVw{
    // 1.创建输入控件
    self.textVw = [[HMEmotionTextView alloc] init];
    self.textVw.alwaysBounceVertical = YES; // 垂直方向上拥有有弹簧效果
    //    textView.frame = self.view.bounds;
    self.textVw.frame = CGRectMake(10, 10, ScreenWidth-20, 100);
    self.textVw.delegate = self;
    self.textVw.backgroundColor =rgba(235, 235, 235, 1);
    [self.view addSubview:self.textVw];
    // 2.设置提醒文字（占位文字）
    self.textVw.placehoder = @"想说的话,想发布的心情..";
    // 3.设置字体
    self.textVw.font = [UIFont systemFontOfSize:15];

    [self textViewDidChange:self.textVw];
}

#pragma mark 当textView的文字改变就会调用
- (void)textViewDidChange:(UITextView *)textView
{


    fabiaoBt.enabled = textView.hasText;
//    NSLog(@"哈S:::%d",textView.hasText);//等于1,或0
    if(textView.hasText== 1){
        [fabiaoBt setBackgroundColor:rgba(233, 84, 35, 1)];
    }
    else if(textView.hasText== 0 && _bendiURL == nil){
        [fabiaoBt setBackgroundColor:[UIColor lightGrayColor]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}




-(void)makeVIdeoView{

    VIDEO_VW = [[UIView alloc]initWithFrame:CGRectMake(10, 10+100+10, 120, 120)];
    VIDEO_VW.userInteractionEnabled = YES;
    UIImage *backGImage=[UIImage imageNamed:@"zhaoppfuben"];
    VIDEO_VW.contentMode=UIViewContentModeScaleAspectFill;
    VIDEO_VW.layer.contents=(__bridge id _Nullable)(backGImage.CGImage);
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapvideo)];
    [VIDEO_VW addGestureRecognizer:tap];



    [self.view addSubview:VIDEO_VW];
}
-(void)tapvideo{

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil  message:nil preferredStyle:UIAlertControllerStyleAlert];

    //创建提示按钮
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"拍摄" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        [self paisheshipin];//拍视频

    }];

    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"从相册选取视频" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        [self chooseVideo];//进入相册选取视频
    }];

    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"取消");
    }];

    [alertController addAction:action1];
    [alertController addAction:action2];
    [alertController addAction:action3];
    [self presentViewController:alertController animated:YES completion:nil];


}
-(void)makeAreaAndBt{

    areaView = [[UIView alloc]initWithFrame:CGRectMake(0, 10+100+10+120+10, ScreenWidth, 30)];

    UIImageView * weizhiImgVw = [[UIImageView alloc]initWithFrame:CGRectMake(15, 9, 16, 22)];
    weizhiImgVw.image = [UIImage imageNamed:@"定位（大）"];

    areaLabel = [[UILabel alloc]initWithFrame:CGRectMake(45,5,ScreenWidth-40-45-5,30)];
////areaLabel.text = @"北京";
    //定位
    [[CCLocationManager shareLocation] getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
    } withCity:^(NSString *addressString) {
        NSRange range=[addressString rangeOfString:@"市"];
#pragma mark 没有“市”此处会崩溃，需要处理
        NSString *dingweiStr;
        // 如果range的位置大于城市名称就退出方法
        if(range.location >= addressString.length) {
            dingweiStr=addressString;
        }else{
            dingweiStr=[addressString substringToIndex:range.location];
        }
        if (![NSString checkForNull:addressString]) {
            areaLabel.text=addressString;
        }
    }];
    areaLabel.font = [UIFont systemFontOfSize:15];

    UIView * TouchVw = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    TouchVw.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer * tapArea = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ToAreaList2)];
    [TouchVw addGestureRecognizer:tapArea];


    UIImageView * jiantouImgVw= [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth-40, 8, 20, 24)];
    jiantouImgVw.image = [UIImage imageNamed:@"ios—前往—大"];




    [areaView addSubview:weizhiImgVw];
    [areaView addSubview:areaLabel];
    [areaView addSubview:TouchVw];
    [areaView addSubview:jiantouImgVw];
    [self.view addSubview:areaView];


    UILabel * lineLb = [[UILabel alloc]initWithFrame:CGRectMake(15,10+100+10+120+10+30+10,ScreenWidth-30,1)];
    lineLb.backgroundColor = [UIColor lightGrayColor];

    [self.view addSubview:lineLb];


    fabiaoBt = [[UIButton alloc]initWithFrame:CGRectMake(20, 10+100+10+120+10+30+10+1+10, ScreenWidth-40, 45)];
    [fabiaoBt addTarget:self action:@selector(pressfabiaoBtBt) forControlEvents:UIControlEventTouchUpInside];
    [fabiaoBt setBackgroundColor:[UIColor lightGrayColor]];
    [fabiaoBt setTitle:@"发     表" forState:UIControlStateNormal];//5空格
    fabiaoBt.layer.cornerRadius = 7;
    fabiaoBt.layer.masksToBounds = YES;
    fabiaoBt.enabled = NO;

    [self.view addSubview:fabiaoBt];
}
-(void)ToAreaList2{
    NSLog(@"地区列表");
    VLX_fujinAreaVC * vc = [[VLX_fujinAreaVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
// 拍摄视频
-(void)paisheshipin{
    UIImagePickerController *imagePicker=[[UIImagePickerController alloc] init];
    imagePicker.delegate=self;
    //    imagePicker.allowsEditing=YES;
    NSLog(@"拍视频");
    if (![UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera]) {
        [SVProgressHUD showErrorWithStatus:@"相机不可用"];
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

//代理 imagePicker.delegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(nonnull NSDictionary<NSString *,id> *)info{

    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];

    [picker dismissViewControllerAnimated:YES completion:^{
        if ([mediaType isEqualToString:(NSString *)kUTTypeImage])//拍照
        {

        }else if([mediaType isEqualToString:(NSString *)kUTTypeMovie]){//如果是录制视频
            //        NSLog(@"video...");
            NSURL *url=[info objectForKey:UIImagePickerControllerMediaURL];//视频路径
            NSData *oldData=[NSData dataWithContentsOfURL:url];
            NSLog(@"视频原大小:%fM",(float)oldData.length / 1024 / 1024);

            _bendiURL = url;
            [self setupPhotosView];
            NSLog(@"_bendiURL:%@",_bendiURL);

            if(_bendiURL == nil && _textVw.text.length == 0){
                fabiaoBt.enabled = NO;
                [fabiaoBt setBackgroundColor:[UIColor lightGrayColor]];
            }
            else{
                fabiaoBt.enabled = YES;
                [fabiaoBt setBackgroundColor:rgba(233, 84, 35, 1)];
            }
        }


    }];


}
-(void)setupPhotosView
{
    _v_Image=[ZYYCustomTool getImage:[_bendiURL path]];
    VIDEO_VW.layer.contents=(__bridge id _Nullable)(_v_Image.CGImage);
    VIDEO_VW.layer.masksToBounds = YES;

    UIButton *playBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    playBtn.frame = CGRectMake(0, 0, 120, 120);
    [playBtn setImage:[UIImage imageNamed:@"video"] forState:UIControlStateNormal];
    [playBtn addTarget:self action:@selector(btnClickedToPlay2:) forControlEvents:UIControlEventTouchUpInside];
    [VIDEO_VW addSubview:playBtn];

}
-(void)btnClickedToPlay2:(UIButton *)sender{

    NSLog(@"播放拍摄的video");
    KYLocalVideoPlayVC *pushViewController = [[KYLocalVideoPlayVC alloc] init];
    pushViewController.title = @"短视频";
    pushViewController.URLString=[_bendiURL path];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;
    [self.navigationController pushViewController:pushViewController animated:YES];

}

-(void)pressfabiaoBtBt{//上传视频



//    if(_bendiURL == nil){//无图片时候发送的通知
//        NSLog(@"没有视频");
//    }
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString * jingdu = [NSString stringWithFormat:@"%f",[userDefaultes floatForKey:@"longtitude"]];
    NSLog(@"经度du:%@",jingdu);
    NSString * weidu = [NSString stringWithFormat:@"%f",[userDefaultes floatForKey:@"latitude"]];
    NSLog(@"纬度:%@",weidu);
    //进行视频压缩
    [SVProgressHUD showWithStatus:@"正在压缩"];
    NSLog(@"本地路径:%@",_bendiURL);
    [JFCompressionVideo compressedVideoOtherMethodWithURL:_bendiURL compressionType:AVAssetExportPresetHighestQuality compressionResultPath:^(NSString *resultPath, float memorySize, NSString *fileName) {
        NSLog(@"视频压缩后大小: %f",memorySize);
        //            NSInteger size= lroundf(memorySize);//取整
        //oss对象储存方法上传
        ZYYOSSUploader *uploader=[ZYYOSSUploader sharedInstance];
        [uploader setupEnvironment];//初始化各种设置
        [SVProgressHUD showWithStatus:@"正在上传"];
        NSLog(@"%@",resultPath);
        NSLog(@"%@",fileName);
        //往阿里传
        [uploader uploadObjectAsyncWithFileUrl:resultPath andFileName:fileName];
        uploader.uploaderBlock=^(BOOL isSuccess)
        {
            NSLog(@"视频上传是否成功:%d",isSuccess);
            if (isSuccess==1) {
                [SVProgressHUD showWithStatus:@"正在保存"];

                //传封面截图
                [ZYYOSSUploader asyncUploadImage:_v_Image complete:^(NSArray<NSString *> *names, UploadImageState state) {
                    NSLog(@"oss封面截图:%ld",state);
                    NSLog(@"oss封面截图:%@",names);
                    NSLog(@"%@",names[0]);
                    NSString * i_name= names[0];
                   // 1,打印一个对象是什么类型
                    NSLog(@"类型是啥%@", NSStringFromClass([names class]));
                    NSMutableDictionary * dic=[NSMutableDictionary dictionary];

                    dic[@"areaid"]=[NSString getAreaID];//

                    NSString * myselfUserId_0 = [userDefaultes stringForKey:@"alias"];
                    NSString *tihuanStr = [myselfUserId_0 stringByReplacingOccurrencesOfString:@"vlvxing" withString:@""];
                    NSString * myselfUserId = tihuanStr;//正式的用户id,真实的用户id
                    dic[@"userid"] =myselfUserId;
                    dic[@"pictures"] = nil;
                    if (_textVw.text.length == 0) {
                        dic[@"content"]=@"";
                    }else{
                        dic[@"content"]=[ZYYCustomTool checkNullWithNSString:_textVw.text];
                    }
                    dic[@"areaName"]=[ZYYCustomTool checkNullWithNSString:areaLabel.text];//当前地址名称
                    dic[@"lng"]=jingdu;//经度
                    dic[@"lat"] =weidu;//纬度
                    dic[@"thumbnail"]= [NSString stringWithFormat:@"%@%@",@"https://vlxingin.oss-cn-hangzhou.aliyuncs.com/",i_name];//[ZYYCustomTool checkNullWithNSString:url];//封面图
                    dic[@"videoUrl"]=[NSString stringWithFormat:@"https://vlxingout.oss-cn-hangzhou.aliyuncs.com/videoout/%@",_shipinModel2.fileName];//视频地址
                    dic[@"type"]=@"3";
                    NSString * saveUrl =[NSString stringWithFormat:@"%@%@",tang_BENDIJIEKOU_URL,@"/weibo/publish.json"];
                    NSLog(@"视频往自己服务器上传参数%@",dic);
                    ////往自己服务器传
                    [SPHttpWithYYCache postRequestUrlStr:saveUrl withDic:dic success:^(NSDictionary *requestDic, NSString *msg) {
                        [SVProgressHUD dismiss];
                        if ([requestDic[@"status"] integerValue]==1) {
                            [SVProgressHUD showSuccessWithStatus:@"保存成功"];
                            //将数据保存到model
                            VLXCourseModel *model=[[VLXCourseModel alloc] init];
                            model.lng=jingdu;
                            model.lat=weidu;
                            model.picUrl=@"";
                            model.videoUrl=[NSString stringWithFormat:@"https://vlxingout.oss-cn-hangzhou.aliyuncs.com/videoout/%@",_shipinModel2.fileName];
                            model.coverUrl=[NSString stringWithFormat:@"%@%@",@"https://vlxingin.oss-cn-hangzhou.aliyuncs.com/",i_name];//[ZYYCustomTool checkNullWithNSString:url];
                            model.time=[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
                            model.pathName=[ZYYCustomTool checkNullWithNSString:_textVw.text];
                            model.address=[ZYYCustomTool checkNullWithNSString:areaLabel.text];
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


                }];

            }
        };

        //将录制视频保存到shipinModel中
        _shipinModel2=[[ShiPinModel alloc] init];
        _shipinModel2.fileName=fileName;
        _shipinModel2.filePath=resultPath;
        _shipinModel2.pic=[ZYYCustomTool getImage:resultPath];
        _shipinModel2.isSelected=YES;

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



#pragma mark 进入相册选取视频
-(void)chooseVideo{

    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        return;
    }
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;//sourcetype有三种分别是camera，photoLibrary和photoAlbum
    NSArray *availableMedia = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];//Camera所支持的Media格式都有哪些,共有两个分别是@"public.image",@"public.movie"
    ipc.mediaTypes = [NSArray arrayWithObject:availableMedia[1]];//设置媒体类型为public.movie
    [self presentViewController:ipc animated:YES completion:nil];
    ipc.delegate = self;//

}

@end
