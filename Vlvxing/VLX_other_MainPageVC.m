//
//  VLX_other_MainPageVC.m
//  Vlvxing
//
//  Created by grm on 2018/2/6.
//  Copyright © 2018年 王静雨. All rights reserved.
//

#import "VLX_other_MainPageVC.h"
#import "VLX_guanzhuVC.h"
#import "VLX_fensiVC.h"
#import "VLX_TA_huatiVC.h"
#import "UIColor+Tools.h"
#import "JohnTopTitleView.h"

#import <Accelerate/Accelerate.h>

#import <RongIMKit/RongIMKit.h>
#import <RongIMLib/RongIMLib.h>

#import "VLX_chatViewController0.h"

const CGFloat headerH = 200;

@interface VLX_other_MainPageVC ()<JohnTopTitleViewDelegate>{

    UILabel * nickLb;//昵称
    NSString * nickStr;//昵称str

    NSNumber * sexNumber;//性别 1=男,  other女,
    NSNumber * followsNumber;//喜欢数
    NSNumber * fansNumber;//粉丝数
    UIImageView * sexvw;//性别

    UIButton * guanzhuBt;//关注
    UIButton * chatBTn;//聊天按钮



}

@property (nonatomic,strong) UIView *headerView;
@property (nonatomic,strong) UIImageView *userHeadImgvw;

@property (nonatomic,strong) VLX_guanzhuVC *vc1;
@property (nonatomic,strong) VLX_fensiVC *vc2;
@property (nonatomic,strong) VLX_TA_huatiVC *vc3;
@property (nonatomic,strong) JohnTopTitleView *topTitleView;

@end

@implementation VLX_other_MainPageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    NSLog_JSON(@"点击头过来的没有%@",_userDic);
//    NSLog_JSON(@"蓝色3:%@",_userDic[@"weiboComment"][@"member"][@"usernick"]);//k
//    NSLog_JSON(@"蓝色4:%@",_userDic[@"weiboComment"][@"member"][@"userid"]);
//    NSLog_JSON(@"蓝色5:%@",_userDic[@"weiboComment"][@"member"][@"userpic"]);//k
    [self loadUserData];

    [self setting];//界面设置

//    [self loadDetailData];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden  = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden  = NO;

}
- (void)setting{

    self.headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, headerH)];
    self.headerView.backgroundColor = [UIColor redColor];
    self.headerView.userInteractionEnabled = YES;

    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 10, 55, 60);
    [leftBtn setImage:[UIImage imageNamed:@"return-red"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(tapLeftButton123) forControlEvents:UIControlEventTouchUpInside];

    _userHeadImgvw = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth/2 - 34, headerH/2 - 34, 68, 68)];
    _userHeadImgvw.backgroundColor = [UIColor lightGrayColor];

    if(_typee == 0){
        [_userHeadImgvw sd_setImageWithURL:[NSURL URLWithString:_userDic[@"userpic"]] placeholderImage:nil];
         }else if (_typee == 1){
             NSLog(@"");
         }else if (_typee == 2){
             [_userHeadImgvw sd_setImageWithURL:[NSURL URLWithString:_userDic[@"weiboComment"][@"member"][@"userpic"]] placeholderImage:nil];
         }

    _userHeadImgvw.layer.cornerRadius = 34;
    _userHeadImgvw.layer.masksToBounds = YES;
    


    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.image = [UIImage imageNamed:@"photo3-toutiao"];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.layer.masksToBounds = YES;
    [self.headerView addSubview:imageView];
    imageView.image = [self boxblurImage:imageView.image withBlurNumber:100];



    [self.headerView addSubview:leftBtn];
    [self.headerView addSubview:_userHeadImgvw];
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.topTitleView];


    //底部
    UIView * bottomVw = [[UIView alloc]initWithFrame:CGRectMake(0, K_SCREEN_HEIGHT - kSafeAreaBottomHeight -55, K_SCREEN_WIDTH, 100)];
    bottomVw.backgroundColor = [UIColor whiteColor];

    guanzhuBt = [[UIButton alloc]init];
    guanzhuBt.frame = CGRectMake(0, 0 , K_SCREEN_WIDTH/3, 55);
//    guanzhuBt.frame = CGRectMake(0, 0 , K_SCREEN_WIDTH, 55);//想打开聊天功能时候,就注释掉这行,打开上一行
    guanzhuBt.backgroundColor = orange_color;
    [guanzhuBt addTarget:self action:@selector(guanzhuAnniu:) forControlEvents:UIControlEventTouchUpInside];
    [guanzhuBt setTitle:@"关注" forState:UIControlStateNormal];

    chatBTn = [[UIButton alloc]init];
    chatBTn.frame = CGRectMake(K_SCREEN_WIDTH/3, 0 , K_SCREEN_WIDTH/3*2, 55);
    chatBTn.backgroundColor = rgba(200, 200, 200, 1);
    [chatBTn setTitle:@"聊天" forState:UIControlStateNormal];
    [chatBTn addTarget:self action:@selector(chatAnniu:) forControlEvents:UIControlEventTouchUpInside];



    [bottomVw addSubview:guanzhuBt];
    [bottomVw addSubview:chatBTn];//打开聊天功能时候,打开这一行

    NSString * panduanStr1 = [[NSString alloc]init];
    if (_typee == 0) {
        //NSLog(@"%@",_userDic[@"userid"]);
        //NSLog(@"leixing%@", NSStringFromClass([_userDic[@"userid"] class]));//NSNumber类型,不转崩溃
        panduanStr1 = [NSString stringWithFormat:@"%@",_userDic[@"userid"]];//;////帖主人的id
    }else if (_typee == 1){

    }else if (_typee == 2){
        panduanStr1 = [NSString stringWithFormat:@"%@", _userDic[@"weiboComment"][@"member"][@"userid"]];//蓝色主人id
    }

    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString * myselfUserId_0 = [userDefaultes stringForKey:@"alias"];
    NSString *panduanStr2 = [myselfUserId_0 stringByReplacingOccurrencesOfString:@"vlvxing" withString:@""];

    if ([panduanStr1 isEqualToString:panduanStr2]) {
//        NSLog(@"让其超出屏幕");
        UIView * bottomVw = [[UIView alloc]initWithFrame:CGRectMake(0, K_SCREEN_HEIGHT - kSafeAreaBottomHeight -55+3000, K_SCREEN_WIDTH, 100)];
        [self.view addSubview:bottomVw];
    }
    else{
        [self.view addSubview:bottomVw];
    }

}
-(void)tapLeftButton123{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark 关注
-(void)guanzhuAnniu:(UIButton *)sender{
    [SVProgressHUD showWithStatus:@""];
    NSString * url= [NSString stringWithFormat:@"%@%@",tang_BENDIJIEKOU_URL,@"/userfollow/follows.json"];
    
    NSMutableDictionary * paras =[NSMutableDictionary dictionary];
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString * myselfUserId_0 = [userDefaultes stringForKey:@"alias"];
    NSString *tihuanStr = [myselfUserId_0 stringByReplacingOccurrencesOfString:@"vlvxing" withString:@""];
    NSString * myselfUserId = tihuanStr;//正式的用户id,真实的用户id

    paras[@"userid"]=myselfUserId;//我本人的id

//    paras[@"followWhoId"]= _userDic[@"userid"];//帖主人的id
    if (_typee == 0) {
        paras[@"followWhoId"] = _userDic[@"userid"];////帖主人的id
    }else if (_typee == 1){

    }else if (_typee == 2){
        paras[@"followWhoId"] = _userDic[@"weiboComment"][@"member"][@"userid"];//蓝色主人id
    }
    NSLog(@"点击关注0000:%@",paras);
    [HMHttpTool get:url params:paras success:^(id responseObj) {
        NSLog(@"关注结果:0000:%@",responseObj);
        [SVProgressHUD dismiss];
        if([responseObj[@"status"] isEqual:@1]){
            if([guanzhuBt.titleLabel.text isEqualToString:@"已关注"]){
                [guanzhuBt setTitle:@"关注" forState:UIControlStateNormal];
            }
            else{
                [guanzhuBt setTitle:@"已关注" forState:UIControlStateNormal];
            }
        }
        NSString * gzString = guanzhuBt.titleLabel.text;
        NSLog(@"gzString:%@",gzString);
        NSDictionary *dic_gz = [NSDictionary dictionaryWithObject:gzString forKey:@"guanzhu"];
        //创建通知并发送
        [[NSNotificationCenter defaultCenter] postNotificationName:@"guanzhuNotification" object:nil userInfo:dic_gz];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络请求失败"];
        NSLog(@"关注:::%@",error);
    }];

}
#pragma mark 聊天
-(void)chatAnniu:(UIButton *)sender{

    NSString * userID = [[NSString alloc]init];
    if (_typee == 0) {
        userID = [NSString stringWithFormat:@"%@",_userDic[@"userid"]];
    }else if (_typee == 1){

    }else if (_typee == 2){
        userID = [NSString stringWithFormat:@"%@",_userDic[@"weiboComment"][@"member"][@"userid"]];
    }

    
    VLX_chatViewController0 * view = [[VLX_chatViewController0 alloc]initWithConversationType:ConversationType_PRIVATE targetId:userID];
    //设置会话的目标会话ID。（单聊、客服、公众服务会话为对方的ID，讨论组、群聊、聊天室为会话的ID）
//    view.targetId = userID;
    view.tagID = userID;

    if(_typee == 0){
        view.pictureStr = _userDic[@"userpic"];
    }else if (_typee == 1){
        NSLog(@"");
    }else if (_typee == 2){
        view.pictureStr = _userDic[@"weiboComment"][@"member"][@"userpic"];
    }

    //设置聊天会话界面要显示的标题
    view.title = nickLb.text;//@"想显示的会话标题";


    [self.navigationController pushViewController:view animated:YES];


}
#pragma mark 毛玻璃效果
- (UIImage *)boxblurImage:(UIImage *)image withBlurNumber:(CGFloat)blur
{
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }

    int boxSize = (int)(blur * 40);
    boxSize = boxSize - (boxSize % 2) + 1;
    CGImageRef img = image.CGImage;
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;

    //从CGImage中获取数据
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);

    //设置从CGImage获取对象的属性
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    if(pixelBuffer == NULL)
        NSLog(@"No pixelbuffer");
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    if(error){
        NSLog(@"error from convolution %ld", error);
    }
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate( outBuffer.data, outBuffer.width, outBuffer.height, 8, outBuffer.rowBytes, colorSpace, kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage(ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];

    //clean up CGContextRelease(ctx)
    CGColorSpaceRelease(colorSpace);
    free(pixelBuffer);
    CFRelease(inBitmapData);
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    return returnImage;

}

#pragma mark - CustomDelegate
- (void)johnScrollViewDidScroll:(CGFloat)scrollY{
    CGFloat headerViewY;
    if (scrollY > (-headerH + 40)) {
        headerViewY = -scrollY;
        if (scrollY > headerH-40) {
            headerViewY = -headerH + 40;
        }
    }else{
        headerViewY = 0;
    }
    self.headerView.frame = CGRectMake(0,headerViewY, ScreenWidth, headerH);
    self.topTitleView.frame = CGRectMake(0, CGRectGetMaxY(self.headerView.frame), ScreenWidth, ScreenHeight - CGRectGetMaxY(self.headerView.frame));
}

#pragma mark - JohnTopTitleViewDelegate
- (void)didSelectedPage:(NSInteger)page{
    self.headerView.frame = CGRectMake(0, 0, ScreenWidth, headerH);
    self.topTitleView.frame = CGRectMake(0, CGRectGetMaxY(self.headerView.frame), ScreenWidth, ScreenHeight - CGRectGetMaxY(self.headerView.frame));
    switch (page) {
        case 0:
        {
            [self.vc2.tableView2 setContentOffset:CGPointMake(0, 0) animated:NO];
            [self.vc3.tableView3 setContentOffset:CGPointMake(0, 0) animated:NO];
        }
            break;
        case 1:
        {
            [self.vc1.tableView1 setContentOffset:CGPointMake(0, 0) animated:NO];
            [self.vc3.tableView3 setContentOffset:CGPointMake(0, 0) animated:NO];

        }
            break;
        default:
        {
            [self.vc1.tableView1 setContentOffset:CGPointMake(0, 0) animated:NO];
            [self.vc2.tableView2 setContentOffset:CGPointMake(0, 0) animated:NO];

        }
            break;
    }
}
#pragma mark - Getter
- (JohnTopTitleView *)topTitleView{
    if (!_topTitleView) {
        _topTitleView = [[JohnTopTitleView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(self.headerView.frame), ScreenWidth, ScreenHeight - 64)];
//        _topTitleView.titles = @[@"话题1",@"话题2",@"话题3"];
        [_topTitleView setupViewControllerWithFatherVC:self childVC:@[self.vc1,self.vc2,self.vc3]];
        _topTitleView.delegete = self;
    }
    return _topTitleView;
}


- (VLX_guanzhuVC *)vc1{
    if (!_vc1) {
        _vc1 = [[VLX_guanzhuVC alloc]init];
        __weak typeof(self) weakSelf = self;
        if (_typee == 0) {
            _vc1.otherID =_userDic[@"userid"];
        }else if (_typee == 1){

        }
        else if (_typee == 2){
            _vc1.otherID = _userDic[@"weiboComment"][@"member"][@"userid"];
        }
        _vc1.DidScrollBlock = ^(CGFloat scrollY) {
            [weakSelf johnScrollViewDidScroll:scrollY];
        };
    }
    return _vc1;
}

- (VLX_fensiVC *)vc2{
    if (!_vc2) {
        _vc2 = [[VLX_fensiVC alloc]init];
        __weak typeof(self) weakSelf = self;
        if (_typee == 0) {
            _vc2.otherID2 = _userDic[@"userid"];
        }else if (_typee == 1){

        }else if (_typee == 2){
            _vc2.otherID2 = _userDic[@"weiboComment"][@"member"][@"userid"];
        }
//        NSLog(@"我擦勒2:%@",_vc2.otherID2);
        _vc2.DidScrollBlock = ^(CGFloat scrollY) {
            [weakSelf johnScrollViewDidScroll:scrollY];
        };
    }
    return _vc2;
}

- (VLX_TA_huatiVC *)vc3{
    if (!_vc3) {
        _vc3 = [[VLX_TA_huatiVC alloc]init];
        __weak typeof(self) weakSelf = self;

        if (_typee == 0) {
            NSLog(@"%@",_userDic);
            _vc3.otherID3 = _userDic[@"userid"];
        }else if (_typee == 1){

        }else if (_typee == 2){
            _vc3.otherID3 = _userDic[@"weiboComment"][@"member"][@"userid"];
        }
//        NSLog(@"我擦勒3:%@",_vc3.otherID3);
        _vc3.DidScrollBlock = ^(CGFloat scrollY) {
            [weakSelf johnScrollViewDidScroll:scrollY];
        };
    }
    return _vc3;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 用户基本信息,
-(void)loadUserData{
    NSString  * url = [NSString stringWithFormat:@"%@%@",tang_BENDIJIEKOU_URL,@"/userfollow/findByUser.json"];
//userId=1&ownerId=2
    NSMutableDictionary * para = [NSMutableDictionary dictionary];
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    
//    NSString * mySelfID = [userDefaultes stringForKey:@"userid"];//这个id为一串长字符串 eg:15117966027
    NSString * myselfUserId_0 = [userDefaultes stringForKey:@"alias"];
    NSString *mySelfID = [myselfUserId_0 stringByReplacingOccurrencesOfString:@"vlvxing" withString:@""];
    if (_typee == 0) {//点击头像.两个参数的值一样
        para[@"userId"] =  mySelfID;//_userDic[@"userid"];
        para[@"ownerId"] = _userDic[@"userid"];
    }else{//点击蓝色
        para[@"userId"] = mySelfID;//本人的id
        para[@"ownerId"] = _userDic[@"weiboComment"][@"member"][@"userid"];//蓝色的那个
    }
    NSLog(@"基本信息参数%@",para);

    [HMHttpTool post:url params:para success:^(id responseObj) {
        NSLog_JSON(@"基本信息%@",responseObj);
        if ([responseObj[@"status"] isEqual:@1]) {
            sexNumber = responseObj[@"data"][@"usersex"];
            fansNumber = responseObj[@"data"][@"fans"];
            followsNumber = responseObj[@"data"][@"follows"];

            nickStr = [NSString string];
            nickStr = responseObj[@"data"][@"usernick"];
            NSLog(@"昵称A:::%@",responseObj[@"data"][@"usernick"]);
            NSLog(@"昵称B:::%@",nickStr);

            //昵称
//            nickLb = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/2 - 80,  150, 160, 20)];
            nickLb = [[UILabel alloc]initWithFrame:CGRectMake(5,  150, ScreenWidth-20, 20)];

            if (_typee == 0) {
                nickLb.text = nickStr;
            }
            else{
                if ([_userDic[@"weiboComment"][@"member"][@"usernick"]  isKindOfClass:[NSNull class]]) {
                    nickLb.text = @"金光洞太2真人";
                }else{
                    nickLb.text = _userDic[@"weiboComment"][@"member"][@"usernick"];
                }
            }
            nickLb.textAlignment = NSTextAlignmentCenter;
            UIFont *foont = [UIFont fontWithName:@"Courier New" size:18.0f];
            nickLb.font = foont;
            // 根据字体得到NSString的尺寸
            CGSize size1 = [nickLb.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:foont,NSFontAttributeName,nil]];
            //W
            CGFloat text_W = size1.width;
            //性别
            sexvw = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth/2 + text_W/2 +15,  150, 15, 15)];

            [self.headerView addSubview:nickLb];
            [self.headerView addSubview:sexvw];

            NSLog(@"%@",followsNumber);
            NSString *str1 = @"";
            NSString *str2 = @"";
            if ([followsNumber isKindOfClass:[NSNull class]]) {
                NSLog(@"我是空的");
                str1 = @"关注 | 0";
            }else{
                str1 = [NSString stringWithFormat:@"%@%@",@"关注 | ",followsNumber];
            }
            if ([fansNumber isKindOfClass:[NSNull class]]) {
                str2 = @"粉丝 | 0";
            }else{
                str2 = [NSString stringWithFormat:@"%@%@",@"粉丝 | ",fansNumber];
            }
            _topTitleView.titles = @[str1,str2,@"TA的话题"];
            if ([sexNumber isEqual:@0] || [sexNumber isEqual:@2]) {
                [sexvw setSize:CGSizeMake(12.5, 16)];
                sexvw.image = [UIImage imageNamed:@"nv-red"];

            }else if ([sexNumber isEqual:@1]){
                sexvw.image = [UIImage imageNamed:@"man-blue"];
            }
            if([responseObj[@"data"][@"isFollow"] isEqual:@1]){
                [guanzhuBt setTitle:@"已关注" forState:UIControlStateNormal];
            }else{
                [guanzhuBt setTitle:@"关注" forState:UIControlStateNormal];
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}


-(void)loadDetailData{
    NSString * url = [NSString stringWithFormat:@"%@%@",tang_BENDIJIEKOU_URL, @"/weibo/detail.json"];
    NSMutableDictionary * paras = [NSMutableDictionary dictionary];
//    paras[@"weiboId"] = _dynamic_id;//帖子id


    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString * myselfUserId_0 = [userDefaultes stringForKey:@"alias"];
    NSString * myselfUserId = [myselfUserId_0 stringByReplacingOccurrencesOfString:@"vlvxing" withString:@""];

    paras[@"loginUserid"] =  myselfUserId;//本人的id
    if (_typee == 0) {
        NSLog(@"%@",_userDic);
        paras[@"userid"] =  _userDic[@"userid"];//类型是个字符串
    }else if (_typee == 1){

    }else if (_typee == 2){
        paras[@"userid"] = _userDic[@"weiboComment"][@"member"][@"userid"];
    }

    NSLog(@"关注查询的请求参数:%@",paras);
    [HMHttpTool get:url params:paras success:^(id responseObj) {
        NSLog_JSON(@"关注查询结果%@",responseObj);
        if([responseObj[@"status"] isEqual:@1]){ NSArray * ary = responseObj[@"data"][@"pictures"];
            if (!(ary.count ==0) ) {

            }
            if([responseObj[@"data"][@"isFollow"] isEqual:@1]){
                [guanzhuBt setTitle:@"已关注" forState:UIControlStateNormal];
            }else{
                [guanzhuBt setTitle:@"关注" forState:UIControlStateNormal];
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}


@end
