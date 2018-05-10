//
//  VLXMineUserCell.m
//  Vlvxing
//
//  Created by 王静雨 on 2017/5/18.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXMineUserCell.h"
#import "UIImageView+WebCache.h"
@interface VLXMineUserCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLab;
@property (weak, nonatomic) IBOutlet UIView *margin;
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;

@end
@implementation VLXMineUserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UIImage * img = [UIImage imageNamed:@"myBGImg"];
    self.contentView.backgroundColor = [UIColor colorWithPatternImage:img];
//self.contentView.layer.contents = (id)[UIImage imageNamed:@"mainBGImg.png"].CGImage;
//    UIImage *image = [UIImage imageNamed:@"mainBGImg.png"];  UIGraphicsBeginImageContextWithOptions(self.contentView.frame.size, NO, 0.f);
//    [image drawInRect:self.contentView.bounds];
//    UIImage *lastImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    self.contentView.backgroundColor = [UIColor colorWithPatternImage:lastImage];

    _iconImageView.layer.cornerRadius=32;
    _iconImageView.layer.masksToBounds=YES;
    _userNameLab.textColor=[UIColor hexStringToColor:@"#313131"];
    _margin.backgroundColor=[UIColor hexStringToColor:@"#dddddd"];
    self.lineView1=[[UIView alloc] initWithFrame:CGRectMake(0, self.contentView.frame.size.height-50, ScreenWidth, 50)];//高为50的线,放置三个按钮
    self.lineView1.backgroundColor=[UIColor whiteColor];//orange_color;
    self.lineView1.userInteractionEnabled = YES;

    UILabel * line = [[UILabel alloc]initWithFrame:CGRectMake(0, 49, ScreenWidth, 1)];
    line.backgroundColor = rgba(240, 240, 240, 1);
    [self.lineView1 addSubview:line];

    [self.contentView addSubview:self.lineView1];
}

-(void)setcellValuewithDic:(NSDictionary * )dic
{
    NSString *nameStr =[NSString stringWithFormat:@"%@",dic[@"usernick"]];
    if ([NSString hd_isNotNull:nameStr]) {
        self.userNameLab.text= nameStr;
    }else{
        self.userNameLab.text = @"";
    }
    if ([dic[@"usersex"] integerValue]==1) {
    //男的
        self.sexImageView.image=[UIImage imageNamed:@"man-blue"];
        self.sexImageView.size=CGSizeMake(22, 22);
    }else
    {
        self.sexImageView.image=[UIImage imageNamed:@"nv-red"];
      self.sexImageView.size=CGSizeMake(16, 22);
    }

//sd加载视图的view
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dic[@"userpic"]]] placeholderImage:[UIImage imageNamed:@"touxiang-moren"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
