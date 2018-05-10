//
//  VLX_gaiqianChooseModel.h
//  Vlvxing
//
//  Created by grm on 2017/11/21.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VLX_gaiqianChooseModel : NSObject

@property (nonatomic,strong)NSString * actFlightNo;//航班号CA1117;
@property (nonatomic,strong)NSString * arrAirportCode;//HET
@property (nonatomic,strong)NSString * cabin ;//舱位
////@property (nonatomic,assign)double ba
//
@property (nonatomic,strong)NSString *  dptAirportCode;//PEK
//@property (nonatomic,strong)NSString * arrTerminal;//""
//@property (nonatomic,strong)NSString * dptTerminal;//T3
@property (nonatomic,strong)NSString * endPlace;//落地机场
@property (nonatomic,strong)NSString * startPlace;///起飞机场
@property (nonatomic,strong)NSString * endTime;//10:33
@property (nonatomic,strong)NSString * flight;//中国国航
@property (nonatomic,strong)NSString * flightNo;//航班号CA1117
@property (nonatomic,strong)NSString * flightType;//空客321(中)
@property (nonatomic,assign)int      gqFee;//改签费
@property (nonatomic,strong)NSString * startTime;//07:03
@property (nonatomic,strong)NSString * uniqKey;//
@property (nonatomic,strong)NSDictionary * flightSegmentList;



+(VLX_gaiqianChooseModel *)infoListWithDict:(NSDictionary *)dict;

-(instancetype)initWithDict:(NSDictionary *)dict;

@end
