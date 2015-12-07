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
    _navigationBarHidden = NO;
    
    self.view.backgroundColor = XYColor(245, 248, 249, 1);
    //self.view.backgroundColor = [UIColor redColor];

    
    UIButton * back = [UIButton new];
    UIImage *img=[UIImage imageNamed:@"形状-1" ];
    back.frame =CGRectMake(0, 0, 38*ScaleY, 38*ScaleY);
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
    if( _navigationBarHidden ){
        [self.navigationController setNavigationBarHidden:YES];
    }else{
        [self.navigationController setNavigationBarHidden:NO];
    }
    
    if ( self.navigationController.navigationBarHidden == YES )
    {
        // [self.view setBounds:CGRectMake(0, -20, self.view.bounds.size.width, self.view.bounds.size.height)];
    }
    else
    {
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
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
    

}

- (void)viewWillDisappear:(BOOL)animated
{
    if( _navigationBarHidden ){
        [self.navigationController setNavigationBarHidden:NO];
    }
    
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

}


- (void)keyboardWillChangeFrameNotification:(NSNotification *)notification {
    
    if (keyboardVisible) {
        return;
    }
    keyboardVisible= YES;
    UIView *firstResponder = [[[UIApplication sharedApplication] keyWindow] performSelector:@selector(firstResponder)];
    
    // 获取键盘基本信息（动画时长与键盘高度）
    NSDictionary *userInfo = [notification userInfo];
    CGRect rect = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardHeight = CGRectGetHeight(rect);
    CGFloat keyboardDuration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //    [_scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
    //        make.bottom.mas_equalTo(self.view).offset(-keyboardHeight);
    //    }];
    _keyboardScrollView.frame = CGRectMake(0, 0, _keyboardScrollView.frame.size.width, _keyboardScrollView.frame.size.height-keyboardHeight);
    
    // 修改下边距约束
    CGRect rectF = (firstResponder.frame);
    CGRect rectConvert = [firstResponder.superview convertRect:rectF toView:self.view];
    
//    CGRect rectS;
//    if( self.navigationController.navigationBarHidden ){
//        rectS =  rectConvert;
//    }else{
//        rectS = CGRectMake(rectConvert.origin.x, rectConvert.origin.y-64, rectConvert.size.width, rectConvert.size.height);
//    }
    
    float heightMax = CGRectGetMaxY(rectConvert);
    
    float keyboardTop = CGRectGetMinY(rect);
    
    if( heightMax >keyboardTop ){
        //        [_containerView mas_updateConstraints:^(MASConstraintMaker *make) {
        //            make.top.bottom.mas_equalTo(self.view).offset( -(heightMax-keyboardTop) );
        //        }];
        
        [_keyboardScrollView scrollRectToVisible:rectConvert animated:YES];
        //_keyboardScrollView.contentOffset = CGPointMake(_keyboardScrollView.contentOffset.x, _keyboardScrollView.contentOffset.y+(heightMax-keyboardTop+64));
    }
    
    
    
    
    // 更新约束
    //    [UIView animateWithDuration:keyboardDuration animations:^{
    //        //[self.view setNeedsLayout];
    //        [self.view layoutIfNeeded];
    //       // if( heightMax >keyboardTop ){
    //            //contentTransformOrigin = _containerView.transform;
    //           // _containerView.transform = CGAffineTransformTranslate(_containerView.transform, 0, -(heightMax-keyboardTop));
    //            //CGRect bounds = _containerView.bounds;
    //           // _containerView.bounds = CGRectMake(0, (heightMax-keyboardTop), bounds.size.width, bounds.size.height);
    //       // }
    ////         CGPoint offset = _scrollView.contentOffset;
    ////         _scrollView.contentOffset = CGPointMake(offset.x,offset.y+keyboardHeight);
    //    }];
    
    
    
}

- (void)keyboardWillHideNotification:(NSNotification *)notification {
    
    if (!keyboardVisible) {
        return;
    }
    keyboardVisible = NO;
    UIView *firstResponder = [[[UIApplication sharedApplication] keyWindow] performSelector:@selector(firstResponder)];
    // 获得键盘动画时长
    NSDictionary *userInfo = [notification userInfo];
    CGFloat keyboardDuration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    
    //    [_scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
    //        make.bottom.mas_equalTo(self.view);
    //    }];
    //
    //    [_containerView mas_updateConstraints:^(MASConstraintMaker *make) {
    //        make.top.bottom.mas_equalTo(self.view) ;
    //    }];
//    if( _navigationBarHidden ){
//        _keyboardScrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//    }else{
        _keyboardScrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//    }
    
    _keyboardScrollView.contentOffset = CGPointZero;
    
    
    // 更新约束
    //    [UIView animateWithDuration:keyboardDuration animations:^{
    //       // [self.view setNeedsLayout];
    //        [self.view layoutIfNeeded];
    //        //_containerView.transform = contentTransformOrigin;
    //        //_containerView.bounds = CGRectMake(0, 0, _containerView.bounds.size.width, _containerView.bounds.size.height);
    //        //_scrollView.contentOffset  = CGPointZero;
    //    }];
}

@end
