//
//  userInfo.h
//  AnyTimeClass
//
//  Created by Aman Goswami on 14/01/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface userInfo : NSObject
+(userInfo *)appShareinstance;

@property(nonatomic,strong)NSString *email;
@property(nonatomic,strong)NSString *password;
@property(nonatomic,strong)NSString *confirmPassword;
@property(nonatomic,strong)NSString *dob;
@property(nonatomic,strong)NSString *address;
@property(nonatomic,strong)NSString *referralCode;
@property(nonatomic,strong)NSString *fullName;
@property(nonatomic,strong)NSString *nwPassword;
@property(nonatomic,strong)NSString *userImage;
@property(nonatomic,strong)NSString *phoneNumber;
@property(nonatomic,strong)NSString *userId;
@property(strong,nonatomic)NSString *firstName;
@property(strong,nonatomic)NSString *lastName;
@property(strong,nonatomic)NSString *gender;
@property(strong,nonatomic)NSString *pushsetting;
@property(nonatomic,strong)NSString *authToken;
@property(nonatomic,strong)NSString *facebookId;
@property(nonatomic,strong)NSString *googleUserID;
@property(nonatomic,strong)NSString *useracess_token;
@property(nonatomic,strong)NSString *uid;
@property(nonatomic,strong)NSString *socialType;
@property(nonatomic,assign)BOOL sixMonth;
@property(nonatomic,strong)NSString *course_duration;
@property(nonatomic,strong)NSString *fromFacebook;
@property(nonatomic,assign)BOOL nineMonth;
@property(nonatomic,strong)NSString *noti_id;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *image;
@property(nonatomic,strong)NSString *maxpage;
@property(nonatomic,strong)NSString *totalRecord;
@property(nonatomic,strong)NSString *pageNumber;
@property(nonatomic,strong)NSString *created;


+(userInfo *)parseUserInfo:(NSDictionary *)userInfo;
+(userInfo *)parseNotification:(NSDictionary *)user ;
@end
