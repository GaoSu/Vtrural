//
//  VLX_message_CommViewController.m
//  Vlvxing
//
//  Created by grm on 2017/10/30.
//  Copyright © 2017年 王静雨. All rights reserved.
//

//c
#import "VLX_message_CommViewController.h"
#import "VLX_guanzhutixingViewController.h"//关注提醒
#import "VLX_pnglunwodeViewController.h"


//v
#import "VLX_message_CommTableViewCell.h"//

@interface VLX_message_CommViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray * aryImg;
    NSArray * aryTitle;
  
}
@property (nonatomic,strong)UITableView * mainTbvW;

@end

@implementation VLX_message_CommViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的消息";
//    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    leftBtn.frame = CGRectMake(0, 0, 20, 20);
//    [leftBtn setImage:[UIImage imageNamed:@"return-red"] forState:UIControlStateNormal];
//    [leftBtn addTarget:self action:@selector(tapLeftButton1) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
//    self.navigationItem.leftBarButtonItem = leftBarButton;

    UIBarButtonItem *leftButon = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return-red"] style:UIBarButtonItemStylePlain target:nil action:nil];
    [leftButon setTarget:self];
    self.navigationItem.leftBarButtonItem = leftButon;
    self.navigationController.navigationBar.tintColor = orange_color;//原色;
    self.navigationItem.leftBarButtonItem.customView.frame = CGRectMake(0, 0, 100, 50);
    [self.navigationItem.leftBarButtonItem setAction:@selector(tapLeftButton1)];


    
    //UI
    _mainTbvW = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
    _mainTbvW.delegate = self;
    _mainTbvW.dataSource = self;
    _mainTbvW.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];

    [self.view addSubview:_mainTbvW];
    
   
    
}
-(void)tapLeftButton1{
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
      return 3;
//    return 1;//暂时隐藏关注提醒和私信
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * strID = @"message_comm_ID";
    if (_mainTbvW == tableView) {
        aryImg   = [NSArray array];
        aryTitle = [NSArray array];
        aryImg = @[@"remind",@"remind",@"remind"];//要换
        aryTitle = @[@"评论我的",@"关注提醒",@"私信"];
        VLX_message_CommTableViewCell * cell = [_mainTbvW dequeueReusableCellWithIdentifier:strID];
        
        if (!cell) {
            cell = [[VLX_message_CommTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strID];
            cell.imgVw.image = [UIImage imageNamed:aryImg[indexPath.row]];
            cell.titleLB.text = aryTitle[indexPath.row];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;//cell右边小箭头，距离十几像素；
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }
    return nil;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_mainTbvW == tableView) {
        
        
        if (indexPath.row == 0) {
            VLX_pnglunwodeViewController * vc = [[VLX_pnglunwodeViewController alloc]init];
            
            [_mainTbvW deselectRowAtIndexPath:indexPath animated:NO];
//            vc.xxx = indexPath.row;
            [self.navigationController pushViewController:vc animated:YES];
        }else if(indexPath.row == 1)
        {
            VLX_guanzhutixingViewController * vc = [[VLX_guanzhutixingViewController alloc]init];
            
            [_mainTbvW deselectRowAtIndexPath:indexPath animated:NO];
            vc.xxx = indexPath.row;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else{
            NSLog(@"私信");
        }
        
        
    }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
