//
//  SidePannelVC.m
//  AnyTimeClass
//
//  Created by Aman Goswami on 16/01/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

#import "SidePannelVC.h"
#import "Header.h"

@interface SidePannelVC () <CAAnimationDelegate,LogoutPopUpVCDelegate>{
    NSMutableArray *imageArray,*textArray;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SidePannelVC
#pragma mark -  View life Cycle.
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetup];
}


#pragma mark - Helper Classes
-(void) initialSetup {
    ////// cell register
    [self.tableView registerNib:[UINib nibWithNibName:@"SidePannelTVCell" bundle:nil] forCellReuseIdentifier:@"SidePannelTVCell"];
    ///// array Initialsation
    imageArray = [[NSMutableArray alloc] initWithObjects:@"m1",@"m8",@"m2",@"m3",@"m4",@"m5",@"refresh" ,@"m7",@"m6", nil];
    textArray = [[NSMutableArray alloc] initWithObjects:@"Home",@"My Profile",@"Notifications",@"My Test Series",@"My Videos",@"Refer a Friend",@"Purchase History" ,@"Settings",@"Logout", nil];
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
-(void) AnimationFromTopToBottom {
    CATransition *animation = [CATransition animation];
    [animation setDelegate:self];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromBottom];
    [animation setDuration:0.65f];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [[self.navigationController.view layer] addAnimation:animation forKey:@"AnimationFromBottomToTop"];
}

#pragma mark - TableView Delegate and DataSource.

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return imageArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SidePannelTVCell *cell = (SidePannelTVCell *)[self.tableView dequeueReusableCellWithIdentifier: @"SidePannelTVCell" forIndexPath:indexPath];
    cell.cellImageView.image = [UIImage imageNamed:[imageArray objectAtIndex:indexPath.row ]];
    cell.cellLabel.text = [textArray objectAtIndex:indexPath.row];
    return cell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
    switch (indexPath.row) {
        case 0: {
            /////// Home navigation
            NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
            for (UIViewController *aViewController in allViewControllers) {
                if ([aViewController isKindOfClass:[HomeVC class]]) {
                    [self.navigationController popToViewController:aViewController animated:YES];
                }
            }
        }
            break;
        case 1: {
            //////// My Profile
            MyProfileVC *myVC = [[MyProfileVC alloc] initWithNibName:@"MyProfileVC" bundle:nil];
            [self.navigationController pushViewController:myVC animated:YES];
        }
            break;
        case 2: {
            ////////// Notifications navigation
            NotificationVC *myVC = [[NotificationVC alloc] initWithNibName:@"NotificationVC" bundle:nil];
            [self.navigationController pushViewController:myVC animated:YES];
        }
            break;
        case 3: {
            ////////// My Testseries navigation
            MyTestVC *myVC = [[MyTestVC alloc] initWithNibName:@"MyTestVC" bundle:nil];
            [self.navigationController pushViewController:myVC animated:YES];
        }
            break;
        case 4: {
            ///////// My Videos
            MyVideosVC *myVC = [[MyVideosVC alloc] initWithNibName:@"MyVideosVC" bundle:nil];
            [self.navigationController pushViewController:myVC animated:YES];
        }
            break;
            
        case 5: {
            ///////// Refer a Friend
            ReferFriendVC *myVC = [[ReferFriendVC alloc] initWithNibName:@"ReferFriendVC" bundle:nil];
            [self.navigationController pushViewController:myVC animated:YES];
        }
            break;
        case 6: {
            ////////// Purchase History
            PurchaseHistoryVC *myVC = [[PurchaseHistoryVC alloc] initWithNibName:@"PurchaseHistoryVC" bundle:nil];
            [self.navigationController pushViewController:myVC animated:YES];
        }
            break;
        case 7: {
            ////////// Settings
            SettingsVC *myVC = [[SettingsVC alloc] initWithNibName:@"SettingsVC" bundle:nil];
            [self.navigationController pushViewController:myVC animated:YES];
        }
            break;
        case 8: {
            ////////// Logout Navigation
            LogoutPopUpVC *customAlertVC = [[LogoutPopUpVC alloc] initWithNibName:@"LogoutPopUpVC" bundle:nil];
            customAlertVC.popUpDelegate = self;
            customAlertVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            [self presentViewController:customAlertVC animated:NO completion:nil];
        }
            break;
        default:
            break;
    }
}

#pragma mark - Button Action.
- (IBAction)crossBtnAction:(id)sender {
    [self.view endEditing:YES];
    [self AnimationFromTopToBottom];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)staticPageBtnAction:(UIButton *)sender {
    [self.view endEditing:YES];
    switch (sender.tag) {
        case 100: {
            ///// About Us.
            TAAboutUsVC *myVC = [[TAAboutUsVC alloc] initWithNibName:@"TAAboutUsVC" bundle:nil];
            myVC.enumVariable = About_us ;
            [self.navigationController pushViewController:myVC animated:YES];
        }
            break;
        case 101: {
            /////// Terms abd conditions.
            TAAboutUsVC *myVC = [[TAAboutUsVC alloc] initWithNibName:@"TAAboutUsVC" bundle:nil];
            myVC.fromTerms = YES;
            myVC.isFrom = NO;
            [self.navigationController pushViewController:myVC animated:YES];
        }
            break;
        case 102: {
            /////// Privacy policy.
            TAAboutUsVC *myVC = [[TAAboutUsVC alloc] initWithNibName:@"TAAboutUsVC" bundle:nil];
            myVC.enumVariable = Privacy_policy ;
            [self.navigationController pushViewController:myVC animated:YES];
        }
            break;
        default:
            break;
    }
}

- (IBAction)questionForumBtnAction:(id)sender {
    [self.view endEditing:YES];
    QuestionForumVC *myVC = [[QuestionForumVC alloc] initWithNibName:@"QuestionForumVC" bundle:nil];
    [self.navigationController pushViewController:myVC animated:YES];
}

#pragma mark- back delegate.
-(void)dismissPopUp {
    [self.view endEditing:YES];
    [self callApiForLogout];
}

#pragma mark - Web Services.
-(void) callApiForLogout {
    
    NSMutableDictionary *user_dict = [NSMutableDictionary dictionary];
    [user_dict setValue:[NSUSERDEFAULTS valueForKey:kuid] forKey:kuid];
    [user_dict setValue:[NSUSERDEFAULTS valueForKey:kdeviceToken] forKey:kdeviceToken];
    [user_dict setValue:kdeviceiOS forKey:kdeviceType];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:user_dict AndPath:kLogout WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        if (suceeded ) {
            
            NSString *responseCode = [response objectForKeyNotNull:kresponseCode expectedClass:[NSString class]];
            NSString *responseMessage = [response objectForKeyNotNull:kresponseMessage expectedClass:[NSString class]];
            if (responseCode.integerValue == KSuccessCode) {
                
                NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
                for (UIViewController *aViewController in allViewControllers) {
                    if ([aViewController isKindOfClass:[LoginVC class]]) {
                        [self.navigationController popToViewController:aViewController animated:YES];
                    }
                }
            } else if (responseCode.integerValue == KLogoutCode) {
                [[AlertView sharedManager] displayInformativeAlertwithTitle:@"Error!" andMessage:responseMessage onController:self];
                [APP_DELEGATE logout];
                [[APP_DELEGATE navController] popToRootViewControllerAnimated:YES];
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
