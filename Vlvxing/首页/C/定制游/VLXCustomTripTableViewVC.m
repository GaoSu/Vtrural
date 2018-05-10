//
//  VLXCustomTripTableViewVC.m
//  Vlvxing
//
//  Created by 王静雨 on 2017/5/23.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXCustomTripTableViewVC.h"
#import "VLXChooseAreaVC.h"
#import "VLXCustomTripModel.h"
#import "VLXSelectDateView.h"//日期选择

@interface VLXCustomTripTableViewVC ()<UITextFieldDelegate,UITextViewDelegate,UIScrollViewDelegate>
{
    NSInteger _outDays;//出行天数
    NSInteger _outPeoples;//出行人数
}
//用于设置样式
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *lineViewArray;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *marginViewArray;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *titleLabArray;



//
@property (weak, nonatomic) IBOutlet UITextField *startCityTXT;
@property (weak, nonatomic) IBOutlet UITextField *endCityTXT;
@property (weak, nonatomic) IBOutlet UITextField *nameTXT;
@property (weak, nonatomic) IBOutlet UITextField *phoneTXT;
@property (weak, nonatomic) IBOutlet UITextField *emailTXT;


@property (weak, nonatomic) IBOutlet UILabel *outDaysLab;
@property (weak, nonatomic) IBOutlet UILabel *outPeopleLab;

@property (weak, nonatomic) IBOutlet UILabel *chooseDateLab;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic,strong)VLXCustomTripModel *tripModel;

@end

@implementation VLXCustomTripTableViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    //初始化
    _outDays=0;
    _outPeoples=0;
    _tripModel=[[VLXCustomTripModel alloc] init];
    _tripModel.startCity=[NSString getCity];
    _startCityTXT.text=[NSString getCity];
    //
    [self createUI];
  
}
#pragma mark---数据
-(void)setModelData
{
    _tripModel.startCity=[ZYYCustomTool checkNullWithNSString:_startCityTXT.text];
    _tripModel.endCity=[ZYYCustomTool checkNullWithNSString:_endCityTXT.text];
    _tripModel.date=[ZYYCustomTool checkNullWithNSString:_chooseDateLab.text];
    _tripModel.days=[ZYYCustomTool checkNullWithNSString:_outDaysLab.text];
    _tripModel.peoples=[ZYYCustomTool checkNullWithNSString:_outPeopleLab.text];
    _tripModel.name=[ZYYCustomTool checkNullWithNSString:_nameTXT.text];
    _tripModel.phone=[ZYYCustomTool checkNullWithNSString:_phoneTXT.text];
    _tripModel.email=[ZYYCustomTool checkNullWithNSString:_emailTXT.text];
    _tripModel.others=[ZYYCustomTool checkNullWithNSString:_textView.text];
    
}
#pragma mark
#pragma mark---视图
-(void)createUI
{
    self.view.backgroundColor=[UIColor whiteColor];
    [self setNav];
    //
    self.tableView.showsHorizontalScrollIndicator=NO;
    self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    //确定按钮
    _sureBtn.layer.cornerRadius=4;
    _sureBtn.layer.masksToBounds=YES;
    _sureBtn.backgroundColor=orange_color;
    //设置线的颜色
    for (UIView *line in _lineViewArray) {
        line.backgroundColor=separatorColor1;
    }
    for (UIView *margin in _marginViewArray) {
        margin.backgroundColor=[UIColor hexStringToColor:@"#f3f3f4"];
    }
    //设置标题
    for (UILabel *titleLab in _titleLabArray) {
        titleLab.textColor=[UIColor hexStringToColor:@"#666666"];
    }
    //
    _chooseDateLab.textColor=[UIColor hexStringToColor:@"#999999"];
    //
    _textView.layer.borderWidth=0.5;
    _textView.layer.borderColor=[UIColor hexStringToColor:@"#999999"].CGColor;
    _textView.layer.cornerRadius=4;
    _textView.layer.masksToBounds=YES;
    
    //
}
- (void)setNav{
    
    self.title = @"定制游";
    self.view.backgroundColor=[UIColor whiteColor];
    //左边按钮
//    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    leftBtn.frame = CGRectMake(0, 0, 20, 20);
//    [leftBtn setImage:[UIImage imageNamed:@"return-red"] forState:UIControlStateNormal];
//    [leftBtn addTarget:self action:@selector(tapLeftButton:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
//    self.navigationItem.leftBarButtonItem = leftBarButton;
    UIBarButtonItem *leftButon = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return-red"] style:UIBarButtonItemStylePlain target:nil action:nil];
    [leftButon setTarget:self];
    self.navigationItem.leftBarButtonItem = leftButon;
    self.navigationController.navigationBar.tintColor = orange_color;//原色;
    self.navigationItem.leftBarButtonItem.customView.frame = CGRectMake(0, 0, 100, 50);
    [self.navigationItem.leftBarButtonItem setAction:@selector(tapLeftButton:)];

    //添加手势用于取消编辑
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(navTapToEndEdit:)];
    [self.navigationController.navigationBar addGestureRecognizer:tap];

}
#pragma mark
#pragma mark---事件
- (IBAction)btnClickedToSure:(id)sender {
    [self setModelData];
    BOOL isFull=[_tripModel checkIsFull];
    if (!isFull) {
//        [SVProgressHUD showErrorWithStatus:@"订单信息不正确，请重新输入"];
        return;
    }
    NSMutableDictionary * dic=[NSMutableDictionary dictionary];
    
    dic[@"token"]=[NSString getDefaultToken];//用户token
    dic[@"departure"]=_tripModel.startCity;//出发地
    dic[@"destinationId"]=_tripModel.endCityId;//目的地id
    dic[@"destination"]=_tripModel.endCity;//目的地
    dic[@"time"]=_tripModel.date;//出行日期
    dic[@"days"]=_tripModel.days;//出行天数
    dic[@"peopleCounts"]=_tripModel.peoples;//出行人数
    dic[@"name"]=_tripModel.name;//姓名
    dic[@"tel"]=_tripModel.phone;//电话
    dic[@"mail"]=_tripModel.email;//邮箱
    dic[@"requirement"]=_tripModel.others;//行程需求
    NSString * url=[NSString stringWithFormat:@"%@/ProCustomController/auth/saveProCustom.json",ftpPath];
    NSLog(@"%@",dic);
    [SPHttpWithYYCache postRequestUrlStr:url withDic:dic success:^(NSDictionary *requestDic, NSString *msg) {
        [SVProgressHUD dismiss];
        NSLog(@"%@",requestDic.mj_JSONString);
        if ([requestDic[@"status"] integerValue]==1) {
            [SVProgressHUD showSuccessWithStatus:@"保存成功"];
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
}

//出行天数加减号
- (IBAction)outDaysAdd:(id)sender {
    _outDays++;
    _outDaysLab.text=[NSString stringWithFormat:@"%ld",_outDays];
    
}
- (IBAction)outDaysMinus:(id)sender {
    if (_outDays<=0) {
        [SVProgressHUD showErrorWithStatus:@"请添加出行天数"];
        return;
    }
    _outDays--;
    _outDaysLab.text=[NSString stringWithFormat:@"%ld",_outDays];
    
}

//出行人数加减号
- (IBAction)outPeopleAdd:(id)sender {
    _outPeoples++;
    _outPeopleLab.text=[NSString stringWithFormat:@"%ld",_outPeoples];
}
- (IBAction)outPeopleMinus:(id)sender {
    if (_outPeoples<=0) {
        [SVProgressHUD showErrorWithStatus:@"请添加出行人数"];
        return;
    }
    _outPeoples--;
    _outPeopleLab.text=[NSString stringWithFormat:@"%ld",_outPeoples];
    
}

//
-(void)tapLeftButton:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
-(void)navTapToEndEdit:(UITapGestureRecognizer *)tap
{
    [self.view endEditing:YES];
}
#pragma mark
#pragma mark---textField delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark
#pragma mark---textView delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
} 

#pragma mark
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    //
    __block VLXCustomTripTableViewVC *blockSelf=self;
    NSLog(@"%ld",indexPath.row);
    if (indexPath.row==1) {

        VLXChooseAreaVC * area=[[VLXChooseAreaVC alloc]init];
        [self.navigationController pushViewController:area animated:YES];
        area.areaBlock=^(VLXChooseAreaListModel *listModel)
        {
            blockSelf.tripModel.endCity=listModel.areaname;
            blockSelf.tripModel.endCityId=[NSString stringWithFormat:@"%@",listModel.areaid];
            _endCityTXT.text=listModel.areaname;
        };

    }else if (indexPath.row==2)
    {
        VLXSelectDateView *dateView=[[VLXSelectDateView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        [[UIApplication sharedApplication].keyWindow addSubview:dateView];
        dateView.dateBlock=^(NSString *dateStr)
        {
            blockSelf.chooseDateLab.text=[ZYYCustomTool checkNullWithNSString:dateStr];
            blockSelf.chooseDateLab.textColor=[UIColor blackColor];
            //
//            blockSelf.tripModel.date=[ZYYCustomTool checkNullWithNSString:dateStr];
        };

    }
}
#pragma mark

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
