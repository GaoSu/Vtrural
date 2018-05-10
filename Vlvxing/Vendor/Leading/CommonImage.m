//
//  CommonImage.h
//  lvxingyongche
//
//  Created by Michael on 16/1/8.
//  Copyright © 2016年 handong001. All rights reserved.
//
#import "CommonImage.h"

@implementation CommonImage
-(id)initWithFrame:(CGRect)frame imageURL:(NSString *)imageURL
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.userInteractionEnabled = YES;
        [self sd_setImageWithURL:[NSURL URLWithString:imageURL]  placeholderImage:[UIImage imageNamed:@""]];
     //   [self setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@""]];
    }
    return self;
}
-(id)initWithFrame:(CGRect)frame imageName:(NSString *)imageName
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.userInteractionEnabled = YES;
        [self setImage:[UIImage imageNamed:imageName]];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
