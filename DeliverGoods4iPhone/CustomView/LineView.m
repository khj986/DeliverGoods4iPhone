//
//  ListCellLine.m
//  DeliverGoods4iPhone
//
//  Created by ztt on 15/11/7.
//  Copyright © 2015年 ztt. All rights reserved.
//

#import "LineView.h"
#import "Prefix.h"

@interface LineView(){

}

@property (nonatomic,strong) UIImage * edgeImageRec;
@property (nonatomic,strong) UIColor * edgeColorRec;
@property (nonatomic) UIEdgeInsets edgeInsetsRec;
@property (nonatomic) UIEdgeInsets edgeWidthsRec;

@end

@implementation LineView


+(int)getViewCountWithActualSizes:(NSArray<NSValue*>*)sizes paddings:(NSArray<NSNumber*>*)paddings fromIndex:(int)index fitMaxWidth:(float)maxWidth {
    
    
    NSAssert(sizes.count-1 == paddings.count, @"sizes,paddings数量不匹配");
    float num = sizes.count;
    
    float widthSum=0;
    int i;
    int lastIndex;
    for(i = index;i<num;i++ ){
        if( i!=index ){
            widthSum+=paddings[i-1].floatValue;
        }
        widthSum+=[sizes[i] CGSizeValue].width;
        if( widthSum > maxWidth){
            break;
        }
    }
    if( i!=num ){
        lastIndex = i-1;
    }else{
        lastIndex = num-1;
    }
    
    return lastIndex-index+1;
}

+(int)getViewCountWithActualSizes:(NSArray<NSValue*>*)sizes paddings:(NSArray<NSNumber*>*)paddings fromIndex:(int)index fitMaxHeight:(float)maxHeight {
    

    NSAssert(sizes.count-1 == paddings.count, @"sizes,paddings数量不匹配");
    float num = sizes.count;
    
    float heightSum=0;
    int i;
    int lastIndex;
    for(i = index;i<num;i++ ){
        if( i!=index ){
            heightSum+=paddings[i-1].floatValue;
        }
        heightSum+=[sizes[i] CGSizeValue].height;
        if( heightSum > maxHeight){
            break;
        }
    }
    if( i!=num ){
        lastIndex = i-1;
    }else{
        lastIndex = num-1;
    }
    
    return lastIndex-index+1;
}


-(UIView *)makeEdgeViewWithLocation:(EdgeLocation)edgeLocation edgeWidths:(UIEdgeInsets)edgeWidths edgeType:(EdgeType)edgeType{
    if( edgeType == EdgeTypeNone ){
        return nil;
    }else {
        if( edgeLocation == EdgeLocationTop && FloatEqual( edgeWidths.top,0)  ){
            return nil;
        }
        if( edgeLocation == EdgeLocationLeft && FloatEqual( edgeWidths.left,0)  ){
            return nil;
        }
        if( edgeLocation == EdgeLocationBottom && FloatEqual( edgeWidths.bottom,0)  ){
            return nil;
        }
        if( edgeLocation == EdgeLocationRight && FloatEqual( edgeWidths.right,0)  ){
            return nil;
        }
        
        if( edgeType == EdgeTypeImage ){
            UIImageView * edgeImage= [[UIImageView alloc]initWithImage:_edgeImage];
            return edgeImage;
        }else if(edgeType == EdgeTypeColor){
            UIView * edgeColor = [UIView new];
            edgeColor.backgroundColor = [UIColor clearColor];
            return edgeColor;
        }else{
            return nil;
        }
    }
    
}


-(void)setEdgeImage:(nullable UIImage*)edgeImage edgeColor:(nullable UIColor*)edgeColor edgeInsets:(UIEdgeInsets)edgeInsets edgeWidths:(UIEdgeInsets)edgeWidths{
    
    
    _edgeImage = edgeImage;
   _edgeColor = edgeColor;
    _edgeInsets = edgeInsets;
    _edgeWidths = edgeWidths;
    
    if( _edgeColor == _edgeColorRec && _edgeImage == _edgeImageRec && UIEdgeInsetsEqualToEdgeInsets (_edgeInsets , _edgeInsetsRec) &&  UIEdgeInsetsEqualToEdgeInsets(_edgeWidths , _edgeWidthsRec) ){
        return;
    }
    _edgeImageRec = edgeImage;
    _edgeColorRec = edgeColor;
    _edgeInsetsRec = edgeInsets;
    _edgeWidthsRec = edgeWidths;

    if( _edges.count >0 ){
        [_edges enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
        [_edges removeAllObjects];
    }
    _edges = [NSMutableArray array];
    
    EdgeType edgeType = EdgeTypeNone;
    if( edgeImage ){
        edgeType = EdgeTypeImage;
    }else if( edgeColor ){
        edgeType = EdgeTypeColor;
    }
    
    UIView * edge =nil;
    if( (edge = [self makeEdgeViewWithLocation:EdgeLocationTop edgeWidths:edgeWidths edgeType:edgeType]) ){
        [self addSubview:edge];
        [_edges addObject:edge];
        [edge mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo( self );
            make.height.equalTo( edgeWidths.top );
        }];
    }
    if( (edge = [self makeEdgeViewWithLocation:EdgeLocationLeft edgeWidths:edgeWidths edgeType:edgeType]) ){
        [self addSubview:edge];
        [_edges addObject:edge];
        [edge mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.equalTo( self );
            make.width.equalTo( edgeWidths.left );
        }];
    }
    if( (edge = [self makeEdgeViewWithLocation:EdgeLocationBottom edgeWidths:edgeWidths edgeType:edgeType]) ){
        [self addSubview:edge];
        [_edges addObject:edge];
        [edge mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.left.bottom.equalTo( self );
            make.height.equalTo( edgeWidths.bottom );
        }];
    }
    if( (edge = [self makeEdgeViewWithLocation:EdgeLocationRight edgeWidths:edgeWidths edgeType:edgeType]) ){
        [self addSubview:edge];
        [_edges addObject:edge];
        [edge mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.right.equalTo( self );
            make.width.equalTo( edgeWidths.right );
        }];
    }
    
   // [self updateSelfConstraint];

}


@end
