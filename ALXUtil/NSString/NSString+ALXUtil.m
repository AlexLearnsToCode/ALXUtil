//
//  NSString+ALXUtil.m
//  ALXUtil
//
//  Created by Alexgao on 2018/12/28.
//

#import "NSString+ALXUtil.h"
#import <Security/Security.h>

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
- (NSString *)alx_ECBEncryptWithAlgorithm:(CCAlgorithm)algorithm key:(NSString *)key padding:(ALXPKCSPadding)padding {
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
- (NSString *)alx_CBCEncryptWithAlgorithm:(CCAlgorithm)algorithm key:(NSString *)key padding:(ALXPKCSPadding)padding iv:(NSString *)iv {
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
        // Alexgao---resultData会自动释放buffer
        NSData *resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
        if (operation == kCCEncrypt) {
            return [[NSString alloc] initWithData:[resultData base64EncodedDataWithOptions:NSDataBase64Encoding64CharacterLineLength] encoding:NSUTF8StringEncoding];
        }else if (operation == kCCDecrypt) {
            return [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
        }
    }
    free(buffer);
    return nil;
}

#pragma mark - *** Asymmetric Encryption(public key, private key) ***
#pragma mark - *** *** RSA *** ***
- (NSString *)alx_RSAEntryptWithPublicKey:(NSString *)publicKey {
    [self alx_encryptWithSecKey:[self alx_publicSecKeyFromPublicKey:publicKey]];
}
- (NSString *)alx_RSAEntryptWithContentsOfPublicKey:(NSString *)publicKeyFilePath {
    [self alx_encryptWithSecKey:[self alx_publicSecKeyFromContentsOfPublicKey:publicKeyFilePath]];
}

- (NSString *)alx_encryptWithSecKey:(SecKeyRef)seckey{
    if(![self dataUsingEncoding:NSUTF8StringEncoding]){
        return nil;
    }
    if(!seckey){
        return nil;
    }
    NSData *data = [self alx_encryptData:[self dataUsingEncoding:NSUTF8StringEncoding] withKeyRef:seckey];
    NSString *ret = [[NSString alloc] initWithData:[data base64EncodedDataWithOptions:0] encoding:NSUTF8StringEncoding];
    return ret;
}

- (NSData *)alx_encryptData:(NSData *)data withKeyRef:(SecKeyRef) keyRef{
    const uint8_t *srcbuf = (const uint8_t *)[data bytes];
    size_t srclen = (size_t)data.length;
    
    size_t block_size = SecKeyGetBlockSize(keyRef) * sizeof(uint8_t);
    void *outbuf = malloc(block_size);
    size_t src_block_size = block_size - 11;
    
    NSMutableData *ret = [[NSMutableData alloc] init];
    for(int idx=0; idx<srclen; idx+=src_block_size){
        //NSLog(@"%d/%d block_size: %d", idx, (int)srclen, (int)block_size);
        size_t data_len = srclen - idx;
        if(data_len > src_block_size){
            data_len = src_block_size;
        }
        
        size_t outlen = block_size;
        OSStatus status = noErr;
        status = SecKeyEncrypt(keyRef,
                               kSecPaddingPKCS1,
                               srcbuf + idx,
                               data_len,
                               outbuf,
                               &outlen
                               );
        if (status != 0) {
            NSLog(@"SecKeyEncrypt fail. Error Code: %d", status);
            ret = nil;
            break;
        }else{
            [ret appendBytes:outbuf length:outlen];
        }
    }
    
    free(outbuf);
    CFRelease(keyRef);
    return ret;
}

- (SecKeyRef)alx_publicSecKeyFromPublicKey:(NSString *)publicKey{
    NSRange spos = [publicKey rangeOfString:@"-----BEGIN PUBLIC KEY-----"];
    NSRange epos = [publicKey rangeOfString:@"-----END PUBLIC KEY-----"];
    if(spos.location != NSNotFound && epos.location != NSNotFound){
        NSUInteger s = spos.location + spos.length;
        NSUInteger e = epos.location;
        NSRange range = NSMakeRange(s, e-s);
        publicKey = [publicKey substringWithRange:range];
    }
    publicKey = [publicKey stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    publicKey = [publicKey stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    publicKey = [publicKey stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    publicKey = [publicKey stringByReplacingOccurrencesOfString:@" "  withString:@""];
    
    // This will be base64 encoded, decode it.
    NSData *data = [[NSData alloc] initWithBase64EncodedString:publicKey options:NSDataBase64DecodingIgnoreUnknownCharacters];
    data = [self alx_stripPublicKeyHeader:data];
    if(!data){
        return nil;
    }
    
    //a tag to read/write keychain storage
    NSString *tag = @"RSAUtil_PubKey";
    NSData *d_tag = [NSData dataWithBytes:[tag UTF8String] length:[tag length]];
    
    // Delete any old lingering key with the same tag
    NSMutableDictionary *publicKeyDic = [[NSMutableDictionary alloc] init];
    [publicKeyDic setObject:(__bridge id) kSecClassKey forKey:(__bridge id)kSecClass];
    [publicKeyDic setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    [publicKeyDic setObject:d_tag forKey:(__bridge id)kSecAttrApplicationTag];
    SecItemDelete((__bridge CFDictionaryRef)publicKeyDic);
    
    // Add persistent version of the key to system keychain
    [publicKeyDic setObject:data forKey:(__bridge id)kSecValueData];
    [publicKeyDic setObject:(__bridge id) kSecAttrKeyClassPublic forKey:(__bridge id)
     kSecAttrKeyClass];
    [publicKeyDic setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)
     kSecReturnPersistentRef];
    
    CFTypeRef persistKey = nil;
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)publicKeyDic, &persistKey);
    if (persistKey != nil){
        CFRelease(persistKey);
    }
    if ((status != noErr) && (status != errSecDuplicateItem)) {
        return nil;
    }
    
    [publicKeyDic removeObjectForKey:(__bridge id)kSecValueData];
    [publicKeyDic removeObjectForKey:(__bridge id)kSecReturnPersistentRef];
    [publicKeyDic setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnRef];
    [publicKeyDic setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    
    // Now fetch the SecKeyRef version of the key
    SecKeyRef keyRef = nil;
    status = SecItemCopyMatching((__bridge CFDictionaryRef)publicKeyDic, (CFTypeRef *)&keyRef);
    if(status != noErr){
        return nil;
    }
    return keyRef;
}

- (NSData *)alx_stripPublicKeyHeader:(NSData *)d_key{
    // Skip ASN.1 public key header
    if (d_key == nil) return(nil);
    
    unsigned long len = [d_key length];
    if (!len) return(nil);
    
    unsigned char *c_key = (unsigned char *)[d_key bytes];
    unsigned int  idx     = 0;
    
    if (c_key[idx++] != 0x30) return(nil);
    
    if (c_key[idx] > 0x80) idx += c_key[idx] - 0x80 + 1;
    else idx++;
    
    // PKCS #1 rsaEncryption szOID_RSA_RSA
    static unsigned char seqiod[] =
    { 0x30,   0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86, 0xf7, 0x0d, 0x01, 0x01,
        0x01, 0x05, 0x00 };
    if (memcmp(&c_key[idx], seqiod, 15)) return(nil);
    
    idx += 15;
    
    if (c_key[idx++] != 0x03) return(nil);
    
    if (c_key[idx] > 0x80) idx += c_key[idx] - 0x80 + 1;
    else idx++;
    
    if (c_key[idx++] != '\0') return(nil);
    
    // Now make a new NSData from this buffer
    return ([NSData dataWithBytes:&c_key[idx] length:len - idx]);
}
- (SecKeyRef)alx_publicSecKeyFromContentsOfPublicKey:(NSString *)publicKeyFilePath{
    NSData *certData = [NSData dataWithContentsOfFile:publicKeyFilePath];
    if (!certData) {
        return nil;
    }
    SecCertificateRef cert = SecCertificateCreateWithData(NULL, (CFDataRef)certData);
    SecKeyRef key = NULL;
    SecTrustRef trust = NULL;
    SecPolicyRef policy = NULL;
    if (cert != NULL) {
        policy = SecPolicyCreateBasicX509();
        if (policy) {
            if (SecTrustCreateWithCertificates((CFTypeRef)cert, policy, &trust) == noErr) {
                SecTrustResultType result;
                if (SecTrustEvaluate(trust, &result) == noErr) {
                    key = SecTrustCopyPublicKey(trust);
                }
            }
        }
    }
    if (policy) CFRelease(policy);
    if (trust) CFRelease(trust);
    if (cert) CFRelease(cert);
    return key;
}




- (NSString *)alx_RSADecryptWithPrivateKey:(NSString *)privateKey {
    return [self alx_decryptString:self privateKeyRef:[self alx_privateSecKeyFromPrivateKey:privateKey]];
}
- (NSString *)alx_RSADecryptWithContentsOfPrivateKey:(NSString *)privateKeyFilePath password:(nonnull NSString *)password {
    return [self alx_decryptString:self privateKeyRef:[self alx_privateSecKeyFromContentsOfPrivateKey:privateKeyFilePath password:password]];
}

- (NSString *)alx_decryptString:(NSString *)str privateKeyRef:(SecKeyRef)privKeyRef{
    NSData *data = [[NSData alloc] initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
    if (!privKeyRef) {
        return nil;
    }
    data = [self alx_decryptData:data withKeyRef:privKeyRef];
    NSString *ret = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return ret;
}
- (NSData *)alx_decryptData:(NSData *)data withKeyRef:(SecKeyRef) keyRef{
    const uint8_t *srcbuf = (const uint8_t *)[data bytes];
    size_t srclen = (size_t)data.length;
    
    size_t block_size = SecKeyGetBlockSize(keyRef) * sizeof(uint8_t);
    UInt8 *outbuf = malloc(block_size);
    size_t src_block_size = block_size;
    
    NSMutableData *ret = [[NSMutableData alloc] init];
    for(int idx=0; idx<srclen; idx+=src_block_size){
        //NSLog(@"%d/%d block_size: %d", idx, (int)srclen, (int)block_size);
        size_t data_len = srclen - idx;
        if(data_len > src_block_size){
            data_len = src_block_size;
        }
        
        size_t outlen = block_size;
        OSStatus status = noErr;
        status = SecKeyDecrypt(keyRef,
                               kSecPaddingNone,
                               srcbuf + idx,
                               data_len,
                               outbuf,
                               &outlen
                               );
        if (status != 0) {
            NSLog(@"SecKeyEncrypt fail. Error Code: %d", status);
            ret = nil;
            break;
        }else{
            //the actual decrypted data is in the middle, locate it!
            int idxFirstZero = -1;
            int idxNextZero = (int)outlen;
            for ( int i = 0; i < outlen; i++ ) {
                if ( outbuf[i] == 0 ) {
                    if ( idxFirstZero < 0 ) {
                        idxFirstZero = i;
                    } else {
                        idxNextZero = i;
                        break;
                    }
                }
            }
            
            [ret appendBytes:&outbuf[idxFirstZero+1] length:idxNextZero-idxFirstZero-1];
        }
    }
    
    free(outbuf);
    CFRelease(keyRef);
    return ret;
}


- (SecKeyRef)alx_privateSecKeyFromPrivateKey:(NSString *)privateKey{
    NSRange spos = [privateKey rangeOfString:@"-----BEGIN RSA PRIVATE KEY-----"];
    NSRange epos = [privateKey rangeOfString:@"-----END RSA PRIVATE KEY-----"];
    if(spos.location != NSNotFound && epos.location != NSNotFound){
        NSUInteger s = spos.location + spos.length;
        NSUInteger e = epos.location;
        NSRange range = NSMakeRange(s, e-s);
        privateKey = [privateKey substringWithRange:range];
    }
    privateKey = [privateKey stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    privateKey = [privateKey stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    privateKey = [privateKey stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    privateKey = [privateKey stringByReplacingOccurrencesOfString:@" "  withString:@""];
    
    // This will be base64 encoded, decode it.
    NSData *data = [[NSData alloc] initWithBase64EncodedString:privateKey options:NSDataBase64DecodingIgnoreUnknownCharacters];
    data = [self alx_stripPrivateKeyHeader:data];
    if(!data){
        return nil;
    }
    
    //a tag to read/write keychain storage
    NSString *tag = @"RSAUtil_PrivKey";
    NSData *d_tag = [NSData dataWithBytes:[tag UTF8String] length:[tag length]];
    
    // Delete any old lingering key with the same tag
    NSMutableDictionary *privateKeyDic = [[NSMutableDictionary alloc] init];
    [privateKeyDic setObject:(__bridge id) kSecClassKey forKey:(__bridge id)kSecClass];
    [privateKeyDic setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    [privateKeyDic setObject:d_tag forKey:(__bridge id)kSecAttrApplicationTag];
    SecItemDelete((__bridge CFDictionaryRef)privateKeyDic);
    
    // Add persistent version of the key to system keychain
    [privateKeyDic setObject:data forKey:(__bridge id)kSecValueData];
    [privateKeyDic setObject:(__bridge id) kSecAttrKeyClassPrivate forKey:(__bridge id)
     kSecAttrKeyClass];
    [privateKeyDic setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)
     kSecReturnPersistentRef];
    
    CFTypeRef persistKey = nil;
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)privateKeyDic, &persistKey);
    if (persistKey != nil){
        CFRelease(persistKey);
    }
    if ((status != noErr) && (status != errSecDuplicateItem)) {
        return nil;
    }
    
    [privateKeyDic removeObjectForKey:(__bridge id)kSecValueData];
    [privateKeyDic removeObjectForKey:(__bridge id)kSecReturnPersistentRef];
    [privateKeyDic setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnRef];
    [privateKeyDic setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    
    // Now fetch the SecKeyRef version of the key
    SecKeyRef keyRef = nil;
    status = SecItemCopyMatching((__bridge CFDictionaryRef)privateKeyDic, (CFTypeRef *)&keyRef);
    if(status != noErr){
        return nil;
    }
    return keyRef;
}

- (NSData *)alx_stripPrivateKeyHeader:(NSData *)d_key{
    // Skip ASN.1 private key header
    if (d_key == nil) return(nil);
    
    unsigned long len = [d_key length];
    if (!len) return(nil);
    
    unsigned char *c_key = (unsigned char *)[d_key bytes];
    unsigned int  idx     = 22; //magic byte at offset 22
    
    if (0x04 != c_key[idx++]) return nil;
    
    //calculate length of the key
    unsigned int c_len = c_key[idx++];
    int det = c_len & 0x80;
    if (!det) {
        c_len = c_len & 0x7f;
    } else {
        int byteCount = c_len & 0x7f;
        if (byteCount + idx > len) {
            //rsa length field longer than buffer
            return nil;
        }
        unsigned int accum = 0;
        unsigned char *ptr = &c_key[idx];
        idx += byteCount;
        while (byteCount) {
            accum = (accum << 8) + *ptr;
            ptr++;
            byteCount--;
        }
        c_len = accum;
    }
    
    // Now make a new NSData from this buffer
    return [d_key subdataWithRange:NSMakeRange(idx, c_len)];
}

- (SecKeyRef)alx_privateSecKeyFromContentsOfPrivateKey:(NSString *)privateKeyFilePath password:(NSString *)password{
    NSData *p12Data = [NSData dataWithContentsOfFile:privateKeyFilePath];
    if (!p12Data) {
        return nil;
    }
    SecKeyRef privateKeyRef = NULL;
    NSMutableDictionary * options = [[NSMutableDictionary alloc] init];
    [options setObject:password forKey:(__bridge id)kSecImportExportPassphrase];
    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
    OSStatus securityError = SecPKCS12Import((__bridge CFDataRef) p12Data, (__bridge CFDictionaryRef)options, &items);
    if (securityError == noErr && CFArrayGetCount(items) > 0) {
        CFDictionaryRef identityDict = CFArrayGetValueAtIndex(items, 0);
        SecIdentityRef identityApp = (SecIdentityRef)CFDictionaryGetValue(identityDict, kSecImportItemIdentity);
        securityError = SecIdentityCopyPrivateKey(identityApp, &privateKeyRef);
        if (securityError != noErr) {
            privateKeyRef = NULL;
        }
    }
    CFRelease(items);
    
    return privateKeyRef;
}

@end
