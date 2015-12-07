//
//  ListCellLine.h
//  DeliverGoods4iPhone
//
//  Created by ztt on 15/11/7.
//  Copyright © 2015年 ztt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LineView.h"



@interface VerticalLineView : LineView


@property (nonatomic,strong,readonly) NSMutableArray<UIView*>* views;



@property(nonatomic,readonly) int viewCount;



@property (nonatomic,strong,readonly) NSMutableArray<NSValue*>* sizes;
@property (nonatomic,strong,readonly) NSMutableArray<NSNumber*>* paddings;
@property (nonatomic,strong,readonly) NSMutableArray<NSNumber*>* hAligns;
@property (nonatomic,strong,readonly) NSMutableArray<NSNumber*>* hOffsets;


-(instancetype) initWithViews:(NSArray<UIView*>*)views sizes:(NSArray<NSValue*>*)sizes paddings:(NSArray<NSNumber*>*)paddings hAligns:(NSArray<NSNumber*>*)hAligns hOffsets:(NSArray<NSNumber*>*)hOffsets edgeImage:(nullable UIImage*)edgeImage edgeColor:(nullable UIColor*)edgeColors edgeInsets:(UIEdgeInsets)edgeInsets edgeWidths:(UIEdgeInsets)edgeWidths;
-(instancetype) initWithViews:(NSArray<UIView*>*)views sizes:(NSArray<NSValue*>*)sizes paddings:(NSArray<NSNumber*>*)paddings hAligns:(NSArray<NSNumber*>*)hAligns hOffsets:(NSArray<NSNumber*>*)hOffsets;
-(void)setSizes:(NSArray<NSValue*>*)sizes paddings:(NSArray<NSNumber*>*)paddings hAligns:(NSArray<NSNumber*>*)hAligns hOffsets:(NSArray<NSNumber*>*)hOffsets;

-(void)deleteViewAtIndex:(int)index;
-(void)deleteViewAtIndex:(int)index leftPaddingType:(PaddingType)paddingType;
-(void)addView:(UIView *)view size:(CGSize)size hAlign:(HAlign)hAlign hOffset:(float)hOffset AtIndex:(int)index;
-(void)addView:(UIView *)view size:(CGSize)size hAlign:(HAlign)hAlign hOffset:(float)hOffset AtIndex:(int)index padding:(float)padding addPaddingType:(PaddingType)paddingType;
-(void)setSize:(CGSize)size AtIndex:(int)index;
-(void)setPadding:(float)padding AtIndex:(int)index;
-(void)setHAlign:(HAlign)hAlign hOffset:(float)hOffset AtIndex:(int)index;

@end
