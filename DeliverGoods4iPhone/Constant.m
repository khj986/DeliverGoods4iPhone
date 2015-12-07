//
//  Constant.m
//  DeliverGoods4iPhone
//
//  Created by ztt on 15/11/24.
//  Copyright © 2015年 ztt. All rights reserved.
//

#import "Constant.h"

//float x =0;
//CLLocationManager* _locationManager = nil;
//float const EdgeY = 10;

@implementation Constant

+ (instancetype)sharedInstance

{
    
    static dispatch_once_t once;
    
    static id sharedInstance;
    
    dispatch_once(&once, ^{
        
        sharedInstance = [[self alloc] init];
        
    });
    
    return sharedInstance;
    
}

-(instancetype)init{
    self = [super init];
    if(self){
        
        ScaleXImp(Edge,28)
        ScaleYImp(Edge,10)
        ScaleXImp(Middle,10)
        ScaleYImp(Middle,5)
        ScaleXImp(PaddingImage,8)
        ScaleXImp(PaddingLabel,5)
        ScaleXImp(PaddingUnderline,5)
        
        ScaleXImp(ButtonsEdge,48)
        ScaleXImp(ButtonsMiddle,48)
        
        ScaleXImp(Font,40)
        ScaleYImp(ButtonAndContent,20)
        Imp(LineHeight,_ScaleXFont)
        Imp(LineSpace,0)
        Imp(FontSize,_ScaleXFont)
        
        ScaleXImp(MinImgLargeSide,300)
        Imp(MidImgSmallSide,480)
        Imp(MidImgLargeSide,960)
        ScaleXImp(ImgPadding,10)          
        
        ScaleXImp(PaddingFlow,35)
        ScaleXImp(FlowHeight,115)
        Imp(MinFlowHeight,40)
        
        Imp(PageSize,10)
    }
    return self;
}

@end
