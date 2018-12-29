//
//  UIView+ALXUtil.h
//  ALXSegmentedControl
//
//  Created by Alexgao on 2018/12/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (ALXUtil)

#pragma mark - Layout
@property (nonatomic) CGFloat alx_x;
@property (nonatomic) CGFloat alx_y;
@property (nonatomic) CGFloat alx_rightX;
@property (nonatomic) CGFloat alx_bottomY;
@property (nonatomic) CGFloat alx_width;
@property (nonatomic) CGFloat alx_height;
@property (nonatomic) CGPoint alx_origin;
@property (nonatomic) CGSize alx_size;
@property (nonatomic) CGFloat alx_centerX;
@property (nonatomic) CGFloat alx_centerY;

- (void)alx_addCorners:(UIRectCorner)corners radius:(CGSize)size;

- (UIImage *)alx_snapshot;
- (UIImage *)alx_snapshotWithScale:(CGFloat)scale;
- (UIImage *)alx_snapshotWithScale:(CGFloat)scale rect:(CGRect)rect;

- (UIViewController *)alx_viewController;

@end

NS_ASSUME_NONNULL_END
