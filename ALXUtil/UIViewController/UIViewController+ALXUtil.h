//
//  UIViewController+ALXUtil.h
//  ALXUtil
//
//  Created by Alexgao on 2018/12/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (ALXUtil)

#pragma mark - Layout
/**
 注意：导航栏什么的不是一开始就有的
 ios11以前：没有导航栏时是20，有导航栏时是44；ios11及以后：用.view.safeAreaInsets.top
 */
@property (nonatomic, readonly) CGFloat alx_topSafeArea;
/**
 注意：tabBar什么的不是一开始就有的
 ios11以前：没有tabBar时是0，有tabBar时时49；ios11及以后：用.view.safeAreaInsets.bottom
 */
@property (nonatomic, readonly) CGFloat alx_bottomSafeArea;

@end

NS_ASSUME_NONNULL_END
