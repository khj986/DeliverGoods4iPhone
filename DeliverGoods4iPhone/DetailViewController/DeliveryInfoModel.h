

#import <Foundation/Foundation.h>
#import "DeliveryFlow.h"
#import "StaticInfoModel.h"

@interface DeliveryInfoModel : NSObject
@property (nonatomic )  int index;
@property (nonatomic ,strong) DeliveryFlow* flow;
@property (nonatomic ,strong) StaticInfoModel* staticInfo;


@end


