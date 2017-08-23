//
//  TAAboutUsVC.m
//  AnyTimeClass
//
//  Created by Aman Goswami on 16/01/17.
//  Copyright © 2016 mobiloitte. All rights reserved.
//

#import "TAAboutUsVC.h"
#import "Header.h"

@interface TAAboutUsVC ()<CAAnimationDelegate>
@property (strong, nonatomic) IBOutlet UILabel *navigationLabel;
@property (strong, nonatomic) IBOutlet UIButton *crossButtonOutlet;
@property (strong, nonatomic) IBOutlet UITextView *descriptionTextView;
@property(strong ,nonatomic) NSString *isType;
@property (strong, nonatomic) IBOutlet UIButton *backBtnOutlet;

@end

@implementation TAAboutUsVC
#pragma mark - View Life Cycle.
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetup];
}

#pragma mark - helper Class
-(void) initialSetup {
    ///// Enum
    if (self.enumVariable == Terms_condition) {
        self.navigationLabel.text = @"Terms & Services";
        if ([self.months isEqualToString:@"6"]) {
            self.isType = @"terms&services6";
        } else if ([self.months isEqualToString:@"9"]){
        self.isType = @"terms&services9";
        } else {
            self.isType = @"terms&services9";
        }
    } else if (self.enumVariable == Privacy_policy) {
        self.navigationLabel.text = @"Privacy Policy";
        self.isType = @"privacypolicy";
        
    } else if (self.enumVariable == About_us) {
        self.navigationLabel.text = @"About Us";
        self.isType = @"aboutus";
    }
    ////////// From SignUp or Setting
    if (_isFrom == YES) {
        self.crossButtonOutlet.hidden = YES;
        [self.backBtnOutlet setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    } else {
        self.crossButtonOutlet.hidden = NO;
        [self.backBtnOutlet setImage:[UIImage imageNamed:@"n1"] forState:UIControlStateNormal];
    }
    [self callApiForStaticData];
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

#pragma mark - Uibutton Action.
- (IBAction)backButtonAction:(id)sender {
    [self.view endEditing:YES];
    if (_isFrom == NO) {
        [self AnimationFromTopToBottom];
        NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
        for (UIViewController *aViewController in allViewControllers) {
            if ([aViewController isKindOfClass:[SidePannelVC class]]) {
                [self.navigationController popToViewController:aViewController animated:NO];
            }
        }
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Webservices.
-(void) callApiForStaticData {
    
    NSMutableDictionary *static_dic = [NSMutableDictionary dictionary];
    if (self.fromTerms == YES) {
        [static_dic setValue:[NSUSERDEFAULTS valueForKey:kuid] forKey:kuid];
    } else {
    [static_dic setValue:self.isType forKey:@"type"];
    }
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:static_dic AndPath:self.fromTerms?Kterms_for_user : KstaticContents WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        if (suceeded ) {
            NSString *responseCode = [response objectForKeyNotNull:kresponseCode expectedClass:[NSString class]];
            NSString *strResponseMessage = [response objectForKeyNotNull:kresponseMessage expectedClass:[NSString class]];
            
            if (responseCode.integerValue == KSuccessCode) {
                
                NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[strResponseMessage dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
                
                self.descriptionTextView.attributedText = attributedString;
                
            }else{
                
                [[AlertView sharedManager] displayInformativeAlertwithTitle:@"Error!" andMessage:strResponseMessage onController:self];
                
            }
        }else{
            NSError *error = [response objectForKeyNotNull:kError expectedClass:[NSError class]];
            
            if (error != nil) {
                
                [[AlertView sharedManager] displayInformativeAlertwithTitle:@"Error!" andMessage:error.localizedDescription onController:self];
            }else{
                [[AlertView sharedManager] displayInformativeAlertwithTitle:@"Error!" andMessage:KError_Message onController:self];
            }
            
        }
    }];
}

#pragma mark - Memory mangement.
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
