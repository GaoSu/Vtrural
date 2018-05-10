//
//  VLXRecordHeaderCell.m
//  Vlvxing
//
//  Created by 王静雨 on 2017/6/3.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXRecordHeaderCell.h"
@interface VLXRecordHeaderCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UILabel *desLab;

@end
@implementation VLXRecordHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

//    _desLab.text=@"描述：今天找到一家很不错的茶馆，里面很安静，服务很周到，茶的味道很不错，很有情调，还有不同分类的各种书籍，很适合谈事或者一个人安安静静的放松下来，大家可以来感受下。";
    //
    _dateLab.textColor=[UIColor hexStringToColor:@"#666666"];
    _addressLab.textColor=orange_color;
    _desLab.textColor=[UIColor hexStringToColor:@"#666666"];
    //
}
-(void)createUIWithModel:(VLXRecordDetailDataModel *)model
{
    _titleLab.text=[ZYYCustomTool checkNullWithNSString:model.travelroadtitle];
    _dateLab.text=[[NSString stringWithFormat:@"%@",model.createtime] RwnTimeExchange4];
    _addressHeight.constant = [model.startareaanddestination sizeWithFont:[UIFont systemFontOfSize:16] maxSize:CGSizeMake(ScreenWidth - 22, MAXFLOAT)].height+5;
    _addressLab.text=[ZYYCustomTool checkNullWithNSString:model.startareaanddestination];
    _desLab.text=[ZYYCustomTool checkNullWithNSString:model.record_description];
    //添加手势
    _addressLab.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToRoute:)];
    [_addressLab addGestureRecognizer:tap];
}
#pragma mark---事件
-(void)tapToRoute:(UITapGestureRecognizer *)tap
{
    if (_addressBlock) {
        _addressBlock();
    }
}
#pragma mark
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
