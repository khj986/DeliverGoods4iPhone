

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TagDeliveryState) {
    
    StateDistubuting = 0,
    StateFinished = 1,
};


@interface StaticInfoModel : NSObject
//@property (nonatomic,strong) NSIndexPath * indexPath;
@property (nonatomic )  int index;
@property (nonatomic )  TagDeliveryState tag;
//@property (nonatomic ,strong)  NSDate * time;
//@property (nonatomic,copy) NSString * time;
//@property (nonatomic,copy) NSString * cargoName;

@property (nonatomic,copy) NSString * eId;
@property (nonatomic,copy) NSString * escortNo;
@property (nonatomic,copy) NSString * customName;
@property (nonatomic,copy) NSString * deliveryDate;
@property (nonatomic,copy) NSString * demandArrivalDate;
@property (nonatomic,copy) NSString * transNo;
@property (nonatomic,copy) NSString * logisticsAgreement;
@property (nonatomic,copy) NSString * carrier;
@property (nonatomic,copy) NSString * boxWeight;
@property (nonatomic,copy) NSString * boxNum;
@property (nonatomic,copy) NSString * businessDepartment;
@property (nonatomic,copy) NSString * deliveryAddress;
@property (nonatomic,copy) NSString * consignee;
@property (nonatomic,copy) NSString * consigneePhoneNumber;
@property (nonatomic,copy) NSString * deliveryNote;
@property (nonatomic,copy) NSString * transportCompany;
@property (nonatomic,copy) NSString * receivingPartyName;
@property (nonatomic,copy) NSString * driver;
@property (nonatomic,copy) NSString * driverPhoneNumber;
@property (nonatomic,copy) NSString * receipt;
@property (nonatomic,copy) NSString * materialList;
@property (nonatomic,copy) NSString * dispatchNote;

@end
