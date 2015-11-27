
#import "Prefix.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "DetailCell.h"
#import "DetailViewController.h"
#import "ReportViewController.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "MJRefresh.h"

@interface DetailViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) UITableView * tableView;
@property (strong, nonatomic) DeliveryInfoModel * model;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"订单详情";
    
    //CGRect rect = self.navigationController.navigationBar.frame;
    NSString * string = @"中文";
    float fontSize =[string fontSizeSingleLineFitsHeight:34*ScaleY attributes:nil];
    

    
    UIButton * report = [UIButton new];
    //UIImage *img=[UIImage imageNamed:@"圆角矩形-27-拷贝-7" ];
    //report.frame =CGRectMake(0, 0, 140*ScaleX, 34*ScaleY);
    [report setTitle:@"上报信息" forState:UIControlStateNormal];
    NSDictionary * dict=@{   NSFontAttributeName:[UIFont fontWithName:nil size:fontSize]
                             };
    CGSize size = [report.titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 34*ScaleY) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:dict context:nil].size;
    report.frame = CGRectMake(0, 0, size.width+24, size.height);
    //report.titleLabel.text = @"上报信息";
    //report.titleLabel.font = [UIFont fontWithName:nil size:font];
    //report.titleLabel.textColor = [UIColor whiteColor];
    //[report setBackgroundImage:img forState:UIControlStateNormal];
    [report addTarget:self action:@selector(reportAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:report];

    
    _model =  [[DeliveryInfoModel alloc]init];
    _model.staticInfo = _staticInfo;
    _model.flow = nil;
    [self loadFlow];
    
    self.tableView = [[UITableView alloc] init];
    

}

-(void) reportAction{
    ReportViewController * vc = [[ReportViewController alloc]init];
    vc.model = _model;
    [self.navigationController pushViewController:vc animated:YES];
}


-(void)loadFlow{
    //NSString *urlAPI = @"http://10.18.3.98:10001/SalesWebTest/LogicInformation";
    NSString *urlAPI =  [URLBase stringByAppendingString: @"/LogicInformation"];
    //NSString *urlAPI = @"http://10.18.3.123:8080/SalesWebTest/LogicInformation";
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userName = [defaults valueForKey:@"username"];
    NSDictionary *parameters = @{
                                 @"username":userName,
                                 @"eId":_staticInfo.eId
                                 };
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/json",@"text/plain", nil];//设置相应内容类型
    
    __block DeliveryFlow * flow = [[DeliveryFlow alloc]init];
    
    [manager
     POST:urlAPI
     parameters:parameters
     success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"JSON: %@", responseObject);
         NSArray * array = responseObject;
         [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
             NSDictionary * dict = obj;
             DeliveryNode * model = [DeliveryNode objectWithKeyValues:obj];
             [flow addNode:model];
             
         }];
         _model.flow = flow;
         [_tableView reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationFade];
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
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerClass:[DetailCell class] forCellReuseIdentifier:NSStringFromClass([DetailCell class])];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UIImage * img = [UIImage imageNamed:@"1"];
    float height = img.size.height/img.size.width*ScreenW;
    int num  =2;
    paddingEdge = 5;
    paddingMiddle =2;
    lineHeight = ( height - 2*paddingEdge - (num-1)*paddingMiddle )/num;
    paddingFlow = 35*ScaleY;
    flowHeight = 115*ScaleY;
    
   // NSString *str = @"中文";
   // _fontSize = [str fontSizeSingleLineFitsHeight:height attributes:nil];
    
    UIView * footerView =[[UIView alloc]init];
    
    footerView.backgroundColor = XYColor(245, 248, 249, 1);
    //footerView.backgroundColor = [UIColor blackColor];
    self.tableView.tableFooterView = footerView;
}





#pragma mark - UITabelView 代理方法.

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
}


- (void)configureCell:(DetailCell *)cell atIndexPath:(NSIndexPath *)indexPath {
//    cell.buttonBlock =  ^{
//        NSLog(@"点击了%ld行",(long)indexPath.row);
//    };
    cell.paddingMiddle= paddingMiddle;
    cell.paddingEdge=paddingEdge;
    cell.lineHeight =lineHeight;
    cell.paddingFlow = paddingFlow;
    cell.flowHeight = flowHeight;

    
    _model.index = indexPath.section;
   
    cell.model = _model;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{   
    DetailCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DetailCell class]) forIndexPath: indexPath];
   // DetailCell * cell = [[DetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([DetailCell class] )];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //NSLog(@"cellIndex%@",indexPath);
    [self configureCell:cell atIndexPath:indexPath];
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat height = [tableView fd_heightForCellWithIdentifier: NSStringFromClass([DetailCell class]) cacheByIndexPath:indexPath configuration:^(DetailCell * cell) {
        
        [self configureCell:cell atIndexPath:indexPath];
    }];
    return height;

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 8;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0)
    {
        if( ScreenH > tableView.tableFooterView.frame.origin.y ){
                    tableView.tableFooterView.frame = CGRectMake(tableView.tableFooterView.frame.origin.x, tableView.tableFooterView.frame.origin.y, tableView.tableFooterView.frame.size.width, ScreenH - tableView.tableFooterView.frame.origin.y);
        }
        
    }
}

@end
