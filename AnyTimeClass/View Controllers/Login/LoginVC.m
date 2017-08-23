//
//  LoginVC.m
//  AnyTimeClass
//
//  Created by Aman Goswami on 14/01/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//
#import <Google/SignIn.h>
#import "LoginVC.h"
#import "Header.h"


@interface LoginVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,GIDSignInUIDelegate> {
    userInfo *objModel;
    NSInteger errroAtIndx;
    BOOL isValidError;
    NSString *strErrorMsg;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (strong, nonatomic) IBOutlet UIButton *facebookBtnOutlet;
@property (strong, nonatomic) IBOutlet UIButton *googleBtnOutlet;
@property (strong, nonatomic) IBOutlet UIButton *loginBtnOutlet;
@property (strong, nonatomic) IBOutlet UIButton *forgotBtnOutlet;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *socialConstraint;
@property (strong, nonatomic) IBOutlet UIButton *signUpBtnOutlet;
@property (nonatomic,assign) BOOL fromFacebook;
@end

@implementation LoginVC
#pragma mark - View life cycle.
- (void)viewDidLoad {
    [super viewDidLoad];
    ///// calling the helper method.
    [self initialSetup];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    objModel.email = @"";
    objModel.password = @"";
    [self.tableView reloadData];
}

#pragma mark - Helper Classes
-(void) initialSetup {
    ////// cell register
    [self.tableView registerNib:[UINib nibWithNibName:@"SignUpTVCell" bundle:nil] forCellReuseIdentifier:@"SignUpTVCell"];
    
    ////// tableview Footer
    self.tableView.tableFooterView = self.footerView ;
    self.tableView.tableHeaderView = self.headerView ;
    ///// Model Class object initialization.
    objModel = [[userInfo alloc]init];
    /////// setting button
    [_forgotBtnOutlet setExclusiveTouch:YES];
    [_facebookBtnOutlet setExclusiveTouch:YES];
    [_googleBtnOutlet setExclusiveTouch:YES];
    [_loginBtnOutlet setExclusiveTouch:YES];
    //////// Google Delegate.
    [GIDSignIn sharedInstance].uiDelegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getGoogleData) name:@"getGoogleData" object:nil];
    ////Window management
    if (WIN_HEIGHT == 568) {
        self.tableView.scrollEnabled = NO;
        self.tableView.pagingEnabled = YES;
        self.topConstraint.constant = 5.0f;
        self.socialConstraint.constant = 5.0f;
        self.tableView.tableHeaderView.frame = CGRectMake(0, 0, self.tableView.contentSize.width, 185.0f);
    }  else if (WIN_HEIGHT == 480) {
        self.tableView.scrollEnabled = YES;
        self.topConstraint.constant = 5.0f;
        self.socialConstraint.constant = 5.0f;
        self.tableView.tableHeaderView.frame = CGRectMake(0, 0, self.tableView.contentSize.width, 185.0f);
    } else {
        self.tableView.tableHeaderView.frame = CGRectMake(0, 0, self.tableView.contentSize.width, 230.0f);
        self.tableView.scrollEnabled = NO;
    }
    ///////// Setting Font to Buttons
    [self.signUpBtnOutlet .titleLabel setFont:[UIFont fontWithName:@"advent-pro" size:15.0f]];
    [self.forgotBtnOutlet .titleLabel setFont:[UIFont fontWithName:@"advent-pro" size:15.0f]];
}
////// Dealloc the notification
-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - TableView Delegate and DataSource.

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SignUpTVCell *cell = (SignUpTVCell *)[self.tableView dequeueReusableCellWithIdentifier: @"SignUpTVCell" forIndexPath:indexPath];
    cell.cellTextField.userInteractionEnabled = YES;
    cell.cellTextField.secureTextEntry = NO;
    cell.cellTextField.tag = indexPath.row+100;
    cell.cellTextField.delegate = self;
    cell.cellBtnOutlet.hidden = YES;
    cell.cellBtnOutlet.hidden = YES;
    cell.passwordImage.hidden = YES;
    
    if (isValidError && indexPath.row == errroAtIndx) {
        [cell.errorLabel setText:strErrorMsg];
        cell.underLabel.backgroundColor = [UIColor colorWithRed:212.0f/255.0f green:32.0f/255.0f blue:31.0f/255.0f alpha:1.0];
    }else{
        [cell.errorLabel setText:nil];
        cell.underLabel.backgroundColor = [UIColor colorWithRed:120.0f/255.0f green:117.0f/255.0f blue:116.0f/255.0f alpha:1.0];
        
    }
    switch (indexPath.row) {
        case 0:{
            cell.cellTextField.placeholder = @"Email";
            cell.cellImageView.image = [UIImage imageNamed:@"i_mail"];
            cell.cellTextField.returnKeyType = UIReturnKeyNext;
            cell.cellTextField.keyboardType = UIKeyboardTypeEmailAddress;
            cell.cellTextField.text = objModel.email;
        }
            break;
        case 1: {
            cell.cellTextField.placeholder = @"Password";
            cell.cellImageView.image = [UIImage imageNamed:@"i_pass"];
            cell.cellTextField.returnKeyType = UIReturnKeyDone;
            cell.cellTextField.keyboardType = UIKeyboardTypeDefault;
            cell.cellTextField.secureTextEntry = YES;
            cell.cellTextField.text = objModel.password ;
        }
            break;
        default:
            break;
    }
    UIColor *color = [UIColor whiteColor];
    cell.cellTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:cell.cellTextField.placeholder attributes:@{NSForegroundColorAttributeName: color }];
    return cell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (isValidError && indexPath.row == errroAtIndx) {
        return 71.0f;
    }else{
        return 60.0f;
    }
}

#pragma mark- Text Field Delegate Method

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.returnKeyType == UIReturnKeyNext) {
        [[self.tableView viewWithTag:textField.tag+1] becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    switch (textField.tag) {
        case 100: {
            objModel.email = TRIM_SPACE(textField.text);
        }
            break;
        case 101: {
            objModel.password = TRIM_SPACE(textField.text);
        }
            break;
        default:
            break;
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    ///// stopping space in start.
    if(range.location == 0) {
        if ([string hasPrefix:@" "]) {
            return NO;
        }
    }
    switch (textField.tag) {
        case 100: {
            if (range.length + range.location>textField.text.length) {
                return NO;
            }
            NSUInteger newLength=[textField.text length]+[string length]-range.length;
            return newLength<=80;
        }
            break;
        case 101: {
            if (range.length + range.location>textField.text.length) {
                return NO;
            }
            NSUInteger newLength=[textField.text length]+[string length]-range.length;
            return newLength<=25;
        }
            break;
        default:
            break;
    }
    return YES;
}

#pragma mark  -Validation.
-(BOOL)isAllFieldVerified {
    [self.view endEditing:YES];
    BOOL isVerified = NO;
    isValidError = YES;
    errroAtIndx = 200;
    strErrorMsg = nil;
    if (![TRIM_SPACE(objModel.email) length]) {
        errroAtIndx = 0;
        strErrorMsg = AlertMessageEmailID;
        
    }  else if (![objModel.email isValidEmail]) {
        errroAtIndx = 0;
        strErrorMsg = AlertMessageValidEmailID;
        
    } else if (![TRIM_SPACE(objModel.password) length]) {
        errroAtIndx = 1;
        strErrorMsg = AlertMessagePassword;
        
    } else if (!([TRIM_SPACE(objModel.password) length] > 5)) {
        errroAtIndx = 1;
        strErrorMsg = AlertMessagePasswordValidate;
        
    } else {
        isVerified = YES;
        isValidError = NO;
    }
    return isVerified;
}

#pragma mark - View movement.



#pragma mark - Button Action.
- (IBAction)loginBtnAction:(id)sender {
    [self.view endEditing:YES];
    if ([self isAllFieldVerified]) {
        [self callApiToLogin];
    }
    [_tableView reloadData];
    
}

- (IBAction)forgotPasswordBtnAction:(id)sender {
    [self.view endEditing:YES];
    ForgotPasswordVC *myVC = [[ForgotPasswordVC alloc] initWithNibName:@"ForgotPasswordVC" bundle:nil];
    [self.navigationController pushViewController:myVC animated:YES];
}

- (IBAction)facebookBtnAction:(id)sender {
    ////////// Facebook Login
    [self.view endEditing:YES];
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
            self.fromFacebook = YES;
            NSLog(@"infoDict====%@",user);
            [self callApiForSocialLogin:user];
        }
    }];
    
    
}

- (IBAction)googleBtnAction:(id)sender {
    ///////// Google Login
    [self.view endEditing:YES];
    [APP_DELEGATE setFromLogin:YES];
    [[GIDSignIn sharedInstance] signIn];
}

-(void)getGoogleData {
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
        self.fromFacebook = NO;
        [[userInfo appShareinstance] setFromFacebook:@"yes"];
        [self callApiForSocialLogin:user];
    }
}

- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error {
    //  [myActivityIndicator stopAnimating];
}

// Present a view that prompts the user to sign in with Google
- (void)signIn:(GIDSignIn *)signIn
presentViewController:(UIViewController *)viewController {
    [self presentViewController:viewController animated:YES completion:nil];
}

// Dismiss the "Sign in with Google" view
- (void)signIn:(GIDSignIn *)signIn
dismissViewController:(UIViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)signIn:(GIDSignIn *)signIn didDisconnectWithUser:(GIDGoogleUser *)user withError:(NSError *)error {
    // Perform any operations when the user disconnects from app here.
}

- (IBAction)signUpBtnAction:(id)sender {
    [self.view endEditing:YES];
    SocialMediaSignUp *myVC = [[SocialMediaSignUp alloc] initWithNibName:@"SocialMediaSignUp" bundle:nil];
    [self.navigationController pushViewController:myVC animated:YES];
}

#pragma mark - Web Api Call Methods

-(void)callApiToLogin {
    
    NSMutableDictionary *user_dict = [NSMutableDictionary dictionary];
    [user_dict setValue:objModel.email forKey:kemailID];
    [user_dict setValue:objModel.password forKey:kpassword];
    [user_dict setValue:kdeviceiOS forKey:kdeviceType];
    [user_dict setValue:[NSUSERDEFAULTS valueForKey:kdeviceKey] forKey:kdeviceKey];
    [user_dict setValue:[NSUSERDEFAULTS valueForKey:kdeviceToken] forKey:kdeviceToken];
    [self.view setUserInteractionEnabled:YES];
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:user_dict AndPath:kLogin WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        if (suceeded ) {
            NSString *responseCode = [response objectForKeyNotNull:kresponseCode expectedClass:[NSString class]];
            
            if (responseCode.integerValue == KSuccessCode) {
                
                [[NSUserDefaults standardUserDefaults] setValue:[response objectForKeyNotNull:kuid expectedClass:[NSString class]] forKey:kuid];
                
                NSLog(@"uer id  = %@",[response objectForKeyNotNull:kuid expectedClass:[NSString class]]);
                [[NSUserDefaults standardUserDefaults] setValue:@"No" forKey:kfromFacebook];
                [[NSUserDefaults standardUserDefaults] setValue:[response objectForKeyNotNull:@"pushsetting" expectedClass:[NSString class]] forKey:kpushsetting];
                
                [NSUSERDEFAULTS synchronize];
                ///// navigation
                HomeVC *myVC = [[HomeVC alloc] initWithNibName:@"HomeVC" bundle:nil];
                [self.navigationController pushViewController:myVC animated:YES];
            }else{
                
                [[AlertView sharedManager] displayInformativeAlertwithTitle:@"Error!" andMessage:@"Invalid Credentials."onController:self];
                [self.view setUserInteractionEnabled:YES];
            }
        }else{
            NSError *error = [response objectForKeyNotNull:kError expectedClass:[NSError class]];
            
            if (error != nil) {
                
                [[AlertView sharedManager] displayInformativeAlertwithTitle:@"Error!" andMessage:error.localizedDescription onController:self];
            }else{
                [[AlertView sharedManager] displayInformativeAlertwithTitle:@"Error!" andMessage:KError_Message onController:self];
            }
            [self.view setUserInteractionEnabled:YES];
        }
    }];
}

-(void) callApiForSocialLogin:(userInfo *) user {
    [self.view endEditing:YES];
    NSMutableDictionary *user_dict = [NSMutableDictionary dictionary];
    
    [user_dict setValue:TRIM_SPACE(user.email)?TRIM_SPACE(user.email):@"" forKey:kemailID];
    if (self.fromFacebook == YES) {
        [user_dict setValue:user.facebookId?user.facebookId:@"" forKey:@"socialID"];
    } else{
        [user_dict setValue:user.googleUserID?user.googleUserID:@"" forKey:@"socialID"];
    }
    [user_dict setValue:user.userImage?user.userImage:@"" forKey:kimage];
    [user_dict setValue:user.fullName?user.fullName:@"" forKey:kname];
    [user_dict setValue:user.dob?user.dob:@"" forKey:kdob];
    [user_dict setValue:user.gender?user.gender:@"" forKey:kgender];
    
    [user_dict setValue:kdeviceiOS forKey:kdeviceType];
    [user_dict setValue:[NSUSERDEFAULTS valueForKey:kdeviceToken] forKey:kdeviceToken];
    [user_dict setValue:[NSUSERDEFAULTS valueForKey:kdeviceKey] forKey:kdeviceKey];
    [user_dict setValue:user.socialType forKey:@"socialType"];
    [user_dict setValue:user.course_duration?TRIM_SPACE(user.course_duration):@"" forKey:@"course_duration"];
    
    [self.view setUserInteractionEnabled:NO];
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:user_dict AndPath:ksocial_login WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        if (suceeded ) {
            
            NSString *responseCode = [response objectForKeyNotNull:kresponseCode expectedClass:[NSString class]];
            NSString *responseMessage = [response objectForKeyNotNull:kresponseMessage expectedClass:[NSString class]];
            
            if (responseCode.integerValue == KSuccessCode) {
                
                [[NSUserDefaults standardUserDefaults] setValue:[response objectForKeyNotNull:kuid expectedClass:[NSString class]] forKey:kuid];
                [[NSUserDefaults standardUserDefaults] setValue:@"Yes" forKey:kfromFacebook];
                NSLog(@"uer id  = %@",[response objectForKeyNotNull:kuid expectedClass:[NSString class]]);
                [[NSUserDefaults standardUserDefaults] setValue:[response objectForKeyNotNull:@"pushsetting" expectedClass:[NSString class]] forKey:kpushsetting];
                
                [NSUSERDEFAULTS synchronize];
                ///// navigation
                HomeVC *myVC = [[HomeVC alloc] initWithNibName:@"HomeVC" bundle:nil];
                [self.navigationController pushViewController:myVC animated:YES];
                
            } else if (responseCode.integerValue ==  400){
                [[userInfo appShareinstance] setFromFacebook:@"yes"];
                  if (self.fromFacebook == YES) {
                SignUpVC *myVC = [[SignUpVC alloc] initWithNibName:@"SignUpVC" bundle:nil];
                myVC.objData = user;
                myVC.fromFacebook = @"1";
                [self.navigationController pushViewController:myVC animated:YES];
                  } else {
                      
                      SignUpVC *myVC = [[SignUpVC alloc] initWithNibName:@"SignUpVC" bundle:nil];
                      myVC.objData = user;
                      myVC.fromFacebook = @"2";
                      [self.navigationController pushViewController:myVC animated:YES];
                  }
            }
            else{
                [[AlertView sharedManager] displayInformativeAlertwithTitle:@"Error!" andMessage:responseMessage onController:self];
                [self.view setUserInteractionEnabled:YES];
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
    [self.view setUserInteractionEnabled:YES];
}


#pragma mark - Memory Management.
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
