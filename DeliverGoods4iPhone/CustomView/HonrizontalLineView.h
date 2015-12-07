//
//  ListCellLine.h
//  DeliverGoods4iPhone
//
//  Created by ztt on 15/11/7.
//  Copyright © 2015年 ztt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LineView.h"


@interface HonrizontalLineView : LineView


@property (nonatomic,strong,readonly) NSMutableArray<UIView*>* views;


//@property(nonatomic) float contentVMax;
@property(nonatomic,readonly) int viewCount;
//@property(nonatomic,readonly) CGSize allSize;

@property (nonatomic,strong,readonly) NSMutableArray<NSValue*>* sizes;
@property (nonatomic,strong,readonly) NSMutableArray<NSNumber*>* paddings;
@property (nonatomic,strong,readonly) NSMutableArray<NSNumber*>* vAligns;
@property (nonatomic,strong,readonly) NSMutableArray<NSNumber*>* vOffsets;


-(instancetype) initWithViews:(NSArray<UIView*>*)views sizes:(NSArray<NSValue*>*)sizes paddings:(NSArray<NSNumber*>*)paddings vAligns:(NSArray<NSNumber*>*)vAligns vOffsets:(NSArray<NSNumber*>*)vOffsets edgeImage:(nullable UIImage*)edgeImage edgeColor:(nullable UIColor*)edgeColors edgeInsets:(UIEdgeInsets)edgeInsets edgeWidths:(UIEdgeInsets)edgeWidths;
-(instancetype) initWithViews:(NSArray<UIView*>*)views sizes:(NSArray<NSValue*>*)sizes paddings:(NSArray<NSNumber*>*)paddings vAligns:(NSArray<NSNumber*>*)vAligns vOffsets:(NSArray<NSNumber*>*)vOffsets;
-(void)setSizes:(NSArray<NSValue*>*)sizes paddings:(NSArray<NSNumber*>*)paddings vAligns:(NSArray<NSNumber*>*)vAligns vOffsets:(NSArray<NSNumber*>*)vOffsets;

-(void)deleteViewAtIndex:(int)index;
-(void)deleteViewAtIndex:(int)index leftPaddingType:(PaddingType)paddingType;
-(void)addView:(UIView *)view size:(CGSize)size vAlign:(VAlign)vAlign vOffset:(float)vOffset AtIndex:(int)index;
-(void)addView:(UIView *)view size:(CGSize)size vAlign:(VAlign)vAlign vOffset:(float)vOffset AtIndex:(int)index padding:(float)padding addPaddingType:(PaddingType)paddingType;
-(void)setSize:(CGSize)size AtIndex:(int)index;
-(void)setPadding:(float)padding AtIndex:(int)index;
-(void)setVAlign:(VAlign)vAlign vOffset:(float)vOffset AtIndex:(int)index;

-(BOOL)addLastView:(UIView *)view size:(CGSize)size fitMaxWidth:(float)maxWidth;

@end
