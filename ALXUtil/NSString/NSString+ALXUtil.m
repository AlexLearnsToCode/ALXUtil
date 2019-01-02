//
//  NSString+ALXUtil.m
//  ALXUtil
//
//  Created by Alexgao on 2018/12/28.
//

#import "NSString+ALXUtil.h"

static int ALXLengthFromHashAlgorithm(ALXHashAlgorithm algorithm) {
    switch (algorithm) {
        case ALXHashAlgorithmmd516:
        case ALXHashAlgorithmMD516:{
            return CC_MD5_DIGEST_LENGTH;
        }
        case ALXHashAlgorithmmd532:
        case ALXHashAlgorithmMD532:{
            return CC_MD5_DIGEST_LENGTH * 2;
        }
        case ALXHashAlgorithmSHA1:{
           return CC_SHA1_DIGEST_LENGTH;
        }
        case ALXHashAlgorithmSHA256:{
            return CC_SHA256_DIGEST_LENGTH;
        }
        case ALXHashAlgorithmSHA384:{
            return CC_SHA384_DIGEST_LENGTH;
        }
        case ALXHashAlgorithmSHA512:{
            return CC_SHA512_DIGEST_LENGTH;
        }
        case ALXHashAlgorithmSHA224:{
            return CC_SHA224_DIGEST_LENGTH;
        }
        default:
            return -1;
    }
}

static BOOL ALXUppercaseFromHashAlgorithm(ALXHashAlgorithm algorithm) {
    switch (algorithm) {
        case ALXHashAlgorithmMD516:
        case ALXHashAlgorithmMD532:{
            return YES;
        }
        default:
            return NO;
    }
}

static CCHmacAlgorithm ALXHmacAlgorithmFromHashAlgorithm(ALXHashAlgorithm algorithm) {
    switch (algorithm) {
        case ALXHashAlgorithmmd516:
        case ALXHashAlgorithmMD516:
        case ALXHashAlgorithmmd532:
        case ALXHashAlgorithmMD532:{
            return kCCHmacAlgMD5;
        }
        case ALXHashAlgorithmSHA1:{
            return kCCHmacAlgSHA1;
        }
        case ALXHashAlgorithmSHA256:{
            return kCCHmacAlgSHA256;
        }
        case ALXHashAlgorithmSHA384:{
            return kCCHmacAlgSHA384;
        }
        case ALXHashAlgorithmSHA512:{
            return kCCHmacAlgSHA512;
        }
        case ALXHashAlgorithmSHA224:{
            return kCCHmacAlgSHA224;
        }
    }
}

static CCOptions ALXOptionsFromModeAndPadding(CCMode mode, ALXPKCSPadding padding) {
    if (mode == kCCModeECB) {
        switch (padding) {
            case ALXPKCSNoPadding:{
                return 0x0000 | kCCModeECB;
            }
            case ALXPKCS7Padding:{
                return kCCOptionPKCS7Padding | kCCModeECB;
            }
            default:
                return 0x1111;
        }
    } else if (mode == kCCModeCBC) {
        switch (padding) {
            case ALXPKCSNoPadding:{
                return 0x0000;
            }
            case ALXPKCS7Padding:{
                return kCCOptionPKCS7Padding;
            }
            default:
                return 0x1111;
        }
    }
    return 0x1111;
}

@implementation NSString (ALXUtil)

- (NSString *)alx_stringByReplacingOccurrencesOfString:(NSString *)target withDictionary:(NSDictionary<NSString *, NSString *> *)replacement{
    NSMutableString *tempString = [NSMutableString stringWithString:target];
    for (NSString *key in replacement) {
        NSRange keyRange = [tempString rangeOfString:key];
        if (keyRange.length > 1) {
            [tempString replaceCharactersInRange:keyRange withString:replacement[key]];
        }
    }
    return [tempString copy];
}

/*
- (NSString *)alx_stringByReplacingOccurrencesOfString:(NSString *)target withDictionary:(NSDictionary<NSString *, NSString *> *)replacement{
    //先拆分字典成c字符串的结构
    NSUInteger dicLen = replacement.count;
    const char *fromChars[dicLen];
    const char *toChars[dicLen];
    NSUInteger fromLen[dicLen];
    NSUInteger toLen[dicLen];
    int i=0;
    for (NSString *key in replacement) {
        if (key.length<1) {
            //字符串长度小于1，不予查找，跳过
            dicLen --;
            continue;
        }
        NSString *value = replacement[key];
        fromChars[i] = [key cStringUsingEncoding:NSUTF8StringEncoding];
        fromLen[i] = [key lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
        toChars[i] = [value cStringUsingEncoding:NSUTF8StringEncoding];
        toLen[i] = [value lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
        i++;
    }
 
    //将输入转换成c写法
    const char *inStr = [target cStringUsingEncoding:NSUTF8StringEncoding];
    NSUInteger inLen = [target lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
 
    //预申请输出长度，因为替换时长度可能变长，所以多申请一点
    NSUInteger outLen = inLen+100;
    char * outStr = malloc(outLen);
 
    NSUInteger inIndex = 0;
    NSUInteger outIndex = 0;
 
    int j;
 
    //循环查找并替换
    while (inIndex<inLen) {
        for (i=0; i<dicLen; i++) {
            for (j=0; j<fromLen[dicLen]; j++) {
                if (inIndex+j>=inLen || (inStr[inIndex+j]!=fromChars[i][j])) {
                    break;
                }
            }
            if (j == fromLen[i]) {
                break;
            }
        }
 
        if (i != dicLen) {
            if (outIndex+toLen[i]+1>=outLen) {
                NSUInteger newOutLen = outLen+toLen[i]+inLen-inIndex+500;
                char *tmpStr = malloc(newOutLen);
                memcpy(tmpStr, outStr, outIndex);
                free(outStr);
                outStr = tmpStr;
                outLen = newOutLen;
            }
 
            for (j=0; j<toLen[i]; j++) {
                outStr[outIndex+j] = toChars[i][j];
            }
            inIndex += fromLen[i];
            outIndex += toLen[i];
        } else {
            if (outIndex+2>=outLen) {
                NSUInteger newOutLen = outLen+inLen-inIndex+500;
                char *tmpStr = malloc(newOutLen);
                memcpy(tmpStr, outStr, outIndex);
                free(outStr);
                outStr = tmpStr;
                outLen = newOutLen;
            }
            outStr[outIndex] = inStr[inIndex];
            outIndex ++;
            inIndex ++;
        }
    }
    outStr[outIndex] = '\0';
    NSString *outString = [NSString stringWithCString:outStr encoding:NSUTF8StringEncoding];
    free(outStr);
     return outString;
}
 */

#pragma mark - Size

-(CGSize)alx_sizeWithFont:(UIFont *)font{
    return [self sizeWithAttributes:@{NSFontAttributeName: font}];
}

- (CGSize)alx_sizeWithMaxWidth:(CGFloat)width font:(UIFont *)font{
    CGSize size = [self boundingRectWithSize:CGSizeMake(width, 0)
                                  options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                               attributes:@{NSFontAttributeName: font}
                                  context:nil].size;
    return size;
}

- (CGSize)alx_sizewithMaxHeight:(CGFloat)height font:(UIFont *)font{
    CGSize size = [self boundingRectWithSize:CGSizeMake(0, height)
                                     options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                  attributes:@{NSFontAttributeName: font}
                                     context:nil].size;
    return size;
}

#pragma mark - Encode && Decode
#pragma mark - *** Base64 ***
- (NSString *)alx_base64EncodedString{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

- (NSString *)alx_base64DecodedString{
    NSData *data = [[NSData alloc] initWithBase64EncodedString:self options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

#pragma mark - Encrypt && Decrypt
#pragma mark - *** Hash/Hmac ***
- (NSString *)alx_hashStringWithAlgorithm:(ALXHashAlgorithm)algorithm {
    const char* input = [self UTF8String];
    int length = ALXLengthFromHashAlgorithm(algorithm);
    BOOL uppercase = ALXUppercaseFromHashAlgorithm(algorithm);
    
    unsigned char result[length];
    
    switch (algorithm) {
        case ALXHashAlgorithmmd516:
        case ALXHashAlgorithmMD516:
        case ALXHashAlgorithmmd532:
        case ALXHashAlgorithmMD532:{
            CC_MD5(input, (CC_LONG)strlen(input), result);
            break;
        }
        case ALXHashAlgorithmSHA1:{
            CC_SHA1(input, (CC_LONG)strlen(input), result);
            break;
        }
        case ALXHashAlgorithmSHA256:{
            CC_SHA256(input, (CC_LONG)strlen(input), result);
            break;
        }
        case ALXHashAlgorithmSHA384:{
            CC_SHA384(input, (CC_LONG)strlen(input), result);
            break;
        }
        case ALXHashAlgorithmSHA512:{
            CC_SHA512(input, (CC_LONG)strlen(input), result);
            break;
        }
        case ALXHashAlgorithmSHA224:{
            CC_SHA224(input, (CC_LONG)strlen(input), result);
            break;
        }
        default:
            break;
    }
    return [NSString alx_internal_hashStringWithBytes:result length:length uppercase:uppercase];
}

- (NSString *)alx_HmacStringWithAlgorithm:(ALXHashAlgorithm)algorithm key:(NSString *)key {
    const char *input = self.UTF8String;
    const char *keyData = key.UTF8String;
    
    int length = ALXLengthFromHashAlgorithm(algorithm);
    BOOL uppercase = ALXUppercaseFromHashAlgorithm(algorithm);
    unsigned char result[length];
    
    CCHmac(ALXHmacAlgorithmFromHashAlgorithm(algorithm), keyData, strlen(keyData), input, strlen(input), result);

    return [NSString alx_internal_hashStringWithBytes:result length:length uppercase:uppercase];
}

+ (NSString *)alx_internal_hashStringWithBytes:(uint8_t *)result length:(int)length uppercase:(BOOL)uppercase {
    NSMutableString *digest = [NSMutableString string];
    for (int i = 0; i < length; i++) {
        if (uppercase) {
            [digest appendFormat:@"%02X", result[i]];
        } else {
            [digest appendFormat:@"%02x", result[i]];
        }
    }
    return [digest copy];
}

#pragma mark - *** Symmetric Encryption(public key = private key) ***
/** ECB Encrypt */
- (NSData *)alx_ECBEncryptWithAlgorithm:(CCAlgorithm)algorithm key:(NSString *)key padding:(ALXPKCSPadding)padding {
    CCOperation operation = kCCEncrypt;
    CCOptions option = ALXOptionsFromModeAndPadding(kCCModeECB, padding);
    return [self alx_internal_encryptOrDecryptWithOperation:operation algorithm:algorithm option:option key:key iv:nil];
}
/** ECB Decrypt */
- (NSString *)alx_ECBDecryptWithAlgorithm:(CCAlgorithm)algorithm key:(NSString *)key padding:(ALXPKCSPadding)padding {
    CCOperation operation = kCCDecrypt;
    CCOptions option = ALXOptionsFromModeAndPadding(kCCModeECB, padding);
    return [self alx_internal_encryptOrDecryptWithOperation:operation algorithm:algorithm option:option key:key iv:nil];
}

/** CBC Encrypt */
- (NSData *)alx_CBCEncryptWithAlgorithm:(CCAlgorithm)algorithm key:(NSString *)key padding:(ALXPKCSPadding)padding iv:(NSString *)iv {
    CCOperation operation = kCCEncrypt;
    CCOptions option = ALXOptionsFromModeAndPadding(kCCModeCBC, padding);
    return [self alx_internal_encryptOrDecryptWithOperation:operation algorithm:algorithm option:option key:key iv:iv];
}
/** CBC Decrypt */
- (NSString *)alx_CBCDecryptWithAlgorithm:(CCAlgorithm)algorithm key:(NSString *)key padding:(ALXPKCSPadding)padding iv:(NSString *)iv {
    CCOperation operation = kCCDecrypt;
    CCOptions option = ALXOptionsFromModeAndPadding(kCCModeCBC, padding);
    return [self alx_internal_encryptOrDecryptWithOperation:operation algorithm:algorithm option:option key:key iv:iv];
}

- (id)alx_internal_encryptOrDecryptWithOperation:(CCOperation)operation
                                       algorithm:(CCAlgorithm)algorithm
                                          option:(CCOptions)option
                                             key:(NSString *)key
                                              iv:(NSString *)iv{
    
    // TODO:Alexgao---key长度容错
    char keyPtr[kCCKeySizeAES256+1];
    memset(keyPtr, 0, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    // TODO:Alexgao---完善iv为空的逻辑
    if (!iv.length) {
        iv = @"";
    }
    
    char ivPtr[kCCBlockSizeAES128 + 1];
    memset(ivPtr, 0, sizeof(ivPtr));
    [iv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
    
    NSData* data = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    size_t bufferSize = [data length] + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(operation,
                                          algorithm,
                                          option,
                                          keyPtr,
                                          [key length],
                                          ivPtr,
                                          [data bytes],
                                          [data length],
                                          buffer,
                                          bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        // !!!:Alexgao---resultData会自动释放buffer
        NSData *resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
        if (operation == kCCEncrypt) {
            return resultData;
        }else if (operation == kCCDecrypt) {
            return [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
        }
    }
    free(buffer);
    return nil;
}

@end
