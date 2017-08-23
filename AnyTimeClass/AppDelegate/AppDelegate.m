//
//  AppDelegate.m
//  AnyTimeClass
//
//  Created by Aman Goswami on 14/01/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//
#import <GoogleSignIn/GoogleSignIn.h>
#import <UserNotifications/UserNotifications.h>

#import "AppDelegate.h"
#import "Header.h"
#import "PayPalMobile.h"

@interface AppDelegate ()<CAAnimationDelegate,UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    SplashVideoVC  *login = [[SplashVideoVC alloc] initWithNibName:@"SplashVideoVC" bundle:nil];
    self.navController = [[UINavigationController alloc] initWithRootViewController:login];
    [self.navController setNavigationBarHidden:YES animated:YES];
    self.window.rootViewController = self.navController;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self.window makeKeyAndVisible];
    /////// Getting Device ID
    UIDevice *device = [UIDevice currentDevice];
    NSString  *currentDeviceId = [[device identifierForVendor]UUIDString];
    [[NSUserDefaults standardUserDefaults] setValue:currentDeviceId forKey:kdeviceKey];
  ////////////// Facebook
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    //////////////// reachability
    [self checkReachability];
    //////// Google SignIn
    NSError* configureError;
    [[GGLContext sharedInstance] configureWithError: &configureError];
    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
    [GIDSignIn sharedInstance].delegate = self;
    //////// Device token
     [[NSUserDefaults standardUserDefaults] setValue:@"sdgfdsfdhgdfgfsd" forKey:kdeviceToken];
    /////// User Notifications
    [self registerForRemoteNotification];
    
    // **************** Paypal Method *******************//
    [self paypalMethod];

    return YES;
}

#pragma mark - Facebook
- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBSDKAppEvents activateApp];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    if([[GIDSignIn sharedInstance] handleURL:url
                           sourceApplication:sourceApplication
                                  annotation:annotation]) {
         return [[GIDSignIn sharedInstance] handleURL:url
                                     sourceApplication:sourceApplication
                                            annotation:annotation];
    }
    else {
        return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                              openURL:url
                                                    sourceApplication:sourceApplication
                                                           annotation:annotation];
    }
}


#pragma mark - Reachability
-(void)checkReachability {
    Reachability * reach = [Reachability reachabilityForInternetConnection];
    self.isReachable = [reach isReachable];
    reach.reachableBlock = ^(Reachability * reachability) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.isReachable = YES;
        });
    };
    reach.unreachableBlock = ^(Reachability * reachability) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.isReachable = NO;
        });
    };
    [reach startNotifier];
}

#pragma mark - Logout
-(void)logout {
    [FBSDKAccessToken setCurrentAccessToken:nil];
    [NSUSERDEFAULTS setValue:@"" forKey:kuid];
//    NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
//    for (UIViewController *aViewController in allViewControllers) {
//        if ([aViewController isKindOfClass:[LoginVC class]]) {
//            [self.navigationController popToViewController:aViewController animated:YES];
//        }
//    }
}

#pragma paypal Method 

- (void)paypalMethod {
    
    [PayPalMobile initializeWithClientIdsForEnvironments:@{PayPalEnvironmentSandbox : @"ARrP_dPH0qPJu1WVDo-GLniX-kScOdFtDySDxKux0NfJkPiMqO2xGr7IZEXC4q4HAsNIH20sCP5c1y__"}];
    [PayPalMobile preconnectWithEnvironment:PayPalEnvironmentSandbox];
    
    //    [PayPalMobile initializeWithClientIdsForEnvironments:@{PayPalEnvironmentProduction : @"ARrP_dPH0qPJu1WVDo-GLniX-kScOdFtDySDxKux0NfJkPiMqO2xGr7IZEXC4q4HAsNIH20sCP5c1y__"}];
    //    [PayPalMobile preconnectWithEnvironment:PayPalEnvironmentProduction];
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    // Perform any operations on signed in user here.
    self.googleUser = user;
    if (self.fromLogin == YES) {
         [[NSNotificationCenter defaultCenter] postNotificationName:@"getGoogleData" object:nil];
    } else {
         [[NSNotificationCenter defaultCenter] postNotificationName:@"getGoogle" object:nil];
    }
   
}


- (void)signIn:(GIDSignIn *)signIn
didDisconnectWithUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
}

#pragma  mark - setupNotification
-(void)registerForRemoteNotification {
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0){
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
            if( !error ){
                [[UIApplication sharedApplication] registerForRemoteNotifications];
            }
        }];
    }else {
        if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
            
            UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |UIUserNotificationTypeBadge |UIUserNotificationTypeSound);
            [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:userNotificationTypes categories:nil]];
            [[UIApplication sharedApplication] registerForRemoteNotifications];
        }
    }
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(nonnull NSData *)deviceToken
{
    
    NSLog(@"Device Token is : %@", deviceToken);
    NSString *deviceTok = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    deviceTok = [deviceTok stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"Device Token is : %@", deviceTok);
    [[NSUserDefaults standardUserDefaults] setValue:deviceTok forKey:kdeviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    if (application.applicationState == UIApplicationStateActive)
    {
        [[TWMessageBarManager sharedInstance] hideAllAnimated:YES];
        
        [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"" description:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] type:TWMessageBarMessageTypeInfo duration:6.0];
    }
    
}

#pragma mark - UNUserNotificationCenterDelegate method
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    completionHandler(UNNotificationPresentationOptionAlert);
    
}

-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler{
    NSLog(@"Userinfo %@",response.notification.request.content.userInfo);
}

@end
