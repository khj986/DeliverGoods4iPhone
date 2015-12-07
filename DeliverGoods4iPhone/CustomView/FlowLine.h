//
//  ListCellLine.h
//  DeliverGoods4iPhone
//
//  Created by ztt on 15/11/7.
//  Copyright © 2015年 ztt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlowLine : UIView
@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) UILabel* time;
@property (nonatomic, strong) UILabel *content;
@property (nonatomic, strong)  UIImageView * line;
@property (nonatomic, strong)  UIImageView * dot;

-(instancetype)initTime:(NSString*)time andContent:(NSString *)content withHeight:(float)height;
-(instancetype)initTime:(NSString*)time andContent:(NSString *)content withFontHeight:(float)fontHeight;
-(instancetype)initTime:(NSString*)time andContent:(NSString *)content withFontSize:(float)fontSize;

-(void)setLastLine;
//-( void )resetTitle:(NSString*)title andContent:(NSString *)content;

@end
