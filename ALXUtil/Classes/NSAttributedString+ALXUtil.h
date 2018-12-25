//
//  NSAttributedString+ALXUtil.h
//  ALXSegmentedControl
//
//  Created by Alexgao on 2018/12/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSAttributedString (ALXUtil)

+ (NSAttributedString *)alx_attributedStringWithString:(NSString *)string font:(UIFont *)font color:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
