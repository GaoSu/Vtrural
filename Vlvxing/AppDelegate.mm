//
//  AppDelegate.m
//  Vlvxing //grmTJ新增加的代码
// //之前注释的
//  Created by 王静雨 on 2017/5/18.
//  Copyright © 2017年 王静雨. All rights reserved.
///增加实时广告功能

#import "AppDelegate.h"
#import <UMSocialCore/UMSocialCore.h>
#import "VLXMessageCenterVC.h"//推送跳转页面
#import "VLXWebViewVC.h"//信用卡or网页
#import "VLXRouteDetailVC.h"//线路详情
#import "VLX_TicketViewController.h"//机票

#import "AppDelegate+customInit.h"
#import "UMMobClick/MobClick.h"



//融云
#import <RongIMLib/RongIMLib.h>
#import <RongIMKit/RongIMKit.h>
#import "VLX_chatViewController0.h"

//#import<CommonCrypto/CommonDigest.h>//sha1哈希算法


@interface AppDelegate ()<UNUserNotificationCenterDelegate,NotificationViewDelegate,RCIMUserInfoDataSource>//,RCIMUserInfoDataSource,RCIMGroupInfoDataSource>
@property(nonatomic,strong)BMKMapManager * mapManager;
@property (nonatomic, strong) NSDictionary *userInfo;//推送的某个属性
//@property (nonatomic, strong)UIImageView *advertiseView;//加载三秒广告 //过会删除

@property (nonatomic, strong)NSString *imgUrlString;//广告的地址

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.


    //rongyun设置代理;
//    [[RCIM sharedRCIM] setUserInfoDataSource:self];
//    [[RCIM sharedRCIM] setGroupInfoDataSource:self];


    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSLog(@"APP当前版本:%@",app_Version);//只是xcode内部版本,不是上线版本,
    
    NSMutableDictionary * para = [NSMutableDictionary dictionary];
    para[@"id"] = @1;
    NSString * url = [NSString stringWithFormat:@"%@%@",tangyangURL,@"getIosVersio"];

//    NSLog(@"version版本号:%@\nbuild版本号:%@",saveVersionStr,curVersionStr);
    NSLog(@"APP当前版本:%@",app_Version);
    [HMHttpTool get:url params:para success:^(id responseObj) {
        NSLog(@"服务器版本号:%@",responseObj);
//        NSLog(@"版本号%@",responseObj[@"version"]);
        
        float versonNumber =[responseObj[@"version"] floatValue];
        float localVersonNumber = [app_Version floatValue];
        //服务器返回的版本号大于当前版本号,就有提示,当上线完成之后,再让服务器修改,
        if (versonNumber>localVersonNumber) {
            UIAlertView *alvertView=[[UIAlertView alloc]initWithTitle:nil message:@"发现新版本,是否更新?" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
            [alvertView show];
        }else
        {
        }

    } failure:^(NSError *error) {
//        NSLog(@"版本号%@",error);
    }];
    
    
    
    self.window = [UIWindow new];
    //需要设置和导航栏一样的颜色，否则隐藏导航栏时会出现黑色
    [self.window setBackgroundColor:[UIColor whiteColor]];
    [self.window setFrame:[UIScreen mainScreen].bounds];






    //显示状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];//影藏否
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];//样式
    
//    [self.window setRootViewController:[CYLTabBarControllerConfig new].tabBarController];
    [self customRootViewController];



    //友盟分享 三方登陆
    [self setUmSocial];
    
    //友盟统计
    //友盟统计
    UMConfigInstance.appKey = @"593df7b97666133db8001383";
    UMConfigInstance.channelId = @"App Store";
    [MobClick startWithConfigure:UMConfigInstance];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;


    //注册百度
    [self registBaidu];
    //注册微信
    [self registerWX];

    //推送
    [self changePushState:launchOptions];


    /*

   // 先创建一个semaphore
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    __block CLPlacemark* start;
    NSString * url_ad = [NSString stringWithFormat:@"%@%@",tang_BENDIJIEKOU_URL,@"/SysAdController/getSlideShow.json?categoryId=5"];

    [HMHttpTool get:url_ad params:nil success:^(id responseObj) {
        if([responseObj[@"status"] isEqual:@1]){
            NSArray * aray = [responseObj[@"data"] copy];
            if (aray.count==0) {
                NSLog(@"节日空空空空空空空空空空空空");
            }
            else{
                NSDictionary * dic = [responseObj[@"data"][0] copy];
                // 1.地址
                _imgUrlString = dic[@"adpicture"];//imageArray_0[0];;
                NSLog(@"gunaggao地址%@",_imgUrlString);



                NSDictionary *dic_ad = [NSDictionary dictionaryWithObject:_imgUrlString forKey:@"adpicture"];
                //创建通知并发送
                [[NSNotificationCenter defaultCenter] postNotificationName:@"qidongyeguanggao" object:nil userInfo:dic_ad];//启动页广告

                //发出已完成的信号,不是自己写的
                dispatch_semaphore_signal(semaphore);

            }
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    //等待执行，不会占用资源
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return start;
*/



///*
// 融云IM ↓↓↓↓↓↓↓↓
//*/
//    //初始化
    [[RCIM sharedRCIM] initWithAppKey:@"cpj2xarlc1xyn"];
//    //
//
//
//
//
//    // /*


    NSString * tURL = [NSString stringWithFormat:@"%@%@",tang_BENDIJIEKOU_URL,@"/rong/getToken.json"];
    NSMutableDictionary * tPara = [NSMutableDictionary dictionary];

    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString * myselfUserId_0 = [userDefaultes stringForKey:@"alias"];
    NSString *tihuanStr = [myselfUserId_0 stringByReplacingOccurrencesOfString:@"vlvxing" withString:@""];
    NSString * myselfUserId = tihuanStr;//正式的用户id,真实的用户id

    tPara[@"userId"]= myselfUserId;


    [HMHttpTool get:tURL params:tPara success:^(id responseObj) {
        NSLog_JSON(@"获取融云token👌:%@",responseObj);//
        if ([responseObj[@"status"] isEqual:@1]) {
            [[RCIM sharedRCIM] connectWithToken:responseObj[@"data"]    success:^(NSString *userId) {
                        NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
                [[RCIM sharedRCIM]setUserInfoDataSource:self];
                    } error:^(RCConnectErrorCode status) {
                        NSLog(@"登陆的错误码为:%ld", (long)status);
                    } tokenIncorrect:^{

                        NSLog(@"token错误");
                    }];
        }



    } failure:^(NSError *error) {
        NSLog_JSON(@"获取融云token失败:%@",error);
    }];
//
//   // */http://app.mtvlx.cn/lvxingrong/getToken.json?userId=513
//
//
//
//    [[RCIM sharedRCIM] connectWithToken:@"0ABt7ILPEShS9stGR+AJgN3bHoP4ztV1ORxxRULm/FLmvyxeqth6/QrQGCuRGPBUkOFQ2cmYVi9C+B2yuDZfcA=="     success:^(NSString *userId) {
//        NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
//    } error:^(RCConnectErrorCode status) {
//        NSLog(@"登陆的错误码为:%ld", (long)status);
//    } tokenIncorrect:^{
//
//        //token过期或者不正确。
//        //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
//        //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
//        NSLog(@"token错误");
//    }];








    [self.window makeKeyAndVisible];




    ////////////////////////////////////////↓↓↓↓↓↓↓
//    //启动页广告加载
    // 1.判断沙盒中是否存在广告图片，如果存在，直接显示
//    NSString *filePath = [self getFilePathWithImageName:[kUserDefaults valueForKey:adImageName]];
//    BOOL isExist = [self isFileExistWithFilePath:filePath];
//    if (isExist) {// 图片存在
//        AdvertiseView *advertiseView = [[AdvertiseView alloc] initWithFrame:self.window.bounds];
//        advertiseView.filePath = filePath;
//        [advertiseView show];
//    }
    // 2.无论沙盒中是否存在广告图片，都需要重新调用广告接口，判断广告是否更新
//    [self getAdvertisingImage];
    ////////////////////////////////////////↑↑↑↑↑↑↑

//**/信用卡
//信用卡功能需要具备金融资质,所以,该接口是为了在上线时候,将信用卡功能隐藏掉,等待上线成功之后,再修改状态,将信用卡功能展示出来,
    [self readXYKData];//读取信用卡展示与否的信息



    //初始化融云
//    [[RCIM sharedRCIM] initWithAppKey:@"cpj2xarlc1xyn"];
//    //获取token
//    NSString * gettokenURL =[ NSString stringWithFormat:@"%@%@",tang_BENDIJIEKOU_URL,@"/rong/getToken.json"];
//    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
//    NSString * myselfUserId_0 = [userDefaultes stringForKey:@"alias"];
//    NSString *userID = [myselfUserId_0 stringByReplacingOccurrencesOfString:@"vlvxing" withString:@""];
//    NSMutableDictionary * parama = [NSMutableDictionary dictionary];
//    parama[@"userId"]=userID;
//    [HMHttpTool get:gettokenURL params:parama success:^(id responseObj) {
//        NSLog(@"%@",responseObj);
//        if ([responseObj[@"status"] isEqual:@1]) {
//            ///////
//            [[RCIM sharedRCIM] connectWithToken:responseObj[@"data"] success:^(NSString *userId) {
//                NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
//            } error:^(RCConnectErrorCode status) {
//                NSLog(@"登陆的错误码为:%ld", (long)status);
//            } tokenIncorrect:^{
//                //token过期或者不正确。
//                //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
//                //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
//                NSLog(@"token错误");
//            }];
//        }
//    } failure:^(NSError *error) {
//        NSLog(@"%@",error);
//    }];





    return YES;
}

-(void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion{

    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString * myselfUserId_0 = [userDefaultes stringForKey:@"alias"];
    NSString *tihuanStr = [myselfUserId_0 stringByReplacingOccurrencesOfString:@"vlvxing" withString:@""];
    NSString * myselfUserId = tihuanStr;//正式的用户id,真实的用户id

    NSString * username = [userDefaultes stringForKey:@"nameForRY"];//读取字符串类型的数据
//    NSLog(@"读取的名字?%@",username);
    NSString * picture = [userDefaultes stringForKey:@"pictureForRY"];//读取字符串类型的数据
//    NSLog(@"读取的图像?%@",picture);

    if ([userId isEqualToString:myselfUserId]) {
        RCUserInfo * u_Info = [[RCUserInfo alloc]init];
        u_Info.userId = userId;
        u_Info.name = username;
        u_Info.portraitUri = picture;
        return completion(u_Info);
    }
    return completion(nil);
}

-(void)readXYKData{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    //读取数据
    NSString * stringgggg = [[NSString alloc]init];
    stringgggg = [userDefaultes  stringForKey:@"is_XINGYONGKA"];
    NSLog(@"stringgggg:%@",stringgggg);
    if (stringgggg == nil) {
//        NSLog(@"getXYKData-getXYKData-getXYKData");
        [self getXYKData];
    }
    else{//如果沙盒有值,请求一下,判断值是否改变,若改变,则重新存沙盒
    //http://app.mtvlx.cn/ticket/getCardStatus
//        NSString * url =@"http://app.mtvlx.cn/ticket/getCardStatus";
        NSString * url = [NSString stringWithFormat:@"%@%@",tangyangURL,@"getCardStatus"];//@"http://app.mtvlx.cn/ticket/getCardStatus";


        [HMHttpTool get:url params:nil success:^(id responseObj) {
            if ([responseObj[@"status"] isEqualToString:@"1"]) {
                NSString * isxykkkk = responseObj[@"cardStatus"];
                if(![isxykkkk isEqualToString:stringgggg]){
                    NSLog(@"我们不一样");
                    [self getXYKData];
                }else{
                    NSLog(@"其实也一样");
                    NSLog(@"%@````%@",isxykkkk,stringgggg);
                }
            }
        } failure:^(NSError *error) {
            NSLog(@"xyk请求失败");
        }];
    }
}
-(void)getXYKData{

//    NSMutableDictionary * para = [[NSMutableDictionary alloc]init];
//    para[@"Status"]=@1;
//    NSString * url = @"http://app.mtvlx.cn/ticket/getCardStatus";//[NSString stringWithFormat:@"%@%@",ftpPath,@"/IosCard/getCardStatus.json"];
    NSString * url = [NSString stringWithFormat:@"%@%@",tangyangURL,@"getCardStatus"];
    NSLog(@"url:::%@",url);
    [HMHttpTool get:url params:nil success:^(id responseObj) {
        NSLog(@"%@",responseObj);
        if ([responseObj[@"status"] isEqualToString:@"1"]) {
            NSString * isxykkkk = responseObj[@"cardStatus"];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:isxykkkk forKey:@"is_XINGYONGKA"];
            [defaults synchronize];//同步到plist文件中
            NSLog(@"存沙盒:%@", [defaults  stringForKey:@"is_XINGYONGKA"]);
        }else{
            NSLog(@"不存沙盒");
        }
    } failure:^(NSError *error) {
        NSLog(@"xyk请求失:%@",error);
    }];

}
//跳转App Store下载新版本
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0){
            NSString * AppstoreUrl = @"itms-apps://itunes.apple.com/app/id1263429853";
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:AppstoreUrl]];
    }
    else{
    }
}

#pragma mark---微信支付相关
-(void)registerWX
{
    [WXApi registerApp:@"wxd3cb391989fe67f1" withDescription:@"Vlvxing"];
}
- (void)onResp:(BaseResp *)resp{
    
    if ([resp isKindOfClass:[PayResp class]]){
        
        PayResp *response=(PayResp*)resp;
        switch(response.errCode)
        {
            case WXSuccess:
            {
                NSNotification *notification = [NSNotification notificationWithName:@"WXPayNotification" object:@"success"];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
                break;
            }
                
            default:
            {
                NSNotification *notification = [NSNotification notificationWithName:@"WXPayNotification" object:@"fail"];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
                //MyLog(@"支付失败，retcode=%d",resp.errCode);
                break;
            }
        }
    }
}
#pragma mark
#pragma mark---支付宝相关
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    [SVProgressHUD dismiss];
    //＝＝＝＝支付宝，微信＝＝＝＝＝
    //  BOOL result = FALSE;
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (result == FALSE) {
        if([sourceApplication compare:@"com.tencent.xin"] == NSOrderedSame){
            
            return [WXApi handleOpenURL:url delegate:self];
            
        }else if([sourceApplication compare:@"com.alipay.iphoneclient"] == NSOrderedSame){
            
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                
//                MyLog(@"result = %@",resultDic);
//                NSLog_JSON(@"郭荣明支付结果_100:%@",resultDic);
                [[NSNotificationCenter defaultCenter] postNotificationName:@"AliPayNotification" object:nil userInfo:resultDic];
                [SVProgressHUD dismiss];
            }];
            return YES;
        }
    }
    
    [WXApi handleOpenURL:url delegate:self];
    return result;
}
#pragma mark
#pragma mark 注册百度地图
-(void)registBaidu
{
    self.mapManager=[[BMKMapManager alloc]init];
    BOOL ret =[self.mapManager start:@"7MwNNcbibbA7DuCFsaH7BrL19aS8p2fu" generalDelegate:nil];
    NSLog(@"百度地图启动：%d",ret);
}

#pragma mark---设置导航栏
- (void)customNavigationBar//设置导航栏
{
    
    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
    UIImage *backgroundImage = [UIImage imageWithColor:[UIColor hexStringToColor:@"#ffffff"]];
    NSDictionary *textAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:19],
                                     NSForegroundColorAttributeName : [UIColor hexStringToColor:@"#313131"],};
    [navigationBarAppearance setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    [navigationBarAppearance setTitleTextAttributes:textAttributes];
    //去除导航栏黑线
    //    [navigationBarAppearance setShadowImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"dbdbdb"]]];
    
}
#pragma mark 友盟登录分享
-(void)setUmSocial{




    [[UMSocialManager defaultManager]openLog:YES];
    [[UMSocialManager defaultManager]setUmSocialAppkey:@"593df7b97666133db8001383"];
    [self configUSharePlatforms];

    [self confitUShareSettings];
    


}

     #pragma mark 友盟分享登录的实现方法
     - (void)confitUShareSettings
     {
     /*
     * 打开图片水印
     */
    //[UMSocialGlobal shareInstance].isUsingWaterMark = YES;

    /*
     * 关闭强制验证https，可允许http图片分享，但需要在info.plist设置安全域名
     <key>NSAppTransportSecurity</key>
     <dict>
     <key>NSAllowsArbitraryLoads</key>
     <true/>
     </dict>
     */
    //[UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;

}

- (void)configUSharePlatforms
{

    /* 设置微信的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wxd3cb391989fe67f1" appSecret:@"226c687e3cf3f69ed0ee44a54cc1aef8" redirectURL:@"http://mobile.umeng.com/social"];
    /*
     * 移除相应平台的分享，如微信收藏
     */
    //[[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];

    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1106150727"/*设置QQ平台的appID*/  appSecret:@"GEvMNnkDFEYKlMXG" redirectURL:@"http://mobile.umeng.com/social"];

    /* 设置新浪的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"3634229237"  appSecret:@"8fdee4deab33dd97afc45f2648270bea" redirectURL:@"http://sns.whalecloud.com"];
    
    
    
}


-(void)changePushState:(NSDictionary * )launchLaunchDic {

//        if([NSUserDefaults defaulttoken]){
    [self setupUMPushWithLaunchOptions:launchLaunchDic];//创建一个配置友盟推送的方法
//        }else{
//            [UMessage unregisterForRemoteNotifications];
//        }
}

-(void)setupUMPushWithLaunchOptions:(NSDictionary *)launchOptions{
    MyLog(@"launchOptions:%@",launchOptions);

    //设置 AppKey 及 LaunchOptions
    [UMessage startWithAppkey:@"593df7b97666133db8001383" launchOptions:launchOptions];//推送所需key

    //1.3.0版本开始简化初始化过程。如不需要交互式的通知，下面用下面一句话注册通知即可。
    [UMessage registerForRemoteNotifications];
//    [UMessage setLogEnabled:YES];//grmtj 开启log

    //iOS10必须加下面这段代码。
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate=self;
    UNAuthorizationOptions types10=UNAuthorizationOptionBadge|	UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:types10 	completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            //点击允许
            NSLog(@"用户允许了推送功能");
        } else {
            //点击不允许
            NSLog(@"用户禁止了推送功能");
        }

    }];
    //for log
    [UMessage setLogEnabled:YES];

    if (launchOptions)
    {
        NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
//        NSString *extone=userInfo[@"extone"];//注
//                NSDictionary *dict = [userInfo valueForKey:@"aps"];
        //do something what u want.
        self.userInfo = userInfo;
        MyLog(@"didReceiveRemoteNotification通知数量=====%@",userInfo);
//        MyLog(@"grm1%@",userInfo[@"mes_type"]);
        MyLog(@"applicationState=====%ld",(long)[UIApplication sharedApplication].applicationState);
        if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive)
        {

            //            if ([extone isEqualToString:@"0"]) {
            //                //问诊/坐诊
            //                [self.main reFreshInterr];
            //            }else{
            //                //1系统消息
            //
            //                [self.main turnToMessage];
            //            }
        }
    }
    else{
        NSLog(@"没有lesssssss");
    }


}
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(nonnull NSDictionary *)userInfo fetchCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler{

    completionHandler(UIBackgroundFetchResultNewData);
    NSLog(@"grm1%@",userInfo[@"aps"][@"badge"]);
//    NSString * badge = [NSString stringWithFormat:@"%@",userInfo[@"aps"][@"badge"]];
//    [[UIApplication sharedApplication]setApplicationIconBadgeNumber:[badge intValue]];

}
//友盟推送
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken//返回deviceToken
{

//        [UMessage registerDeviceToken:deviceToken];


    NSString *strDeviceToken = [[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]                  stringByReplacingOccurrencesOfString: @">" withString: @""] stringByReplacingOccurrencesOfString: @" " withString: @""];
    MyLog(@"友,设备号%@",strDeviceToken);//是token 在安装APP时候固定下来

}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    //如果注册不成功，打印错误信息，可以在网上找到对应的解决方案
    //如果注册成功，可以删掉这个方法
    MyLog(@"application:didFailToRegisterForRemoteNotificationsWithError: %@", error);
}
//友盟协议方法: iOS10以下使用这个方法接收通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{


    [UMessage setAutoAlert:NO];//关闭U-Push自带的弹出框
    [UMessage didReceiveRemoteNotification:userInfo];
    self.userInfo = userInfo;
        MyLog(@"didReceiveRemoteNotification什数量=====%@",userInfo);//注
//        MyLog(@"didReceiveRemoteNotification什%@",userInfo[@"mes_type"]);//注
//        self.messageType = [userInfo[@"mes_type"] intValue];//注
    NSDictionary *alertStrDic = userInfo[@"aps"][@"alert"];
    NSString *alertStr = alertStrDic[@"body"];

    //    MyLog(@"applicationState=====%ld",(long)[UIApplication sharedApplication].applicationState);
    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
    {
        NSLog(@"8888888");
        //1系统消息
//         NotificationView * notifi=[[NotificationView alloc] initWithTitle:alertStr];
//         notifi.notiDelegate=self;
//         [notifi show];
    }
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive)
    {

        NSLog(@"7777777");
        UINavigationController * nav = self.cyl_tabBarController.selectedViewController;
        //            //1系统消息
        //            [self.main turnToMessage];
    }
    
}

//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;
    [UMessage setAutoAlert:YES];
    MyLog(@"前台收到通知的内容%@",userInfo);
//    NSString * badge = [NSString stringWithFormat:@"%@",userInfo[@"aps"][@"badge"]];
    NSDictionary *alertStrDic = userInfo[@"aps"][@"alert"];
    NSString *alertStr = alertStrDic[@"body"];
    NSString *typeStr = userInfo[@"tracingtype"];
    NSString *littleType = userInfo[@"tracingtypexiao"];
//    [[UIApplication sharedApplication]setApplicationIconBadgeNumber:1];//grm,icon角标数量
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台时的远程推送接受
        //必须加这句代码 统计点击数
        [UMessage didReceiveRemoteNotification:userInfo];

        //收到推送之后就会弹出系统消息//1系统消息
        NotificationView * notifi=[[NotificationView alloc] initWithTitle:alertStr];//注
        notifi.notiDelegate=self;//注
        [notifi show];//注

//        if ([userInfo[@"type"] integerValue]==2)
//        {//超过5分钟弹窗
//            NSLog(@"99999999");
//        }
    }
    else{

        NSLog(@"1010101010");
    }
    //当应用处于前台时提示设置，需要哪个可以设置哪一个
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);

}

//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{

    NSDictionary * userInfo = response.notification.request.content.userInfo;
    MyLog(@"houtai收到通知的内容%@",userInfo.mj_JSONString);
    [UMessage setAutoAlert:NO];
    NSDictionary *alertStrDic = userInfo[@"aps"][@"alert"];
    NSString *alertStr = alertStrDic[@"body"];
    if(userInfo[@"rc"]){
//        NSLog(@"融云");
//        NSLog(@"");
        UINavigationController *nav = self.cyl_tabBarController.selectedViewController;

        VLX_chatViewController0 * ryVc = [[VLX_chatViewController0 alloc]initWithConversationType:ConversationType_PRIVATE targetId:userInfo[@"rc"][@"fId"]];

        [nav pushViewController:ryVc animated:YES];




    }

//    NSString * badge = [NSString stringWithFormat:@"%@",userInfo[@"aps"][@"badge"]];
//    [[UIApplication sharedApplication]setApplicationIconBadgeNumber:1];//grm,icon角标数量

    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {

         NSLog(@"应用处于时的远程推处理");//
        NSLog(@"ppp::%@",userInfo[@"p"]);
        NSLog(@"alertStr:%@",alertStr);
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
//        NSLog(@"类型%@", NSStringFromClass([ppNum class]));
        NSLog(@"鬼%@",userInfo[@"category"]);
        if(userInfo[@"category"]==nil){
            //不跳转
        }else{
            [self objectWithJsonString:userInfo[@"category"]];
        }

    }else{
        NSLog(@"应用处于后台时的本地推送接");
    }
    
}

//解析出来的category,将其转换成标准的json格式
-(id)objectWithJsonString:(NSString *)jsonStr
{
    NSData *jsondata = [jsonStr dataUsingEncoding:NSASCIIStringEncoding];
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsondata options:NSJSONReadingAllowFragments error:nil];
    if (jsonObject != nil && error == nil){
        NSLog(@"category内容:%@",jsonObject);

        NSLog(@"类型%@", NSStringFromClass([jsonObject[@"data"][@"type"] class]));//NSNumber
        UINavigationController *nav = self.cyl_tabBarController.selectedViewController;
        if ([jsonObject[@"type"] isEqualToNumber:@1]) {//系统通知
            if ([jsonObject[@"data"][@"type"] isEqualToNumber:@0]) {
                VLXMessageCenterVC * messageCenter =[[VLXMessageCenterVC alloc]init];
                [nav pushViewController:messageCenter animated:YES];
            }
            else if([jsonObject[@"data"][@"type"] isEqualToNumber:@1]){
                VLXWebViewVC *webView = [[VLXWebViewVC alloc]init];
                webView.urlStr = jsonObject[@"data"][@"data"];
                [nav pushViewController:webView animated:YES];
            }
            else if([jsonObject[@"data"][@"type"] isEqualToNumber:@2]){

                NSString * classNamestr = jsonObject[@"data"][@"data"];
                id myObj = [[NSClassFromString(classNamestr) alloc] init];//找到类名,然后跳转
                [nav pushViewController:myObj animated:YES];

            }
            else if([jsonObject[@"data"][@"type"] isEqualToNumber:@3]){
                VLXRouteDetailVC * routeDetailVC = [[VLXRouteDetailVC alloc]init];
                routeDetailVC.travelproductID = jsonObject[@"data"][@"data"];
                [nav pushViewController:routeDetailVC animated:YES];
            }
        }
        else if ([jsonObject[@"type"] isEqualToNumber:@1]){//订单通知
            NSLog(@"订单通知");
        }
        //return jsonObject;
        return nil;
    }else{
        NSLog(@"222");
        return nil;
    }
}
-(void)NotificationDidSelected
{
    NSLog(@"444444");
}



#pragma mark

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
//    [SVProgressHUD dismiss];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    //当应用程序处于非活动状态时，重启暂停(或尚未启动)的任何任务。如果应用程序先前在后台，则可以选择刷新用户界面
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    //当应用程序即将终止时调用
}

////初始化广告页面
//- (void)getAdvertisingImage
//{
//
//    NSMutableArray * imageArray_0 = [NSMutableArray array];
//    NSString * url = [NSString stringWithFormat:@"%@%@",tang_BENDIJIEKOU_URL,@"/SysAdController/getSlideShow.json?categoryId=5"];
//    // 请求广告接口
//    [HMHttpTool post:url params:nil success:^(id responseObj) {
//        NSLog(@"节日图接口OK:%@",responseObj);
//        if([responseObj[@"status"] isEqual:@1]){
//            NSArray * aray = [responseObj[@"data"] copy];
//            if (aray.count==0) {
//                NSLog(@"节日空空空空空空空空空空空空");
//            }
//            else{
//            for (NSDictionary * dic in responseObj[@"data"]) {
//                NSLog(@"启动页节日广告%@",dic[@"adpicture"]);
//                [imageArray_0 addObject:dic[@"adpicture"]];
//            }
//
//            NSString *imageUrl = imageArray_0[0];
//            NSLog(@"immmmmgurl:%@",imageUrl);
//            // 获取图片名
//            NSArray *stringArr = [imageUrl componentsSeparatedByString:@"/"];
//            NSString *imageName = stringArr.lastObject;
//
//            // 拼接沙盒路径
//            NSString *filePath = [self getFilePathWithImageName:imageName];
//            BOOL isExist = [self isFileExistWithFilePath:filePath];
//            if (!isExist){// 如果该图片不存在，则删除老图片，下载新图片
//                ////下载新图片
//                [self downloadAdImageWithUrl:imageUrl imageName:imageName];}
//            }
//        }
//        else{
//            NSLog(@"不是节日");
//        }
//    } failure:^(NSError *error) {
//        NSLog(@"节日接口:%@",error);
//    }];
//
//
//}


//-(NSString *)sha1:(NSString * )str{//哈希
//
//    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
//
//    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
//
//    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
//
//    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
//
//    for(int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
//        [output appendFormat:@"%02x", digest[i]];
//    }
//
//    return output;
//}
//判断文件是否存在
- (BOOL)isFileExistWithFilePath:(NSString *)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirectory = FALSE;
    return [fileManager fileExistsAtPath:filePath isDirectory:&isDirectory];
}
//根据图片名拼接文件路径
- (NSString *)getFilePathWithImageName:(NSString *)imageName
{
    if (imageName) {

        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:imageName];

        return filePath;
    }

    return nil;
}


//下载新图片
//- (void)downloadAdImageWithUrl:(NSString *)imageUrl imageName:(NSString *)imageName
//{
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//
//        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
//        UIImage *image = [UIImage imageWithData:data];
//
//        NSString *filePath = [self getFilePathWithImageName:imageName]; // 保存文件的名称
//
//        if ([UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES]) {// 保存成功
//            NSLog(@"保存成功");
//            [self deleteOldImage];
//            [kUserDefaults setValue:imageName forKey:adImageName];
//            [kUserDefaults synchronize];
//            // 如果有广告链接，将广告链接也保存下来
//        }else{
//            NSLog(@"保存失败");
//        }
//
//    });
//}

//删除旧图片
//- (void)deleteOldImage
//{
//    NSString *imageName = [kUserDefaults valueForKey:adImageName];
//    if (imageName) {
//        NSString *filePath = [self getFilePathWithImageName:imageName];
//        NSFileManager *fileManager = [NSFileManager defaultManager];
//        [fileManager removeItemAtPath:filePath error:nil];
//    }
//}
@end

@implementation NSURLRequest(DataController)

+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host
{
    return YES;
}
@end
