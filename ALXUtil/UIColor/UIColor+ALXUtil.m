//
//  UIColor+ALXUtil.m
//  ALXUtil
//
//  Created by Alexgao on 2018/12/28.
//

#import "UIColor+ALXUtil.h"

@implementation UIColor (ALXUtil)

- (BOOL)alx_isEqualToColor:(UIColor *)color {
    return CGColorEqualToColor(self.CGColor, color.CGColor);
}

@end
