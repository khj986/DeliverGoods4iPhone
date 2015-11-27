
#import "Prefix.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "ListCell.h"
#import "QureyTableviewController.h"
#import "DetailViewController.h"
#import "ReportViewController.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "Constant.h"


@interface QureyTableviewController ()<UITableViewDataSource, UITableViewDelegate>{
    UIImageView *background;
    UIDatePicker * datePicker;
    
    int pageNum;

    BOOL end;
    NSString * beginTime;
    NSString * endTime;
    NSString * escortNo;
}
@property (strong, nonatomic) UITableView * tableView;
@property (strong, nonatomic) StaticInfoModel * model;
@property (strong, nonatomic) UIImageView * segment;
@property (strong, nonatomic) NSMutableArray * buttons;
@property (strong, nonatomic) NSMutableArray * labels;
@property (strong,nonatomic) NSMutableArray* arrayModel;
@property (nonatomic) int status;
@property (copy,nonatomic) NSString* userName;

@end

static float lineHeight =25;
static float paddingEdge = 5;
static float paddingMiddle =2;
static float paddingEdgeX ;
static float paddingMiddleX ;

@implementation QureyTableviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"查询列表";
    

    
    UIButton * query = [UIButton new];

    [query setTitle:@"搜索" forState:UIControlStateNormal];
    NSDictionary * dict=@{   NSFontAttributeName:[UIFont fontWithName:nil size:CONST.kFontSize]
                             };
    CGSize size = [query.titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, CONST.kLineHeight) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:dict context:nil].size;
    query.frame = CGRectMake(0, 0, size.width+24, size.height);
    [query addTarget:self action:@selector(queryAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:query];
    
    
    [self setupHeader];

    self.tableView = [[UITableView alloc] init];

    _arrayModel = [NSMutableArray array];
    _status =0;
    pageNum =0;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _userName = [defaults valueForKey:@"username"];
    
}

- (void)setupHeader{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy/MM/dd"];
    NSString *dateString = [dateFormat stringFromDate:[NSDate date]];
    
    NSArray * title = @[ @"订单号", @"订单状态",@"起始时间",@"截止时间"];
   // NSArray * buttonBackground = @[ @"圆角矩形-27-拷贝-4", @"多边形-1",@"圆角矩形-27-拷贝-4",@"圆角矩形-27-拷贝-4"];
    //NSArray * buttonTitle = @[ @"", @"",@"",@""];
    
    
    background = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"3"]];
    [self.view addSubview: background];
    
    _buttons = [NSMutableArray array];
    _labels = [NSMutableArray array];
    
    int num = title.count;
    float labelSizeXMax = 0;
    for( int i=0;i<num;i++ ){
        
        UILabel* label = [UILabel new];
        label.text = title[i];
        float fontSize =[label.text fontSizeSingleLineFitsHeight:CONST.kLineHeight attributes:nil];
        label.font = [UIFont fontWithName:nil size:fontSize];
        [self.view addSubview:label];
        [_labels addObject:label];
        NSDictionary * dict=@{   NSFontAttributeName:[UIFont fontWithName:nil size:fontSize]
                                 };
        CGSize labelSize = [label.text boundingRectWithSize:CGSizeMake(MAXFLOAT, CONST.kLineHeight) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading  attributes:dict context:nil].size;
       // float offsetH = (lineHeight -labelSize.height)/2;
        //        label.frame = CGRectMake(paddingEdgeX +column*( width +paddingMiddleX ) , paddingEdge + row*(paddingMiddle+lineHeight)+offsetH, labelSize.width, labelSize.height);
        
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( background ).offset( CONST.ScaleYEdge + i*(CONST.ScaleYMiddle+CONST.kLineHeight) );
            make.left.equalTo( background ).offset( CONST.ScaleXEdge  );
            make.width.equalTo( labelSize.width );
            make.height.equalTo( labelSize.height );
        }];
    }
    
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];

    for( int i=0;i<num;i++ ){
        CGRect rect =((UILabel*)_labels[i]).frame;
        if( rect.size.width>labelSizeXMax ){
            labelSizeXMax = rect.size.width;
        }
//        [((UILabel *)_labels[i]) mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.width.equalTo( ((UILabel *)_labels[i]).bounds.size.width );
//            make.height.equalTo( ((UILabel *)_labels[i]).bounds.size.height );
////            make.top.equalTo( background ).offset( CONST.ScaleYEdge + i*(CONST.ScaleYMiddle+CONST.kLineHeight) );
////            make.left.equalTo( background ).offset( CONST.ScaleXEdge  );
//        }];
    }
    
    for( int i=0;i<num;i++ ){
        
        UIButton *button = [UIButton new];
        [button setBackgroundImage:[UIImage imageNamed:@"矩形-13-拷贝"] forState:UIControlStateNormal];
        //[button setTitle:buttonTitle[i] forState:UIControlStateNormal];
        [button setTitleColor:XYColor(69, 69, 69, 1) forState:UIControlStateNormal];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        //button.titleLabel.font = [UIFont fontWithName:nil size:CONST.kFontSize];
        button.tag = 10+i;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        [_buttons addObject:button];

        
        if( i==1 ){
//            UIView * view = [ UIView new ];
//            view.backgroundColor= [UIColor clearColor];
//            [self.view addSubview:view];
//            
//            [view makeConstraints:^(MASConstraintMaker *make) {
//                make.top.bottom.equalTo(button);
//                make.right.equalTo( background ).offset(  -CONST.ScaleXEdge  );
//                make.width.equalTo(view.height);
//            }];
            
            UIImage * image = [UIImage imageNamed:@"多边形-1"];
            UIImage * image2 = [UIImage imageNamed:@"矩形-14"];
            UIButton * status = [UIButton new];
            [status setBackgroundImage:image2 forState:UIControlStateNormal];
            [status setImage:image forState:UIControlStateNormal];
            status.tag =10+i;
            [status addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            //[status setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
            [self.view addSubview:status];

            [status makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(button);
                make.right.equalTo( background ).offset(  -CONST.ScaleXEdge  );
                make.width.equalTo(status.height);

//                make.center.equalTo(view);
//                make.size.equalTo(view).multipliedBy(0.5);
            }];
            
            [button makeConstraints:^(MASConstraintMaker *make) {
                //make.top.equalTo( background ).offset( paddingEdge + row*(paddingMiddle+lineHeight) );
                make.top.bottom.equalTo((UILabel*)_labels[i]);
                make.left.equalTo(CONST.ScaleXEdge+labelSizeXMax + CONST.ScaleXMiddle);
                make.right.equalTo( status.left).offset(  -CONST.ScaleXMiddle  );
                //make.left.equalTo(label.right);
            }];

        }else{
            [button makeConstraints:^(MASConstraintMaker *make) {
                //make.top.equalTo( background ).offset( paddingEdge + row*(paddingMiddle+lineHeight) );
                make.top.bottom.equalTo((UILabel*)_labels[i]);
                make.left.equalTo(CONST.ScaleXEdge+labelSizeXMax + CONST.ScaleXMiddle);
                make.right.equalTo( background).offset(  -CONST.ScaleXEdge  );
                //make.left.equalTo(label.right);
            }];
        }
    }
    
    [background mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(CONST.ScaleYEdge);
        //make.bottom.mas_equalTo(self.view.top).offset(  CGRectGetMaxY( ((UILabel*)_labels[num-1]).frame) + CONST.ScaleYEdge);
        make.bottom.mas_equalTo( ((UILabel*)_labels[num-1]) ).offset(CONST.ScaleYEdge);
    }];

}


//- (void)setupHeader{
//    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
//    [dateFormat setDateFormat:@"yyyy/MM/dd"];
//    NSString *dateString = [dateFormat stringFromDate:[NSDate date]];
//    
//    NSArray * title = @[ @"订单号", @"订单状态",@"起始时间",@"截止时间"];
//    NSArray * buttonBackground = @[ @"圆角矩形-27-拷贝-4", @"多边形-1",@"圆角矩形-27-拷贝-4",@"圆角矩形-27-拷贝-4"];
//    //NSArray * buttonTitle = @[ @"", @"",@"",@""];
//    
//    _buttons = [NSMutableArray array];
//    _labels = [NSMutableArray array];
//    
//    int num = title.count;
//    float labelSizeXMax = 0;
//    for( int i=0;i<num;i++ ){
//        int row = i/2;
//        int column = i%2;
//        
//        paddingEdgeX = 28*ScaleX;
//        paddingMiddleX = 14*ScaleX;
//        float width = (ScreenW - 2*paddingEdgeX - (2-1)*paddingMiddle)/2;
//        
//        UILabel* label = [UILabel new];
//        label.text = title[i];
//        float fontSize =[label.text fontSizeSingleLineFitsHeight:lineHeight attributes:nil];
//        label.font = [UIFont fontWithName:nil size:fontSize-5];
//        [self.view addSubview:label];
//        [_labels addObject:label];
//        NSDictionary * dict=@{   NSFontAttributeName:[UIFont fontWithName:nil size:fontSize-5]
//                                 };
//        CGSize labelSize = [label.text boundingRectWithSize:CGSizeMake(MAXFLOAT, lineHeight) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading  attributes:dict context:nil].size;
//        float offsetH = (lineHeight -labelSize.height)/2;
////        label.frame = CGRectMake(paddingEdgeX +column*( width +paddingMiddleX ) , paddingEdge + row*(paddingMiddle+lineHeight)+offsetH, labelSize.width, labelSize.height);
//        
//        
////        CGRect rect =label.frame;
////        if( rect.size.width>labelSizeXMax ){
////            labelSizeXMax = rect.size.width;
////        }
//        
//        UIButton *button = [UIButton new];
//        [button setBackgroundImage:[UIImage imageNamed:buttonBackground[i]] forState:UIControlStateNormal];
//        //[button setTitle:buttonTitle[i] forState:UIControlStateNormal];
//        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        //button.titleLabel.font = [UIFont fontWithName:nil size:fontSize-5];
//        button.tag = 10+i;
//        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:button];
//        [_buttons addObject:button];
//        
////        [button makeConstraints:^(MASConstraintMaker *make) {
////            make.top.equalTo( background ).offset( paddingEdge + row*(paddingMiddle+lineHeight) );
////            make.height.equalTo(lineHeight);
////            //make.width.equalTo( 165*ScaleX );
////            make.right.equalTo( background).offset(  -( 1-column )*( width +paddingMiddleX ) - paddingEdgeX   );
////            //make.left.equalTo(label.right);
////        }];
//       // button.frame = CGRectMake(,paddingEdge + row*(paddingMiddle+lineHeight),  <#CGFloat width#>, lineHeight);
//        
//        [label makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo( background ).offset( paddingEdge + row*(paddingMiddle+lineHeight) );
//            //make.centerY.equalTo(button);
//            
//            make.left.equalTo( background ).offset( paddingEdgeX +column*( width +paddingMiddleX ) );
//            //make.width.equalTo( labelSize.width );
//            //make.height.equalTo( labelSize.height );
//        }];
//        
//    }
//    [self.view setNeedsLayout];
//    [self.view layoutIfNeeded];
//    
//    
//    
//    for( int i=0;i<num;i++ ){
//        CGRect rect =((UILabel*)_labels[i]).frame;
//        if( rect.size.width>labelSizeXMax ){
//            labelSizeXMax = rect.size.width;
//        }
//    }
//
//    for( int i=0;i<num;i++ ){
//        int row = i/2;
//        int column = i%2;
//        
//        float xMax;
//        float xMin;
//        if( column == 0 ){
//            xMin = paddingEdgeX +labelSizeXMax;
//            xMax = CGRectGetMinX(((UILabel*)_labels[i+1]).frame);
//        }else{
//            xMin = CGRectGetMinX(((UILabel*)_labels[i]).frame)+labelSizeXMax;
//            xMax = ScreenW;
//        }
//        
////        if(i==1){
////            ((UIButton*)_buttons[i]).contentEdgeInsets = UIEdgeInsetsMake(2, 2, 2, 20);
////        }else{
////            ((UIButton*)_buttons[i]).contentEdgeInsets = UIEdgeInsetsMake(2, 2, 2, 2);
////        }
//        
//        ((UIButton*)_buttons[i]).frame = CGRectMake(xMin,paddingEdge + row*(paddingMiddle+lineHeight),  xMax-28*ScaleX-xMin, lineHeight);
////        CGRect rect = UIEdgeInsetsInsetRect( ((UIButton*)_buttons[i]).frame, ((UIButton*)_buttons[i]).contentEdgeInsets);
////        float fontSize =[((UIButton*)_buttons[i]).titleLabel.text fontSizeSingleLineFitsRect:rect attributes:nil];
////        ((UIButton*)_buttons[i]).titleLabel.font = [UIFont fontWithName:nil size:fontSize];
//    }
//   
//    
//
//    
//    
//    UIButton * query = [UIButton new];
//    [query setBackgroundImage:[UIImage imageNamed:@"圆角矩形-27"] forState:UIControlStateNormal];
//    [query setTitle:@"查询" forState:UIControlStateNormal];
//    [query addTarget:self action:@selector(queryAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:query];
//    
//    [query makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo( ((UIButton*)_buttons.lastObject).bottom ).offset(37*ScaleY);
//        make.centerX.mas_equalTo(self.view);
//        make.width.mas_equalTo(345*ScaleX);
//        make.height.mas_equalTo(45*ScaleY);
//    }];
//    
//    
//    [background mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.mas_equalTo(self.view);
//        make.top.mas_equalTo(MasonryBottom(self.view)).multipliedBy(10/1136.0);
//        make.bottom.mas_equalTo(query).offset(21*ScaleY);
//    }];
//}

-(void)queryAction{
    [_arrayModel removeAllObjects];
    pageNum =0;
    end = NO;
    [_tableView.mj_footer resetNoMoreData];
    

    if( ((UIButton*)_buttons[2]).titleLabel.text.length  ){
        beginTime = [((UIButton*)_buttons[2]).titleLabel.text stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
    }else{
        beginTime =@"#";
    }
    
    if(((UIButton*)_buttons[3]).titleLabel.text.length){
        endTime = [((UIButton*)_buttons[3]).titleLabel.text stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
    }else{
        endTime =@"#";
    }
    
    if( ((UIButton*)_buttons[2]).titleLabel.text.length && ((UIButton*)_buttons[3]).titleLabel.text.length ){
        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];

        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        
        NSDate* beginDateFomat = [dateFormat dateFromString:beginTime];
        NSDate* endDateFomat = [dateFormat dateFromString:endTime];
        NSComparisonResult result = [beginDateFomat compare:endDateFomat];
        if( result == NSOrderedDescending  ){
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"结束时间小于开始时间，无法查询" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            return;
        }
    }

    
    
    if( ((UIButton*)_buttons[0]).titleLabel.text.length ){
        escortNo = ((UIButton*)_buttons[0]).titleLabel.text;
    }else{
        escortNo = @"#";
    }
    

    [self requestPageNum:pageNum+1];
    

}

-(void)requestPageNum:(int)pageNum{
    
    [(MJRefreshAutoNormalFooter*)_tableView.mj_footer setTitle:[NSString stringWithFormat:@"正在加载第%d页",pageNum] forState:MJRefreshStateRefreshing];
    
    NSDictionary * dict= @{@"pageNum":[NSString stringWithFormat:@"%d",pageNum],
                           @"pageSize":[NSString stringWithFormat:@"%d",CONST.kPageSize],
                           @"username":_userName,
                           @"status":[NSString stringWithFormat:@"%d",_status],
                           @"escortNo":escortNo,
                           @"beginTime":beginTime,
                           @"endTime":endTime
                           };
    [self listInfo:dict];
}



-(void)button:(UIButton*)button setAdjustTitle:(NSString*)title{
    [button setTitle:title forState:UIControlStateNormal];
    
    //((UIButton*)_buttons[i]).frame = CGRectMake(xMin,paddingEdge + row*(paddingMiddle+lineHeight),  xMax-28*ScaleX-xMin, lineHeight);
    NSDictionary * dict = @{
                           NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Light" size:1]
                           };
    CGRect rect = UIEdgeInsetsInsetRect( button.frame, button.contentEdgeInsets);
    float fontSize =[button.titleLabel.text fontSizeSingleLineFitsRect:rect attributes:nil];
    button.titleLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:fontSize];
}

-(void)buttonAction:(UIButton*)sender{
    if(sender.tag == 10 ){
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"请输入运单号" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
        [alert textFieldAtIndex:0].keyboardType = UIKeyboardTypeNumberPad;
        [alert show];
    }else if( sender.tag == 11){
        
        NSArray * options = [NSArray arrayWithObjects:
                             [NSDictionary dictionaryWithObjectsAndKeys:@"全部状态",@"text", nil],
                             [NSDictionary dictionaryWithObjectsAndKeys:@"配送中",@"text", nil],
                             [NSDictionary dictionaryWithObjectsAndKeys:@"已完成",@"text", nil],
                             nil];
        
        LeveyPopListView *lplv = [[LeveyPopListView alloc] initWithTitle:@"选择运单状态" options:options handler:^(NSInteger anIndex) {
            _status = anIndex;
            //[sender setTitle:options[anIndex][@"text"] forState:UIControlStateNormal];
            [self button:_buttons[1] setAdjustTitle:options[anIndex][@"text"] ];
        }];
        
        UIWindow * window = [UIApplication sharedApplication].keyWindow;
        [lplv showInView:window animated:YES];
        
    }else if( sender.tag == 12 || sender.tag == 13 ){

        datePicker = [ [ UIDatePicker alloc] init];
        datePicker.datePickerMode = UIDatePickerModeDate;
        //datePicker.backgroundColor  =[UIColor grayColor];
        NSDate *now = [NSDate date];
        [datePicker setDate:now animated:YES];
        [datePicker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
        datePicker.tag = sender.tag;
        //[datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged ];
        //[self.view addSubview:datePicker];

        if (IOS8) {
            
            //解释1,是用于给UIDatePicker留出空间的,因为UIDatePicker的大小是系统定死的,我试过用frame来设置,当然是没有效果的.
            //还有就是UIAlertControllerStyleActionSheet是用来设置ActionSheet还是alert的
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            //增加子控件--直接添加到alert的view上面
            [alert.view addSubview:datePicker];
            //解释2: handler是一个block,当点击ok这个按钮的时候,就会调用handler里面的代码.
            UIAlertAction *noLimit = [UIAlertAction actionWithTitle:@"不限时间" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

                [self button:_buttons[sender.tag-10] setAdjustTitle:@""];
                
            }];
            
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
                
                //实例化一个NSDateFormatter对象
                [dateFormat setDateFormat:@"yyyy-MM-dd"];//设定时间格式
                
               // NSString *dateString = [dateFormat stringFromDate:[NSDate date]];
                NSString *dateString = [dateFormat stringFromDate:datePicker.date];
             
                //求出当天的时间字符串
                //[((UIButton*)_buttons[sender.tag-10]) setTitle:dateString forState:UIControlStateNormal];
                [self button:_buttons[sender.tag-10] setAdjustTitle:dateString];
                
            }];
            
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
            }];
            
            [alert addAction:noLimit];
            [alert addAction:ok];//添加按钮
            
            [alert addAction:cancel];//添加按钮

            [self presentViewController:alert animated:YES completion:^{ }];
        }else
        {
//            //当在ios7上面运行的时候,
//           
//            
            UIActionSheet* startsheet = [[UIActionSheet alloc] initWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n\n"
                                                                    delegate:self
                                                           cancelButtonTitle:@"取消"
                                                      destructiveButtonTitle:nil
                                                           otherButtonTitles:@"不限时间",@"确定",
                                         nil];
            startsheet.tag = sender.tag;
            //添加子控件的方式也是直接添加
            [startsheet addSubview:datePicker];
            [startsheet showInView:self.view];
        }

        [datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(datePicker.superview);
            make.centerX.mas_equalTo(datePicker.superview);
        }];
    }
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if( buttonIndex == 0 ){
        [self button:_buttons[actionSheet.tag-10] setAdjustTitle:@""];
    }else if ( buttonIndex == 1 ){
        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
        
        //实例化一个NSDateFormatter对象
        [dateFormat setDateFormat:@"yyyy-MM-dd"];//设定时间格式
        
        NSString *dateString = [dateFormat stringFromDate:datePicker.date];
        
        //求出当天的时间字符串
        //[((UIButton*)_buttons[sender.tag-10]) setTitle:dateString forState:UIControlStateNormal];
        [self button:_buttons[actionSheet.tag-10] setAdjustTitle:dateString];
        
       // [((UIButton*)_buttons[actionSheet.tag-10]) setTitle:dateString forState:UIControlStateNormal];
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    UITextField *text_field = [alertView textFieldAtIndex:0];
    
    if (buttonIndex == 1) {
        
        [((UIButton*)_buttons[0]) setTitle:text_field.text forState:UIControlStateNormal];

        CGRect rect = UIEdgeInsetsInsetRect( ((UIButton*)_buttons[0]).frame, ((UIButton*)_buttons[0]).contentEdgeInsets);
        float fontSize =[((UIButton*)_buttons[0]).titleLabel.text fontSizeSingleLineFitsRect:rect attributes:nil];
        ((UIButton*)_buttons[0]).titleLabel.font = [UIFont fontWithName:nil size:fontSize];
    }
}

-(void)listInfo:( NSDictionary* )param{
    //NSString *urlAPI = @"http://10.18.3.98:10001/SalesWebTest/SearchLogicInformation?status=0&pageNum=1&pageSize=10&escortNo=#&beginTime=#&endTime=#";
    NSString *urlAPI =  [URLBase stringByAppendingString: @"/SearchLogicInformation"];
   // NSString *urlAPI = @"http://10.18.3.123:8080/SalesWebTest/SearchLogicInformation";
    
    NSDictionary *parameters = param;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/json",@"text/plain", nil];//设置相应内容类型
    
    
    [manager
     POST:urlAPI
     parameters:parameters
     success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         //NSLog(@"JSON: %@", responseObject);
         NSArray * array = responseObject;
         if( array.count != CONST.kPageSize ){
             if(!end){
                 end = YES;
             }
         }
         [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
             NSDictionary * dict = obj;
             StaticInfoModel * model = [StaticInfoModel objectWithKeyValues:obj];
             [_arrayModel addObject:model];
         }];
         pageNum =pageNum+1;
         [_tableView reloadData];
         if( !end ){
             [_tableView.mj_footer endRefreshing];
         }else{
             [_tableView.mj_footer endRefreshingWithNoMoreData];
         }
         
        [(MJRefreshAutoNormalFooter*)_tableView.mj_footer setTitle:[NSString stringWithFormat:@"正在加载第%d页",pageNum+1] forState:MJRefreshStateRefreshing];

     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
     }
     ];
}


- (void)setTableView:(UITableView *)tableView
{
    _tableView = tableView;
    
    
    [self.view addSubview: self.tableView];
    
//    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        //make.top.mas_equalTo(_segment.bottom).offset(10);
//        make.top.mas_equalTo(self.view).offset(200);
//        make.left.right.bottom.mas_equalTo(self.view);
//    }];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[ListCell class] forCellReuseIdentifier:NSStringFromClass([ListCell class])];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(background.bottom).offset(CONST.ScaleYEdge);
                //make.top.mas_equalTo(self.view).offset(200);
                make.left.right.bottom.mas_equalTo(self.view);
    }];
    

    UIView * footerView =[[UIView alloc]init];
    
    footerView.backgroundColor = XYColor(245, 248, 249, 1);
    //footerView.backgroundColor = [UIColor blackColor];
    self.tableView.tableFooterView = footerView;
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if(!end)    [self requestPageNum:pageNum+1];
    }];

}



#pragma mark - UITabelView 代理方法.

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _arrayModel.count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
}


- (void)configureCell:(ListCell *)cell atIndexPath:(NSIndexPath *)indexPath {
//    cell.buttonBlock =  ^{
//        NSLog(@"点击了%ld行",(long)indexPath.section);
//    };
//    cell.paddingEdge = paddingEdge;
//    cell.paddingMiddle = paddingMiddle;
//    cell.lineHeight = lineHeight;
    
    _model =  _arrayModel[indexPath.section];
    _model.index = indexPath.section;
    //_model.time = @"2015/10/09 8:42:46";
    _model.cargoName = @"电缆";
    
    cell.model = _model;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{   
    ListCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ListCell class]) forIndexPath: indexPath];
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat height = [tableView fd_heightForCellWithIdentifier: NSStringFromClass([ListCell class]) cacheByIndexPath:indexPath configuration:^(ListCell * cell) {
            [self configureCell:cell atIndexPath:indexPath];
    }];
    //NSLog(@"heightIndex%@,%f",indexPath,height);
    return height;

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 8)];
    view.backgroundColor = XYColor(245, 248, 249, 1);
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 8;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 0;
//}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0)
    {

        if( ScreenH > tableView.tableFooterView.frame.origin.y ){
            tableView.tableFooterView.frame = CGRectMake(tableView.tableFooterView.frame.origin.x, tableView.tableFooterView.frame.origin.y, tableView.tableFooterView.frame.size.width, ScreenH - tableView.tableFooterView.frame.origin.y);
        }
        
    }
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DetailViewController * vc = [[DetailViewController alloc]init];
    vc.staticInfo = _arrayModel[indexPath.section];
    [self.navigationController pushViewController:vc animated:YES];

    
}

@end
