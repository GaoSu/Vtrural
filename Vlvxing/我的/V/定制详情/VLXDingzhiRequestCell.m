//
//  VLXDingzhiRequestCell.m
//  Vlvxing
//
//  Created by 王静雨 on 2017/6/6.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXDingzhiRequestCell.h"
@interface VLXDingzhiRequestCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end
@implementation VLXDingzhiRequestCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _titleLab.textColor=[UIColor hexStringToColor:@"#666666"];
    _textView.textColor=[UIColor hexStringToColor:@"#313131"];
    _textView.layer.cornerRadius=4;
    _textView.layer.masksToBounds=YES;
    _textView.layer.borderWidth=0.5;
    _textView.layer.borderColor=[UIColor hexStringToColor:@"#999999"].CGColor;
}
-(void)createUIWithRequestStr:(NSString *)requestStr
{
    _textView.text=[ZYYCustomTool checkNullWithNSString:requestStr];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
