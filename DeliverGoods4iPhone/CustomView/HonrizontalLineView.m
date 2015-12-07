//
//  ListCellLine.m
//  DeliverGoods4iPhone
//
//  Created by ztt on 15/11/7.
//  Copyright © 2015年 ztt. All rights reserved.
//

#import "HonrizontalLineView.h"
#import "Prefix.h"

@interface HonrizontalLineView(){

}

@property (nonatomic,strong)  NSMutableArray<MASConstraint*>* vAlignConstraints;
@property (nonatomic,strong)  NSMutableArray<MASConstraint*>* contentHConstraints;
@property (nonatomic,strong)  NSMutableArray<MASConstraint*>* hConstraints;

@end

@implementation HonrizontalLineView


-(instancetype) initWithViews:(NSArray<UIView*>*)views sizes:(NSArray<NSValue*>*)sizes paddings:(NSArray<NSNumber*>*)paddings vAligns:(NSArray<NSNumber*>*)vAligns vOffsets:(NSArray<NSNumber*>*)vOffsets edgeImage:(nullable UIImage*)edgeImage edgeColor:(nullable UIColor*)edgeColor edgeInsets:(UIEdgeInsets)edgeInsets edgeWidths:(UIEdgeInsets)edgeWidths{
    
    NSAssert(views.count == sizes.count, @"views,sizes数量不匹配");
    NSAssert(vAligns.count == sizes.count, @"vAligns,sizes数量不匹配");
    NSAssert(sizes.count-1 == paddings.count, @"sizes,paddings数量不匹配");
    
    _viewCount = sizes.count;
    _views = [NSMutableArray arrayWithArray:views];
    _sizes = [NSMutableArray arrayWithArray:sizes];
    _paddings = [NSMutableArray arrayWithArray:paddings];
    _vAligns = [NSMutableArray arrayWithArray:vAligns];
    _vOffsets = [NSMutableArray arrayWithArray:vOffsets];
    self.edgeImage = edgeImage;
    self.edgeColor = edgeColor;
    self.edgeInsets = edgeInsets;
    self.edgeWidths = edgeWidths;

    
    
    
    if( self = [super init] ){
        
        contentView = [UIView new];
        [self addSubview:contentView];
        for( int i=0;i<_viewCount;i++ ){
            [contentView addSubview:_views[i]];
        }
        
        [self setSizes:_sizes paddings:paddings vAligns:vAligns vOffsets:vOffsets];

        [self setEdgeImage:edgeImage edgeColor:edgeColor edgeInsets:edgeInsets edgeWidths:edgeWidths];
        

    }
    return self;

}




-(instancetype) initWithViews:(NSArray<UIView*>*)views sizes:(NSArray<NSValue*>*)sizes paddings:(NSArray<NSNumber*>*)paddings vAligns:(NSArray<NSNumber*>*)vAligns vOffsets:(NSArray<NSNumber*>*)vOffsets{
    
    return [self initWithViews:views sizes:sizes paddings:paddings vAligns:vAligns vOffsets:vOffsets edgeImage:nil edgeColor:nil edgeInsets:UIEdgeInsetsZero edgeWidths:UIEdgeInsetsZero];
}

//返回YES表示未超出最大宽度
-(BOOL)addLastView:(UIView *)view size:(CGSize)size fitMaxWidth:(float)maxWidth{
    
    float allWidth = self.contentSize.width+self.edgeInsets.left+self.edgeInsets.right+self.edgeWidths.left+self.edgeWidths.right;
    if( allWidth+size.width >maxWidth ){
        return NO;
    }else{
        return YES;
    }
}

-(void)setSizes:(NSArray<NSValue*>*)sizes paddings:(NSArray<NSNumber*>*)paddings vAligns:(NSArray<NSNumber*>*)vAligns vOffsets:(NSArray<NSNumber*>*)vOffsets{
    
    NSAssert(_viewCount == sizes.count, @"sizes数量不匹配");
    NSAssert(_viewCount == vAligns.count, @"vAligns数量不匹配");
    NSAssert(_viewCount == vOffsets.count, @"vOffsets数量不匹配");
    NSAssert(_viewCount-1 == paddings.count, @"paddings数量不匹配");
    
    _sizes = [NSMutableArray arrayWithArray:sizes];
    _paddings = [NSMutableArray arrayWithArray:paddings];
    _vAligns = [NSMutableArray arrayWithArray:vAligns];
    _vOffsets = [NSMutableArray arrayWithArray:vOffsets];
    
    float _contentVMax =0;
    float widthSum=0;
    float paddingSum=0;
    for( int i=0;i<_viewCount;i++ ){
        if( [_sizes[i] CGSizeValue].height  >_contentVMax ){
            _contentVMax = [_sizes[i] CGSizeValue].height;
        }
        widthSum += [_sizes[i] CGSizeValue].width;
        if( i!= _viewCount-1 ){
            paddingSum += paddings[i].floatValue;
        }
       
    }
    
    self.contentSize = CGSizeMake(widthSum+paddingSum, _contentVMax);

    
    _vAlignConstraints = [NSMutableArray array];
    _hConstraints =[NSMutableArray array];
    _contentHConstraints = [NSMutableArray array];
    for( int i=0;i<_viewCount;i++ ){
        
        [_views[i] mas_remakeConstraints:^(MASConstraintMaker *make) {
            if(  vAligns[i].integerValue == VAlignTop ){
                [_vAlignConstraints addObject:make.top.equalTo( contentView.top ).offset(vOffsets[i].floatValue )];
            }else if(  vAligns[i].integerValue == VAlignCenter ){
                [_vAlignConstraints addObject:make.centerY.equalTo( contentView.centerY ).offset( vOffsets[i].floatValue )];
            }else if(  vAligns[i].integerValue == VAlignBottom ){
                [_vAlignConstraints addObject:make.bottom.equalTo( contentView.bottom ).offset( vOffsets[i].floatValue )];
            }else{
                [_vAlignConstraints addObject:make.top.equalTo( contentView.top ).offset(vOffsets[i].floatValue )];
            }
            

            if(i!=0){
              [_hConstraints addObject:  make.left.equalTo( _views[i-1].right ).offset( _paddings[i-1].floatValue )];
            }

            
            make.width.equalTo( [_sizes[i] CGSizeValue].width );
            make.height.equalTo( [_sizes[i] CGSizeValue].height );
        }];
        
    }
    
    [contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
         [_contentHConstraints addObject: make.left.equalTo( _views[0].left )];
        [_contentHConstraints addObject: make.right.equalTo( _views[_viewCount-1].right )];
        make.height.equalTo(self.contentSize.height);
    }];


    
}



-(void)deleteViewAtIndex:(int)index{
    if( index > _viewCount-1 || index<0 ){
        return;
    }
    if( _viewCount == 1 ){
        return;
    }
    UIView * preView;
    UIView * laterView;
    if( index !=0 ){preView = _views[index-1];}
    else{ preView = nil;}
    if(index != _viewCount-1){  laterView = _views[index+1];}
    else{ laterView =nil; }
    
    float width = self.contentSize.width;
    if( index == 0 ){
        width = self.contentSize.width - _sizes[index].CGSizeValue.width - _paddings[0].floatValue;
        [_paddings removeObjectAtIndex:index ];
        [_hConstraints removeObjectAtIndex:index];
    }else if( index == _viewCount-1 ){
        width = self.contentSize.width - _sizes[index].CGSizeValue.width - _paddings[index-1].floatValue;
        [_paddings removeObjectAtIndex:index-1 ];
        [_hConstraints removeObjectAtIndex:index-1];
    }else{
        [_paddings replaceObjectAtIndex:index-1 withObject:[NSNumber numberWithFloat:_paddings[index-1 ].floatValue +_paddings[index].floatValue]];
        [_paddings removeObjectAtIndex:index];
        width = self.contentSize.width - _sizes[index].CGSizeValue.width ;
        [laterView mas_makeConstraints:^(MASConstraintMaker *make) {
            [_hConstraints replaceObjectAtIndex:index withObject:make.left.equalTo( preView.right ).offset( _paddings[index-1].floatValue)];
        }];
    }
    
    float _contentVMax =0;
    for( int i=0;i<_viewCount;i++ ){
        if(  [_sizes[i] CGSizeValue].height  >_contentVMax ){
            if( i!=index ){
                _contentVMax = [_sizes[i] CGSizeValue].height;
            }
        }
    }
    self.contentSize =  CGSizeMake(width, _contentVMax) ;
    
    //contentView首尾约束
    if( index ==0 ){
        [_contentHConstraints[0] uninstall];
        [contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            [_contentHConstraints replaceObjectAtIndex:0 withObject:make.left.equalTo( laterView.left )];
            make.height.equalTo(self.contentSize.height);
        }];
    }
    if( index == _viewCount-1 ){
        [_contentHConstraints[1] uninstall];
        [contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            [_contentHConstraints  replaceObjectAtIndex:1 withObject:make.right.equalTo( preView.right )];
            make.height.equalTo(self.contentSize.height);
        }];
    }
    
    
    UIView * view = _views[index];
    [view removeFromSuperview];
    _viewCount--;
    [_views removeObjectAtIndex:index];
    [_sizes removeObjectAtIndex:index];
    [_vAligns removeObjectAtIndex:index];
    [_vOffsets removeObjectAtIndex:index];
    
}

-(void)deleteViewAtIndex:(int)index leftPaddingType:(PaddingType)paddingType{
    if( index > _viewCount-1 || index<0 ){
        return;
    }
    if( _viewCount == 1 ){
        return;
    }
    float prePadding;
    float laterPadding;
    if( index!=0 ){      prePadding   = _paddings[index-1].floatValue;}
    else{ prePadding = -1; }
    if( index!=_viewCount-1 ){ laterPadding =  _paddings[index].floatValue;}
    else{ laterPadding = -1; }
    
    [self deleteViewAtIndex:index];
    if( paddingType == PaddingTypeZero ){
        if( index!=0 && index!=_viewCount ){
            [self setPadding:0 AtIndex:index-1];
        }
    }else if( paddingType == PaddingTypeBeforeAfter ){

    }else if( paddingType == PaddingTypeBefore  ){
        if( index!=0 && index!=_viewCount ){
            [self setPadding:prePadding AtIndex:index-1];
        }
    }else if( paddingType == PaddingTypeAfter ){
        if( index!=0 && index!=_viewCount ){
            [self setPadding:laterPadding AtIndex:index-1];
        }
    }
}

-(void)addView:(UIView *)view size:(CGSize)size vAlign:(VAlign)vAlign vOffset:(float)vOffset AtIndex:(int)index{
    if( index > _viewCount || index<0 ){
        return;
    }
    [self addSubview:view];
    
    _viewCount +=1;
    [_views insertObject:view atIndex:index];
    [_sizes insertObject:[NSValue valueWithCGSize:size] atIndex:index];

    [_vAligns insertObject:[NSNumber numberWithInteger:vAlign] atIndex:index];
    [_vOffsets insertObject:[NSNumber numberWithFloat:vOffset] atIndex:index];
    
    float width =self.contentSize.width;
    if( index == 0 ){
        [_paddings insertObject:[NSNumber numberWithFloat:0]  atIndex:index];
         width = self.contentSize.width+size.width;
    }else if( index == _viewCount-1 ){
        [_paddings insertObject:[NSNumber numberWithFloat:0]  atIndex:index-1];
         width = self.contentSize.width+size.width;
    }else{
        [_paddings insertObject:[NSNumber numberWithFloat:_paddings[index-1].floatValue] atIndex:index];
        width = self.contentSize.width+size.width + _paddings[index-1].floatValue;
    }

    
    float _contentVMax =0;
    for( int i=0;i<_viewCount;i++ ){
        if( [_sizes[i] CGSizeValue].height  >_contentVMax ){
            _contentVMax = [_sizes[i] CGSizeValue].height;
        }
    }

    self.contentSize = CGSizeMake(width, _contentVMax) ;

    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        if(  vAlign == VAlignTop ){
            [_vAlignConstraints insertObject:make.top.equalTo( contentView.top ).offset(vOffset ) atIndex:index ];
        }else if(  vAlign == VAlignCenter ){
            [_vAlignConstraints insertObject:make.centerY.equalTo( contentView.centerY ).offset( vOffset ) atIndex:index ];
        }else if(  vAlign == VAlignBottom ){
            [_vAlignConstraints insertObject:make.bottom.equalTo( contentView.bottom ).offset( vOffset ) atIndex:index ];
        }else{
            [_vAlignConstraints insertObject:make.top.equalTo( contentView.top ).offset(vOffset ) atIndex:index];
        }
        
        if( index!= 0 ){
            [_hConstraints insertObject: make.left.equalTo( _views[index-1].right ).offset( _paddings[index-1].floatValue) atIndex:index-1];
        }
        
        make.width.equalTo( size.width );
        make.height.equalTo( size.height );
        
    }];
    
    if( index==_viewCount-1 ){
        
    }else if(index == 0){
        UIView * oldView = _views[1];
        [oldView mas_makeConstraints:^(MASConstraintMaker *make) {
            [_hConstraints insertObject: make.left.equalTo( _views[0].right ).offset( _paddings[0].floatValue) atIndex:0];
        }];
    }else{
        [_hConstraints[index] uninstall];
        UIView * oldView = _views[index+1];
        [oldView mas_makeConstraints:^(MASConstraintMaker *make) {
            [_hConstraints replaceObjectAtIndex:index withObject:make.left.equalTo( _views[index].right ).offset( _paddings[index].floatValue)];
        }];
    }
    //contentView首尾约束
    if( index ==0 ){
        [_contentHConstraints[0] uninstall];
        [contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            [_contentHConstraints replaceObjectAtIndex:0 withObject:make.left.equalTo( _views[0].left )];
            make.height.equalTo(self.contentSize.height);
        }];
    }
    if( index == _viewCount-1 ){
    [_contentHConstraints[1] uninstall];
        [contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            [_contentHConstraints  replaceObjectAtIndex:1 withObject:make.right.equalTo( _views[_viewCount-1].right )];
            make.height.equalTo(self.contentSize.height);
        }];
    }
}

-(void)addView:(UIView *)view size:(CGSize)size vAlign:(VAlign)vAlign vOffset:(float)vOffset AtIndex:(int)index padding:(float)padding addPaddingType:(PaddingType)paddingType{
    
    [self addView:view size:size vAlign:vAlign vOffset:vOffset AtIndex:index];
    if( paddingType == PaddingTypeZero ){
        if( index!=0 && index!=_viewCount-1 ){
            [self setPadding:0 AtIndex:index-1];
            [self setPadding:0 AtIndex:index];
        }
    }else if( paddingType == PaddingTypeBeforeAfter ){
        if( index!=0 && index!=_viewCount-1  ){
            [self setPadding:padding AtIndex:index-1];
            [self setPadding:padding AtIndex:index];
        }else if( index == 0 ){
            [self setPadding:padding AtIndex:index];
        }else{
            [self setPadding:padding AtIndex:index-1];
        }
        
    }else if( paddingType == PaddingTypeBefore  ){
        if( index!=0  ){
            [self setPadding:padding AtIndex:index-1];
        }else{
            [self setPadding:padding AtIndex:index];
        }
    }else if( paddingType == PaddingTypeAfter ){
        if(  index!=_viewCount-1 ){
            [self setPadding:padding AtIndex:index];
        }else{
            [self setPadding:padding AtIndex:index-1];
        }
    }

}

-(void)setSize:(CGSize)size AtIndex:(int)index{
    if( index > _viewCount-1 || index<0 ){
        return;
    }
    CGSize trashSize = [_sizes[index] CGSizeValue];
    [_sizes replaceObjectAtIndex:index withObject:[NSValue valueWithCGSize:size]];
    
    UIView * view = _views[index];
    [view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo( size.width );
        make.height.equalTo( size.height );
    }];
    
    float vMax = self.contentSize.height;
    if( size.height >self.contentSize.height ){
        vMax = size.height;
    }
    self.contentSize = CGSizeMake(self.contentSize.width - trashSize.width+size.width, vMax);
    
    [contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.contentSize.height);
    }];
}

-(void)setPadding:(float)padding AtIndex:(int)index{
    if( index > _viewCount-2 || index<0 ){
        return;
    }
    float trashPadding = _paddings[index].floatValue;
    [_paddings replaceObjectAtIndex:index withObject:[NSNumber numberWithFloat:padding]];
    
    UIView * view = _views[index+1];
    [view mas_updateConstraints:^(MASConstraintMaker *make) {
       [_hConstraints replaceObjectAtIndex:index withObject:make.left.equalTo( _views[index].right ).offset( padding )];
    }];
    
    self.contentSize = CGSizeMake(self.contentSize.width - trashPadding+ padding, self.contentSize.height);

    
}

-(void)setVAlign:(VAlign)vAlign vOffset:(float)vOffset AtIndex:(int)index{
    if( index > _viewCount-1 || index<0 ){
        return;
    }
    [_vAligns replaceObjectAtIndex:index withObject:[NSNumber numberWithInteger:vAlign]];
    [_vOffsets replaceObjectAtIndex:index withObject:[NSNumber numberWithFloat:vOffset]];
    
    UIView * view = _views[index];
    [_vAlignConstraints[index] uninstall];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        if(  vAlign == VAlignTop ){
            [_vAlignConstraints replaceObjectAtIndex:index withObject:make.top.equalTo( contentView.top ).offset(vOffset )];
        }else if(  vAlign == VAlignCenter ){
            [_vAlignConstraints replaceObjectAtIndex:index withObject: make.centerY.equalTo( contentView.centerY ).offset( vOffset )];
        }else if(  vAlign == VAlignBottom ){
            [_vAlignConstraints replaceObjectAtIndex:index withObject: make.bottom.equalTo( contentView.bottom ).offset( vOffset )];
        }else{
            [_vAlignConstraints replaceObjectAtIndex:index withObject:make.top.equalTo( contentView.top ).offset(vOffset )];
        }
    }];
}



@end
