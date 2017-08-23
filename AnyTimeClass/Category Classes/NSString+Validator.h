//
//  NSString+Validator.h
//  Apple-O-Pol
//
//  Created by KrishnaKant kaira on 04/06/14.
//  Copyright (c) 2014 Mobiloitte. All rights reserved.
//


#import "Header.h"

@interface NSString (Validator)

- (CGFloat)getEstimatedHeightWithFont:(UIFont*)font withWidth:(CGFloat)width withExtraHeight:(CGFloat)ht;

- (BOOL)isBlank;
- (BOOL)isValid;
- (NSString *)removeWhiteSpacesFromString;


- (NSUInteger)countNumberOfWords;
- (BOOL)containsString:(NSString *)subString;
- (BOOL)isBeginsWith:(NSString *)string;
- (BOOL)isEndssWith:(NSString *)string;

- (NSString *)replaceCharcter:(NSString *)olderChar withCharcter:(NSString *)newerChar;
- (NSString*)getSubstringFrom:(NSInteger)begin to:(NSInteger)end;
- (NSString *)addString:(NSString *)string;
- (NSString *)removeSubString:(NSString *)subString;

- (BOOL) isValidPassword;
- (BOOL)containsOnlyLetters;
- (BOOL)containsOnlyNumbers;
- (BOOL)containsOnlyNumbersAndLetters;
- (BOOL)isInThisarray:(NSArray*)array;
+(BOOL)validatePassword:(NSString *)password;

+ (NSString *)getStringFromArray:(NSArray *)array;
- (NSArray *)getArray;

+ (NSString *)getMyApplicationVersion;
+ (NSString *)getMyApplicationName;

- (NSData *)convertToData;
+ (NSString *)getStringFromData:(NSData *)data;

- (BOOL)isValidEmail;
- (BOOL)isValidName;
- (BOOL)isVAlidPhoneNumber;
- (BOOL)isValidUrl;
- (BOOL)isValidRadius;

- (NSString *)trimWhitespace;

+ (NSString*)ordinalNumberFormat:(NSNumber *)numObj;

+ (NSDate *)getDateFromString:(NSString *)dateStr;

+ (NSDate *)getShortDateFromString:(NSString *)dateStr;

+ (NSString *)getStringFromDate:(NSDate *)date;

+ (NSString *)getStringFromDateWithFormat:(NSDate *)date :(NSString *)format ;

NSString * imageToNSString (UIImage *image );
NSString * getBase64String (UIImage *image );
+(NSString*)generateOrderIDWithPrefix:(NSString *)prefix;
@end
