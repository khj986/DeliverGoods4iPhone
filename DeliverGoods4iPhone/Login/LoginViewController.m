
#import "Prefix.h"
#import "LoginViewController.h"
#import "ListTableViewController.h"
#import "LeftSortsViewController.h"
#import "AppDelegate.h"
//#import "TitleContentLine.h"
#import "FlowLine.h"
#import "ImageLabel.h"
//#import "ImageLabelLine2.h"
#import "AFNetworking.h"

#import "NSString+MD5.h"
//#import "NetConnect.h"


@interface LoginViewController (){
    BOOL  keyboardVisible;
    CGAffineTransform contentTransformOrigin;
}
@property (strong,nonatomic) UIScrollView * scrollView;
@property (strong,nonatomic) UIView * containerView;
@property (strong, nonatomic) UITextField *accountField;
@property (strong, nonatomic) UITextField *passwordField;
@property (strong, nonatomic) UIButton *loginBtn;
@property (strong, nonatomic) UIImageView *bgImageView;

//@property (strong, nonatomic) UITextField *accountField;
//@property (strong, nonatomic) LoginTextField *passwordField;
//@property (strong, nonatomic) UIButton *loginBtn;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.touchDismissKeyboardEnabled = YES;
    self.scrollToVisibleEnabled = YES;
    
    self.navigationController.navigationBarHidden = YES;
    keyboardVisible = NO;
    //self.edgesForExtendedLayout = UIRectEdgeAll;
    
    __weak __typeof(self) weakself = self;

    
    _scrollView = [[UIScrollView alloc]init];
    _scrollView.directionalLockEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    _containerView = [[UIView alloc]init];
    [_scrollView addSubview:_containerView];
    _scrollView.contentSize = self.view.frame.size;
    
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakself.view);
        //make.width.height.mas_equalTo(weakself.view);
        //make.top.bottom.left.right.mas_equalTo(weakself.view);
    }];
    [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_scrollView);
        make.width.height.mas_equalTo(weakself.view);

    }];
    
   
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"矩形-1-拷贝-3"]];
    [_containerView addSubview:bgImageView];
    //[bgImageView setImage:[UIImage imageNamed:@"mask"]];
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_containerView);
        //make.width.height.equalTo(weakself.view);
        //make.bottom.equalTo(MasonryBottom(_containerView)).multipliedBy(0.33);
    }];
    _bgImageView = bgImageView;

    
    
    //输入框
    UIView * containerField = [[UIView alloc]init];
    [_containerView addSubview:containerField];
    
    _accountField = [[UITextField alloc] init];
    _accountField.placeholder = @"账号";
    _accountField.tag = 1;
    [containerField addSubview:_accountField];
    

    UIImageView *accountImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"形状-30"]];
    [containerField addSubview:accountImage];

    //UIImageView *baseLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"underline---input"]];
    UIView * baseLine = [UIView new];
    baseLine.backgroundColor = XYColor(236, 236, 236, 1);
    [containerField addSubview:baseLine];
    
    //输入框约束
    
    [accountImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(MasonryRight(_containerView)).multipliedBy(92/640.0);
        make.width.height.mas_equalTo(MasonryWidth(_containerView)).multipliedBy(38/640.0);
    }];

    [_accountField mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.width.mas_equalTo(MasonryWidth(_containerView)).multipliedBy(410/640.0);
        make.height.mas_equalTo(accountImage);
        //make.left.mas_equalTo(accountImage.right).offset(20);
        make.left.mas_equalTo(MasonryRight(_containerView)).multipliedBy((92+38+32)/640.0);
    }];
    
    [baseLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(containerField);
        //make.top.equalTo(_accountField.bottom).offset(10);
        //make.top.equalTo(MasonryBottom).multipliedBy(0.42);
        make.height.equalTo(1);
    }];
    
    [containerField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(MasonryBottom(_containerView)).multipliedBy((44+108+166+40+40+120)/1136.0);
        make.centerX.mas_equalTo(_containerView);
        make.top.mas_equalTo(@[_accountField,accountImage]);
        make.bottom.mas_equalTo(baseLine);
        make.left.mas_equalTo(accountImage);
        make.right.mas_equalTo(_accountField);
        make.height.mas_equalTo(MasonryHeight(_containerView)).multipliedBy(60/1136.0);
    }];
    

    //输入框
    UIView * containerField2 = [[UIView alloc]init];
    [_containerView addSubview:containerField2];
    
    _passwordField = [[UITextField alloc] init];
    _passwordField.placeholder = @"密码";
    [_passwordField setSecureTextEntry:YES];
    _passwordField.tag = 2;
    [containerField2 addSubview:_passwordField];
    
    
    UIImageView *passwordImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"形状-31"]];
    [containerField2 addSubview:passwordImage];
    
    //UIImageView *baseLine2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"underline---input"]];
    UIView * baseLine2 = [UIView new];
    baseLine2.backgroundColor = XYColor(236, 236, 236, 1);
    [containerField2 addSubview:baseLine2];
    
    //输入框约束
    
    [passwordImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(MasonryRight(_containerView)).multipliedBy(92/640.0);
        make.width.height.mas_equalTo(MasonryWidth(_containerView)).multipliedBy(38/640.0);
    }];
    
    [_passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.width.mas_equalTo(MasonryWidth(_containerView)).multipliedBy(410/640.0);
        make.height.mas_equalTo(accountImage);
        //make.left.mas_equalTo(accountImage.right).offset(20);
        make.left.mas_equalTo(MasonryRight(_containerView)).multipliedBy((92+38+32)/640.0);
    }];
    
    [baseLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(containerField2);
       // make.top.equalTo(_passwordField.bottom).offset(10);
        make.height.equalTo(1);
    }];
    
    [containerField2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(MasonryBottom(_containerView)).multipliedBy((44+108+166+40+40+120+110)/1136.0);
        make.centerX.mas_equalTo(_containerView);
        make.top.mas_equalTo(@[_passwordField,passwordImage]);
        make.bottom.mas_equalTo(baseLine2);
        make.left.mas_equalTo(passwordImage);
        make.right.mas_equalTo(_passwordField);
        make.height.mas_equalTo(MasonryHeight(_containerView)).multipliedBy(60/1136.0);
    }];
    

    
    _loginBtn = [[UIButton alloc] init];
    _loginBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [_loginBtn addTarget:self action:@selector(clickedLoginButton) forControlEvents:UIControlEventTouchUpInside];
    _loginBtn.showsTouchWhenHighlighted = YES;
    [_containerView addSubview:_loginBtn];
    [_loginBtn setBackgroundImage:[UIImage imageNamed:@"button-拷贝"] forState:UIControlStateNormal];
    //[_loginBtn setBackgroundImage:[UIImage imageNamed:@"button"] forState:UIControlStateHighlighted];
    [_loginBtn.layer setCornerRadius:5];//设置矩形四个圆角半径
    
    [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(containerField2);
        make.height.mas_equalTo(MasonryHeight(_containerView)).multipliedBy(80/1136.0);

        make.top.mas_equalTo(MasonryBottom(_containerView)).multipliedBy((44+108+166+40+40+120+110+60+70)/1136.0);
    }];
    
    
    UILabel * label = [[UILabel alloc]init];

    [_containerView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_containerView);
        make.top.mas_equalTo(MasonryBottom(_containerView)).multipliedBy((44+108+166+40)/1136.0);
        make.width.mas_equalTo(_containerView);
        make.height.mas_equalTo(MasonryHeight(_containerView)).multipliedBy(40/1136.0);
    }];
    
    [label setNeedsDisplay];
    [label layoutIfNeeded];
    
    label.text = @"江东物流易配货";
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:nil size:[label.text fontSizeSingleLineFitsRect:label.frame attributes:nil]];
    label.textAlignment = NSTextAlignmentCenter;
    
    UIImageView * imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo"]];
    [_containerView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_containerView);
        make.top.mas_equalTo(MasonryBottom(_containerView)).multipliedBy((44+108)/1136.0);
        make.width.height.mas_equalTo(MasonryWidth(_containerView)).multipliedBy(166/640.0);
    }];

    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userName = [defaults valueForKey:@"username"];
    NSString *password = [defaults valueForKey:@"password"];
    if (userName.length && password.length){
        NSDictionary * dict = @{@"username":userName,
                                @"password":password
                                };
        [self login:dict];
    }
    
    //ListCellLine * line = [[ListCellLine alloc]initWithImage:[UIImage imageNamed:@"形状-31"] andLabelText:@"货物： 电缆"];
   // TitleContentLine * line = [[TitleContentLine alloc]initTitle:@"货物:" andContent:@"电缆" withHeight:40];
//    FlowLine* line  = [[FlowLine alloc]initTime:@"2015/10/10 8:00" andContent:@"行政，星座ZTT\n光伏壳开发	IOS端欢迎界面停留时间加长\n光伏壳开发	IOS端欢迎界面停留时间加长行政，星座ZTT\n光伏壳开发	IOS端欢迎界面停留时间加长\n光伏壳开发	IOS端欢迎界面停" withFontHeight:20];
//    [_containerView addSubview:line];
//    //line.frame = CGRectMake(0, 0, 320,40);
//    [line mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(200);
//        //make.left.equalTo(100);
////        make.width.equalTo(414);
////        make.height.equalTo(60);
//    }];
    
//    [line setUnderlineHidden:YES];
//    UILabel *_time = [[UILabel alloc]init];
//    _time.numberOfLines = 0;
//    _time.text = @"2015\n123456";
//    _time.textAlignment = NSTextAlignmentCenter;
//    _time.textColor = [UIColor blackColor];
//    //float fontSize = [time fontSizeSingleLineFitsHeight:height attributes:nil];
//    //_time.font = [UIFont fontWithName:nil size:fontSize];
//    [self.view addSubview:_time];
//    [_time makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(0);
//        make.left.equalTo(0);
//    }];
    
//    UIView * view = [UIView new];
//    view.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:view];
//    [view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(0);
//        make.left.equalTo(0);
//        make.width.equalTo(320);
//        make.height.equalTo(60);
//    }];
//    
//    locTitle = [[ImageLabelLine alloc]initWithImage:[UIImage imageNamed:@"形状-42"] andLabelText:@"当前位置:"];
//    [locTitle setUnderlineHidden:YES];
//    [view addSubview:locTitle];
//    
//    [locTitle mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.top.equalTo(0);
//                make.left.equalTo(0);
//                //make.width.equalTo(320);
//                make.height.equalTo(60);
//    }];
//    
//    
//    
//    [locTitle resetPaddingLabel:40];
    
//    ImageLabelLine2 * line= [[ImageLabelLine2 alloc]initWithImage:[UIImage imageNamed:@"形状-30"] andLabelText:@"当前位置:" setHeightImage:50 heightUnderline:1 paddingImage:0 paddingLabel:0 paddingUnderline:0];
//    [self.view addSubview:line];
//     NSLog(@"self5%@",NSStringFromCGRect(line.frame));
//    [line mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(0);
////        make.width.equalTo(line.frame.size.width*2);
////        make.height.equalTo(line.frame.size.height*2);
//    }];
//     [line setPaddingImage:20];
//     NSLog(@"self6%@",NSStringFromCGRect(line.frame));
//    //line.frame = CGRectMake(0, 0, line.frame.size.width, line.frame.size.height);
//    [self.view setNeedsLayout];
//    [self.view layoutIfNeeded];
//     NSLog(@"self7%@",NSStringFromCGRect(line.frame));
//    
//    [line setPaddingImage:20];
}


-(void)login:( NSDictionary *)param{
    
    //NSString *urlAPI = @"http://10.18.3.98:10001/SalesWebTest/UserLogin";
    NSString *urlAPI =  [URLBase stringByAppendingString: @"/UserLogin"];
    // NSString *urlAPI = @"http://www.baidu.com";
    NSDictionary *parameters = param;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/json",@"text/plain", @"application/json",nil];//设置相应内容类型
    //manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager
     POST:urlAPI
     parameters:parameters
     success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"JSON: %@", responseObject);

         [self setUpRootController];
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
     }
     ];
//    NSString *para = [NSString stringWithFormat:@"username=%@&password=%@", param[@"username"],param[@"password"]];
//    [NetConnect connectWithUrl:urlAPI param:para timeoutInterval:10 complete:^(id result) {
//        NSLog(@"请求成功");
//        NSLog(@"sucess:%@",result);
////        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
////        NSLog(@"dict --- %@========", dict);
////        if (dict) {
////
////            
////            
////        }
//    } error:^(id result) {
//
//        NSLog(@"请求出错");
//        NSLog(@"error:%@",result);
//    }];


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
    
    [_scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view).offset(-keyboardHeight);
    }];
    
    
    // 修改下边距约束
    CGRect rectF = (firstResponder.frame);
    CGRect rectConvert = [firstResponder.superview convertRect:rectF toView:nil];

    float heightMax = CGRectGetMaxY(rectConvert);
    
    float keyboardTop = CGRectGetMinY(rect);

    if( heightMax >keyboardTop ){
        [_containerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(self.view).offset( -(heightMax-keyboardTop) );
        }];
    }

    

    
    // 更新约束
    [UIView animateWithDuration:keyboardDuration animations:^{
        //[self.view setNeedsLayout];
        [self.view layoutIfNeeded];
       // if( heightMax >keyboardTop ){
            //contentTransformOrigin = _containerView.transform;
           // _containerView.transform = CGAffineTransformTranslate(_containerView.transform, 0, -(heightMax-keyboardTop));
            //CGRect bounds = _containerView.bounds;
           // _containerView.bounds = CGRectMake(0, (heightMax-keyboardTop), bounds.size.width, bounds.size.height);
       // }
//         CGPoint offset = _scrollView.contentOffset;
//         _scrollView.contentOffset = CGPointMake(offset.x,offset.y+keyboardHeight);
    }];
    


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
    

    [_scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view);
    }];
    
    [_containerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self.view) ;
    }];
   

    
    // 更新约束
    [UIView animateWithDuration:keyboardDuration animations:^{
       // [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
        //_containerView.transform = contentTransformOrigin;
        //_containerView.bounds = CGRectMake(0, 0, _containerView.bounds.size.width, _containerView.bounds.size.height);
        //_scrollView.contentOffset  = CGPointZero;
    }];
}



-(void)setUpRootController{
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    
    
    ListTableviewController * listVC = [[ListTableviewController alloc]init];
    
    
    tempAppDelegate.mainNavigationController = [[UINavigationController alloc] initWithRootViewController:listVC];
    LeftSortsViewController *leftVC = [[LeftSortsViewController alloc] init];
    tempAppDelegate.LeftSlideVC = [[LeftSlideViewController alloc] initWithLeftView:leftVC andMainView:tempAppDelegate.mainNavigationController];
    

    CGRect rect = tempAppDelegate.mainNavigationController.navigationBar.frame;
    //[[UINavigationBar appearance] setBarTintColor:[UIColor purpleColor]];
    NSString * string = @"中文";
    float font =[string fontSizeSingleLineFitsRect:rect attributes:nil];
    [tempAppDelegate.mainNavigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"barBackground"] forBarMetrics:UIBarMetricsDefault];
    tempAppDelegate.mainNavigationController.navigationBar.titleTextAttributes = [ NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName,[UIFont systemFontOfSize:font/2],NSFontAttributeName,nil];
    tempAppDelegate.mainNavigationController.interactivePopGestureRecognizer.enabled = false;
    tempAppDelegate.mainNavigationController.interactivePopGestureRecognizer.delegate = nil;
    

    
    
    tempAppDelegate.window.rootViewController = tempAppDelegate.LeftSlideVC;
}



- (void)clickedLoginButton {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *userName =  _accountField.text;
    NSString *password0 = _passwordField.text;
    NSString *password = [[password0 MD5Digest]uppercaseString];
    //NSLog(@"%@",password);
    [defaults setValue:userName forKey:@"username"];
    [defaults setValue:password forKey:@"password"];
    if (userName.length && password.length){
        NSDictionary * dict = @{@"username":userName,
                                @"password":password
                                };
        [self login:dict];
    }
//    [self login:nil];
    
    //[self setUpRootController];
    
}
@end
