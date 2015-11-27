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
        ScaleXImp(Font,32)
        ScaleYImp(ButtonAndContent,20)
        Imp(LineHeight,_ScaleXFont)
        Imp(FontSize,_ScaleXFont)
        Imp(PageSize,10)
    }
    return self;
}

@end
