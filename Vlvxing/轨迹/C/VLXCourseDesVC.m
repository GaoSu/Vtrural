//
//  VLXCourseDesVC.m
//  Vlvxing
//
//  Created by 王静雨 on 2017/6/9.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXCourseDesVC.h"

@interface VLXCourseDesVC ()<UITextViewDelegate>
@property (nonatomic,strong)UITextField *titleTXT;
@property (nonatomic,strong)UITextView *desTextView;
@property(nonatomic,strong) UILabel *promptTitle;
@end

@implementation VLXCourseDesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
}
#pragma mark---数据
#pragma mark
#pragma mark---视图
-(void)createUI
{
    [self setNav];
    UIView *titleView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 45)];
    titleView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:titleView];
    _titleTXT=[[UITextField alloc] initWithFrame:CGRectMake(15, 8.5, kScreenWidth-15*2, titleView.frame.size.height-8.5*2)];
    _titleTXT.borderStyle=UITextBorderStyleNone;
    _titleTXT.layer.cornerRadius=4;
    _titleTXT.layer.masksToBounds=YES;
    _titleTXT.layer.borderColor=[UIColor hexStringToColor:@"#999999"].CGColor;
    _titleTXT.layer.borderWidth=0.5;
    _titleTXT.font=[UIFont systemFontOfSize:14];
//    _titleTXT.placeholder=@"请输入轨迹名称";
    // 就下面这两行是重点
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"请输入轨迹名称" attributes:
                                      @{NSForegroundColorAttributeName:[UIColor hexStringToColor:@"#999999"],
                                        NSFontAttributeName:_titleTXT.font
                                        }];
    _titleTXT.attributedPlaceholder = attrString;
    [titleView addSubview:_titleTXT];
    //
    UIView *desView=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleView.frame)+8, kScreenWidth, 150)];
    desView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:desView];
    _desTextView=[[UITextView alloc] initWithFrame:CGRectMake(15, 15, kScreenWidth-15*2, desView.frame.size.height-15*2)];
    _desTextView.layer.cornerRadius=4;
    _desTextView.layer.masksToBounds=YES;
    _desTextView.layer.borderColor=[UIColor hexStringToColor:@"#999999"].CGColor;
    _desTextView.layer.borderWidth=0.5;
    _desTextView.delegate=self;
    [desView addSubview:_desTextView];
    //创建Label 加提示语
    self.promptTitle = [[UILabel alloc]initWithFrame:CGRectMake(5,5,200,20)];
    self.promptTitle.text = @"请输入轨迹描述...";
    self.promptTitle.font = [UIFont systemFontOfSize:14.0];
    self.promptTitle.textColor=[UIColor hexStringToColor:@"#666666"];
    [self.desTextView addSubview:self.promptTitle];
    
}
- (void)setNav{
    
    self.title = @"保存轨迹";
    self.view.backgroundColor=[UIColor hexStringToColor:@"f3f3f4"];
    //左边按钮
//    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    leftBtn.frame = CGRectMake(0, 0, 20, 20);
//    [leftBtn setImage:[UIImage imageNamed:@"return-red"] forState:UIControlStateNormal];
//    [leftBtn addTarget:self action:@selector(tapLeftButton) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
//    self.navigationItem.leftBarButtonItem = leftBarButton;

    UIBarButtonItem *leftButon = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return-red"] style:UIBarButtonItemStylePlain target:nil action:nil];
    [leftButon setTarget:self];
    self.navigationItem.leftBarButtonItem = leftButon;
    self.navigationController.navigationBar.tintColor = orange_color;//原色;
    self.navigationItem.leftBarButtonItem.customView.frame = CGRectMake(0, 0, 100, 50);
    [self.navigationItem.leftBarButtonItem setAction:@selector(tapLeftButton)];

    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"保存" forState:UIControlStateNormal];
    [rightBtn setTitleColor:orange_color forState:UIControlStateNormal];
    rightBtn.titleLabel.font=[UIFont systemFontOfSize:16];
    rightBtn.frame = CGRectMake(0, 0, 40, 20);
    [rightBtn addTarget:self action:@selector(tapRightButton:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBarButton;
}
#pragma mark
#pragma mark---事件
-(void)tapLeftButton
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(BOOL)beforeSaveRoute
{
    if ([NSString checkForNull:_titleTXT.text]) {
        [SVProgressHUD showErrorWithStatus:@"请输入轨迹名称"];
        return NO;
    }else if ([NSString checkForNull:_desTextView.text])
    {
        [SVProgressHUD showErrorWithStatus:@"请输入轨迹描述"];
        return NO;
    }
    return YES;
}
-(void)tapRightButton:(UIButton *)sender
{
    NSLog(@"保存轨迹");
//    if ([self beforeSaveRoute]) {
        if (_desBlock) {
            _desBlock([ZYYCustomTool checkNullWithNSString:_titleTXT.text],[ZYYCustomTool checkNullWithNSString:_desTextView.text]);
        }
        [self.navigationController popViewControllerAnimated:YES];
//    }
//    if (_desBlock) {
//        _desBlock([ZYYCustomTool checkNullWithNSString:_titleTXT.text],[ZYYCustomTool checkNullWithNSString:_desTextView.text]);
//    }
//    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark
#pragma mark---textView delegate
//判断是否超出最大限额 500
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSLog(@"%@",text);
    if ([text isEqualToString:@""] && range.length > 0) {
        //删除字符肯定是安全的
        return YES;
    }
    else {
        if (textView.text.length - range.length + text.length > 500) {
            [SVProgressHUD showInfoWithStatus:@"最多可评价500字!"];
            return NO;
        }
        else {
            return YES;
        }
    }
}
-(void)textViewDidChange:(UITextView *)textView
{
    if(textView.text.length>0)
    {
        _promptTitle.hidden = YES;
    }
    else
    {
        _promptTitle.hidden =NO;
    }
}
#pragma mark
#pragma mark---delegate
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
