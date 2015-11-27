//
//  MainPageViewController.m
//  LeftSlide
//
//  Created by huangzhenyu on 15/6/18.
//  Copyright (c) 2015年 eamon. All rights reserved.
//



#import "BaseViewController.h"
#import "AppDelegate.h"
#import "Prefix.h"

@interface BaseViewController (){
    
}

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _leftSlideEnabled  = NO;
    _touchDismissKeyboardEnabled = NO;
    _scrollToVisibleEnabled =NO;
    
    //self.view.backgroundColor = XYColor(245, 248, 249, 1);
    self.view.backgroundColor = [UIColor redColor];
        if ( self.navigationController.navigationBarHidden == YES )
        {
           // [self.view setBounds:CGRectMake(0, -20, self.view.bounds.size.width, self.view.bounds.size.height)];
        }
        else
        {
            
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
    
    UIButton * back = [UIButton new];
    UIImage *img=[UIImage imageNamed:@"形状-1" ];
    back.frame =CGRectMake(0, 0, img.size.width, img.size.height);
    [back setBackgroundImage:img forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:back];
    
//    UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    menuBtn.frame = CGRectMake(0, 0, 20, 18);
//    [menuBtn setBackgroundImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
//    [menuBtn addTarget:self action:@selector(openOrCloseLeftList) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];
}

-(void)dismissKeyboard{
    [self.view endEditing:YES];
}

-(void) backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dealloc{

    NSLog(@"%@释放了",self.description);
}

- (void) openOrCloseLeftList
{
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (tempAppDelegate.LeftSlideVC.closed)
    {
        [tempAppDelegate.LeftSlideVC openLeftView];
    }
    else
    {
        [tempAppDelegate.LeftSlideVC closeLeftView];
    }

}

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear");
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if(_leftSlideEnabled){
        
        [tempAppDelegate.LeftSlideVC setPanEnabled:YES];
    }
    else{
        [tempAppDelegate.LeftSlideVC setPanEnabled:NO];
    }
    if(_touchDismissKeyboardEnabled  ){
        
        self.tapTouch =[[UITapGestureRecognizer alloc]init];
        [self.tapTouch addTarget:self action:@selector(dismissKeyboard)];
        [self.view addGestureRecognizer:self.tapTouch];
        [self.navigationController.view addGestureRecognizer:self.tapTouch];
    }
    
    if( _scrollToVisibleEnabled ){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrameNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
    }
    
    //[self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSLog(@"viewWillDisappear");
    if(_leftSlideEnabled){
        AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [tempAppDelegate.LeftSlideVC setPanEnabled:NO];
    }
    if(_touchDismissKeyboardEnabled  ){
        [self.view removeGestureRecognizer:self.tapTouch];
        [self.navigationController.view removeGestureRecognizer:self.tapTouch];
        
    }
    
    if( _scrollToVisibleEnabled ){

        [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
        [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    }
    //[self.navigationController setNavigationBarHidden:NO];
}



@end
