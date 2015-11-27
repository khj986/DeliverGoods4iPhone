

#import <Foundation/Foundation.h>

//typedef NS_ENUM(NSInteger, DeliveryEventType) {
//    Type0 = 0,
//    Type1 = 1,
//    Type2  = 2,
//};

@interface DeliveryNode : NSObject

@property (nonatomic,copy) NSString * uploadTime;
@property (nonatomic,copy) NSString * logicStatus;
//@property (nonatomic) RepairEventType event;

@end

@interface DeliveryFlow : NSObject
//@property (nonatomic )  int index;
//@property (nonatomic ,strong)  NSDate * time;
//@property (nonatomic,copy) NSString * time;
////@property (nonatomic,copy) MachineErrorType errorType;
//@property (nonatomic,copy) NSString * errorType;
//@property (nonatomic,copy) NSString * district;
//@property (nonatomic,copy) NSString * reporter;
//@property (nonatomic,copy) NSString * errorDescription;
//@property (nonatomic,copy) NSString * repairman;
//@property (nonatomic,copy) NSString * errorImg;

@property (nonatomic,strong) NSMutableArray * arrayFlow;

-(void)addNode:(DeliveryNode*)node;


@end
