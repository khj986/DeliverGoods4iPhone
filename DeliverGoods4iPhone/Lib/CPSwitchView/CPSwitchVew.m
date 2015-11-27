//
//  CPSwitchVew.m
//  ChongiPet
//
//  Created by Gabriel on 13-5-31.
//  Copyright Gabriel.Zhou.All rights reserved.
//

#import "CPSwitchVew.h"
@interface CPSwitchVew()
@property (nonatomic,strong) UIImageView *backImageView;
@property (nonatomic,strong) UIImageView *iconImageView;
@property (nonatomic,strong) UILabel *statusLabel;
@end



@implementation CPSwitchVew

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        // Initialization code
        self.backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:self.backImageView];
        
        self.iconImageView = [[UIImageView alloc] init];
        [self addSubview:self.iconImageView];
        
        self.statusLabel = [[UILabel alloc] init];
        self.statusLabel.backgroundColor = [UIColor clearColor];
        self.statusLabel.textColor = [UIColor whiteColor];
        self.statusLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.statusLabel];

        UISwipeGestureRecognizer *swipGestureLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(switchSwipped:)];
        swipGestureLeft.direction = UISwipeGestureRecognizerDirectionLeft;
        
        UISwipeGestureRecognizer *swipGestureRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(switchSwipped:)];
        swipGestureRight.direction = UISwipeGestureRecognizerDirectionRight;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(switchTapped:)];
        [self addGestureRecognizer:swipGestureRight];
        [self addGestureRecognizer:swipGestureLeft];
        [self addGestureRecognizer:tapGesture];
        SAVE_RELEASE(swipGestureLeft);
        SAVE_RELEASE(swipGestureRight);
        SAVE_RELEASE(tapGesture);
    }
    return self;
}

-(void)setOnBackImage:(UIImage *)onBackImage{
    SAVE_RELEASE(_onBackImage);
    _onBackImage = onBackImage;
}

-(void)setOffBackImage:(UIImage *)offBackImage{
    SAVE_RELEASE(_offBackImage);
    _offBackImage = offBackImage;
}

-(void)setOnBeforeImage:(UIImage *)onBeforeImage{
    SAVE_RELEASE(_onBeforeImage);
    _onBeforeImage = onBeforeImage;
}

-(void)setOffBeforeImage:(UIImage *)offBeforeImage{
    SAVE_RELEASE(_offBeforeImage);
    _offBeforeImage = offBeforeImage ;
}

-(void)setOnString:(NSString *)onString{
    SAVE_RELEASE(_onString);
    _onString = [onString copy];
}

-(void)setOffString:(NSString *)offString{
    SAVE_RELEASE(_offString);
    _offString = [offString copy];
}

-(void)switchTapped:(UIGestureRecognizer *)gesture{
    [self setOn:!self.on];
}

-(void)switchSwipped:(UISwipeGestureRecognizer *)swipGesture{
    UISwipeGestureRecognizerDirection direction = swipGesture.direction;
    switch (direction) {
        case UISwipeGestureRecognizerDirectionLeft:
            if (self.on) {
                [self setOn:!self.on];
            }
            break;
        case UISwipeGestureRecognizerDirectionRight:
            if (!self.on) {
                [self setOn:!self.on];
            }
            break;
        default:
            break;
    }
    
}

-(void)setOn:(BOOL)on{
    _on = on;
    if (self.on) {
        self.backImageView.image = self.onBackImage;
        
        self.iconImageView.image = self.onBeforeImage;
        
        self.statusLabel.text = self.onString;
        
        [UIView animateWithDuration:0.25f animations:^{
            self.iconImageView.frame = CGRectMake(self.frame.size.width-self.frame.size.height, 0, self.frame.size.height, self.frame.size.height);
            
            self.statusLabel.frame = CGRectMake(0, 0, self.frame.size.width-self.frame.size.height, self.frame.size.height);
        }];
                
    }else{
        self.backImageView.image = self.offBackImage;
        
        self.iconImageView.image = self.offBeforeImage;
        
        self.statusLabel.text = self.offString;
        
        [UIView animateWithDuration:.25f animations:^{
            self.iconImageView.frame = CGRectMake(0, 0, self.frame.size.height, self.frame.size.height);
            
            self.statusLabel.frame = CGRectMake(self.frame.size.height, 0, self.frame.size.width-self.frame.size.height, self.frame.size.height);

        }];
    }
    [self sendActionsForControlEvents:UIControlEventValueChanged];

}



-(void)dealloc{
    SAVE_RELEASE(self.statusLabel);
    SAVE_RELEASE(self.backImageView);
    SAVE_RELEASE(self.iconImageView);
    SAVE_RELEASE(self.onBackImage);
    SAVE_RELEASE(self.onBackImage);
    SAVE_RELEASE(self.offBackImage);
    SAVE_RELEASE(self.offBeforeImage);
    SAVE_RELEASE(self.onString);
    SAVE_RELEASE(self.offString);
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
