
//
//  VLX_IMG_Watch.m
//  Vlvxing
//
//  Created by grm on 2018/1/29.
//  Copyright © 2018年 王静雨. All rights reserved.
//

#import "VLX_IMG_Watch.h"

@interface VLX_IMG_Watch ()<UIScrollViewDelegate>
{
    UIScrollView * scrVW;
    UILabel * lb;
}

@end

@implementation VLX_IMG_Watch

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"%ld",(long)_tagger);
    NSLog(@"%ld",_imgAry.count);
    self.view.backgroundColor = [UIColor blackColor];
    [self ui];
}
-(void)ui{

//    scrVW =  [[UIScrollView alloc]initWithFrame:CGRectMake(0, (ScreenHeight/2)-(ScreenWidth * 1.5 / 4), ScreenWidth, ScreenWidth * 3 / 4)];
    scrVW =  [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    scrVW.contentSize = CGSizeMake(ScreenWidth * _imgAry.count, 0);//
    scrVW.pagingEnabled = YES;
    scrVW.delegate = self;

    lb = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/2 - 25, ScreenHeight-30, 50, 20)];
    lb.text = @"1";
    lb.textColor = [UIColor lightGrayColor];
    lb.textAlignment = NSTextAlignmentCenter;



    for (int i= 0; i<_imgAry.count; i++) {
        UIImageView * imageView = [[UIImageView alloc]init];//WithFrame:CGRectMake(self.view.frame.size.width * i, 0,scrVW.frame.size.width , scrVW.frame.size.height)];
//        [inageView contentModeScaleToFill:YES];
        NSLog(@"---------%@",_imgAry[i]);
        imageView.image = _imgAry[i];//[UIImage imageNamed:[NSString stringWithFormat:@"%@",_imgAry[i]]];
        imageView.frame = CGRectMake(self.view.frame.size.width * i,
                                     ScreenHeight/2-imageView.image.size.height*(ScreenWidth/imageView.image.size.width)/2,
                                     imageView.image.size.width*(ScreenWidth/imageView.image.size.width),
                                     imageView.image.size.height*(ScreenWidth/imageView.image.size.width));// cimageView.image.size;
        [scrVW addSubview:imageView];
    }





    UITapGestureRecognizer * tapgest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap2)];
    [scrVW addGestureRecognizer:tapgest];

    [self.view addSubview:scrVW];

    [self.view addSubview:lb];

}
-(void)tap2{
    [self dismissViewControllerAnimated:NO completion:nil];
}

//由点变成数字
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint point = scrVW.contentOffset;
    int currpage = point.x / self.view.frame.size.width;
    lb.text = [NSString stringWithFormat:@"%d",currpage + 1];


}

@end
