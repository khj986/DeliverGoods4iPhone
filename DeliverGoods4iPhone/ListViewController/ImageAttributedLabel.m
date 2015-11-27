//
//  ListCellLine.m
//  DeliverGoods4iPhone
//
//  Created by ztt on 15/11/7.
//  Copyright © 2015年 ztt. All rights reserved.
//

#import "ImageAttributedLabel.h"
#import "Prefix.h"

@interface ImageAttributedLabel(){
}

@end

@implementation ImageAttributedLabel


-(instancetype)initWithImage:(UIImage*)image andLabelText:(NSAttributedString *)text setHeightImage:(float)heightImage heightUnderline:(float)heightUnderline paddingImage:(float)paddingImage paddingLabel:(float)paddingLabel paddingUnderline:(float)paddingUnderline{
    if( self = [super init] ){

        _heightImage = heightImage;
        _heightUnderLine = heightUnderline;
        _underlineHidden = NO;
        _paddingImage = paddingImage;
        _paddingLabel= paddingLabel;
        _paddingUnderLine = paddingUnderline;
        
        self.imageContainer = [[UIView alloc]init];
        [self addSubview:self.imageContainer];
        
        [_imageContainer makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(0);
            make.left.equalTo(paddingImage);
            make.width.height.equalTo(heightImage);
        }];
        
        self.imageView = [[UIImageView alloc]initWithImage:image];
        [_imageContainer addSubview:self.imageView];
        
        if( image.size.height >= image.size.width ){
            [_imageView makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(_imageContainer);
                make.height.equalTo(_imageContainer);
                make.width.equalTo(_imageView.height).multipliedBy(image.size.width/image.size.height);
            }];
        }else{
            [_imageView makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(_imageContainer);
                make.width.equalTo(_imageContainer);
                make.height.equalTo(_imageView.width).multipliedBy(image.size.height/image.size.width);
            }];
        }
        

        
        NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc]initWithAttributedString:text];
        
        self.label = [[UILabel alloc]init];

        [self addSubview:self.label];
        float fontSize = [attStr fontSizeThatFitsHeight:heightImage];
        
        [attStr enumerateAttribute:NSFontAttributeName inRange:NSMakeRange(0, [attStr length]) options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(id value,NSRange range, BOOL *  stop) {
            UIFont * font = value;
            if(font){
                font = [font fontWithSize:fontSize];
                [attStr addAttribute:NSFontAttributeName value:font range:range];
            }
            else{
                font = [UIFont fontWithName:nil size:fontSize];
                [attStr addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, [attStr length])];
            }
        }];
        
        _label.attributedText = attStr;

        CGSize labelSize = [_label.attributedText boundingRectWithSize:CGSizeMake(MAXFLOAT, heightImage) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading context:nil].size;
        
        [_label makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(0);
            make.left.equalTo(_imageContainer.right).offset(paddingLabel);
            make.width.equalTo(labelSize.width+8);
            make.height.equalTo(labelSize.height);
        }];
        

        self.underline = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"矩形-9"]];
        [self addSubview:self.underline];
        
        [_underline makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_imageContainer.bottom).offset(paddingUnderline);
            make.left.equalTo(0);
            make.height.equalTo(1);
            make.right.greaterThanOrEqualTo(_label);
            make.right.equalTo(self);
        }];
        
//        [self makeConstraints:^(MASConstraintMaker *make) {
//            //make.left.equalTo(0);
//            make.right.equalTo(_label.right);
//            make.bottom.equalTo(_underline.bottom);
//        }];
    }
    return self;
}

-(instancetype)initWithImage:(UIImage*)image andLabelText:(NSAttributedString *)text{
    return [self initWithImage:image andLabelText:text setHeightImage:image.size.height heightUnderline:1 paddingImage:0 paddingLabel:0 paddingUnderline:0];
}

-(void)setUnderlineHidden:(BOOL)underlineHidden{
    _underline.hidden = underlineHidden;
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_imageContainer.bottom);
    }];
}

-(void)setPaddingImage:(float)paddingImage{
    _paddingImage = paddingImage;
    [_imageContainer mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_paddingImage);
    }];
}

-(void)setPaddingLabel:(float)paddingLabel {
    _paddingLabel = paddingLabel;
    [_label mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_imageContainer.right).offset(_paddingLabel);
    }];
}

-(void)setPaddingUnderLine:(float)paddingUnderLine{
    _paddingUnderLine= paddingUnderLine;
    [_underline mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imageContainer.bottom).offset(_paddingUnderLine);
    }];
}

-(void)setHeightUnderLine:(float)heightUnderLine{
    _heightUnderLine =heightUnderLine;
    [_underline mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(_heightUnderLine);
    }];
}

-(void)setHeightImage:(float)heightImage{
    _heightImage = heightImage;
    [_imageContainer mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(_heightImage);
    }];

    UIImage* image = _imageView.image;
    if( image.size.height >= image.size.width ){
        [_imageView makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_imageContainer);
            make.height.equalTo(_imageContainer);
            make.width.equalTo(_imageView.height).multipliedBy(image.size.width/image.size.height);
        }];
    }else{
        [_imageView makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_imageContainer);
            make.width.equalTo(_imageContainer);
            make.height.equalTo(_imageView.width).multipliedBy(image.size.height/image.size.width);
        }];
    }
    
    [self resetText:_label.attributedText];
}

-( void )resetText:(NSAttributedString *)text{
    NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc]initWithAttributedString:text];
    float fontSize = [attStr fontSizeThatFitsHeight:_heightImage];
    
    [attStr enumerateAttribute:NSFontAttributeName inRange:NSMakeRange(0, [attStr length]) options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(id value,NSRange range, BOOL *  stop) {
        UIFont * font = value;
        if(font){
            font = [font fontWithSize:fontSize];
            [attStr addAttribute:NSFontAttributeName value:font range:range];
        }
        else{
            font = [UIFont fontWithName:nil size:fontSize];
            [attStr addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, [attStr length])];
        }
    }];
    
    _label.attributedText = attStr;
    
    CGSize labelSize = [_label.attributedText boundingRectWithSize:CGSizeMake(MAXFLOAT, _heightImage) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading context:nil].size;

    
   [_label mas_updateConstraints:^(MASConstraintMaker *make) {
       make.width.equalTo(labelSize.width+8);
       make.height.equalTo(labelSize.height);
   }];
}

//-(void)updateConstraints{
// 
////    NSLog(@"image%@",NSStringFromCGRect(_imageView.frame));
////    NSLog(@"label%@",NSStringFromCGRect(_label.frame));
////    NSLog(@"underline%@",NSStringFromCGRect(_underline.frame));
////    NSLog(@"self%@",NSStringFromCGRect(self.frame));
//
//    
//    [super updateConstraints];
////    NSLog(@"image2%@",NSStringFromCGRect(_imageView.frame));
////    NSLog(@"label2%@",NSStringFromCGRect(_label.frame));
////    NSLog(@"underline2%@",NSStringFromCGRect(_underline.frame));
////    NSLog(@"self2%@",NSStringFromCGRect(self.frame));
//}
//
//-(void)layoutSubviews{
//    NSLog(@"image3%@",NSStringFromCGRect(_imageView.frame));
//    NSLog(@"label3%@",NSStringFromCGRect(_label.frame));
//    NSLog(@"underline3%@",NSStringFromCGRect(_underline.frame));
//    NSLog(@"self3%@",NSStringFromCGRect(self.frame));
//    //    [self makeConstraints:^(MASConstraintMaker *make) {
//    ////        make.left.equalTo(0);
//    ////        make.right.equalTo(_label.right);
//    ////        make.top.equalTo
//    //    }];
//    
//    [super layoutSubviews];
//    NSLog(@"image4%@",NSStringFromCGRect(_imageView.frame));
//    NSLog(@"label4%@",NSStringFromCGRect(_label.frame));
//    NSLog(@"underline4%@",NSStringFromCGRect(_underline.frame));
//    NSLog(@"self4%@",NSStringFromCGRect(self.frame));
//    
//        [self makeConstraints:^(MASConstraintMaker *make) {
//    //        make.left.equalTo(0);
//    //        make.right.equalTo(_label.right);
//    //        make.top.equalTo
//            make.width.mas_equalTo(CGRectGetMaxX(_label.frame));
//            make.height.mas_equalTo( CGRectGetMaxY(_underline.frame) );
//        }];
//}


@end
