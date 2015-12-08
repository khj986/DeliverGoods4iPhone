
#import "Prefix.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "ListCell.h"
#import "ListTableviewController.h"
#import "DetailViewController.h"
#import "ReportViewController.h"
#import "QureyTableviewController.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "MJRefresh.h"
//#import "ImageLabelLine2.h"
//#import "ImageLabel.h"
#import "Constant.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+HM.h"
#import "Authority.h"

@interface ListTableviewController ()<UITableViewDataSource, UITableViewDelegate>{
    TagDeliveryState tag ;
    int distributingPageNum;
    int finishedPageNum;
    NSInteger distributingSection;
    NSInteger finishedSection;
    BOOL distributingBegin;
    BOOL finishedBegin;
    BOOL distributingEnd;
    BOOL finishedEnd;
    
}
@property (strong, nonatomic) UITableView * tableView;
@property (strong, nonatomic) StaticInfoModel * model;
@property (strong, nonatomic) UISegmentedControl * segment;
@property (nonatomic) NSMutableArray* __strong* arrayModel;
@property (strong,nonatomic) NSMutableArray* arrayModelDistributing;
@property (strong,nonatomic) NSMutableArray* arrayModelFinished;
@property (copy,nonatomic) NSString* userName;
@property (weak,nonatomic)MBProgressHUD * hud;
@end

static float lineHeight;
static float paddingEdge;
static float paddingMiddle;

@implementation ListTableviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.leftSlideEnabled = YES;
    // Do any additional setup after loading the view.
    //self.title = @"配送单列表";
    _needRefresh = NO;
    
    self.navigationItem.leftBarButtonItem = nil;

    UIButton * menu = [UIButton new];
    UIImage *img=[UIImage imageNamed:@"main_lefttop" ];
    menu.frame =CGRectMake(0, 0, 38*ScaleX, 38*ScaleY);
    [menu setBackgroundImage:img forState:UIControlStateNormal];
    [menu addTarget:self action:@selector(openOrCloseLeftList) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menu];
    
    UIButton * query = [UIButton new];
    UIImage *img2=[UIImage imageNamed:@"magnifying-glass" ];
    query.frame =CGRectMake(0, 0, 38*ScaleX, 38*ScaleY);
    [query setBackgroundImage:img2 forState:UIControlStateNormal];
    [query addTarget:self action:@selector(qureyAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:query];
    
    //UISegmentedControl * segment =
//    UIImage* img =  [UIImage imageNamed:@"圆角矩形-28-拷贝"];
//   _segment  = [[UIImageView alloc]initWithImage:img];
//    [self.view addSubview:_segment];
//    [_segment mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.view).offset(10);
//        make.centerX.mas_equalTo(self.view);
//        make.height.equalTo(MasonryWidth(self.view)).multipliedBy(35/640.0);
//        make.width.equalTo(MasonryWidth(self.view)).multipliedBy(303/640.0);
//    }];
    
    tag = StateDistubuting;
    distributingPageNum = 0;
    finishedPageNum =0;
    distributingSection =0;
    finishedSection = 0;
    distributingBegin = NO;
    finishedBegin = NO;
    distributingEnd = NO;
    finishedEnd = NO;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _userName = [defaults valueForKey:@"username"];

    [self createSegmentedControl];
    
    //self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(20, 200, self.view.frame.size.width, self.view.frame.size.height-200) style:UITableViewStylePlain];
    
    
    UIImage * imgBack = [UIImage imageNamed:@"矩形-8-拷贝"];
//    float height = imgBack.size.height/imgBack.size.width*ScreenW;
//    int num  =3;
//    paddingEdge = 5;
//    paddingMiddle =2;
//    lineHeight = ( height - 2*paddingEdge - (num-1)*paddingMiddle )/num;
    
    _arrayModel = nil;
    _arrayModelDistributing = [NSMutableArray array];
    _arrayModelFinished = [NSMutableArray array];
    
    //[self segChange:_segment];
    _hud =[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    _hud.labelText= @"正在加载";
    _hud.removeFromSuperViewOnHide = YES;
    [self requestTag:tag pageNum:distributingPageNum+1];

    
    self.tableView = [[UITableView alloc] init];
   
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(_needRefresh){
        [_tableView reloadData];
    }
}

-(void)createSegmentedControl{
    
    NSArray *arr=@[@"配送中", @"已完成"];
    _segment = [[UISegmentedControl alloc]initWithItems:arr];
    
    
     self.navigationItem.titleView=_segment;
    _segment.bounds = CGRectMake(0, 0, 303*ScaleX, 44*ScaleX);
    _segment.layer.position = CGPointMake(ScreenW/2, 44);
    //[weakSelf.view addSubview:_segment];
//    [_segment mas_makeConstraints:^(MASConstraintMaker *make) {
//       // make.top.mas_equalTo(self.view).offset(10);
//       // make.centerX.mas_equalTo(self.view);
//        //make.height.equalTo(MasonryWidth(self.view)).multipliedBy(35/640.0);
//        //make.width.equalTo(MasonryWidth(self.view)).multipliedBy(303/640.0);
//        //make.center.equalTo( self.navigationController.navigationBar );
//        make.centerX.equalTo(ScreenW/2);
//        make.centerY.equalTo( 44 );
//        make.height.equalTo(44*ScaleY);
//        make.width.equalTo(303*ScaleX);
//    }];

    
//    ////背景 点击或未点击
   // [_segment setBackgroundImage:[UIImage imageNamed:@"barBackground"] forState:UIControlStateFocused barMetrics:UIBarMetricsDefault];
//    [_segment setBackgroundImage:[UIImage imageNamed:@"barBackground"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
//    [_segment setBackgroundImage:[UIImage imageNamed:@"barBackground"] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
//    [_segment setBackgroundImage:[UIImage imageNamed:@"3"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
//    
//    ////中间的分割线
//    [_segment setDividerImage:[UIImage imageNamed:@"messline"] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//    [_segment setDividerImage:[UIImage imageNamed:@"messline"] forLeftSegmentState:UIControlStateHighlighted rightSegmentState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    
    
    
    
    
    NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:XYColor(49, 144, 232, 1),UITextAttributeTextColor ,[UIColor clearColor],UITextAttributeTextShadowColor ,nil];
    [_segment setTitleTextAttributes:dic1 forState:UIControlStateSelected];
    
    NSDictionary *dic2 = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor ,[UIColor clearColor],UITextAttributeTextShadowColor ,nil];
    [_segment setTitleTextAttributes:dic2 forState:UIControlStateNormal];
    _segment.backgroundColor=XYColor(49, 144, 232, 1);
    _segment.tintColor = [UIColor whiteColor];
    _segment.layer.borderWidth=1;
    _segment.layer.borderColor=[[UIColor whiteColor] CGColor];
    _segment.layer.masksToBounds=YES;
    _segment.layer.cornerRadius=5;
    _segment.selectedSegmentIndex=tag;
    [_segment addTarget:self action:@selector(segChange:) forControlEvents:UIControlEventValueChanged];
    
   //
    
}

-(void)segChange:(UISegmentedControl *)sender{
    
    NSInteger index= sender.selectedSegmentIndex;
    
    if( index == tag ){
        return;
    }
    
    NSInteger from = tag;
    NSInteger to = index;
    tag = index;
    
    if( tag == StateDistubuting ){
        [self transFooterWithTag:tag end:distributingEnd];
    }else{
        [self transFooterWithTag:tag end:finishedEnd];
    }


    if( from == StateDistubuting ){
        if( distributingBegin ){
            distributingSection = _tableView.indexPathsForVisibleRows.firstObject.section;
        }
    }else{
        if( finishedBegin ){
            finishedSection = _tableView.indexPathsForVisibleRows.firstObject.section;
        }
    }

    if(to == StateDistubuting ){

        if( !distributingBegin ){
            _hud =[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            _hud.labelText= @"正在加载";
            _hud.removeFromSuperViewOnHide = YES;
            [self requestTag:tag pageNum:distributingPageNum+1];

        }else{
            _arrayModel = &_arrayModelDistributing;
            [_tableView reloadData];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:distributingSection ];
            [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
    }else{
        if( !finishedBegin ){
            _hud =[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            _hud.labelText= @"正在加载";
            _hud.removeFromSuperViewOnHide = YES;
            [self requestTag:tag pageNum:finishedPageNum+1];

        }else{
            _arrayModel = &_arrayModelFinished;
            [_tableView reloadData];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:finishedSection ];
            [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
    }
}

-(void)transFooterWithTag:(TagDeliveryState)tag end:(BOOL)end{
    if( end ){
        [_tableView.mj_footer endRefreshingWithNoMoreData];
    }else{
        [_tableView.mj_footer resetNoMoreData];
    }
    
    if( tag == StateDistubuting ){
            [(MJRefreshAutoNormalFooter*)_tableView.mj_footer setTitle:[NSString stringWithFormat:@"正在加载第%d页",distributingPageNum+1] forState:MJRefreshStateRefreshing];
    }else{
            [(MJRefreshAutoNormalFooter*)_tableView.mj_footer setTitle:[NSString stringWithFormat:@"正在加载第%d页",finishedPageNum+1] forState:MJRefreshStateRefreshing];
    }
}

-(void)requestTag:(NSInteger)tag pageNum:(int)pageNum{

   // [(MJRefreshAutoNormalFooter*)_tableView.mj_footer setTitle:[NSString stringWithFormat:@"正在加载第%d页",pageNum] forState:MJRefreshStateRefreshing];

    
    NSDictionary * dict= @{@"pageNum":[NSString stringWithFormat:@"%d",pageNum],
                           @"pageSize":[NSString stringWithFormat:@"%d",CONST.kPageSize],
                           @"username":_userName,
                           @"tag":[NSString stringWithFormat:@"%d",(int)(tag+1)]
                           };
    [self listInfo:dict];
}

-(void)listInfo:( NSDictionary* )param{
    

    
    //NSString *urlAPI = @"http://10.18.3.98:10001/SalesWebTest/DistributeList?pageNum=0&tag=0&pageSize=10";
    NSString *urlAPI =  [URLBase stringByAppendingString: @"/DistributeList"];
   // NSString *urlAPI = @"http://10.18.3.123:8080/SalesWebTest/DistributeList?pageNum=0&tag=0";
    
    NSDictionary *parameters = param;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
   manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/json",@"text/plain", nil];//设置相应内容类型
    
    
    [manager
     POST:urlAPI
     parameters:parameters
     success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         //NSLog(@"JSON: %@", responseObject);
         if(_hud){
             [_hud removeFromSuperview];
         }
          [MBProgressHUD showSuccess:@"加载成功"];
         
         NSArray * array = responseObject;
//         if( !distributingEnd ){
//             distributingEnd = YES;
//         }
         if( array.count != CONST.kPageSize ){
             if( tag ==StateDistubuting ){
                 if( !distributingEnd ){
                     distributingEnd = YES;
                 }
             }else if(tag == StateFinished){
                 if( !finishedEnd ){
                     finishedEnd = YES;
                 }
             }
         }
         [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
             NSDictionary * dict = obj;
             StaticInfoModel * model = [StaticInfoModel objectWithKeyValues:obj];
             //NSLog(@"%@",model.eId);
             //[_arrayModel addObject:model];
             if( tag ==StateDistubuting ){
                 [_arrayModelDistributing addObject:model];
             }else if(tag == StateFinished){
                 [_arrayModelFinished addObject:model];
             }
         }];
         
         if( tag ==StateDistubuting ){
             _arrayModel = &_arrayModelDistributing;
             if( !distributingBegin ){
                 distributingBegin = YES;
             }
             distributingPageNum = distributingPageNum+1;
             
         }else if(tag == StateFinished){
             _arrayModel = &_arrayModelFinished;
             if( !finishedBegin ){
                 finishedBegin = YES;
             }
             finishedPageNum = finishedPageNum+1;
         }
         [_tableView reloadData];
         [_tableView.mj_footer endRefreshing];
         
         if( tag == StateDistubuting ){
             [self transFooterWithTag:tag end:distributingEnd];
         }else{
             [self transFooterWithTag:tag end:finishedEnd];
         }
         
         
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         if(_hud){
             [_hud removeFromSuperview];
         }
         [MBProgressHUD showError:@"加载失败"];
         NSLog(@"Error: %@", error);
     }
     ];
}


-(void)qureyAction{
    QureyTableviewController* vc = [QureyTableviewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setTableView:(UITableView *)tableView
{
    WeakSelf;
    _tableView = tableView;
    
    
    [self.view addSubview: _tableView];
    
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
                make.top.mas_equalTo(weakSelf.view).offset(10);
                //make.top.mas_equalTo(weakSelf.view).offset(200);
                make.left.right.bottom.mas_equalTo(weakSelf.view);
    }];
    //NSLog( @"segment%@",_segment.superview );
    //NSLog( @"tableview%@",_tableView.superview );

    UIView * footerView =[[UIView alloc]init];
    
    footerView.backgroundColor = XYColor(245, 248, 249, 1);
    //footerView.backgroundColor = [UIColor blackColor];
    self.tableView.tableFooterView = footerView;
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        //NSLog(@"开始上拉加载");
        if( tag == StateDistubuting ){
            if( !distributingEnd ){
                //[(MJRefreshAutoNormalFooter*)_tableView.mj_footer setTitle:[NSString stringWithFormat:@"正在加载第%d页",distributingPageNum+1] forState:MJRefreshStateRefreshing];
                [self requestTag:tag pageNum:distributingPageNum+1];

            }else{

            }
        }else{
            if(!finishedEnd ){
                //[(MJRefreshAutoNormalFooter*)_tableView.mj_footer setTitle:[NSString stringWithFormat:@"正在加载第%d页",finishedPageNum+1] forState:MJRefreshStateRefreshing];
                [self requestTag:tag pageNum:finishedPageNum+1];

            }else{

            }
        }
    }];
    //((MJRefreshAutoNormalFooter*)_tableView.mj_footer).automaticallyRefresh = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - UITabelView 代理方法.

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(_arrayModel){
        return (*_arrayModel).count;
    }else{
        return 0;
    }
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
    
    _model =  (*_arrayModel)[indexPath.section];
    _model.index = indexPath.section;
    //_model.time = @"2015/10/09 8:42:46";
    //_model.cargoName = @"电缆";
    _model.tag = tag;
    
    cell.model = _model;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{   
    ListCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ListCell class]) forIndexPath: indexPath];
//    NSString *cellIdentifier = NSStringFromClass([ListCell class]);
//    ListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//     if (!cell) {
//        cell = [[ListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//    }
//    cell.imageView.image = [UIImage imageNamed:@"ic_delivery_list_detail_spot_selected"];
//    cell.imageView.frame = CGRectMake(0, 0, 80, 80);
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //UIImageView * imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_delivery_list_item_detail"]];
    //cell.accessoryView = imageView;
    
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

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView *view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 8)];
//    view.backgroundColor = XYColor(245, 248, 249, 1);
//    return view;
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 8;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 8;
//}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    CGRect rect = cell.accessoryView.superview.frame;
    
    if (indexPath.section == 0)
    {

        if( ScreenH > tableView.tableFooterView.frame.origin.y ){
            tableView.tableFooterView.frame = CGRectMake(tableView.tableFooterView.frame.origin.x, tableView.tableFooterView.frame.origin.y, tableView.tableFooterView.frame.size.width, ScreenH - tableView.tableFooterView.frame.origin.y);
        }
        
    }
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //CGRect rect = _tableView cellForRowAtIndexPath:<#(nonnull NSIndexPath *)#> .accessoryView.frame;
    // ReportViewController * vc = [[ReportViewController alloc]init];
    DetailViewController * vc = [[DetailViewController alloc]init];    
    vc.staticInfo = (*_arrayModel)[indexPath.section];
    [self.navigationController pushViewController:vc animated:YES];

    
}

+(float)getLineHeight{
    return lineHeight;
}

+(float)getPaddingEdge{
    return paddingEdge;
}

+(float)getPaddingMiddle{
    return paddingMiddle;
}
@end
