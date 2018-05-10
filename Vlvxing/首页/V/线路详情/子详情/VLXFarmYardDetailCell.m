//
//  VLXFarmYardDetailCell.m
//  Vlvxing
//
//  Created by 王静雨 on 2017/6/23.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXFarmYardDetailCell.h"
@interface VLXFarmYardDetailCell ()
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UILabel *distanceLab;

@end
@implementation VLXFarmYardDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor=backgroun_view_color;
    _addressLab.textColor=[UIColor hexStringToColor:@"#313131"];
    _distanceLab.textColor=orange_color;
    
}
-(void)createUIWithModel:(VLXHomeDetailModel *)model
{
    _addressLab.text=[ZYYCustomTool checkNullWithNSString:model.data.address];
    
    _distanceLab.text=[NSString stringWithFormat:@"%@km",[ZYYCustomTool checkNullWithNSString:[NSString stringWithFormat:@"%.2f",model.data.distance.floatValue/1000]]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
