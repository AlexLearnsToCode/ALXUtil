//
//  UIViewController+ALXUtil.m
//  ALXUtil
//
//  Created by Alexgao on 2018/12/28.
//

#import "UIViewController+ALXUtil.h"

@implementation UIViewController (ALXUtil)

/**
 注意：导航栏什么的不是一开始就有的
 ios11以前：没有导航栏时是20，有导航栏时是44；ios11及以后：用.view.safeAreaInsets.top
 */
- (CGFloat)alx_topSafeArea {
    
    if (@available(iOS 11.0, *)) {
        return self.view.safeAreaInsets.top;
    } else {
        return self.topLayoutGuide.length;
    }
}
/**
 注意：tabBar什么的不是一开始就有的
 ios11以前：没有tabBar时是0，有tabBar时时49；ios11及以后：用.view.safeAreaInsets.bottom
 */
- (CGFloat)alx_bottomSafeArea {
    
    if (@available(iOS 11.0, *)) {
        return self.view.safeAreaInsets.bottom;
    } else {
        if (self.hidesBottomBarWhenPushed) {
            return 0;
        }
        return self.bottomLayoutGuide.length;
    }
}

@end
