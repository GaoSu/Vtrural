//
//  VLXInputOrderTableViewVC.m
//  Vlvxing
//
//  Created by 王静雨 on 2017/5/26.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXInputOrderTableViewVC.h"
#import "VLXInputOrderModel.h"
#import "VLXPayCustomAlertView.h"
@interface VLXInputOrderTableViewVC ()<UIScrollViewDelegate,UITextViewDelegate,UITextFieldDelegate>
{
    NSInteger _orderCount;//购买份数

}
//
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIImageView *distanceIcon;

@property (weak, nonatomic) IBOutlet UILabel *distanceLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *countLab;
@property (weak, nonatomic) IBOutlet UITextView *textView;
//
@property (weak, nonatomic) IBOutlet UITextField *nameTXT;
@property (weak, nonatomic) IBOutlet UITextField *phoneTXT;
@property (weak, nonatomic) IBOutlet UITextField *addressTXT;

@property (weak, nonatomic) IBOutlet UITextField *IDCardTXT;


//
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *marginArray;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *lineArray;


//
@property (nonatomic,strong)UILabel *allPriceLab;//总价
@property (nonatomic,assign)float allPrice;//
@property (nonatomic,strong)VLXInputOrderModel *orderModel;
@end

@implementation VLXInputOrderTableViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    //初始化
    _orderCount=1;
    _orderModel=[[VLXInputOrderModel alloc] init];
    //
    [self createUI];
    [self loadData];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self addNotification];
}
-(void)viewDidDisappear:(BOOL)animated
{
    //移除观察者
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"WXPayNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AliPayNotification" object:nil];
    
}
//支付结果通知
- (void)addNotification
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getWXPayResult:) name:@"WXPayNotification" object:nil];//监听一个通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getAliPayResult:) name:@"AliPayNotification" object:nil];//监听一个通知
}
#pragma mark 微信.  支付宝  结果通知
- (void)getWXPayResult:(NSNotification *)sender
{
    [SVProgressHUD dismiss];
    NSString *result = sender.object;
    if ([result isEqualToString:@"success"])
    {

        [SVProgressHUD showSuccessWithStatus:@"支付成功!"];
        [self.navigationController popViewControllerAnimated:YES];
    }else
    {

        [SVProgressHUD showErrorWithStatus:@"支付失败，请重试"];
    }
}
- (void)getAliPayResult:(NSNotification *)sender
{
    [SVProgressHUD dismiss];
    NSDictionary *resultDic = sender.userInfo;
    //MyLog(@"AlipaySDK reslut = %@",resultDic);
    if ([[resultDic objectForKey:@"resultStatus"] integerValue] == 9000)
    {

        NSLog(@"郭荣明_支付测试OK0001");
        [SVProgressHUD showSuccessWithStatus:@"支付成功!"];
        [self.navigationController popViewControllerAnimated:YES];
    }else {

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             NSLog(@"郭荣明_支付测试失败0001");
            [SVProgressHUD showErrorWithStatus:@"支付失败，请重试"];
        });
    }
}
#pragma mark
#pragma mark---数据
-(void)loadData
{
    //
    _countLab.text=[NSString stringWithFormat:@"%ld",_orderCount];
    //
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:_detailModel.data.productsmallpic] placeholderImage:smallNoDataImage];//
    _titleLab.text=[ZYYCustomTool checkNullWithNSString:_detailModel.data.productname];//
    if ([_detailModel.data.isfarmyard integerValue]==1)//是否是农家院 0不是农家院，1是
    {
        _distanceLab.hidden=NO;
        _distanceIcon.hidden=NO;
        //计算农家院离当前位置的距离
        CLLocationCoordinate2D currentCoor=CLLocationCoordinate2DMake([[NSString getLatitude] floatValue], [[NSString getLongtitude] floatValue]);
        CLLocationCoordinate2D shopCoor=CLLocationCoordinate2DMake([_detailModel.data.pathlat floatValue], [_detailModel.data.pathlng floatValue]);
        CGFloat meter= [VLXMapTool calculateMeter:currentCoor toShop:shopCoor];
        _distanceLab.text=[NSString stringWithFormat:@"%.1fkm",meter/1000];
    }else
    {
        _distanceLab.hidden=YES;
        _distanceIcon.hidden=YES;
    }

    //
    //可变字体
    NSString *priceStr=[NSString stringWithFormat:@"¥%@",_detailModel.data.price];
    NSMutableAttributedString *attStr=[[NSMutableAttributedString alloc] initWithString:priceStr];
    NSRange range=[priceStr rangeOfString:[NSString stringWithFormat:@"%@",_detailModel.data.price]];
    [attStr addAttributes:@{NSForegroundColorAttributeName:orange_color, NSFontAttributeName:[UIFont boldSystemFontOfSize:12]} range:NSMakeRange(0, 1)];//¥
    [attStr addAttributes:@{NSForegroundColorAttributeName:orange_color, NSFontAttributeName:[UIFont boldSystemFontOfSize:16]} range:range];//价格
    _priceLab.attributedText=attStr;
    //
    
}
-(void)setModelData
{
    if (![NSString getName] || ![[NSString getName] isEqualToString:_nameTXT.text]) {
        [NSString setName:_nameTXT.text];
        NSLog(@"姓名:%@",_nameTXT.text);
      _orderModel.name=[ZYYCustomTool checkNullWithNSString:_nameTXT.text];
    }else{
       _orderModel.name=[NSString getName];
    }
    if (![NSString getPhone] || ![[NSString getPhone] isEqualToString:_phoneTXT.text]) {
        [NSString setPhoneNum:_phoneTXT.text];
        _orderModel.phone=[ZYYCustomTool checkNullWithNSString:_phoneTXT.text];
    }else{
        _orderModel.phone = [NSString getPhone];
    }
    
    if (![NSString getAddress] || ![[NSString getAddress] isEqualToString:_addressTXT.text]) {
        [NSString setAddress:_addressTXT.text];
        _orderModel.address=[ZYYCustomTool checkNullWithNSString:_addressTXT.text];
    }else{
        _orderModel.address = [NSString getAddress];
    }
    if (![NSString getIdNum] || ![[NSString getIdNum] isEqualToString:_IDCardTXT.text]) {
        [NSString setIdNum:_IDCardTXT.text];
        _orderModel.IDCard=[ZYYCustomTool checkNullWithNSString:_IDCardTXT.text];
    }else{
        _orderModel.IDCard=[NSString getIdNum];
    }
    
    _orderModel.others=[ZYYCustomTool checkNullWithNSString:_textView.text];
    _orderModel.allPrice=[NSString stringWithFormat:@"%.2f",_detailModel.data.price.floatValue*_orderCount];
    _orderModel.orderCount=_orderCount;
    
    
    
}
#pragma mark
#pragma mark---视图
-(void)createUI
{
    [self setNav];
    //设置线的颜色
    for (UIView *line in _lineArray) {
        line.backgroundColor=separatorColor1;
    }
    for (UIView *margin in _marginArray) {
        margin.backgroundColor=[UIColor hexStringToColor:@"#f3f3f4"];
    }
    //
    _nameTXT.textColor=orange_color;
    _phoneTXT.textColor=orange_color;
    _addressTXT.textColor=orange_color;
    _IDCardTXT.textColor=orange_color;
    _textView.layer.borderWidth=0.5;
    _textView.layer.borderColor=[UIColor hexStringToColor:@"#999999"].CGColor;
    _textView.layer.cornerRadius=4;
    _textView.layer.masksToBounds=YES;
    
    if ([NSString hd_isNotNull:[NSString getName]]) { // 本地缓存有值
        _nameTXT.text = [NSString getName];
    }
    if ([NSString hd_isNotNull:[NSString getPhone]]) {
        _phoneTXT.text = [NSString getPhone];
    }
    
    if ([NSString hd_isNotNull:[NSString getAddress]]) {
        _addressTXT.text = [NSString getAddress];
    }
    
    if ([NSString hd_isNotNull:[NSString getIdNum]]) {

        _IDCardTXT.text = [NSString getIdNum];
    }
    //
    [self createBototmView];
}
-(void)createBototmView
{
    UIView *bottomView=[[UIView alloc] initWithFrame:CGRectMake(0, K_SCREEN_HEIGHT - kSafeAreaBottomHeight-64-49, kScreenHeight, 49)];
    [self.view addSubview:bottomView];

    //
    UILabel *priceLab=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth/2, bottomView.frame.size.height)];
//    priceLab.text=@"   总价：￥150";
    //
    //可变字体
    _allPrice=_detailModel.data.price.floatValue;
    NSString *priceStr=[NSString stringWithFormat:@"   总价：￥%@",_detailModel.data.price];
    NSMutableAttributedString *attStr=[[NSMutableAttributedString alloc] initWithString:priceStr];
    NSRange range=[priceStr rangeOfString:[NSString stringWithFormat:@"￥%@",_detailModel.data.price]];
    [attStr addAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor], NSFontAttributeName:[UIFont systemFontOfSize:16]} range:NSMakeRange(0, range.location)];//   总价：
    [attStr addAttributes:@{NSForegroundColorAttributeName:orange_color, NSFontAttributeName:[UIFont boldSystemFontOfSize:16]} range:range];//价格 ￥%@
    priceLab.attributedText=attStr;
    //
    //
    priceLab.textAlignment=NSTextAlignmentLeft;
    
//    priceLab.font=[UIFont systemFontOfSize:16];
    priceLab.layer.borderColor=separatorColor1.CGColor;
    priceLab.layer.borderWidth=0.5;
    [bottomView addSubview:priceLab];
    _allPriceLab=priceLab;
    UIButton *orderBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    orderBtn.frame=CGRectMake(kScreenWidth/2, 0, kScreenWidth/2, bottomView.frame.size.height);
    [orderBtn setTitle:@"提交订单" forState:UIControlStateNormal];
    [orderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    orderBtn.titleLabel.font=[UIFont systemFontOfSize:19];
    orderBtn.backgroundColor=orange_color;
    [orderBtn addTarget:self action:@selector(btnClickedToOrder:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:orderBtn];
    
}
- (void)setNav{
    
    self.title = @"填写订单";
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
-(void)calculateAllPrice//计算总价
{
    //可变字体
    _allPrice=_detailModel.data.price.floatValue*_orderCount;
    NSString *priceStr=[NSString stringWithFormat:@"   总价：￥%.0f",_detailModel.data.price.floatValue*_orderCount];
    NSMutableAttributedString *attStr=[[NSMutableAttributedString alloc] initWithString:priceStr];
    NSRange range=[priceStr rangeOfString:[NSString stringWithFormat:@"￥%.0f",_detailModel.data.price.floatValue*_orderCount]];
    [attStr addAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor], NSFontAttributeName:[UIFont systemFontOfSize:16]} range:NSMakeRange(0, range.location)];//   总价：
    [attStr addAttributes:@{NSForegroundColorAttributeName:orange_color, NSFontAttributeName:[UIFont boldSystemFontOfSize:16]} range:range];//价格 ￥%@
    _allPriceLab.attributedText=attStr;
    //
}
//
- (IBAction)addBtnClicked:(id)sender {
    _orderCount++;
    _countLab.text=[NSString stringWithFormat:@"%ld",(long)_orderCount];
    //
    [self calculateAllPrice];
}
- (IBAction)minusBtnClicked:(id)sender {
    if (_orderCount<=0) {
        [SVProgressHUD showErrorWithStatus:@"请添加购买份数"];
        return;
    }
    _orderCount--;
    _countLab.text=[NSString stringWithFormat:@"%ld",(long)_orderCount];
    //
    [self calculateAllPrice];
}
//提交订单事件
-(void)btnClickedToOrder:(UIButton *)sender
{
    
    NSLog(@"order");
    [self setModelData];
    BOOL isFull=[_orderModel checkIsFull];
    if (!isFull) {
        //        [SVProgressHUD showErrorWithStatus:@"订单信息不正确，请重新输入"];
        return;
    }
    NSMutableDictionary * dic=[NSMutableDictionary dictionary];
    
    dic[@"token"]=[NSString getDefaultToken];//用户token
    dic[@"travelProductId"]=[NSString stringWithFormat:@"%@",_detailModel.data.travelproductid];//商品id
    dic[@"orderName"]=[ZYYCustomTool checkNullWithNSString:_detailModel.data.productname];//订单名称
    dic[@"orderAllPrice"]=[ZYYCustomTool checkNullWithNSString:_orderModel.allPrice];//订单总价
    dic[@"orderCount"]=[NSString stringWithFormat:@"%ld",(long)_orderModel.orderCount];//商品数量
    dic[@"orderPrice"]=[NSString stringWithFormat:@"%@",_detailModel.data.price];//商品单价
    dic[@"orderUserName"]=[ZYYCustomTool checkNullWithNSString:_orderModel.name];//订单人姓名
    dic[@"orderUserPhone"]=[ZYYCustomTool checkNullWithNSString:_orderModel.phone];//订单人手机
    dic[@"orderUserAddress"]=[ZYYCustomTool checkNullWithNSString:_orderModel.address];//订单人地址
    dic[@"orderUserId"]=[ZYYCustomTool checkNullWithNSString:_orderModel.IDCard];//订单人身份证号
    dic[@"orderUserMessage"]=[ZYYCustomTool checkNullWithNSString:_orderModel.others];//留言
    dic[@"orderPic"]=[ZYYCustomTool checkNullWithNSString:_detailModel.data.productsmallpic];//订单图片

    if ([_detailModel.data.isfarmyard integerValue]==1) {
        dic[@"orderAddressLng"]=[ZYYCustomTool checkNullWithNSString:_detailModel.data.pathlng];//订单地址经度    （农家院需要传，否则不传）
        dic[@"orderAddressLat"]=[ZYYCustomTool checkNullWithNSString:_detailModel.data.pathlat];//订单地址纬度    （农家院需要传，否则不传）
    }
    NSString * url=[NSString stringWithFormat:@"%@/OrderInfoController/auth/placeAnOrder.html",ftpPath];
    NSLog(@"第一个请求的残书%@",dic);
    [SPHttpWithYYCache postRequestUrlStr:url withDic:dic success:^(NSDictionary *requestDic, NSString *msg) {
        [SVProgressHUD dismiss];
        NSLog(@"第一个返回的参数%@",requestDic.mj_JSONString);
        if ([requestDic[@"status"] integerValue]==1) {
            //test 0.01元
//            _allPrice=0.01;//支付一分钱
            //
//            //prodution
            _allPrice=[requestDic[@"data"][@"orderallprice"] floatValue];
            //
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [SVProgressHUD showSuccessWithStatus:@"订单提交成功"];
                VLXPayCustomAlertView *payAlert=[[VLXPayCustomAlertView alloc] initWithFrame:CGRectZero andPayMoney:_allPrice];//弹出悬浮框,选择支付方式
                
                [[UIApplication sharedApplication].keyWindow addSubview:payAlert];
                payAlert.payTypeBlock=^(NSInteger tag)
                {
                    if (tag==0) {
                        NSLog(@"微信");
                       
                        
                        NSMutableDictionary *dataDic=[NSMutableDictionary dictionary];
                        dataDic[@"token"]=[NSString getDefaultToken];
                        dataDic[@"orderid"]=[NSString stringWithFormat:@"%@",requestDic[@"data"][@"orderid"]];
                        dataDic[@"systemtradeno"]=[NSString stringWithFormat:@"%@",requestDic[@"data"][@"systemtradeno"]];
                        dataDic[@"orderprice"]=[NSString stringWithFormat:@"%f",_allPrice];//单位:元
                        NSLog(@"微信字典%@",dataDic);
                        [[PayTool defaltTool] payForServiceWithDic:dataDic withViewController:self withPayType:@"101" SuccessBlock:^{
                            NSLog(@"SuccessBlock");
                        } failure:^(NSString *errorInfo) {
                            NSLog(@"failure:%@",errorInfo);
                        }];
                    }else if (tag==1)
                    {
                        NSLog(@"支付宝");
                 
                        
                        NSMutableDictionary *dataDic=[NSMutableDictionary dictionary];
                        dataDic[@"token"]=[NSString getDefaultToken];
                        dataDic[@"orderid"]=[NSString stringWithFormat:@"%@",requestDic[@"data"][@"orderid"]];
                        dataDic[@"systemtradeno"]=[NSString stringWithFormat:@"%@",requestDic[@"data"][@"systemtradeno"]];//不是毫秒
                        dataDic[@"orderprice"]=[NSString stringWithFormat:@"%f",_allPrice];//单位:元
                        dataDic[@"servername"]=[ZYYCustomTool checkNullWithNSString:_detailModel.data.productname];
                        NSLog(@"这是什么贵:%@",_detailModel.data.productname);
                        NSLog(@"支付宝信字典%@",dataDic);
                        [[PayTool defaltTool] payForServiceWithDic:dataDic withViewController:self withPayType:@"102" SuccessBlock:^{
                            NSLog(@"SuccessBlock");
                        } failure:^(NSString *errorInfo) {
                            NSLog(@"failure:%@",errorInfo);
                        }];
                    }
                };
            });
//            [self.navigationController popViewControllerAnimated:YES];

        }else
        {
            [SVProgressHUD showErrorWithStatus:msg];
        }
        
        
        
    } failure:^(NSString *errorInfo) {
        [SVProgressHUD dismiss];
        
    }];
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
#pragma mark---delegate
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
#pragma mark
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
