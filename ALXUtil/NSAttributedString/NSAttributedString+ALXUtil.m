//
//  NSAttributedString+ALXUtil.m
//  ALXSegmentedControl
//
//  Created by Alexgao on 2018/12/17.
//

#import "NSAttributedString+ALXUtil.h"
#import "ALXUtil.h"

@implementation NSAttributedString (ALXUtil)

+ (NSAttributedString *)alx_attributedStringWithString:(NSString *)string font:(UIFont *)font color:(UIColor *)color {
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:string];
    if (font) {
        [attStr addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, attStr.length)];
    }
    if (color) {
        [attStr addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, attStr.length)];
    }
    
    return attStr;
}

@end
