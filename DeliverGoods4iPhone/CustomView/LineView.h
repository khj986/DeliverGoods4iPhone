//
//  ListCellLine.h
//  DeliverGoods4iPhone
//
//  Created by ztt on 15/11/7.
//  Copyright © 2015年 ztt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+AutoSize.h"
//#import "Prefix.h"
@class MASConstraint;


typedef NS_ENUM(NSInteger, HAlign) {

    HAlignLeft = 0,
    HAlignCenter = 1,
    HAlignRight = 2
};

typedef NS_ENUM(NSInteger, VAlign) {

    VAlignTop = 0,
    VAlignCenter = 1,
    VAlignBottom = 2
};

typedef NS_ENUM(NSInteger, EdgeLocation) {
    
    EdgeLocationTop = 0,
    EdgeLocationLeft = 1,
    EdgeLocationBottom = 2,
    EdgeLocationRight = 3
};

typedef NS_ENUM(NSInteger, EdgeType) {
    
    EdgeTypeNone = 0,
    EdgeTypeImage = 1,
    EdgeTypeColor = 2

};

typedef NS_ENUM(NSInteger, PaddingType) {
    
    PaddingTypeZero = 0,
    PaddingTypeBefore = 1,
    PaddingTypeAfter = 2,
    PaddingTypeBeforeAfter = 3,
//    PaddingTypeMiddleBefore = 4,
//    PaddingTypeMiddleAfter = 5,
};


@interface LineView : UIView{
    @protected
//    UIView * _contentView;
//    CGSize _contentSize;
//    UIImage * _edgeImage;
//    UIColor * _edgeColor;
//    UIEdgeInsets _edgeInsets;
//    UIEdgeInsets _edgeWidths;
    UIView * contentView;

    //CGSize contentSize;
}

@property (nonatomic,strong) UIView * anchorView;

//@property (nonatomic,strong) UIView * contentView;

@property(nonatomic) CGSize contentSize;
@property(nonatomic) CGSize lineViewSize;

@property (nonatomic,strong) UIImage * edgeImage;
@property (nonatomic,strong) UIColor * edgeColor;
@property (nonatomic) UIEdgeInsets edgeInsets;
@property (nonatomic) UIEdgeInsets edgeWidths;
@property (nonatomic,strong)  NSMutableArray<UIView*>* edges;

//@property (nonatomic,strong)  NSMutableArray<MASConstraint*>* edgeConstraints;


-(void)setEdgeImage:(nullable UIImage*)edgeImage edgeColor:(nullable UIColor*)edgeColor edgeInsets:(UIEdgeInsets)edgeInsets edgeWidths:(UIEdgeInsets)edgeWidths;
//-(void)updateSelfConstraint;

+(int)getViewCountWithActualSizes:(NSArray<NSValue*>*)sizes paddings:(NSArray<NSNumber*>*)paddings fromIndex:(int)index fitMaxWidth:(float)maxWidth;
+(int)getViewCountWithActualSizes:(NSArray<NSValue*>*)sizes paddings:(NSArray<NSNumber*>*)paddings fromIndex:(int)index fitMaxHeight:(float)maxHeight;

@end
