//
//  YBImgPickerViewCell.m
//  settingsTest
//
//  Created by 宋奕兴 on 15/9/7.
//  Copyright (c) 2015年 宋奕兴. All rights reserved.
//

#import "YBImgPickerViewCell.h"
@interface YBImgPickerViewCell ()
@property (nonatomic , strong) IBOutlet UIImageView * mainImageView;
@property (nonatomic , strong) IBOutlet UIImageView * isChoosenImageView;
@property (nonatomic , strong) IBOutlet UIView * backLayer;

@end
@implementation YBImgPickerViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    UITapGestureRecognizer * isChoosenImageViewTapG = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(isChoosenImageViewTap)];
    self.isChoosenImageView.userInteractionEnabled = YES;
    [self.isChoosenImageView addGestureRecognizer:isChoosenImageViewTapG];
    
}
- (void)isChoosenImageViewTap {
    if ([self.delegate respondsToSelector:@selector(cellIsChoosen:)]) {
        [self.delegate cellIsChoosen:self];
    }
}
- (void)setContentImg:(UIImage *)contentImg {
    if (contentImg) {
        _contentImg = contentImg;
        self.mainImageView.image = _contentImg;
    }
}
- (void)setIsChoosen:(BOOL)isChoosen {
    _isChoosen = isChoosen;
    [UIView animateWithDuration:0.2 animations:^{
        if (isChoosen) {
            self.isChoosenImageView.image = [UIImage imageNamed:@"YBimgPickerView.bundle/isChoosenY"];
            
        }else {
            self.isChoosenImageView.image = [UIImage imageNamed:@"YBimgPickerView.bundle/isChoosenN"];
        }
        self.backLayer.hidden = !isChoosen;
        self.isChoosenImageView.transform = CGAffineTransformMakeScale (1.1,1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            self.isChoosenImageView.transform = CGAffineTransformMakeScale (1.0,1.0);
        } completion:^(BOOL finished) {
            
        }];
    }];
    
}
- (void)setIsChoosenImgHidden:(BOOL)isChoosenImgHidden {
    _isChoosenImgHidden = isChoosenImgHidden;
    self.isChoosenImageView.hidden = isChoosenImgHidden;
}
@end
