//
//  CPSwitchVew.h
//  ChongiPet
//
//  Created by Gabriel on 13-5-31.
//  Copyright Gabriel.Zhou.All rights reserved.
//

#import <UIKit/UIKit.h>
#define SAVE_RELEASE(X) if(X) {X = nil;}
@interface CPSwitchVew : UIControl
@property (nonatomic,assign) BOOL on;
@property (nonatomic,strong) UIImage *onBackImage;
@property (nonatomic,strong) UIImage *offBackImage;
@property (nonatomic,strong) UIImage *onBeforeImage;
@property (nonatomic,strong) UIImage *offBeforeImage;
@property (nonatomic,copy)   NSString *onString;
@property (nonatomic,copy)   NSString *offString;
- (id)initWithFrame:(CGRect)frame;
@end
