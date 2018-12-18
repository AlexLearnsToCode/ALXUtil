//
//  UIView+ALXUtil.m
//  ALXSegmentedControl
//
//  Created by Alexgao on 2018/12/17.
//

#import "UIView+ALXUtil.h"

@implementation UIView (ALXUtil)

- (void)setAlx_x:(CGFloat)alx_x {
    CGRect frame = self.frame;
    frame.origin.x = alx_x;
    self.frame = frame;
}
- (CGFloat)alx_x {
    return self.frame.origin.x;
}

- (void)setAlx_y:(CGFloat)alx_y {
    CGRect frame = self.frame;
    frame.origin.y = alx_y;
    self.frame = frame;
}
- (CGFloat)alx_y {
    return self.frame.origin.y;
}

- (void)setAlx_rightX:(CGFloat)alx_rightX {
    CGRect frame = self.frame;
    frame.origin.x = alx_rightX - frame.size.width;
    self.frame = frame;
}
- (CGFloat)alx_rightX {
    CGRect frame = self.frame;
    return frame.origin.x + frame.size.width;
}

- (void)setAlx_bottomY:(CGFloat)alx_bottomY {
    CGRect frame = self.frame;
    frame.origin.y = alx_bottomY - frame.size.height;
    self.frame = frame;
}
- (CGFloat)alx_bottomY {
    CGRect frame = self.frame;
    return frame.origin.y + frame.size.height;
}

- (void)setAlx_width:(CGFloat)alx_width {
    CGRect frame = self.frame;
    frame.size.width = alx_width;
    self.frame = frame;
}
- (CGFloat)alx_width {
    return self.frame.size.width;
}

- (void)setAlx_height:(CGFloat)alx_height {
    CGRect frame = self.frame;
    frame.size.height = alx_height;
    self.frame = frame;
}
- (CGFloat)alx_height {
    return self.frame.size.height;
}

- (void)setAlx_origin:(CGPoint)alx_origin {
    CGRect frame = self.frame;
    frame.origin = alx_origin;
    self.frame = frame;
}
- (CGPoint)alx_origin {
    return self.frame.origin;
}

- (void)setAlx_size:(CGSize)alx_size {
    CGRect frame = self.frame;
    frame.size = alx_size;
    self.frame = frame;
}
- (CGSize)alx_size {
    return self.frame.size;
}

- (void)setAlx_centerX:(CGFloat)alx_centerX {
    CGPoint center = self.center;
    center.x = alx_centerX;
    self.center = center;
}
- (CGFloat)alx_centerX {
    return self.center.x;
}
- (void)setAlx_centerY:(CGFloat)alx_centerY {
    CGPoint center = self.center;
    center.y = alx_centerY;
    self.center = center;
}
- (CGFloat)alx_centerY {
    return self.center.y;
}

@end
