//
//  ListCellLine.h
//  DeliverGoods4iPhone
//
//  Created by ztt on 15/11/7.
//  Copyright © 2015年 ztt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageAttributedLabel : UIView
@property (nonatomic,strong) UIView *imageContainer;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic,strong) UIImageView * underline;

@property(nonatomic) float paddingImage;
@property(nonatomic) float paddingLabel;
@property(nonatomic) float paddingUnderLine;
@property(nonatomic) float heightUnderLine;
@property(nonatomic) float heightImage;
@property(nonatomic) BOOL underlineHidden;

-( void )resetText:(NSAttributedString *)text;

-(instancetype)initWithImage:(UIImage*)image andLabelText:(NSAttributedString *)text setHeightImage:(float)heightImage heightUnderline:(float)heightUnderline paddingImage:(float)paddingImage paddingLabel:(float)paddingLabel paddingUnderline:(float)paddingUnderline;
-(instancetype)initWithImage:(UIImage*)image andLabelText:(NSAttributedString *)text;

@end
