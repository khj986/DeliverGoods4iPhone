
#import "Prefix.h"
#import "Constant.h"
#import "SuggestViewController.h"
#import "AFNetworking.h"
#import "LeveyPopListView.h"






@interface SuggestViewController (){
    BOOL  keyboardVisible;
    UIImageView *background;
    UIButton * typeShow;
    
}
@property (strong,nonatomic) UIScrollView * scrollView;
@property (strong,nonatomic) UIView * containerView;
@property (strong,nonatomic) NSMutableArray * lines;
@property (strong,nonatomic) NSMutableArray * textviews;
@property (strong,nonatomic) NSArray * placeholderStrings;
@end

@implementation SuggestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.touchDismissKeyboardEnabled = YES;
    self.scrollToVisibleEnabled = YES;
    // fontSize =ScreenW /32;
    
    self.title =@"意见反馈";
    
    _scrollView = [[UIScrollView alloc]init];
    _scrollView.directionalLockEnabled = YES;
    //_scrollView.bounces = NO;
    //_scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    _containerView = [[UIView alloc]init];
    [_scrollView addSubview:_containerView];
    
    _scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64);
    
    
    
    UILabel* typeTitle = [UILabel new];
    typeTitle.text = @"问题类型";
    typeTitle.font = [UIFont fontWithName:nil size:CONST.kFontSize];
    [_containerView addSubview:typeTitle];
    [typeTitle makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo( CONST.ScaleYEdge );
        make.left.equalTo( CONST.ScaleXEdge );
    }];
    
    
    typeShow = [UIButton new];
    //typeShow.titleLabel.textColor = [UIColor blackColor];
    //typeShow.titleLabel.font = typeTitle.font;
    [typeShow setTitle:@"新需求建议" forState:UIControlStateNormal];
    [typeShow setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [typeShow addTarget:self action:@selector(selectType) forControlEvents:UIControlEventTouchUpInside];
    [_containerView addSubview:typeShow];
    
    UIImage * img =[UIImage imageNamed:@"suggest-select"];
    UIButton * typeButton = [UIButton new];
    [typeButton setBackgroundImage:img forState:UIControlStateNormal];
    [typeButton addTarget:self action:@selector(selectType) forControlEvents:UIControlEventTouchUpInside];
    [_containerView addSubview:typeButton];
    
    [typeShow makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(typeTitle);
        make.height.equalTo(typeTitle);
        make.right.equalTo(typeButton.left);
    }];
    [typeButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(typeTitle);
        make.right.equalTo( _containerView.left ).offset( ScreenW -CONST.ScaleXEdge);
        make.height.equalTo(typeTitle ).multipliedBy(0.7);
        //make.height.equalTo(typeTitle );
        make.width.equalTo( typeButton.height ).multipliedBy( img.size.width/img.size.height );
    }];
    
    background = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"3"]];
    [_containerView addSubview:background];
    
    
    _placeholderStrings = @[@"请输入您的宝贵建议和问题(必填)",@"(必填)"];
    
    _lines = [NSMutableArray array];
    _textviews = [NSMutableArray array];
    
    int num =3;
    
    for( int i=0;i<num;i++ ){
        
        UIImageView * line = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"矩形-9"]];
        [_containerView addSubview:line];
        [_lines addObject:line];
        
        if( i==0 ){
            [line makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo( typeTitle.bottom ).offset( CONST.ScaleYMiddle );
                make.height.equalTo(2);
                make.centerX.equalTo(_containerView);
                make.left.equalTo(CONST.ScaleXEdge );
            }];
        }else{
            UITextView * textviewLast =  _textviews[i-1];
            [line makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo( textviewLast.bottom );
                make.height.equalTo(2);
                make.centerX.equalTo(_containerView);
                make.left.equalTo(CONST.ScaleXEdge );
            }];
        }
        
        UITextView * textview;
        if( i != num-1 ){
            textview = [UITextView new];
            textview.tag =10+i;
            textview.backgroundColor = [UIColor whiteColor];
            textview.text = _placeholderStrings[i];
            textview.font = [UIFont fontWithName:nil size:CONST.kFontSize];
            textview.textColor = [UIColor grayColor];
            textview.delegate = self;
            [_containerView addSubview:textview];
            [_textviews addObject:textview];
        }
        if( i==0 ){
            [textview makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo( line.bottom );
                make.left.right.equalTo(line);
                make.height.equalTo(200);
            }];
        }else if( i==1) {
            UILabel * title = [UILabel new];
            title.text = @"联系方式";
            title.font = [UIFont fontWithName:nil size:CONST.kFontSize];
            [_containerView addSubview:title];
            [title makeConstraints:^(MASConstraintMaker *make) {
                //make.top.equalTo( line.bottom );
                make.centerY.equalTo( textview );
                make.left.equalTo( line );
            }];
            
            
            [textview makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo( line.bottom );
                make.left.equalTo(title.right);
                make.right.equalTo(line);
                make.height.equalTo(title).offset(16);
            }];
        }else{
            
        }
        
    }
    
    [background makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(typeTitle.bottom);
        make.bottom.equalTo( (UIImageView*)_lines[num-1] ).offset(CONST.ScaleYMiddle);
        make.left.right.equalTo(_containerView);
    }];
    
    UIImage * img2 = [UIImage imageNamed:@"圆角矩形-27-拷贝-2"];
    UIButton * suggest = [UIButton new];
    [suggest setBackgroundImage:img2 forState:UIControlStateNormal];
    [suggest setTitle:@"提交反馈" forState:UIControlStateNormal];
    //[suggest setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [suggest addTarget:self action:@selector(suggest) forControlEvents:UIControlEventTouchUpInside];
    [_containerView addSubview:suggest];
    [suggest makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(background.bottom).offset( CONST.ScaleYButtonAndContent );
        make.centerX.equalTo(_containerView);
        make.width.equalTo(ScreenW/2);
        make.height.equalTo( suggest.width ).multipliedBy( img2.size.height/img2.size.width );
    }];
    
    
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    
    _containerView.frame = CGRectMake(0,0 , ScreenW, CGRectGetMaxY(suggest.frame)+CONST.ScaleYEdge);
    _scrollView.contentSize = CGSizeMake( ScreenW, CGRectGetMaxY(suggest.frame)+CONST.ScaleYEdge );
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if( textView.tag -10 == 0   ){
        if( ![textView.text isEqualToString:_placeholderStrings[0]] )
            return;
    }
    if( textView.tag -10 == 1   ){
        if( ![textView.text isEqualToString:_placeholderStrings[1]] )
            return;
    }
    textView.text = @"";
    textView.textColor = [UIColor blackColor];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length == 0) {
        textView.text = _placeholderStrings[ textView.tag-10 ];
        textView.textColor = [UIColor grayColor];
    }
}

-(void)selectType{
    NSArray * options = [NSArray arrayWithObjects:
                         [NSDictionary dictionaryWithObjectsAndKeys:@"新需求建议",@"text", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"功能建议",@"text", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"界面建议",@"text", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"操作问题",@"text", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"质量问题",@"text", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"投诉",@"text", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"其他",@"text", nil],
                         nil];
    
    LeveyPopListView *lplv = [[LeveyPopListView alloc] initWithTitle:@"选择问题类型" options:options handler:^(NSInteger anIndex) {
        [typeShow setTitle:options[anIndex][@"text"] forState:UIControlStateNormal];
    }];
    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    [lplv showInView:window animated:YES];
}

-(void)suggest{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userName = [defaults valueForKey:@"username"];
    
    for( int i=0;i<_textviews.count;i++ ){
        if( [((UITextView*)_textviews[i]).text isEqualToString:_placeholderStrings[i]]){
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"请填写内容和联系方式" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            return;
        }
    }
    
    
    
    NSDictionary * dict= @{@"type":typeShow.titleLabel.text,
                           @"suggest":((UITextView*)_textviews[0]).text,
                           @"contact":((UITextView*)_textviews[1]).text,
                           @"username":userName
                           };
    [self suggestInfo:dict];
}

-( void )suggestInfo:(NSDictionary* ) param {
    
    // http://10.18.3.98:10001/SalesWebTest/SuggestPost
    NSString *urlAPI =  [URLBase stringByAppendingString: @"/SuggestPost"];
    
    
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
             [self suggustCompletionWithSucess:YES];
             
         }else {
             [self suggustCompletionWithSucess:NO];
             NSLog( @"上报失败：requestString:%@",operation.responseString );
         }
         
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [self suggustCompletionWithSucess:NO];
         NSLog(@"Error: %@", error);
     }
     ];
    
}

-(void) suggustCompletionWithSucess:(BOOL)sucess{
    if( sucess ){
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"意见提交成功,感谢您的支持" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }else{
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"意见提交失败，请检查网络并重试" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self backAction];
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
    
    
    _scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64);
    
    _scrollView.contentOffset = CGPointZero;
    
}





@end
