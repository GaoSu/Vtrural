//
//  HMComposeViewController.m
//  XingJu
//
//  Created by apple on 14-7-7.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "HMComposeViewController.h"
#import "HMEmotionTextView.h"
#import "HMComposeToolbar.h"
#import "HMComposePhotosView.h"
#import "HMAccountTool.h"
#import "HMAccount.h"
#import "MBProgressHUD+MJ.h"
#import "HMEmotion.h"
#import "HMEmotionKeyboard.h"

#import "YMTool.h"
#import "AFNetworking.h"
//谭
#import "TZImagePickerController.h"
#import "UIView+Layout.h"
#import "TZTestCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "LxGridViewFlowLayout.h"
#import "TZImageManager.h"
#import "TZVideoPlayerController.h"

#import "ZYYOSSUploader.h"//阿里oss

#import "VLXCityChooseVC.h"
#import "VLX_fujinAreaVC.h"

#define EMOJI_CODE_TO_SYMBOL(x) ((((0x808080F0 | (x & 0x3F000) >> 4) | (x & 0xFC0) << 10) | (x & 0x1C0000) << 18) | (x & 0x3F) << 24);

@interface HMComposeViewController () <HMComposeToolbarDelegate, UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIActionSheetDelegate,TZImagePickerControllerDelegate>
{
    HMEmotionTextView *textView;
    //    UIView * imgVw;//放置选择好的单张图片
    NSMutableArray * imgArray;//放置选择好的图片数组(废弃)
    
    NSMutableArray *_selectedPhotos;//已经选好的图片数组
    NSMutableArray *_selectedAssets;//已经选好的图片的标识
    BOOL _isSelectOriginalPhoto;
    CGFloat _itemWH;
    CGFloat _margin;
    
    TZImagePickerController *imagePickerVcc;
    UIButton * selectBt;
    
    UIImageView * videoVw;//专门用来放置单一一个视频的控件
    NSMutableArray * _seletedVideo;//已经选好的视频
    
    UIImageView *videoImg;//作品缩略图小图
    
    //    NSString*_fileUrl;//视频路径使用filePath代替
    NSString*myVedio;//1 选择视频列表  0录制或 1本地
    NSMutableArray * imgdataArray;//存放上传图片返回的data字段
    
    NSString * videoId;//返回的两个东西
    NSString * videoUnique;

    UIView * areaView;//地区view,承载小图标,地区名和箭头
    UILabel * areaLabel;//地点
    UIButton * fabiaoBt;//发表按钮

    NSString * userID_ture;//正式的userid,其他可更换
    
    
}
@property (nonatomic, retain) NSMutableArray *imageArrry;;//放置选择好的图片数组(备用)

@property (nonatomic, weak) HMEmotionTextView *HM_textView;
@property (nonatomic, weak) HMComposeToolbar *toolbar;
@property (nonatomic, weak) HMComposePhotosView *photosView;
@property (nonatomic, strong) HMEmotionKeyboard *kerboard;
//谭
@property (nonatomic, strong) UICollectionView *collectionView;
//视频
//@property (nonatomic, strong) LECUploader *uploader;
@property (nonatomic, strong) NSString *filePath;
@property (nonatomic, strong) NSString *type;
@property(nonatomic,strong) NSProgress *progress;//上传视频的进度条



@property (nonatomic,strong) UIProgressView *uploadProgress;
@property (nonatomic,strong) UILabel *completeMessage;
@property (nonatomic,strong) UITextView *tokenTextview;
@property (nonatomic,strong) UILabel *videoIdLable;
@property (nonatomic,strong) UILabel *videoUniqueLabel;
@property (nonatomic,strong) UILabel *percentLabel;
@property (nonatomic,strong) UILabel *fileSizeLabel;
@property (nonatomic,strong) UILabel *rateLabel;


@property (nonatomic,strong) UITextField *userUniqueTextfield;
@property (nonatomic,strong) UITextField *secretKeyTextfield;

@property (nonatomic,strong) UIButton *backBtn;
@property (nonatomic,strong) UIButton *uploadBtn;
//
@property(nonatomic,strong)UIWindow *window;//点击弹出的泡泡窗口

//测试demo上传多张图片
//  上传图片数组
@property (nonatomic, strong)NSArray *picArray;
//  上传图片字典
@property (nonatomic, strong)NSMutableDictionary *picDictionary;



/**
 *  是否正在切换键盘
 */
@property (nonatomic, assign, getter = isChangingKeyboard) BOOL changingKeyboard;
@end

@implementation HMComposeViewController
//懒加载，只在需要的时候才分配内存
- (NSMutableArray *)imageArrry{
    if (_imageArrry == nil) {
        _imageArrry = [NSMutableArray array];
    }
    return _imageArrry;
}
//-(void)dealloc
//{//移除观察者
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changeCity" object:nil];
//}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //接收通知

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NotiDynamicArea:) name:@"changeDynamicArea" object:nil];

}

-(void)NotiDynamicArea:(NSNotification * )notiif{
    
    NSLog(@"%@",notiif.object);
    areaLabel.text = notiif.object;
}
//-(void)notifyToChangeCity3:(NSNotification *)notify
//{
//    areaLabel.text=[NSString getCity];
//}

#pragma mark - 初始化方法
- (HMEmotionKeyboard *)kerboard
{
    if (!_kerboard) {
        self.kerboard = [HMEmotionKeyboard keyboard];
        self.kerboard.width = ScreenWidth;
        self.kerboard.height = 216;
    }
    return _kerboard;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString * myselfUserId_0 = [userDefaultes stringForKey:@"alias"];
    NSString *userID = [myselfUserId_0 stringByReplacingOccurrencesOfString:@"vlvxing" withString:@""];

    userID_ture = userID;///[userDefaultes stringForKey:@"userid"];;
    NSLog(@"userid:%@",userID_ture);

    CGFloat rgb = 244 / 255.0;
    self.view.backgroundColor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:1.0];


    imgdataArray = [NSMutableArray array];//
    
    self.automaticallyAdjustsScrollViewInsets = NO;//让textView文字居顶显示
    // 设置导航条内容
    [self setupNavBar];
    
    // 添加输入控件
    [self setupTextView];
    
    // 添加工具条
    //[self setupToolbar];
//    [self startReverseGeocode:_location.coordinate];//经纬

    
    // 添加显示图片的相册控件
    [self setupPhotosView];
    
    // 监听表情选中的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionDidSelected:) name:HMEmotionDidSelectedNotification object:nil];
    // 监听删除按钮点击的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionDidDeleted:) name:HMEmotionDidDeletedNotification object:nil];
    
    
    //这是通知的必写方法(上传视频传值用)
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(Receive:) name:@"ChuanZhiBa" object:nil];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(upServerData) name:@"tupiandeshuzu" object:nil];//方法是直接网自己服务器传

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(upServerData) name:@"wutupiantongzhi" object:nil];//方法是直接网自己服务器传
}

#pragma mark 添加显示图片的相册控件
- (void)setupPhotosView
{


    CGFloat videoVw_High = 0.0f;
//    if(self.tags == 1){
//        videoVw_High= 0.0f;//(ScreenWidth-100)*9/16;
////        }
//    else if(self.tags == 0){
//        videoVw_High=0.0f;
//    }

    //显示视频的View
    videoVw = [[UIImageView alloc]initWithFrame:CGRectMake(0, 86, (ScreenWidth-16)/3, videoVw_High)];
    videoVw.backgroundColor = rgba(230, 230, 230, 1);//[UIColor lightGrayColor];
    [self.view addSubview:videoVw];

    //显示图片的View
    _fangzhiimgVw = [[UIView alloc]init];//WithFrame:CGRectMake(0, 86+videoVw.height, ScreenWidth, _itemWH*2+10)];
    LxGridViewFlowLayout *layout = [[LxGridViewFlowLayout alloc] init];
    _margin = 4;
    _itemWH = (self.view.tz_width - 2 * _margin - 4) / 3 - _margin;
    _fangzhiimgVw.frame = CGRectMake(0, 86+videoVw.height, ScreenWidth, _itemWH*2+10);
    layout.itemSize = CGSizeMake(_itemWH, _itemWH);
    layout.minimumInteritemSpacing = _margin;
    layout.minimumLineSpacing = _margin;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.tz_width, _itemWH*2+10) collectionViewLayout:layout];
    NSLog(@"宽度:::%f",self.view.tz_width);
    CGFloat rgb = 244 / 255.0;
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.bounces = NO;//无弹簧效果
    _collectionView.scrollEnabled = NO;

    _collectionView.backgroundColor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:1.0];
    _collectionView.contentInset = UIEdgeInsetsMake(4, 4, 4, 4);
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [_fangzhiimgVw addSubview:_collectionView];
    [_collectionView registerClass:[TZTestCell class] forCellWithReuseIdentifier:@"TZTestCell"];
    [self.view addSubview:videoVw];
    [self.view addSubview:_fangzhiimgVw];


    areaView = [[UIView alloc]initWithFrame:CGRectMake(0, 86+videoVw.height+_itemWH+6, ScreenWidth, 135)];
//    areaView.backgroundColor = rgba(220, 220, 220, 1);
    areaView.userInteractionEnabled = YES;
//    UITapGestureRecognizer * tapArea = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ToAreaList)];
//    [areaView addGestureRecognizer:tapArea];
    //1
    UIImageView * weizhiImgVw = [[UIImageView alloc]initWithFrame:CGRectMake(15, 9, 16, 22)];
    weizhiImgVw.image = [UIImage imageNamed:@"定位（大）"];
    //2
    areaLabel = [[UILabel alloc]initWithFrame:CGRectMake(45,5,ScreenWidth-40-45-5,30)];
    //    areaLabel.text = @"北京";
    areaLabel.font = [UIFont systemFontOfSize:15];

    UIView * TouchVw = [[UIView alloc]initWithFrame:CGRectMake(0, 5, ScreenWidth, 30)];
    TouchVw.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer * tapArea = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ToAreaList)];
    [TouchVw addGestureRecognizer:tapArea];

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
    //3
    UIImageView * jiantouImgVw= [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth-40, 8, 20, 24)];
    jiantouImgVw.image = [UIImage imageNamed:@"ios—前往—大"];

    UILabel * lineLb = [[UILabel alloc]initWithFrame:CGRectMake(15, 45, ScreenWidth-30, 1)];
    lineLb.backgroundColor = [UIColor lightGrayColor];

    fabiaoBt = [[UIButton alloc]initWithFrame:CGRectMake(20, 54, ScreenWidth-40, 45)];
    [fabiaoBt addTarget:self action:@selector(pressfabiaoBtBt) forControlEvents:UIControlEventTouchUpInside];
    [fabiaoBt setBackgroundColor:[UIColor lightGrayColor]];//rgba(233, 84, 35, 1)];
    [fabiaoBt setTitle:@"发     表" forState:UIControlStateNormal];//5空格
    fabiaoBt.layer.cornerRadius = 7;
    fabiaoBt.layer.masksToBounds = YES;
    fabiaoBt.enabled = NO;


    [areaView addSubview:weizhiImgVw];
    [areaView addSubview:areaLabel];
    [areaView addSubview:TouchVw];
    [areaView addSubview:jiantouImgVw];
    [areaView addSubview:lineLb];
    [areaView addSubview:fabiaoBt];
    [self.view addSubview:areaView];

    
}

#pragma mark 跳转地区列表
-(void)ToAreaList{
    NSLog(@"地区列表");
//    VLXCityChooseVC * city=[[VLXCityChooseVC alloc]init];

    VLX_fujinAreaVC * city = [[VLX_fujinAreaVC alloc]init];
    [self.navigationController pushViewController:city animated:YES];
}

#pragma mark 上传视频获取视频的第一帧作为封面
- (UIImage*) thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time {
    //转码配置

    NSLog(@"转码配置");
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    NSParameterAssert(asset);
    //取出视频的每一帧图片(AVAssetImageGenerator,关键帧)
    AVAssetImageGenerator *assetImageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    //应用方向(按正确方向)
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    //光圈模式 =
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60) actualTime:NULL error:&thumbnailImageGenerationError];
    
    if (!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@", thumbnailImageGenerationError);
    
    UIImage *thumbnailImage = thumbnailImageRef ? [[UIImage alloc] initWithCGImage:thumbnailImageRef] : nil;
    
    return thumbnailImage;
}



#pragma mark UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
     NSLog(@"到底多少行::%ld",_selectedPhotos.count+1);

    ///*

    if (_selectedPhotos.count+1 >1) {
    //        NSLog(@"有了图片");
    fabiaoBt.enabled = YES;
    [fabiaoBt setBackgroundColor:rgba(233, 84, 35, 1)];
    }else if(_selectedPhotos.count+1 == 1 && textView.text.length == 0){
        [fabiaoBt setBackgroundColor:[UIColor lightGrayColor]];
    }
    //*/

    if (_selectedPhotos.count+1>3){
        areaView.frame = CGRectMake(0, 86+videoVw.height+(_itemWH+8)*2, ScreenWidth, 135);
    }
    else{
        areaView.frame = CGRectMake(0, 86+videoVw.height+_itemWH+8, ScreenWidth, 135);
    }
    return _selectedPhotos.count + 1;

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TZTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZTestCell" forIndexPath:indexPath];
    cell.videoImageView.hidden = YES;
    if (indexPath.row == _selectedPhotos.count) {
        cell.imageView.image = [UIImage imageNamed:@"zhaoppfuben"];
        cell.deleteBtn.hidden = YES;
    } else {
        cell.imageView.image = _selectedPhotos[indexPath.row];
        cell.asset = _selectedAssets[indexPath.row];
        cell.deleteBtn.hidden = NO;
    }
    cell.deleteBtn.tag = indexPath.row;
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
//点击cell方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _selectedPhotos.count) {
        [self pushImagePickerController:_tags];
        [self.view endEditing:YES];//关闭键盘方法
    } else { // preview photos or video / 预览照片或者视频
        id asset = _selectedAssets[indexPath.row];
        BOOL isVideo = NO;
        if ([asset isKindOfClass:[PHAsset class]]) {
            PHAsset *phAsset = asset;
            isVideo = phAsset.mediaType == PHAssetMediaTypeVideo;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        } else if ([asset isKindOfClass:[ALAsset class]]) {
            ALAsset *alAsset = asset;
            isVideo = [[alAsset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo];
#pragma clang diagnostic pop
        }
        if (isVideo) { // perview video / 预览视频
            TZVideoPlayerController *vc = [[TZVideoPlayerController alloc] init];
            TZAssetModel *model = [TZAssetModel modelWithAsset:asset type:TZAssetModelMediaTypeVideo timeLength:@""];
            vc.model = model;
            [self presentViewController:vc animated:YES completion:nil];
        } else { // preview photos / 预览照片
            TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:_selectedAssets selectedPhotos:_selectedPhotos index:indexPath.row];
            //            imagePickerVc.maxImagesCount = self.maxCountTF.text.integerValue;
            imagePickerVc.maxImagesCount = 6;//你最多只能选择n张照片
            //            imagePickerVc.allowPickingOriginalPhoto = self.allowPickingOriginalPhotoSwitch.isOn;
            imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
            [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
                _selectedPhotos = [NSMutableArray arrayWithArray:photos];
                NSLog(@"数组里边%@",_selectedPhotos );
                _selectedAssets = [NSMutableArray arrayWithArray:assets];
                _isSelectOriginalPhoto = isSelectOriginalPhoto;
                [_collectionView reloadData];
                _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
            }];
            [self presentViewController:imagePickerVc animated:YES completion:nil];
        }
    }
}

//点击加号进入相册
-(void)pushImagePickerController:(int)tags{
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            return;
        }
        imagePickerVcc = [[TZImagePickerController alloc] initWithMaxImagesCount:6 columnNumber:3 delegate:self pushPhotoPickerVc:YES];
#pragma mark - 四类个性化设置，这些参数都可以不传，此时会走默认设置
        imagePickerVcc.isSelectOriginalPhoto = _isSelectOriginalPhoto;

        //    if (self.maxCountTF.text.integerValue > 1) {
        // 1.设置目前已经选中的图片数组
        imagePickerVcc.selectedAssets = _selectedAssets; // 目前已经选中的图片数组
        //    }
        // 在内部显示拍照按钮
        imagePickerVcc.allowTakePicture = YES;
        // 3. 设置是否可以选择视频/图片/原图
        imagePickerVcc.allowPickingVideo = NO;//是否允许选择视频
        imagePickerVcc.allowPickingImage = YES;
        imagePickerVcc.allowPickingOriginalPhoto = YES;

        // 4. 照片排列按修改时间升序
        imagePickerVcc.sortAscendingByModificationDate = YES;
#pragma mark - 到这里为止

        // 你可以通过block或者代理，来得到用户选择的照片.
        [imagePickerVcc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {

        }];
        [self presentViewController:imagePickerVcc animated:YES completion:nil];

}


- (void)pushImagePickerControllerZanshi{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        return;
    }

    //最多选九个,每行三个
    imagePickerVcc = [[TZImagePickerController alloc] initWithMaxImagesCount:6 columnNumber:3 delegate:self pushPhotoPickerVc:YES];

    imagePickerVcc.navigationBar.hidden = YES;
    
    UIView  * vieW = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    vieW.backgroundColor = [UIColor colorWithWhite:0.3 alpha:1];
    
    UIButton * backBt = [[UIButton alloc]initWithFrame:CGRectMake(10, 15, 25, 25)];
    selectBt = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth/2.0 - 35,15, 100, 25)];
    selectBt.backgroundColor = [UIColor grayColor];
    selectBt.layer.cornerRadius = 4;
    UIButton * cancelBt = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-35, 15, 25, 25)];
    [backBt setTitle:@"返回" forState:UIControlStateNormal];
    [selectBt setTitle:@"选择" forState:UIControlStateNormal];
    [cancelBt setTitle:@"取消" forState:UIControlStateNormal];
    [backBt addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [selectBt addTarget:self action:@selector(selectClick) forControlEvents:UIControlEventTouchUpInside];
    [cancelBt addTarget:self action:@selector(cancleClick) forControlEvents:UIControlEventTouchUpInside];
    
    [vieW addSubview:backBt];
    [vieW addSubview:selectBt];
    [vieW addSubview:cancelBt];
    
    _window = [[UIWindow alloc]initWithFrame:CGRectMake(ScreenWidth/2 - 90, 54, 180, 105)];
    _window.windowLevel = UIWindowLevelAlert+1;
    [_window makeKeyAndVisible];
    CGFloat rgb = 244 / 255.0;
    _window.backgroundColor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:1.0];
    _window.hidden=YES;
    
    [imagePickerVcc.view addSubview:_window];
    
    [imagePickerVcc.view addSubview:vieW];
    //弹出的控件的几个方法
    UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(40, 0, 30, 15)];
    [_window addSubview:img];
    img.image=[UIImage imageNamed:@"shareAndCollectArrow"];//小三角△图像
    
    UIView *bg=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(img.frame), _window.width, _window.height-img.height)];
    [_window addSubview:bg];
    bg.backgroundColor=[UIColor colorWithRed:84/255.0 green:84/255.0 blue:84/255.0 alpha:1.0];
    bg.layer.cornerRadius=3;
    
    UIButton *shareBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, bg.width, bg.height/2)];
    [bg addSubview:shareBtn];
    [shareBtn setTitle:@"选择图片" forState:UIControlStateNormal];
    shareBtn.titleLabel.font=[UIFont systemFontOfSize:16];
    //    _videoBtn=shareBtn;
    [shareBtn addTarget:self action:@selector(imgBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(shareBtn.frame), bg.width, 0.5)];
    [bg addSubview:line];
    line.backgroundColor=[UIColor whiteColor];
    
    UIButton *collectBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(line.frame), shareBtn.width, shareBtn.height-1)];
    [bg addSubview:collectBtn];
    [collectBtn setTitle:@"选择视频" forState:UIControlStateNormal];
    collectBtn.titleLabel.font=[UIFont systemFontOfSize:16];
    [collectBtn addTarget:self action:@selector(videoBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _window.hidden=YES;

    
    
    
#pragma mark - 四类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVcc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
    
    //    if (self.maxCountTF.text.integerValue > 1) {
    // 1.设置目前已经选中的图片数组
    imagePickerVcc.selectedAssets = _selectedAssets; // 目前已经选中的图片数组
    //    }
    //    imagePickerVc.allowTakePicture = self.showTakePhotoBtnSwitch.isOn; // 在内部显示拍照按钮
    imagePickerVcc.allowTakePicture = YES;
    // 2. 在这里设置imagePickerVc的外观
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVcc.allowPickingVideo = NO;//是否允许选择视频
    imagePickerVcc.allowPickingImage = YES;
    imagePickerVcc.allowPickingOriginalPhoto = YES;
    
    // 4. 照片排列按修改时间升序
    imagePickerVcc.sortAscendingByModificationDate = YES;
#pragma mark - 到这里为止
    
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVcc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
    }];
    
    [self presentViewController:imagePickerVcc animated:YES completion:nil];
}
//导航条三个按钮方法
-(void)backClick
{
    [imagePickerVcc dismissViewControllerAnimated:YES completion:nil];
}
-(void)cancleClick
{
    [imagePickerVcc dismissViewControllerAnimated:YES completion:nil];
}
-(void)selectClick{
    _window.hidden = NO;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    _window.hidden=YES;
}
//点击发布图片按钮
-(void)imgBtnClick
{
    //最多选九个,每行三个
    imagePickerVcc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 columnNumber:3 delegate:self pushPhotoPickerVc:YES];
    imagePickerVcc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
    // 1.设置目前已经选中的图片数组
    imagePickerVcc.selectedAssets = _selectedAssets; // 目前已经选中的图片数组
    // 在内部显示拍照按钮
    imagePickerVcc.allowTakePicture = YES;
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVcc.allowPickingVideo = NO;//是否允许选择视频
    imagePickerVcc.allowPickingImage = YES;//是否允许选择图片
    imagePickerVcc.allowPickingOriginalPhoto = YES;
    // 4. 照片排列按修改时间升序
    imagePickerVcc.sortAscendingByModificationDate = YES;
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVcc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
    }];

    _window.hidden=YES;
    [selectBt setTitle:@"选择图片" forState:UIControlStateNormal];
    
}

//从拍照、图库、相册获取图片
- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:6 delegate:self];
        tzImagePickerVc.sortAscendingByModificationDate = YES;
        [tzImagePickerVc showProgressHUD];
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        // save photo and get asset / 保存图片，获取到asset
        [[TZImageManager manager] savePhotoWithImage:image completion:^(NSError *error){
            if (error) {
                [tzImagePickerVc hideProgressHUD];
                NSLog(@"图片保存失败 %@",error);
            } else {
                [[TZImageManager manager] getCameraRollAlbum:NO allowPickingImage:YES completion:^(TZAlbumModel *model) {
                    [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:NO allowPickingImage:YES completion:^(NSArray<TZAssetModel *> *models) {
                        [tzImagePickerVc hideProgressHUD];
                        TZAssetModel *assetModel = [models firstObject];
                        if (tzImagePickerVc.sortAscendingByModificationDate) {
                            assetModel = [models lastObject];
                        }
                        [_selectedAssets addObject:assetModel.asset];
                        [_selectedPhotos addObject:image];

                        [_collectionView reloadData];
                    }];
                }];
            }
        }];
        //压缩,写入,获取路径完成之后,直接从相册压缩界面自动返回上个界面
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
    if ([type isEqualToString:@"public.movie"])//视频
    {
        // 1.如果这个是图片类型,则执行...
        if ([info[UIImagePickerControllerMediaType] isEqualToString:@"public.image"]) {
            
            UIImage *image = info[UIImagePickerControllerOriginalImage];//封面图片
            videoVw.image=image;//小缩略图
            
        }else{//NSLog(@"视频类型"); //否则就是视频类型
        }
        videoVw.frame = CGRectMake(8, 86, (ScreenWidth-16)/3, (ScreenWidth-16)/3);
        [_fangzhiimgVw removeFromSuperview];
        areaView.frame = CGRectMake(0,86+videoVw.height+16, ScreenWidth, 135);
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if ([picker isKindOfClass:[UIImagePickerController class]]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}
//将选的图片刷新到contentView里边
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    _selectedPhotos = [NSMutableArray arrayWithArray:photos];
    _selectedAssets = [NSMutableArray arrayWithArray:assets];
    _isSelectOriginalPhoto = isSelectOriginalPhoto;
    [_collectionView reloadData];
}

#pragma mark - LxGridViewDataSource
/// 以下三个方法为长按排序相关代码
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.item < _selectedPhotos.count;
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath canMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    return (sourceIndexPath.item < _selectedPhotos.count && destinationIndexPath.item < _selectedPhotos.count);
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath didMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    UIImage *image = _selectedPhotos[sourceIndexPath.item];
    [_selectedPhotos removeObjectAtIndex:sourceIndexPath.item];
    [_selectedPhotos insertObject:image atIndex:destinationIndexPath.item];
    
    id asset = _selectedAssets[sourceIndexPath.item];
    [_selectedAssets removeObjectAtIndex:sourceIndexPath.item];
    [_selectedAssets insertObject:asset atIndex:destinationIndexPath.item];
    [_collectionView reloadData];
}
//删除按钮
- (void)deleteBtnClik:(UIButton *)sender {
    [_selectedPhotos removeObjectAtIndex:sender.tag];
    [_selectedAssets removeObjectAtIndex:sender.tag];

    NSString *fileName;
    BOOL hasViode = NO;
    for (id asset in _selectedAssets) {
        if ([asset isKindOfClass:[PHAsset class]]) {
            PHAsset *phAsset = (PHAsset *)asset;
            fileName = [phAsset valueForKey:@"filename"];
        } else if ([asset isKindOfClass:[ALAsset class]]) {
            ALAsset *alAsset = (ALAsset *)asset;
            fileName = alAsset.defaultRepresentation.filename;;
        }
        if([fileName rangeOfString:@".mp4"].location !=NSNotFound || [fileName rangeOfString:@".MOV"].location !=NSNotFound)
        {
            NSLog(@"还存在视频");
            hasViode = YES;
        }
        NSLog(@"图片名字:%@",fileName);
    }
    if (hasViode == YES) {
        NSLog(@"存在视频,那么不能继续添加了");
        [[NSUserDefaults standardUserDefaults]setObject:@"NO" forKey:@"CanAdd"];
    }else if (hasViode == NO){
        NSLog(@"不存在视频,那么可以继续添加");
        [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:@"CanAdd"];
    }
    [_collectionView performBatchUpdates:^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag inSection:0];
        [_collectionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        [_collectionView reloadData];
    }];
}
// 添加工具条
- (void)setupToolbar
{
    // 1.创建
    HMComposeToolbar *toolbar = [[HMComposeToolbar alloc] init];
    toolbar.width = self.view.width;
    toolbar.delegate = self;
    toolbar.height = 44;
    self.toolbar = toolbar;
    
    // 2.显示
    toolbar.y = self.view.height - toolbar.height;
    [self.view addSubview:toolbar];
}

// 添加输入控件
- (void)setupTextView
{
    // 1.创建输入控件
    textView = [[HMEmotionTextView alloc] init];
    textView.alwaysBounceVertical = YES; // 垂直方向上拥有有弹簧效果
    //    textView.frame = self.view.bounds;
    textView.frame = CGRectMake(0, 0, ScreenWidth, 160/2);
    textView.delegate = self;
    textView.backgroundColor =[UIColor whiteColor];//yellowColor];
    [self.view addSubview:textView];
    self.HM_textView = textView;
    // 2.设置提醒文字（占位文字）
    textView.placehoder = @"想说的话,想发布的心情..";
    // 3.设置字体
    textView.font = [UIFont systemFontOfSize:15];
    
    // 4.监听键盘
    // 键盘的frame(位置)即将改变, 就会发出UIKeyboardWillChangeFrameNotification
    // 键盘即将弹出, 就会发出UIKeyboardWillShowNotification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    // 键盘即将隐藏, 就会发出UIKeyboardWillHideNotification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changeCity" object:nil];
}

//view显示完毕的时候再弹出键盘，避免显示控制器view的时候会卡住
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // 成为第一响应者（叫出键盘）
    [self.HM_textView becomeFirstResponder];
}

// 设置导航条内容
- (void)setupNavBar
{
    NSString *name = [HMAccountTool account].name;
    if (name) {
        // 构建文字
        NSString *prefix = @"编辑内容";
        NSString *text = [NSString stringWithFormat:@"%@\n%@", prefix, name];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:text];
        [string addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:15] range:[text rangeOfString:prefix]];
        [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:[text rangeOfString:name]];
        
        // 创建label
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.attributedText = string;
        titleLabel.numberOfLines = 0;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.width = 100;
        titleLabel.height = 44;
        self.navigationItem.titleView = titleLabel;
    } else {
        self.title = @"编辑内容";
    }
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel)];
}
#pragma mark 取消
- (void)cancel
{
    [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:@"CanAdd"];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark 发表;
- (void)pressfabiaoBtBt
{
    [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:@"CanAdd"];
    [self sendStatusWithImage];
}
//懒
-(NSMutableDictionary *)picDictionary
{
    if (_picDictionary == nil) {
        _picDictionary = [NSMutableDictionary dictionary];
    }
    return _picDictionary;
}
- (NSArray *)picArray {
    if (_picArray == nil) {
        _picArray = [NSArray array];
    }
    return _picArray;
}
// *  发表有图片的微博
#pragma mark - 点击了发布按钮,
- (void)sendStatusWithImage
{
    //文件上传的思路:关键是在判断上传的对象的数据类型,数据源为_selectedPhotos,其中装的对象是image(统称),判断完之后通过判断语句选择不同的代码上传
    if(_selectedPhotos.count==0){//无图片时候发送的通知
        [[NSNotificationCenter defaultCenter]postNotificationName:@"wutupiantongzhi" object:nil];
    }
    else{//有图片
    [SVProgressHUD showWithStatus:@"正在处理图片"];
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.requestSerializer =[AFJSONRequestSerializer serializer];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
////     manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions: NSJSONReadingMutableContainers];
//    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json",@"text/html",@"text/plain", nil]];
    //压缩图片
    NSData *imageDate = nil;
//    NSString * url = [NSString stringWithFormat:@"%@%@",tang_BENDIJIEKOU_URL,@"/ckeditorUpload/uploadImage.json"];

    for (UIImage * image in _selectedPhotos){
        imageDate = UIImageJPEGRepresentation(image, 0.5);
        //使用日期生成图片名称
        NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat = @"yyyyMMddHHmmssSSSS";


        [ZYYOSSUploader asyncUploadImage:image complete:^(NSArray<NSString *> *names, UploadImageState state) {
            if (state == 1) {
                NSString * i_nameA = names[0];
                NSString * i_nameB = [NSString stringWithFormat:@"%@%@",@"https://vlxingin.oss-cn-hangzhou.aliyuncs.com/",i_nameA];//拼接成完整的名字,该名字就是服务器的图片路径,可直接访问
                [imgdataArray addObject:i_nameB];
                if (_selectedPhotos.count == imgdataArray.count){
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"tupiandeshuzu" object:imgdataArray];
                }
            }
            else{
                [SVProgressHUD dismiss];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];


//        NSString * fileName = [NSString stringWithFormat:@"%@.png",[formatter stringFromDate:[NSDate date]]];
//        [manager POST: url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//            [formData appendPartWithFileData:imageDate name:@"upload" fileName:fileName mimeType:@"image/*"];
//        } progress:^(NSProgress * _Nonnull uploadProgress) {
//            CGFloat progress = 100.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
//            NSLog(@"进度:%.3lf%%",progress);
//        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            NSLog(@"动态图片上传成功%@",responseObject);
//            NSString * imgdata = responseObject[@"data"];
////            NSLog(@"responseObject[data]::%@",responseObject[@"data"][0]);
//            NSString * zfc = [NSString stringWithFormat:@"%@",imgdata];
//            [imgdataArray addObject:zfc];
//            if (_selectedPhotos.count == imgdataArray.count){
//                [[NSNotificationCenter defaultCenter]postNotificationName:@"tupiandeshuzu" object:imgdataArray];
//                [SVProgressHUD dismiss];
//            }
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
////            NSLog(@"动态图片上传失败==%@",error);
//            [SVProgressHUD dismiss];
//            [self.navigationController popViewControllerAnimated:YES];
//        }];
    }
    }
}

#pragma mark - 键盘处理
//键盘即将隐藏
- (void)keyboardWillHide:(NSNotification *)note
{
    if (self.isChangingKeyboard) return;
    // 1.键盘弹出需要的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 2.动画
    [UIView animateWithDuration:duration animations:^{
        self.toolbar.transform = CGAffineTransformIdentity;
    }];
}

///键盘即将弹出
- (void)keyboardWillShow:(NSNotification *)note
{
    // 1.键盘弹出需要的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];

    // 2.动画
    [UIView animateWithDuration:duration animations:^{
        // 取出键盘高度
        CGRect keyboardF = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGFloat keyboardH = keyboardF.size.height;
        self.toolbar.transform = CGAffineTransformMakeTranslation(0, - keyboardH);
    }];
}

#pragma mark - UITextViewDelegate
//当用户开始拖拽scrollView时调用
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

//当textView的文字改变就会调用
- (void)textViewDidChange:(UITextView *)textView
{
    fabiaoBt.enabled = textView.hasText;
    NSLog(@"哈S:::%d",textView.hasText);//等于1,或0
    if(textView.hasText== 1){
        [fabiaoBt setBackgroundColor:rgba(233, 84, 35, 1)];
    }else if(textView.hasText== 0 && _selectedPhotos.count == 0){
        [fabiaoBt setBackgroundColor:[UIColor lightGrayColor]];
    }
}

//将得到的图片参数发送到自己公司服务器
-(void)upServerData{

//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    NSString * url = [NSString stringWithFormat:@"%@%@",tang_BENDIJIEKOU_URL,@"/weibo/publish.json"];
    NSMutableDictionary * parametes = [NSMutableDictionary dictionary];
    parametes[@"videoUrl"] = nil;
    parametes[@"thumbnail"] = nil;
    if(imgdataArray.count==0){
        parametes[@"pictures"] = nil;
    }
    else{
        NSString * pictureString = [[NSString alloc]init];
        pictureString = [imgdataArray componentsJoinedByString:@","];
        NSLog(@"分割后的字符串::%@",pictureString);
        parametes[@"pictures"] = pictureString;
        parametes[@"type"] = @"2";//图片
    }

    if(imgdataArray.count==0 && videoId == nil){
        parametes[@"type"] = @"1";//纯文字
    }

    if (textView.text.length == 0) {
        parametes[@"content"] = @"";
    }else{

        NSString *priceStr=textView.text;
        NSMutableAttributedString *attStr=[[NSMutableAttributedString alloc] initWithString:priceStr];

        NSData *data = [attStr dataFromRange:NSMakeRange(0, attStr.length) documentAttributes:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} error:nil];
        NSString *html = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"html=%@",html);

        NSRange range = [html rangeOfString:@"<p class"];//匹配得到的下标
        NSLog(@"rang:%@",NSStringFromRange(range));
        html = [html substringFromIndex:range.location];
        NSLog(@"前截取的值为：%@",html);
        NSRange range2 = [html rangeOfString:@"\n</body>"];
        html = [html substringToIndex:range2.location];
        NSLog(@"后截取的值为：%@",html);

        NSLog(@"转码字符串:%@", [self stringReplaceWithFace:priceStr]);
//        NSString * HTML2 = [self stringReplaceWithFace:html];


        parametes[@"content"]= html;
    }
    //获取经纬度
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString * jingdu = [NSString stringWithFormat:@"%f",[userDefaultes floatForKey:@"longtitude"]];
    NSString * weidu = [NSString stringWithFormat:@"%f",[userDefaultes floatForKey:@"latitude"]];

    parametes[@"lng"] = jingdu;//经度
    parametes[@"lat"] = weidu;//纬度

    NSString * myselfUserId_0 = [userDefaultes stringForKey:@"alias"];
    NSString *tihuanStr = [myselfUserId_0 stringByReplacingOccurrencesOfString:@"vlvxing" withString:@""];
    NSString * myselfUserId = tihuanStr;//正式的用户id,真实的用户id

    parametes[@"userid"] = myselfUserId;//userid;

    parametes[@"areaid"] = [NSString getAreaID];
    parametes[@"areaName"] = areaLabel.text;
    NSLog(@"上传自己服务器参数:%@",parametes);


    [HMHttpTool post:url params:parametes success:^(id responseObj) {
        NSLog(@"发送到自己服务器OK:%@",responseObj);

        [SVProgressHUD dismiss];
        if ([responseObj[@"status"] isEqual:@1]) {
            [MBProgressHUD showSuccess:@"发布成功"];
        }
        else{
            [MBProgressHUD showError:@"发布失败"];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.navigationController popViewControllerAnimated:YES];

    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        NSLog(@"发送到自己服务器Error:%@",error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"发布失败,"];
        [self.navigationController popViewControllerAnimated:YES];

    }];
}

//转码
- (NSString *)stringReplaceWithFace:(NSString *)str
{
    NSString *mutaStr = str;

    for (int i=0x1F600; i<=0x1F64F; i++) {
        if (i < 0x1F641 || i > 0x1F644) {
            int sym = EMOJI_CODE_TO_SYMBOL(i);
            NSString *emoT = [[NSString alloc] initWithBytes:&sym length:sizeof(sym) encoding:NSUTF8StringEncoding];

            mutaStr = [mutaStr stringByReplacingOccurrencesOfString:emoT withString:[NSString stringWithFormat:@"%d",sym]];
        }
    }

    return mutaStr;
}



@end
