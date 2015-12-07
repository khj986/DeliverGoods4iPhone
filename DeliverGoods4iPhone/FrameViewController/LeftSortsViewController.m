//
//  LeftSortsViewController.m
//  LGDeckViewController
//
//  Created by jamie on 15/3/31.
//  Copyright (c) 2015年 Jamie-Ling. All rights reserved.
//
#import "Prefix.h"
#import "LeftSortsViewController.h"
#import "AppDelegate.h"
#import "LeftMenuTableViewCell.h"
#import "SuggestViewController.h"
#import "AboutUsViewController.h"
#import "LoginViewController.h"
//#import "CustomButton.h"


const float RowHeight = 50;

@interface LeftSortsViewController () <UITableViewDelegate,UITableViewDataSource>{
    float tableHeaderHeight;
    float tableFooterHeight;
}
@property (nonatomic,strong)   LeftMenuTableViewCellData * cellData;
@property (nonatomic,strong) UIImageView* portrait;
@property (nonatomic,strong) UILabel* name;
@end



@implementation LeftSortsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageview.image = [UIImage imageNamed:@"矢量智能对象"];
    [self.view addSubview:imageview];

    
    tableHeaderHeight = ViewFrameH(self.view)*0.25;
    tableFooterHeight = ViewFrameH(self.view)*0.1;
    UITableView *tableview = [[UITableView alloc] init];
    self.tableview = tableview;
    //tableview.frame = self.view.bounds;
    tableview.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height/2);
    tableview.dataSource = self;
    tableview.delegate  = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.scrollEnabled = NO;
    [self.view addSubview:tableview];

    _cellData = [[LeftMenuTableViewCellData alloc]init];
    _cellData.cellTitles = [NSArray arrayWithObjects:@"消息", @"意见反馈",@"软件更新",@"关于我们",nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _cellData.cellTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *Identifier = @"Identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (cell == nil) {
        //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
        
        cell = [[LeftMenuTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier indexPath:indexPath cellData:_cellData];
//         cell = [[LeftMenuTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier block:^(UITableViewCell *cell) {
//             cell.backgroundColor = [UIColor clearColor];
//
//             
//            UILabel* _label = [[UILabel alloc]init];
//             
//             UIImageView *_image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:_cellData.cellTitles[indexPath.row]]];
//             UIImageView*_baseLine = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"矩形-6-拷贝"]];
//             [cell.contentView addSubview:_image];
//             [cell.contentView addSubview:_label];
//             [cell.contentView addSubview:_baseLine];
//             
//             [_image mas_makeConstraints:^(MASConstraintMaker *make) {
//                 make.left.mas_equalTo(MasonryRight(cell.contentView)).multipliedBy(0.11);
//                 make.centerY.mas_equalTo(MasonryBottom(cell.contentView)).multipliedBy(0.45);
//                 make.width.height.mas_equalTo(MasonryHeight(cell.contentView)).multipliedBy(0.5);
//             }];
//             
//             
//             [_label mas_makeConstraints:^(MASConstraintMaker *make) {
//                 make.left.mas_equalTo(MasonryRight(cell.contentView)).multipliedBy(0.25);
//                 make.centerY.mas_equalTo(MasonryBottom(cell.contentView)).multipliedBy(0.45);
//                 make.height.mas_equalTo(MasonryHeight(cell.contentView)).multipliedBy(0.6);
//                 make.width.mas_equalTo(MasonryWidth(cell.contentView)).multipliedBy(0.5);
//             }];
//             
//             [_baseLine mas_makeConstraints:^(MASConstraintMaker *make) {
//                 make.left.mas_equalTo(_image);
//                 make.right.mas_equalTo(MasonryRight(cell.contentView)).multipliedBy(0.8);
//                 make.top.mas_equalTo(MasonryBottom(cell.contentView)).multipliedBy(0.9);
//                 make.height.equalTo(1);
//                 
//             }];
//             
//             [_label setNeedsDisplay];
//             [_label layoutIfNeeded];
//             
//             _label.text = _cellData.cellTitles[indexPath.row];
//             _label.textColor = [UIColor whiteColor];
//             _label.font = [UIFont fontWithName:nil size:[_label.text fontSizeSingleLineFitsRect:_label.frame attributes:nil]];
//             
////             if( indexPath.row == 0 ){
////                 
////                 [cell setUpInfoSwitch];
////                 
////             }
//             
//         }
//
//         ];
        
//        if( indexPath.row == 0 ){
//                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        }
//        if( indexPath.row == 3 ){
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        }
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if( indexPath.row == 3 ){
//      return;
//    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.LeftSlideVC closeLeftView];//关闭左侧抽屉
    
    if( indexPath.row == 1 ){
        SuggestViewController * vc = [SuggestViewController new];
        [tempAppDelegate.mainNavigationController pushViewController:vc animated:YES];
    }else if( indexPath.row == 3 ){
        AboutUsViewController * vc = [AboutUsViewController new];
        [tempAppDelegate.mainNavigationController pushViewController:vc animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return RowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return tableHeaderHeight;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableview.bounds.size.width, tableHeaderHeight)];
    view.backgroundColor = [UIColor clearColor];
    
    _portrait = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo-拷贝-2"]];
    [view addSubview:_portrait];
    
    [_portrait mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(MasonryRight(view)).multipliedBy(0.1);
        make.top.mas_equalTo(_portrait.left).offset(20);
        make.width.mas_equalTo(MasonryWidth(view)).multipliedBy(0.25);
        make.height.mas_equalTo(_portrait.width);
        
    }];
    
    _name = [[UILabel alloc]init];
    [view addSubview:_name];
    _name.text = @"江东物流易配货";
    _name.textAlignment = NSTextAlignmentCenter;
    _name.textColor = [UIColor whiteColor];
    [_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_portrait.right).offset(10);
        make.right.mas_equalTo(MasonryRight(view)).multipliedBy(0.9);
        make.height.mas_equalTo(36);
        make.centerY.mas_equalTo(_portrait);
    }];
    
    [view setNeedsLayout];
    [view layoutIfNeeded];
    
    float fontSize = [_name.text fontSizeSingleLineFitsRect:_name.frame attributes:nil];
    _name.font = [UIFont fontWithName:nil size:fontSize];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return tableFooterHeight;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableview.bounds.size.width, tableFooterHeight)];
    view.backgroundColor = [UIColor clearColor];
    
    UIButton * exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //CustomButton * exitButton = [[CustomButton alloc]init];
    UIImage * img = [UIImage imageNamed:@"bt_logout"];
    CGSize imgSize = img.size;
    
    [view addSubview:exitButton];
    
    [exitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(MasonryWidth(view)).multipliedBy(0.65);
        make.height.mas_equalTo(exitButton.width).multipliedBy(imgSize.height/imgSize.width);
        make.centerY.mas_equalTo(view);
        make.centerX.mas_equalTo(MasonryRight(view)).multipliedBy(0.45);
    }];
    
    [exitButton setNeedsDisplay];
    [exitButton layoutIfNeeded];
    [exitButton setBackgroundImage:img forState:UIControlStateNormal];
    [exitButton setBackgroundImage:[UIImage imageNamed:@"bt_logout_click"] forState:UIControlStateHighlighted];
    //[exitButton setImage:[UIImage imageNamed:@"圆角矩形-27-拷贝-2"] forState:UIControlStateNormal];
    //exitButton.adjustsImageWhenHighlighted = YES;
    [exitButton setTitle:@"注销" forState:UIControlStateNormal];
    [exitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [exitButton setTitleEdgeInsets:UIEdgeInsetsMake(1, 0, 1, 0)];
//    exitButton.titleLabel.textAlignment = NSTextAlignmentCenter;
//    exitButton.titleLabel.textColor = [UIColor whiteColor];
   // exitButton.titleLabel.font = [UIFont fontWithName:nil size:[exitButton.titleLabel.text fontSizeSingleLineFitsRect:exitButton.titleLabel.frame attributes:nil]];
    [exitButton addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    exitButton.showsTouchWhenHighlighted = YES;
    
    
    return view;
}

-(void)logout{
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    LoginViewController* vc = [[LoginViewController alloc]initForLogout:YES];
    
    tempAppDelegate.window.rootViewController = vc;
    
    
}
@end
