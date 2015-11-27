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


#import "NSAttributedString+fontSizeThatFitsRect.h"

@implementation NSAttributedString (fontSizeThatFitsRect)



- (CGFloat)fontSizeThatFitsRect:(CGRect)rect
{
    float sizeIncrementBig = 4;
    float sizeIncrementSmall = 1;
    float startFontSize = 1;
    
    NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc]initWithAttributedString:self];


    float currentFontSize = startFontSize;
    [attStr enumerateAttribute:NSFontAttributeName inRange:NSMakeRange(0, [attStr length]) options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(id value,NSRange range, BOOL *  stop) {
        UIFont * font = value;
       // NSLog(@"font1:%@",font);
        if(font){
            font = [font fontWithSize:currentFontSize];
            [attStr addAttribute:NSFontAttributeName value:font range:range];
        }
        else{
            font = [UIFont fontWithName:nil size:currentFontSize];
            [attStr addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, [attStr length])];
        }

    }];
    NSRange range = NSMakeRange(0, [attStr length]);
    NSDictionary * dict =  [attStr attributesAtIndex:0 effectiveRange:&range];
    UIFont *font =[dict objectForKey:NSFontAttributeName];
   // NSLog(@"font1c:%@",font);
    CGSize currentSize = [attStr boundingRectWithSize:CGSizeMake(rect.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                          context:nil].size;
    
    // first do big increments with sizeIncrementBig
    while (currentSize.width <= rect.size.width && currentSize.height <= rect.size.height) {
        currentFontSize = currentFontSize + sizeIncrementBig;
        
        [attStr enumerateAttribute:NSFontAttributeName inRange:NSMakeRange(0, [attStr length]) options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(id   value, NSRange range, BOOL *  stop) {
            UIFont * font = value;
            if(font){
                font = [font fontWithSize:currentFontSize];
                [attStr addAttribute:NSFontAttributeName value:font range:range];
            }
            else{
                font = [UIFont fontWithName:nil size:currentFontSize];
                [attStr addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, [attStr length])];
            }
        }];
        
        
        currentSize = [attStr boundingRectWithSize:CGSizeMake(rect.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                                context:nil].size;
    }
    
    currentFontSize = currentFontSize - sizeIncrementBig;
    [attStr enumerateAttribute:NSFontAttributeName inRange:NSMakeRange(0, [attStr length]) options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(id  value, NSRange range, BOOL *  stop) {
        UIFont * font = value;
        if(font){
            font = [font fontWithSize:currentFontSize];
            [attStr addAttribute:NSFontAttributeName value:font range:range];
        }
        else{
            font = [UIFont fontWithName:nil size:currentFontSize];
            [attStr addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, [attStr length])];
        }
    }];
    
    currentSize = [attStr boundingRectWithSize:CGSizeMake(rect.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                     context:nil].size;
    
    // and now do small increments with sizeIncrementSmall
    while (currentSize.width <= rect.size.width && currentSize.height <= rect.size.height) {
        currentFontSize = currentFontSize + sizeIncrementSmall;
        [attStr enumerateAttribute:NSFontAttributeName inRange:NSMakeRange(0, [attStr length]) options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(id   value, NSRange range, BOOL *  stop) {
            UIFont * font = value;
            if(font){
                font = [font fontWithSize:currentFontSize];
                [attStr addAttribute:NSFontAttributeName value:font range:range];
            }
            else{
                font = [UIFont fontWithName:nil size:currentFontSize];
                [attStr addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, [attStr length])];
            }
        }];
        
        currentSize = [attStr boundingRectWithSize:CGSizeMake(rect.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                         context:nil].size;
    }
    
    return currentFontSize - sizeIncrementSmall;
}

- (CGFloat)fontSizeThatFitsHeight:(CGFloat)height{
    return [self fontSizeThatFitsRect:CGRectMake(0, 0, MAXFLOAT, height)];
}



@end
