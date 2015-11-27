

#define IOS8 [[[UIDevice currentDevice]systemVersion] floatValue] >= 8.0

#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height
#define ViewFrameW(view) view.frame.size.width
#define ViewFrameH(view) view.frame.size.height
#define MasonryWidth(view) view.mas_width
#define MasonryHeight(view) view.mas_height
#define MasonryRight(view) view.mas_right
#define MasonryBottom(view) view.mas_bottom

#define ScaleX (ScreenW/640.0)
#define ScaleY (ScreenH/1136.0)

#define Imp(name,value) _k##name = value;
#define XImp(name,value) _X##name = value;
#define YImp(name,value) _Y##name = value;
#define ScaleXImp(name,value) _X##name = value;\
_ScaleX##name = _X##name * ScaleX;
#define ScaleYImp(name,value) _Y##name = value;\
_ScaleY##name = _Y##name * ScaleY;

#define ScaleXDefFloat(name) @property (nonatomic,readonly)  float  X##name;\
@property (nonatomic,readonly)  float  ScaleX##name;
#define ScaleYDefFloat(name) @property (nonatomic,readonly) float Y##name;\
@property (nonatomic,readonly) float ScaleY##name;
#define XDefFloat(name) @property (nonatomic,readonly) float X##name;
#define YDefFloat(name) @property (nonatomic,readonly) float Y##name;
#define DefFloat(name) @property (nonatomic,readonly) float k##name;
#define XDefInt(name) @property (nonatomic,readonly) int X##name;
#define YDefInt(name) @property (nonatomic,readonly) int Y##name;
#define DefInt(name) @property (nonatomic,readonly) int k##name;
#define CONST [Constant sharedInstance]

#define MAS_SHORTHAND
#define MAS_SHORTHAND_GLOBALS
#import "Masonry.h"
#define WeakSelf __weak typeof(self) weakSelf = self;

#import "NSString+fontSizeThatFitsRect.h"
#import "NSAttributedString+fontSizeThatFitsRect.h"

#define XYColor(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#define URLBase @"http://10.18.3.98:10001/SalesWebTest"

// 在这里自定义log
#ifdef DEBUG
#define XYLog(...) NSLog(__VA_ARGS__)
#else
#define XYLog(...) // NSLog(__VA_ARGS__)
#endif


