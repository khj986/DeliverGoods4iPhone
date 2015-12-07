//
//  ListCellLine.m
//  DeliverGoods4iPhone
//
//  Created by ztt on 15/11/7.
//  Copyright © 2015年 ztt. All rights reserved.
//

#import "VerticalLineView.h"
#import "Prefix.h"

@interface VerticalLineView(){

}

@property (nonatomic,strong)  NSMutableArray<MASConstraint*>* hAlignConstraints;
@property (nonatomic,strong)  NSMutableArray<MASConstraint*>* contentVConstraints;
@property (nonatomic,strong)  NSMutableArray<MASConstraint*>* vConstraints;

@end

@implementation VerticalLineView


-(instancetype) initWithViews:(NSArray<UIView*>*)views sizes:(NSArray<NSValue*>*)sizes paddings:(NSArray<NSNumber*>*)paddings hAligns:(NSArray<NSNumber*>*)hAligns hOffsets:(NSArray<NSNumber*>*)hOffsets edgeImage:(nullable UIImage*)edgeImage edgeColor:(nullable UIColor*)edgeColor edgeInsets:(UIEdgeInsets)edgeInsets edgeWidths:(UIEdgeInsets)edgeWidths{
    
    NSAssert(views.count == sizes.count, @"views,sizes数量不匹配");
    NSAssert(hAligns.count == sizes.count, @"hAligns,sizes数量不匹配");
    NSAssert(sizes.count-1 == paddings.count, @"sizes,paddings数量不匹配");
    
    _viewCount = sizes.count;
    _views = [NSMutableArray arrayWithArray:views];
    _sizes = [NSMutableArray arrayWithArray:sizes];
    _paddings = [NSMutableArray arrayWithArray:paddings];
    _hAligns = [NSMutableArray arrayWithArray:hAligns];
    _hOffsets = [NSMutableArray arrayWithArray:hOffsets];
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
        
        [self setSizes:_sizes paddings:paddings hAligns:hAligns hOffsets:hOffsets];

        [self setEdgeImage:edgeImage edgeColor:edgeColor edgeInsets:edgeInsets edgeWidths:edgeWidths];
        

    }
    return self;

}



-(instancetype) initWithViews:(NSArray<UIView*>*)views sizes:(NSArray<NSValue*>*)sizes paddings:(NSArray<NSNumber*>*)paddings hAligns:(NSArray<NSNumber*>*)hAligns hOffsets:(NSArray<NSNumber*>*)hOffsets{  
    

    
    return [self initWithViews:views sizes:sizes paddings:paddings hAligns:hAligns hOffsets:hOffsets edgeImage:nil edgeColor:nil edgeInsets:UIEdgeInsetsZero edgeWidths:UIEdgeInsetsZero];
}



//返回YES表示未超出最大宽度
-(BOOL)addLastView:(UIView *)view size:(CGSize)size fitMaxHeight:(float)maxHeight{
    
    float allHeight = self.contentSize.height+self.edgeInsets.top+self.edgeInsets.bottom+self.edgeWidths.top+self.edgeWidths.bottom;
    if( allHeight+size.height >maxHeight ){
        return NO;
    }else{
        return YES;
    }
}

-(void)setSizes:(NSArray<NSValue*>*)sizes paddings:(NSArray<NSNumber*>*)paddings hAligns:(NSArray<NSNumber*>*)hAligns hOffsets:(NSArray<NSNumber*>*)hOffsets{
    
    NSAssert(_viewCount == sizes.count, @"sizes数量不匹配");
    NSAssert(_viewCount == hAligns.count, @"hAligns数量不匹配");
    NSAssert(_viewCount == hOffsets.count, @"hOffsets数量不匹配");
    NSAssert(_viewCount-1 == paddings.count, @"paddings数量不匹配");
    
    _sizes = [NSMutableArray arrayWithArray:sizes];
    _paddings = [NSMutableArray arrayWithArray:paddings];
    _hAligns = [NSMutableArray arrayWithArray:hAligns];
    _hOffsets = [NSMutableArray arrayWithArray:hOffsets];
    
    float contentHMax =0;
    float heightSum=0;
    float paddingSum=0;
    for( int i=0;i<_viewCount;i++ ){
        if( [_sizes[i] CGSizeValue].width  >contentHMax ){
            contentHMax = [_sizes[i] CGSizeValue].width;
        }
        heightSum += [_sizes[i] CGSizeValue].height;
        if( i!= _viewCount-1 ){
            paddingSum += paddings[i].floatValue;
        }
       
    }

    self.contentSize = CGSizeMake(contentHMax, heightSum+paddingSum);
    
    _hAlignConstraints = [NSMutableArray array];
    _vConstraints =[NSMutableArray array];
    _contentVConstraints = [NSMutableArray array];
    for( int i=0;i<_viewCount;i++ ){
        
        [_views[i] mas_remakeConstraints:^(MASConstraintMaker *make) {
            if(  hAligns[i].integerValue == HAlignLeft ){
                [_hAlignConstraints addObject:make.left.equalTo( contentView.left ).offset(hOffsets[i].floatValue )];
            }else if(  hAligns[i].integerValue == HAlignCenter ){
                [_hAlignConstraints addObject:make.centerX.equalTo( contentView.centerX ).offset( hOffsets[i].floatValue )];
            }else if(  hAligns[i].integerValue == HAlignRight ){
                [_hAlignConstraints addObject:make.right.equalTo( contentView.right ).offset( hOffsets[i].floatValue )];
            }else{
                [_hAlignConstraints addObject:make.left.equalTo( contentView.left ).offset(hOffsets[i].floatValue )];
            }
            

            if(i!=0){
              [_vConstraints addObject:  make.top.equalTo( _views[i-1].bottom ).offset( _paddings[i-1].floatValue )];
            }

            
            make.width.equalTo( [_sizes[i] CGSizeValue].width );
            make.height.equalTo( [_sizes[i] CGSizeValue].height );
        }];
        
    }
    
    [contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
         [_contentVConstraints addObject: make.top.equalTo( _views[0].top )];
        [_contentVConstraints addObject: make.bottom.equalTo( _views[_viewCount-1].bottom )];

        make.width.equalTo(self.contentSize.width);
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
    
    float height = self.contentSize.height;
    if( index == 0 ){
        height = self.contentSize.height - _sizes[index].CGSizeValue.height - _paddings[0].floatValue;
        [_paddings removeObjectAtIndex:index ];
        [_vConstraints removeObjectAtIndex:index];
    }else if( index == _viewCount-1 ){
        height = self.contentSize.height - _sizes[index].CGSizeValue.height - _paddings[index-1].floatValue;
        [_paddings removeObjectAtIndex:index-1 ];
        [_vConstraints removeObjectAtIndex:index-1];
    }else{
        [_paddings replaceObjectAtIndex:index-1 withObject:[NSNumber numberWithFloat:_paddings[index-1 ].floatValue +_paddings[index].floatValue]];
        [_paddings removeObjectAtIndex:index];
        height = self.contentSize.height - _sizes[index].CGSizeValue.height ;
        [laterView mas_makeConstraints:^(MASConstraintMaker *make) {
            [_vConstraints replaceObjectAtIndex:index withObject:make.top.equalTo( preView.bottom ).offset( _paddings[index-1].floatValue)];
        }];
    }
    
    float contentHMax =0;
    for( int i=0;i<_viewCount;i++ ){
        if(  [_sizes[i] CGSizeValue].width  >contentHMax ){
            if( i!=index ){
                contentHMax = [_sizes[i] CGSizeValue].width;
            }
        }
    }
    self.contentSize = CGSizeMake(contentHMax,height);
    
    //contentView首尾约束
    if( index ==0 ){
        [_contentVConstraints[0] uninstall];
        [contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            [_contentVConstraints replaceObjectAtIndex:0 withObject:make.top.equalTo( laterView.top )];
            make.width.equalTo(self.contentSize.width);
        }];
    }
    if( index == _viewCount-1 ){
        [_contentVConstraints[1] uninstall];
        [contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            [_contentVConstraints  replaceObjectAtIndex:1 withObject:make.bottom.equalTo( preView.bottom )];
           make.width.equalTo(self.contentSize.width);
        }];
    }
    
    
    UIView * view = _views[index];
    [view removeFromSuperview];
    _viewCount--;
    [_views removeObjectAtIndex:index];
    [_sizes removeObjectAtIndex:index];
    [_hAligns removeObjectAtIndex:index];
    [_hOffsets removeObjectAtIndex:index];
    
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

-(void)addView:(UIView *)view size:(CGSize)size hAlign:(HAlign)hAlign hOffset:(float)hOffset AtIndex:(int)index{
    if( index > _viewCount || index<0 ){
        return;
    }
    [self addSubview:view];
    
    _viewCount +=1;
    [_views insertObject:view atIndex:index];
    [_sizes insertObject:[NSValue valueWithCGSize:size] atIndex:index];

    [_hAligns insertObject:[NSNumber numberWithInteger:hAlign] atIndex:index];
    [_hOffsets insertObject:[NSNumber numberWithFloat:hOffset] atIndex:index];
    
    float height = self.contentSize.height;
    if( index == 0 ){
        [_paddings insertObject:[NSNumber numberWithFloat:0]  atIndex:index];
         height = self.contentSize.height+size.height;
    }else if( index == _viewCount-1 ){
        [_paddings insertObject:[NSNumber numberWithFloat:0]  atIndex:index-1];
         height = self.contentSize.height+size.height;
    }else{
        [_paddings insertObject:[NSNumber numberWithFloat:_paddings[index-1].floatValue] atIndex:index];
        height = self.contentSize.height+size.height + _paddings[index-1].floatValue;
    }

    
    float contentHMax =0;
    for( int i=0;i<_viewCount;i++ ){
        if( [_sizes[i] CGSizeValue].width  >contentHMax ){
            contentHMax = [_sizes[i] CGSizeValue].width;
        }
    }

    self.contentSize = CGSizeMake(contentHMax,height);

    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        if(  hAlign == HAlignLeft ){
            [_hAlignConstraints insertObject:make.left.equalTo( contentView.left ).offset(hOffset ) atIndex:index ];
        }else if(  hAlign == HAlignCenter ){
            [_hAlignConstraints insertObject:make.centerX.equalTo( contentView.centerX ).offset( hOffset ) atIndex:index ];
        }else if(  hAlign == HAlignRight ){
            [_hAlignConstraints insertObject:make.right.equalTo( contentView.right ).offset( hOffset ) atIndex:index ];
        }else{
            [_hAlignConstraints insertObject:make.left.equalTo( contentView.left ).offset(hOffset ) atIndex:index];
        }
        
        if( index!= 0 ){
            [_vConstraints insertObject: make.top.equalTo( _views[index-1].bottom ).offset( _paddings[index-1].floatValue) atIndex:index-1];
        }
        
        make.width.equalTo( size.width );
        make.height.equalTo( size.height );
        
    }];
    
    if( index==_viewCount-1 ){
        
    }else if(index == 0){
        UIView * oldView = _views[1];
        [oldView mas_makeConstraints:^(MASConstraintMaker *make) {
            [_vConstraints insertObject: make.top.equalTo( _views[0].bottom ).offset( _paddings[0].floatValue) atIndex:0];
        }];
    }else{
        [_vConstraints[index] uninstall];
        UIView * oldView = _views[index+1];
        [oldView mas_makeConstraints:^(MASConstraintMaker *make) {
            [_vConstraints replaceObjectAtIndex:index withObject:make.top.equalTo( _views[index].bottom ).offset( _paddings[index].floatValue)];
        }];
    }
    //contentView首尾约束
    if( index ==0 ){
        [_contentVConstraints[0] uninstall];
        [contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            [_contentVConstraints replaceObjectAtIndex:0 withObject:make.top.equalTo( _views[0].top )];
            make.width.equalTo(self.contentSize.width);
        }];
    }
    if( index == _viewCount-1 ){
    [_contentVConstraints[1] uninstall];
        [contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            [_contentVConstraints  replaceObjectAtIndex:1 withObject:make.bottom.equalTo( _views[_viewCount-1].bottom )];
            make.width.equalTo(self.contentSize.width);
        }];
    }
}

-(void)addView:(UIView *)view size:(CGSize)size hAlign:(HAlign)hAlign hOffset:(float)hOffset AtIndex:(int)index padding:(float)padding addPaddingType:(PaddingType)paddingType{
    
    [self addView:view size:size hAlign:hAlign hOffset:hOffset AtIndex:index];
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
    
    float hMax = self.contentSize.width;
    if( size.width >self.contentSize.width ){
        hMax = size.width;
    }
    self.contentSize = CGSizeMake(hMax, self.contentSize.height - trashSize.height+size.height);
    
    [contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.contentSize.width);
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
       [_vConstraints replaceObjectAtIndex:index withObject:make.top.equalTo( _views[index].bottom ).offset( padding )];
    }];
    
    self.contentSize = CGSizeMake(self.contentSize.width, self.contentSize.height - trashPadding+ padding);

    
}

-(void)setHAlign:(HAlign)hAlign hOffset:(float)hOffset AtIndex:(int)index{
    if( index > _viewCount-1 || index<0 ){
        return;
    }
    [_hAligns replaceObjectAtIndex:index withObject:[NSNumber numberWithInteger:hAlign]];
    [_hOffsets replaceObjectAtIndex:index withObject:[NSNumber numberWithFloat:hOffset]];
    
    UIView * view = _views[index];
    [_hAlignConstraints[index] uninstall];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        if(  hAlign == HAlignLeft ){
            [_hAlignConstraints replaceObjectAtIndex:index withObject:make.left.equalTo( contentView.left ).offset(hOffset )];
        }else if(  hAlign == HAlignCenter ){
            [_hAlignConstraints replaceObjectAtIndex:index withObject: make.centerX.equalTo( contentView.centerX ).offset( hOffset )];
        }else if(  hAlign == HAlignRight ){
            [_hAlignConstraints replaceObjectAtIndex:index withObject: make.right.equalTo( contentView.right ).offset( hOffset )];
        }else{
            [_hAlignConstraints replaceObjectAtIndex:index withObject:make.left.equalTo( contentView.left ).offset(hOffset )];
        }
    }];
}

@end
