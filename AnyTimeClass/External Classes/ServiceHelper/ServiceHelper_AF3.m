//
//  ServiceHelper_AF3.m
//  PriceFixer
//
//  Created by Mirza Zuhaib Beg on 5/31/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "ServiceHelper_AF3.h"

@implementation ServiceHelper_AF3

static ServiceHelper_AF3 * serviceHelper = nil;

#pragma mark - Initialization Methods

+(id)instance {
    
    @synchronized(self) {
        
        if(!serviceHelper)
            serviceHelper = [[ServiceHelper_AF3 alloc] init];
            serviceHelper.manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:SERVICE_BASE_URL]];
            [serviceHelper.manager setRequestSerializer:[AFJSONRequestSerializer serializerWithWritingOptions:NSJSONWritingPrettyPrinted]];
            [serviceHelper.manager setResponseSerializer:[AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments]];
    }
    return serviceHelper;
}

-(void)makeWebApiCallWithParameters:(id)dict AndPath:(NSString*)strApi WithCompletion:(ServiceCompletionBlock)completionBlock{
    {
        NSLog(@"Request Parameter %@",(NSDictionary *)dict);
        NSLog(@"Request AndPath %@",strApi);
        
         [MBProgressHUD showHUDAddedTo:[APP_DELEGATE navController].view animated:YES];
        
        dispatch_queue_t globalConcurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(globalConcurrentQueue, ^{
            
            
          [self.manager.requestSerializer setValue:@"admin" forHTTPHeaderField:@"Authentication"];
            [self.manager POST:strApi parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"Request Parameter %@",(NSDictionary *)responseObject);

                    completionBlock(YES,nil,responseObject);
                     [MBProgressHUD hideAllHUDsForView:[APP_DELEGATE navController].view animated:YES];
                });
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                NSMutableDictionary *response = [NSMutableDictionary dictionary];
                [response setObject:error forKey:@"Error"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO,nil,response);
                     [MBProgressHUD hideAllHUDsForView:[APP_DELEGATE navController].view animated:YES];
                });
            }];
        });
    }
}

-(void)makeGetWebApiCallWithParameters:(id)dict AndPath:(NSString*)strApi WithCompletion:(ServiceCompletionBlock)completionBlock{
    // NSLog(@"Request Parameter %@",(NSDictionary *)dict);
    
    dispatch_queue_t globalConcurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalConcurrentQueue, ^{
        
        [self.manager GET:strApi parameters:dict progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                //  NSLog(@"Request Parameter %@",(NSDictionary *)responseObject);
                
                completionBlock(YES,nil,responseObject);
            });
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSMutableDictionary *response = [NSMutableDictionary dictionary];
            [response setObject:error forKey:@"Error"];
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(NO,nil,response);
            });
        }];
        
        
    });
}

@end
