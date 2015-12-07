//
//  ListCellLine.m
//  DeliverGoods4iPhone
//
//  Created by ztt on 15/11/7.
//  Copyright © 2015年 ztt. All rights reserved.
//

#import "UIView+AutoSize.h"
#import "Prefix.h"


@implementation UIView(AutoSize)

-(CGSize)autoSizeAfterMasonry{
    
    [self.superview setNeedsLayout];
    [self.superview layoutIfNeeded];
    
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.frame.size);
    }];
    
    return self.frame.size;
}

-(CGSize)autoSizeWithAutoLayout:(void(^)(void))autoLayoutBlock{

    autoLayoutBlock();
    
    [self.superview setNeedsLayout];
    [self.superview layoutIfNeeded];

    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.frame.size);
    }];

    return self.frame.size;
    
}

-(CGSize)autoSizeWithFrame:(CGRect)frame{
    void(^autolayoutBlock)(void) = ^{
        [self makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(frame.origin.y);
            make.left.equalTo(frame.origin.x);
            if( !FloatEqual(frame.size.width, -1) && !FloatEqual(frame.size.width, 0) ){
                make.width.equalTo(frame.size.width);
            }
            if( !FloatEqual(frame.size.height, -1) && !FloatEqual(frame.size.height, 0) ){
                make.height.equalTo(frame.size.height);
            }
        }];
    };
    return [self autoSizeWithAutoLayout:autolayoutBlock];
}



@end
