//
//  VLX_Community_DetailViewController.m
//  Vlvxing
//
//

#import "VLX_Community_DetailViewController.h"
#import "VLX_CommentTBVW_Cell.h"
#import "VLX_detailhuifuModel.h"
#import "VLX_louzhuxinxiVC.h"//楼主信息
#import "VLX_IMG_Watch.h"//图片全屏展示
#import "SRVideoPlayer.h"//视频播放控件
#import "VLX_other_MainPageVC.h"//其他人的主页
#import "TZImagePickerController.h"
#import "UIView+Layout.h"
#import "TZTestCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "LxGridViewFlowLayout.h"
#import "TZImageManager.h"
#import "TZVideoPlayerController.h"

#import "XHWebImageAutoSize.h"

#import "ShareBtnView.h"

#import "VLX_huifuSinglePicture.h"



@interface VLX_Community_DetailViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIImagePickerControllerDelegate,TZImagePickerControllerDelegate,ShareBtnViewDelegate>
{
    UIImageView * RightImgV;//右边item上放置的vw
    UIView * share_OR_delet_BigVw;//分享或删除透明大背景
    UIView * share_OR_delet_Vw;//分享或删除
    
    UIButton * shareBt;
    UIButton * deletBt ;
    int c;
    CGFloat _itemWH;
    CGFloat _margin;

    UITextView * hfTxfd;
    UIButton * fabiaoBt;
    NSMutableArray * imgArray;
    NSMutableArray * imgArray_memory;//图片内存地址

    NSMutableArray * imgHeightAry;//主题帖子的每张图片高度

    UIImageView * imgVw;//主题图片

    UIImageView * videoVw2;//主题视频
    UIButton * playBt2;
    SRVideoPlayer * SRvideoView2;

    UIView * huifVw;//底部回复
    UIView * jiahaoVw;//点击加号弹出的view
    UIButton * imgBt0;//选图片
    UIButton * cameraBt0;//选相机
    UIButton * voiceBt0;//发语音

    NSInteger tagger;
    NSInteger cellTagg;//点击cell上的回复按钮,有值(1)就是回复评论.没值(0)就是直接回复帖子

    UIImage *resultImg;//回复的单张图片


    TZImagePickerController *imagePickerVcc_3;
    NSMutableArray *_selectedPhotos_3;//已经选好的图片数组
    NSMutableArray *_selectedAssets_3;//已经选好的图片的标识
    BOOL _isSelectOriginalPhoto_3;//
    int haveIMAGE;//有没有图片:0没有, 1有;
    NSString * guanzhuBtTitle;
    NSArray * heightArr;


}

@property (nonatomic,strong)UITableView * tableVw;
//@property (nonatomic,strong)UITableView * imgTableVw;//用于图片
@property (nonatomic,assign) NSInteger pageIndex;//页码
@property (nonatomic,strong)UIImageView * headImgvw;//头像
@property (nonatomic,strong)UILabel * louceng;//楼层或楼主
@property (nonatomic,strong)UIButton * guanzhuBt;//关注按钮
@property (nonatomic,strong)UILabel * nameLb;//mingzi
@property (nonatomic,strong)UILabel * dateLb;//日期
@property (nonatomic,strong)UILabel * timeLb;//时间
@property (nonatomic,strong)UILabel * titleLb;//正文简介
@property (nonatomic,strong)UIView * sumView;//正文图片
//@property (nonatomic,assign)NSInteger tagger;//图片标识
//@property (nonatomic,strong)UIButton * commentBt;//评论按钮
@property (nonatomic,strong)UIImageView * areaImgvw;//地点
@property (nonatomic,strong)UILabel * areaLb;
@property (nonatomic,strong)UIImageView * watchImgvw;//查看次数
@property (nonatomic,strong)UILabel * watchLb;
@property (nonatomic,strong)UIImageView * commentImgvw;//评论
@property (nonatomic,strong)UILabel * commentLb;
@property (nonatomic,assign)CGFloat zhutiHeight;//主题高度(文字部分)
@property (nonatomic,assign)CGFloat imageHeightTotal;//所有图片的总高度
@property (nonatomic,assign)CGFloat videoHeightTotal;//视频总高度
@property (nonatomic,strong)UIButton * dianzanBt;//点赞
@property (nonatomic,strong)NSMutableArray * huifuHeightAry;//回复or楼层高度
@property (nonatomic,strong)NSMutableArray * huifuAry;//回复数据源;
@property (nonatomic,strong)NSMutableArray * huifuAry_imgH;//回复数据源,用于评论的图片高度计算;
@property (nonatomic,strong)NSMutableArray * huifu_ID_Ary;//回复的评论的id;
@property (nonatomic,strong)NSMutableArray * huifuUSER_ID_Ary;//回复的评论的人id(蓝色,);
@property (nonatomic,strong)NSMutableArray * huifuUSER_ALL_Ary;//回复的评论的人信息;

@property (nonatomic,strong)NSMutableArray * img_widthAry;// 评论里单张显示在屏幕上的宽,
@property (nonatomic,strong)NSMutableArray * img_heightAry;//评论里单张显示在屏幕上的高,
@property (nonatomic,strong)NSMutableArray * img_Ary;//(评论里的图片数组)

@property(nonatomic,weak)UIView * blackView;//分享用
@property(nonatomic,weak)ShareBtnView*shareView;


//谭
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSString *filePath;
@property (nonatomic, strong) NSString *type;
//  上传图片数组
@property (nonatomic, strong)NSArray *picArray;
//  上传图片字典
@property (nonatomic, strong)NSMutableDictionary *picDictionary;

@end

@implementation VLX_Community_DetailViewController

-(void)viewWillAppear:(BOOL)animated{

    //接收通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NoTifiGz:) name:@"guanzhuNotification" object:nil];
}

-(void)NoTifiGz:(NSNotification *)notiffff{
    NSString * url = notiffff.userInfo[@"guanzhu"];
    [_guanzhuBt setTitle:url forState:UIControlStateNormal];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"话题详情";
    NSLog_JSON(@"上个界面传递的数据_userDic:%@",_userDic);
    NSLog_JSON(@"上个界面传递的_detailDic:%@",_detailDic);
    _huifuAry = [NSMutableArray array];
    _huifuAry_imgH = [NSMutableArray array];
    _huifu_ID_Ary = [NSMutableArray array];
    _huifuUSER_ID_Ary = [NSMutableArray array];
    _huifuUSER_ALL_Ary = [NSMutableArray array];
    imgHeightAry = [NSMutableArray array];
    imgArray = [NSMutableArray array];
    imgArray_memory = [NSMutableArray array];
    _videoHeightTotal = 0.0f;

    _img_widthAry = [NSMutableArray array];//单张原始的宽(评论里)
    _img_heightAry = [NSMutableArray array];//单张原始的高(评论里)
    _img_Ary = [NSMutableArray array];//(评论里的图片数组)



    //起始被写出
    UIBarButtonItem *leftButon = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return-red"] style:UIBarButtonItemStylePlain target:nil action:nil];
    [leftButon setTarget:self];
    self.navigationItem.leftBarButtonItem = leftButon;
    self.navigationController.navigationBar.tintColor = orange_color;//原色;
    self.navigationItem.leftBarButtonItem.customView.frame = CGRectMake(0, 0, 100, 50);
    [self.navigationItem.leftBarButtonItem setAction:@selector(tapLeftButton1)];


    



    c = 1;
    cellTagg = 0;//默认是直接回复主题帖子
    haveIMAGE=0;//默认没有选图片
    [self navUI];
    [self zhutiHeights];//计算主题高度
    [self replyViewUI];//回复楼主输入部分
   [self loadNewpinglunData];
    [self loadDetailData];//主贴数据,只是为了获取是否关注
    [self mineUI];//搭建主界面
    [self loadPinglunData];//主界面评论数据
}
-(void)tapLeftButton1{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark 搭建导航条UI
-(void)navUI{


    if (_typee2 ==1) {
        NSLog(@"从'我的跳转而来'");
        self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]init];
        self.navigationItem.rightBarButtonItem.image = [UIImage imageNamed:@"more.png"];
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor grayColor];
        self.navigationItem.rightBarButtonItem.target = self;
        self.navigationItem.rightBarButtonItem.action = @selector(rightNavItemClick2);
        
    }
    else {
        NSLog(@"从'TA的跳转而来' 或者是从主列表跳转而来");
        self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]init];
        self.navigationItem.rightBarButtonItem.image = [UIImage imageNamed:@"share-red"];
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor grayColor];
        self.navigationItem.rightBarButtonItem.target = self;
        self.navigationItem.rightBarButtonItem.action = @selector(pressShare);

    }

}
#pragma mark 分享
-(void)pressShare{
    [self thirdShareWithUrl];
}

-(void)thirdShareWithUrl
{


    NSString * url = [NSString stringWithFormat:@"%@%@%@",tang_BENDIJIEKOU_URL,@"/shareurl/weiboshare.json?travelProductId=",_dynamic_id];
//    NSLog(@"分享的内容地址%@",url);ok
    UIWindow*window=[UIApplication sharedApplication].keyWindow;
    UIView*blackView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    self.blackView=blackView;
    blackView.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.3];
    [window addSubview:blackView];
    UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clcikClose)];
    [blackView addGestureRecognizer:tap];
    ShareBtnView*shareView=[[ShareBtnView alloc]init];
    shareView.delegate = self;
    __block VLX_Community_DetailViewController * blockSelf=self;;
    shareView.btnShareBlock=^(NSInteger tag)
    {
        NSString *titleStr;
        NSString *contentStr;


        int lenTh = (unsigned int)[_titleLb.text length];
        if (lenTh >29) {
            titleStr = [_titleLb.text substringToIndex:29];//取前xx位
        }
        else if (lenTh == 0){
           titleStr = @"看世界、V旅行!";
        }
        else{
            titleStr = _titleLb.text;
        }
        contentStr = @"看世界、V旅行!";//contentStr;

        NSString * iconURL = @"";
        if (imgArray.count == 0){
            if ([_detailDic[@"thumbnail"] isKindOfClass:[NSNull class]]) {
                iconURL = @"http://img3.2345.com/toolsimg/baike/collect/sheying/73b2150ajw1e6wsbsp5lbj20hs0hs3zs.jpg";
            }
            else{
                iconURL = _detailDic[@"thumbnail"];//1495
            }
        }else{
            iconURL =  imgArray[0];
        }

        NSLog(@"iconURL:::%@",iconURL);
        NSLog(@"contentStr:::%@",contentStr);
        NSLog(@"titleStr:::%@",titleStr);

        MyLog(@"share:%ld",tag);
        //555,QQ 556,新浪微博 557,微信 558,朋友圈
        switch (tag) {
            case 555:
            {
                [ShareTool shareWebPageToPlatformType:UMSocialPlatformType_QQ andThumbURL:iconURL andTitle:titleStr andDesc:contentStr andWebPageUrl:url];
                [blockSelf clcikClose];

            }
                break;
            case 556:
            {

                [ShareTool shareWebPageToPlatformType:UMSocialPlatformType_Sina andThumbURL:iconURL andTitle:titleStr andDesc:contentStr andWebPageUrl:url];
                [blockSelf clcikClose];
            }
                break;
            case 557:
            {
                [ShareTool shareWebPageToPlatformType:UMSocialPlatformType_WechatSession andThumbURL:iconURL andTitle:titleStr andDesc:contentStr andWebPageUrl:url];
                [blockSelf clcikClose];
            }
                break;
            case 558:
            {
                [ShareTool shareWebPageToPlatformType:UMSocialPlatformType_WechatTimeLine andThumbURL:iconURL andTitle:titleStr andDesc:contentStr andWebPageUrl:url];
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

-(void)clcikClose
{
    [self.shareView removeFromSuperview];
    [self .blackView removeFromSuperview];
}

#pragma mark 回复输入框相关UI
-(void)replyViewUI{
    huifVw = [[UIView alloc]initWithFrame:CGRectMake(0, K_SCREEN_HEIGHT - kSafeAreaBottomHeight-50-64, ScreenWidth, 60)];
    huifVw.backgroundColor = rgba(240, 240, 240, 1);
    //加号按钮
    UIButton * jiahaoBt = [[UIButton alloc]initWithFrame:CGRectMake(20, 5, 40, 40)];
    [jiahaoBt setImage:[UIImage imageNamed:@"fangda"] forState:UIControlStateNormal];
    [jiahaoBt addTarget:self action:@selector(pressJiahao) forControlEvents:UIControlEventTouchUpInside];

    hfTxfd = [[UITextView alloc]initWithFrame:CGRectMake(65, 5, ScreenWidth-65-100, 40)];
    hfTxfd.delegate = self;
    hfTxfd.tag = 0;
    hfTxfd.text = @"回复V主..";
    hfTxfd.textColor = [UIColor lightGrayColor];
    hfTxfd.font = [UIFont systemFontOfSize:18];
    hfTxfd.backgroundColor = [UIColor clearColor];


    //发表按钮
    fabiaoBt = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-70, 5, 60, 40)];
    [fabiaoBt setTitle:@"发表" forState:UIControlStateNormal];
    [fabiaoBt setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [fabiaoBt addTarget:self action:@selector(pressFabiao) forControlEvents:UIControlEventTouchUpInside];
    fabiaoBt.userInteractionEnabled = NO;

    [huifVw addSubview:hfTxfd];
    [huifVw addSubview:jiahaoBt];
    [huifVw addSubview:fabiaoBt];
    [self.view addSubview:huifVw];
}
//开始输入时候,
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if (hfTxfd.tag ==0) {
        hfTxfd.text=@"";
        hfTxfd.textColor = [UIColor blackColor];
        hfTxfd.tag = 1;
        [fabiaoBt setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        fabiaoBt.userInteractionEnabled = NO;
    }else if (hfTxfd.text.length == 0){
        hfTxfd.tag = 0;
        [fabiaoBt setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        fabiaoBt.userInteractionEnabled = NO;
    }else if (hfTxfd.text.length > 0){
//        hfTxfd.tag = 0;
        [fabiaoBt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        fabiaoBt.userInteractionEnabled = YES;
    }
    return YES;
}
//如果清空输入框,再点击完成,则运行↓
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
if (hfTxfd.text.length == 0){
        hfTxfd.tag = 0;
                hfTxfd.text = @"回复V主..";
                hfTxfd.textColor = [UIColor lightGrayColor];
    [fabiaoBt setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    fabiaoBt.userInteractionEnabled = NO;
    }

     return YES;
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSLog(@"变化");
}
//监听变化
-(void)textViewDidChange:(UITextView *)textView{
    if (hfTxfd.text.length > 0){
        [fabiaoBt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        fabiaoBt.userInteractionEnabled = YES;
    }else{
        hfTxfd.tag = 0;
        [fabiaoBt setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        fabiaoBt.userInteractionEnabled = NO;
    }
}
#pragma mark 发表评论
-(void)pressFabiao{
    [SVProgressHUD showWithStatus:@"正在发表评论"];
    NSString * url_pl = [NSString stringWithFormat:@"%@%@",tang_BENDIJIEKOU_URL,@"/weibo/comment.json"];
    NSMutableDictionary * para = [NSMutableDictionary dictionary];
    para[@"userid"] = _myselfUserId;
    para[@"weiboId"] = _dynamic_id;
    para[@"content"] = hfTxfd.text;
//    NSLog(@"            %ld",_huifu_ID_Ary.count);

    if (cellTagg == 1) {
        if(_huifu_ID_Ary.count>0){
            para[@"weiboCommentId"]=[NSString stringWithFormat:@"%@",_huifu_ID_Ary[tagger]];
        }else{
            para[@"weiboCommentId"] = @"";
        }
    }else if(cellTagg == 0){
        para[@"weiboCommentId"] = @"";
    }
    if (haveIMAGE==0) {
        para[@"pictures"]= @"";
        [HMHttpTool post:url_pl params:para success:^(id responseObj) {
            NSLog(@"OK: :::%@",responseObj);
            hfTxfd.tag = 0;
            hfTxfd.text = @"回复V主..";
            hfTxfd.textColor = [UIColor lightGrayColor];
            [hfTxfd resignFirstResponder];
            [SVProgressHUD showSuccessWithStatus:@"评论发布成功"];
        } failure:^(NSError *error) {
            NSLog(@"err: ::%@",error);
            hfTxfd.tag = 0;
            hfTxfd.text = @"回复V主..";
            hfTxfd.textColor = [UIColor lightGrayColor];
            [hfTxfd resignFirstResponder];
            [SVProgressHUD showErrorWithStatus:@"评论发布失败"];}];
    }else if (haveIMAGE == 1){
        [UploadImageTool UploadImage:resultImg upLoadProgress:^(float progress) {
            NSLog(@"progress:%f",progress);
        } successUrlBlock:^(NSString *url) {
            para[@"pictures"]= url;
            [HMHttpTool post:url_pl params:para success:^(id responseObj) {
                NSLog(@"带图片OK::::%@",responseObj);
                hfTxfd.tag = 0;
                hfTxfd.text = @"回复V主..";
                hfTxfd.textColor = [UIColor lightGrayColor];
                [hfTxfd resignFirstResponder];
                [SVProgressHUD showSuccessWithStatus:@"带图片的评论发布成功"];
            } failure:^(NSError *error) {
                NSLog(@"带图片err:::%@",error);
                hfTxfd.tag = 0;
                hfTxfd.text = @"回复V主..";
                hfTxfd.textColor = [UIColor lightGrayColor];
                [hfTxfd resignFirstResponder];
                [SVProgressHUD showErrorWithStatus:@"带图片的评论发布失败"];}];
        } failBlock:^(NSString *error) {
            [SVProgressHUD showErrorWithStatus:@"图片上传失败"];
            hfTxfd.tag = 0;
            hfTxfd.text = @"回复V主..";
            hfTxfd.textColor = [UIColor lightGrayColor];
            [hfTxfd resignFirstResponder];
            NSLog(@"%@",error);
        }];
    }
    [self.tableVw reloadData];
}

#pragma mark 点击加号按钮
-(void)pressJiahao{
    [hfTxfd resignFirstResponder];//VLX_huifuSinglePicture.h
    VLX_huifuSinglePicture * vc = [[VLX_huifuSinglePicture alloc]init];

    if ([hfTxfd.text isEqualToString:@"回复V主.."]) {
    }else{
        vc.texxtViewStr = hfTxfd.text;
    }
    vc.dynamic_id =_dynamic_id;
    if (cellTagg == 1) {
        if(_huifu_ID_Ary.count>0){
            vc.weiboCommentId=[NSString stringWithFormat:@"%@",_huifu_ID_Ary[tagger]];
        }else{
            vc.weiboCommentId = @"";
        }
    }else if(cellTagg == 0){
        vc.weiboCommentId = @"";
    }
    [self.navigationController pushViewController:vc animated:YES];



//    UIImagePickerController *imagePicker=[[UIImagePickerController alloc] init];
//    imagePicker.delegate=self;
//    //    imagePicker.allowsEditing=YES;
//    NSLog(@"拍照片");
//    if (![UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera]) {
//        [SVProgressHUD showErrorWithStatus:@"相机不可用"];//RWNLocalizedString(@"SheZhi-TheCameraIsNotAvailable");
//    }else{
//        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
//        [self presentViewController:imagePicker animated:YES completion:nil];
//    }



    
    //设置弹出窗为180的高度
//    huifVw.frame = CGRectMake(0, K_SCREEN_HEIGHT - kSafeAreaBottomHeight-50-64  -180, ScreenWidth, 60);
//    jiahaoVw = [[UIView alloc]initWithFrame:CGRectMake(0, K_SCREEN_HEIGHT - kSafeAreaBottomHeight-50-64  -180+60, ScreenWidth, 170)];
//    jiahaoVw.backgroundColor = rgba(240, 240, 240, 1);
//
//    imgBt0 = [[UIButton alloc]initWithFrame:CGRectMake(20, 25, 80, 80)];
//    [imgBt0 setImage:[UIImage imageNamed:@"屏幕快照 2018-01-19 下午2.27.11"] forState:UIControlStateNormal];
//    [imgBt0 addTarget:self action:@selector(pressToImg) forControlEvents:UIControlEventTouchUpInside];

//    cameraBt0 = [[UIButton alloc]initWithFrame:CGRectMake(20+20+20+80+80, 25, 80, 80)];
//    [cameraBt0 setImage:[UIImage imageNamed:@"屏幕快照 2018-01-19 下午2.27.11 3"] forState:UIControlStateNormal];
//    [cameraBt0 addTarget:self action:@selector(pressToMakeCamera) forControlEvents:UIControlEventTouchUpInside];

//    voiceBt0 = [[UIButton alloc]initWithFrame:CGRectMake(20+20+80, 25, 80, 80)];
//    [voiceBt0 setImage:[UIImage imageNamed:@"屏幕快照 2018-01-19 下午2.27.11 2"] forState:UIControlStateNormal];
//    [voiceBt0 addTarget:self action:@selector(pressToMakeVoice) forControlEvents:UIControlEventTouchUpInside];


//    [jiahaoVw addSubview:imgBt0];
//    [self.view addSubview:jiahaoVw];
}

#pragma mark---imagePicker delegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    [picker dismissViewControllerAnimated:YES completion:^{
        if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
            //设置弹出窗为180的高度,但是只露出170,隐藏的10像素给iPhoneX
            huifVw.frame = CGRectMake(0, K_SCREEN_HEIGHT - kSafeAreaBottomHeight-50-64  -180, ScreenWidth, 60);
            jiahaoVw = [[UIView alloc]initWithFrame:CGRectMake(0, K_SCREEN_HEIGHT - kSafeAreaBottomHeight-50-64  -180+60, ScreenWidth, 170)];
            jiahaoVw.backgroundColor = rgba(240, 240, 240, 1);
            imgBt0 = [[UIButton alloc]initWithFrame:CGRectMake(20, 25, 80, 80)];
            resultImg = info[UIImagePickerControllerOriginalImage];
            resultImg = [self fixOrientation:resultImg];
            [imgBt0 setImage:resultImg forState:UIControlStateNormal];
            [jiahaoVw addSubview:imgBt0];
            if(resultImg){
                haveIMAGE=1;//表示有图片
                NSLog(@"%d",haveIMAGE);
            }
            [self.view addSubview:jiahaoVw];
            _tableVw.frame = CGRectMake(0, 0, ScreenWidth, K_SCREEN_HEIGHT - kSafeAreaBottomHeight-64-50-170);
            huifVw.frame = CGRectMake(0, K_SCREEN_HEIGHT - kSafeAreaBottomHeight-50-64-170, ScreenWidth, 60);
        }
    }];
}

- (UIImage *)fixOrientation:(UIImage *)aImage {
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
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


//列表滑动时候
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (_tableVw == scrollView) {
        [hfTxfd resignFirstResponder];
        _tableVw.frame = CGRectMake(0, 0, ScreenWidth, K_SCREEN_HEIGHT - kSafeAreaBottomHeight-64-50);
        huifVw.frame = CGRectMake(0, K_SCREEN_HEIGHT - kSafeAreaBottomHeight-50-64, ScreenWidth, 60);
        [jiahaoVw removeFromSuperview];
    }
}
////点击时候
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [hfTxfd resignFirstResponder];

    _tableVw.frame = CGRectMake(0, 0, ScreenWidth, K_SCREEN_HEIGHT - kSafeAreaBottomHeight-64-50);
    huifVw.frame = CGRectMake(0, K_SCREEN_HEIGHT - kSafeAreaBottomHeight-50-64, ScreenWidth, 60);
    [jiahaoVw removeFromSuperview];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)rightNavItemClick2{

//    c +=1;
//    if (c%2 == 0) {//开始有,点击之后

//        shareBt.hidden = NO;
//        deletBt.hidden = NO;
//        shareBt = [[UIButton alloc]initWithFrame:CGRectMake(-60, 83, 64+30, 30)];
//        shareBt.frame = CGRectMake(ScreenWidth+20, 83, 64+30, 30);

        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil  message:nil preferredStyle:UIAlertControllerStyleAlert];

        //创建提示按钮

        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"分享" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"分享");

            [self thirdShareWithUrl];
        }];

        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"删除话题" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"删除话题");

            [self shanchuTiezi];//删除帖子
        }];

        UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"取消");
        }];

        [alertController addAction:action1];
        [alertController addAction:action2];
        [alertController addAction:action3];


        [self presentViewController:alertController animated:YES completion:nil];


//    }
//    else{

//    }

}

-(void)shanchuTiezi{
//weibo/delete.json?    weiboId=23&userId=10删除帖子
    [SVProgressHUD showWithStatus:@"正在删除"];

    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString * myselfUserId_0 = [userDefaultes stringForKey:@"alias"];
    NSString *selfmyUserId = [myselfUserId_0 stringByReplacingOccurrencesOfString:@"vlvxing" withString:@""];//获取正式的用户id,真实的用户id

    NSString * url = [NSString stringWithFormat:@"%@%@",tang_BENDIJIEKOU_URL,@"/weibo/delete.json"];

    NSMutableDictionary * para = [NSMutableDictionary dictionary];



    para[@"weiboId"]=_dynamic_id;
    para[@"userId"]=selfmyUserId;

    [HMHttpTool get:url params:para success:^(id responseObj) {
        NSLog(@"删帖👌:%@",responseObj);
        if ([responseObj[@"status"] isEqual:@1]) {


//            NSDictionary *dic_ad = [NSDictionary dictionaryWithObject:_imgUrlString forKey:@"adpicture"];
            //创建通知并发送
            [[NSNotificationCenter defaultCenter] postNotificationName:@"shanchuOKandShuaxin" object:nil userInfo:nil];//返回上个界面之后刷新列表

            [self.navigationController popViewControllerAnimated:YES];
        }

        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        NSLog(@"删帖失败:%@",error);
        [SVProgressHUD dismiss];
    }];


}


#pragma mark 主界面
-(void)mineUI{

    //    self.navigationController.navigationBar.translucent = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;

    _tableVw = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, K_SCREEN_HEIGHT - kSafeAreaBottomHeight-64-50) style:UITableViewStyleGrouped];
    _tableVw.delegate = self;
    _tableVw.dataSource = self;
//    _tableVw.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
   // 让tableview滚动到特定行
//    if (_tagss==1) {//NSLog(@"tagss==1");
//        [self.tableVw selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]animated:YES scrollPosition:UITableViewScrollPositionMiddle];
//    }

    [self.view addSubview: _tableVw];
//    [_tableVw reloadData];
}
#pragma mark 填充
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_tableVw == tableView) {
        static NSString * IDs = @"cell";
        VLX_CommentTBVW_Cell * cell = [tableView dequeueReusableCellWithIdentifier:IDs];
//        VLX_CommentTBVW_Cell *cell = [tableView cellForRowAtIndexPath:indexPath];//不复用
        if (!cell) {
            cell = [[VLX_CommentTBVW_Cell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:IDs];
        }
        if (_huifuAry.count > 0) {
            [cell FillWithModel:_huifuAry[indexPath.row]];
        }

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.MUT_titleLb.HighlightAction = ^(NSString * highliText){
            [self pushUser:indexPath];
        };
        [cell.commentBt addTarget:self action:@selector(pressADD_pinglun:) forControlEvents:UIControlEventTouchUpInside];
        cell.commentBt.tag = indexPath.row;
        return cell;
    }
    return nil;

}
//行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_tableVw == tableView) {
        return _huifuAry.count;
    }else{
        return 0;
    }
//    return 0;
}
//高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_tableVw == tableView) {
//
        CGFloat high1 = 0.0f;
        CGFloat high2 = 0.0f;////回复的图片展示在屏幕上的高

        NSArray * ary = [_huifuAry_imgH[indexPath.row] copy];
        if (ary.count == 0) {
            NSLog(@"自动计算高度,无图%f",[_huifuAry[indexPath.row] CellHeight_2]);
            return [_huifuAry[indexPath.row] CellHeight_2];//自动计算高度 96.7f;//崩在回复评论,之后再刷新
        }
        else{

            high1 = [_huifuAry[indexPath.row] CellHeight_2];
            high2 = [_img_heightAry[indexPath.row] floatValue];
            NSLog(@"文字:%f,图:%f",high1,high2);
        return high1+high2;
        }

    }else{
         return 0;
    }
  
}
#pragma mark 头高
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (_tableVw == tableView) {
        NSLog(@"_zhutiHeight%f",_zhutiHeight);
         NSLog(@"_imageHeightTotal%f",_imageHeightTotal);
        NSLog(@"_videoHeightTotal:%f",_videoHeightTotal);

        return 65 + 60 + _zhutiHeight + _imageHeightTotal+_videoHeightTotal;
    }
    return 0;//头像栏65,下边点赞栏60
}
#pragma mark 定制头
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (_tableVw == tableView) {
    if(section == 0){
        UIView * headerVw =[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth , 65+_zhutiHeight+_imageHeightTotal)];
        headerVw.backgroundColor = [UIColor whiteColor];

        _headImgvw = [[UIImageView alloc]initWithFrame:CGRectMake(11, 8, 48, 48)];
        _headImgvw.backgroundColor =[UIColor clearColor];//lightGrayColor];
        _headImgvw.layer.cornerRadius = 24;
        _headImgvw.clipsToBounds = YES;
        _headImgvw.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headTap)];
        [_headImgvw addGestureRecognizer:tap];
//        NSLog(@"%@",_userDic[@"userpic"]);
        [_headImgvw sd_setImageWithURL:[NSURL URLWithString:_userDic[@"userpic"]] placeholderImage:nil];
        _nameLb = [[UILabel alloc]init];
        _nameLb.text = _userDic[@"usernick"];//@"蛋蛋";
        _nameLb.font = [UIFont systemFontOfSize:15];
        UIFont *font1 = [UIFont fontWithName:@"Courier New" size:15.0f];
        _nameLb.font = font1;
        CGSize size1 = [_nameLb.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font1,NSFontAttributeName,nil]];
        CGFloat nameW = size1.width;
        _nameLb.frame = CGRectMake(70,33, ScreenWidth-70-70,15);

        _louceng = [[UILabel alloc]init];
        _louceng.backgroundColor = [UIColor orangeColor];
        _louceng.text = @"V主";//@"楼主";
        _louceng.textColor = [UIColor whiteColor];
        _louceng.layer.cornerRadius = 5;
        _louceng.clipsToBounds = YES;
        UIFont *font2 = [UIFont fontWithName:@"Courier New" size:10.0f];//12
        _louceng.font = font2;
        CGSize size2 = [_louceng.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font2,NSFontAttributeName,nil]];
        CGFloat nameW2 = size2.width;
        _louceng.frame = CGRectMake(70,9, nameW2,15);

        _guanzhuBt = [[UIButton alloc]init];
        _guanzhuBt.backgroundColor =  [UIColor orangeColor];
        [_guanzhuBt setTitle:guanzhuBtTitle forState:UIControlStateNormal];
//        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16]};
//        CGFloat length = [_guanzhuBt.titleLabel.text  boundingRectWithSize:CGSizeMake(320, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width;
        _guanzhuBt.frame = CGRectMake(ScreenWidth-69 , 10, 60 , 19);
        [_guanzhuBt addTarget:self action:@selector(guanzhu) forControlEvents:UIControlEventTouchUpInside];


        NSTimeInterval interval   = [_detailDic[@"createTime"] doubleValue]/1000;
        NSDate *date              = [NSDate dateWithTimeIntervalSince1970:interval];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd :HH:mm"];
        _dateLb = [[UILabel alloc]initWithFrame:CGRectMake(70+6+15, 12, 155, 9)];
        _dateLb.font = [UIFont systemFontOfSize:11];
        _dateLb.text = [formatter stringFromDate: date];//@"2017-09-09";


        NSAttributedString * attributeStr = [self attributedStringWithHTMLString:_detailDic[@"content"]];

        _titleLb = [[UILabel alloc]initWithFrame:CGRectMake(11, 67,ScreenWidth-11-12 , 17)];
//        _titleLb.font = [UIFont systemFontOfSize:17.0f];


        NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithAttributedString:attributeStr];
        NSLog(@"attributedString1:%@",attributedString1);
        NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle1 setLineSpacing:4];//行间距
        [attributedString1 addAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor], NSFontAttributeName:[UIFont systemFontOfSize:16]} range:NSMakeRange(0, [attributeStr length])];//字体大小
        [paragraphStyle1 setAlignment:NSTextAlignmentLeft];//字体居左
        [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [attributeStr length])];//范围


        [_titleLb setAttributedText:attributedString1];

        _titleLb.numberOfLines = 0;
        [_titleLb sizeToFit];
        self.zhutiHeight = _titleLb.frame.size.height;
//        NSLog(@"self.zhutiHeight::%f",self.zhutiHeight);

        //已经展示出来的图片各自占用的高度
        CGFloat imgsH = 0.0f;
        CGFloat imgsBeforeH = 0.0f;//前一个
//        if(imgArray_memory.count <imgArray.count){
        for(int i = 0;i<imgArray.count;i++){
            if(i>0){
                imgsBeforeH += 5+ [imgHeightAry[i-1] floatValue];
            }
            imgsH = [imgHeightAry[i] floatValue];

            imgVw = [[UIImageView alloc]initWithFrame:CGRectMake(5,10+ 65+_zhutiHeight+imgsBeforeH, ScreenWidth-10, imgsH)];
            imgVw.userInteractionEnabled = YES;
            imgVw.tag = 200+i;
            [imgVw sd_setImageWithURL:[NSURL URLWithString:imgArray[i]] completed:nil];
            UITapGestureRecognizer * tap =[[ UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pressWatch:)];
            [imgVw addGestureRecognizer:tap];


            [headerVw addSubview:imgVw];
        }
        if([_detailDic[@"videoUrl"] isKindOfClass:[NSNull class]]){//_detailDic[@"videoUrl"] == nil
            videoVw2 = [[UIImageView alloc]initWithFrame:CGRectMake(2,3,4,0)];
        }else{
            videoVw2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10+65+_zhutiHeight, ScreenWidth, ScreenWidth*9/16)];
            videoVw2.userInteractionEnabled = YES;
            [videoVw2 sd_setImageWithURL:[NSURL URLWithString:_detailDic[@"thumbnail"]]];

            playBt2 = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth/2 - 15, ScreenWidth*9/16 / 2 -15, 30, 30)];
            [playBt2 setImage:[UIImage imageNamed:@"video.png"] forState:UIControlStateNormal];
            [playBt2 addTarget:self action:@selector(playVIDEO2) forControlEvents:UIControlEventTouchUpInside];

            SRvideoView2 = [SRVideoPlayer playerWithVideoURL:[NSURL URLWithString:_detailDic[@"videoUrl"]] playerView:videoVw2 playerSuperView:videoVw2.superview];
            SRvideoView2.playerEndAction = SRVideoPlayerEndActionStop;

            [videoVw2 addSubview:playBt2];

        }



        _dianzanBt = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-70, headerVw.frame.size.height+25, 60, 30)];
        [_dianzanBt setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
        NSString * str= [NSString stringWithFormat:@"%@",_detailDic[@"favor"]];
        [_dianzanBt setFont:[UIFont systemFontOfSize:12]];
//        [_dianzanBt setTitle:@"30000" forState:UIControlStateNormal];
        [_dianzanBt setTitle:[NSString  stringWithFormat:@"%@",_detailDic[@"favor"] ]forState:UIControlStateNormal];
        [_dianzanBt setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];

        //按钮图片文字://contentHorizontalAlignment/contentVerticalAlignment
        _dianzanBt.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
        [_dianzanBt setTitleEdgeInsets:UIEdgeInsetsMake(0 ,_dianzanBt.imageView.frame.size.width-40, 0, -_dianzanBt.imageView.frame.size.width)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
        [_dianzanBt setImageEdgeInsets:UIEdgeInsetsMake(0, _dianzanBt.imageView.frame.size.width-30, 0, _dianzanBt.imageView.frame.size.width)];//图片距离右边框距离减少图片的宽度，其它不边

        [headerVw addSubview:_headImgvw];
        [headerVw addSubview:_nameLb];
        [headerVw addSubview:_louceng];
        [headerVw addSubview:_guanzhuBt];
        [headerVw addSubview:_dateLb];
        [headerVw addSubview:videoVw2];
        [headerVw addSubview:_timeLb];
        [headerVw addSubview:_titleLb];
//        [headerVw addSubview:_dianzanBt];
        NSLog(@"定制头");
        return headerVw;
    }
    }
    return nil;
}
#pragma mark 点击关注按钮,改变文字,并走关注接口
-(void)guanzhu{
    [SVProgressHUD showWithStatus:@""];
    NSString * url= [NSString stringWithFormat:@"%@%@",tang_BENDIJIEKOU_URL,@"/userfollow/follows.json"];
    NSMutableDictionary * paras =[NSMutableDictionary dictionary];
    paras[@"userid"]=_myselfUserId;//我本人的id
    NSLog(@"%@",_userDic);
    paras[@"followWhoId"]= _userDic[@"userid"];//帖主的id
    NSLog(@"点击关注:%@",paras);
    [HMHttpTool get:url params:paras success:^(id responseObj) {

        [SVProgressHUD dismiss];
        NSLog(@"%@",responseObj);
        if([responseObj[@"status"] isEqual:@1]){
            if([guanzhuBtTitle isEqualToString:@"已关注"]){
                [_guanzhuBt setTitle:@"关注" forState:UIControlStateNormal];


            }
            else{
                [_guanzhuBt setTitle:@"已关注" forState:UIControlStateNormal];
            }
        }
        else if ([responseObj[@"status"] isEqual:@-1]){
            [SVProgressHUD showInfoWithStatus:@"不能关注自己"];
        }
    } failure:^(NSError *error) {
        NSLog(@"关注:::%@",error);
    }];

}

-(void)playVIDEO2{
    double delayInSeconds = 10.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        playBt2.hidden = NO;
    });

    playBt2.hidden = YES;
    [SRvideoView2 play];

}

-(void)pressWatch:(NSInteger) tagg{

    [imgArray_memory removeAllObjects];
    for (int i = 0; i<imgArray.count; i++) {
        UIImageView * imgview =[self.view viewWithTag:200+i];
        UIImage * img = imgview.image;
        [imgArray_memory addObject:img];
    }


    VLX_IMG_Watch * vc = [[VLX_IMG_Watch alloc]init];
    vc.imgAry = imgArray_memory;
//    vc.tagger = _tagger;
    [self presentViewController:vc animated:NO completion:nil];//模态

}
#pragma mark点击头像
-(void)headTap{
//    VLX_louzhuxinxiVC * vc= [[VLX_louzhuxinxiVC alloc]init];
//    vc.uisrID = [NSString stringWithFormat:@"%@",_userDic[@"userid"]];
//    vc.myUserid = _myselfUserId;
//    [self.navigationController pushViewController:vc animated:YES];

    VLX_other_MainPageVC * vc = [[VLX_other_MainPageVC alloc]init];
    vc.guanzhutitle = _guanzhuBt.titleLabel.text;
    vc.userDic = _userDic;
    vc.myselfUserId = _myselfUserId;
    vc.typee= 0;
    [self.navigationController pushViewController:vc animated:YES];

}

#pragma mark 点击蓝色的用户名跳转
-(void)pushUser:(NSIndexPath *)indxPh{
//    NSLog(@"!%ld",indxPh.row);
    NSLog_JSON(@"蓝色:%@",[NSString stringWithFormat:@"%@",_huifuUSER_ID_Ary[indxPh.row]]);
    VLX_other_MainPageVC * vc = [[VLX_other_MainPageVC alloc]init];
    vc.guanzhutitle = _guanzhuBt.titleLabel.text;
    vc.userDic = _huifuUSER_ALL_Ary[indxPh.row];
    vc.myselfUserId = _myselfUserId;
    vc.typee= 2;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark 点击cell上的回复按钮
-(void)pressADD_pinglun:(UIButton *)btn{
    tagger = btn.tag;
    cellTagg = 1;
    NSLog(@"%ld",tagger);
    [hfTxfd becomeFirstResponder];
}

//计算主题高度!
- (void)zhutiHeights{

    NSMutableArray * i_width = [NSMutableArray array];//单张原始的宽
    NSMutableArray * i_height = [NSMutableArray array];//单张原始的高


    /******************正文高度************************/
    CGFloat textMaxW = ScreenWidth - 2 * 10;

    _zhutiHeight += [_detailDic[@"content"] boundingRectWithSize:CGSizeMake(textMaxW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size.height;// + 10;


    /******************图片高度************************/
    NSMutableArray * ary = [_detailDic[@"pictures"] copy];
    _imageHeightTotal = 0.0f;
    if (ary.count>0) {//有图
//        NSLog(@"有图");
//        NSLog(@"ary个数:%ld",ary.count);
        for (NSDictionary * imgDic in ary) {
            [imgArray addObject:imgDic[@"path"]];
            if ([imgDic[@"width"] isKindOfClass:[NSNull class]]) {
//                NSLog(@"没有宽高");
                NSNumber * width  = @"430";
                NSNumber * height = @"457";
                [i_width addObject:width];
                [i_height addObject:height];
            }
            else{
            [i_width addObject:imgDic[@"width"]];
            [i_height addObject:imgDic[@"height"]];
            }

        }
//        NSLog(@"W个数%ld",i_width.count);
//        NSLog(@"H个数%ld",i_height.count);

        for (int a=0; a<ary.count; a++) {

            //1.2计算图片的高度

            CGFloat kuanyuanshi= [i_width[a] floatValue];//原始宽
            NSLog(@"原始宽%f",kuanyuanshi);
            CGFloat kuandubili = (ScreenWidth-10) / kuanyuanshi ;//按照屏幕宽度比例计算出比例;
            NSLog(@"屏宽比例%f",kuandubili);

            CGFloat gaoyuanshi = [i_height[a] floatValue];//原始高
            CGFloat gaodu      = gaoyuanshi * kuandubili;//根据屏幕计算出来的单个高度
            NSLog(@"屏幕显示出的高度%f",gaodu);


            _imageHeightTotal +=gaodu + 5;//每张图片有5像素间隔
//            //2将float类型存入数组;
            NSNumber * number = [NSNumber numberWithFloat:gaodu];
            [imgHeightAry addObject:number];
        }
    }

    /******************视频高度************************/
    if(![_detailDic[@"videoUrl"] isKindOfClass:[NSNull class]]){
        _videoHeightTotal = ScreenWidth*9/16;
    }

    NSLog(@"文字的高度是多少?:%f",_zhutiHeight);
    NSLog(@"所有图片总高度:%f",_imageHeightTotal);
}
-(void)loadPinglunData{
    self.tableVw.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewpinglunData)];

//    [self.tableVw.mj_header beginRefreshing];
    self.tableVw.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDataa)];
//    [self loadNewpinglunData];
}
//下拉刷新
-(void)loadNewpinglunData{
    self.pageIndex = 1;//
    if(_huifuAry.count>0){
        [_huifuAry removeAllObjects];
        [_huifuUSER_ID_Ary removeAllObjects];
        [_huifu_ID_Ary removeAllObjects];
        [_huifuUSER_ALL_Ary removeAllObjects];
        [_img_widthAry removeAllObjects];
        [_img_heightAry removeAllObjects];
        [_img_Ary removeAllObjects];
    }
    NSMutableDictionary * para = [NSMutableDictionary dictionary];
    para[@"weiboId"] = _dynamic_id;
    para[@"currentPage"] = @(self.pageIndex);
    NSLog(@"评论参数%@",para);
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",tang_BENDIJIEKOU_URL,@"/weibo/commentList.json"];
    [HMHttpTool get:urlStr params:para success:^(id responseObj) {
    
        [self.tableVw.mj_header endRefreshing];
        if([responseObj[@"status"] isEqual:@1]){
            VLX_detailhuifuModel * model = [[VLX_detailhuifuModel alloc]init];
            NSDictionary * dic_1  = [NSDictionary dictionary];
            for (NSDictionary * dic in responseObj[@"data"]) {
                NSLog_JSON(@"回复字典:%@",dic);
                [_huifuAry_imgH addObject:dic[@"pictures"]];
                model = [VLX_detailhuifuModel infoListWithDict:dic];
                [_huifuAry addObject:model];
                [_huifuUSER_ID_Ary addObject:model.member];
                [_huifu_ID_Ary addObject:model.discussId];//该条评论的id
                [_huifuUSER_ALL_Ary addObject:dic];

                NSMutableArray * ary2 = [dic[@"pictures"] copy];
                if (ary2.count>0) {
                    dic_1 = dic[@"pictures"][0];
                    NSLog_JSON(@"评论图片字典%@",dic_1);
                }
                else{
                    dic_1 = @{@"height":@"0.0",@"path":@"",@"width":@"0.0"};//为空
                }
                [_img_Ary addObject:dic_1];
            }

        }
        CGFloat high2 = 0.0f;////回复的图片展示在屏幕上的高;

        CGFloat yuanshi_High = 0.0f; //原始像素高
        CGFloat yuanshi_weight= 0.0f;//原始像素宽
        CGFloat bili = 0.0f;         //屏幕比例

        for (int a=0; a<_img_Ary.count; a++) {
            if([_img_Ary[a][@"height"] isKindOfClass:[NSNull class]] ){
                yuanshi_High = 457.0f;
                yuanshi_weight = 430.0f;
            }else{
                yuanshi_High =[_img_Ary[a][@"height"] floatValue];
                yuanshi_weight = [_img_Ary[a][@"width"] floatValue];
            }
            bili = (ScreenWidth-20)/ yuanshi_weight;
            high2 = yuanshi_High * bili;
            NSString * highStr = [NSString stringWithFormat:@"%f",high2];
            [_img_heightAry addObject:highStr];

        }

        if (_huifuAry.count == 0) {
            self.tableVw.mj_footer.state = MJRefreshStateNoMoreData;
        }else{
            [self.tableVw reloadData];//请求成功后，一定要刷新界面
        }
      
        
    } failure:^(NSError *error) {
        [self.tableVw.mj_footer endRefreshing];
        [self.tableVw.mj_header endRefreshing];
        NSLog(@"%@",error);
    }];

  

}

-(void)loadMoreDataa{
    //以下↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓



    NSMutableDictionary * para = [NSMutableDictionary dictionary];
    para[@"weiboId"] = _dynamic_id;
    para[@"currentPage"] = @(++self.pageIndex);
    NSLog(@"参数::::::::%@",para);
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",tang_BENDIJIEKOU_URL,@"/weibo/commentList.json"];
    [HMHttpTool get:urlStr params:para success:^(id responseObj) {
        NSLog_JSON(@"详情👌::%@",responseObj);

//        //消除尾部"没有更多数据"的状态
    [self.tableVw.mj_footer resetNoMoreData];
        if([responseObj[@"status"] isEqual:@1]){
            VLX_detailhuifuModel * model = [[VLX_detailhuifuModel alloc]init];
            NSArray *commentMoreData = responseObj[@"data"];
           
            if (commentMoreData.count == 0) {
                [self.tableVw.mj_footer endRefreshing];
                [self.tableVw.mj_header endRefreshing];
                self.tableVw.mj_footer.state = MJRefreshStateNoMoreData;//在没有更多数据时候显示的
                return ;
            }
            for (NSDictionary * dic in responseObj[@"data"]) {
                [_huifuAry_imgH addObject:dic[@"pictures"]];
                model = [VLX_detailhuifuModel infoListWithDict:dic];

                [_huifuAry addObject:model];
                [_huifuUSER_ID_Ary addObject:model.member];
                [_huifu_ID_Ary addObject:model.discussId];//该条评论的id
//                [_huifu_ID_Ary addObject:model.PLid];//该条评论的id
                [_huifuUSER_ALL_Ary addObject:dic];
            }
        }
        //请求成功后，一定要刷新界面
        [self.tableVw reloadData];
        




    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [self.tableVw.mj_footer endRefreshing];
        [self.tableVw.mj_header endRefreshing];
    }];


    //以上↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑


}

#pragma mark 关注否查询,查询关注
-(void)loadDetailData{
    NSString * url = [NSString stringWithFormat:@"%@%@",tang_BENDIJIEKOU_URL, @"/weibo/detail.json"];
    NSMutableDictionary * paras = [NSMutableDictionary dictionary];
    paras[@"weiboId"] = _dynamic_id;//帖子id
    paras[@"loginUserid"] =  _myselfUserId;//本人的id
    paras[@"userid"] =  _userDic[@"userid"];//类型是个字符串
    NSLog(@"关注查询的请求参数:%@",paras);
    [HMHttpTool get:url params:paras success:^(id responseObj) {
        if([responseObj[@"status"] isEqual:@1]){ NSArray * ary = responseObj[@"data"][@"pictures"];
            if (!(ary.count ==0) ) {

            }
            if([responseObj[@"data"][@"isFollow"] isEqual:@1]){
                guanzhuBtTitle = @"已关注";
                [_guanzhuBt setTitle:@"已关注" forState:UIControlStateNormal];
                
            }else{
                guanzhuBtTitle = @" 关注 ";
                [_guanzhuBt setTitle:@"关注" forState:UIControlStateNormal];
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}


- (NSAttributedString *)attributedStringWithHTMLString:(NSString *)htmlString
{
    NSDictionary *options = @{ NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType,
                               NSCharacterEncodingDocumentAttribute :@(NSUTF8StringEncoding) };

    NSData *data = [htmlString dataUsingEncoding:NSUTF8StringEncoding];

    return [[NSAttributedString alloc] initWithData:data options:options documentAttributes:nil error:nil];
}
@end
