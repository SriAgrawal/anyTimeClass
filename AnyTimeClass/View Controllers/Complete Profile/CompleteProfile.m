//
//  CompleteProfile.m
//  AnyTimeClass
//
//  Created by Aman Goswami on 14/01/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

#import "CompleteProfile.h"
#import "Header.h"

@interface CompleteProfile ()<UITextFieldDelegate,UIPickerViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    userInfo *objModel;
    NSInteger errroAtIndx;
    BOOL isValidError;
    NSString *strErrorMsg;
}

@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (strong, nonatomic) IBOutlet UIButton *maleBtnOutlet;
@property (strong, nonatomic) IBOutlet UIButton *femaleBtnOutlet;
@property (strong, nonatomic) IBOutlet UIButton *profileBtnOutlet;
@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;
@end

@implementation CompleteProfile
#pragma mark - View life Cycle.
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetup];
}

#pragma mark  -Helper Method.
-(void) initialSetup {
    ////// cell register
    [self.tableView registerNib:[UINib nibWithNibName:@"SignUpTVCell" bundle:nil] forCellReuseIdentifier:@"SignUpTVCell"];
    ////// tableview Footer
    self.tableView.tableFooterView = self.footerView ;
    self.tableView.tableHeaderView = self.headerView ;
    ///// Model Class object initialization.
    objModel = [[userInfo alloc]init];
    ///// Window management
    if (WIN_HEIGHT < 400) {
        self.tableView.scrollEnabled = YES;
    } else {
        self.tableView.scrollEnabled = NO;
    }
    objModel = self.objSignUp;
    if (objModel.userImage != nil) {
        [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:objModel.userImage] placeholderImage:[UIImage imageNamed:@"img1"]];
    }
}

#pragma mark - TableView Delegate and DataSource.

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SignUpTVCell *cell = (SignUpTVCell *)[self.tableView dequeueReusableCellWithIdentifier: @"SignUpTVCell" forIndexPath:indexPath];
    cell.cellTextField.tag = indexPath.row+100;
    cell.textFieldContraint.constant = -20.0f;
    cell.textFieldBackConstraint.constant = 30.0f;
    cell.cellTextField.textAlignment = NSTextAlignmentCenter;
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
            cell.cellTextField.placeholder = @"We are willing to know your name";
            cell.cellTextField.returnKeyType = UIReturnKeyDone;
            cell.cellTextField.keyboardType = UIKeyboardTypeDefault;
            cell.cellTextField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
            cell.cellTextField.text = objModel.fullName;
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
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    [self.view layoutIfNeeded];
    switch (textField.tag) {
        case 100: {
            objModel.fullName = textField.text;
        }
            break;
            break;
        default:
            break;
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
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
            return newLength<=60;
        }
            break;
        default:
            break;
    }
    return YES;
}

#pragma mark - validations.

-(BOOL)isAllFieldVerified {
    [self.view endEditing:YES];
    BOOL isVerified = NO;
    isValidError = YES;
    errroAtIndx = 200;
    strErrorMsg = nil;
    if (![(objModel.fullName) length]) {
        errroAtIndx = 0;
        strErrorMsg = AlertMessageFullName;
        
    } else if (!([objModel.fullName length] > 2)) {
        errroAtIndx = 0;
        strErrorMsg = AlertMessageMinValidName;
        
    } else if (![objModel.fullName isValidName]) {
        errroAtIndx = 0;
        strErrorMsg = AlertMessageValidFullName;
        
    } else {
        isVerified = YES;
        isValidError = NO;
    }
    return isVerified;
}

#pragma mark - Take Profile img from Camera or Gallery

-(void)takePhotoFromCamera {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIImagePickerController *profileImagePicker = [[UIImagePickerController alloc]init];
        profileImagePicker.delegate = self;
        profileImagePicker.allowsEditing = YES;
        profileImagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;;
        [self presentViewController:profileImagePicker animated:YES completion:NULL];
    }
    else {
        [[AlertView sharedManager] displayInformativeAlertwithTitle:@"Warning!" andMessage:@"Camera is not available" onController:self];
    }
}

-(void)takePhotoFromGallery {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - UIImagePicker Delegate method

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    objModel.userImage = imageToNSString(image);
    self.profileImageView.image = image ;
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Button Action.

- (IBAction)profileBtnAction:(id)sender {
    [self.view endEditing:YES];
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        // Cancel button tappped do nothing.
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Take a photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        // take photo button tapped.
        [self takePhotoFromCamera];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Choose from gallery" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        // choose photo button tapped.
        [self takePhotoFromGallery];
    }]];
    
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (IBAction)maleFemaleAction:(UIButton *)sender {
    [self.view endEditing:YES];
    switch (sender.tag) {
        case 500: {
            ////// male button action
            self.maleBtnOutlet.selected = YES;
            self.femaleBtnOutlet.selected = NO;
            objModel.gender = @"male";
        }
            break;
        case 501: {
            ////// female button action
            self.maleBtnOutlet.selected = NO;
            self.femaleBtnOutlet.selected = YES;
            objModel.gender = @"female";
        }
            break;
        default:
            break;
    }
}

- (IBAction)submitBtnAction:(id)sender {
    [self.view endEditing:YES];
    if ([self isAllFieldVerified]) {
     //   if (objModel.socialType == nil) {
            [self callApiToSignupUser];
    //    } else {
      //      [self callApiForSocialLogin];
    //    }
    }
    [_tableView reloadData];
}

- (IBAction)backBtnAction:(id)sender {
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Web Api Call Methods
-(void)callApiToSignupUser{
    
    NSMutableDictionary *user_dict = [NSMutableDictionary dictionary];
    
    [user_dict setValue:TRIM_SPACE(objModel.email)?TRIM_SPACE(objModel.email):@"" forKey:kemailID];
    [user_dict setValue:TRIM_SPACE(objModel.dob)?TRIM_SPACE(objModel.dob):@"" forKey:kdob];
    [user_dict setValue:objModel.address?objModel.address:@"" forKey:kaddress];
    [user_dict setValue:objModel.referralCode?objModel.referralCode:@"" forKey:krefferal_code];
    [user_dict setValue:objModel.userImage?objModel.userImage:@"" forKey:kimage];
    [user_dict setValue:objModel.fullName?objModel.fullName:@"" forKey:kname];
    [user_dict setValue:objModel.gender?TRIM_SPACE(objModel.gender):@"" forKey:kgender];
    [user_dict setValue:objModel.course_duration?TRIM_SPACE(objModel.course_duration):@"" forKey:@"course_duration"];
    [user_dict setValue:kdeviceiOS forKey:kdeviceType];
    [user_dict setValue:[NSUSERDEFAULTS valueForKey:kdeviceToken] forKey:kdeviceToken];
    [user_dict setValue:[NSUSERDEFAULTS valueForKey:kdeviceKey] forKey:kdeviceKey];
    
    if ([self.fromFacebook isEqualToString:@"1"]) {
        [user_dict setValue:objModel.facebookId?objModel.facebookId:@"" forKey:@"socialID"];
         [user_dict setValue:TRIM_SPACE(objModel.facebookId)?TRIM_SPACE(objModel.facebookId):@"" forKey:kpassword];
    } else if ([self.fromFacebook isEqualToString:@"2"]){
        [user_dict setValue:objModel.googleUserID?objModel.googleUserID:@"" forKey:@"socialID"];
         [user_dict setValue:TRIM_SPACE(objModel.googleUserID)?TRIM_SPACE(objModel.googleUserID):@"" forKey:kpassword];
    } else {
        [user_dict setValue:@"" forKey:@"socialID"];
         [user_dict setValue:TRIM_SPACE(objModel.password)?TRIM_SPACE(objModel.password):@"" forKey:kpassword];
    }
    [user_dict setValue:objModel.socialType forKey:@"socialType"];
    
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:user_dict AndPath:kUserSignUp WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        if (suceeded ) {
            
            NSString *responseCode = [response objectForKeyNotNull:kresponseCode expectedClass:[NSString class]];
            NSString *responseMessage = [response objectForKeyNotNull:kresponseMessage expectedClass:[NSString class]];
            
            if (responseCode.integerValue == KSuccessCode) {
                
                objModel = [userInfo parseUserInfo:[response objectForKeyNotNull:@"UserInfo" expectedClass:[NSDictionary class]]];
                [[NSUserDefaults standardUserDefaults] setValue:@"No" forKey:kfromFacebook];
                [NSUSERDEFAULTS setValue:objModel.uid forKey:kuid];
                [[NSUserDefaults standardUserDefaults] setValue:objModel.pushsetting forKey:kpushsetting];
                [[AlertView sharedManager] presentAlertWithTitle:@"Congratulations!" message:@"You have registered successfully." andButtonsWithTitle:@[@"Ok"] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                    HomeVC *myVC = [[HomeVC alloc] initWithNibName:@"HomeVC" bundle:nil];
                    [self.navigationController pushViewController:myVC animated:YES];
                }];
                
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


-(void) callApiForSocialLogin {
    [self.view endEditing:YES];
    NSMutableDictionary *user_dict = [NSMutableDictionary dictionary];
    
    [user_dict setValue:TRIM_SPACE(objModel.email)?TRIM_SPACE(objModel.email):@"" forKey:kemailID];
    if ([self.fromFacebook isEqualToString:@"1"]) {
        [user_dict setValue:objModel.facebookId?objModel.facebookId:@"" forKey:@"socialID"];
    } else{
        [user_dict setValue:objModel.googleUserID?objModel.googleUserID:@"" forKey:@"socialID"];
    }
    [user_dict setValue:objModel.userImage?objModel.userImage:@"" forKey:kimage];
    [user_dict setValue:objModel.fullName forKey:kname];
    [user_dict setValue:objModel.dob?objModel.dob:@"" forKey:kdob];
    [user_dict setValue:objModel.gender?objModel.gender:@"" forKey:kgender];
    [user_dict setValue:kdeviceiOS forKey:kdeviceType];
    [user_dict setValue:[NSUSERDEFAULTS valueForKey:kdeviceToken] forKey:kdeviceToken];
    [user_dict setValue:[NSUSERDEFAULTS valueForKey:kdeviceKey] forKey:kdeviceKey];
    [user_dict setValue:objModel.socialType forKey:@"socialType"];
    [user_dict setValue:objModel.course_duration?TRIM_SPACE(objModel.course_duration):@"" forKey:@"subscription"];
    
    [self.view setUserInteractionEnabled:NO];
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:user_dict AndPath:ksocial_login WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        if (suceeded ) {
            
            NSString *responseCode = [response objectForKeyNotNull:kresponseCode expectedClass:[NSString class]];
            NSString *responseMessage = [response objectForKeyNotNull:kresponseMessage expectedClass:[NSString class]];
            if (responseCode.integerValue == KSuccessCode) {
                
                [[NSUserDefaults standardUserDefaults] setValue:[response objectForKeyNotNull:kuid expectedClass:[NSString class]] forKey:kuid];
                NSLog(@"uer id  = %@",[response objectForKeyNotNull:kuid expectedClass:[NSString class]]);
                [NSUSERDEFAULTS synchronize];
                
                [[NSUserDefaults standardUserDefaults] setValue:@"Yes" forKey:kfromFacebook];
                HomeVC *myVC = [[HomeVC alloc] initWithNibName:@"HomeVC" bundle:nil];
                [self.navigationController pushViewController:myVC animated:YES];
                
            }else{
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



#pragma mark - Memory management.
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
