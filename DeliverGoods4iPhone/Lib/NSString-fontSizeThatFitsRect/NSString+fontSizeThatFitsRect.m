//
//  NSString+fontSizeThatFitsRect.m
//  fontSizeThatFitsRect category
//
//  Created by Niklas Berglund on 10/16/15.

//  The MIT License (MIT)
//
//  Copyright (c) 2015 Niklas Berglund
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.


#import "NSString+fontSizeThatFitsRect.h"

@implementation NSString (fontSizeThatFitsRect)

- (CGFloat)fontSizeSingleLineFitsRect:(CGRect)rect attributes:(nullable NSDictionary *)attr
{
    float sizeIncrementBig = 4;
    float sizeIncrementSmall = 1;
    float startFontSize = 1;
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setDictionary:attr];
    UIFont *font =[attr objectForKey:NSFontAttributeName];
    
    float currentFontSize = startFontSize;
    
    [dict setValue:[UIFont fontWithName:font.fontName size:currentFontSize] forKey:NSFontAttributeName];
    
    CGSize currentSize = [self sizeWithAttributes:dict];
    
    // first do big increments with sizeIncrementBig
    while (currentSize.width <= rect.size.width && currentSize.height <= rect.size.height) {
        currentFontSize = currentFontSize + sizeIncrementBig;
        [dict setValue:[UIFont fontWithName:font.fontName size:currentFontSize] forKey:NSFontAttributeName];
        currentSize = [self sizeWithAttributes:dict];
    }
    
    currentFontSize = currentFontSize - sizeIncrementBig;
    [dict setValue:[UIFont fontWithName:font.fontName size:currentFontSize] forKey:NSFontAttributeName];
    currentSize = [self sizeWithAttributes:dict];
    
    // and now do small increments with sizeIncrementSmall
    while (currentSize.width <= rect.size.width && currentSize.height <= rect.size.height) {
        currentFontSize = currentFontSize + sizeIncrementSmall;
        [dict setValue:[UIFont fontWithName:font.fontName size:currentFontSize] forKey:NSFontAttributeName];
        currentSize = [self sizeWithAttributes:dict];
    }
    
    return currentFontSize - sizeIncrementSmall;
}

- (CGFloat)fontSizeSingleLineFitsWidth:(CGFloat)width attributes:(nullable NSDictionary *)attr{
    return [self fontSizeSingleLineFitsRect:CGRectMake(0,0,width,MAXFLOAT) attributes:attr];
}

- (CGFloat)fontSizeSingleLineFitsHeight:(CGFloat)height attributes:(nullable NSDictionary *)attr{
    return [self fontSizeSingleLineFitsRect:CGRectMake(0,0,MAXFLOAT,height) attributes:attr];
}


- (CGFloat)fontSizeMultiLineFitsRect:(CGRect)rect attributes:(nullable NSDictionary *)attr
{
    float sizeIncrementBig = 4;
    float sizeIncrementSmall = 1;
    float startFontSize = 1;
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setDictionary:attr];
    UIFont *font =[attr objectForKey:NSFontAttributeName];
    
    float currentFontSize = startFontSize;
    
    [dict setValue:[UIFont fontWithName:font.fontName size:currentFontSize] forKey:NSFontAttributeName];
    
    CGSize currentSize = [self boundingRectWithSize:CGSizeMake(rect.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                         attributes:dict context:nil].size;
    
    // first do big increments with sizeIncrementBig
    while (currentSize.width <= rect.size.width && currentSize.height <= rect.size.height) {
        currentFontSize = currentFontSize + sizeIncrementBig;
        
        [dict setValue:[UIFont fontWithName:font.fontName size:currentFontSize] forKey:NSFontAttributeName];
        
        currentSize = [self boundingRectWithSize:CGSizeMake(rect.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                      attributes:dict context:nil].size;
    }
    
    currentFontSize = currentFontSize - sizeIncrementBig;
    [dict setValue:[UIFont fontWithName:font.fontName size:currentFontSize] forKey:NSFontAttributeName];
    
    currentSize = [self boundingRectWithSize:CGSizeMake(rect.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                  attributes:dict context:nil].size;
    
    // and now do small increments with sizeIncrementSmall
    while (currentSize.width <= rect.size.width && currentSize.height <= rect.size.height) {
        currentFontSize = currentFontSize + sizeIncrementSmall;
        [dict setValue:[UIFont fontWithName:font.fontName size:currentFontSize] forKey:NSFontAttributeName];
        
        currentSize = [self boundingRectWithSize:CGSizeMake(rect.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                      attributes:dict context:nil].size;
    }
    
    return currentFontSize - sizeIncrementSmall;
}

- (CGFloat)fontSizeMultiLineFitsHeight:(CGFloat)height attributes:(nullable NSDictionary *)attr{
    return [self fontSizeMultiLineFitsRect:CGRectMake(0, 0, MAXFLOAT, height) attributes:nil];
}

@end
