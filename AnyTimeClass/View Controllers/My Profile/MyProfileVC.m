//
//  MyProfileVC.m
//  AnyTimeClass
//
//  Created by Aman Goswami on 17/01/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

#import "MyProfileVC.h"
#import "Header.h"

@interface MyProfileVC ()<CAAnimationDelegate,UIPickerViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate> {
    userInfo *objModel;
    NSMutableArray *titleArray;
    BOOL  isEdit,isValidError,isBase64;
    NSInteger errroAtIndx;
    NSString *strErrorMsg;
    int a;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (strong, nonatomic) IBOutlet UIButton *profileBtnOutlet;
@property (strong, nonatomic) IBOutlet UIButton *changePassBtnOutlet;
@property (strong, nonatomic) IBOutlet UIButton *editBtnOutlet;
@property (strong, nonatomic) IBOutlet UIButton *backBtnAction;
@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;
@property (strong, nonatomic) IBOutlet UIView *cameraView;

@end

@implementation MyProfileVC
#pragma mark -  View Life Cycle.
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetup];
}

#pragma mark - Helper Method.
-(void) initialSetup {
    ////// cell register
    [self.tableView registerNib:[UINib nibWithNibName:@"MyProfileTVCell" bundle:nil] forCellReuseIdentifier:@"MyProfileTVCell"];
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = self.footerView;
    
    //////// Array initialisation
    titleArray = [[NSMutableArray alloc]initWithObjects:@"Name",@"Email",@"Mobile",@"Address", nil];
    ////////// model class object initialisation.
    objModel = [[userInfo alloc]init];
    //// Automatic Dimension.
    self.tableView.estimatedRowHeight = 60.0f;
    self.tableView.rowHeight =  UITableViewAutomaticDimension;
    //// Setting bool values.
    isEdit = NO;
    isBase64 = NO;
    self.profileBtnOutlet.userInteractionEnabled = NO;
    NSString *strFacebook = [NSUSERDEFAULTS valueForKey:kfromFacebook];
    if (![strFacebook isEqualToString:@"No"] ) {
        self.changePassBtnOutlet.hidden = YES;
        self.profileBtnOutlet.hidden = YES;
    } else {
        self.changePassBtnOutlet.hidden = NO;
        self.profileBtnOutlet.hidden = NO;
    }
     self.cameraView.hidden = YES;
    ////////  Api calling.
    [self callApiForProfile];
}
#pragma mark  -Animation.
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

#pragma mark - TableView Delegate and DataSource.

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return titleArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyProfileTVCell *cell = (MyProfileTVCell *)[self.tableView dequeueReusableCellWithIdentifier: @"MyProfileTVCell" forIndexPath:indexPath];
    cell.titleLabel.text = [titleArray objectAtIndex:indexPath.row];
    cell.valueTextField.userInteractionEnabled = NO;
    cell.valueTextField.hidden = YES;
    cell.valueLabel.hidden = NO;
    ///// validation show and hide.
    if (isValidError && indexPath.row == errroAtIndx) {
        [cell.errorLabel setText:strErrorMsg];
    }else{
        [cell.errorLabel setText:nil];
    }
    if (isEdit ==  YES) {
        cell.valueTextField.userInteractionEnabled = YES;
        cell.valueLabel.hidden = YES;
        cell.valueTextField.hidden = NO;
        cell.valueTextField.delegate = self;
        cell.valueTextField.userInteractionEnabled = YES;
        cell.valueTextField.tag = indexPath.row +100;
        switch (indexPath.row) {
            case 0: {
                cell.valueTextField.returnKeyType = UIReturnKeyNext;
                cell.valueTextField.keyboardType = UIKeyboardTypeDefault;
                cell.valueTextField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
                cell.valueTextField.text = objModel.fullName;
            }
                break;
            case 1: {
                cell.valueTextField.returnKeyType = UIReturnKeyNext;
                cell.valueTextField.keyboardType = UIKeyboardTypeEmailAddress;
                cell.valueTextField.userInteractionEnabled = NO;
                cell.valueTextField.text = objModel.email;
            }
                break;
            case 2: {
                cell.valueTextField.keyboardType = UIKeyboardTypeNumberPad;
                cell.valueTextField.returnKeyType = UIReturnKeyNext;
                cell.valueTextField.text = objModel.phoneNumber;
            }
                break;
            case 3: {
                cell.valueTextField.keyboardType = UIKeyboardTypeDefault;
                cell.valueTextField.returnKeyType = UIReturnKeyDone;
                cell.valueTextField.text = objModel.address;
            }
                break;
            default:
                break;
        }
        
    } else {
        ///////// when user edit the page.
        switch (indexPath.row) {
            case 0:
                objModel.fullName=[objModel.fullName capitalizedString];
                cell.valueLabel.text = objModel.fullName;
                break;
            case 1:
                cell.valueLabel.text = objModel.email;
                break;
            case 2:
                cell.valueLabel.text = objModel.phoneNumber;
                break;
            case 3:
                cell.valueLabel.text = objModel.address;
                break;
            default:
                break;
        }
    }
    return cell;
}

-(CGFloat) tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

#pragma mark- Text Field Delegate Method

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.returnKeyType == UIReturnKeyNext) {
        if (textField.tag == 102) {
            [[self.tableView viewWithTag:textField.tag+2] becomeFirstResponder];
        } else{
            [[self.tableView viewWithTag:textField.tag+1] becomeFirstResponder];
        }
    } else {
        [textField resignFirstResponder];
    }
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    [self.view layoutIfNeeded];
    switch (textField.tag) {
        case 100: {
            objModel.fullName = TRIM_SPACE(textField.text);
        }
            break;
        case 101: {
            objModel.email = TRIM_SPACE(textField.text);
        }
            break;
        case 102: {
            objModel.phoneNumber = TRIM_SPACE(textField.text);
        }
            break;
        case 103: {
            objModel.address = textField.text;
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
        case 101: {
            if (range.length + range.location>textField.text.length) {
                return NO;
            }
            NSUInteger newLength=[textField.text length]+[string length]-range.length;
            return newLength<=80;
        }
            break;
        case 102: {
            //// stopping user to enter 00
            if(range.location == 0)
            { a= 0;
                if ([string hasPrefix:@"0"])
                {
                    a=1;
                }
            }  else if (range.location == 1 && a ==1) {
                if ([string hasPrefix:@"0"])
                {
                    return NO;
                }
            }else if (range.length + range.location>textField.text.length) {
                return NO;
            }
            NSUInteger newLength=[textField.text length]+[string length]-range.length;
            
            return newLength<=12;
        }
            break;
        case 103: {
            if (range.length + range.location>textField.text.length) {
                return NO;
            }
            NSUInteger newLength=[textField.text length]+[string length]-range.length;
            return newLength<=256;
        }
            break;
            
        default:
            break;
    }
    return YES;
}

#pragma mark - Validations.
-(BOOL)isAllFieldVerified {
    [self.view endEditing:YES];
    BOOL isVerified = NO;
    isValidError = YES;
    errroAtIndx = 200;
    strErrorMsg = nil;
    
    if (![TRIM_SPACE(objModel.fullName) length]) {
        errroAtIndx = 0;
        strErrorMsg = AlertMessageFullName;
        
    } else if (!([objModel.fullName length] > 2)) {
        errroAtIndx = 0;
        strErrorMsg = AlertMessageMinValidName;
        
    } else if (![objModel.fullName isValidName]) {
        errroAtIndx = 0;
        strErrorMsg = AlertMessageValidFullName;
        
    } else if (![TRIM_SPACE(objModel.email) length]) {
        errroAtIndx = 1;
        strErrorMsg = AlertMessageEmailID;
        
    } else if (![objModel.email isValidEmail ]) {
        errroAtIndx = 1;
        strErrorMsg = AlertMessageValidEmailID;
        
    }
    else if (![TRIM_SPACE(objModel.phoneNumber) length]) {
        errroAtIndx = 2;
        strErrorMsg = AlertMessageMobileNumber;
        
    } else if (!([objModel.phoneNumber length] > 9 )){
        
        errroAtIndx = 2;
        strErrorMsg = AlertMessageMobileNumberValidation;
    }
    else if (![(objModel.address) length]) {
        errroAtIndx = 3;
        strErrorMsg = AlertMessageAddress;
    } else {
        isVerified = YES;
        isValidError = NO;
        isEdit = NO;
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
    isBase64 = YES;
    self.profileImageView.image = image;
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Button Action.

- (IBAction)editBtnAction:(id)sender {
    if (isEdit == NO) {
        [self.editBtnOutlet setTitle:@"Save" forState:UIControlStateNormal ];
        self.changePassBtnOutlet.hidden = YES;
         NSString *strFacebook = [NSUSERDEFAULTS valueForKey:kfromFacebook];
         if (![strFacebook isEqualToString:@"No"] ) {
             self.cameraView.hidden = NO;
         } else {
        self.cameraView.hidden = NO;
         }
        self.profileBtnOutlet.userInteractionEnabled = YES;
        isEdit = YES;
        [self.backBtnAction setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        
    } else {
        if ([self isAllFieldVerified]) {
            [self callApiForEditProfile];
        }
        [self.tableView reloadData];
    }
    [self.tableView reloadData];
}

- (IBAction)changePasswordAction:(id)sender {
    [self.view endEditing:YES];
    ChangePasswordVC *myVC = [[ChangePasswordVC alloc] initWithNibName:@"ChangePasswordVC" bundle:nil];
    [self.navigationController pushViewController:myVC animated:YES];
}

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
- (IBAction)menuBtnAction:(id)sender {
    [self.view endEditing:YES];
    [self AnimationFromBottomToTop];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Webservice.

- (void) callApiForProfile {
    
    NSMutableDictionary *user_dict = [NSMutableDictionary dictionary];
    [user_dict setValue:[NSUSERDEFAULTS valueForKey:kuid] forKey:kuid];
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:user_dict AndPath:kprofileDetail WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        if (suceeded) {
            
            NSString *responseCode = [response objectForKeyNotNull:kresponseCode expectedClass:[NSString class]];
            NSString *responseMessage = [response objectForKeyNotNull:kresponseMessage expectedClass:[NSString class]];
            if (responseCode.integerValue == KSuccessCode) {
                objModel = [userInfo parseUserInfo:[response objectForKeyNotNull:@"profileDetail" expectedClass:[NSDictionary class]]];
                [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:objModel.userImage] placeholderImage:[UIImage imageNamed:@"img1"]];
                [self.tableView reloadData];
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


-(void)callApiForEditProfile  {
    NSMutableDictionary *user_dict = [NSMutableDictionary dictionary];
    
    if(!isBase64) {
        NSURL *url = [NSURL URLWithString:objModel.userImage];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        objModel.userImage = imageToNSString(image);
    }
    [user_dict setValue:TRIM_SPACE(objModel.fullName)?TRIM_SPACE(objModel.fullName):@"" forKey:kname];
    [user_dict setValue:TRIM_SPACE(objModel.email)?TRIM_SPACE(objModel.email):@"" forKey:kemailID];
    [user_dict setValue:objModel.address?objModel.address:@"" forKey:kaddress];
    [user_dict setValue:objModel.phoneNumber?objModel.phoneNumber:@"" forKey:kmobile];
    [user_dict setValue:objModel.userImage?objModel.userImage:@"" forKey:kimage];
    [user_dict setValue:[NSUSERDEFAULTS valueForKey:kuid] forKey:kuid];
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:user_dict AndPath:keditProfile WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        if (suceeded) {
            NSString *responseCode = [response objectForKeyNotNull:kresponseCode expectedClass:[NSString class]];
            NSString *responseMessage = [response objectForKeyNotNull:kresponseMessage expectedClass:[NSString class]];
            if (responseCode.integerValue == KSuccessCode) {
                [self.editBtnOutlet setTitle:@"Edit" forState:UIControlStateNormal ];
                self.changePassBtnOutlet.hidden = NO;
                self.profileBtnOutlet.userInteractionEnabled = NO;
                isEdit = NO;
                [self.backBtnAction setImage:[UIImage imageNamed:@"n1" ] forState:UIControlStateNormal];
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
