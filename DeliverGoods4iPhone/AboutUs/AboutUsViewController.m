
#import "Prefix.h"
#import "Constant.h"
#import "AboutUsViewController.h"
#import "AFNetworking.h"
//#import "HonrizontalLineView.h"
#import "HonrizontalLineView.h"
#import "VerticalLineView.h"
#import "UIKit+AFNetworking.h"
#import "UIView+AutoSize.h"

#import "AutoSizeLabel.h"

#import "HonrizontalAutoSizeView.h"
#import "VerticalAutoSizeView.h"


@interface AboutUsViewController (){

    
}

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title =@"关于我们";
    
//    UIView * view1= [UIView new];
//    view1.backgroundColor = [UIColor greenColor];
    AutoSizeLabel * view1 =[AutoSizeLabel new];
    //view1.numberOfLines =0;
    view1.text = @"中文Block的实际";
    //[view1 setContentHuggingPriority:750 forAxis:UILayoutConstraintAxisHorizontal];
    
//    UIView * view2= [UIView new];
//    view2.backgroundColor = [UIColor blueColor];
    AutoSizeLabel * view2 =[AutoSizeLabel new];
    view2.numberOfLines =0;
    view2.text = @"中文Block的实际行为和Function很像，最大的差别是在可以存取同一个Scope的变量值。Block实体形式如下";

    
    NSArray<UIView*> * views= @[view1,view2];
    NSArray* sizes = @[[NSValue valueWithCGSize:CGSizeMake(-1, -1)],
                       [NSValue valueWithCGSize:CGSizeMake(100, -1)]
                       ];
    NSArray* paddings = @[ [NSNumber numberWithFloat:50]
                          ];
    NSArray* vAligns = @[ [NSNumber numberWithInteger:VAlignTop],
                          [NSNumber numberWithInteger:VAlignBottom]
                         ];
    
    NSArray* vOffsets = @[ [NSNumber numberWithFloat:0],
                          [NSNumber numberWithFloat:0]
                         ];
    NSArray* hAligns = @[ [NSNumber numberWithInteger:HAlignCenter],
                          [NSNumber numberWithInteger:HAlignLeft]
                          ];
    
    NSArray* hOffsets = @[ [NSNumber numberWithFloat:0],
                           [NSNumber numberWithFloat:0]
                           ];
    
    HonrizontalAutoSizeView * hLineView = [[HonrizontalAutoSizeView alloc]initWithViews:views sizes:sizes paddings:paddings vAligns:vAligns vOffsets:vOffsets edgeImage:[UIImage imageNamed:@"barBackground"] edgeColor:[UIColor yellowColor] edgeInsets:UIEdgeInsetsMake(5,5,5,5) edgeWidths:UIEdgeInsetsMake(2, 2, 4, 2)];
    
    [self.view addSubview: hLineView];
    
    [hLineView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left).offset( 50 );
        make.top.equalTo(self.view.top).offset(50);
        //make.width.equalTo(200);
        //make.height.equalTo(300);
        //make.bottom.equalTo(self.view.top).offset(350);
    }];
    
    
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC*2),
//                       dispatch_get_main_queue(), ^{
//                  //[hLineView setLineViewSize:CGSizeMake(-1, 300)];
//                           [hLineView masonryWithBlock:^{
//                               [hLineView mas_updateConstraints:^(MASConstraintMaker *make) {
//                                   //make.left.equalTo(self.view.left).offset( 50 );
//                                   //make.top.equalTo(self.view.top).offset(50);
//                                   //make.width.equalTo(200);
//                                   //make.height.equalTo(300);
//                                   make.bottom.equalTo(self.view.top).offset(350);
//                               }];
//                           } sizeChanged:YES];
//                       });

    //[hLineView setNeedsDisplay];
    //hLineView.backgroundColor = [UIColor clearColor];
    
    //[self.view setNeedsLayout];
    //[self.view layoutIfNeeded];
    
   // NSLog(@"lineViewFrame%@", NSStringFromCGRect( hLineView.frame));
//    VerticalAutoSizeView * vLineView = [[VerticalAutoSizeView alloc]initWithViews:views sizes:sizes paddings:paddings hAligns:hAligns hOffsets:hOffsets edgeImage:[UIImage imageNamed:@"barBackground"] edgeColor:[UIColor yellowColor] edgeInsets:UIEdgeInsetsMake(5,5,5,5) edgeWidths:UIEdgeInsetsMake(0, 0, 0, 4)];
//    
//    [self.view addSubview: vLineView];
//    
//    [vLineView.contentView makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view.left).offset( 50 );
//        make.top.equalTo(self.view.top).offset(50);
//    }];

    
//    UIView * view3= [UIView new];
//    view3.backgroundColor = [UIColor yellowColor];
    
    //[vLineView addView:view3 size:CGSizeMake(50, 50) hAlign:HAlignLeft hOffset:0 AtIndex:1 padding:50 addPaddingType:PaddingTypeBeforeAfter];
    //[hLineView deleteViewAtIndex:1 leftPaddingType:PaddingTypeAfter];

//    UIImageView * imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
//    [self.view addSubview:imgView];
//    [imgView setImageWithURL:[NSURL URLWithString:@"http://img2.xxh.cc:8080/images/eschool/ZTT_1449029876979_image.png"]];
    

//    AutoSizeLabel * label = [AutoSizeLabel new];
//    label.numberOfLines=0;
//    label.text = @"中文Block的实际行为和Function很像，最大的差别是在可以存取同一个Scope的变量值。Block实体形式如下";
//    [self.view addSubview:label];
//    [label makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(100);
//        make.top.equalTo(100);
//        make.width.equalTo(100);
//    }];
   // CGSize size =[label autoSizeAfterMasonry];
//    CGSize size =[AutoSizeView viewAutoSizeWithView:label autoLayout:^(UIView *view) {
//
//    }];
//    __block UILabel * label;
//
//    CGSize size =[AutoSizeView viewAutoSizeWithInit:^UIView *{
//        label = [UILabel new];
//        label.numberOfLines=0;
//        label.text = @"中文Block的实际行为和Function很像，最大的差别是在可以存取同一个Scope的变量值。Block实体形式如下";
//        return label;
//    } frame:CGRectMake(100, 100, 100, -1) superView:self.view realBuild:YES];
//    
//    CGSize labelSize = label.frame.size;
//    CGSize size2= [AutoSizeView getView].frame.size;
//    
//    NSLog(@"label%@",label);
//    NSLog(@"getView%@",[AutoSizeView getView]);
    
//            UILabel * label = [UILabel new];
//            label.numberOfLines=0;
//            label.text = @"中文Block的实际行为和Function很像，最大的差别是在可以存取同一个Scope的变量值。Block实体形式如下";
//    
//            [label autoSizeWithSuperView:self.view autoLayout:^{
//                    [label makeConstraints:^(MASConstraintMaker *make) {
//                        make.left.equalTo(100);
//                        make.top.equalTo(100);
//                        addObject:make.width.equalTo(100);
//                    }];
//            }];
//    ViewContainLabel* view = [ViewContainLabel new];
//    [self.view addSubview:view];
//    
//    [view makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(0);
//        make.top.equalTo(0);
//    }];
    
}







@end
