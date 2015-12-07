


#import "Prefix.h"
#import "DetailCell.h"
#import "TitleContentMultiLine.h"
#import "DeliveryInfoModel.h"
#import "DeliveryFlow.h"
#import "FlowLine.h"
#import "Constant.h"

//static float MinFlowHeight = 40;
static float PaddingEdgeX  ;

@interface DetailCell (){
    
}

@property (nonatomic,strong) UIImageView *background;
@property (nonatomic,strong) NSMutableArray * labelLines;
//@property (nonatomic ,strong) DeliveryFlow* flow;
@property (nonatomic,strong) NSMutableArray * flowLines;

@end

@implementation DetailCell

//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
//{
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    
//    if (nil != self) {
//       // [self setupView];
//    }
//    
//    return self;
//}

/**
 *  初始化视图.
 */
- (void) setupView
{
    self.background = XYColor(245, 248, 249, 1);
    self.contentView.backgroundColor = XYColor(245, 248, 249, 1);
    
  

    
    UIImage * img = [UIImage imageNamed:@"1"];
    _background = [[UIImageView alloc]initWithImage:img];
    [self.contentView addSubview:_background];
    
    [_background mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(0);
        make.height.mas_equalTo(_background.width).multipliedBy(img.size.height/img.size.width);
        make.width.mas_equalTo(ScreenW);
    }];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
}

- (void)setModel:(DeliveryInfoModel *)model
{
    _model = model;
    

    _background =nil;
    [self setupView];
    
    [_labelLines enumerateObjectsUsingBlock:^(TitleContentMultiLine *  obj, NSUInteger idx, BOOL *  stop) {
        [obj removeFromSuperview];
        
    }];
    [_labelLines removeAllObjects];
    
    _labelLines  = [NSMutableArray array];
    
    
    [_flowLines enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
        
    }];
    [_flowLines removeAllObjects];
    _flowLines = [NSMutableArray array];
    
    
    
    if( _model.index<3 ){
        [self setupMultiLabels];
        
    }
    else if(_model.index == 3){
        [self setupFlow];
    }
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    


}

-(void)setupMultiLabels{
    
    PaddingEdgeX = 28*ScaleX;
    
    NSMutableArray * titles = [self buildTitles];
    
    NSMutableArray * contents = [self buildContents];
    
    int num = titles.count;
    
    
    
    for( int i=0;i<num;i++ ){
        TitleContentMultiLine * line = [[TitleContentMultiLine alloc]initTitle:titles[i] andContent:contents[i] withFontHeight:CONST.kLineHeight andLineWidth:ScreenW-2*CONST.ScaleXEdge];
        [_background addSubview:line];
        [_labelLines addObject:line];
        
        //float offsetH = _paddingEdge + i*(_paddingMiddle+_lineHeight);
        if( i==0 ){
//            [line mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.top.mas_equalTo(_background.top).offset( _paddingEdge );
//                make.left.mas_equalTo(_background);
//            }];
            //line.layer.position = CGPointMake(0, _paddingEdge);
            line.frame = CGRectMake(CONST.ScaleXEdge, CONST.ScaleYEdge, line.bounds.size.width-2*CONST.ScaleXEdge, line.bounds.size.height);
        }else{
            TitleContentMultiLine* lineLast = _labelLines[i-1];
            CGRect rect = lineLast.frame;
//            [line mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.top.mas_equalTo(_background).offset(CGRectGetMaxY( lineLast.frame));
//                make.left.mas_equalTo(_background);
//            }];
            //line.layer.position = CGPointMake(0, CGRectGetMaxY( lineLast.frame));
            line.frame = CGRectMake(CONST.ScaleXEdge, CGRectGetMaxY( lineLast.frame), line.bounds.size.width-2*CONST.ScaleXEdge, line.bounds.size.height);
        }
        
        //[line setNeedsLayout];
        //[line layoutIfNeeded];

    }
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    [_background mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo( CGRectGetMaxY( ((TitleContentMultiLine*)_labelLines.lastObject).frame) +CONST.ScaleYEdge  );
        make.top.left.mas_equalTo(0);
        make.width.mas_equalTo(ScreenW);
    }];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    
    
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(0);
        make.width.mas_equalTo(ScreenW);
        make.height.mas_equalTo(_background.bounds.size.height);
    }];
    
    
}

//-(void)setupLabels{
//    
//
//    
//    NSMutableArray * titles = [self buildTitles];
//    
//    NSMutableArray * contents = [self buildContents];
//    
//    int num = titles.count;
//    
//    
//    
//    for( int i=0;i<num;i++ ){
//        TitleContentLine * line = [[TitleContentLine alloc]initTitle:titles[i] andContent:contents[i] withHeight:_lineHeight];
//        [_background addSubview:line];
//        [_labelLines addObject:line];
//        
//        float offsetH = _paddingEdge + i*(_paddingMiddle+_lineHeight);
//        [line mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(_background.top).offset( offsetH );
//            make.height.equalTo(_lineHeight);
//            make.left.mas_equalTo(MasonryRight(_background)).multipliedBy(28/640.0);
//            //make.right.mas_equalTo(MasonryRight(self.contentView)).multipliedBy(1-28/640.0);
//            make.centerX.mas_equalTo(_background);
//        }];
//    }
//    
//    [self setNeedsLayout];
//    [self layoutIfNeeded];
//    
//    [_background mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo( CGRectGetMaxY( ((TitleContentLine*)_labelLines.lastObject).frame) +_paddingEdge  );
//        make.top.left.mas_equalTo(0);
//        make.width.mas_equalTo(ScreenW);
//    }];
//    
//    [self setNeedsLayout];
//    [self layoutIfNeeded];
//    
//
//    
//    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.mas_equalTo(0);
//        make.width.mas_equalTo(ScreenW);
//        make.height.mas_equalTo(_background.bounds.size.height);
//    }];
//
//    
//}

-(void)setupFlow{
    
    NSMutableArray * flowModel =  _model.flow.arrayFlow;
    if( !flowModel ){
        return;
    }
    
    UIView * lastView = nil;
    
    for( int i=0;i<flowModel.count;i++ ){
        DeliveryNode * nodeModel = flowModel[i];
        
        FlowLine * line = [[FlowLine alloc]initTime:nodeModel.uploadTime andContent:nodeModel.logicStatus withFontHeight:CONST.kLineHeight];
        [_background addSubview:line];
        [_flowLines addObject:line];
        if( i== 0 ){
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(_background).offset(CONST.ScaleXPaddingFlow);
                make.left.right.mas_equalTo(_background);
                //make.height.mas_greaterThanOrEqualTo(MinFlowHeight);
                //make.left.mas_equalTo(line.frame.origin.x);
                //make.size.mas_equalTo(line.frame.size);
            }];
        }else{
            FlowLine* lineLast = _flowLines[i-1];
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(_background).offset(CGRectGetMaxY( lineLast.frame));
                make.left.right.mas_equalTo(_background);
               // make.height.mas_greaterThanOrEqualTo(MinFlowHeight);
                //make.left.mas_equalTo(line.frame.origin.x);
                //make.size.mas_equalTo(line.frame.size);
            }];
        }

        [line setNeedsLayout];
        [line layoutIfNeeded];
        
        if( i== flowModel.count-1 ){
            [_flowLines[i] setLastLine];

        }
    }
    
    [_background mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo( CGRectGetMaxY( ((FlowLine*)_flowLines.lastObject).frame) +CONST.ScaleXPaddingFlow  );
        make.top.left.mas_equalTo(0);
        make.width.mas_equalTo(ScreenW);
    }];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(0);
        make.width.mas_equalTo(ScreenW);
        make.height.mas_equalTo(_background.bounds.size.height);
    }];
    

}
    
-(NSMutableArray* )buildTitles{
    
    if(_model.index == 0){
        return  [NSMutableArray arrayWithArray:@[@"押运单号:",@"客户名称:" ]];
    }else if(_model.index == 1){
        return  [NSMutableArray arrayWithArray:@[@"发货日期:",@"要求到货日期:" ]];
    }else if(_model.index == 2){
        return  [NSMutableArray arrayWithArray:@[@"收货人:",@"收获地址:",@"收获人电话:",@"收货方名称:",@"回单需带回:" ]];
    }else{
        return nil;
    }
}

-(NSMutableArray * )buildContents{
    
    if(_model.index == 0){
        return  [NSMutableArray arrayWithArray:@[_model.staticInfo.escortNo,_model.staticInfo.customName ]];
    }else if(_model.index == 1){
        return  [NSMutableArray arrayWithArray:@[_model.staticInfo.deliveryDate,_model.staticInfo.demandArrivalDate]];
    }else if(_model.index == 2){
        return  [NSMutableArray arrayWithArray:@[_model.staticInfo.consignee,_model.staticInfo.deliveryAddress,_model.staticInfo.consigneePhoneNumber,_model.staticInfo.receivingPartyName,_model.staticInfo.receipt]];
    }else{
        return nil;
    }
}


-(void) backgroundClicked{
    self.buttonBlock();
}

@end
