//
//  NSString+ALXUtil.h
//  ALXUtil
//
//  Created by Alexgao on 2018/12/28.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCrypto.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, ALXStringType) {
    ALXStringTypePhoneNumber     = 1 << 0,
    ALXStringTypeMobileNumber    = 1 << 1,
    ALXStringTypeEmail           = 1 << 2,
    ALXStringTypeEmailDomainName = 1 << 3,
    ALXStringTypeURL             = 1 << 3,
    ALXStringTypeAll             = ~0UL
};

typedef NS_ENUM(NSInteger, ALXHashAlgorithm) {
    /** md5_16 */
    ALXHashAlgorithmmd516 = 1,
    /** md5_32 */
    ALXHashAlgorithmmd532,
    /** MD5_16_Uppercase */
    ALXHashAlgorithmMD516,
    /** MD5_32_Uppercase */
    ALXHashAlgorithmMD532,
    /** sha1 */
    ALXHashAlgorithmSHA1,
    /** sha256 */
    ALXHashAlgorithmSHA256,
    /** sha384 */
    ALXHashAlgorithmSHA384,
    /** sha512 */
    ALXHashAlgorithmSHA512,
    /** sha224 */
    ALXHashAlgorithmSHA224
};

typedef NS_ENUM(NSInteger, ALXPKCSPadding) {
    ALXPKCSNoPadding = 0,
    /** 主要用于非对称加密 */
    ALXPKCS1Padding,
    ALXPKCS5Padding,
    ALXPKCS7Padding = ALXPKCS5Padding
};

@interface NSString (ALXUtil)
/** replace "key" in "target" with "replacement[key]" */
- (NSString *)alx_stringByReplacingOccurrencesOfString:(NSString *)target withDictionary:(NSDictionary<NSString *, NSString *> *)replacement;

#pragma mark - Size
- (CGSize)alx_sizeWithFont:(UIFont *)font;
- (CGSize)alx_sizeWithMaxWidth:(CGFloat)width font:(UIFont *)font;
- (CGSize)alx_sizewithMaxHeight:(CGFloat)height font:(UIFont *)font;

#pragma mark - Verify
/** type->regex->predicate->string */


#pragma mark - Encode && Decode
#pragma mark - *** Base64 ***
- (NSString *)alx_base64EncodedString;
- (NSString *)alx_base64DecodedString;

// !!!:Alexgao--- 加密解密不适合做成工具方法,还是做成一个工具类比较好
#pragma mark - Encrypt && Decrypt
#pragma mark - *** Hash/Hmac ***
- (NSString *)alx_hashStringWithAlgorithm:(ALXHashAlgorithm)algorithm;
- (NSString *)alx_HmacStringWithAlgorithm:(ALXHashAlgorithm)algorithm key:(NSString *)key;

#pragma mark - *** Symmetric Encryption(public key = private key) ***
/* ECB(Block Ciphers Mode) */
- (NSString *)alx_ECBEncryptWithAlgorithm:(CCAlgorithm)algorithm key:(NSString *)key padding:(ALXPKCSPadding)padding;
- (NSString *)alx_ECBDecryptWithAlgorithm:(CCAlgorithm)algorithm key:(NSString *)key padding:(ALXPKCSPadding)padding;

/* CBC(Block Ciphers Mode) */
- (NSString *)alx_CBCEncryptWithAlgorithm:(CCAlgorithm)algorithm key:(NSString *)key padding:(ALXPKCSPadding)padding iv:(NSString *)iv;
- (NSString *)alx_CBCDecryptWithAlgorithm:(CCAlgorithm)algorithm key:(NSString *)key padding:(ALXPKCSPadding)padding iv:(NSString *)iv;

#pragma mark - *** Asymmetric Encryption(public key, private key) ***
#pragma mark - *** *** RSA *** ***
- (NSString *)alx_RSAEntryptWithPublicKey:(NSString *)publicKey;
- (NSString *)alx_RSAEntryptWithContentsOfPublicKey:(NSString *)publicKeyFilePath;

- (NSString *)alx_RSADecryptWithPrivateKey:(NSString *)privateKey;
- (NSString *)alx_RSADecryptWithContentsOfPrivateKey:(NSString *)privateKeyFilePath password:(NSString *)password;

@end

NS_ASSUME_NONNULL_END
