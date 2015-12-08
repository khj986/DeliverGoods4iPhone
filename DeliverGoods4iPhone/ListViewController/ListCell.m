


#import "Prefix.h"
#import "ListCell.h"
//#import "ImageLabelLine2.h"
#import "ImageAttributedLabel.h"
#import "ListTableviewController.h"
#import "Constant.h"



static float _lineHeight =25;
static float _paddingEdge =5;
static float _paddingMiddle =2;

@interface ListCell (){
    CGSize indexSize;
}
@property (nonatomic,strong) UIImageView *background;
@property (nonatomic,strong) NSMutableArray * cellLines;
@property (nonatomic,strong) UILabel * indexNum;
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
    //self.backgroundColor = [UIColor redColor];
    //self.contentView.backgroundColor = [UIColor redColor];
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
    UIImageView * indexImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_list_num_bg"]] ;
    [self.contentView addSubview: indexImg];
    [indexImg makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(CONST.ScaleXEdge);
        make.centerY.equalTo(self.contentView);
        make.width.height.equalTo( MasonryWidth(self.contentView) ).multipliedBy(0.06);
    }];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    
    _indexNum= [UILabel new];
    //_indexNum.text = [NSString stringWithFormat:@"%d",_model.index ];
    indexSize = CGSizeMake(indexImg.frame.size.width/1, indexImg.frame.size.height/1);
//    float fontSize = [_indexNum.text fontSizeSingleLineFitsRect:CGRectMake(0, 0, size.width, size.height) attributes:nil];
//    _indexNum.font = [UIFont fontWithName:nil size:fontSize];
    
    [self.contentView addSubview: _indexNum];
    [_indexNum makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(indexImg);
    }];
    
    UIImageView * detailIndicator = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_delivery_list_item_detail"]] ;
    [self.contentView addSubview: detailIndicator];
    [detailIndicator makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-CONST.ScaleXEdge);
        make.centerY.equalTo(self.contentView);
        make.width.height.equalTo( MasonryWidth(self.contentView) ).multipliedBy(0.06);
    }];
    
    _cellLines  = [NSMutableArray array];
    
    //NSArray * imgs = @[@"形状-39",@"形状-40",@"officer"];
    
   NSArray * titles = @[@"押运单号: ",@"客户名称: ",@"发货日期: ",@"要求到货日期: "];
    
//    NSArray * contents = @[_model.cargoName,[[_model.deliveryAddress stringByAppendingString:@"---"] stringByAppendingString:_model.receivingPartyName],_model.transportCompany];
    NSArray *contents = @[@"押运单号: ",@"客户名称: ",@"发货日期: ",@"要求到货日期: "];
    
    int num = titles.count;
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
    
    for( int i=0;i<num;i++ ){
        NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc]initWithString:titles[i] attributes:dictTitle];
        NSMutableAttributedString * content = [[NSMutableAttributedString alloc]initWithString:contents[i] attributes:dictContent];
        [attStr appendAttributedString:content];
        //NSString* str = [titles[i] stringByAppendingString:contents[i]];
        
        //ImageAttributedLabel * line = [[ImageAttributedLabel alloc]initWithImage:[UIImage imageNamed:imgs[i]] andLabelText:attStr];
        ImageAttributedLabel * line = [[ImageAttributedLabel alloc]initWithImage:nil andLabelText:attStr];
        line.heightImage = CONST.kLineHeight;
        line.paddingLabel = CONST.ScaleXPaddingLabel;
        line.paddingImage = CONST.ScaleXPaddingImage;
        line.paddingUnderLine =CONST.ScaleXPaddingUnderline;
        line.underlineHidden =YES;
        [self.contentView addSubview:line];
        [_cellLines addObject:line];
        
        float offsetH = CONST.ScaleYEdge + i*(CONST.ScaleYMiddle+CONST.kLineHeight);
//        if(i!=num-1){
//            line.underlineHidden =YES;
//        }
        
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView.top).offset( offsetH );
            //make.height.equalTo(_lineHeight);
//            make.left.mas_equalTo(MasonryRight(self.contentView)).multipliedBy(CONST.XEdge/640.0);
            make.left.mas_equalTo(indexImg.right).offset(CONST.ScaleXMiddle);
            //make.right.mas_equalTo(MasonryRight(self.contentView)).multipliedBy(1-28/640.0);
            make.right.mas_equalTo(detailIndicator.left);
            //make.centerX.mas_equalTo(self.contentView);
        }];
    }
    
    UIImageView * underline = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"矩形-9"]];
    [self.contentView addSubview:underline];
    [underline mas_makeConstraints:^(MASConstraintMaker *make) {
         make.height.equalTo(1);
        make.left.equalTo(CONST.ScaleXEdge);
        make.right.equalTo(-CONST.ScaleXEdge);
        make.bottom.equalTo(_background.bottom);
    }];

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
    NSArray * titles = @[@"押运单号: ",@"客户名称: ",@"发货日期: ",@"要求到货日期: "];
    
//    NSArray * contents = @[_model.cargoName,[[_model.deliveryAddress stringByAppendingString:@"---"] stringByAppendingString:_model.receivingPartyName],_model.transportCompany];
    NSArray * contents =@[_model.escortNo,_model.customName,_model.deliveryDate,_model.demandArrivalDate];
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
 
    _indexNum.text = [NSString stringWithFormat:@"%d",_model.index+1 ];
    //CGSize size = CGSizeMake(indexImg.frame.size.width/1.4, indexImg.frame.size.height/1.4);
    float fontSize = [_indexNum.text fontSizeSingleLineFitsRect:CGRectMake(0, 0, indexSize.width, indexSize.height) attributes:nil];
    _indexNum.font = [UIFont fontWithName:nil size:fontSize];
    
}



-(void) backgroundClicked{
    
    self.buttonBlock();
}

@end
