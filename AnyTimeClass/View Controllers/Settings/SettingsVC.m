//
//  SettingsVC.m
//  AnyTimeClass
//
//  Created by Aman Goswami on 17/01/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

#import "SettingsVC.h"
#import "Header.h"

@interface SettingsVC ()<CAAnimationDelegate>{
    userInfo *objModel;
}
@property (strong, nonatomic) IBOutlet UISwitch *switchBtnOutlet;

@end

@implementation SettingsVC
#pragma mark - View Life Cycle.
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([[NSUSERDEFAULTS valueForKey:kpushsetting] isEqualToString:@"1"]) {
         [self.switchBtnOutlet setOn:YES];
    } else {
         [self.switchBtnOutlet setOn:NO];
    }
    objModel = [[userInfo alloc]init];
}

#pragma mark - Animation.
-(void) AnimationFromTopToBottom {
    CATransition *animation = [CATransition animation];
    [animation setDelegate:self];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromBottom];
    [animation setDuration:0.65f];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [[self.navigationController.view layer] addAnimation:animation forKey:@"AnimationFromBottomToTop"];
}

-(void) AnimationFromBottomToTop {
    CATransition *animation = [CATransition animation];
    [animation setDelegate:self];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromTop];
    [animation setDuration:0.65f];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [[self.navigationController.view layer] addAnimation:animation forKey:@"AnimationFromBottomToTop"];
}

#pragma mark - Memory management.
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - button Action.
- (IBAction)switchBtnAction:(UIButton *)sender {
    [self.view endEditing:YES];
    sender.selected = !sender.selected;
    if (sender.selected == NO) {
        objModel.pushsetting = @"0";
    } else {
        objModel.pushsetting = @"1";
    }
    [self callApiForSetting];
}

- (IBAction)crossBtnAction:(id)sender {
    [self.view endEditing:YES];
    [self AnimationFromBottomToTop];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)menuBtnAction:(id)sender {
    [self.view endEditing:YES];
    [self AnimationFromBottomToTop];
    NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
    for (UIViewController *aViewController in allViewControllers) {
        if ([aViewController isKindOfClass:[SidePannelVC class]]) {
            [self.navigationController popToViewController:aViewController animated:NO];
        }
    }
}

#pragma mark - Webservice.
- (void) callApiForSetting {
    
    NSMutableDictionary *user_dict = [NSMutableDictionary dictionary];
    [user_dict setValue:[NSUSERDEFAULTS valueForKey:kuid] forKey:kuid];
    [user_dict setValue:objModel.pushsetting forKey:kpushValue];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:user_dict AndPath:kchangePushSetting WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        if (suceeded) {
            NSString *responseCode = [response objectForKeyNotNull:kresponseCode expectedClass:[NSString class]];
            NSString *responseMessage = [response objectForKeyNotNull:kresponseMessage expectedClass:[NSString class]];
            
            if (responseCode.integerValue == KSuccessCode) {
                 [[NSUserDefaults standardUserDefaults] setValue:[response objectForKeyNotNull:@"pushsetting" expectedClass:[NSString class]] forKey:kpushsetting];
                
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
