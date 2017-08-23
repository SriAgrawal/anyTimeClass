//
//  ServiceHelper_AF3.h
//  PriceFixer
//
//  Created by Mirza Zuhaib Beg on 5/31/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "Header.h"


@class PFAppUserInfo;

#define SERVICE_BASE_URL @"http://ec2-52-1-133-240.compute-1.amazonaws.com/PROJECTS/AnytimeClasses/trunk/api/"

//#if DEBUG

//#define SERVICE_LOCAL_URL  @"http://172.16.5.30:3000"
//#define SERVICE_LOCAL_URL  @"http://172.16.0.9/PROJECTS/AnytimeClasses/trunk/api/"

//#else
//#define SERVICE_BASE_URL @""
//#endif


typedef void (^ServiceCompletionBlock)(BOOL suceeded, NSString *error,id response);

@interface ServiceHelper_AF3 : NSObject

@property (strong,nonatomic) ServiceCompletionBlock completionBlock;

@property (strong,nonatomic) AFHTTPSessionManager *manager;

+(id)instance;

-(void)makeWebApiCallWithParameters:(id)dict AndPath:(NSString*)strApi WithCompletion:(ServiceCompletionBlock)completionBlock;
-(void)makeGetWebApiCallWithParameters:(id)dict AndPath:(NSString*)strApi WithCompletion:(ServiceCompletionBlock)completionBlock;


@end
