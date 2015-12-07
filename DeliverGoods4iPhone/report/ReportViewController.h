

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "DeliveryInfoModel.h"
#import "LeveyPopListView.h"
#import <CoreLocation/CoreLocation.h>

typedef NS_ENUM(NSInteger, ImgShowType) {
    ImgShowTypeSquare = 0,
    ImgShowTypeCenter = 1,
    ImgShowTypeExtention =2
};

@interface ReportViewController : BaseViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate,CLLocationManagerDelegate,UIAlertViewDelegate,UIGestureRecognizerDelegate>

@property (strong,nonatomic) DeliveryInfoModel * model;

+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize;

@end
