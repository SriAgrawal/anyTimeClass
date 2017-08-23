//
//  AskQuestionVC.m
//  AnyTimeClass
//
//  Created by Aman Goswami on 18/01/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

#import "AskQuestionVC.h"
#import "Header.h"

@interface AskQuestionVC ()<UITextFieldDelegate,VSDropdownDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDelegate>{
    CoursesInfo  *objModel;
    NSInteger errroAtIndx;
    BOOL isValidError,courseType;
    NSString *strErrorMsg;
    NSMutableArray *subjectArray,*subjectID,*courseArray;
}
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (strong, nonatomic) NSString *courseID;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) VSDropdown *dropdown;

@end

@implementation AskQuestionVC
#pragma mark - View Life Cycle.
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetup];
}

#pragma mark -  Helper Method.
-(void) initialSetup {
    ////// cell register
    [self.tableView registerNib:[UINib nibWithNibName:@"ChangePasswordTVCell" bundle:nil] forCellReuseIdentifier:@"ChangePasswordTVCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"textViewTVCell" bundle:nil] forCellReuseIdentifier:@"textViewTVCell"];
    //// Setting header and footer
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = self.footerView;
    /////// VS Dropdown Setup
    _dropdown = [[VSDropdown alloc]initWithDelegate:self];
    [_dropdown setAdoptParentTheme:YES];
    [_dropdown setShouldSortItems:YES];
    
    /////////Array
    courseArray = [[NSMutableArray alloc] initWithObjects:@"CA-CPT",@"CA-IPC Group 2",@"CA-FINAL Group 1",@"CA-IPC Group 1",@"CA-FINAL Group 2", nil];
    subjectArray = [[NSMutableArray alloc] init];
    subjectID = [[NSMutableArray alloc] init];
    ////// Object initialization.
    objModel = [[CoursesInfo alloc] init];
    objModel.questionAsk = @"Write your question here";
}

#pragma mark - TableView Delegate and DataSource.

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ChangePasswordTVCell *cell;
    cell.cellTextField.textColor = [UIColor blackColor];
    if (indexPath.row == 2) {
        textViewTVCell *cell1 = (textViewTVCell *)[self.tableView dequeueReusableCellWithIdentifier: @"textViewTVCell" forIndexPath:indexPath];
        /////// showing the error message
        if (isValidError && indexPath.row == errroAtIndx) {
            [cell1.errorLabel setText:strErrorMsg];
            cell1.underLabel.backgroundColor = [UIColor colorWithRed:212.0f/255.0f green:32.0f/255.0f blue:31.0f/255.0f alpha:1.0];
        }else{
            [cell1.errorLabel setText:nil];
            cell1.underLabel.backgroundColor = [UIColor colorWithRed:227.0f/255.0f green:227.0f/255.0f blue:227.0f/255.0f alpha:1.0];
        }
        cell1.cellTextView.delegate = self;
        cell1.cellTextView.returnKeyType = UIReturnKeyDone;
        cell1.cellTextView.keyboardType = UIKeyboardTypeDefault;
        cell1.cellTextView.text = objModel.questionAsk ;
        return cell1 ;
    } else {
        cell = (ChangePasswordTVCell *)[self.tableView dequeueReusableCellWithIdentifier: @"ChangePasswordTVCell" forIndexPath:indexPath];
        cell.cellTextField.userInteractionEnabled = NO;
        cell.cellButton.tag = indexPath.row+100;
        cell.cellButton.hidden = NO;
        cell.cellTextField.delegate = self;
        
    }
    /////// showing the error message
    if (isValidError && indexPath.row == errroAtIndx) {
        [cell.errorLabel setText:strErrorMsg];
        cell.underLabel.backgroundColor = [UIColor colorWithRed:212.0f/255.0f green:32.0f/255.0f blue:31.0f/255.0f alpha:1.0];
    }else{
        [cell.errorLabel setText:nil];
        cell.underLabel.backgroundColor = [UIColor colorWithRed:227.0f/255.0f green:227.0f/255.0f blue:227.0f/255.0f alpha:1.0];
    }
    switch (indexPath.row) {
        case 0:{
            cell.cellTextField.placeholder = @"Course Type";
            cell.cellTextField.text = objModel.courseType;
            [cell.cellButton addTarget:self action:@selector(courseTypeList:) forControlEvents:UIControlEventTouchUpInside];
        }
            break;
        case 1: {
            cell.cellTextField.placeholder = @"Select Subject";
            cell.cellTextField.text = objModel.selectSubject ;
            [cell.cellButton addTarget:self action:@selector(selectSubjectList:) forControlEvents:UIControlEventTouchUpInside];
        }
            break;
        case 3: {
            cell.cellTextField.placeholder = @"Upload image & file";
            [cell.cellButton setImage:[UIImage imageNamed:@"ic_attach"] forState:UIControlStateNormal];
            [cell.cellButton addTarget:self action:@selector(uploadImageAction:) forControlEvents:UIControlEventTouchUpInside];
            cell.cellTextField.textColor = [UIColor greenColor];
            cell.cellTextField.text = objModel.ImageStatus ;
        }
            break;
            
        default:
            break;
    }
    /////// Attributed placeholder
    UIColor *color = [UIColor darkGrayColor];
    cell.cellTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:cell.cellTextField.placeholder attributes:@{NSForegroundColorAttributeName: color }];
    return cell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ///// setting height according to error
    if (isValidError && indexPath.row == errroAtIndx) {
        if (indexPath.row == 2) {
            return 120.0f;
        } else {
            return 70.0f;
        }
    }else{
        if (indexPath.row == 2) {
            return 110.0f;
        } else {
            return 60.0f;
        }
    }
}

#pragma mark- Text View Delegate Method

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark - textview Delegate.
- (BOOL) textViewShouldBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@"Write your question here" ]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    return YES;
}

-(void) textViewDidChange:(UITextView *)textView {
    if(textView.text.length == 0){
        textView.textColor = [UIColor blackColor];
        textView.text = @"Write your question here";
        [textView resignFirstResponder];
    }
}

-(void) textViewDidEndEditing:(UITextView *)textView {
    if(textView.text.length == 0){
        textView.textColor = [UIColor darkGrayColor];
        textView.text = @"Write your question here";
        [textView resignFirstResponder];
    } else {
        objModel.questionAsk = textView.text;
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    //// Stopping Space at start.
    if(range.location == 0) {
        if ([text hasPrefix:@" "]) {
            return NO;
        }
    }
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return (textView.text.length >= 250 && range.length == 0) ? NO : YES; // return NO to not change
}

#pragma mark - Validations.

-(BOOL)isAllFieldVerified {
    [self.view endEditing:YES];
    BOOL isVerified = NO;
    isValidError = YES;
    errroAtIndx = 200;
    strErrorMsg = nil;
    if (![TRIM_SPACE(objModel.courseType) length]) {
        errroAtIndx = 0;
        strErrorMsg = @"*Please select the course type.";
        
    }   else if (![TRIM_SPACE(objModel.selectSubject) length]) {
        errroAtIndx = 1;
        strErrorMsg = @"*Please select the subject.";
        
    } else if (![TRIM_SPACE(objModel.questionAsk) length]) {
        errroAtIndx = 2;
        strErrorMsg = @"*Please write your question.";
        
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
    objModel.ImageStatus  =@"Uploaded";
    
    objModel.UploadImage = imageToNSString(image);
    [self.tableView reloadData];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - VSDropdown Delegate methods.
- (void)dropdown:(VSDropdown *)dropDown didChangeSelectionForValue:(NSString *)str atIndex:(NSUInteger)index selected:(BOOL)selected {
    NSString *allSelectedItems = nil;
    if (dropDown.selectedItems.count > 1) {
        allSelectedItems = [dropDown.selectedItems componentsJoinedByString:@";"];
    } else {
        allSelectedItems = [dropDown.selectedItems firstObject];
    }
    if (courseType == YES) {
        objModel.courseType = allSelectedItems;
        self.courseID = [NSString stringWithFormat:@"%lu" ,(unsigned long)index + 1];
        [self callApiForCourseList];
    } else {
        objModel.selectSubject = allSelectedItems;
        objModel.subjectID = [subjectID objectAtIndex:index];
    }
    [self.tableView reloadData];
}

- (UIColor *)outlineColorForDropdown:(VSDropdown *)dropdown {
    UIButton *btn = (UIButton *)dropdown.dropDownView;
    return btn.titleLabel.textColor;
}

- (CGFloat)outlineWidthForDropdown:(VSDropdown *)dropdown {
    return 2.0;
}

- (CGFloat)cornerRadiusForDropdown:(VSDropdown *)dropdown {
    return 3.0;
}

- (CGFloat)offsetForDropdown:(VSDropdown *)dropdown {
    return -2.0;
}

-(void)showDropDownForButton:(UIButton *)sender adContents:(NSArray *)contents multipleSelection:(BOOL)multipleSelection {
    [_dropdown setDrodownAnimation:rand()%2];
    [_dropdown setAllowMultipleSelection:multipleSelection];
    [_dropdown setupDropdownForView:sender];
    [_dropdown setBorderColor:[UIColor lightGrayColor]];
    [_dropdown setSeparatorColor:[UIColor lightGrayColor]];
    [_dropdown reloadDropdownWithContents:contents andSelectedItems:[NSArray array]];
}

#pragma mark - Button Action.
- (IBAction)courseTypeList:(UIButton *)sender {
    [self.view endEditing:YES];
    courseType  = YES;
    [self showDropDownForButton:sender adContents:courseArray multipleSelection:NO];
}

- (IBAction)selectSubjectList:(UIButton *)sender {
    [self.view endEditing:YES];
    courseType  = NO;
    [self showDropDownForButton:sender adContents:subjectArray multipleSelection:NO];
}

- (IBAction)uploadImageAction:(UIButton *)sender {
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

- (IBAction)submitBtnAction:(id)sender {
    [self.view endEditing:YES];
    if ([self isAllFieldVerified]) {
        [self callApiForAskQuestion];
    }
    [self.tableView reloadData];
}

#pragma mark - Webservice.

-(void) callApiForAskQuestion {
    NSMutableDictionary *user_dict = [NSMutableDictionary dictionary];
    [user_dict setValue:[NSUSERDEFAULTS valueForKey:kuid] forKey:kuid];
    [user_dict setValue:self.courseID forKey:@"course_id"];
    [user_dict setValue:objModel.subjectID forKey:ksubjectID];
    [user_dict setValue:objModel.questionAsk forKey:@"question"];
    [user_dict setValue:objModel.UploadImage forKey:@"attach_file"];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:user_dict AndPath:kask_question WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        if (suceeded) {
            
            NSString *responseCode = [response objectForKeyNotNull:kresponseCode expectedClass:[NSString class]];
            NSString *responseMessage = [response objectForKeyNotNull:kresponseMessage expectedClass:[NSString class]];
            
            if (responseCode.integerValue == KSuccessCode) {
                [[AlertView sharedManager] presentAlertWithTitle:@"Congratulations!" message:@"Your question is submitted successfully!!" andButtonsWithTitle:@[@"Ok"] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                    objModel = [[CoursesInfo alloc]init];
                    objModel.questionAsk = @"Write your question here";
                    [self.tableView reloadData];
                }];

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

-(void) callApiForCourseList {
    NSMutableDictionary *user_dict = [NSMutableDictionary dictionary];
    
    [user_dict setValue:[NSUSERDEFAULTS valueForKey:kuid] forKey:kuid];
    [user_dict setValue:self.courseID forKey:@"course_id"];
    [user_dict setValue:@"" forKey:@"group"];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:user_dict AndPath:ksubject_list WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        if (suceeded) {
            
            NSString *responseCode = [response objectForKeyNotNull:kresponseCode expectedClass:[NSString class]];
            NSString *responseMessage = [response objectForKeyNotNull:kresponseMessage expectedClass:[NSString class]];
            
            if (responseCode.integerValue == KSuccessCode) {
                [subjectArray removeAllObjects];
                NSDictionary *subjectListArray = [response objectForKeyNotNull:@"subjectList" expectedClass:[NSArray class]];
                
                for (NSDictionary  *subjectDict in subjectListArray) {
                    [subjectArray addObject:[[CoursesInfo parseSubjectList:subjectDict] subjectName]];
                    [subjectID addObject:[[CoursesInfo parseSubjectList:subjectDict] subjectID]];
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

#pragma mark - Memory Management.
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
