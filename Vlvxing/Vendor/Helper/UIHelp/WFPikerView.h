//
//  WFPikerView.h
//  shangxuelian
//
//  Created by hdkj002 on 16/2/27.
//  Copyright © 2016年 hdkj005. All rights reserved.
//

#import <UIKit/UIKit.h>


#define PROVINCE_COMPONENT  0
#define CITY_COMPONENT      1
#define DISTRICT_COMPONENT  2

@class WFPikerView;
@protocol WFPikerViewDelagat <NSObject>



/**
 *  点击确定
 *
 */
-(void)WFPikerView:(WFPikerView *)view topYesButtonWithDate:(NSString *)str provinceStr:(NSString *)provinceModel cityStr:(NSString *)cityModel districtStr:(NSString *)districtModel;
/**
 *  点击取消
 */
-(void)WFPikerViewTopCancen:(WFPikerView *)view;
/**
 * 点击蒙版
 */
-(void)WFPikerViewTopMBbutton:(WFPikerView *)view;
@end


@interface WFPikerView : UIView<UIPickerViewDelegate, UIPickerViewDataSource>{
    NSDictionary *allData;
    UIPickerView *picker;
    UIButton *button;
    NSDictionary *areaDic;
    NSArray *province;
    NSArray *city;
    NSArray *district;
    NSString *selectedProvince;
    NSString *selectedCity;
    NSString *selectedArea;
    NSInteger selectCityIndex;
}

@property(nonatomic,copy)NSString *title;

@property(weak,nonatomic)id<WFPikerViewDelagat> delegate;
- (instancetype)initWithFrame:(CGRect)frame withAreaModelArr:(NSArray *)modelArr;
-(instancetype)initWithFrame:(CGRect)frame withAreaModelDic:(NSDictionary *)modelDic Province:(NSString *)provinceName city:(NSString *)cityName Area:(NSString *)areaName;
@end
