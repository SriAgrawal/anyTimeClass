//
//  AppDelegate.h
//  AnyTimeClass
//
//  Created by Aman Goswami on 14/01/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Google/SignIn.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, GIDSignInDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong , nonatomic) UINavigationController *navController;
@property(assign,nonatomic) BOOL shouldAddTimer;
@property(assign,nonatomic) int pageIndex;
@property (nonatomic, assign) BOOL   isReachable;
@property (nonatomic, assign) BOOL   fromLogin;
@property (nonatomic, assign) GIDGoogleUser *googleUser;
-(void)logout;
@end

