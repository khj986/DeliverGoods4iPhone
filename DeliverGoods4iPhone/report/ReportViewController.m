
#import "Prefix.h"
#import "ReportViewController.h"
#import "ImageAttributedLabel.h"
//#import "ImageLabelLine2.h"
#import "ImageViewController.h"
#import "AFNetworking.h"
#import "Constant.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import "DetailViewController.h"
#import "ListTableviewController.h"
#import "UIKit+AFNetworking.h"
#import "MBProgressHUD+HM.h"

//static  CLLocationManager* _locationManager;

static float  PaddingEdge = 5;
static float PaddingMiddle =2;
static float PaddingLabel =10;
static float LineHeight  =25;
static float LineSpace =0;
//float minLargeSide = 150;
//float midMinSide = 480;
//float midLargeSide  =640;
static CGSize ImgSizeMax;
//static float ImgPadding = 8;
static float PaddingEdgeX;



@interface ReportViewController (){
    float fontSize ;
    ImageAttributedLabel* picTitle;
    UIImageView* locLine;
    UIImageView* picLine;
    UIImageView *background;
    ImageAttributedLabel * locTitle;
    UILabel * locContent;
    //CLLocationManager* locationManager;
    BOOL isLocated;
    //BOOL  keyboardVisible;
    int tag;
    
    int recordImgCount;
    CGSize recordImgSizeMax;
    
    UIButton *report;
    ImgShowType imgShowType;
    float imgScrollX;
    
}

@property (strong,nonatomic) CLLocationManager* locationManager;
@property (strong,nonatomic) AMapLocationManager* AMapLocMgr;
@property (strong,nonatomic) UIScrollView * scrollView;
@property (strong,nonatomic) UIScrollView * imgScrollView;
@property (strong,nonatomic) UIView * containerView;
@property (strong,nonatomic) UIView * imgContainerView;
@property (nonatomic,strong) UITextView* state;
@property (nonatomic,strong) NSMutableArray * images;

@property (copy, nonatomic) void(^reportBlock)(void);
//@property (nonatomic,strong) NSMutableArray * imageNames;
@property (copy, nonatomic) NSString * thisLoc;
@property (nonatomic,strong) UIActivityIndicatorView * activityView;
@property (nonatomic,strong) NSMutableArray * arrayImageName;
@property (nonatomic,strong) NSMutableArray * uploadImageNames;
@property (nonatomic )  CGSize imageShowSize;
@property (nonatomic,strong) NSMutableArray * confirmButtons;
@property (nonatomic,copy) NSString* JSON_Images;
@property (nonatomic) CLLocationCoordinate2D loc2D;
@property (nonatomic,weak)MBProgressHUD * hud;

@end

@implementation ReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.touchDismissKeyboardEnabled = YES;
    self.scrollToVisibleEnabled = YES;
    self.navigationBarHidden = NO;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    //self.edgesForExtendedLayout = UIRectEdgeTop;
    
    PaddingEdgeX =28*ScaleX;
    
   self.title =@"上报信息";

    
    _thisLoc = nil;
    
    _images  = [NSMutableArray array];
    _arrayImageName = [NSMutableArray array];
    for( int i =0;i<5;i++ ){
        [_arrayImageName addObject:@""];
    }
    _imageShowSize = CGSizeZero;
    ImgSizeMax = CGSizeZero;
    _imgScrollView =nil;
    imgShowType = ImgShowTypeSquare;
     //AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    _locationManager = [[CLLocationManager alloc]init];
    
    _locationManager.delegate = self;
    
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    
    _locationManager.distanceFilter = 50.0f;
    //locationManager.allowsBackgroundLocationUpdates = NO;
    //locationManager.pausesLocationUpdatesAutomatically = NO;
    _AMapLocMgr = [[AMapLocationManager alloc]init];
    
    _AMapLocMgr.delegate = self;
    _AMapLocMgr.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    
    [self AMapRequestLocationRepeatNumber:5];
    

    [self addRegister];
    
    
    
//    _activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//    _activityView.hidesWhenStopped = YES;
//    _activityView.color = XYColor(21, 126, 251, 1);
//    [self.view addSubview:_activityView];
//    [_activityView makeConstraints:^(MASConstraintMaker *make) {
//        make.center.mas_equalTo(self.view);
//    }];
//    
//    [_activityView startAnimating];   

    
    

        
        
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.directionalLockEnabled = YES;
        //_scrollView.bounces = NO;
        //_scrollView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:_scrollView];
        _containerView = [[UIView alloc]init];
        [_scrollView addSubview:_containerView];
       // _scrollView.delaysContentTouches = NO;
        //_scrollView.canCancelContentTouches = NO;
        //_scrollView.contentSize = self.view.frame.size;
        _scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64);
        _containerView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64);

        
//        NSLog( @"selfview:%@",NSStringFromCGRect(self.view.frame) );
//        NSLog( @"scroll:%@",NSStringFromCGRect(_scrollView.frame) );
//        NSLog( @"container:%@",NSStringFromCGRect(_containerView.frame) );

    if( self.scrollToVisibleEnabled ){
        self.keyboardScrollView = _scrollView;
    }
    
        
        background = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"3"]];
        [_containerView addSubview: background];
        
        
        [self setupLocation];
        [self setupPic];
        [self setupState];
        [self setupConfirm];

    
        



    
//    void (^delay)(void) =^(){
//        _bulidBlock(NO);
//    };
//    
//    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC*2),
//                   dispatch_get_main_queue(), delay);

    

    
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self addRegister];
    
}

-(void) addRegister{
    if( [CLLocationManager locationServicesEnabled] ){
        if(IOS8){
            [_locationManager requestAlwaysAuthorization];
            //[_locationManager requestWhenInUseAuthorization];            
        }
        [_locationManager startUpdatingLocation];
    }
    
    
    //    else{
//        _bulidBlock(NO);
//    }

}

-(void) removeRegister{
    if( [CLLocationManager locationServicesEnabled] ){
        [_locationManager stopUpdatingLocation];
    }

}

//-(void)viewDidDisappear:(BOOL)animated{
//    [super viewDidDisappear:animated];
//
//}

-(void)dealloc{
    [self removeRegister];
    for( int i= 0;i<_images.count;i++ ){
        [self deleteImageWithName:_arrayImageName[i]];
    }    
}

//解决button与tap手势冲突
//-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
//{
//    // 判断是不是UIButton的类
//    UIView * view= touch.view;
//    NSLog(@"view:%@",view);
////   // if( [touch.view isKindOfClass:[UIScrollView class]] )
////    {
////        if ([touch.view isKindOfClass:[UIButton class]  ])
////            {
////                return NO;
////            }
////            else
////            {
////                return YES;
////            }
////    }
//    return YES;
//}


-( void ) resetScrollViewSize{
    WeakSelf
    [weakSelf.view setNeedsDisplay];
    [weakSelf.view layoutIfNeeded];
    
//    NSLog( @"confirmButton:%@",NSStringFromCGRect( report.frame) );
//    _containerView.frame = CGRectMake(0,0 , ScreenW, CGRectGetMaxY(report.frame)+ PaddingEdge*ScaleY);
//    _scrollView.contentSize = CGSizeMake( ScreenW, CGRectGetMaxY(report.frame)+ PaddingEdge*ScaleY );


    
    _containerView.frame = CGRectMake(0,0 , ScreenW, CGRectGetMaxY(((UIButton*)_confirmButtons[0]).frame)+ PaddingEdge*ScaleY);
    //[_containerView clipsToBounds];
    _scrollView.contentSize = CGSizeMake( ScreenW, CGRectGetMaxY(((UIButton*)_confirmButtons[0]).frame)+ PaddingEdge*ScaleY );
    
//    NSLog( @"container:%@",NSStringFromCGRect(_containerView.frame) );
//    NSLog( @"scroll:%@",NSStringFromCGRect(_scrollView.frame) );
//    NSLog( @"scrollSize:%@",NSStringFromCGSize(_scrollView.contentSize) );
}

//-( void ) resetScrollViewSizeFirst{
//    WeakSelf
//    [self.view setNeedsDisplay];
//    [self.view layoutIfNeeded];
//    //    _containerView.frame = CGRectMake(0,0 , ScreenW, CGRectGetMaxY(background.frame)+ PaddingEdge*ScaleY);
//    //    _scrollView.contentSize = CGSizeMake( ScreenW, CGRectGetMaxY(background.frame)+ PaddingEdge*ScaleY );
//    
//     NSLog( @"confirmButton:%@",NSStringFromCGRect( ((UIButton*)_confirmButtons[0]).frame) );
//    
//    _containerView.frame = CGRectMake(0,0 , ScreenW, CGRectGetMaxY(((UIButton*)_confirmButtons[0]).frame)+ PaddingEdge*ScaleY);
//  //  [_containerView clipsToBounds];
//    _scrollView.contentSize = CGSizeMake( ScreenW, CGRectGetMaxY(((UIButton*)_confirmButtons[0]).frame)+ PaddingEdge*ScaleY+20 );
//    
//    //    NSLog( @"container:%@",NSStringFromCGRect(_containerView.frame) );
//    //    NSLog( @"scroll:%@",NSStringFromCGRect(_scrollView.frame) );
//    //    NSLog( @"scrollSize:%@",NSStringFromCGSize(_scrollView.contentSize) );
//}

-(void)setupLocation{
    
    
    locTitle = [[ImageAttributedLabel alloc]initWithImage:[UIImage imageNamed:@"形状-42"] andLabelText:[[NSAttributedString alloc ]initWithString:@"当前位置:"]];
    locTitle.heightImage = CONST.kLineHeight;
    locTitle.paddingLabel = CONST.ScaleXPaddingLabel;
    [locTitle setUnderlineHidden:YES];
//    locTitle.layer.borderColor = [[UIColor blackColor]CGColor];
//    locTitle.layer.borderWidth = 2;
    [_containerView addSubview:locTitle];
    
    
    
    if( !_thisLoc  ){
        _thisLoc = @"暂未获取到位置信息";
    }
    fontSize = locTitle.label.font.pointSize;
    
    locContent = [UILabel new];
    locContent.numberOfLines = 0;
//    locContent.lineBreakMode = NSLineBreakByWordWrapping;
//    locContent.layer.borderColor = [[UIColor greenColor]CGColor];
//    locContent.layer.borderWidth = 2;
//    locContent.text = _thisLoc;
//    locContent.font = [UIFont fontWithName:nil size:fontSize];
    [_containerView addSubview:locContent];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    //style.lineSpacing = LineSpace;
    style.alignment = NSTextAlignmentLeft;
    style.lineBreakMode = NSLineBreakByWordWrapping;
    
    NSDictionary * dict=@{
                          NSFontAttributeName:[UIFont fontWithName:nil size:fontSize],
                          NSForegroundColorAttributeName:[UIColor blackColor],
                          NSParagraphStyleAttributeName:style
                          };

    NSAttributedString * attStr = [[NSAttributedString alloc]initWithString: _thisLoc attributes:dict];
    locContent.attributedText = attStr;

    
    locLine = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"矩形-9-拷贝-3"]];
    [_containerView addSubview:locLine];
    
    [locTitle makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(background).offset(CONST.ScaleYMiddle);
        make.left.mas_equalTo( MasonryRight(_containerView) ).multipliedBy(CONST.XEdge/640.0);
    }];
    
//    [self.view setNeedsLayout];
//    [self.view layoutIfNeeded];
    
//    NSLog(@"loctitle%@",NSStringFromCGRect(locTitle.bounds));
//    
//    [locTitle makeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(locTitle.bounds.size.width);
//        make.height.equalTo(locTitle.bounds.size.height);
//    }];
    

//     CGSize labelSize =  [attStr boundingRectWithSize:CGSizeMake(ScreenW - CGRectGetMaxX(locTitle.frame) -PaddingEdgeX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading context:nil].size;
//            NSDictionary * dict=@{
//                                  NSFontAttributeName:[UIFont fontWithName:nil size:fontSize],
//                                  };
//    CGSize labelSize  = [locContent.text boundingRectWithSize:CGSizeMake( ScreenW - CGRectGetMaxX(locTitle.frame)-PaddingEdgeX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
//                                        attributes:dict context:nil].size;
    
//    [self.view setNeedsLayout];
//    [self.view layoutIfNeeded];
    
    [locContent makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(locTitle.right);
        make.top.mas_equalTo(locTitle.top);
        //make.centerY.mas_equalTo(locTitle.top);
        make.right.mas_equalTo( MasonryRight(_containerView) ).multipliedBy(1-CONST.XEdge/640.0);
        //make.width.mas_equalTo(labelSize.width);
        //make.height.mas_equalTo(labelSize.height);
    }];
    
//    [locContent sizeToFit];
//    
//        [self.view setNeedsLayout];
//        [self.view layoutIfNeeded];
//
//    NSLog(@"loccontent%@",NSStringFromCGRect(locContent.frame));
//    
//    [locContent makeConstraints:^(MASConstraintMaker *make) {
//        make.height.equalTo( locContent.bounds.size.height );
//    }];

    
//    locTitle.frame = CGRectMake(28*ScaleX, PaddingEdge, locTitle.bounds.size.width, locTitle.bounds.size.height);
//    float contentWidth = ScreenW - CGRectGetMaxX(locTitle.frame) - 28*ScaleX;
//    CGSize contentSize = [attStr boundingRectWithSize:CGSizeMake(contentWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
//                                              context:nil].size;
//    locContent.frame = CGRectMake(CGRectGetMaxX(locTitle.frame), PaddingEdge, contentSize.width, contentSize.height);
//    
//    NSLog(@"loctitle%@",NSStringFromCGRect(locTitle.frame));
//    NSLog(@"loccontent%@",NSStringFromCGRect(locContent.frame));
    
    [locLine makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_greaterThanOrEqualTo( locTitle.bottom );
        make.top.mas_equalTo( locContent.bottom );
        make.left.mas_equalTo( MasonryRight(_containerView) ).multipliedBy(CONST.XEdge/640.0);
        make.right.mas_equalTo( MasonryRight(_containerView) ).multipliedBy(1-CONST.XEdge/640.0);
        make.height.equalTo(1);
    }];
    
    
}

-(void)AMapRequestLocationRepeatNumber:(int)number{
    
    
    if( number <=0 )
        return;
    [_AMapLocMgr requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        


        if(!isLocated ){
            if( location ){
                _loc2D = location.coordinate;
            }
            if(regeocode ){
               
                [self resetLocation:regeocode.formattedAddress];
            }
            
            if (error)
            {
                
                [self AMapRequestLocationRepeatNumber:number-1];
            }
        }
        
        
    }];
}

-(void)resetLocation:(NSString*)newLocation{
    
    if( isLocated )
        return;
    if( newLocation ){
        //locContent.text = newLocation;
        _thisLoc = newLocation;
        
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
        //style.lineSpacing = LineSpace;
        style.alignment = NSTextAlignmentLeft;
        style.lineBreakMode = NSLineBreakByWordWrapping;
        
        NSDictionary * dict=@{
                              NSFontAttributeName:[UIFont fontWithName:nil size:fontSize],
                              NSForegroundColorAttributeName:[UIColor blackColor],
                              NSParagraphStyleAttributeName:style
                              };
        
        NSAttributedString * attStr = [[NSAttributedString alloc]initWithString: _thisLoc attributes:dict];
        locContent.attributedText = attStr;
        
    //    [locContent remakeConstraints:^(MASConstraintMaker *make) {
    //        make.left.mas_equalTo(locTitle.right);
    //        make.top.mas_equalTo(locTitle.top);
    //        //make.centerY.mas_equalTo(locTitle.top);
    //        make.right.mas_equalTo( MasonryRight(_containerView) ).multipliedBy(1-28/640.0);
    //        //make.width.mas_equalTo(labelSize.width);
    //        //make.height.mas_equalTo(labelSize.height+16);
    //    }];
        
        [self resetScrollViewSize];

    }else{
        
    }
    

    isLocated = YES;
    [_locationManager stopUpdatingLocation];
}

-(void)setupPic{
    
    picTitle = [[ImageAttributedLabel alloc]initWithImage:[UIImage imageNamed:@"形状-45"] andLabelText:[[NSAttributedString alloc ]initWithString:@"拍照:"]];
    picTitle.heightImage = CONST.kLineHeight;
    picTitle.paddingLabel = CONST.ScaleXPaddingLabel;
    [picTitle setUnderlineHidden:YES];
    [_containerView addSubview:picTitle];
    [picTitle makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(locLine).offset(PaddingMiddle);
        make.left.mas_equalTo( MasonryRight(_containerView) ).multipliedBy(CONST.XEdge/640.0);
    }];
    
    
    UIButton * camera = [UIButton new];
    [_scrollView addSubview:camera];
    UIImage *img=[UIImage imageNamed:@"圆角矩形-27-拷贝-7" ];
    //camera.frame =CGRectMake(0, 0, img.size.width, img.size.height);
    [camera setBackgroundImage:img forState:UIControlStateNormal];
    [camera setTitle:@"照相机" forState:UIControlStateNormal];
    camera.showsTouchWhenHighlighted = YES;
    [camera addTarget:self action:@selector(cameraAction) forControlEvents:UIControlEventTouchUpInside];
    camera.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    
    [camera makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(picTitle);
        make.right.mas_equalTo(MasonryRight(_containerView)).multipliedBy( 515/640.0 );
        make.height.mas_equalTo(picTitle);
    }];
    
   

    
    picLine = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"矩形-9-拷贝-3"]];
    [_containerView addSubview:picLine];
    
    [picLine makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo( picTitle.bottom ).offset(CONST.ScaleYMiddle);
        make.left.mas_equalTo( MasonryRight(_containerView) ).multipliedBy(CONST.XEdge/640.0);
        make.right.mas_equalTo( MasonryRight(_containerView) ).multipliedBy(1-CONST.XEdge/640.0);
        make.height.equalTo(1);
    }];
}



-(void)setupState{
    ImageAttributedLabel * stateTitle = [[ImageAttributedLabel alloc]initWithImage:[UIImage imageNamed:@"形状-46"] andLabelText:[[NSAttributedString alloc ]initWithString:@"运单状态:"]];
    stateTitle.heightImage = CONST.kLineHeight;
    stateTitle.paddingLabel = CONST.ScaleXPaddingLabel;
    [stateTitle setUnderlineHidden:YES];
    [_containerView addSubview:stateTitle];
    
    [stateTitle makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(picLine).offset(CONST.ScaleYMiddle);
        make.left.mas_equalTo( MasonryRight(_containerView) ).multipliedBy(CONST.XEdge/640.0);
    }];
    UIFont * font = stateTitle.label.font;
    
//    _state = [UIButton new];
//    [_containerView addSubview:_state];
//    UIImage *img=[UIImage imageNamed:@"圆角矩形-27-拷贝-8" ];
//    [_state setBackgroundImage:img forState:UIControlStateNormal];
//    [_state setTitle:@"运送正常" forState:UIControlStateNormal];
//    [_state setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [_state addTarget:self action:@selector(stateAction) forControlEvents:UIControlEventTouchUpInside];
//    
//    _state.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    //_state.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
//    _state.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
//    
//    [_state makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.mas_equalTo(stateTitle);
//        make.left.mas_equalTo(stateTitle.right);
//        make.height.equalTo(stateTitle);
//        make.right.mas_equalTo(MasonryRight(_containerView)).multipliedBy( 515/640.0 );
//    }];
    
    _state = [UITextView new];
    _state.layer.cornerRadius = 6;
    _state.layer.masksToBounds = YES;
    _state.layer.borderColor = XYColor(83, 83, 83, 1).CGColor;
    _state.layer.borderWidth = 1.0;
    _state.font = font;
    [_containerView addSubview:_state];
    
        [_state makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(stateTitle.bottom).offset(CONST.ScaleYMiddle);
            make.left.mas_equalTo(stateTitle);
            make.centerX.mas_equalTo(_containerView);
            make.height.mas_equalTo( 3*CONST.kLineHeight );
        }];
    
    [background mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(_containerView);
        //make.top.mas_equalTo(MasonryBottom(_containerView)).multipliedBy(10/1136.0);
        //make.top.mas_equalTo( 10*ScaleY );
        make.top.mas_equalTo( CONST.ScaleYEdge );
        make.bottom.equalTo(_state.bottom).offset(CONST.ScaleYEdge);
        //make.bottom.equalTo(report.bottom).offset(PaddingEdge);
    }];

}

//-(void) setupConfirm{
//    WeakSelf
//    [weakSelf.view setNeedsDisplay];
//    [weakSelf.view layoutIfNeeded];
//
//    //NSLog( @"background:%@",NSStringFromCGRect( background.frame) );
//    
//         report = [UIButton new];
//        [_containerView addSubview:report];
//       // [_confirmButtons addObject:report];
//        report.tag = 11;
//        UIImage *img=[UIImage imageNamed:@"圆角矩形-27-拷贝-9" ];
//        [report setBackgroundImage:img forState:UIControlStateNormal];
//        [report setBackgroundImage:[UIImage imageNamed:@"圆角矩形-27-click-11" ] forState:UIControlStateHighlighted];
//        report.showsTouchWhenHighlighted = YES;
//    
//        [report setTitle:@"上报" forState:UIControlStateNormal];
//    
//                    //[report setTitle:@"结束运单" forState:UIControlStateNormal];
//
//        [report setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [report addTarget:self action:@selector(reportAction:) forControlEvents:UIControlEventTouchUpInside];
//
//
//
//        float edge = 48;
//        float middle = 48;
//        float width = (640.0 - 2*edge - 1*middle)/2;
//
//        [report makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(background.bottom).offset(20*ScaleX);
//            //make.top.equalTo(_state.bottom).offset(20*ScaleX);
//            make.left.equalTo( MasonryRight(_containerView) ).multipliedBy( (edge + 0*( middle+width ))/640.0 );
//            make.width.equalTo(MasonryWidth(_containerView)).multipliedBy( width/640.0 );
//            make.height.equalTo( report.width).multipliedBy( img.size.height/img.size.width );
//        }];
//    
//    UIButton *report2 = [UIButton new];
//    [_containerView addSubview:report2];
//    // [_confirmButtons addObject:report];
//    report2.tag = 11;
//    //UIImage *img=[UIImage imageNamed:@"圆角矩形-27-拷贝-9" ];
//    [report2 setBackgroundImage:img forState:UIControlStateNormal];
//    [report2 setBackgroundImage:[UIImage imageNamed:@"圆角矩形-27-click-11" ] forState:UIControlStateHighlighted];
//    report2.showsTouchWhenHighlighted = YES;
//    
//    //[report2 setTitle:@"上报" forState:UIControlStateNormal];
//    
//    [report2 setTitle:@"结束运单" forState:UIControlStateNormal];
//    
//    [report2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [report2 addTarget:self action:@selector(reportAction:) forControlEvents:UIControlEventTouchUpInside];
//
//    
//    [report2 makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(background.bottom).offset(20*ScaleX);
//        make.left.equalTo( MasonryRight(_containerView) ).multipliedBy( (edge + 1*( middle+width ))/640.0 );
//        make.width.equalTo(MasonryWidth(_containerView)).multipliedBy( width/640.0 );
//        make.height.equalTo( report.width).multipliedBy( img.size.height/img.size.width );
//    }];
//    
//        //report.frame = CGRectMake((edge + i*( middle+width ))*ScaleX, CGRectGetMaxY(background.frame)+20*ScaleX, width*ScaleX, width*ScaleX*img.size.height/img.size.width);
//
//
//

//
//    //[self resetScrollViewSize];
//     [self resetScrollViewSize];
////    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
////            [self resetScrollViewSize];
////    });
//
//
//}


-(void) setupConfirm{
    WeakSelf
    //[weakSelf.view setNeedsDisplay];
   // [weakSelf.view layoutIfNeeded];
    
    _confirmButtons = [NSMutableArray array];
    for( int i=0;i<2;i++ ){
        UIButton *report = [UIButton new];
        [_scrollView addSubview:report];
        [_confirmButtons addObject:report];
        report.tag = 10+i;
        UIImage *img=[UIImage imageNamed:@"圆角矩形-27-拷贝-9" ];
        [report setBackgroundImage:img forState:UIControlStateNormal];
        [report setBackgroundImage:[UIImage imageNamed:@"圆角矩形-27-click-11" ] forState:UIControlStateHighlighted];
        report.showsTouchWhenHighlighted = YES;
        if( i==0 ){
                    [report setTitle:@"上报" forState:UIControlStateNormal];
        }else{
                    [report setTitle:@"结束运单" forState:UIControlStateNormal];
        }
        [report setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [report addTarget:self action:@selector(reportAction:) forControlEvents:UIControlEventTouchUpInside];
//        report.userInteractionEnabled = YES;
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reportAction:)];
//        tap.delegate = self;
//        [report addGestureRecognizer:tap];
        NSLog(@"report:%@",report);
        
//        float edge = 48;
//        float middle = 48;
        float width = (640.0 - 2*CONST.XButtonsEdge - 1*CONST.XButtonsMiddle)/2;
        
        [report makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(background.bottom).offset(20*ScaleX);
            make.left.equalTo( MasonryRight(_containerView) ).multipliedBy( (CONST.XButtonsEdge + i*( CONST.XButtonsMiddle+width ))/640.0 );
            make.width.equalTo(MasonryWidth(_containerView)).multipliedBy( width/640.0 );
            make.height.equalTo( report.width).multipliedBy( img.size.height/img.size.width );
        }];
        //report.frame = CGRectMake((edge + i*( middle+width ))*ScaleX, CGRectGetMaxY(background.frame)+20*ScaleX, width*ScaleX, width*ScaleX*img.size.height/img.size.width);
    }
    
    [self.view setNeedsDisplay];
    [self.view layoutIfNeeded];
    
    //[self resetScrollViewSize];
     [self resetScrollViewSize];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self resetScrollViewSize];
//    });

    
}

-(void)cameraAction{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIImagePickerController * picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        picker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        //picker.allowsEditing = YES;  //是否可编辑
        //摄像头
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        //[self presentModalViewController:picker animated:YES];
        [self presentViewController:picker animated:YES completion:^{}];
    }else{
        //如果没有提示用户
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"你的设备不支持摄像" delegate:nil cancelButtonTitle:@"取消!" otherButtonTitles:nil];
//        [alert show];
        //[self showOneImage:[UIImage imageNamed:@"画板-1-拷贝-5"]];
        
        //http://img2.xxh.cc:8080/images/eschool/ZTT_1449029876979_image.png
        UIImageView * imgView = [UIImageView new];
        [self.view addSubview:imgView];
        [imgView setImageWithURL:[NSURL URLWithString:@"http://img2.xxh.cc:8080/images/eschool/ZTT_1449029876979_image.png"]  ];
       // [self showOneImage:imgView.image];
       // [self showAndSaveImage:imgView.image];
        [self imgShowToScrollView:[UIImage imageNamed:@"画板-1-拷贝-5"]];
        //[self removeLastImage];
    }
}



-(void)reportAction:(UIButton * )sender{
    tag = sender.tag-10;

//    _reportBlock = ^{
//
//    };

    
    [self uploadImagesAndReport];

}

-(void) startReport{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userName = [defaults valueForKey:@"username"];
    
    NSDictionary * dict= @{
                           @"username":userName,
                           @"eId":_model.staticInfo.eId,
                           @"location":_thisLoc,
                           @"lat":[NSString stringWithFormat:@"%lf",_loc2D.latitude],
                           @"lng":[NSString stringWithFormat:@"%lf",_loc2D.longitude],
                           @"tag":[NSString stringWithFormat:@"%d",tag],
                           @"logicStatus":_state.text,
                           @"imgs":_JSON_Images
                           };
    [self reportInfo:dict];
}

-( void )reportInfo:(NSDictionary* ) param {

    _hud.labelText = @"上报中";
    // http://10.18.3.98:10001/SalesWebTest/UploadLogicInformation
    NSString *urlAPI =  [URLBase stringByAppendingString: @"/UploadLogicInformation"];

    //http://10.18.3.98:10001/SalesWebTest/UploadLogicInformation?username=admin&eId=
    
    NSDictionary *parameters = param;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
//    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
//    //[requestSerializer setValue:@"html/text"forHTTPHeaderField:@"Content-Type"];
//    //[requestSerializer setValue:@"html/text"forHTTPHeaderField:@"Accept"];
//    [requestSerializer setValue:@"text/plain"forHTTPHeaderField:@"Content-Type"];
//    [requestSerializer setValue:@"text/plain"forHTTPHeaderField:@"Accept"];
//    manager.requestSerializer = requestSerializer;
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/json",@"text/plain", @"application/json",nil];//设置相应内容类型
    //manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager
     POST:urlAPI
     parameters:parameters
     success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [MBProgressHUD hideHUDForView:self.navigationController.view];
         NSLog(@"successObject: %@", responseObject);
         NSLog( @"requestString:%@",operation.responseString );
         if( [operation.responseString  isEqual:@"1"] ){
             [self reportCompletionWithSucess:YES];
             
         }else {
             [self reportCompletionWithSucess:NO];
             NSLog( @"上报失败：requestString:%@",operation.responseString );
         }

     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [MBProgressHUD hideHUDForView:self.navigationController.view];
         [self reportCompletionWithSucess:NO];
         NSLog(@"Error: %@", error);
     }
     ];

}

//-(void )uploadImagesAndReport3{
//    if( _images.count == 0 ){
//        _JSON_Images = @"[{\"imgurl\":\"\"}]";
//        //_reportBlock();
//        [self startReport];
//    }else{
//        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/json",@"text/plain", @"application/json" ,nil];  //添加ContentType识别text/plain，默认只识别text/json
//        
//        NSString *url = @"http://img2.xxh.cc:8080/AndroidUploadFileWeb/ESchoolImageUpload";
//        NSMutableArray *mutableOperations = [NSMutableArray array];
//        for( int i= 0;i<_images.count;i++ ){
//        NSMutableURLRequest* request =[[AFHTTPRequestSerializer serializer]multipartFormRequestWithMethod:@"POST" URLString:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//                UIImage * img = [self readImageWithName:_arrayImageName[i]];
//                [formData appendPartWithFileData:UIImagePNGRepresentation(img) name:_arrayImageName[i] fileName:_arrayImageName[i] mimeType:@"image/png"];
//        } error:nil];
//            AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//            [mutableOperations addObject:operation];
//        }
//        
//        NSArray *operations = [AFURLConnectionOperation batchOfRequestOperations:mutableOperations progressBlock:^(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations) {
//            
//        } completionBlock:^(NSArray *operations) {
//            //以下是处理返回结果
//            for(AFHTTPRequestOperation*operation in operations){
//                //NSDictionary*dict=[NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
//                NSLog(@"%@-----%@",operation.responseString,operation.responseObject);
//
//            }
//        }];
//        [manager.operationQueue addOperations:operations waitUntilFinished:NO];
//        //[[NSOperationQueue mainQueue] addOperations:operations waitUntilFinished:NO];
//        
//
//    }
//    
//}

-(void )uploadImagesAndReport2{
    

    if( _images.count == 0 ){
        _JSON_Images = @"[{\"imgurl\":\"\"}]";
        //_reportBlock();
        [self startReport];
    }else{
        _hud= [MBProgressHUD showMessage:@"上传图片中" toView:self.navigationController.view];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/json",@"text/plain", @"application/json" ,nil];  //添加ContentType识别text/plain，默认只识别text/json

        NSString *url = @"http://img2.xxh.cc:8080/AndroidUploadFileWeb/ESchoolImageUpload";

       NSMutableURLRequest* request =[[AFHTTPRequestSerializer serializer]multipartFormRequestWithMethod:@"POST" URLString:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                                               for( int i= 0;i<_images.count;i++ ){
                                                   UIImage * img = [self readImageWithName:_arrayImageName[i]];
                                                    [formData appendPartWithFileData:UIImagePNGRepresentation(img) name:_arrayImageName[i] fileName:_arrayImageName[i] mimeType:@"image/png"];
//                                                   UIImage* img = ((UIImageView*)_images[i]).image;
//                                                   [formData appendPartWithFileData:UIImagePNGRepresentation(img) name:@"image" fileName:@"upload.png" mimeType:@"image/png"];

                                               }
       } error:nil];
        
        AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"success. upload,%@", responseObject);
            
            _JSON_Images = operation.responseString;
            
            //[MBProgressHUD showSuccess:@"上传图片成功"];
            [self startReport];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            //[MBProgressHUD showError:@"上传图片失败"];
            NSLog(@"failure. upload....");
        }];
        [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            int percent = totalBytesWritten/(float)totalBytesExpectedToWrite*100;
            //NSLog(@"上传进度...%f",percent);
            _hud.labelText =  [NSString stringWithFormat:@"上传进度...%d%%",percent] ;
        }];
        [operation start];
        //[manager.operationQueue addOperation:operation];
    }

}

-(void )uploadImagesAndReport{
    if( _images.count == 0 ){
        _JSON_Images = @"[{\"imgurl\":\"\"}]";
        //_reportBlock();
        [self startReport];
    }else{
        _hud= [MBProgressHUD showMessage:@"上传图片中" toView:self.navigationController.view];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/json",@"text/plain", nil];  //添加ContentType识别text/plain，默认只识别text/json
        //NSDictionary *parameters = @{@"param": [@{@"filename": @"test"} toJsonString]};
        NSString *url = @"http://img2.xxh.cc:8080/AndroidUploadFileWeb/ESchoolImageUpload";
        
        AFHTTPRequestOperation *operation = [manager POST:url
                                               parameters:nil
                                constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                    for( int i= 0;i<_images.count;i++ ){
                                        UIImage * img = [self readImageWithName:_arrayImageName[i]];
                                        [formData appendPartWithFileData:UIImagePNGRepresentation(img) name:_arrayImageName[i] fileName:_arrayImageName[i] mimeType:@"image/png"];
                                    }
                                    
                                } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                    NSLog(@"%@-----%@",operation.responseString,responseObject);
                                    
                                    _JSON_Images = operation.responseString;
                                    //[MBProgressHUD showSuccess:@"上传图片成功"];
                                    [self startReport];
                                    // _reportBlock();

                                    
                                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                                    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"图片上传失败，请检查网络并重试" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//                                    [alert show];

                                    //[MBProgressHUD showError:@"上传图片失败"];
                                    NSLog(@"Error: %@ ***** %@", operation.responseString, error);
                                }];
        
        [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            int percent = totalBytesWritten/(float)totalBytesExpectedToWrite*100;
            //NSLog(@"上传进度...%f",percent);
            _hud.labelText =  [NSString stringWithFormat:@"上传进度...%d%%",percent] ;
        }];
        //[operation start];
    }
    
    
}


-(void) reportCompletionWithSucess:(BOOL)sucess{
    if( sucess ){
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"上报成功,感谢您的数据支持" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }else{
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"上报失败，请检查网络并重试" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }

}





//-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
//    double  altitude = newLocation.altitude;//高度
//    
//    double  latitude = newLocation.coordinate.latitude;
//    
//    double  longitude = newLocation.coordinate.longitude;
//    
//    CLGeocoder *geo = [[CLGeocoder alloc]init];
//    [geo reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
//        if( placemarks.count >0 ){
//            CLPlacemark * place = placemarks.firstObject;
//            
//            NSLog( @"%@,%@,%@,%@,%@,%@,%@,%@,",place.country,place.administrativeArea,place.subAdministrativeArea,place.locality,place.subLocality,place.thoroughfare,place.subThoroughfare,place.name );
//        }
//    }];
//}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if(!isLocated){
        if( locations && locations.count >0 ){
            CLLocation * currentLocation = [locations firstObject];
            
    //        double  altitude = currentLocation.altitude;//高度
    //        
    //        double  latitude = currentLocation.coordinate.latitude;
    //        
    //        double  longitude = currentLocation.coordinate.longitude;
            
                _loc2D = currentLocation.coordinate;

            
            CLGeocoder *geo = [[CLGeocoder alloc]init];
            [geo reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
                if( error ){
                    NSLog(@"Error: %@", error);
                }
                if(  placemarks && placemarks.count >0 ){
                    CLPlacemark * place = placemarks.firstObject;
                    NSDictionary * dict=place.addressDictionary;
    //                CLRegion *region = place.region;
    //                NSArray * arrayAll =@[place.ocean,place. place.country,place.administrativeArea,place.locality,place.subLocality,place.name];
    //                NSArray * array =@[place.country,place.administrativeArea,place.locality,place.subLocality,place.name];
    //                NSString * str =@"";
    //                for( int i=0; )
    //                NSString * addStr;


                   
                    //_thisLoc = [NSString stringWithFormat:@"%@%@%@%@,%@",place.country,place.administrativeArea,place.locality,place.subLocality,place.name];
                    [self resetLocation:((NSArray*)(dict[@"FormattedAddressLines"])).firstObject];
                    [_locationManager stopUpdatingLocation];
                     //[_activityView stopAnimating];
                }else{
                    
                }
            }];
            
        }
    }
    
}




- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"定位失败:%@",error);
    [_locationManager stopUpdatingLocation];
//    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"获取位置失败，请打开网络和定位功能" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if( tag == 0  ){
        [self backAction];
        ((DetailViewController *)self.navigationController.topViewController).needRefresh = YES;
    }else{
        ((ListTableviewController *)self.navigationController.viewControllers.firstObject).needRefresh =YES;
        [self.navigationController popToRootViewControllerAnimated:NO];

    }
   
}


- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image= [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    CGSize size = image.size;
    
    [self showAndSaveImage:image];

   // [self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
   // [self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:^{}];
}

+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    return newImage;
}


-(void)showAndSaveImage:(UIImage *)image{
   // UIImage *minImage;
   // self minSizeWithSize:minImage.size toFitSize:CGSizeMake(<#CGFloat width#>, <#CGFloat height#>) rotate:<#(BOOL)#>
//    CGSize size1 =  CGSizeMake(minLargeSide,minLargeSide*( image.size.height /image.size.width));
//    CGSize size2 =  CGSizeMake(minLargeSide*( image.size.width /image.size.height),minLargeSide);
//    CGSize size0 = image.size;
//    
//    if( size1.width <size2.width ){
//        if( size1.width < size0.width ){
//            minImage = [ReportViewController imageWithImageSimple:image scaledToSize:size1];
//        }else{
//            minImage = image;
//        }
//    }else{
//        if( size2.width < size0.width){
//            minImage = [ReportViewController imageWithImageSimple:image scaledToSize:size2];
//        }else{
//            minImage = image;
//        }
//    }

    
    UIImage *midImage = image;
//    float midMinSide = 480;
//    float midLargeSide = 640;
    CGSize fitSize;
    if( image.size.height >image.size.width ){
        fitSize= [self minSizeWithSize:image.size toFitSize:CGSizeMake(CONST.kMidImgSmallSide, CONST.kMidImgLargeSide) rotate:NO];
        
//        size1 =  CGSizeMake(midMinSide,midMinSide*( image.size.height /image.size.width));
//        size2 =  CGSizeMake(midLargeSide*( image.size.width /image.size.height),midLargeSide);
//        size0 = image.size;
//        
//        if( size1.width <size2.width ){
//            if( size1.width < size0.width ){
//                midImage = [ReportViewController imageWithImageSimple:image scaledToSize:size1];
//            }
//        }else{
//            if( size2.width < size0.width ){
//                midImage = [ReportViewController imageWithImageSimple:image scaledToSize:size2];
//            }
//        }
  
    }else{
     //旋转90度
        fitSize= [self minSizeWithSize:image.size toFitSize:CGSizeMake( CONST.kMidImgLargeSide,CONST.kMidImgSmallSide) rotate:NO];
//        size1 =  CGSizeMake(midMinSide*( image.size.width /image.size.height),midMinSide);
//        size2 =  CGSizeMake(midLargeSide,midLargeSide*( image.size.height /image.size.width));
//        size0 =  image.size;
//        
//        if( size1.width <size2.width ){
//            if( size1.width < size0.width ){
//                midImage = [ReportViewController imageWithImageSimple:image scaledToSize:size1];
//            }
//        }else{
//            if( size2.width < size0.width ){
//                midImage = [ReportViewController imageWithImageSimple:image scaledToSize:size2];
//            }
//        }
        
    }
    midImage = [ReportViewController imageWithImageSimple:image scaledToSize:fitSize];
    
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyyMMddHHmmss"];
    NSString *dateString = [[dateFormat stringFromDate:[NSDate date]]stringByAppendingString:@".png"];
    
    if( [self saveImage:midImage WithName:dateString]   ){
        
        //if([self showOneImage:minImage]){
            [self imgShowToScrollView:midImage];
            [_arrayImageName insertObject:dateString atIndex:_images.count-1];
//        }else{
//            [self deleteImageWithName:dateString];
//            [self recoverLastImageInfo];
//            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"照片显示失败" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//            [alert show];
//        }
        
    }else{
        [self deleteImageWithName:dateString];
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"照片保存失败,请检查内存卡空间" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }

}

- (BOOL)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName
{
    NSData* imageData = UIImagePNGRepresentation(tempImage);
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    // and then we write it out
    if( [imageData writeToFile:fullPath atomically:NO]) return  YES;
    else return NO;
}

- (BOOL)deleteImageWithName:(NSString *)imageName
{
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];

     NSFileManager *manager = [NSFileManager defaultManager];
    if( [manager fileExistsAtPath:fullPath] ){
     if([manager removeItemAtPath:fullPath error:nil]) return YES;
     else return NO;
    }else return YES;
}

- (UIImage*)readImageWithName:(NSString *)imageName
{
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];

    UIImage* image = [UIImage imageWithContentsOfFile:fullPath];
    return image;
}


//-( void ) showAllImages{
//    for( int i=0;i<_images.count;i++ ){
//        UIImage *image = [UIImage imageNamed:_arrayImageName[i] ];
//        UIImage *minImage;
//        CGSize size1 =  CGSizeMake(minLargeSide,minLargeSide*( image.size.height /image.size.width));
//        CGSize size2 =  CGSizeMake(minLargeSide*( image.size.width /image.size.height),minLargeSide);
//        
//        if( size1.width <size2.width ){
//            minImage = [ReportViewController imageWithImageSimple:image scaledToSize:size1];
//        }else{
//            minImage = [ReportViewController imageWithImageSimple:image scaledToSize:size2];
//        }
//        [self addOneImage:minImage];
//    }
//    if( _images.count !=0 ){
//        [self addImageChangeHeight];
//    }
//}


-(void)imgShowToScrollView:(UIImage *)tempImage{
    if( !_imgScrollView ){
        _imgScrollView = [UIScrollView new];
        _imgScrollView.directionalLockEnabled = YES;
        [_containerView addSubview:_imgScrollView];
        [_imgScrollView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(picTitle.bottom).offset(PaddingMiddle);
            make.left.equalTo(PaddingEdgeX);
            make.height.equalTo( CONST.ScaleXMinImgLargeSide +2*CONST.ScaleYMiddle );
            make.centerX.equalTo(_containerView);
        }];
        
        _imgContainerView = [[UIView alloc]init];
        [_imgScrollView addSubview:_imgContainerView];
        _imgContainerView.frame = CGRectMake(0, 0, self.view.frame.size.width-2*CONST.ScaleXEdge , CONST.ScaleXMinImgLargeSide +2*CONST.ScaleXMiddle);
        
        [picLine remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo( _imgScrollView.bottom ).offset(PaddingMiddle);
            make.left.mas_equalTo( MasonryRight(_containerView) ).multipliedBy(CONST.XEdge/640.0);
            make.right.mas_equalTo( MasonryRight(_containerView) ).multipliedBy(1-CONST.XEdge/640.0);
            make.height.equalTo(1);
        }];
        
        [self resetScrollViewSize];
        imgScrollX = 0;
        
        
    }
    
    int num = _images.count;
    //[self recordLastImageInfo];
    UIImageView * imageView = [[UIImageView alloc]initWithImage:tempImage];
    [_imgContainerView addSubview:imageView];
    imageView.tag = 10+num;
    [_images addObject:imageView];
    [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageDidTouch:)]];
    [imageView setUserInteractionEnabled:YES];
    
    CGSize size = tempImage.size;
    CGSize sizeFit;
    if(imgShowType == ImgShowTypeCenter){
        sizeFit = [self minSizeWithSize:size toFitSize:CGSizeMake(CONST.ScaleXMinImgLargeSide, CONST.ScaleXMinImgLargeSide) rotate:NO];
    }else if(imgShowType == ImgShowTypeExtention){
        sizeFit = CGSizeMake(CONST.ScaleXMinImgLargeSide*size.width/size.height,CONST.ScaleXMinImgLargeSide);
        
    }else if( imgShowType == ImgShowTypeSquare ){
        sizeFit = CGSizeMake(CONST.ScaleXMinImgLargeSide,CONST.ScaleXMinImgLargeSide );
    }
    
    [imageView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_imgContainerView);
        make.left.equalTo(_imgContainerView).offset(imgScrollX+CONST.ScaleXImgPadding);
        make.width.equalTo(sizeFit.width);
        make.height.equalTo( sizeFit.height );
    }];
    
    imgScrollX +=sizeFit.width +CONST.ScaleXImgPadding;
    _imgContainerView.frame = CGRectMake(0, 0, imgScrollX+ CONST.ScaleXImgPadding , _imgContainerView.frame.size.height);
    _imgScrollView.contentSize = _imgContainerView.frame.size;
    
    if( _imgScrollView.contentSize.width >_imgScrollView.frame.size.width ){
    _imgScrollView.contentOffset = CGPointMake(_imgScrollView.contentSize.width - _imgScrollView.frame.size.width, 0);
    }
    
}

//-(BOOL)showOneImage:(UIImage *)tempImage{
//    if( [self addOneImage:tempImage] ){
//        [self addImageChangeHeight];
//    }
//    return YES;
//}

//-(BOOL)addOneImage:(UIImage *)tempImage{
//    [self recordLastImageInfo];
//    float imageShowWidth  = ScreenW -2*PaddingEdgeX ;
//    int num = _images.count;
//    
//    CGPoint start;
//    
//    if( num == 0 ){
//        start = CGPointMake(PaddingEdgeX, CGRectGetMaxY(picTitle.frame)+ImgPadding);
//        
//    }else{
//        CGRect rect =( (UIImageView*)_images[num-1]).frame;
//        start = CGPointMake(CGRectGetMaxX(rect)+ImgPadding, CGRectGetMinY(rect));
//        if( start.x +tempImage.size.width > ScreenW -PaddingEdgeX ){
//            start  = CGPointMake(PaddingEdgeX, CGRectGetMaxY(picTitle.frame)+ImgSizeMax.height+ImgPadding);
//        }
//    }
//    
//    CGPoint offset = CGPointMake(start.x, start.y - CGRectGetMaxY(picTitle.frame));
//
//    UIImageView * imageView = [[UIImageView alloc]initWithImage:tempImage];
//    [_containerView addSubview:imageView];
//    imageView.tag = 10+num;
//    [_images addObject:imageView];
//    [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageDidTouch:)]];
//    [imageView setUserInteractionEnabled:YES];
//    
//    CGSize size = tempImage.size;
//    [imageView makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(picTitle.bottom).offset(offset.y);
//        make.left.equalTo(offset.x);
//        make.width.equalTo(size.width);
//        make.height.equalTo( size.height );
//    }];
//    
//    if( offset.x +tempImage.size.width >ImgSizeMax.width+1 ){
//        ImgSizeMax.width = offset.x +tempImage.size.width;
//    }
//    if( offset.y +tempImage.size.height  >ImgSizeMax.height  +1 ){
//        ImgSizeMax.height = offset.y +tempImage.size.height  ;
//        //是否改变图片最大显示高度
//        return true;
//    }else return false;
//}

-(void)recoverLastImageInfo{
    if( recordImgCount != _images.count){
        [self removeLastImage];
    }
}

-(void)recordLastImageInfo{
    recordImgCount = _images.count;
    recordImgSizeMax = ImgSizeMax;
}

-(void)removeLastImage{
    
    UIImageView* lastImg =_images[_images.count-1];
    if(lastImg){
        [lastImg removeFromSuperview];
        [_images removeLastObject];
    }
    
    ImgSizeMax = recordImgSizeMax;
    [self addImageChangeHeight];
    
}

-(void) addImageChangeHeight{
    [picLine remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo( picTitle.bottom ).offset( ImgSizeMax.height + PaddingMiddle);
        make.left.mas_equalTo( MasonryRight(_containerView) ).multipliedBy(28/640.0);
        make.right.mas_equalTo( MasonryRight(_containerView) ).multipliedBy(1-28/640.0);
        make.height.equalTo(1);
    }];

    
    [self resetScrollViewSize];

}



-(void)imageDidTouch:(UIGestureRecognizer*)sender{
    int index = sender.view.tag-10;
    NSString * name = _arrayImageName[index];
    UIImage * image =[self readImageWithName:name];
    ImageViewController * vc = [[ImageViewController alloc]initWithImage:image];
    
    [self presentViewController:vc animated:YES completion:^{    }];
}

-( CGSize ) minSizeWithSize:(CGSize)size toFitSize:(CGSize)fitSize rotate:(BOOL)rotate{
    
    CGSize size0;
    CGSize size1;
    CGSize size2;
    
    if( !rotate ){
        size1 =  CGSizeMake(fitSize.width,fitSize.width*( size.height /size.width));
        size2 =  CGSizeMake(fitSize.height*( size.width /size.height),fitSize.height);
        size0 = size;
        
        if( size1.width <size2.width ){
            if( size1.width < size0.width ){
                return size1;
            }
            else{
                return size0;
            }
        }else{
            if( size2.width < size0.width ){
                return size2;
            }else{
                return size0;
            }
        }
        
    }else{
        //旋转90度
        size1 =  CGSizeMake(fitSize.width*( size.width /size.height),fitSize.width);
        size2 =  CGSizeMake(fitSize.height,fitSize.height*( size.height /size.width));
        size0 =  size;
        
        if( size1.width <size2.width ){
            if( size1.width < size0.width ){
                return size1;
            }else{
                return size0;
            }
        }else{
            if( size2.width < size0.width ){
                return size2;
            }
            else{
                return size0;
            }
        }
        
    }

}

@end
