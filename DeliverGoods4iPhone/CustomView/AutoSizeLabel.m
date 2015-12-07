//
//  ListCellLine.m
//  DeliverGoods4iPhone
//
//  Created by ztt on 15/11/7.
//  Copyright © 2015年 ztt. All rights reserved.
//

#import "AutoSizeLabel.h"
#import "Prefix.h"


@implementation AutoSizeLabel

-(instancetype)init{
    if( self =[super init] ){
        [self setContentHuggingPriority:1000 forAxis:UILayoutConstraintAxisHorizontal];
        [self setContentCompressionResistancePriority:1000 forAxis:UILayoutConstraintAxisHorizontal];
        [self setContentHuggingPriority:1000 forAxis:UILayoutConstraintAxisVertical];
        [self setContentCompressionResistancePriority:1000 forAxis:UILayoutConstraintAxisVertical];
    }
    return self;
}

//-(void)layoutSubviews{
//    
//    [super layoutSubviews];
//    [self makeConstraints:^(MASConstraintMaker *make) {
//        make.size.equalTo(self.frame.size);
//    }];
//    [super layoutSubviews];
//
//}



@end
