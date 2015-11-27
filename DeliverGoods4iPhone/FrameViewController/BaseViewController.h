//
//  MainPageViewController.h
//  LeftSlide
//
//  Created by huangzhenyu on 15/6/18.
//  Copyright (c) 2015年 eamon. All rights reserved.
//

#import <UIKit/UIKit.h>

//static float  constEdge = 5;
//static float constMiddle =2;
//static float  constEdge = 5;
//static float constMiddle =2;

@interface BaseViewController : UIViewController
@property (nonatomic) BOOL leftSlideEnabled;
@property ( nonatomic )BOOL touchDismissKeyboardEnabled;
@property ( nonatomic )BOOL scrollToVisibleEnabled;
@property(strong,nonatomic)UITapGestureRecognizer *tapTouch;
-(void) backAction;
@end
