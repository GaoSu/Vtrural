//
//  RWNPickView.m
//  zichanguanli
//
//  Created by RWN on 17/3/7.
//  Copyright © 2017年 handongkeji. All rights reserved.
//

#import "RWNPickView.h"

@interface RWNPickView ()<UIPickerViewDataSource,UIPickerViewDelegate>

@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)UIButton *backBtn;
@property(nonatomic,strong)UIPickerView *pickerView;

@property(nonatomic,assign)NSInteger compent;

@end

@implementation RWNPickView

- (instancetype)initWithFrame:(CGRect)frame  CreateProjectTypeViewWithDataSourceArray:(NSMutableArray *)dataArray selectedArray:(NSMutableArray *)selectedArray title:(NSString *)title andTag:(NSInteger)Tag{

    if (self=[super initWithFrame:frame]) {
        
        self.tag=Tag;
        
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:dataArray];

        [self setupUIWithDataSourceArray:dataArray selectedArray:selectedArray title:title andTag:Tag];
        
    }
    return self;
}

-(void)setupUIWithDataSourceArray:(NSMutableArray *)dataArray selectedArray:(NSMutableArray *)selectedArray title:(NSString *)title andTag:(NSInteger)Tag{

    UIButton *MBbutton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, ScreenSize.width, ScreenSize.height-64)];
    MBbutton.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    [self addSubview:MBbutton];
    [MBbutton addTarget:self action:@selector(topMBbutton) forControlEvents:UIControlEventTouchUpInside];
    self.backBtn=MBbutton;

    //创建一个view(承载时间选择器)
    CGFloat DatePickerviewW=ScreenSize.width;
    CGFloat DatePickerviewH=260;
    CGFloat DatePickerviewX=(ScreenSize.width-DatePickerviewW)/2;
    CGFloat DatePickerviewY=ScreenSize.height-DatePickerviewH-64;
    UIView *DatePickerview=[[UIView alloc]initWithFrame:CGRectMake(DatePickerviewX, DatePickerviewY, DatePickerviewW, DatePickerviewH)];
    DatePickerview.backgroundColor=[UIColor whiteColor];
    [MBbutton addSubview:DatePickerview];
    
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:DatePickerview.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(4, 4)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = DatePickerview.bounds;
    maskLayer.path = maskPath.CGPath;
    DatePickerview.layer.mask = maskLayer;
    
    
    //添加顶部的View
    UIView *TopView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenSize.width, 44)];
    TopView.backgroundColor=[UIColor hexStringToColor:@"F3F3F3"];
    [DatePickerview addSubview:TopView];
    
    //添加确定取消按钮
    //1 取消
    CGFloat picerCencelY=15;
    CGFloat picerCencelW=50;
    CGFloat picerCencelH=17;
    CGFloat picerCencelX=15;
    UIButton *picerCencel=[[UIButton alloc]initWithFrame:CGRectMake(picerCencelX, picerCencelY, picerCencelW, picerCencelH)];
    [picerCencel setTitle:@"取消" forState:UIControlStateNormal];
    [picerCencel setTitleColor:[UIColor hexStringToColor:@"#509EEE"] forState:UIControlStateNormal];
    picerCencel.titleLabel.font=[UIFont fontWithName:@"PingFangSC-Regular" size:17];
    picerCencel.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    [DatePickerview addSubview:picerCencel];
    [picerCencel addTarget:self action:@selector(topNO:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel *RWNTitle=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(picerCencel.frame), 0, kScreenWidth-130, 45)];
    RWNTitle.textColor=[UIColor hexStringToColor:@"#999999"];
    RWNTitle.textAlignment=NSTextAlignmentCenter;
    RWNTitle.font=[UIFont fontWithName:@"PingFangSC-Regular" size:17];
    RWNTitle.text=title;
    [DatePickerview addSubview:RWNTitle];
    
    
    //1 确定
    CGFloat picerYesY=15;
    CGFloat picerYesW=50;
    CGFloat picerYesH=17;
    CGFloat picerYesX=ScreenSize.width-15-picerYesW;
    UIButton *picerYes=[[UIButton alloc]initWithFrame:CGRectMake(picerYesX, picerYesY, picerYesW, picerYesH)];
    [picerYes setTitle:@"确定" forState:UIControlStateNormal];
    [picerYes setTitleColor:[UIColor hexStringToColor:@"#509EEE"] forState:UIControlStateNormal];
    picerYes.titleLabel.font=[UIFont fontWithName:@"PingFangSC-Regular" size:17];
    picerYes.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
    [DatePickerview addSubview:picerYes];
    [picerYes addTarget:self action:@selector(topYes:) forControlEvents:UIControlEventTouchUpInside];
    
    //添加UIPickerView
    CGFloat datepickerW=DatePickerviewW;
    CGFloat datepickerH=DatePickerview.mj_h-TopView.mj_h;
    CGFloat datepickerX=0;
    CGFloat datepickerY=TopView.mj_h;
    UIPickerView*  picker = [[UIPickerView alloc] initWithFrame: CGRectMake(datepickerX, datepickerY, datepickerW, datepickerH)];
    picker.dataSource = self;
    picker.delegate = self;
    picker.showsSelectionIndicator = YES;
    self.pickerView=picker;
    [DatePickerview addSubview: picker];

}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark- button clicked
#pragma mark- Picker Data Source Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
   
    return  self.dataArray.count;
}





#pragma mark- Picker Delegate Methods

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
        NSString *Provincename = [self.dataArray objectAtIndex:row];
        return Provincename;
   
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{

    self.compent=component;
    NSLog(@"%d",component);
    
}


- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
   
        return ScreenSize.width;
    
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{

    UILabel *myView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 80)];
    myView.textAlignment = NSTextAlignmentCenter;
    if (self.dataArray.count>row) {
        NSString *selectedName = self.dataArray[row];
        myView.text = selectedName;
    }

    myView.font = [UIFont systemFontOfSize:24];
    myView.backgroundColor = [UIColor clearColor];
//    myView.textColor=[UIColor hexStringToColor:@"#333333"];
    if (component==0) {
        myView.textColor=[UIColor redColor];
    }else{
        myView.textColor=[UIColor yellowColor];
    }
    
    ((UIView *)[self.pickerView.subviews objectAtIndex:1]).backgroundColor = [UIColor hexStringToColor:@"#eeeeee"];
    ((UIView *)[self.pickerView.subviews objectAtIndex:2]).backgroundColor = [UIColor hexStringToColor:@"#eeeeee"];
    
    return myView;
}

//点击确定

- (void) topYes:(UIButton*)sender {
    
    NSInteger selectedIndex = [self.pickerView selectedRowInComponent:0];
   
    NSString *selectedName= @"";
    if (self.dataArray.count>selectedIndex) {
     selectedName = [self.dataArray objectAtIndex: selectedIndex];
    }
    
    NSString *selectedMsg = [NSString stringWithFormat: @"%@", selectedName];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(RWNPickViewDidClickSureBtn:andSelectedStr:andRWNPickView:)]) {
        [self.delegate RWNPickViewDidClickSureBtn:sender andSelectedStr:selectedMsg andRWNPickView:self];
    }
    
    [self removeAll];
    
}

//点击取消
- (void)topNO:(UIButton *)sender {
   
    [self removeAll];
    
}
//点击蒙版
-(void)topMBbutton
{
   
     [self removeAll];
    
}

-(void)removeAll{

    [self.backBtn removeFromSuperview];
    [self.pickerView removeFromSuperview];
    [self removeFromSuperview];

}

-(NSMutableArray *)dataArray{

    if (!_dataArray) {
        _dataArray=[NSMutableArray array];
    }
    return _dataArray;
}



@end
