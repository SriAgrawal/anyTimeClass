//
//  SignUpVC.m
//  AnyTimeClass
//
//  Created by Aman Goswami on 14/01/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

#import "SignUpVC.h"
#import "Header.h"
#import "TASIgnUpBtnCell.h"

@interface SignUpVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate> {
    userInfo *objModel;
    NSInteger errroAtIndx;
    BOOL isValidError;
    NSString *strErrorMsg;
}
@property (strong, nonatomic) IBOutlet UILabel *errorLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (strong, nonatomic) IBOutlet UIButton *checkBoxBtnOutlet;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIButton *termsBtnOutlet;
@property (strong,nonatomic) NSString *terms;

@end

@implementation SignUpVC

#pragma mark - View Life Cycle.
- (void)viewDidLoad {
    [super viewDidLoad];
    ///// calling the helper method.
    [self initialSetup];
}

#pragma mark - Helper Classes
-(void) initialSetup {
    ////// cell register
    [self.tableView registerNib:[UINib nibWithNibName:@"SignUpTVCell" bundle:nil] forCellReuseIdentifier:@"SignUpTVCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TASIgnUpBtnCell" bundle:nil] forCellReuseIdentifier:@"TASIgnUpBtnCell"];
    ////// tableview Footer
    self.tableView.tableFooterView = self.footerView ;
    self.tableView.tableHeaderView = self.headerView ;
    ///// Model Class object initialization.
    objModel = [[userInfo alloc]init];
    if (self.objData != nil) {
        objModel = self.objData;
    }
    [self.termsBtnOutlet .titleLabel setFont:[UIFont fontWithName:@"advent-pro.regular" size:15.0f]];
    //// initial value setup.
    self.errorLabel.hidden = YES;
    objModel.sixMonth = YES;
    self.terms = @"6";
    objModel.course_duration = [NSString stringWithFormat:@"6 months"];
}

#pragma mark - TableView Delegate and DataSource.

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SignUpTVCell *cell;
    if ( indexPath.row == 6)
    {
        TASIgnUpBtnCell  *btnCell = (TASIgnUpBtnCell *)[self.tableView dequeueReusableCellWithIdentifier: @"TASIgnUpBtnCell" forIndexPath:indexPath];
        btnCell.SixMonthBtnOutlet.tag = 0;
        btnCell.NineMonthBtnOutlet.tag = 1;
        [btnCell.SixMonthBtnOutlet addTarget:self action:@selector(sixMonthBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [btnCell.NineMonthBtnOutlet addTarget:self action:@selector(nineMonthBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        btnCell.SixMonthBtnOutlet.selected = objModel.sixMonth;
        btnCell.NineMonthBtnOutlet.selected = objModel.nineMonth;
        return btnCell;
    } else {
        cell = (SignUpTVCell *)[self.tableView dequeueReusableCellWithIdentifier: @"SignUpTVCell" forIndexPath:indexPath];
    }
    //// initial state setup
    cell.cellTextField.userInteractionEnabled = YES;
    cell.cellTextField.secureTextEntry = NO;
    cell.cellTextField.tag = indexPath.row+100;
    cell.cellTextField.delegate = self;
    cell.cellBtnOutlet.hidden = YES;
    cell.passwordImage.hidden = YES;
    cell.statusLabel.hidden = YES;
    
    //// showing Error message.
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
            if ([[userInfo appShareinstance].fromFacebook isEqualToString:@"yes"]) {
                cell.cellTextField.placeholder = @"";
            } else {
                cell.cellTextField.placeholder = @"Password";
                cell.cellImageView.image = [UIImage imageNamed:@"i_pass"];
                cell.cellTextField.returnKeyType = UIReturnKeyNext;
                cell.cellTextField.secureTextEntry = YES;
                cell.cellTextField.keyboardType = UIKeyboardTypeDefault;
                cell.cellTextField.text = objModel.password ;
            }
        }
            break;
        case 2: {
            if ([[userInfo appShareinstance].fromFacebook isEqualToString:@"yes"]) {
                cell.cellTextField.placeholder = @"";
            } else {
                cell.cellTextField.placeholder = @"Confirm Password";
                cell.cellImageView.image = [UIImage imageNamed:@"i_pass"];
                cell.cellTextField.returnKeyType = UIReturnKeyNext;
                cell.cellTextField.secureTextEntry = YES;
                cell.cellTextField.keyboardType = UIKeyboardTypeDefault;
                cell.cellTextField.text = objModel.confirmPassword ;
            }
        }
            break;
            
        case 3: {
            cell.cellTextField.placeholder = @"DOB";
            cell.cellTextField.userInteractionEnabled = NO;
            cell.cellImageView.image = [UIImage imageNamed:@"i_dob"];
            cell.cellBtnOutlet.hidden = NO;
            [cell.cellBtnOutlet addTarget:self action:@selector(pickButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            cell.cellTextField.text = objModel.dob;
        }
            break;
        case 4: {
            cell.cellTextField.placeholder = @"Address";
            cell.cellImageView.image = [UIImage imageNamed:@"i_loc"];
            cell.cellTextField.returnKeyType = UIReturnKeyNext;
            cell.cellTextField.keyboardType = UIKeyboardTypeDefault;
            cell.cellTextField.text = objModel.address ;
        }
            break;
        case 5: {
            cell.cellTextField.placeholder = @"Referral Code";
            cell.cellImageView.image = [UIImage imageNamed:@"i_ref"];
            cell.cellTextField.returnKeyType = UIReturnKeyDone;
            cell.cellTextField.keyboardType = UIKeyboardTypeDefault;
            cell.cellTextField.text = objModel.referralCode ;
        }
            break;
        default:
            break;
    }
    ////// Setting the attributed font.
    UIColor *color = [UIColor whiteColor];
    cell.cellTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:cell.cellTextField.placeholder attributes:@{NSForegroundColorAttributeName: color }];
    return cell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[userInfo appShareinstance].fromFacebook isEqualToString:@"yes"]) {
        if (indexPath.row == 1 || indexPath.row == 2) {
            return 0.0f;
        }
    }
    if (indexPath.row == 6){
        return 60.0f;
    }
    if (isValidError && indexPath.row == errroAtIndx) {
        return 71.0f;
    }else{
        return 60.0f;
    }
    
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
            objModel.email = TRIM_SPACE(textField.text);
        }
            break;
        case 101: {
            objModel.password = TRIM_SPACE(textField.text);
        }
            break;
        case 102: {
            objModel.confirmPassword = TRIM_SPACE(textField.text);
        }
            break;
        case 104: {
            objModel.address = textField.text;
        }
            break;
        case 105: {
            objModel.referralCode = TRIM_SPACE(textField.text);
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
    //////// phone no should have first value 0
    if(range.location == 0) {
        if ([string hasPrefix:@" "]) {
            return NO;
        }
    }
    ///// setting range of textfeilds.
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
        case 102: {
            if (range.length + range.location>textField.text.length) {
                return NO;
            }
            NSUInteger newLength=[textField.text length]+[string length]-range.length;
            return newLength<=25;
            
        }
            break;
        case 104: {
            if (range.length + range.location>textField.text.length) {
                return NO;
            }
            NSUInteger newLength=[textField.text length]+[string length]-range.length;
            return newLength<=256;
        }
            break;
            
        case 105: {
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

#pragma mark - Validations.

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
        
    }else if (![TRIM_SPACE(objModel.password) length]) {
        errroAtIndx = 1;
        strErrorMsg = AlertMessagePassword;
        
    } else if (!([TRIM_SPACE(objModel.password) length] > 5)) {
        errroAtIndx = 1;
        strErrorMsg = AlertMessagePasswordValidate;
    }
    else if (![TRIM_SPACE(objModel.confirmPassword) length]) {
        errroAtIndx = 2;
        strErrorMsg = AlertMessageConfirmPassword;
        
    } else if (![objModel.password isEqualToString:objModel.confirmPassword]){
        
        errroAtIndx = 2;
        strErrorMsg = AlertMessageNewAndConfirmSame;
    } else if (![(objModel.address) length]) {
        errroAtIndx = 4;
        strErrorMsg = AlertMessageAddress;
        
    } else if (self.checkBoxBtnOutlet.selected == NO){
        self.errorLabel.hidden = NO;
    }
    
    else {
        isVerified = YES;
        isValidError = NO;
        self.errorLabel.hidden = YES;
    }
    return isVerified;
}

-(BOOL)isAllFieldVerifiedSocial {
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
        
    } else if (![(objModel.address) length]) {
        errroAtIndx = 4;
        strErrorMsg = AlertMessageAddress;
        
    } else if (self.checkBoxBtnOutlet.selected == NO){
        self.errorLabel.hidden = NO;
    }
    
    else {
        isVerified = YES;
        isValidError = NO;
        self.errorLabel.hidden = YES;
    }
    return isVerified;
}



#pragma mark - Selector Method.

-(void)pickButtonAction:(UIButton *)sender {
    [self.view endEditing:YES];
    ////// Calling date Picker
    [DatePickerSheetView  showDatePickerWithDate:[NSDate date] AndTimeZone:nil datePickerType:UIDatePickerModeDate WithReturnDate:^(NSDate *date) {
        if (date) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"dd-MM-yyyy"];
            NSString *strDate = [dateFormatter stringFromDate:date];
            
            objModel.dob = [NSString stringWithFormat:@"%@",strDate];
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - Button Action.

- (IBAction)backBtnAction:(id)sender {
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)checkBoxBtnAction:(id)sender {
    [self.view endEditing:YES];
    self.checkBoxBtnOutlet.selected = !self.checkBoxBtnOutlet.selected;
}
- (IBAction)termsConditionBtnAction:(id)sender {
    [self.view endEditing:YES];
    TAAboutUsVC *myVC = [[TAAboutUsVC alloc] initWithNibName:@"TAAboutUsVC" bundle:nil];
    myVC.enumVariable = Terms_condition;
    myVC.isFrom = YES;
    myVC.months = self.terms;
    [self.navigationController pushViewController:myVC animated:YES];
}

-(void)sixMonthBtnAction:(UIButton *)sender {
    [self.view endEditing:YES];
    objModel.sixMonth = YES;
    objModel.nineMonth = NO;
    objModel.course_duration = [NSString stringWithFormat:@"6 months"];
    self.terms = @"6";
    [self.tableView reloadData];
}

-(void)nineMonthBtnAction:(UIButton *)sender {
    [self.view endEditing:YES];
    objModel.nineMonth = YES;
    objModel.sixMonth= NO;
    objModel.course_duration = [NSString stringWithFormat:@"9 months"];
    self.terms = @"9";
    [self.tableView reloadData];
}

- (IBAction)nextBtnAction:(id)sender {
    [self.view endEditing:YES];
    if (![[userInfo appShareinstance].fromFacebook isEqualToString:@"yes" ]) {
        if ([self isAllFieldVerified]) {
            CompleteProfile *myVC = [[CompleteProfile alloc] initWithNibName:@"CompleteProfile" bundle:nil];
            if (objModel.socialType == nil) {
            } else {
                myVC.fromFacebook = self.fromFacebook;
            }
            myVC.objSignUp = objModel;
            [self.navigationController pushViewController:myVC animated:YES];
        }
        [_tableView reloadData];
    } else {
        if ([self isAllFieldVerifiedSocial]) {
            CompleteProfile *myVC = [[CompleteProfile alloc] initWithNibName:@"CompleteProfile" bundle:nil];
            if (objModel.socialType == nil) {
            } else {
                myVC.fromFacebook = self.fromFacebook;
            }
            myVC.objSignUp = objModel;
            [self.navigationController pushViewController:myVC animated:YES];
        }
        [_tableView reloadData];
    }
    [_tableView reloadData];
}


#pragma mark - Memory Management.
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
