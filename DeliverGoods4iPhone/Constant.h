//
//  Constant.h
//  DeliverGoods4iPhone
//
//  Created by ztt on 15/11/24.
//  Copyright © 2015年 ztt. All rights reserved.
//
#import "Prefix.h"
#import <Foundation/Foundation.h>

//@class CLLocationManager;

//extern float x ;
//extern CLLocationManager* _locationManager;
//ScaleYDefine(kEdgeY)

@interface Constant : NSObject

ScaleXDefFloat(Edge)
ScaleYDefFloat(Edge)
ScaleXDefFloat(Middle)
ScaleYDefFloat(Middle)
ScaleYDefFloat(ButtonAndContent)


//ScaleXFont & XFont
ScaleXDefFloat(Font)

DefFloat(LineHeight)

//kFontSize
DefFloat(FontSize)

DefInt(PageSize)

+ (instancetype)sharedInstance;

@end
