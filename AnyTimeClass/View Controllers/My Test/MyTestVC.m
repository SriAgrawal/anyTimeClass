//
//  MyTestVC.m
//  AnyTimeClass
//
//  Created by Aman Goswami on 17/01/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

#import "MyTestVC.h"
#import "Header.h"

@interface MyTestVC ()<CAAnimationDelegate,UITableViewDelegate,UITableViewDataSource>{
    NSMutableArray  *statusArray,*subjectArray,*testIDArray;
    NSArray *results;
    BOOL isSearch;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *searchView;
@property (strong, nonatomic) IBOutlet UITextField *searchTextField;

@end

@implementation MyTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    /////// cell register
    [self.tableView registerNib:[UINib nibWithNibName:@"MyVideosTVCell" bundle:nil] forCellReuseIdentifier:@"MyVideosTVCell"];
    ///// Array Initiazation.
    testIDArray = [[NSMutableArray alloc] init];
    subjectArray = [[NSMutableArray alloc]init];
    ///// placeholder
    UIColor *color = [UIColor whiteColor];
    self.searchTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.searchTextField.placeholder attributes:@{NSForegroundColorAttributeName: color }];
    isSearch = NO;
    /////// Api Calling
    self.searchView.hidden = YES;
    [self callApiForTestList];
}

#pragma Mark - Animation.
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
    if (isSearch == YES ) {
        return results.count;
    } else {
        return subjectArray.count;
    }

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyVideosTVCell *cell = (MyVideosTVCell *)[self.tableView dequeueReusableCellWithIdentifier: @"MyVideosTVCell" forIndexPath:indexPath];
    cell.playerImageView.hidden = YES;
    CoursesInfo *info = [isSearch ? results : subjectArray objectAtIndex:indexPath.row];
        [cell.titleImageView sd_setImageWithURL:[NSURL URLWithString:info.subjectImage] placeholderImage:[UIImage imageNamed:@"img1"]];
        cell.subjectLabel.text = info.testName;
       cell.typeLabel.text = info.subjectName;
        [testIDArray addObject:info.testID];
        if ([info.subjectPriceStatus isEqualToString:@"Free"]) {
            cell.statusImageView.image = [UIImage imageNamed:@"Free"];
        } else {
            cell.statusImageView.image = [UIImage imageNamed:@"Paid"];
        }
    return cell;
}


-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MyTestDetailsVC *myVC = [[MyTestDetailsVC alloc] initWithNibName:@"MyTestDetailsVC" bundle:nil];
    myVC.testID = [testIDArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:myVC animated:YES];
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
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"videoName beginswith[c] %@",str];
    results = [subjectArray filteredArrayUsingPredicate:predicate];
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
- (IBAction)searchBtnAction:(id)sender {
    [self.view endEditing:YES];
    SearchScreenVC *customAlertVC = [[SearchScreenVC alloc] initWithNibName:@"SearchScreenVC" bundle:nil];
    [self.navigationController pushViewController:customAlertVC animated:YES];
}

- (IBAction)menuBtnAction:(id)sender {
    [self.view endEditing:YES];
    [self AnimationFromBottomToTop];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)crossBtnAction:(id)sender {
    [self.view endEditing:YES];
    self.searchView.hidden = YES;
    isSearch = NO;
    [self.tableView reloadData];
}

#pragma mark - WebService.

-(void) callApiForTestList {
    NSMutableDictionary *user_dict = [NSMutableDictionary dictionary];
    
    [user_dict setValue:[NSUSERDEFAULTS valueForKey:kuid] forKey:kuid];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:user_dict AndPath:kmyTestSeries WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        if (suceeded) {
            NSString *responseCode = [response objectForKeyNotNull:kresponseCode expectedClass:[NSString class]];
            NSString *responseMessage = [response objectForKeyNotNull:kresponseMessage expectedClass:[NSString class]];
            
            if (responseCode.integerValue == KSuccessCode) {
                [subjectArray removeAllObjects];
                NSDictionary *subjectListArray = [response objectForKeyNotNull:@"subjectList" expectedClass:[NSArray class]];
                for (NSDictionary  *subjectDict in subjectListArray) {
                    [subjectArray addObject :[CoursesInfo parseTestsList:subjectDict]];
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



@end
