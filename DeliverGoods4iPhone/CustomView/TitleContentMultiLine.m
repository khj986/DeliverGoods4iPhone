//
//  ListCellLine.m
//  DeliverGoods4iPhone
//
//  Created by ztt on 15/11/7.
//  Copyright © 2015年 ztt. All rights reserved.
//

#import "TitleContentMultiLine.h"
#import "Prefix.h"

static float LineSpace = 0;

@interface TitleContentMultiLine(){

}


@end

@implementation TitleContentMultiLine

//-(instancetype)initTitle:(NSString*)title andContent:(NSString *)content withFontHeight:(float)fontHeight{
//    if( self = [super init] ){
//        _title = [[UILabel alloc]init];
//        _title.text = title;
//        _title.textColor = [UIColor blackColor];
//
//        float fontSize = [title fontSizeSingleLineFitsHeight:fontHeight attributes:nil];
//        _title.font = [UIFont fontWithName:nil size:fontSize];
//        [self addSubview:_title];
//        NSDictionary * dictTitle=@{
//                              NSFontAttributeName:[UIFont fontWithName:nil size:fontSize],
//                              };
//        CGSize titleSize = [_title.text boundingRectWithSize:CGSizeMake(MAXFLOAT, fontHeight) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
//                                             attributes:dictTitle context:nil].size;
//        _title.frame = CGRectMake(0, 0, titleSize.width, titleSize.height);
//        
//        
//        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
//        style.lineSpacing = LineSpace;
//        style.alignment = NSTextAlignmentCenter;
//        style.lineBreakMode = NSLineBreakByWordWrapping;
//
//        
//        NSDictionary * dict=@{
//                              NSFontAttributeName:[UIFont fontWithName:nil size:fontSize],
//                              NSForegroundColorAttributeName:[UIColor blackColor],
//                              NSParagraphStyleAttributeName:style
//                              };
//        
//        NSAttributedString * attStr = [[NSAttributedString alloc]initWithString: content attributes:dict];
//        
//        
//        _content = [[UILabel alloc]init];
//        _content.numberOfLines = 0;
//        _content.lineBreakMode = NSLineBreakByWordWrapping;
//        _content.attributedText =attStr;
//        //_content.text = content;
//        //_content.textColor = [UIColor blackColor];
//        //_content.font = _title.font;
//        [self addSubview:_content];
//        
//        float contentWidth = ScreenW - titleSize.width;
//        CGSize contentSize = [attStr boundingRectWithSize:CGSizeMake(contentWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
//                                           context:nil].size;
//        //大于2行
//        if( contentSize.height > 2*( fontHeight-2 ) ){
//            _content.frame = CGRectMake(titleSize.width, 0, contentSize.width, contentSize.height);
//        }
//        else{
//            _content.bounds = CGRectMake(0, 0, contentSize.width, contentSize.height);
//            _content.center = CGPointMake(ScreenW*0.55, contentSize.height/2);
//        }
//        
//        self.bounds = CGRectMake(0, 0, ScreenW,contentSize.height);
//        NSLog( @"bounds:%@",NSStringFromCGSize(self.bounds.size)  );
//    }
//    return self;
//}

-(instancetype)initTitle:(NSString*)title andContent:(NSString *)content withFontHeight:(float)fontHeight andLineWidth:(float)lineWidth{
    if( self = [super init] ){
        _title = [[UILabel alloc]init];
        _title.text = title;
        _title.textColor = [UIColor blackColor];
        
        float fontSize = [title fontSizeSingleLineFitsHeight:fontHeight attributes:nil];
        _title.font = [UIFont fontWithName:nil size:fontSize];
        [self addSubview:_title];
        NSDictionary * dictTitle=@{
                                   NSFontAttributeName:[UIFont fontWithName:nil size:fontSize],
                                   };
        CGSize titleSize = [_title.text boundingRectWithSize:CGSizeMake(MAXFLOAT, fontHeight) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                                  attributes:dictTitle context:nil].size;
        _title.frame = CGRectMake(0, 0, titleSize.width, titleSize.height);
        
        
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
        style.lineSpacing = LineSpace;
        style.alignment = NSTextAlignmentCenter;
        style.lineBreakMode = NSLineBreakByWordWrapping;
        
        
        NSDictionary * dict=@{
                              NSFontAttributeName:[UIFont fontWithName:nil size:fontSize],
                              NSForegroundColorAttributeName:[UIColor blackColor],
                              NSParagraphStyleAttributeName:style
                              };
        
        NSAttributedString * attStr = [[NSAttributedString alloc]initWithString: content attributes:dict];
        
        
        _content = [[UILabel alloc]init];
        _content.numberOfLines = 0;
        _content.lineBreakMode = NSLineBreakByWordWrapping;
        _content.attributedText =attStr;
        //_content.text = content;
        //_content.textColor = [UIColor blackColor];
        //_content.font = _title.font;
        [self addSubview:_content];
        
        float contentWidth = lineWidth - titleSize.width;
        CGSize contentSize = [attStr boundingRectWithSize:CGSizeMake(contentWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading context:nil].size;
        //大于2行
        if( contentSize.height > 2*( fontHeight-2 ) ){
            _content.frame = CGRectMake(titleSize.width, 0, contentSize.width, contentSize.height);
        }
        else{
            _content.bounds = CGRectMake(0, 0, contentSize.width, contentSize.height);
            _content.center = CGPointMake(lineWidth*0.55, contentSize.height/2);
            if( CGRectGetMinX( _content.frame)<CGRectGetMaxX(_title.frame) ){
                _content.frame = CGRectMake(titleSize.width, 0, contentSize.width, contentSize.height);
            }
        }
        
        self.bounds = CGRectMake(0, 0, lineWidth,contentSize.height);
        //NSLog( @"bounds:%@",NSStringFromCGSize(self.bounds.size)  );
    }
    return self;
}


//-(instancetype)initTitle:(NSString*)title andContent:(NSString *)content withFontSize:(float)fontSize{
//    if( self = [super init] ){
//        _title = [[UILabel alloc]init];
//        _title.text = title;
//        _title.textColor = [UIColor blackColor];
//        _title.font = [UIFont fontWithName:nil size:fontSize];
//        [self addSubview:_title];
//        
//        _content = [[UILabel alloc]init];
//        _content.numberOfLines = 0;
//        _content.lineBreakMode = NSLineBreakByWordWrapping;
//        _content.text = content;
//         _content.textColor = [UIColor blackColor];
//        _content.font = _title.font;
//        [self addSubview:_content];
//        
//
//    }
//    return self;
//}

-( void )resetTitle:(NSString*)title andContent:(NSString *)content{
    _title.text = title;
    _content.text = content;
}

//-(void)updateConstraints{
//   
//
////        [self makeConstraints:^(MASConstraintMaker *make) {
////            make.height.greaterThanOrEqualTo(_content);
////            make.left.mas_equalTo(0);
////            make.right.mas_equalTo(ScreenW);
////        }];
//
//    
//    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(MasonryRight(self)).multipliedBy(28/640.0);
//        make.top.mas_equalTo(self);
//        
//    }];
//    
//    [_content mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self);
//        //make.centerX.mas_equalTo(MasonryRight(self)).multipliedBy(0.55).priorityLow();
//        make.left.mas_greaterThanOrEqualTo(_title.right).priority(749);
//        make.right.mas_lessThanOrEqualTo(self.right);
//        make.height.lessThanOrEqualTo(self);
//    }];
//    
//    
//    [super updateConstraints];
//}

//-(void)layoutSubviews{
//    [super layoutSubviews];
//    NSLog(@"contentRect2:%@",NSStringFromCGRect(_content.bounds));
//    NSLog(@"titleRect2:%@",NSStringFromCGRect(_title.bounds));
//    NSLog(@"selfRect2:%@",NSStringFromCGRect(self.bounds));
//
////    if( self.bounds.size.height < _content.bounds.size.height ){
////        [self mas_remakeConstraints:^(MASConstraintMaker *make) {
////            make.height.mas_greaterThanOrEqualTo(_content).offset(2*PaddingEdge);
////            make.left.right.mas_equalTo(self.superview);
////            make.top.mas_equalTo(self.frame.origin.y);
////        }];
////    }
////    [self needsUpdateConstraints];
////    [self updateConstraintsIfNeeded];
////    [super layoutSubviews];
//
//}



@end
