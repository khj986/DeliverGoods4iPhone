

#import <UIKit/UIKit.h>
#import "StaticInfoModel.h"

//static float lineHeight;
//static float paddingEdge;
//static float paddingMiddle;

@interface ListCell : UITableViewCell{
//    float lineHeight;
//    float paddingEdge;
//    float paddingMiddle;
}

//@property ( nonatomic) float lineHeight;
//@property ( nonatomic) float paddingEdge;
//@property ( nonatomic) float paddingMiddle;
@property (copy, nonatomic) void(^buttonBlock)(void);
@property (strong,nonatomic) StaticInfoModel * model;
@end
