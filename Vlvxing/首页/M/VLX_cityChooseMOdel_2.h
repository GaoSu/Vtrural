#import "JSONModel.h"
@interface VLX_cityChooseMOdel_2 : JSONModel
@property (nonatomic,strong)NSString * areaid;
@property (nonatomic,strong)NSString * uriCode;
@property (nonatomic,strong)NSString * address;//需要的城市名字
@property (nonatomic,strong)NSString * belongtocity;//
@property (nonatomic,strong)NSString * airportZh;
@property (nonatomic,strong)NSString * airportZhShort;
@property (nonatomic,strong)NSString * airportEn;
@property (nonatomic,strong)NSString * airportPy;
@property (nonatomic,strong)NSString * airportPyShort;
//@property (nonatomic,assign)NSInteger  validate;
@property (nonatomic,strong)NSString * isHot;//是否热门城市=1是, =null不是
@property (nonatomic,strong)NSString * capitalized;
@end
