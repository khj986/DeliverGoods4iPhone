//
//  ListCellLine.h
//  DeliverGoods4iPhone
//
//  Created by ztt on 15/11/7.
//  Copyright © 2015年 ztt. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIView(AutoSize){

}

-(CGSize)autoSizeAfterMasonry;
-(CGSize)autoSizeWithAutoLayout:(void(^)(void))autoLayoutBlock ;
-(CGSize)autoSizeWithFrame:(CGRect)frame ;

@end
