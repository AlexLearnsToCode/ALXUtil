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

- (void)alx_addCorners:(UIRectCorner)corners radius:(CGSize)size{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:size];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (UIImage *)alx_snapshot{
    return [self alx_snapshotWithScale:[UIScreen mainScreen].scale];
}
- (UIImage *)alx_snapshotWithScale:(CGFloat)scale{
    return [self alx_snapshotWithScale:scale rect:self.bounds];
}
- (UIImage *)alx_snapshotWithScale:(CGFloat)scale rect:(CGRect)rect{
    if (scale == 1) {
        UIGraphicsBeginImageContext(rect.size);
    } else {
        UIGraphicsBeginImageContextWithOptions(rect.size, NO, scale);
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextConcatCTM(context, CGAffineTransformMakeTranslation(-rect.origin.x, -rect.origin.y));
    
    if (![self drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES]) {
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIViewController *)alx_viewController{
    id responder = self.nextResponder;
    while (![responder isKindOfClass: [UIViewController class]] && ![responder isKindOfClass: [UIWindow class]]){
        responder = [responder nextResponder];
    }
    if ([responder isKindOfClass: [UIViewController class]]){
        return responder;
    }
    return nil;
}

@end
