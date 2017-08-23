//
//  MyTestDetailsVC.m
//  AnyTimeClass
//
//  Created by Aman Goswami on 18/01/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

#import "MyTestDetailsVC.h"
#import "Header.h"

@interface MyTestDetailsVC ()<CAAnimationDelegate,UIDocumentInteractionControllerDelegate> {
    NSMutableArray *subjectArray;
    CoursesInfo *objModel;
}
@property (strong, nonatomic) IBOutlet UILabel *subjectName;
@property (strong, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (strong, nonatomic) IBOutlet UILabel *likesLabel;
@property (strong, nonatomic) IBOutlet UILabel *courseName;
@property (strong, nonatomic) IBOutlet UIButton *likeBtnOutlet;
@property (strong, nonatomic) IBOutlet UIImageView *bannerImageView;
@property (strong, nonatomic) IBOutlet UILabel *amountLabel;
@property (retain)UIDocumentInteractionController *docController;
@end

@implementation MyTestDetailsVC
#pragma mark - View Life Cycle.
- (void)viewDidLoad {
    [super viewDidLoad];
    /// Header and footer
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = self.footerView;
    subjectArray = [NSMutableArray array];
    objModel = [[CoursesInfo alloc] init];
    [self callApiForTestDetails];
}

#pragma mark - Memory management.
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma mark - Button Action.
- (IBAction)crossBtnAction:(id)sender {
    [self.view endEditing:YES];
    [self AnimationFromTopToBottom];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)likeBtnAction:(id)sender {
    [self.view endEditing:YES];
    if (self.likeBtnOutlet.selected == YES) {
        self.likeBtnOutlet.selected = NO;
    } else {
        self.likeBtnOutlet.selected = YES;
    }
}
- (IBAction)downloadBtnAction:(id)sender {
    [self.view endEditing:YES];

  //  NSString *path = [[NSBundle mainBundle] pathForResource:objModel.testfile ofType:@"pdf"];
    NSURL *targetURL = [NSURL fileURLWithPath:objModel.testfile];
    
    self.docController = [UIDocumentInteractionController interactionControllerWithURL:targetURL];
    
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"itms-books:"]]) {
        
        [self.docController presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];
        NSLog(@"iBooks installed");
        
    } else {
        [[AlertView sharedManager] presentAlertWithTitle:@"" message:@"iBooks not installed." andButtonsWithTitle:@[@"Ok"] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
        }];
        NSLog(@"iBooks not installed");
        
    }
 
}

#pragma mark - Webservices.

-(void) callApiForTestDetails{
    NSMutableDictionary *user_dict = [NSMutableDictionary dictionary];
    
    [user_dict setValue:[NSUSERDEFAULTS valueForKey:kuid] forKey:kuid];
    [user_dict setValue:self.testID forKey:@"testId"];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:user_dict AndPath:ktestDetail WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        if (suceeded) {
            
            NSString *responseCode = [response objectForKeyNotNull:kresponseCode expectedClass:[NSString class]];
            NSString *responseMessage = [response objectForKeyNotNull:kresponseMessage expectedClass:[NSString class]];
            
            if (responseCode.integerValue == KSuccessCode) {
                
                [subjectArray removeAllObjects];
                NSDictionary *subjectListArray = [response objectForKeyNotNull:@"subjectList" expectedClass:[NSArray class]];
                for (NSDictionary  *subjectDict in subjectListArray) {
                    objModel = [CoursesInfo parseTestList:subjectDict];
                }
                self.subjectName.text = objModel.courseName;
                self.descriptionTextView.text = objModel.testDescription;
                self.courseName.text = objModel.subjectName;
                [self.bannerImageView sd_setImageWithURL:[NSURL URLWithString:objModel.subjectImage ] placeholderImage:[UIImage imageNamed:@"ban1"]];
                if ([objModel.testPrice isEqualToString:@"Free"] ||[objModel.testPrice isEqualToString:@"Demo"]) {
                    self.amountLabel.text = objModel.testPrice;
                } else if ([objModel.testPrice isEqualToString:@""]) {
                    self.amountLabel.text = [NSString stringWithFormat:@"₹ 0"];
                } else {
                    self.amountLabel.text = [NSString stringWithFormat:@"₹ %@", objModel.testPrice ];
                }
                
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
