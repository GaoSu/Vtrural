//
//  VLXRecordVideoDetailVC.m
//  Vlvxing
//
//  Created by 王静雨 on 2017/6/13.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXRecordVideoDetailVC.h"
#import "VLXMenuPopView.h"
#import "VLXCourseAlertView.h"
#import "VLXRecordEditVideoVC.h"
#import "ShareBtnView.h"
@interface VLXRecordVideoDetailVC ()<ShareBtnViewDelegate>
@property (nonatomic,strong)UIImageView *iconImageView;
@property (nonatomic,strong)UIView *bottomView;
@property (nonatomic,strong)VLXMenuPopView *menuView;
@property (nonatomic,assign)BOOL isShowMenu;
@property(nonatomic,weak)UIView * blackView;
@property(nonatomic,weak)ShareBtnView *shareView;
@end

@implementation VLXRecordVideoDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _isShowMenu=NO;
    if (_model) {
        [self createUI];
    }else if (_courseModel)
    {
        [self createUIWithCourse];
    }else if (_detailModel)
    {
        [self createUIWithDetail];
    }
}
#pragma mark---数据
-(void)loadDataWithDeleteEvent:(NSString *)pathinfoID//删除轨迹中的单个事件
{
    [SVProgressHUD showWithStatus:@"正在删除"];
    NSMutableDictionary * dic=[NSMutableDictionary dictionary];
    
    dic[@"token"]=[NSString getDefaultToken];//
    dic[@"pathInfoId"]=[ZYYCustomTool checkNullWithNSString:pathinfoID];
    NSString * url=[NSString stringWithFormat:@"%@/TraRoadController/auth/deletePathinfo.html",ftpPath];
    NSLog(@"%@",dic);
    [SPHttpWithYYCache postRequestUrlStr:url withDic:dic success:^(NSDictionary *requestDic, NSString *msg) {
        [SVProgressHUD dismiss];
        //        NSLog(@"%@",requestDic.mj_JSONString);
        [SVProgressHUD showSuccessWithStatus:@"删除成功"];
        if ([requestDic[@"status"] integerValue]==1) {
 
            [self.navigationController popViewControllerAnimated:YES];
            
        }else
        {
            [SVProgressHUD showErrorWithStatus:msg];
        }
        
    } failure:^(NSString *errorInfo) {
        [SVProgressHUD dismiss];
        
    }];
}
#pragma mark
-(void)createUI
{
    [self setNav];
    _iconImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-80)];
    _iconImageView.contentMode=UIViewContentModeScaleAspectFit;
    [self.view addSubview:_iconImageView];
    NSLog(@"%@",_model.coverurl);
    _iconImageView.userInteractionEnabled=YES;
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:[ZYYCustomTool checkNullWithNSString:_model.coverurl]] placeholderImage:nil];
    UIButton *playBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    playBtn.center=_iconImageView.center;
    playBtn.bounds=CGRectMake(0, 0, 36, 36);
    [playBtn setImage:[UIImage imageNamed:@"video"] forState:UIControlStateNormal];
    [playBtn addTarget:self action:@selector(btnClickedToPlay:) forControlEvents:UIControlEventTouchUpInside];
    [_iconImageView addSubview:playBtn];
    //
    _bottomView=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_iconImageView.frame), kScreenWidth, 80)];
    _bottomView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_bottomView];
    //
    UILabel *titleLab=[[UILabel alloc] initWithFrame:CGRectMake(11.5, 15, kScreenWidth-11.5*2, 18)];
    titleLab.text=[ZYYCustomTool checkNullWithNSString:_model.address];
    titleLab.font=[UIFont boldSystemFontOfSize:19];
    titleLab.textColor=[UIColor hexStringToColor:@"#313131"];
    titleLab.textAlignment=NSTextAlignmentLeft;
    [_bottomView addSubview:titleLab];
    //
    UILabel *dateLab=[[UILabel alloc] initWithFrame:CGRectMake(11.5, CGRectGetMaxY(titleLab.frame)+14, kScreenWidth-11.5*2, 11)];
    dateLab.textColor=[UIColor hexStringToColor:@"#666666"];
    dateLab.font=[UIFont systemFontOfSize:12];
    dateLab.text=[[NSString stringWithFormat:@"%@",_model.createtime] RwnTimeExchange5];
    dateLab.textAlignment=NSTextAlignmentLeft;
    [_bottomView addSubview:dateLab];
    
}
-(void)createUIWithCourse
{
    [self setNav];
    _iconImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-80)];
    _iconImageView.contentMode=UIViewContentModeScaleAspectFit;
    [self.view addSubview:_iconImageView];
    NSLog(@"%@",_courseModel.coverUrl);
    _iconImageView.userInteractionEnabled=YES;
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:[ZYYCustomTool checkNullWithNSString:_courseModel.coverUrl]] placeholderImage:nil];
    UIButton *playBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    playBtn.center=_iconImageView.center;
    playBtn.bounds=CGRectMake(0, 0, 36, 36);
    [playBtn setImage:[UIImage imageNamed:@"video"] forState:UIControlStateNormal];
    [playBtn addTarget:self action:@selector(btnClickedToPlay:) forControlEvents:UIControlEventTouchUpInside];
    [_iconImageView addSubview:playBtn];
    //
    _bottomView=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_iconImageView.frame), kScreenWidth, 80)];
    _bottomView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_bottomView];
    //
    UILabel *titleLab=[[UILabel alloc] initWithFrame:CGRectMake(11.5, 15, kScreenWidth-11.5*2, 18)];
    titleLab.text=[ZYYCustomTool checkNullWithNSString:_courseModel.address];
    titleLab.font=[UIFont boldSystemFontOfSize:19];
    titleLab.textColor=[UIColor hexStringToColor:@"#313131"];
    titleLab.textAlignment=NSTextAlignmentLeft;
    [_bottomView addSubview:titleLab];
    //
    UILabel *dateLab=[[UILabel alloc] initWithFrame:CGRectMake(11.5, CGRectGetMaxY(titleLab.frame)+14, kScreenWidth-11.5*2, 11)];
    dateLab.textColor=[UIColor hexStringToColor:@"#666666"];
    dateLab.font=[UIFont systemFontOfSize:12];
    dateLab.text=[[NSString stringWithFormat:@"%f",[_courseModel.time floatValue]*1000] RwnTimeExchange5];
    dateLab.textAlignment=NSTextAlignmentLeft;
    [_bottomView addSubview:dateLab];
}
-(void)createUIWithDetail
{
    [self setNav];
    _iconImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-80)];
    _iconImageView.contentMode=UIViewContentModeScaleAspectFit;
    [self.view addSubview:_iconImageView];
    NSLog(@"%@",_detailModel.coverurl);
    _iconImageView.userInteractionEnabled=YES;
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:[ZYYCustomTool checkNullWithNSString:_detailModel.coverurl]] placeholderImage:nil];
    UIButton *playBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    playBtn.center=_iconImageView.center;
    playBtn.bounds=CGRectMake(0, 0, 36, 36);
    [playBtn setImage:[UIImage imageNamed:@"video"] forState:UIControlStateNormal];
    [playBtn addTarget:self action:@selector(btnClickedToPlay:) forControlEvents:UIControlEventTouchUpInside];
    [_iconImageView addSubview:playBtn];
    //
    _bottomView=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_iconImageView.frame), kScreenWidth, 80)];
    _bottomView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_bottomView];
    //
    UILabel *titleLab=[[UILabel alloc] initWithFrame:CGRectMake(11.5, 15, kScreenWidth-11.5*2, 18)];
    titleLab.text=[ZYYCustomTool checkNullWithNSString:_detailModel.address];
    titleLab.font=[UIFont boldSystemFontOfSize:19];
    titleLab.textColor=[UIColor hexStringToColor:@"#313131"];
    titleLab.textAlignment=NSTextAlignmentLeft;
    [_bottomView addSubview:titleLab];
    //
    UILabel *dateLab=[[UILabel alloc] initWithFrame:CGRectMake(11.5, CGRectGetMaxY(titleLab.frame)+14, kScreenWidth-11.5*2, 11)];
    dateLab.textColor=[UIColor hexStringToColor:@"#666666"];
    dateLab.font=[UIFont systemFontOfSize:12];
    dateLab.text=[[NSString stringWithFormat:@"%@",_detailModel.createtime] RwnTimeExchange5];
    dateLab.textAlignment=NSTextAlignmentLeft;
    [_bottomView addSubview:dateLab];
}
- (void)setNav{
    
    
    self.view.backgroundColor=[UIColor blackColor];
    //左边按钮
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 20, 20);
    [leftBtn setImage:[UIImage imageNamed:@"return-red"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(tapLeftButton:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    if (_isHiddenRight) {
        
    }else
    {
        //右边按钮
        if (_model) {
            //右边按钮
            UIView * rightview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 20)];
            rightview.backgroundColor=[UIColor whiteColor];
            
            UIImageView * rightimageview=[[UIImageView alloc]initWithFrame:CGRectMake(36, 0, 4, 20)];
            rightimageview.image=[UIImage imageNamed:@"more"];
            [rightview addSubview:rightimageview];
            
            UIBarButtonItem * rightBaritem=[[UIBarButtonItem alloc]initWithCustomView:rightview];
            self.navigationItem.rightBarButtonItem=rightBaritem;
            
            rightview.userInteractionEnabled=YES;
            UITapGestureRecognizer * rightTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rightClick)];
            [rightview addGestureRecognizer:rightTap];
        }else if (_courseModel)
        {
            
        }else if (_detailModel)
        {
            //右边按钮
            UIView * rightview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 20)];
            rightview.backgroundColor=[UIColor whiteColor];
            
            UIImageView * rightimageview=[[UIImageView alloc]initWithFrame:CGRectMake(36, 0, 4, 20)];
            rightimageview.image=[UIImage imageNamed:@"more"];
            [rightview addSubview:rightimageview];
            
            UIBarButtonItem * rightBaritem=[[UIBarButtonItem alloc]initWithCustomView:rightview];
            self.navigationItem.rightBarButtonItem=rightBaritem;
            
            rightview.userInteractionEnabled=YES;
            UITapGestureRecognizer * rightTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rightClick)];
            [rightview addGestureRecognizer:rightTap];
        }
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
    __block VLXRecordVideoDetailVC * blockSelf=self;;
    shareView.btnShareBlock=^(NSInteger tag)
    {
        NSString *contentStr;
        if (_model) {
            contentStr = _model.address;
        }else if (_courseModel)
        {
            contentStr = _courseModel.address;
        }else if (_detailModel)
        {
            contentStr = _detailModel.address;
        }else{
            contentStr =@"看世界、V旅行！";
        }
        
        MyLog(@"share:%ld",tag);
        //555,QQ 556,新浪微博 557,微信 558,朋友圈
        switch (tag) {
            case 555:
            {
                [ShareTool shareWebPageToPlatformType:UMSocialPlatformType_QQ andThumbURL:@"http://img3.2345.com/toolsimg/baike/collect/sheying/73b2150ajw1e6wsbsp5lbj20hs0hs3zs.jpg" andTitle:@"V旅行" andDesc:contentStr andWebPageUrl:url];
                [blockSelf clcikClose];
                
            }
                break;
            case 556:
            {
                
                [ShareTool shareWebPageToPlatformType:UMSocialPlatformType_Sina andThumbURL:@"http://img3.2345.com/toolsimg/baike/collect/sheying/73b2150ajw1e6wsbsp5lbj20hs0hs3zs.jpg" andTitle:@"V旅行" andDesc:contentStr andWebPageUrl:url];
                [blockSelf clcikClose];
            }
                break;
            case 557:
            {
                [ShareTool shareWebPageToPlatformType:UMSocialPlatformType_WechatSession andThumbURL:@"http://img3.2345.com/toolsimg/baike/collect/sheying/73b2150ajw1e6wsbsp5lbj20hs0hs3zs.jpg" andTitle:@"V旅行" andDesc:contentStr andWebPageUrl:url];
                [blockSelf clcikClose];
            }
                break;
            case 558:
            {
                [ShareTool shareWebPageToPlatformType:UMSocialPlatformType_WechatTimeLine andThumbURL:@"http://img3.2345.com/toolsimg/baike/collect/sheying/73b2150ajw1e6wsbsp5lbj20hs0hs3zs.jpg" andTitle:@"V旅行" andDesc:contentStr andWebPageUrl:url];
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

#pragma mark
#pragma mark---事件
-(void)btnClickedToPlay:(UIButton *)sender
{
    NSLog(@"轨迹_2_video");
    KYLocalVideoPlayVC *pushViewController = [[KYLocalVideoPlayVC alloc] init];
    pushViewController.title = @"短视频";
    if (_model) {
        pushViewController.URLString=_model.videourl;
        NSLog(@"视频1地址%@",pushViewController.URLString);
    }else if (_courseModel)
    {
        pushViewController.URLString=_courseModel.videoUrl;
        NSLog(@"视频2地址%@",pushViewController.URLString);
    }else if (_detailModel)
    {
        pushViewController.URLString=_detailModel.videourl;
        NSLog(@"视频3地址%@",pushViewController.URLString);
    }
//    pushViewController.URLString=[_url path];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;
    [self.navigationController pushViewController:pushViewController animated:YES];
}
-(void)tapLeftButton:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightClick
{
    MyLog(@"点击右上角分享按钮");
    __block VLXRecordVideoDetailVC *blockSelf=self;
    _isShowMenu=!_isShowMenu;
    if (_isShowMenu) {
        _menuView=[[VLXMenuPopView alloc] initWithFrame:CGRectZero andType:2];
        _menuView.menuBlock=^(NSInteger index)
        {
            blockSelf.isShowMenu=NO;
            if (index==100) {
                NSLog(@"分享");
                if (blockSelf.model) {
                    [blockSelf thirdShareWithUrl:[NSString stringWithFormat:@"%@/shareurl/shipingshare.json?pathInfoId=%@",ftpPath,blockSelf.model.pathinfoid]];
                    
                }else if (blockSelf.courseModel)
                {
                    
                }else if (blockSelf.detailModel)
                {
                    [blockSelf thirdShareWithUrl:[NSString stringWithFormat:@"%@/shareurl/shipingshare.json?pathInfoId=%@",ftpPath,blockSelf.detailModel.pathinfoid]];
                    
                }
//                [blockSelf thirdShareWithUrl:[NSString stringWithFormat:@"%@",@"http://www.baidu.com"]];
            }else if (index==101)
            {
                NSLog(@"编辑");
                VLXRecordEditVideoVC *vc=[[VLXRecordEditVideoVC alloc] init];
                if (blockSelf.model) {
                    vc.model=blockSelf.model;
                }else if (blockSelf.courseModel)
                {
                    
                }else if (blockSelf.detailModel)
                {
                    vc.detailModel=blockSelf.detailModel;
                }
                [blockSelf.navigationController pushViewController:vc animated:YES];
            }else if (index==102)
            {
                NSLog(@"删除");
                VLXCourseAlertView *alert=[[VLXCourseAlertView alloc] initWithFrame:CGRectZero andType:2];
                [[UIApplication sharedApplication].keyWindow addSubview:alert];
                alert.courseBlock=^(NSInteger tag)
                {
                    if (tag==101) {//确定
                        if (blockSelf.model) {//单个点
                            [blockSelf loadDataWithDeleteEvent:[NSString stringWithFormat:@"%@",blockSelf.model.pathinfoid]];
                        }else if (blockSelf.courseModel)//录制中
                        {
                            
                        }else if (blockSelf.detailModel)//轨迹详情
                        {
                            [blockSelf loadDataWithDeleteEvent:[NSString stringWithFormat:@"%@",blockSelf.detailModel.pathinfoid]];
                        }
                    }else if (tag==100)//取消
                    {
                        
                    }
                };
                
                
                
            }
        };
        [self.view addSubview:_menuView];
    }else
    {
        [_menuView removeFromSuperview];
    }

    
}
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
