

#import <UIKit/UIKit.h>
#import "BaseViewController.h"



@interface ListTableviewController : BaseViewController{

}

@property (nonatomic ) BOOL needRefresh;
+(float)getLineHeight;
+(float)getPaddingEdge;
+(float)getPaddingMiddle;

@end
