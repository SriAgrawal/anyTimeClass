//
//  ReferFriendVC.m
//  AnyTimeClass
//
//  Created by Aman Goswami on 17/01/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//
#import "ReferFriendVC.h"
#import "Header.h"

@interface ReferFriendVC ()<CAAnimationDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UILabel *referCodeLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *shareonConstraint;

@end

@implementation ReferFriendVC
#pragma mark - View Life Cycle.
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableHeaderView = self.headerView;
    ///// Window management
    if (WIN_HEIGHT < 400) {
        self.tableView.scrollEnabled = YES;
    }else if (WIN_HEIGHT ==568) {
        self.topConstraint.constant = 30.0f;
        self.shareonConstraint.constant = 30.0f;
        self.tableView.scrollEnabled = NO;
    }else {
        self.topConstraint.constant = 50.0f;
        self.shareonConstraint.constant = 50.0f;
        self.tableView.scrollEnabled = NO;
    }
    [self callApiForReferAFriend];
}

#pragma mark - Animation.
-(void) AnimationFromBottomToTop {
    CATransition *animation = [CATransition animation];
    [animation setDelegate:self];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromTop];
    [animation setDuration:0.65f];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [[self.navigationController.view layer] addAnimation:animation forKey:@"AnimationFromBottomToTop"];
}

#pragma mark - Memory MAnagement.
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Button Action.
- (IBAction)menuBtnAction:(id)sender {
    /////// Home navigation
    [self AnimationFromBottomToTop];
    NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
    for (UIViewController *aViewController in allViewControllers) {
        if ([aViewController isKindOfClass:[SidePannelVC class]]) {
            [self.navigationController popToViewController:aViewController animated:NO];
        }
    }
}

- (IBAction)shareBtnAction:(id)sender {
    NSString *textToShare = @"Look at this awesome website for aspiring iOS Developers!";
    NSURL *myWebsite = [NSURL URLWithString:@"http://www.codingexplorer.com/"];
    
    NSArray *objectsToShare = @[textToShare, myWebsite];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    [self presentViewController:activityVC animated:YES completion:nil];
    
}

#pragma mark - Webservice.

- (void) callApiForReferAFriend {
    
    NSMutableDictionary *user_dict = [NSMutableDictionary dictionary];
    [user_dict setValue:[NSUSERDEFAULTS valueForKey:kuid] forKey:kuid];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:user_dict AndPath:krefer_a_friend WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        if (suceeded) {
            NSString *responseCode = [response objectForKeyNotNull:kresponseCode expectedClass:[NSString class]];
            NSString *responseMessage = [response objectForKeyNotNull:kresponseMessage expectedClass:[NSString class]];
            
            if (responseCode.integerValue == KSuccessCode) {
                NSDictionary *dict =  [response objectForKeyNotNull:@"profileDetail" expectedClass:[NSDictionary class]] ;
                self.referCodeLabel.text  = [dict objectForKeyNotNull:@"referral_code" expectedClass:[NSString class]];
                
            } else if (responseCode.integerValue == KLogoutCode) {
                [[AlertView sharedManager] displayInformativeAlertwithTitle:@"Error!" andMessage:responseMessage onController:self];
                [APP_DELEGATE logout];
                [[APP_DELEGATE navController] popToRootViewControllerAnimated:YES];
                
            } else{
                [[AlertView sharedManager] displayInformativeAlertwithTitle:@"Error!" andMessage:responseMessage onController:self];
            }
        }else{
            NSError *error = [response objectForKeyNotNull:@"Error" expectedClass:[NSError class]];
            
            if (error != nil) {
                
                [[AlertView sharedManager] displayInformativeAlertwithTitle:@"Error!" andMessage:error.localizedDescription onController:self];
            }else{
                [[AlertView sharedManager] displayInformativeAlertwithTitle:@"Error!" andMessage:KError_Message onController:self];
            }
        }
    }];
}


@end
