//
//  VLX_huifuSinglePicture.m
//  Vlvxing
//
//  Created by grm on 2018/4/3.
//  Copyright © 2018年 王静雨. All rights reserved.
//

#import "VLX_huifuSinglePicture.h"

#import "HMEmotiontextView.h"

#import "TZImagePickerController.h"
#import "UIView+Layout.h"
#import "TZTestCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "LxGridViewFlowLayout.h"
#import "TZImageManager.h"
#import "TZVideoPlayerController.h"

#import "ZYYOSSUploader.h"//阿里oss

#define EMOJI_CODE_TO_SYMBOL(x) ((((0x808080F0 | (x & 0x3F000) >> 4) | (x & 0xFC0) << 10) | (x & 0x1C0000) << 18) | (x & 0x3F) << 24);




@interface VLX_huifuSinglePicture ()<UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIActionSheetDelegate,TZImagePickerControllerDelegate>{


    HMEmotionTextView *textView1;

    TZImagePickerController *imagePickerVcc;
    UIButton * selectBt;
    NSMutableArray * imgdataArray;//存放上传图片返回的data字段



    NSMutableArray *_selectedPhotos;//已经选好的图片数组
    NSMutableArray *_selectedAssets;//已经选好的图片的标识
    BOOL _isSelectOriginalPhoto;
    CGFloat _itemWH;
    CGFloat _margin;

    UIButton * fabiaoBt;//发表按钮

}

@property (nonatomic, assign, getter = isChangingKeyboard) BOOL changingKeyboard;
//谭
@property (nonatomic, strong) UICollectionView *collectionView1;
@property (nonatomic, strong) UIView * fangzhiimgVw;
@property (nonatomic,assign)int tags;//区分是图片或视频, 0=图片  1=视频,2=已经选好了视频
@property(nonatomic,strong)UIWindow *window;//点击弹出的泡泡窗口


@end

@implementation VLX_huifuSinglePicture




- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"回复";
    self.view.backgroundColor = rgba(248, 248, 248, 1);

    _selectedPhotos = [NSMutableArray array];
    _selectedAssets = [NSMutableArray array];
    imgdataArray   = [NSMutableArray array];

//    if (_texxtViewStr == nil) {
//        NSLog(@"没有值");//👌
//    }
//    else{
//        NSLog(@"_texxtViewStrB:%@",_texxtViewStr);
//    }

    _tags =0;
    [self createNav];
    [self createTextView1];
    [self createPhotosView1];


    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(upServerData2) name:@"tupiandeshuzuForHuifu" object:nil];//方法是直接网自己服务器传
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(upServerData2) name:@"wutupiantongzhiForHuifu" object:nil];

}

-(void)createNav{

    UIBarButtonItem *leftButon = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return-red"] style:UIBarButtonItemStylePlain target:nil action:nil];
    [leftButon setTarget:self];
    self.navigationItem.leftBarButtonItem = leftButon;
    self.navigationController.navigationBar.tintColor = orange_color;//原色;
    self.navigationItem.leftBarButtonItem.customView.frame = CGRectMake(0, 0, 100, 50);
    [self.navigationItem.leftBarButtonItem setAction:@selector(tapLeftButton)];

    //右边
    fabiaoBt = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-60,5, 50, 34)];
    [fabiaoBt addTarget:self action:@selector(pressfabiaoBtBt) forControlEvents:UIControlEventTouchUpInside];
    [fabiaoBt setBackgroundColor:[UIColor lightGrayColor]];//rgba(233, 84, 35, 1)];
    [fabiaoBt setTitle:@"发  表" forState:UIControlStateNormal];//2空格
    fabiaoBt.layer.cornerRadius = 7;
    fabiaoBt.layer.masksToBounds = YES;
    fabiaoBt.enabled = NO;

    [self.navigationController.navigationBar addSubview:fabiaoBt];

}
-(void)tapLeftButton{
    [fabiaoBt removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)pressfabiaoBtBt{

    if(_selectedPhotos.count==0){//无图片时候发送的通知
        [[NSNotificationCenter defaultCenter]postNotificationName:@"wutupiantongzhiForHuifu" object:nil];
    }
    else{//有图片
        [SVProgressHUD showWithStatus:@"正在处理图片"];

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
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"tupiandeshuzuForHuifu" object:imgdataArray];
                    }
                }
                else{
                    [SVProgressHUD dismiss];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }];


        }
    }


}




-(void)createTextView1{

    // 1.创建输入控件
    textView1 = [[HMEmotionTextView alloc] init];
    textView1.alwaysBounceVertical = YES; // 垂直方向上拥有有弹簧效果
    //    textView1.frame = self.view.bounds;
    textView1.frame = CGRectMake(10, 5, ScreenWidth-20, 160/2);
    textView1.delegate = self;
    textView1.backgroundColor =[UIColor whiteColor];//yellowColor];
    [self.view addSubview:textView1];
//    self.HM_textView = textView1;
    // 2.设置提醒文字（占位文字）
    textView1.placehoder = @"回复V主..";
    if (_texxtViewStr == nil) {
    }
    else{
        textView1.text = _texxtViewStr;
    }

    // 3.设置字体
    textView1.font = [UIFont systemFontOfSize:15];

    // 4.监听键盘
    // 键盘的frame(位置)即将改变, 就会发出UIKeyboardWillChangeFrameNotification
    // 键盘即将弹出, 就会发出UIKeyboardWillShowNotification
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    // 键盘即将隐藏, 就会发出UIKeyboardWillHideNotification
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

}

///键盘即将弹出
//- (void)keyboardWillShow:(NSNotification *)note{
//    // 1.键盘弹出需要的时间
//    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//
//    // 2.动画
//    [UIView animateWithDuration:duration animations:^{
//        // 取出键盘高度
////        CGRect keyboardF = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
////        CGFloat keyboardH = keyboardF.size.height;
////        self.toolbar.transform = CGAffineTransformMakeTranslation(0, - keyboardH);
//    }];
//}
//键盘即将隐藏
//- (void)keyboardWillHide:(NSNotification *)note{
//    if (self.isChangingKeyboard) return;
//    // 1.键盘弹出需要的时间
//    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//    // 2.动画
//    [UIView animateWithDuration:duration animations:^{
////        self.toolbar.transform = CGAffineTransformIdentity;
//    }];
//}


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

-(void)createPhotosView1{
    _fangzhiimgVw = [[UIView alloc]init];//WithFrame:CGRectMake(0, 86+videoVw.height, ScreenWidth, _itemWH*2+10)];
    LxGridViewFlowLayout *layout = [[LxGridViewFlowLayout alloc] init];
    _margin = 4;
    _itemWH = (self.view.tz_width - 2 * _margin - 4) / 3 - _margin;
    _fangzhiimgVw.frame = CGRectMake(0, 86, _itemWH+4, _itemWH+4);
    layout.itemSize = CGSizeMake(_itemWH, _itemWH);
    layout.minimumInteritemSpacing = _margin;
    layout.minimumLineSpacing = _margin;
    _collectionView1 = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, _itemWH+4, _itemWH+4) collectionViewLayout:layout];
//    NSLog(@"宽度:::%f",self.view.tz_width);
    CGFloat rgb = 244 / 255.0;
    _collectionView1.alwaysBounceVertical = YES;
    _collectionView1.bounces = NO;//无弹簧效果
    _collectionView1.scrollEnabled = NO;

    _collectionView1.backgroundColor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:1.0];
    _collectionView1.contentInset = UIEdgeInsetsMake(4, 4, 4, 4);
    _collectionView1.dataSource = self;
    _collectionView1.delegate = self;
    _collectionView1.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [_fangzhiimgVw addSubview:_collectionView1];
    [_collectionView1 registerClass:[TZTestCell class] forCellWithReuseIdentifier:@"TZTestCell"];
    [self.view addSubview:_fangzhiimgVw];

}

#pragma mark UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSLog(@"到底多少行::%ld",_selectedPhotos.count+1);

    ///*
    if (_selectedPhotos.count+1 >1) {
        //        NSLog(@"有了图片");
        fabiaoBt.enabled = YES;
        [fabiaoBt setBackgroundColor:rgba(233, 84, 35, 1)];
    }else if(_selectedPhotos.count+1 == 1 && textView1.text.length == 0){
        [fabiaoBt setBackgroundColor:[UIColor lightGrayColor]];
    }
    //*/

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
    [_collectionView1 performBatchUpdates:^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag inSection:0];
        [_collectionView1 deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        [_collectionView1 reloadData];
    }];
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
//            TZVideoPlayerController *vc = [[TZVideoPlayerController alloc] init];
//            TZAssetModel *model = [TZAssetModel modelWithAsset:asset type:TZAssetModelMediaTypeVideo timeLength:@""];
//            vc.model = model;
//            [self presentViewController:vc animated:YES completion:nil];
        } else { // preview photos / 预览照片
            TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:_selectedAssets selectedPhotos:_selectedPhotos index:indexPath.row];
            //            imagePickerVc.maxImagesCount = self.maxCountTF.text.integerValue;
            imagePickerVc.maxImagesCount = 1;//你最多只能选择n张照片
            //            imagePickerVc.allowPickingOriginalPhoto = self.allowPickingOriginalPhotoSwitch.isOn;
            imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
            [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
                _selectedPhotos = [NSMutableArray arrayWithArray:photos];
                NSLog(@"数组里边%@",_selectedPhotos );
                _selectedAssets = [NSMutableArray arrayWithArray:assets];
                _isSelectOriginalPhoto = isSelectOriginalPhoto;
                [_collectionView1 reloadData];
                _collectionView1.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
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
    imagePickerVcc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:3 delegate:self pushPhotoPickerVc:YES];
#pragma mark - 四类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVcc.isSelectOriginalPhoto = _isSelectOriginalPhoto;

    // 1.设置目前已经选中的图片数组
    imagePickerVcc.selectedAssets = _selectedAssets; // 目前已经选中的图片数组
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


//- (void)pushImagePickerControllerZanshi{
//    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
//        return;
//    }
//
//    //最多选九个,每行三个
//    imagePickerVcc = [[TZImagePickerController alloc] initWithMaxImagesCount:6 columnNumber:3 delegate:self pushPhotoPickerVc:YES];
//
//    imagePickerVcc.navigationBar.hidden = YES;
//
//    UIView  * vieW = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
//    vieW.backgroundColor = [UIColor colorWithWhite:0.3 alpha:1];
//
//    UIButton * backBt = [[UIButton alloc]initWithFrame:CGRectMake(10, 15, 25, 25)];
//    selectBt = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth/2.0 - 35,15, 100, 25)];
//    selectBt.backgroundColor = [UIColor grayColor];
//    selectBt.layer.cornerRadius = 4;
//    UIButton * cancelBt = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-35, 15, 25, 25)];
//    [backBt setTitle:@"返回" forState:UIControlStateNormal];
//    [selectBt setTitle:@"选择" forState:UIControlStateNormal];
//    [cancelBt setTitle:@"取消" forState:UIControlStateNormal];
//    [backBt addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
//    [selectBt addTarget:self action:@selector(selectClick) forControlEvents:UIControlEventTouchUpInside];
//    [cancelBt addTarget:self action:@selector(cancleClick) forControlEvents:UIControlEventTouchUpInside];
//
//    [vieW addSubview:backBt];
//    [vieW addSubview:selectBt];
//    [vieW addSubview:cancelBt];
//
//    _window = [[UIWindow alloc]initWithFrame:CGRectMake(ScreenWidth/2 - 90, 54, 180, 105)];
//    _window.windowLevel = UIWindowLevelAlert+1;
//    [_window makeKeyAndVisible];
//    CGFloat rgb = 244 / 255.0;
//    _window.backgroundColor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:1.0];
//    _window.hidden=YES;
//
//    [imagePickerVcc.view addSubview:_window];
//
//    [imagePickerVcc.view addSubview:vieW];
//    //弹出的控件的几个方法
//    UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(40, 0, 30, 15)];
//    [_window addSubview:img];
//    img.image=[UIImage imageNamed:@"shareAndCollectArrow"];//小三角△图像
//
//    UIView *bg=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(img.frame), _window.width, _window.height-img.height)];
//    [_window addSubview:bg];
//    bg.backgroundColor=[UIColor colorWithRed:84/255.0 green:84/255.0 blue:84/255.0 alpha:1.0];
//    bg.layer.cornerRadius=3;
//
//    UIButton *shareBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, bg.width, bg.height/2)];
//    [bg addSubview:shareBtn];
//    [shareBtn setTitle:@"选择图片" forState:UIControlStateNormal];
//    shareBtn.titleLabel.font=[UIFont systemFontOfSize:16];
//    //    _videoBtn=shareBtn;
//    [shareBtn addTarget:self action:@selector(imgBtnClick) forControlEvents:UIControlEventTouchUpInside];
//
//
//    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(shareBtn.frame), bg.width, 0.5)];
//    [bg addSubview:line];
//    line.backgroundColor=[UIColor whiteColor];
//
//    UIButton *collectBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(line.frame), shareBtn.width, shareBtn.height-1)];
//    [bg addSubview:collectBtn];
//    [collectBtn setTitle:@"选择视频" forState:UIControlStateNormal];
//    collectBtn.titleLabel.font=[UIFont systemFontOfSize:16];
//    [collectBtn addTarget:self action:@selector(videoBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    _window.hidden=YES;
//
//
//
//
//#pragma mark - 四类个性化设置，这些参数都可以不传，此时会走默认设置
//    imagePickerVcc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
//
//    //    if (self.maxCountTF.text.integerValue > 1) {
//    // 1.设置目前已经选中的图片数组
//    imagePickerVcc.selectedAssets = _selectedAssets; // 目前已经选中的图片数组
//    //    }
//    //    imagePickerVc.allowTakePicture = self.showTakePhotoBtnSwitch.isOn; // 在内部显示拍照按钮
//    imagePickerVcc.allowTakePicture = YES;
//    // 2. 在这里设置imagePickerVc的外观
//    // 3. 设置是否可以选择视频/图片/原图
//    imagePickerVcc.allowPickingVideo = NO;//是否允许选择视频
//    imagePickerVcc.allowPickingImage = YES;
//    imagePickerVcc.allowPickingOriginalPhoto = YES;
//
//    // 4. 照片排列按修改时间升序
//    imagePickerVcc.sortAscendingByModificationDate = YES;
//#pragma mark - 到这里为止
//
//    // 你可以通过block或者代理，来得到用户选择的照片.
//    [imagePickerVcc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
//
//    }];
//
//    [self presentViewController:imagePickerVcc animated:YES completion:nil];
//}

//点击发布图片按钮
-(void)imgBtnClick
{
    //最多选九个,每行三个
    imagePickerVcc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:3 delegate:self pushPhotoPickerVc:YES];
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
        TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:2 delegate:self];
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

                        [_collectionView1 reloadData];
                    }];
                }];
            }
        }];
        //压缩,写入,获取路径完成之后,直接从相册压缩界面自动返回上个界面
        [picker dismissViewControllerAnimated:YES completion:nil];
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
    [_collectionView1 reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)upServerData2{

    NSString * url = [NSString stringWithFormat:@"%@%@",tang_BENDIJIEKOU_URL,@"/weibo/comment.json"];
    NSMutableDictionary * parametes = [NSMutableDictionary dictionary];
    parametes[@"weiboId"] = _dynamic_id;

    if(imgdataArray.count==0){
        parametes[@"pictures"] = nil;
    }
    else{
        NSString * pictureString = [[NSString alloc]init];
        pictureString = [imgdataArray componentsJoinedByString:@","];
        NSLog(@"分割后的字符串::%@",pictureString);
        parametes[@"pictures"] = pictureString;
    }



    if (textView1.text.length == 0) {
        parametes[@"content"] = @"";
    }else{

        NSString *priceStr=textView1.text;
        NSMutableAttributedString *attStr=[[NSMutableAttributedString alloc] initWithString:priceStr];

        NSData *data = [attStr dataFromRange:NSMakeRange(0, attStr.length) documentAttributes:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} error:nil];
        NSString *html = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"html=%@",html);

        NSRange range = [html rangeOfString:@"<p class"];//匹配得到的下标
//        NSLog(@"rang:%@",NSStringFromRange(range));
        html = [html substringFromIndex:range.location];
//        NSLog(@"前截取的值为：%@",html);
        NSRange range2 = [html rangeOfString:@"\n</body>"];
        html = [html substringToIndex:range2.location];
//        NSLog(@"后截取的值为：%@",html);

        NSLog(@"转码字符串:%@", [self stringReplaceWithFace:priceStr]);
        //        NSString * HTML2 = [self stringReplaceWithFace:html];


        parametes[@"content"]= html;
    }
    //获取经纬度
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString * myselfUserId_0 = [userDefaultes stringForKey:@"alias"];
    NSString *tihuanStr = [myselfUserId_0 stringByReplacingOccurrencesOfString:@"vlvxing" withString:@""];
    NSString * myselfUserId = tihuanStr;//正式的用户id,真实的用户id
    parametes[@"userid"] = myselfUserId;//userid;
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
