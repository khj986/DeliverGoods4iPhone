//
//  ListCellLine.h
//  DeliverGoods4iPhone
//
//  Created by ztt on 15/11/7.
//  Copyright © 2015年 ztt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TitleContentMultiLine : UIView
@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) UILabel* title;
@property (nonatomic, strong) UILabel *content;

-(instancetype)initTitle:(NSString*)title andContent:(NSString *)content withFontHeight:(float)fontHeight andLineWidth:(float)lineWidth;
//-(instancetype)initTitle:(NSString*)title andContent:(NSString *)content withFontSize:(float)fontSize;

-( void )resetTitle:(NSString*)title andContent:(NSString *)content;

@end
