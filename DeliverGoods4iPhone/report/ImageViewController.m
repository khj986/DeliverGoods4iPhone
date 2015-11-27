//
//  ImageViewController.m
//  DeliverGoods4iPhone
//
//  Created by ztt on 15/11/20.
//  Copyright © 2015年 ztt. All rights reserved.
//
#import "Prefix.h"
#import "ImageViewController.h"

@interface ImageViewController ()

@end

@implementation ImageViewController


-( instancetype) initWithImage:(UIImage*)image{
    if( self = [super init] ){
        self.view.backgroundColor = [UIColor whiteColor];
        
        CGSize  size1;
        CGSize  size2;
        UIImageView * imageView = [[UIImageView alloc]initWithImage:image];
        [self.view addSubview:imageView];
        if( image.size.height >image.size.width ){
            
           size1 =  CGSizeMake(ScreenW,ScreenW*( image.size.height /image.size.width));
           size2 =  CGSizeMake(ScreenH*( image.size.width /image.size.height),ScreenH);
            if( size1.width <size2.width ){
                [imageView makeConstraints:^(MASConstraintMaker *make) {
                    make.center.equalTo(self.view);
                    make.width.equalTo(size1.width);
                    make.height.equalTo( size1.height );
                }];
            } else{
                [imageView makeConstraints:^(MASConstraintMaker *make) {
                    make.center.equalTo(self.view);
                    make.width.equalTo(size2.width);
                    make.height.equalTo( size2.height );
                }];
            }
        }else{
            //旋转90度
            size1 =  CGSizeMake(ScreenW*( image.size.width /image.size.height),ScreenW);
            size2 =  CGSizeMake(ScreenH,ScreenH*( image.size.height /image.size.width));
            
            if( size1.width <size2.width ){
                [imageView makeConstraints:^(MASConstraintMaker *make) {
                    make.center.equalTo(self.view);
                    make.height.equalTo(size1.height);
                    make.width.equalTo( size1.width );
                }];
            }else{
                [imageView makeConstraints:^(MASConstraintMaker *make) {
                    make.center.equalTo(self.view);
                    make.height.equalTo(size2.height);
                    make.width.equalTo( size2.width );
                }];
            }
            
            imageView.transform = CGAffineTransformRotate(imageView.transform, M_PI_2);
        }
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCurrView)];
        [self.view addGestureRecognizer:tap];
        
    }
    return self;
}

-(void)tapCurrView{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
