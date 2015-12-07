
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
#import "MBProgressHUD+HM.h"
#import "NSString+MD5.h"
//#import "NetConnect.h"
#import "LoginModel.h"
#import "MJExtension.h"
#import "Authority.h"


@interface LoginViewController (){
    BOOL  netWorkRequesting;
    CGAffineTransform contentTransformOrigin;
    
}
@property (strong,nonatomic) UIScrollView * scrollView;
@property (strong,nonatomic) UIView * containerView;
@property (strong, nonatomic) UITextField *accountField;
@property (strong, nonatomic) UITextField *passwordField;
@property (strong, nonatomic) UIButton *loginBtn;
@property (strong, nonatomic) UIImageView *bgImageView;
@property (weak, nonatomic) MBProgressHUD* hud;

//@property (strong, nonatomic) UITextField *accountField;
//@property (strong, nonatomic) LoginTextField *passwordField;
//@property (strong, nonatomic) UIButton *loginBtn;
@property (nonatomic) BOOL logout;
@end

@implementation LoginViewController

-(instancetype)init{
    return [self initForLogout:NO];
}

-(instancetype)initForLogout:(BOOL)logout{
    if( self = [super init] ){
         _logout = logout;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.touchDismissKeyboardEnabled = YES;
    self.scrollToVisibleEnabled = YES;
    self.navigationBarHidden = YES;
    //self.navigationController.navigationBarHidden = YES;
    //keyboardVisible = NO;
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
    
//    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(weakself.view);
//        //make.width.height.mas_equalTo(weakself.view);
//        //make.top.bottom.left.right.mas_equalTo(weakself.view);
//    }];
//    [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(_scrollView);
//        make.width.height.mas_equalTo(weakself.view);
//
//    }];
    _scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    _containerView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
   
    
    if( self.scrollToVisibleEnabled ){
        self.keyboardScrollView = _scrollView;
    }
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"矩形-1-拷贝-3"]];
    [_containerView addSubview:bgImageView];
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_containerView);

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

    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    
    _scrollView.contentSize = CGSizeMake(ScreenW, CGRectGetMaxY(_loginBtn.frame));
    
    if( !_logout){
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *userName = [defaults valueForKey:@"username"];
        NSString *password = [defaults valueForKey:@"password"];
        NSInteger pwdLength = [defaults integerForKey:@"password length"];
        NSString *showPwd = @"";
        for( int i=0;i<pwdLength;i++ ){
            showPwd =[showPwd stringByAppendingString:@"x"];
        }
        if (userName.length && password.length){
            NSDictionary * dict = @{@"username":userName,
                                    @"password":password
                                    };
            _accountField.text = userName;
            _passwordField.text = showPwd;
            [self login:dict];
        }
    }

}


-(void)login:( NSDictionary *)param{
    //netWorkRequesting = YES;
    _hud = [[MBProgressHUD alloc]initWithView:self.view];
    _hud.labelText = @"正在登陆";
    _hud.removeFromSuperViewOnHide = YES;

    //NSString *urlAPI = @"http://10.18.3.98:10001/SalesWebTest/UserLogin";
    NSString *urlAPI =  [URLBase stringByAppendingString: @"/UserLogin"];

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

             [_hud removeFromSuperview];
             [MBProgressHUD showSuccess:@"登陆成功"];


         LoginModel * model = [LoginModel objectWithJSONData:responseObject];
         if( model && [model.result isEqualToString:@"1"] ){

             authority = [model.authority integerValue];

             [self setUpRootController];
         }
         
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         
         NSLog(@"Error: %@", error);
        
         
        [_hud removeFromSuperview];
         [MBProgressHUD showError:@"登陆失败"];
     }
     ];



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

    [defaults setValue:userName forKey:@"username"];
    [defaults setValue:password forKey:@"password"];
    [defaults setInteger:password0.length forKey:@"password length"];
    
    if (userName.length && password.length){
        NSDictionary * dict = @{@"username":userName,
                                @"password":password
                                };
        [self login:dict];
    }

    
}
@end
