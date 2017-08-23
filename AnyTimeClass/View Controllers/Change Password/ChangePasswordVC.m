//
//  ChangePasswordVC.m
//  AnyTimeClass
//
//  Created by Aman Goswami on 14/01/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

#import "ChangePasswordVC.h"
#import "Header.h"

@interface ChangePasswordVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate> {
    userInfo *objModel;
    NSInteger errroAtIndx;
    BOOL isValidError;
    NSString *strErrorMsg;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *footerView;

@end

@implementation ChangePasswordVC
#pragma mark - View Life Cycle.
- (void)viewDidLoad {
    [super viewDidLoad];
    ///// calling the helper method.
    [self initialSetup];
}

#pragma mark - Helper Classes
-(void) initialSetup {
    ////// cell register
    [self.tableView registerNib:[UINib nibWithNibName:@"ChangePasswordTVCell" bundle:nil] forCellReuseIdentifier:@"ChangePasswordTVCell"];
    ////// tableview Footer
    self.tableView.tableFooterView = self.footerView ;
    self.tableView.tableHeaderView = self.headerView ;
    ///// Model Class object initialization.
    objModel = [[userInfo alloc]init];
}

#pragma mark - TableView Delegate and DataSource.
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChangePasswordTVCell *cell = (ChangePasswordTVCell *)[self.tableView dequeueReusableCellWithIdentifier: @"ChangePasswordTVCell" forIndexPath:indexPath];
    cell.cellTextField.userInteractionEnabled = YES;
    cell.cellTextField.secureTextEntry = YES;
    cell.cellTextField.tag = indexPath.row+100;
    cell.cellButton.hidden = YES;
    cell.cellTextField.delegate = self;
    /////// error message show
    if (isValidError && indexPath.row == errroAtIndx) {
        [cell.errorLabel setText:strErrorMsg];
        cell.underLabel.backgroundColor = [UIColor colorWithRed:212.0f/255.0f green:32.0f/255.0f blue:31.0f/255.0f alpha:1.0];
    }else{
        [cell.errorLabel setText:nil];
        cell.underLabel.backgroundColor = [UIColor colorWithRed:170.0f/255.0f green:170.0f/255.0f blue:170.0f/255.0f alpha:1.0];
    }
    switch (indexPath.row) {
        case 0:{
            cell.cellTextField.placeholder = @"Current Password";
            cell.cellTextField.returnKeyType = UIReturnKeyNext;
            cell.cellTextField.keyboardType = UIKeyboardTypeDefault;
            cell.cellTextField.text = objModel.password;
        }
            break;
        case 1: {
            cell.cellTextField.placeholder = @"New Password";
            cell.cellTextField.returnKeyType = UIReturnKeyNext;
            cell.cellTextField.keyboardType = UIKeyboardTypeDefault;
            cell.cellTextField.text = objModel.nwPassword ;
        }
            break;
        case 2: {
            cell.cellTextField.placeholder = @"Confirm Password";
            cell.cellTextField.returnKeyType = UIReturnKeyDone;
            cell.cellTextField.keyboardType = UIKeyboardTypeDefault;
            cell.cellTextField.text = objModel.confirmPassword ;
        }
            break;
            
        default:
            break;
    }
    UIColor *color = [UIColor darkGrayColor];
    cell.cellTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:cell.cellTextField.placeholder attributes:@{NSForegroundColorAttributeName: color }];
    return cell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (isValidError && indexPath.row == errroAtIndx) {
        return 70.0f;
    }else{
        return 55.0f;
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
    [self.view layoutIfNeeded];
    switch (textField.tag) {
        case 100: {
            objModel.password = TRIM_SPACE(textField.text);
        }
            break;
        case 101: {
            objModel.nwPassword = TRIM_SPACE(textField.text);
            if (textField.tag == 101) {
                [self.tableView reloadData];
            }
        }
            break;
        case 102: {
            objModel.confirmPassword = TRIM_SPACE(textField.text);
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
    if (range.length + range.location>textField.text.length) {
        return NO;
    }
    NSUInteger newLength=[textField.text length]+[string length]-range.length;
    return newLength<=25;
}

#pragma mark - Validations.

-(BOOL)isAllFieldVerified {
    [self.view endEditing:YES];
    BOOL isVerified = NO;
    isValidError = YES;
    errroAtIndx = 200;
    strErrorMsg = nil;
    if (![TRIM_SPACE(objModel.password) length]) {
        errroAtIndx = 0;
        strErrorMsg = AlertMessageOldPassword;
        
    }  else if (!([TRIM_SPACE(objModel.password) length] > 5)) {
        errroAtIndx = 0;
        strErrorMsg = AlertMessagePasswordValidate;
        
    }  else if (![TRIM_SPACE(objModel.nwPassword) length]) {
        errroAtIndx = 1;
        strErrorMsg = AlertMessageNewPassword;
        
    } else if (!([TRIM_SPACE(objModel.nwPassword) length] > 5)) {
        errroAtIndx = 1;
        strErrorMsg = AlertMessagePasswordValidate;
        
    } else if ([objModel.password isEqualToString:objModel.nwPassword]) {
        errroAtIndx = 1;
        strErrorMsg = AlertMessageOldAndNewPassword;
        
    } else if (![TRIM_SPACE(objModel.confirmPassword) length]) {
        errroAtIndx = 2;
        strErrorMsg = AlertMessageConfirmPassword;
        
    } else if (![objModel.nwPassword isEqualToString:objModel.confirmPassword]) {
        errroAtIndx = 2;
        strErrorMsg = AlertMessageNewAndConfirmSame;
        
    } else {
        isVerified = YES;
        isValidError = NO;
    }
    return isVerified;
}

#pragma mark - button Action.
- (IBAction)submitBtnAction:(id)sender {
    [self.view endEditing:YES];
    if ([self isAllFieldVerified]) {
        [self callApiForChangePassword];
    }
    [_tableView reloadData];
}

- (IBAction)backBtnAction:(id)sender {
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -  WebService.

-(void) callApiForChangePassword {
    NSMutableDictionary *dict =[NSMutableDictionary dictionary];
    [dict setValue:[NSUSERDEFAULTS valueForKey:kuid] forKey:kuid];
    [dict setValue:objModel.password forKey:koldPassword];
    [dict setValue:objModel.nwPassword forKey:knewPassword];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dict AndPath:kChangePassword WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        if (suceeded) {
            
            NSString *responseCode = [response objectForKeyNotNull:kresponseCode expectedClass:[NSString class]];
            NSString *responseMessage = [response objectForKeyNotNull:kresponseMessage expectedClass:[NSString class]];
            
            if (responseCode.integerValue == KSuccessCode) {
                [[AlertView sharedManager] presentAlertWithTitle:@"" message:@"Password Changed Successfully!" andButtonsWithTitle:@[@"Ok"] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }];
            }else{
                
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

#pragma mark - Memory Management.
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
