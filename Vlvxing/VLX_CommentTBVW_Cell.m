
//
//  VLX_CommentTBVW_Cell.m
//  Vlvxing
//
//  Created by grm on 2017/10/26.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLX_CommentTBVW_Cell.h"

@implementation VLX_CommentTBVW_Cell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    self.contentView.backgroundColor = [UIColor whiteColor];
    
}
//高亮
-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self UI2];
    }return self;
}

-(void)UI2
{
    _headImgvw = [[UIImageView alloc]initWithFrame:CGRectMake(11, 8, 48, 48)];
    _headImgvw.backgroundColor =[UIColor lightGrayColor];
    _headImgvw.layer.cornerRadius = 24;
    _headImgvw.layer.masksToBounds = YES;
    
    
    _nameLb = [[UILabel alloc]init];
    _nameLb.text = @"蛋蛋";
    _nameLb.font = [UIFont systemFontOfSize:15];
    UIFont *font1 = [UIFont fontWithName:@"Courier New" size:15.0f];
    _nameLb.font = font1;
    CGSize size1 = [_nameLb.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font1,NSFontAttributeName,nil]];
    CGFloat nameW = size1.width;
    _nameLb.frame = CGRectMake(70,29, nameW,15);
    
//    _louceng = [[UILabel alloc]init];
//    _louceng.backgroundColor = [UIColor orangeColor];
//    _louceng.text = @"10楼主";
//    _louceng.textColor = [UIColor whiteC];
//    _louceng.layer.cornerRadius = 3;
//    _louceng.clipsToBounds = YES;
//    UIFont *font2 = [UIFont fontWithName:@"Courier New" size:10.0f];//12
//    _louceng.font = font2;
//    CGSize size2 = [_louceng.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font2,NSFontAttributeName,nil]];
//    CGFloat nameW2 = size2.width;
//    _louceng.frame = CGRectMake(70,9, nameW2,15);

    
    
//    _dateLb = [[UILabel alloc]initWithFrame:CGRectMake(70+6+ nameW, 32, 55, 9)];
//    _dateLb.font = [UIFont systemFontOfSize:9];
//    _dateLb.text = @"2017-09-09";

    
    
    _timeLb = [[UILabel alloc]init];//WithFrame:CGRectMake(70+6+ nameW, 32, 155, 10)];//
    _timeLb.textColor = [UIColor lightGrayColor];
    _timeLb.font = [UIFont systemFontOfSize:10];
    _timeLb.text = @"22:34";


    _MUT_titleLb =[[AttributeLabel alloc]init];//WithFrame:CGRectMake(70,60 , ScreenWidth-90, 50)];
    _MUT_titleLb.font = [UIFont systemFontOfSize:14];
    _MUT_titleLb.textColor = [UIColor blackColor];
    _MUT_titleLb.backgroundColor = [UIColor clearColor];

    _huifuImgvW = [[UIImageView alloc]init];


    _sumView = [[UIView alloc]initWithFrame:CGRectMake(11, 92, ScreenWidth-22, 0)];//正文图片
    _sumView.backgroundColor = [UIColor lightGrayColor];

//    
    _commentBt = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth - 50, 16, 30, 23)];
    [_commentBt setImage:[UIImage imageNamed:@"comment-@3x"] forState:UIControlStateNormal];


    
    
    [self.contentView addSubview:_headImgvw];
    [self.contentView addSubview:_nameLb];
    [self.contentView addSubview:_dateLb];
    [self.contentView addSubview:_timeLb];
    [self.contentView addSubview:_MUT_titleLb];
    [self.contentView addSubview:_huifuImgvW];
    [self.contentView addSubview:_sumView];
//    [self.contentView addSubview:_areaImgvw];
//    [self.contentView addSubview:_areaLb];
//    [self.contentView addSubview:_watchImgvw];
//    [self.contentView addSubview:_watchLb];
    [self.contentView addSubview:_commentBt];
//    [self.contentView addSubview:_commentLb];
    
    
}

-(void)FillWithModel:(VLX_detailhuifuModel *)model
{
    [_headImgvw sd_setImageWithURL:model.member[@"userpic"] placeholderImage:nil];
    if(model.weiboComment == nil){
//        NSLog(@"没有评论的回复");
        self.MUT_titleLb.text = model.content;
//        self.MUT_titleLb.frame =CGRectMake(70,55 , ScreenWidth-90, 50);
    }
    else{
//        NSLog(@"有评论的回复");
        _MUT_titleLb.text = [NSString stringWithFormat:@"%@<@%@:>%@",model.content,model.weiboComment[@"member"][@"usernick"],model.weiboComment[@"content"]];
        _MUT_titleLb.highlightColor = rgba(26, 116, 206, 1);
//        _MUT_titleLb.frame =CGRectMake(70,55 , ScreenWidth-90, 60);
        NSLog(@"%@",_MUT_titleLb.text);
    }
    //文字高度
    NSLog(@"_MUT_titleLbText:%@",_MUT_titleLb.text);
        CGRect rect = [_MUT_titleLb.text boundingRectWithSize:CGSizeMake(ScreenWidth-90, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil];
        NSLog(@"文字高度高度%.f",rect.size.height);
        _Cell_height_wz = rect.size.height;//代码ok

    NSAttributedString * attributeStr = [self attributedStringWithHTMLString:_MUT_titleLb.text];
    NSLog(@"attributeStr:%@",attributeStr);
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithAttributedString:attributeStr];
    NSLog(@"attributedString1:%@",attributedString1);
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
//    [paragraphStyle1 setLineSpacing:2];//行间距
//    [attributedString1 addAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor], NSFontAttributeName:[UIFont systemFontOfSize:15]} range:NSMakeRange(0, [_MUT_titleLb.text length])];//字体大小
    [paragraphStyle1 setAlignment:NSTextAlignmentLeft];//字体居左
//    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [_MUT_titleLb.text length])];//范围

    [_MUT_titleLb setAttributedText:attributedString1];
//    [_MUT_titleLb sizeToFit];
    _MUT_titleLb.frame =CGRectMake(70,55 , ScreenWidth-90, _Cell_height_wz+15);


    CGFloat pm_High=0.0f;//屏幕上展示的高度
    if (model.pictures.count == 0) {
        NSLog(@"没有评论的回复的图片");
        _huifuImgvW.frame =CGRectMake(10, 10, 0, 0);
    }
    else{
        CGFloat zhenshi_H = [model.pictures[0][@"height"] floatValue];
        CGFloat zhenshi_W = [model.pictures[0][@"width"] floatValue];
        CGFloat bili = (ScreenWidth-20)/zhenshi_W;
        pm_High = bili * zhenshi_H;

        //文字高度
        CGRect rect = [_MUT_titleLb.text boundingRectWithSize:CGSizeMake(ScreenWidth-32, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
        NSLog(@"高度%.f",rect.size.height);

//        UIImage * img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.pictures[0][@"path"]]]];
//        CGFloat  iheight=0.0f;
//        iheight = [self heightForImage3:img];
        _huifuImgvW.frame =CGRectMake(10, 55 + rect.size.height+8, ScreenWidth-20, pm_High);
        [_huifuImgvW sd_setImageWithURL:[NSURL URLWithString:model.pictures[0][@"path"]]];
    }

    if( [model.member[@"usernick"] isKindOfClass:[NSNull class]]){
        self.nameLb.text  = @"";
    }else{
        self.nameLb.text =  model.member[@"usernick"];
    }
    UIFont *fnt = [UIFont fontWithName:@"Courier New" size:15.0f];
    _nameLb.font = fnt;
    // 根据字体得到NSString的尺寸
    CGSize size1 = [_nameLb.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName,nil]];
    CGFloat nameW1 = size1.width;
    _nameLb.frame = CGRectMake(70,7, nameW1,22);

    NSTimeInterval interval   = [model.createTime doubleValue]/1000;
    NSDate *date              = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd :HH:mm"];
    self.timeLb.text =  [formatter stringFromDate: date];
    self.timeLb.frame = CGRectMake(70, 32, 155, 10);

    if(model.weiboComment[@"content"]){
        NSLog(@"%@",model.weiboComment[@"member"][@"usernick"]);//👌
    }

}

- (CGFloat)heightForImage3:(UIImage *)image
{
    //(1)获取图片的大小
    CGSize imgsize = image.size;
    //(2)求出缩放比例
    CGFloat scale = (ScreenWidth-20) / imgsize.width;
    CGFloat imageHeight = imgsize.height * scale;
    return imageHeight;

}

- (NSAttributedString *)attributedStringWithHTMLString:(NSString *)htmlString
{
    NSDictionary *options = @{ NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType,
                               NSCharacterEncodingDocumentAttribute :@(NSUTF8StringEncoding) };

    NSData *data = [htmlString dataUsingEncoding:NSUTF8StringEncoding];

    return [[NSAttributedString alloc] initWithData:data options:options documentAttributes:nil error:nil];
}



@end
