


#import "Prefix.h"
#import "ListCell.h"
//#import "ImageLabelLine2.h"
#import "ImageAttributedLabel.h"
#import "ListTableviewController.h"
#import "Constant.h"



static float _lineHeight =25;
static float _paddingEdge =5;
static float _paddingMiddle =2;

@interface ListCell ()
@property (nonatomic,strong) UIImageView *background;
@property (nonatomic,strong) NSMutableArray * cellLines;
@end

@implementation ListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (nil != self) {
        [self setupView];
    }
    
    return self;
}

/**
 *  初始化视图.
 */
- (void) setupView
{
    //self.backgroundColor = XYColor(245, 248, 249, 1);;
    //self.contentView.backgroundColor = XYColor(245, 248, 249, 1);
    self.backgroundColor = [UIColor redColor];
    self.contentView.backgroundColor = [UIColor redColor];
   // self.backgroundColor = [UIColor clearColor];
    // self.contentView.backgroundColor = [UIColor clearColor];
    
    UIImage * img = [UIImage imageNamed:@"3"];
    _background = [[UIImageView alloc]initWithImage:img];

    [self.contentView addSubview:_background];
    
   // UIEdgeInsets padding = UIEdgeInsetsMake(12, 12, 0, 12);
//    [_background mas_makeConstraints:^(MASConstraintMaker *make) {
//        //make.edges.mas_equalTo(self.contentView).insets(padding);
//        make.top.left.right.bottom.mas_equalTo(self.contentView);
//        make.width.mas_equalTo(ScreenW);
//        make.height.mas_equalTo(_background.width).multipliedBy(img.size.height/img.size.width).priorityLow();
//    }];
    
//    [self setNeedsLayout];
//    [self layoutIfNeeded];
    
    _cellLines  = [NSMutableArray array];
    
    NSArray * imgs = @[@"形状-39",@"形状-40",@"officer"];
    
    NSArray * titles = @[@"货物: ",@"路线: ",@"承运商: "];
    
//    NSArray * contents = @[_model.cargoName,[[_model.deliveryAddress stringByAppendingString:@"---"] stringByAppendingString:_model.receivingPartyName],_model.transportCompany];
    NSArray *contents = @[@"货物: ",@"路线: ",@"承运商: "];
    
    int num = imgs.count;
    //    float paddingEdge = 5;
    //    float paddingMiddle = 2;
    //    float height =( self.contentView.frame.size.height - 2*paddingEdge - (num-1)*paddingMiddle )/num;
    // float height= _lineHeight;
    //_lineHeight = [ListTableviewController getLineHeight];
    
    NSDictionary * dictTitle=@{
                               NSForegroundColorAttributeName:[UIColor blackColor]
                               };
    NSDictionary * dictContent=@{
                                 NSForegroundColorAttributeName:XYColor(155, 155, 155, 1)
                                 };
    
    for( int i=0;i<imgs.count;i++ ){
        NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc]initWithString:titles[i] attributes:dictTitle];
        NSMutableAttributedString * content = [[NSMutableAttributedString alloc]initWithString:contents[i] attributes:dictContent];
        [attStr appendAttributedString:content];
        //NSString* str = [titles[i] stringByAppendingString:contents[i]];
        
        ImageAttributedLabel * line = [[ImageAttributedLabel alloc]initWithImage:[UIImage imageNamed:imgs[i]] andLabelText:attStr];
        line.heightImage = CONST.kLineHeight;
        line.paddingLabel = CONST.ScaleXPaddingLabel;
        line.paddingImage = CONST.ScaleXPaddingImage;
        line.paddingUnderLine =CONST.ScaleXPaddingUnderline;
        [self.contentView addSubview:line];
        [_cellLines addObject:line];
        
        float offsetH = CONST.ScaleYEdge + i*(CONST.ScaleYMiddle+CONST.kLineHeight);
        if(i!=imgs.count-1){
            line.underlineHidden =YES;
        }
        
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView.top).offset( offsetH );
            //make.height.equalTo(_lineHeight);
            make.left.mas_equalTo(MasonryRight(self.contentView)).multipliedBy(CONST.XEdge/640.0);
            //make.right.mas_equalTo(MasonryRight(self.contentView)).multipliedBy(1-28/640.0);
            make.centerX.mas_equalTo(self.contentView);
        }];
    }
    
    //((ImageAttributedLabel*)_cellLines.lastObject).underlineHidden = YES;
    
//    [self setNeedsDisplay];
//    [self layoutIfNeeded];
//
//    CGRect lastRect =((ImageAttributedLabel*)_cellLines.lastObject).frame;
//    NSLog( @" lastRectY:%f ",CGRectGetMaxY(lastRect) );
    //    [_background mas_updateConstraints:^(MASConstraintMaker *make) {
    //       //make.top.left.right.mas_equalTo(self.contentView);
    //       // make.bottom.mas_equalTo( ((ImageLabelLine2*)_cellLines.lastObject).bottom  ).offset(0).priorityHigh();
    //        make.height.mas_equalTo( CGRectGetMaxY(lastRect) );
    //    }];
    [_background mas_remakeConstraints:^(MASConstraintMaker *make) {
        //make.height.mas_equalTo(num*_lineHeight+ (num-1)*_paddingMiddle +2*_paddingEdge);
        make.top.left.right.bottom.mas_equalTo(self.contentView);
        make.width.mas_equalTo(ScreenW);
        //make.height.mas_equalTo( CGRectGetMaxY(lastRect) );
        make.bottom.mas_equalTo( ((ImageAttributedLabel*)_cellLines.lastObject).bottom  ).offset(_paddingEdge);
    }];
    // _background.frame =  CGRectMake(0, 0, ScreenW, CGRectGetMaxY(lastRect));
    
}

- (void)setModel:(StaticInfoModel *)model
{
    _model = model;
//
//    _background = nil;
//    [self setupView];
//    
//    [_cellLines enumerateObjectsUsingBlock:^(ImageAttributedLabel *  obj, NSUInteger idx, BOOL *  stop) {
//        [obj removeFromSuperview];
//        
//    }];
//    [_cellLines removeAllObjects];
//    
    NSArray * titles = @[@"货物: ",@"路线: ",@"承运商: "];
    
    NSArray * contents = @[_model.cargoName,[[_model.deliveryAddress stringByAppendingString:@"---"] stringByAppendingString:_model.receivingPartyName],_model.transportCompany];
    
    int num = titles.count;
    
    NSDictionary * dictTitle=@{
                               NSForegroundColorAttributeName:[UIColor blackColor]
                               };
    NSDictionary * dictContent=@{
                                 NSForegroundColorAttributeName:XYColor(155, 155, 155, 1)
                                 };

    for( int i=0;i<num;i++ ){
        NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc]initWithString:titles[i] attributes:dictTitle];
        NSMutableAttributedString * content = [[NSMutableAttributedString alloc]initWithString:contents[i] attributes:dictContent];
        [attStr appendAttributedString:content];
        
        [((ImageAttributedLabel*)_cellLines[i]) resetText:attStr];
    }
 
    
}



-(void) backgroundClicked{
    self.buttonBlock();
}

@end
