

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface DetailViewController : BaseViewController{
    float lineHeight;
    float paddingEdge;
    float paddingMiddle;
    float paddingFlow;
    float flowHeight;
}
@property (nonatomic ,strong) StaticInfoModel* staticInfo;

@property (nonatomic ) BOOL needRefresh;
//@property (nonatomic)  float fontSize;


@end
