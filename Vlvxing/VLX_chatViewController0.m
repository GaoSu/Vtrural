
//
//  VLX_chatViewController0.m
//  Vlvxing
//
//  Created by grm on 2018/4/4.
//  Copyright © 2018年 王静雨. All rights reserved.
//

#import "VLX_chatViewController0.h"

@interface VLX_chatViewController0 ()<RCIMUserInfoDataSource>

@end

@implementation VLX_chatViewController0

//-(id)init{
//    self = [super init];
//    if (self) {
//        [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),@(ConversationType_GROUP),@(ConversationType_DISCUSSION),@(ConversationType_CUSTOMERSERVICE)]];
//    }
//    return self;
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navUI];
}
-(void)navUI{
    UIBarButtonItem *leftButon = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return-red"] style:UIBarButtonItemStylePlain target:nil action:nil];
    [leftButon setTarget:self];
    self.navigationItem.leftBarButtonItem = leftButon;
    self.navigationController.navigationBar.tintColor = orange_color;//原色;
    self.navigationItem.leftBarButtonItem.customView.frame = CGRectMake(0, 0, 100, 50);
    [self.navigationItem.leftBarButtonItem setAction:@selector(tapLeftButton1)];

     [[RCIM sharedRCIM]setUserInfoDataSource:self];
}
-(void)tapLeftButton1{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion{


    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString * myselfUserId_0 = [userDefaultes stringForKey:@"alias"];
    NSString *tihuanStr = [myselfUserId_0 stringByReplacingOccurrencesOfString:@"vlvxing" withString:@""];
    NSString * myselfUserId = tihuanStr;//正式的用户id,真实的用户id

    NSString * username = [userDefaultes stringForKey:@"nameForRY"];//读取字符串类型的数据
    NSString * picture = [userDefaultes stringForKey:@"pictureForRY"];//读取字符串类型的数据
    if ([userId isEqualToString:myselfUserId]) {
        RCUserInfo * u_Info = [[RCUserInfo alloc]init];
        u_Info.userId = userId;
        u_Info.name = username;
        u_Info.portraitUri = picture;
        return completion(u_Info);
    }
    else{
        RCUserInfo * u_Info = [[RCUserInfo alloc]init];
        u_Info.userId = _tagID;
        u_Info.name = self.title;
        u_Info.portraitUri = _pictureStr;
        return completion(u_Info);
    }

    return completion(nil);
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
