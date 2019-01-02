//
//  UIImage+ALXUtil.h
//  ALXSegmentedControl
//
//  Created by Alexgao on 2018/12/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^UIImageSaveToPhotosAlbumBlock)(NSError *saveError);
@interface UIImage (ALXUtil)

+ (UIImage *)alx_imageWithColor:(UIColor *)color;
+ (UIImage *)alx_imageWithColor:(UIColor *)color size:(CGSize)size;

+ (UIImage *)alx_cropImage:(UIImage *)image rect:(CGRect)cropRect;
+ (UIImage *)alx_fixImageOrientation:(UIImage *)image;

- (BOOL)hasAlphaChannel;
+ (UIImage*)alx_grayImageFromImage:(UIImage*)image;
+ (UIColor *)alx_colorInImage:(UIImage *)image point:(CGPoint)point;

+ (NSString *)alx_base64StringFromImage:(UIImage *)image;
+ (UIImage *)alx_imageFromBase64String:(NSString *)base64String;

- (void)alx_saveToPhotosAlbumWithResult:(UIImageSaveToPhotosAlbumBlock)result;

// TODO:Alexgao---获取视频第一帧/获取文件和网络图片大小/获取视频时长/获取图片信息

@end

NS_ASSUME_NONNULL_END
