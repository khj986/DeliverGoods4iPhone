

#import <UIKit/UIKit.h>
#import "DeliveryInfoModel.h"

//static float lineHeight;
//static float paddingEdge;
//static float paddingMiddle;

@interface DetailCell : UITableViewCell

@property ( nonatomic) float lineHeight;
@property ( nonatomic) float paddingEdge;
@property ( nonatomic) float paddingMiddle;
@property ( nonatomic) float paddingFlow;
@property ( nonatomic) float flowHeight;

@property (copy, nonatomic) void(^buttonBlock)(void);
@property (strong,nonatomic) DeliveryInfoModel * model;
//@property (strong,nonatomic) NSIndexPath * indexPath;
//@property (nonatomic) float fontSize;
//@property (nonatomic)  float lineHeight;

@end
