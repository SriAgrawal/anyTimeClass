//
//  SearchScreenVC.m
//  AnyTimeClass
//
//  Created by Aman Goswami on 18/01/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

#import "SearchScreenVC.h"
#import "Header.h"

@interface SearchScreenVC ()<CAAnimationDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate> {
    NSMutableArray *nameArray,*subjectIDArray;
    NSArray *results;
    BOOL isSearch;
}
@property (strong, nonatomic) IBOutlet UITextField *searchTextField;
@property (strong, nonatomic) NSString *search;
@property (strong, nonatomic) NSString *selectedString;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SearchScreenVC
#pragma mark - View Life Cycle.
- (void)viewDidLoad {
    [super viewDidLoad];
    ///// Array Initialzation
    nameArray = [[NSMutableArray alloc]init];
    subjectIDArray = [[NSMutableArray alloc]init];
    /////// cell register
    [self.tableView registerNib:[UINib nibWithNibName:@"SearchTVCell" bundle:nil] forCellReuseIdentifier:@"SearchTVCell"];
    ///// placeholder
    UIColor *color = [UIColor whiteColor];
    self.searchTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.searchTextField.placeholder attributes:@{NSForegroundColorAttributeName: color }];
    isSearch = NO;
    /////// Api Calling
    [self callApiForCourseList];
}
//////// Animation
-(void) AnimationFromTopToBottom {
    CATransition *animation = [CATransition animation];
    [animation setDelegate:self];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromBottom];
    [animation setDuration:0.65f];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [[self.navigationController.view layer] addAnimation:animation forKey:@"AnimationFromBottomToTop"];
}

#pragma mark - TableView Delegate and DataSource.

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (isSearch == YES ) {
        return results.count;
    } else {
        return nameArray.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchTVCell *cell = (SearchTVCell *)[self.tableView dequeueReusableCellWithIdentifier: @"SearchTVCell" forIndexPath:indexPath];
    if (isSearch == YES ) {
        cell.nameLabel.text = [results objectAtIndex:indexPath.row];
    } else {
        cell.nameLabel.text = [nameArray objectAtIndex:indexPath.row];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CourseDetailsVC *myVC = [[CourseDetailsVC alloc] initWithNibName:@"CourseDetailsVC" bundle:nil];
    if (indexPath.row == 0) {
        myVC.isbuy = YES;
    } else {
        myVC.isbuy = NO;
    }
    myVC.fromSearch = YES;
    myVC.subjectID = [subjectIDArray objectAtIndex:indexPath.item];
    [self.navigationController pushViewController:myVC animated:YES];
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
}

#pragma mark- Text Field Delegate Method

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.returnKeyType == UIReturnKeySearch) {
        [self isAllFieldVerified];
    }
    if (_searchTextField.text.length) {
        isSearch = NO;
    }else{
        isSearch = YES;
    }
    [textField resignFirstResponder];
    return YES;
}


-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

-(void) textFieldDidBeginEditing:(UITextField *)textField {
    //   isSearch = YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    isSearch = YES;
    
    if(range.location == 0) {
        if ([string hasPrefix:@" "]) {
            
            return NO;
        } else {
            [self onTextChange:string];
        }
    } else if (isSearch == YES) {
        [self onTextChange:string];
    }
    if (range.length + range.location>textField.text.length) {
        return NO;
    }
    NSUInteger newLength=[textField.text length]+[string length]-range.length;
    return newLength<=80;
    
}


- (void)onTextChange :(NSString *)searchText{
    NSString *str;
    if ([searchText isEqualToString:@""] && [self.searchTextField.text length] <2) {
        str = searchText;
    } else {
        str = [self.searchTextField.text stringByAppendingString:searchText];
    }
    isSearch = YES;
    results  = [NSArray array];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c]%@",str];
    results = [nameArray filteredArrayUsingPredicate:predicate];
    if (results.count) {
        self.tableView.hidden = NO ;
        [self.tableView reloadData];
    } else if ([str isEqualToString:@""]) {
        isSearch = NO;
        self.tableView.hidden = NO ;
        [self.tableView reloadData];
    } else {
        self.tableView.hidden = YES ;
    }
}

#pragma mark - validations.

-(BOOL)isAllFieldVerified {
    [self.view endEditing:YES];
    BOOL isVerified = NO;
    if (![(self.searchTextField.text) length]) {
        [self.view endEditing:YES];
        [[AlertView sharedManager] presentAlertWithTitle:@"" message:@"Please enter text to search." andButtonsWithTitle:@[@"Ok"] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
        }];
    }  else {
        isVerified = YES;
    }
    return isVerified;
}

#pragma mark - Button Action.
- (IBAction)crossBtnAction:(id)sender {
    [self.view endEditing:YES];
    [self AnimationFromTopToBottom];
    [self.navigationController popViewControllerAnimated:YES];
    
}


#pragma mark - WebService.
-(void) callApiForCourseList {
    NSMutableDictionary *user_dict = [NSMutableDictionary dictionary];
    
    [user_dict setValue:[NSUSERDEFAULTS valueForKey:kuid] forKey:kuid];
    [user_dict setValue:self.subjectName forKey:@"course_id"];
    [user_dict setValue:@"" forKey:@"group"];
    [user_dict setValue:@"" forKey:@"sort"];
    [user_dict setValue:@"" forKey:@"filter"];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:user_dict AndPath:ksubject_list WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        if (suceeded) {
            
            NSString *responseCode = [response objectForKeyNotNull:kresponseCode expectedClass:[NSString class]];
            NSString *responseMessage = [response objectForKeyNotNull:kresponseMessage expectedClass:[NSString class]];
            
            if (responseCode.integerValue == KSuccessCode) {
                [nameArray removeAllObjects];
                NSDictionary *subjectListArray = [response objectForKeyNotNull:@"subjectList" expectedClass:[NSArray class]];
                for (NSDictionary  *subjectDict in subjectListArray) {
                    
                    [nameArray addObject :[[CoursesInfo parseSubjectList:subjectDict] subjectName] ];
                    [subjectIDArray addObject :[[CoursesInfo parseSubjectList:subjectDict] subjectID] ];
                    
                }
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

#pragma mark - Memory Management.
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
