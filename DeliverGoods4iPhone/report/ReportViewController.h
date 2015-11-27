

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "DeliveryInfoModel.h"
#import "LeveyPopListView.h"
#import <CoreLocation/CoreLocation.h>

@interface ReportViewController : BaseViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate,CLLocationManagerDelegate,UIAlertViewDelegate,UIGestureRecognizerDelegate>

@property (strong,nonatomic) DeliveryInfoModel * model;

+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize;

@end
