//
//  ForgotPasswordVC.m
//  AnyTimeClass
//
//  Created by Aman Goswami on 14/01/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

#import "ForgotPasswordVC.h"
#import "Header.h"

@interface ForgotPasswordVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate> {
    userInfo *objModel;
    NSInteger errroAtIndx;
    BOOL isValidError;
    NSString *strErrorMsg;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *footerView;

@end

@implementation ForgotPasswordVC
#pragma mark  -View life Cycle.
- (void)viewDidLoad {
    [super viewDidLoad];
    ///// calling the helper method.
    [self initialSetup];
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
    cell.cellTextField.delegate = self;
    cell.cellBtnOutlet.hidden = YES;
    cell.cellBtnOutlet.hidden = YES;
    cell.passwordImage.hidden = YES;
    ///// error show or hide.
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
            objModel.email = TRIM_SPACE(textField.text);
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
            return newLength<=80;
        }
            break;
        default:
            break;
    }
    return YES;
}

#pragma mark - validation.

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
        
    }  else {
        isVerified = YES;
        isValidError = NO;
    }
    return isVerified;
}

#pragma mark - Button Action.
- (IBAction)backBtnAction:(id)sender {
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)submitBtnAction:(id)sender {
    [self.view endEditing:YES];
    if ([self isAllFieldVerified]) {
        [self callApiToForgotPassword];
    }
    [self.tableView reloadData];
}


#pragma mark - Web Api Call Methods
-(void)callApiToForgotPassword {
    
    NSMutableDictionary *user_dict  = [NSMutableDictionary dictionary];
    [user_dict setValue:objModel.email forKey:kemailID];
    [self.view setUserInteractionEnabled:YES];
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:user_dict AndPath:kForgotPassword WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        if (suceeded ) {
            
            NSString *responseCode = [response objectForKeyNotNull:kresponseCode expectedClass:[NSString class]];
            NSString *responseMessage = [response objectForKeyNotNull:kresponseMessage expectedClass:[NSString class]];
            
            if (responseCode.integerValue == KSuccessCode) {
                [[AlertView sharedManager] presentAlertWithTitle:@"" message:responseMessage andButtonsWithTitle:@[@"Ok"] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }else{
                
                [[AlertView sharedManager] displayInformativeAlertwithTitle:@"Error!" andMessage:responseMessage onController:self];
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


#pragma mark - Memory Management.
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
