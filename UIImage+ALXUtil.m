//
//  UIImage+ALXUtil.m
//  ALXSegmentedControl
//
//  Created by Alexgao on 2018/12/17.
//

#import "UIImage+ALXUtil.h"

@implementation UIImage (ALXUtil)

+ (UIImage *)alx_imageWithColor:(UIColor *)color{
    
    CGSize imageSize = CGSizeMake(1.0f, 1.0f);
    UIGraphicsBeginImageContext(imageSize);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0.0f, 0.0f, imageSize.width, imageSize.height));
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

@end
