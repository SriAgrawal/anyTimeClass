//
//  userInfo.m
//  AnyTimeClass
//
//  Created by Aman Goswami on 14/01/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

#import "userInfo.h"
#import "Header.h"

@implementation userInfo

+(userInfo *)appShareinstance {
    
    static userInfo *_appShareInstance = nil;
    static dispatch_once_t oncePerdicate;
    
    dispatch_once(&oncePerdicate , ^{
        _appShareInstance = [[userInfo alloc]init];
    });
    
    return _appShareInstance;
}


+(userInfo *)parseUserInfo:(NSDictionary *)user {
    userInfo *obj = [[userInfo alloc] init];
    obj.uid =  [user objectForKeyNotNull:kuid expectedClass:[NSString class]];
    obj.fullName = [user objectForKeyNotNull:kname expectedClass:[NSString class]];
    obj.email = [user objectForKeyNotNull:kemailID expectedClass:[NSString class]];
    obj.userImage = [user objectForKeyNotNull:kimage expectedClass:[NSString class]];
    obj.phoneNumber = [user objectForKeyNotNull:kmobile expectedClass:[NSString class]];
    obj.pushsetting = [user objectForKeyNotNull:kpushsetting expectedClass:[NSString class]];
    obj.address = [user objectForKeyNotNull:kaddress expectedClass:[NSString class]];
    obj.dob =  [user objectForKeyNotNull:kdob expectedClass:[NSString class]];
    obj.gender = [user objectForKeyNotNull:kgender expectedClass:[NSString class]];
    return obj;
}

+(userInfo *)parseNotification:(NSDictionary *)user {
    userInfo *obj = [[userInfo alloc] init];
    obj.noti_id =  [user objectForKeyNotNull:@"noti_id" expectedClass:[NSString class]];
    obj.title = [user objectForKeyNotNull:@"title" expectedClass:[NSString class]];
    obj.name = [user objectForKeyNotNull:@"name" expectedClass:[NSString class]];
    obj.image = [user objectForKeyNotNull:@"image" expectedClass:[NSString class]];
    obj.created = [user objectForKeyNotNull:@"created" expectedClass:[NSString class]];
    return obj;
}

@end
