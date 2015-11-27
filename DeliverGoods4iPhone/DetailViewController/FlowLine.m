//
//  ListCellLine.m
//  DeliverGoods4iPhone
//
//  Created by ztt on 15/11/7.
//  Copyright © 2015年 ztt. All rights reserved.
//

#import "FlowLine.h"
#import "Prefix.h"

@interface FlowLine(){

}

@end
static float PaddingEdge = 10;
static float LineSpace = 0;
static float MinHeight = 60;

@implementation FlowLine

-(instancetype)initTime:(NSString *)time andContent:(NSString *)content withHeight:(float)height{
    if( self = [super init] ){
        
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
        style.lineSpacing = LineSpace;
        style.alignment = NSTextAlignmentCenter;
        
        NSMutableParagraphStyle *style2 = [[NSMutableParagraphStyle alloc]init];
        style2.lineSpacing = LineSpace;
        style2.alignment = NSTextAlignmentLeft;
        
       // NSString * number = @"2015";
        //float fontSize = [number fontSizeSingleLineFitsHeight:fontHeight attributes:nil];
        
        NSDictionary * dict=@{
                              //NSFontAttributeName:[UIFont fontWithName:nil size:fontSize],
                              NSForegroundColorAttributeName:[UIColor blackColor],
                              NSParagraphStyleAttributeName:style
                              };

        
        NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc]initWithString: [time stringByReplacingOccurrencesOfString:@" " withString:@"\n"]];
        
        float fontSize =[attStr fontSizeThatFitsHeight:height];
       // [dict setObject:[UIFont fontWithName:nil size:fontSize] forKey:NSFontAttributeName];
        [attStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:nil size:fontSize] range:NSMakeRange(0, [attStr length])];
        
        _time = [[UILabel alloc]init];
        _time.numberOfLines = 0;
        _time.attributedText = attStr;
        [self addSubview:_time];
        
        NSDictionary * dict2=@{
                                     NSFontAttributeName:[UIFont fontWithName:nil size:fontSize],
                                     NSForegroundColorAttributeName:[UIColor blackColor],
                                     NSParagraphStyleAttributeName:style2
                                     };
        
        NSAttributedString * attContent =[[NSAttributedString alloc]initWithString:content attributes:dict2];
        
        _content = [[UILabel alloc]init];
        _content.numberOfLines = 0;
        _content.attributedText = attContent;
        [self addSubview:_content];
        
        _line = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"圆角矩形-26"]];
        [self addSubview:_line];
        
        _dot = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"椭圆-2-拷贝"]];
        [self addSubview:_dot];
        
    }
    return self;
}

-(instancetype)initTime:(NSString *)time andContent:(NSString *)content withFontHeight:(float)fontHeight{
    if( self = [super init] ){
        
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
        style.lineSpacing = LineSpace;
        style.alignment = NSTextAlignmentCenter;
        
        NSMutableParagraphStyle *style2 = [[NSMutableParagraphStyle alloc]init];
        style2.lineSpacing = LineSpace;
        style2.alignment = NSTextAlignmentLeft;
        
        NSString * number = @"2015/:";
        float fontSize = [number fontSizeSingleLineFitsHeight:fontHeight attributes:nil];
        
        NSDictionary * dict=@{
                              NSFontAttributeName:[UIFont fontWithName:nil size:fontSize],
                              NSForegroundColorAttributeName:[UIColor blackColor],
                              NSParagraphStyleAttributeName:style
                              };
        
        NSAttributedString * attTime = [[NSAttributedString alloc]initWithString: [time stringByReplacingOccurrencesOfString:@" " withString:@"\n"] attributes:dict];
        
        NSDictionary * dict2=@{
                                      NSFontAttributeName:[UIFont fontWithName:nil size:fontSize],
                                      NSForegroundColorAttributeName:[UIColor blackColor],
                                      NSParagraphStyleAttributeName:style2
                                      };
        
        NSAttributedString * attContent =[[NSAttributedString alloc]initWithString:content attributes:dict2];
        
        _time = [[UILabel alloc]init];
        _time.numberOfLines = 0;
        _time.attributedText = attTime;
        [self addSubview:_time];
        
        _content = [[UILabel alloc]init];
        _content.numberOfLines = 0;
        _content.attributedText = attContent;
        [self addSubview:_content];
        
        UIImage* img =[UIImage imageNamed:@"line"];
        _line = [[UIImageView alloc]initWithImage:img];
        //_line.bounds = CGRectMake(0,0,img.size.width,img.size.height/4);
        [self addSubview:_line];
        //_line.transform = CGAffineTransformMakeScale(1, 0.5);
        
        _dot = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"椭圆-2-拷贝"]];
        [self addSubview:_dot];
        
    }
    return self;
}

-(instancetype)initTime:(NSString *)time andContent:(NSString *)content withFontSize:(float)fontSize{
    if( self = [super init] ){
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
        style.lineSpacing = LineSpace;
        style.alignment = NSTextAlignmentCenter;
        
        NSMutableParagraphStyle *style2 = [[NSMutableParagraphStyle alloc]init];
        style2.lineSpacing = LineSpace;
        style2.alignment = NSTextAlignmentLeft;
        
       // NSString * number = @"2015";
        //float fontSize = [number fontSizeSingleLineFitsHeight:fontHeight attributes:nil];
        
        NSDictionary * dict=@{
                              NSFontAttributeName:[UIFont fontWithName:nil size:fontSize],
                              NSForegroundColorAttributeName:[UIColor blackColor],
                              NSParagraphStyleAttributeName:style
                              };
        
        NSAttributedString * attStr = [[NSAttributedString alloc]initWithString: [time stringByReplacingOccurrencesOfString:@" " withString:@"\n"] attributes:dict];
        
        _time = [[UILabel alloc]init];
        _time.numberOfLines = 0;
        _time.attributedText = attStr;
        
        [self addSubview:_time];
        
        NSDictionary * dict2=@{
                                      NSFontAttributeName:[UIFont fontWithName:nil size:fontSize],
                                      NSForegroundColorAttributeName:[UIColor blackColor],
                                      NSParagraphStyleAttributeName:style2
                                      };
        
        NSAttributedString * attContent =[[NSAttributedString alloc]initWithString:content attributes:dict2];
        
        _content = [[UILabel alloc]init];
        _content.numberOfLines = 0;
        _content.attributedText = attContent;
        [self addSubview:_content];
        
        _line = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"圆角矩形-26"]];
        [self addSubview:_line];
        
        _dot = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"椭圆-2-拷贝"]];
        [self addSubview:_dot];

    }
    return self;
}

//-( void )resetTitle:(NSString*)title andContent:(NSString *)content{
//    _time.text = title;
//    _content.text = content;
//}

-(void)setLastLine{
    [_dot setImage:[UIImage imageNamed:@"椭圆-2"]];
}


-(void)updateConstraints{

    
    [self makeConstraints:^(MASConstraintMaker *make) {
        //make.left.right.mas_equalTo(self.superview);
        //make.width.mas_equalTo(ScreenW);
        //make.height.mas_equalTo(MasonryHeight(self.superview)).multipliedBy(60/1136.0);
        //make.height.mas_greaterThanOrEqualTo(_time.height).offset(2*PaddingEdge);
        make.height.mas_greaterThanOrEqualTo(MinHeight);
        make.height.mas_greaterThanOrEqualTo(_content.height).offset(2*PaddingEdge);
    }];
   // self.frame = CGRectMake(0, 0, ScreenW, MinHeight);
    
    [_time mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.top.left.mas_equalTo(self);
        make.right.mas_equalTo(_line.left).offset(-20);
        make.centerY.mas_equalTo(_line);
    }];
    
    [_content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_line.left).offset(20);
        make.centerY.mas_equalTo(_line);
        make.right.mas_equalTo(MasonryRight(self));
    }];
    
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.top.bottom.mas_equalTo(self);
        //make.height.mas_greaterThanOrEqualTo(_time.height).offset(2*PaddingEdge);
        make.top.mas_equalTo(self);
        make.width.equalTo(3);
        make.height.mas_equalTo(self);
        make.left.mas_equalTo(MasonryRight(self)).multipliedBy(200/640.0);
    }];
    
    [_dot mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(_line);
        make.width.height.mas_equalTo(20);
    }];
    
    [super updateConstraints];
    
//    [super setNeedsLayout];
//    [super layoutIfNeeded];
//    [_content setNeedsLayout];
//    [_content layoutIfNeeded];
//    NSLog(@"contentRect1:%@",NSStringFromCGRect(_content.bounds));
//    NSLog(@"selfRect1:%@",NSStringFromCGRect(self.bounds));
//    NSLog(@"timeRect1:%@",NSStringFromCGRect(_time.bounds));
//    NSLog(@"lineRect1:%@",NSStringFromCGRect(_line.bounds));
//    
//        if( self.bounds.size.height < _content.bounds.size.height+2*PaddingEdge ){
//            [self mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.height.mas_equalTo(_content).offset(2*PaddingEdge);
//                //make.height.mas_greaterThanOrEqualTo(60);
//            }];
//        }
//    
//    [super updateConstraints];
}

//-(void)layoutSubviews{
//    [super layoutSubviews];
//    NSLog(@"contentRect2:%@",NSStringFromCGRect(_content.bounds));
//    NSLog(@"selfRect2:%@",NSStringFromCGRect(self.bounds));
//    
//    if( self.bounds.size.height < _content.bounds.size.height ){
//        [self mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.height.mas_greaterThanOrEqualTo(_content).offset(2*PaddingEdge);
//            make.left.right.mas_equalTo(self.superview);
//            make.top.mas_equalTo(self.frame.origin.y);
//        }];
//    }
//    [self needsUpdateConstraints];
//    [self updateConstraintsIfNeeded];
//    [super layoutSubviews];
//    
//}




@end
