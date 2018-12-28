//
//  ALXUtil.h
//  Pods
//
//  Created by Alexgao on 2018/12/18.
//

#import "NSString+ALXUtil.h"
#import "NSAttributedString+ALXUtil.h"
#import "NSDate+ALXUtil.h"

#import "UIImage+ALXUtil.h"
#import "UIView+ALXUtil.h"
#import "UIColor+ALXUtil.h"
#import "UIViewController+ALXUtil.h"

#pragma mark - Device
#define ALXDevice_iPhone    (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define ALXDevice_iPad      (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define ALXSystemVersion    [UIDevice currentDevice].systemVersion
#define ALX_SYSTEM_VERSION_EQUAL_TO(v) ([[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define ALX_SYSTEM_VERSION_GREATER_THAN(v) ([[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define ALX_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define ALX_SYSTEM_VERSION_LESS_THAN(v) ([[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define ALX_SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v) ([[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


#pragma mark - App
#define ALXAppVersion    [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleShortVersionString"]


#pragma mark - Screen
#define ALXScreenWidth     [UIScreen mainScreen].bounds.size.width
#define ALXScreenHeight    [UIScreen mainScreen].bounds.size.height
#define ALXScreenBounds    [UIScreen mainScreen].bounds
#define ALXScreenScale     [UIScreen mainScreen].scale
#define ALXScreenScaleW    ([UIScreen mainScreen].bounds.size.width/375)
#define ALXScreenScaleH    ([UIScreen mainScreen].bounds.size.height/667)


#pragma mark - Screen-Top
#define ALXStatusBarHeight         ([[UIApplication sharedApplication] statusBarFrame].size.height)
#define ALXNavigationBarHeight     44
#define ALXTopSafeArea             (ALXStatusBarHeight + ALXNavigationBarHeight)


#pragma mark - Window
#define ALXKeyWindow    [UIApplication sharedApplication].keyWindow


#pragma mark - Sandbox
#define ALXSandboxPathForCaches      [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define ALXSandboxPathForDocument    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]


#pragma mark - Bundle
#define ALXResourcePathInMainBundle(name, type)    [[NSBundle mainBundle] pathForResource:(name) ofType:(type)]


#pragma mark - UserDefaults
#define ALXUserDefaultsGet(key)    [NSUserDefaults standardUserDefaults] objectForKey:(key)]
#define ALXUserDefaultsSave(key, object) \
[[NSUserDefaults standardUserDefaults] setObject:object forKey:(key)] \
[[NSUserDefaults standardUserDefaults] synchronize];


#pragma mark - Notification
#define ALXNotificationRegister(observer, selector, name, object)    [[NSNotificationCenter defaultCenter] addObserver:observer selector:@selector(selector) name:(name) \ object:object]
#define ALXNotificationPost(name, object)     [[NSNotificationCenter defaultCenter] postNotificationName:(name) object:object];
#define ALXNotificationPostUserInfo(name, object, userInfo)    [[NSNotificationCenter defaultCenter] postNotificationName:(name) object:object userInfo:userInfo];


#pragma mark - Value
#pragma mark - Value-Convert  Assign<->Strong
#define ALXValueFromPoint(x, y)                             [NSValue valueWithCGPoint:CGPointMake(floorf(x), floorf(y))]
#define ALXValueFromSize(w, h)                              [NSValue valueWithCGSize:CGSizeMake(floorf(w), floorf(h))]
#define ALXValueFromRect(x, y, w, h)                        [NSValue valueWithCGRect:CGRectMake(floorf(x), floorf(y), floorf(w), floorf(h))]
#define ALXValueFromRange(loc, len)                         [NSValue valueWithRange:NSMakeRange((loc), (len))]
#define ALXValueFromEdgeInsets(top, left, bottom, right)    [NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(floorf(top), floorf(left), floorf(bottom), floorf(right)]


#pragma mark - Value-Convert  Degree<->Radian
#define ALXDegreesToRadian(degree) (M_PI * (x) / 180.0)
#define ALXRadianToDegrees(radian) (radian * 180.0) / (M_PI)


#pragma mark - Calendar
#define  ALXYearFromDate(date) [[NSCalendar currentCalendar] component:NSCalendarUnitYear fromDate:date]
#define  ALXMonthFromDate(date) [[NSCalendar currentCalendar] component:NSCalendarUnitMonth fromDate:date]
#define  ALXDayFromDate(date)  [[NSCalendar currentCalendar] component:NSCalendarUnitDay fromDate:date]
#define  ALXHourFromDate(date) [[NSCalendar currentCalendar] component:NSCalendarUnitHour fromDate:date]
#define  ALXMinuteFromDate(date) [[NSCalendar currentCalendar] component:NSCalendarUnitMinute fromDate:date]
#define  ALXSecondFromDate(date) [[NSCalendar currentCalendar] component:NSCalendarUnitSecond fromDate:date]
#define  ALXWeekdayFromDate(date) [[NSCalendar currentCalendar] component:NSCalendarUnitWeekday fromDate:date]


#pragma mark - Weak-Strong
/** @weakify(self) */
#ifndef weakify
#if DEBUG
#if __has_feature(objc_arc)
#define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif
/** @strongify(self) */
#ifndef strongify
#if DEBUG
#if __has_feature(objc_arc)
#define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif


#pragma mark - Singleton
/** .h    ALX_DEF_SINGLETON( __class ) */
#undef    ALX_DEF_SINGLETON
#define ALX_DEF_SINGLETON( __class ) \
+ (__class * __nonnull)sharedInstance;
/** .m    ALX_IMP_SINGLETON( __class ) */
#undef    ALX_IMP_SINGLETON
#define ALX_IMP_SINGLETON( __class ) \
+ (__class * __nonnull)sharedInstance \
{ \
static dispatch_once_t once; \
static __class * __singleton__; \
dispatch_once(&once, ^{ __singleton__ = [[__class alloc] init]; } ); \
return __singleton__; \
}


#pragma mark - Font
#define ALXFont(f)        [UIFont systemFontOfSize:f]
#define ALXBoldFont(f)    [UIFont boldSystemFontOfSize:f]


#pragma mark - Color
#define ALXRandomColor [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]
#define ALXColorRGB(hex) \
[UIColor colorWithRed:(((hex)>>16)&0xFF)/255.0 \
green:(((hex)>>8)&0xFF)/255.0 \
blue:((hex)&0xFF)/255.0 \
alpha:1.0]
#define ALXColorRGBA(hex, a) \
[UIColor colorWithRed:(((hex)>>16)&0xFF)/255.0 \
green:(((hex)>>8)&0xFF)/255.0 \
blue:((hex)&0xFF)/255.0 \
alpha:(a)]
#define ALXColorGray(f)   LGColorRGB(0x##f##f##f##f##f##f)


#pragma mark - Image
#define ALXImageNamed(name)    [UIImage imageNamed:(name)]
#define ALXImageFile(name)     [UIImage imageWithContentsOfFile:(name)]
