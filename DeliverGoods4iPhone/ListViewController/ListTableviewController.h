

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

typedef NS_ENUM(NSInteger, TagDeliveryState) {
    
    StateDistubuting = 0,
    StateFinished = 1,
};

@interface ListTableviewController : BaseViewController{

}

+(float)getLineHeight;
+(float)getPaddingEdge;
+(float)getPaddingMiddle;

@end
