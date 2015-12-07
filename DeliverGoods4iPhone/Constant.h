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

ScaleXDefFloat(PaddingImage)
ScaleXDefFloat(PaddingLabel)
ScaleXDefFloat(PaddingUnderline)

ScaleXDefFloat(ButtonsEdge)
ScaleXDefFloat(ButtonsMiddle)

//ScaleXFont & XFont
ScaleXDefFloat(Font)

DefFloat(LineHeight)
DefFloat(LineSpace)
//kFontSize
DefFloat(FontSize)

ScaleXDefFloat(MinImgLargeSide)
DefFloat(MidImgSmallSide)
DefFloat(MidImgLargeSide)
ScaleXDefFloat(ImgPadding)

ScaleXDefFloat(PaddingFlow)
ScaleXDefFloat(FlowHeight)
DefFloat(MinFlowHeight)

DefInt(PageSize)

+ (instancetype)sharedInstance;

@end
