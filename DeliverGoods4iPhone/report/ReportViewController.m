
#import "Prefix.h"
#import "ReportViewController.h"
#import "ImageLabel.h"
//#import "ImageLabelLine2.h"
#import "ImageViewController.h"
#import "AFNetworking.h"
#import "Constant.h"
#import <AMapLocationKit/AMapLocationKit.h>

//static  CLLocationManager* _locationManager;

static float  PaddingEdge = 5;
static float PaddingMiddle =2;
static float PaddingLabel =10;
static float LineHeight  =25;
static float LineSpace =0;
float ImgLargeSide = 150;
static CGSize ImgSizeMax;
static float ImgPadding = 8;
static float PaddingEdgeX;

@interface ReportViewController (){
    float fontSize ;
    ImageLabel* picTitle;
    UIImageView* locLine;
    UIImageView* picLine;
    UIImageView *background;
    ImageLabel * locTitle;
    UILabel * locContent;
    //CLLocationManager* locationManager;
    BOOL isLocated;
    BOOL  keyboardVisible;
    int tag;
}

@property (strong,nonatomic) CLLocationManager* locationManager;
@property (strong,nonatomic) AMapLocationManager* AMapLocMgr;
@property (strong,nonatomic) UIScrollView * scrollView;
@property (strong,nonatomic) UIView * containerView;
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
@end

@implementation ReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.touchDismissKeyboardEnabled = YES;
    self.scrollToVisibleEnabled = YES;
    
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
        //_containerView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);

        
//        NSLog( @"selfview:%@",NSStringFromCGRect(self.view.frame) );
//        NSLog( @"scroll:%@",NSStringFromCGRect(_scrollView.frame) );
//        NSLog( @"container:%@",NSStringFromCGRect(_containerView.frame) );

        
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
    
    _containerView.frame = CGRectMake(0,0 , ScreenW, CGRectGetMaxY(((UIButton*)_confirmButtons[0]).frame)+ PaddingEdge*ScaleY);
    _scrollView.contentSize = CGSizeMake( ScreenW, CGRectGetMaxY(((UIButton*)_confirmButtons[0]).frame)+ PaddingEdge*ScaleY );
    
    NSLog( @"container:%@",NSStringFromCGRect(_containerView.frame) );
    NSLog( @"scroll:%@",NSStringFromCGRect(_scrollView.frame) );
    NSLog( @"scrollSize:%@",NSStringFromCGSize(_scrollView.contentSize) );
}

-(void)setupLocation{
    
    
    locTitle = [[ImageLabel alloc]initWithImage:[UIImage imageNamed:@"形状-42"] andLabelText:@"当前位置:"];
    locTitle.heightImage = 25;
    locTitle.paddingLabel = PaddingLabel;
    [locTitle setUnderlineHidden:YES];
   // locTitle.layer.borderColor = [[UIColor blackColor]CGColor];
    //locTitle.layer.borderWidth = 2;
    [_containerView addSubview:locTitle];
    
    
    
    if( !_thisLoc  ){
        _thisLoc = @"暂未获取到位置信息";
    }
    fontSize = locTitle.label.font.pointSize;
    
    locContent = [UILabel new];
    locContent.numberOfLines = 0;
    locContent.lineBreakMode = NSLineBreakByWordWrapping;
    //locContent.layer.borderColor = [[UIColor redColor]CGColor];
    //locContent.layer.borderWidth = 2;
    locContent.text = _thisLoc;
    locContent.font = [UIFont fontWithName:nil size:fontSize];
    [_containerView addSubview:locContent];
    
//    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
//    style.lineSpacing = LineSpace;
//    style.alignment = NSTextAlignmentLeft;
//    style.lineBreakMode = NSLineBreakByWordWrapping;
//    
//    NSDictionary * dict=@{
//                          NSFontAttributeName:[UIFont fontWithName:nil size:fontSize],
//                          NSForegroundColorAttributeName:[UIColor blackColor],
//                          NSParagraphStyleAttributeName:style
//                          };

//    NSAttributedString * attStr = [[NSAttributedString alloc]initWithString: _thisLoc attributes:dict];
//    locContent.attributedText = attStr;

    
    locLine = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"矩形-9-拷贝-3"]];
    [_containerView addSubview:locLine];
    
    [locTitle makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_containerView).offset(PaddingEdge);
        make.left.mas_equalTo( MasonryRight(_containerView) ).multipliedBy(PaddingEdgeX/ScaleX/640.0);
    }];
    
    //[locTitle setNeedsLayout];
    //[locTitle layoutIfNeeded];
    
        NSDictionary * dict=@{
                              NSFontAttributeName:[UIFont fontWithName:nil size:fontSize],
                              };
//     CGSize size =  [attStr boundingRectWithSize:CGSizeMake(ScreenW - CGRectGetMaxX(locTitle.frame) -PaddingEdgeX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading context:nil].size;
//    CGSize labelSize  = [locContent.text boundingRectWithSize:CGSizeMake( ScreenW - CGRectGetMaxX(locTitle.frame) -PaddingEdgeX , CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
//                                        attributes:dict context:nil].size;
    
    [locContent makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(locTitle.right);
        make.top.mas_equalTo(locTitle.top);
        //make.centerY.mas_equalTo(locTitle.top);
        make.right.mas_equalTo( MasonryRight(_containerView) ).multipliedBy(1-28/640.0);
        //make.width.mas_equalTo(labelSize.width);
        //make.height.mas_equalTo(labelSize.height+16);
    }];
    
  //  [locContent setNeedsLayout];
   // [locContent layoutIfNeeded];
    

    
//    locTitle.frame = CGRectMake(28*ScaleX, PaddingEdge, locTitle.bounds.size.width, locTitle.bounds.size.height);
//    float contentWidth = ScreenW - CGRectGetMaxX(locTitle.frame) - 28*ScaleX;
//    CGSize contentSize = [attStr boundingRectWithSize:CGSizeMake(contentWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
//                                              context:nil].size;
//    locContent.frame = CGRectMake(CGRectGetMaxX(locTitle.frame), PaddingEdge, contentSize.width, contentSize.height);
//    
    NSLog(@"loctitle%@",NSStringFromCGRect(locTitle.frame));
    NSLog(@"loccontent%@",NSStringFromCGRect(locContent.frame));
    
    [locLine makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo( locContent.bottom ).offset(PaddingMiddle);
        make.left.mas_equalTo( MasonryRight(_containerView) ).multipliedBy(PaddingEdgeX/ScaleX/640.0);
        make.right.mas_equalTo( MasonryRight(_containerView) ).multipliedBy(1-PaddingEdgeX/ScaleX/640.0);
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
                
                _thisLoc = regeocode.formattedAddress;
                [self resetLocation:_thisLoc];
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
    
    locContent.text = newLocation;
    _thisLoc = newLocation;
//    [locContent remakeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(locTitle.right);
//        make.top.mas_equalTo(locTitle.top);
//        //make.centerY.mas_equalTo(locTitle.top);
//        make.right.mas_equalTo( MasonryRight(_containerView) ).multipliedBy(1-28/640.0);
//        //make.width.mas_equalTo(labelSize.width);
//        //make.height.mas_equalTo(labelSize.height+16);
//    }];
    
    [self resetScrollViewSize];
    
    isLocated = YES;
    [_locationManager stopUpdatingLocation];
    
}

-(void)setupPic{
    
    picTitle = [[ImageLabel alloc]initWithImage:[UIImage imageNamed:@"形状-45"] andLabelText:@"拍照:"];
    picTitle.heightImage = 25;
    picTitle.paddingLabel = PaddingLabel;
    [picTitle setUnderlineHidden:YES];
    [_containerView addSubview:picTitle];
    [picTitle makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(locLine).offset(PaddingMiddle);
        make.left.mas_equalTo( MasonryRight(_containerView) ).multipliedBy(PaddingEdgeX/ScaleX/640.0);
    }];
    
    
    UIButton * camera = [UIButton new];
    [_containerView addSubview:camera];
    UIImage *img=[UIImage imageNamed:@"圆角矩形-27-拷贝-7" ];
    //camera.frame =CGRectMake(0, 0, img.size.width, img.size.height);
    [camera setBackgroundImage:img forState:UIControlStateNormal];
    [camera setTitle:@"camera" forState:UIControlStateNormal];
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
        make.top.mas_equalTo( picTitle.bottom ).offset(PaddingMiddle);
        make.left.mas_equalTo( MasonryRight(_containerView) ).multipliedBy(PaddingEdgeX/ScaleX/640.0);
        make.right.mas_equalTo( MasonryRight(_containerView) ).multipliedBy(1-PaddingEdgeX/ScaleX/640.0);
        make.height.equalTo(1);
    }];
}



-(void)setupState{
    ImageLabel * stateTitle = [[ImageLabel alloc]initWithImage:[UIImage imageNamed:@"形状-46"] andLabelText:@"运单状态:"];
    stateTitle.heightImage = 25;
    stateTitle.paddingLabel = PaddingLabel;
    [stateTitle setUnderlineHidden:YES];
    [_containerView addSubview:stateTitle];
    
    [stateTitle makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(picLine).offset(PaddingMiddle);
        make.left.mas_equalTo( MasonryRight(_containerView) ).multipliedBy(PaddingEdgeX/ScaleX/640.0);
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
            make.top.mas_equalTo(stateTitle.bottom).offset(PaddingMiddle);
            make.left.mas_equalTo(stateTitle);
            make.centerX.mas_equalTo(_containerView);
            make.height.mas_equalTo( 3*LineHeight );
        }];
    
    [background mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(_containerView);
        //make.top.mas_equalTo(MasonryBottom(_containerView)).multipliedBy(10/1136.0);
        //make.top.mas_equalTo( 10*ScaleY );
        make.top.mas_equalTo( PaddingEdge );
        make.bottom.equalTo(_state.bottom).offset(PaddingEdge);
    }];

}

-(void) setupConfirm{
    WeakSelf
    [weakSelf.view setNeedsDisplay];
    [weakSelf.view layoutIfNeeded];
    
    _confirmButtons = [NSMutableArray array];
    for( int i=0;i<2;i++ ){
        UIButton *report = [UIButton new];
        [_containerView addSubview:report];
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
        
        float edge = 48;
        float middle = 48;
        float width = (640.0 - 2*edge - 1*middle)/2;
        
        [report makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(background.bottom).offset(20*ScaleX);
            make.left.equalTo( MasonryRight(_containerView) ).multipliedBy( (edge + i*( middle+width ))/640.0 );
            make.width.equalTo(MasonryWidth(_containerView)).multipliedBy( width/640.0 );
            make.height.equalTo( report.width).multipliedBy( img.size.height/img.size.width );
        }];
        //report.frame = CGRectMake((edge + i*( middle+width ))*ScaleX, CGRectGetMaxY(background.frame)+20*ScaleX, width*ScaleX, width*ScaleX*img.size.height/img.size.width);
    }
    
    [self resetScrollViewSize];
    
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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"你的设备不支持摄像" delegate:nil cancelButtonTitle:@"取消!" otherButtonTitles:nil];
        [alert show];
        //[self showOneImage:[UIImage imageNamed:@"画板-1-拷贝-5"]];
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
         [self reportCompletionWithSucess:NO];
         NSLog(@"Error: %@", error);
     }
     ];

}

-(void )uploadImagesAndReport{
    if( _images.count == 0 ){
        _JSON_Images = @"[{\"imgurl\":\"\"}]";
        //_reportBlock();
        [self startReport];
    }else{
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
                                    
                                    [self startReport];
                                    // _reportBlock();

                                    
                                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"图片上传失败，请检查网络并重试" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                    [alert show];
                                    NSLog(@"Error: %@ ***** %@", operation.responseString, error);
                                }];
        [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            CGFloat percent = totalBytesWritten/(float)totalBytesExpectedToWrite;
            NSLog(@"上传进度...%f",percent);
        }];
        [operation start];
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
    

    _scrollView.frame = CGRectMake(0, 0, _scrollView.frame.size.width, _scrollView.frame.size.height-keyboardHeight);

    CGRect rectF = (firstResponder.frame);
    CGRect rectConvert = [firstResponder convertRect:rectF toView:nil];
    
    float heightMax = CGRectGetMaxY(rectF);
    
    float keyboardTop = CGRectGetMinY(rect);

    if( heightMax >keyboardTop )
    {

        [_scrollView scrollRectToVisible:rectF animated:YES];

    }
    
    
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
    

    _scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);

    _scrollView.contentOffset = CGPointZero;

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


                    _thisLoc = ((NSArray*)(dict[@"FormattedAddressLines"])).firstObject;
                    //_thisLoc = [NSString stringWithFormat:@"%@%@%@%@,%@",place.country,place.administrativeArea,place.locality,place.subLocality,place.name];
                    [self resetLocation:_thisLoc];
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
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"获取位置失败，请打开网络和定位功能" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
        [self backAction];
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
    UIImage *minImage;
    CGSize size1 =  CGSizeMake(ImgLargeSide,ImgLargeSide*( image.size.height /image.size.width));
    CGSize size2 =  CGSizeMake(ImgLargeSide*( image.size.width /image.size.height),ImgLargeSide);
    CGSize size0 = image.size;
    
    if( size1.width <size2.width ){
        if( size1.width < size0.width ){
            minImage = [ReportViewController imageWithImageSimple:image scaledToSize:size1];
        }else{
            minImage = image;
        }
    }else{
        if( size2.width < size0.width){
            minImage = [ReportViewController imageWithImageSimple:image scaledToSize:size2];
        }else{
            minImage = image;
        }
    }

    
    UIImage *midImage = image;
    float midMinSide = ScreenW;
    if( image.size.height >image.size.width ){
        size1 =  CGSizeMake(ScreenW,ScreenW*( image.size.height /image.size.width));
        size2 =  CGSizeMake(ScreenH*( image.size.width /image.size.height),ScreenH);
        size0 = image.size;
        
        if( size1.width <size2.width ){
            if( size1.width < size0.width ){
                midImage = [ReportViewController imageWithImageSimple:image scaledToSize:size1];
            }
        }else{
            if( size2.width < size0.width ){
                midImage = [ReportViewController imageWithImageSimple:image scaledToSize:size2];
            }
        }
  
    }else{
     //旋转90度
        size1 =  CGSizeMake(ScreenW*( image.size.width /image.size.height),ScreenW);
        size2 =  CGSizeMake(ScreenH,ScreenH*( image.size.height /image.size.width));
        size0 =  image.size;
        
        if( size1.width <size2.width ){
            if( size1.width < size0.width ){
                midImage = [ReportViewController imageWithImageSimple:image scaledToSize:size1];
            }
        }else{
            if( size2.width < size0.width ){
                midImage = [ReportViewController imageWithImageSimple:image scaledToSize:size2];
            }
        }
        
    }
    
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyyMMddHHmmss"];
    NSString *dateString = [[dateFormat stringFromDate:[NSDate date]]stringByAppendingString:@".png"];
    
    if( [self saveImage:midImage WithName:dateString]   ){
        
        [self showOneImage:minImage];
        [_arrayImageName insertObject:dateString atIndex:_images.count-1];
        
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


-( void ) showAllImages{
    for( int i=0;i<_images.count;i++ ){
        UIImage *image = [UIImage imageNamed:_arrayImageName[i] ];
        UIImage *minImage;
        CGSize size1 =  CGSizeMake(ImgLargeSide,ImgLargeSide*( image.size.height /image.size.width));
        CGSize size2 =  CGSizeMake(ImgLargeSide*( image.size.width /image.size.height),ImgLargeSide);
        
        if( size1.width <size2.width ){
            minImage = [ReportViewController imageWithImageSimple:image scaledToSize:size1];
        }else{
            minImage = [ReportViewController imageWithImageSimple:image scaledToSize:size2];
        }
        [self addOneImage:minImage];
    }
    if( _images.count !=0 ){
        [self addImageChangeHeight];
    }
}



-(void)showOneImage:(UIImage *)tempImage{
    if( [self addOneImage:tempImage] ){
        [self addImageChangeHeight];
    }
}

-(BOOL)addOneImage:(UIImage *)tempImage{
    float imageShowWidth  = ScreenW -2*PaddingEdgeX ;
    int num = _images.count;
    
    CGPoint start;
    
    if( num == 0 ){
        start = CGPointMake(PaddingEdgeX, CGRectGetMaxY(picTitle.frame)+ImgPadding);
        
    }else{
        CGRect rect =( (UIImageView*)_images[num-1]).frame;
        start = CGPointMake(CGRectGetMaxX(rect)+ImgPadding, CGRectGetMinY(rect));
        if( start.x +tempImage.size.width > ScreenW -PaddingEdgeX ){
            start  = CGPointMake(PaddingEdgeX, CGRectGetMaxY(picTitle.frame)+ImgSizeMax.height+ImgPadding);
            
        }
    }
    
    CGPoint offset = CGPointMake(start.x, start.y - CGRectGetMaxY(picTitle.frame));

    UIImageView * imageView = [[UIImageView alloc]initWithImage:tempImage];
    [_containerView addSubview:imageView];
    imageView.tag = 10+num;
    [_images addObject:imageView];
    [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageDidTouch:)]];
    [imageView setUserInteractionEnabled:YES];
    
    CGSize size = tempImage.size;
    [imageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(picTitle.bottom).offset(offset.y);
        make.left.equalTo(offset.x);
        make.width.equalTo(size.width);
        make.height.equalTo( size.height );
    }];
    
    if( offset.x +tempImage.size.width >ImgSizeMax.width+1 ){
        ImgSizeMax.width = offset.x +tempImage.size.width;
    }
    if( offset.y +tempImage.size.height  >ImgSizeMax.height  +1 ){
        ImgSizeMax.height = offset.y +tempImage.size.height  ;
        //是否改变图片最大显示高度
        return true;
    }else return false;
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



@end
