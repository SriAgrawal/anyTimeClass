//
//  SocialMediaSignUp.m
//  AnyTimeClass
//
//  Created by Aman Goswami on 14/01/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

#import "SocialMediaSignUp.h"
#import "Header.h"
#import <Google/SignIn.h>

@interface SocialMediaSignUp ()<GIDSignInUIDelegate>
@property (strong, nonatomic) IBOutlet UIButton *fbBtnOutlet;
@property (strong, nonatomic) IBOutlet UIButton *googleBtnOutlet;
@property (strong, nonatomic) IBOutlet UIButton *signUpBtnOutlet;

@end

@implementation SocialMediaSignUp

#pragma mark - View Life Cycle.
- (void)viewDidLoad {
    [super viewDidLoad];
    ///// Setting Exclusive touch.
    [_fbBtnOutlet setExclusiveTouch:YES];
    [_googleBtnOutlet setExclusiveTouch:YES];
    [_signUpBtnOutlet setExclusiveTouch:YES];
    ////// Setting font.
    [self.signUpBtnOutlet .titleLabel setFont:[UIFont fontWithName:@"advent-pro.regular" size:15.0f]];
    /////// Google signIn Delegate
    [GIDSignIn sharedInstance].uiDelegate = self;
    /////// Local Notification for google.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getGoogle) name:@"getGoogle" object:nil];
    
}
////// Dealloc the notification
-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Button Action.

- (IBAction)backBtnAction:(id)sender {
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)fbBtnAction:(id)sender {
    [self.view endEditing:YES];
    /////// Facebook Login
    [[FacebookLogin sharedManager] getFacebookInfoWithCompletionHandler:self completionBlock:^(NSDictionary *infoDict, NSError *error) {
        
        if (!error) {
            userInfo *user = [[userInfo alloc] init];
            
            NSDictionary *pictureDict = [infoDict objectForKeyNotNull:@"picture" expectedClass:[NSDictionary class]];
            NSDictionary *dataDict = [pictureDict objectForKeyNotNull:@"data" expectedClass:[NSDictionary class]];
            user.userImage = [dataDict objectForKeyNotNull:@"url" expectedClass:[NSString class]];
            
            user.fullName = [infoDict valueForKey:@"name"];
            user.email = [infoDict valueForKey:@"email"];
            user.facebookId = [infoDict valueForKey:@"id"];
            user.dob = [infoDict valueForKey:@"birthday"];
            user.firstName = [infoDict valueForKey:@"first_name"];
            user.lastName = [infoDict valueForKey:@"last_name"];
            user.gender = [infoDict valueForKey:@"gender"];
            user.socialType = @"facebook";
            
            NSLog(@"infoDict====%@",user);
            [[userInfo appShareinstance] setFromFacebook:@"yes"];
            SignUpVC *myVC = [[SignUpVC alloc] initWithNibName:@"SignUpVC" bundle:nil];
            myVC.objData = user;
            myVC.fromFacebook = @"1";
            [self.navigationController pushViewController:myVC animated:YES];
        }
        else{
            
        }
    }];
}

- (IBAction)googleBtnAction:(id)sender {
    [self.view endEditing:YES];
    /////// Google Login
    [APP_DELEGATE setFromLogin:NO];
    [[GIDSignIn sharedInstance] signIn];
}

-(void)getGoogle {
    userInfo *user = [[userInfo alloc] init];
    if ([APP_DELEGATE googleUser].userID != nil) {
        user.googleUserID = [APP_DELEGATE googleUser].userID;                  // For client-side use only!
        user.facebookId = [APP_DELEGATE googleUser].authentication.idToken; // Safe to send to the servp[-er
        user.fullName = [APP_DELEGATE googleUser].profile.name;
        user.firstName = [APP_DELEGATE googleUser].profile.givenName;
        user.lastName = [APP_DELEGATE googleUser].profile.familyName;
        user.email = [APP_DELEGATE googleUser].profile.email;
        user.socialType = @"google";
        NSLog(@"infoDict====%@",user);
        [[userInfo appShareinstance] setFromFacebook:@"yes"];
        SignUpVC *myVC = [[SignUpVC alloc] initWithNibName:@"SignUpVC" bundle:nil];
        myVC.objData = user;
        myVC.fromFacebook = @"2";
        [self.navigationController pushViewController:myVC animated:YES];
    }
    
}

- (IBAction)signUpBtnAction:(id)sender {
    [self.view endEditing:YES];
    SignUpVC *myVC = [[SignUpVC alloc] initWithNibName:@"SignUpVC" bundle:nil];
    [self.navigationController pushViewController:myVC animated:YES];
}



// Stop the UIActivityIndicatorView animation that was started when the user
// pressed the Sign In button
- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error {
    //  [myActivityIndicator stopAnimating];
}

// Present a view that prompts the user to sign in with Google
- (void)signIn:(GIDSignIn *)signIn presentViewController:(UIViewController *)viewController {
    [self presentViewController:viewController animated:YES completion:nil];
}

// Dismiss the "Sign in with Google" view
- (void)signIn:(GIDSignIn *)signIn dismissViewController:(UIViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Memory Management.
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
