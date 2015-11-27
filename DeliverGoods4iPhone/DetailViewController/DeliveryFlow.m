

#import "DeliveryFlow.h"

@implementation DeliveryNode

@end

@implementation DeliveryFlow

-(instancetype)init{
    if(self = [super init]){
        _arrayFlow = [NSMutableArray array];
    }
    return self;
}

-(void)addNode:(DeliveryNode*)node{
    [_arrayFlow addObject:node];
}

@end
