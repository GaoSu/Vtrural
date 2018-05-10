//
//  WFPikerView.m
//  shangxuelian
//
//  Created by hdkj002 on 16/2/27.
//  Copyright © 2016年 hdkj005. All rights reserved.
//

#import "WFPikerView.h"
#import "UIView+MJExtension.h"

@interface WFPikerView ()


@property(nonatomic,strong)UILabel *RWNTitleLable;

@end


@implementation WFPikerView



- (instancetype)initWithFrame:(CGRect)frame withAreaModelArr:(NSArray *)modelArr
{
    if (self = [super initWithFrame:frame])
    {
//        [self addpikerViewWithAreaModelArr:modelArr];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame withAreaModelDic:(NSDictionary *)modelDic Province:(NSString *)provinceName city:(NSString *)cityName Area:(NSString *)areaName{
    if (self = [super initWithFrame:frame])
    {
        allData = modelDic;
        selectedProvince = provinceName;
        selectedCity = cityName;
        selectedArea = areaName;
        [self addpikerViewWithAreaModelDic:modelDic];
    }
    return self;
}


-(void)addpikerViewWithAreaModelDic:(NSDictionary *)modelDic
{
    //添加蒙版
    UIButton *MBbutton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, ScreenSize.width, ScreenSize.height-64)];
    MBbutton.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    [self addSubview:MBbutton];
    [MBbutton addTarget:self action:@selector(topMBbutton) forControlEvents:UIControlEventTouchUpInside];
    
//    //解析modelArr的东西
//    //__________________________________________________________________________
//    
    province = [modelDic allKeys]; // 所有的省
//    RWNAreaModel *selectedProvinceModel = [province objectAtIndex:0];
////    NSString *selectedProvinceName = selectedProvinceModel.areaName;
//    
//    NSArray *cityArray = selectedProvinceModel.children;
//    city = [[NSArray alloc] initWithArray: cityArray];
//    RWNAreaModel *selectedCityModel = [city objectAtIndex:0];
////    NSString *selectedCityName = selectedCityModel.areaName;
//    
//    NSArray *districtArray = selectedCityModel.children;
//    district = [[NSArray alloc] initWithArray: districtArray];
//    RWNAreaModel *selectedDistrictModel = [city objectAtIndex:0];
////    NSString *selectedDistrictName = selectedDistrictModel.areaName;
    
      //__________________________________________________________________________
    
    
    
    //创建一个view(承载时间选择器)
    CGFloat DatePickerviewW=ScreenSize.width;
    CGFloat DatePickerviewH=ScreenSize.height/1333*600;
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
    RWNTitle.text=self.title;
    [DatePickerview addSubview:RWNTitle];
    self.RWNTitleLable=RWNTitle;
    
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
    
    //添加时间选择器
    CGFloat datepickerW=DatePickerviewW;
    CGFloat datepickerH=DatePickerview.mj_h-TopView.mj_h;
    CGFloat datepickerX=0;
    CGFloat datepickerY=TopView.mj_h;
    picker = [[UIPickerView alloc] initWithFrame: CGRectMake(datepickerX, datepickerY, datepickerW, datepickerH)];
    picker.dataSource = self;
    picker.delegate = self;
    picker.showsSelectionIndicator = YES;
   

    [DatePickerview addSubview: picker];
    
    if ([NSString checkForNull:selectedProvince] && [NSString checkForNull:selectedCity]&& [NSString checkForNull:selectedArea]) {
        [picker selectRow: 0 inComponent: 0 animated: YES];
        selectedProvince = [province objectAtIndex: 0];// 默认选中第一个省
        NSArray *Arr = allData[selectedProvince];
        NSDictionary *dic = [Arr firstObject];
        NSArray *allCity = [dic allKeys];
        city = allCity;
        selectedCity = [allCity objectAtIndex:0]; // 当前默认选中第一个市
        NSArray *areaArr = dic[selectedCity];
        district = areaArr;
        selectedArea = [areaArr objectAtIndex:0];
    }else{
        
        NSArray *Arr = allData[selectedProvince];
        NSDictionary *dic = [Arr firstObject];
        NSArray *allCity = [dic allKeys];
        city = allCity;
        NSArray *areaArr = dic[selectedCity];
        district = areaArr;
        for (int i = 0; i<province.count; i++) {
            NSString *pName = province[i];
            if ([pName isEqualToString:selectedProvince]) {
                [picker selectRow:i inComponent:0 animated:YES];
            }
        }
        for (int i = 0; i<city.count; i++) {
            NSString *pName = city[i];
            if ([pName isEqualToString:selectedCity]) {
                [picker selectRow:i inComponent:CITY_COMPONENT animated:YES];
            }
        }
        for (int i = 0; i<district.count; i++) {
            NSString *pName = district[i];
            if ([pName isEqualToString:selectedArea]) {
                [picker selectRow:i inComponent:DISTRICT_COMPONENT animated:YES];
            }
        }
        
    }

}

-(void)setTitle:(NSString *)title{

    _title=title;
    
    self.RWNTitleLable.text=title;
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark- button clicked
#pragma mark- Picker Data Source Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == PROVINCE_COMPONENT) {
        return [province count];
    }
    else if (component == CITY_COMPONENT) {
      
        return city.count;
//        return [self getNumOfCityByProvince:selectedProvince];
    }
    else {
        
        return district.count;
        return [self getNumOfAreaByCity:selectedCity];
    }
}


#pragma mark ======= 根据省取市的个数
-(NSInteger)getNumOfCityByProvince:(NSString *)myprovince{
    NSArray *Arr = allData[myprovince];
    NSDictionary *dic = [Arr firstObject];
    NSArray *allCity = [dic allKeys];
//    city = allCity;
    return allCity.count;
}

-(NSInteger)getNumOfAreaByCity:(NSString *)myCity{
    NSArray *Arr = allData[selectedProvince];
    NSDictionary *dic = [Arr firstObject];
    NSArray *allCity = [dic allKeys];
//    city = allCity;
    NSArray *areaArr = dic[myCity];
//    district = areaArr;
    return areaArr.count;
}


#pragma mark- Picker Delegate Methods

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == PROVINCE_COMPONENT) {
        NSString *Provincename = [province objectAtIndex:row];
        return Provincename;
    }
    else if (component == CITY_COMPONENT) {
        NSString *cityName = [city objectAtIndex:row];
        return cityName;
    }
    else {
        NSString *areaName = [district objectAtIndex:row];
        return areaName;
    }
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == PROVINCE_COMPONENT) {
        NSString *provinceName = [province objectAtIndex:row];
        NSArray *Arr = allData[provinceName];
        NSDictionary *dic = [Arr firstObject];
        NSArray *allCity = [dic allKeys];
        city = [[NSArray alloc] initWithArray: allCity];
        NSString *cityName =city[0];
        NSArray *areaArray =dic[cityName];
        district = [[NSArray alloc] initWithArray:areaArray];
        [picker selectRow: 0 inComponent: CITY_COMPONENT animated: YES];
        [picker selectRow: 0 inComponent: DISTRICT_COMPONENT animated: YES];
        [picker reloadComponent: CITY_COMPONENT];
        [picker reloadComponent: DISTRICT_COMPONENT];
        selectedProvince = provinceName;
        selectedCity =cityName;//cityName;
        
    }else if (component == CITY_COMPONENT) {
        NSArray *Arr = allData[selectedProvince];
        NSDictionary *dic = [Arr firstObject];
        NSString *cityName = [city objectAtIndex:row];
        NSArray *areaArr = dic[cityName];
        district = [[NSArray alloc] initWithArray:areaArr];
        [picker selectRow: 0 inComponent: DISTRICT_COMPONENT animated: YES];
        [picker reloadComponent: DISTRICT_COMPONENT];
        selectCityIndex = row;
        selectedCity = [city objectAtIndex:row]; //cityName;
    }
    
}


- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (component == PROVINCE_COMPONENT) {
        return ScreenSize.width/3;
    }
    else if (component == CITY_COMPONENT) {
        return ScreenSize.width/3;
    } else {
        return ScreenSize.width/3;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *myView = nil;
    
    if (component == PROVINCE_COMPONENT) {
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 78, 80)];
        myView.textAlignment = NSTextAlignmentCenter;
        
        NSString *selectedName = province[row];
        myView.text = selectedName;
        myView.font = [UIFont systemFontOfSize:18];
        myView.backgroundColor = [UIColor clearColor];
    }
    else if (component == CITY_COMPONENT) {
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 95, 80)];
        myView.textAlignment = NSTextAlignmentCenter;
        NSString *selectedName  = [city objectAtIndex:row];
        myView.text = selectedName;
        myView.font = [UIFont systemFontOfSize:18];
        myView.backgroundColor = [UIColor clearColor];
    }
    else {
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 110, 80)];
        myView.textAlignment = NSTextAlignmentCenter;
        NSString *selectedName;
        selectedName = [district objectAtIndex:row];
        myView.text = selectedName;
        myView.font = [UIFont systemFontOfSize:18];
        myView.backgroundColor = [UIColor clearColor];
    }
    
    return myView;
}

//点击确定

- (void) topYes:(id)sender {
    NSInteger provinceIndex = [picker selectedRowInComponent: PROVINCE_COMPONENT];
    NSInteger cityIndex = [picker selectedRowInComponent: CITY_COMPONENT];
    NSInteger districtIndex = [picker selectedRowInComponent: DISTRICT_COMPONENT];
    
    NSString *selectedProvinceName= [province objectAtIndex: provinceIndex];
    NSString *selectedCityName = [city objectAtIndex: cityIndex];
    NSString *selectedDistrictName = [district objectAtIndex:districtIndex];
    
    NSString *showMsg = [NSString stringWithFormat: @"%@ %@ %@", selectedProvinceName, selectedCityName, selectedDistrictName];
    if ([selectedProvinceName isEqualToString:selectedCityName]) {
        showMsg = [NSString stringWithFormat: @"%@ %@", selectedProvinceName, selectedDistrictName];
    }
    if ([self.delegate respondsToSelector:@selector(WFPikerView:topYesButtonWithDate:provinceStr:cityStr:districtStr:)]) {
        [self.delegate WFPikerView:self topYesButtonWithDate:showMsg provinceStr:selectedProvinceName cityStr:selectedCityName districtStr:selectedDistrictName];
    }
  
    
}

//点击取消
- (void)topNO:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(WFPikerViewTopCancen:)]) {
        [self.delegate WFPikerViewTopCancen:self];
    }
    
}
//点击蒙版
-(void)topMBbutton
{
    if ([self.delegate respondsToSelector:@selector(WFPikerViewTopMBbutton:)]) {
        [self.delegate WFPikerViewTopMBbutton:self];
    }
}

@end
