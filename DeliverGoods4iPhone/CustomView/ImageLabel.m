//
//  ListCellLine.m
//  DeliverGoods4iPhone
//
//  Created by ztt on 15/11/7.
//  Copyright © 2015年 ztt. All rights reserved.
//

#import "ImageLabel.h"
#import "Prefix.h"

@interface ImageLabel(){
}
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic,strong) UIImageView * underline;
@property (nonatomic,strong) UIView *imageContainer;

@end

@implementation ImageLabel


-(instancetype)initWithImage:(UIImage*)image andLabelText:(NSString *)text setHeightImage:(float)heightImage heightUnderline:(float)heightUnderline paddingImage:(float)paddingImage paddingLabel:(float)paddingLabel paddingUnderline:(float)paddingUnderline{
    if( self = [super init] ){

        _heightImage = heightImage;
        _heightUnderLine = heightUnderline;
        _underlineHidden = NO;
        _paddingImage = paddingImage;
        _paddingLabel= paddingLabel;
        _paddingUnderLine = paddingUnderline;        
        
        _imageContainer = [[UIView alloc]init];
        _imageContainer.backgroundColor = [UIColor clearColor];
        [self addSubview:self.imageContainer];
        _imageContainer.frame = CGRectMake(paddingImage, 0, heightImage, heightImage);
        
        self.imageView = [[UIImageView alloc]initWithImage:image];
        [_imageContainer addSubview:self.imageView];
        
        if( image.size.height/heightImage >= image.size.width/heightImage ){
            float scale = heightImage/image.size.height;
            float width = image.size.width*scale;
            _imageView.frame = CGRectMake((heightImage-width)/2, 0, width, heightImage);
        }
        else{
            float scale = heightImage/image.size.width;
            float height = image.size.height*scale;
            _imageView.frame = CGRectMake(0, (heightImage-height)/2, heightImage, height);
        }
        
        
        
        self.label = [[UILabel alloc]init];
        self.label.text = text;
        self.label.lineBreakMode = NSLineBreakByWordWrapping;
        self.label.textColor = [UIColor blackColor];
        [self addSubview:self.label];
        float fontSize = [_label.text fontSizeSingleLineFitsHeight:heightImage attributes:nil];
        _label.font = [UIFont fontWithName:nil size:fontSize];
        
        NSDictionary * dict=@{   NSFontAttributeName:[UIFont fontWithName:nil size:fontSize]
                                   };
        CGSize labelSize = [_label.text boundingRectWithSize:CGSizeMake(ScreenW, heightImage) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                                  attributes:dict context:nil].size;
        
        _label.frame = CGRectMake(CGRectGetMaxX(_imageContainer.frame)+paddingLabel, 0, labelSize.width, labelSize.height);
        
        self.underline = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"矩形-9"]];
        [self addSubview:self.underline];
        _underline.frame = CGRectMake(0, heightImage+ paddingUnderline, CGRectGetMaxX(_label.frame), heightUnderline);
        
        
        self.bounds = CGRectMake(0, 0, CGRectGetMaxX(_label.frame), CGRectGetMaxY(_underline.frame));
        
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            //        make.top.equalTo(self.frame.origin.y);
            //        make.left.equalTo(self.frame.origin.x);
            make.width.equalTo(self.bounds.size.width);
            make.height.equalTo(self.bounds.size.height);
        }];
    }
    return self;
    
}


-(instancetype)initWithImage:(UIImage*)image andLabelText:(NSString *)text{
    return [self initWithImage:image andLabelText:text setHeightImage:image.size.height heightUnderline:1 paddingImage:0 paddingLabel:0 paddingUnderline:0];
 }

-(void)setUnderlineHidden:(BOOL)underlineHidden{
    _underline.hidden = underlineHidden;
    if(_underlineHidden){
        self.bounds = CGRectMake(0, 0, self.bounds.size.width, _heightImage);
    }else{
        self.bounds = CGRectMake(0, 0, self.bounds.size.width, CGRectGetMaxY(_underline.frame));
    }
}
//
//-(void)setUnderlineHidden:(BOOL) hidden{
//
//}

-( void )resetText:(NSString *)text{
    _label.text = text;
    NSDictionary * dict=@{   NSFontAttributeName:[UIFont fontWithName:nil size:_label.font.pointSize]
                             };
    CGSize labelSize = [_label.text boundingRectWithSize:CGSizeMake(ScreenW, _heightImage) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                              attributes:dict context:nil].size;
    
    _label.frame = CGRectMake(_label.frame.origin.x, 0, labelSize.width, labelSize.height);
    _underline.frame = CGRectMake(0, _underline.frame.origin.y, CGRectGetMaxX(_label.frame), _underline.frame.size.height);
    self.bounds = CGRectMake(0, 0, CGRectGetMaxX(_label.frame), self.bounds.size.height);
    
}

-(void)setPaddingLabel:(float)paddingLabel {
    _paddingLabel = paddingLabel;
    _label.frame = CGRectMake(CGRectGetMaxX(_imageContainer.frame)+_paddingLabel, 0, _label.bounds.size.width, _label.bounds.size.height);
    _underline.frame = CGRectMake(0, _underline.frame.origin.y, CGRectGetMaxX(_label.frame), _underline.frame.size.height);
    self.bounds = CGRectMake(0, 0, CGRectGetMaxX(_label.frame), self.bounds.size.height);
}

-(void)setPaddingUnderLine:(float)paddingUnderLine{
    _paddingUnderLine= paddingUnderLine;
    _underline.frame = CGRectMake(0, _heightImage+_paddingUnderLine, _underline.frame.size.width, _underline.frame.size.height);
    self.bounds = CGRectMake(0, 0, self.bounds.size.width, CGRectGetMaxY(_underline.frame));
}

-(void)setPaddingImage:(float)paddingImage{
    //float lastPaddingImage = _paddingImage;
    _paddingImage = paddingImage;
    _imageContainer.frame = CGRectMake(_paddingImage, 0, _heightImage, _heightImage);
    _label.frame = CGRectMake(CGRectGetMaxX(_imageContainer.frame)+_paddingLabel, 0, _label.bounds.size.width, _label.bounds.size.height);
    _underline.frame = CGRectMake(0, _underline.frame.origin.y, CGRectGetMaxX(_label.frame), _underline.frame.size.height);
    self.bounds = CGRectMake(0, 0, CGRectGetMaxX(_label.frame), self.bounds.size.height);
}

-(void)setHeightImage:(float)heightImage{
    _heightImage = heightImage;
    _imageContainer.frame = CGRectMake(_paddingImage, 0, _heightImage, _heightImage);
    
    CGSize imagesize= _imageView.frame.size;
    
    if( imagesize.height/_heightImage >= imagesize.width/_heightImage ){
        float scale = _heightImage/imagesize.height;
        float width = imagesize.width*scale;
        _imageView.frame = CGRectMake((_heightImage-width)/2, 0, width, _heightImage);
    }
    else{
        float scale = _heightImage/imagesize.width;
        float height = imagesize.height*scale;
        _imageView.frame = CGRectMake(0, (_heightImage-height)/2, _heightImage, height);
    }
    
    float fontSize = [_label.text fontSizeSingleLineFitsHeight:_heightImage attributes:nil];
    _label.font = [UIFont fontWithName:nil size:fontSize];
    
    NSDictionary * dict=@{   NSFontAttributeName:[UIFont fontWithName:nil size:fontSize]
                             };
    CGSize labelSize = [_label.text boundingRectWithSize:CGSizeMake(ScreenW, _heightImage) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                              attributes:dict context:nil].size;
    
    _label.frame = CGRectMake(CGRectGetMaxX(_imageContainer.frame)+_paddingLabel, 0, labelSize.width, labelSize.height);

    _underline.frame = CGRectMake(0, _heightImage+_paddingUnderLine, CGRectGetMaxX(_label.frame), _underline.frame.size.height);
    self.bounds = CGRectMake(0, 0, CGRectGetMaxX(_label.frame), CGRectGetMaxY(_underline.frame));
    
//    [self mas_updateConstraints:^(MASConstraintMaker *make) {
//        //        make.top.equalTo(self.frame.origin.y);
//        //        make.left.equalTo(self.frame.origin.x);
//        make.width.equalTo(self.bounds.size.width);
//        make.height.equalTo(self.bounds.size.height);
//    }];
}

-(void)setHeightUnderLine:(float)heightUnderLine{
    _heightUnderLine =heightUnderLine;
    _underline.frame = CGRectMake(0, _underline.frame.origin.y, _underline.frame.size.width, _heightUnderLine);
    self.bounds = CGRectMake(0, 0,self.bounds.size.width , CGRectGetMaxY(_underline.frame));
}

//-(void)updateConstraints{
//
//    [super updateConstraints];
//}



@end
