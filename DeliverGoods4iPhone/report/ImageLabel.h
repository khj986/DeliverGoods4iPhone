//
//  ListCellLine.h
//  DeliverGoods4iPhone
//
//  Created by ztt on 15/11/7.
//  Copyright © 2015年 ztt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageLabel : UIView

@property (nonatomic, strong) UILabel *label;


@property(nonatomic) float paddingImage;
@property(nonatomic) float paddingLabel;
@property(nonatomic) float paddingUnderLine;
@property(nonatomic) float heightUnderLine;
@property(nonatomic) float heightImage;
@property(nonatomic) BOOL underlineHidden;

-(instancetype)initWithImage:(UIImage*)image andLabelText:(NSString *)text;
-(instancetype)initWithImage:(UIImage*)image andLabelText:(NSString *)text setHeightImage:(float)heightImage heightUnderline:(float)heightUnderline paddingImage:(float)paddingImage paddingLabel:(float)paddingLabel paddingUnderline:(float)paddingUnderline;
-( void )resetText:(NSString *)text;
//-(void) setHeightImage:(float)heightImage heightUnderline:(float)heightUnderline paddingImage:(float)paddingImage paddingLabel:(float)paddingLabel paddingUnderline:(float)paddingUnderline;
@end
