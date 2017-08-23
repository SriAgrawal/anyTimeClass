//
//  CAFinalsVC.m
//  AnyTimeClass
//
//  Created by Aman Goswami on 17/01/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

#import "CAFinalsVC.h"
#import "Header.h"

@interface CAFinalsVC ()<CAAnimationDelegate>{
    NSMutableArray *subjectIDArray,*subjectArray;
}
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UILabel *headerTextLabel;
@end

@implementation CAFinalsVC
#pragma mark - View Life Cycle.
- (void)viewDidLoad {
    [super viewDidLoad];
    ///// Cell register.
    [self.collectionView registerNib:[UINib nibWithNibName:@"CACVCell" bundle:nil] forCellWithReuseIdentifier:@"CACVCell"];
    //// Array initialzation.
    subjectIDArray = [[NSMutableArray alloc]init];
    subjectArray = [[NSMutableArray alloc]init];
    self.headerTextLabel.text = self.headerText;
    ///// Api Calling
    [self callApiForCourseList];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - Memory management.
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -  Animation.
-(void) AnimationFromBottomToTop {
    CATransition *animation = [CATransition animation];
    [animation setDelegate:self];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromTop];
    [animation setDuration:0.65f];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [[self.navigationController.view layer] addAnimation:animation forKey:@"AnimationFromBottomToTop"];
}
-(void) AnimationFromTopToBottom {
    CATransition *animation = [CATransition animation];
    [animation setDelegate:self];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromBottom];
    [animation setDuration:0.65f];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [[self.navigationController.view layer] addAnimation:animation forKey:@"AnimationFromBottomToTop"];
}


#pragma  mark - collectionView Delgate and DataSource.

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return subjectArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CACVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CACVCell" forIndexPath:indexPath];
    CoursesInfo *info = [subjectArray objectAtIndex:indexPath.row];
    [cell.backImageView sd_setImageWithURL:[NSURL URLWithString:info.subjectImage] placeholderImage:[UIImage imageNamed:@"img1"]];
    cell.subjectLabel.text = info.subjectName;
    if (![info.subjectMarks isEqualToString:@""]) {
        cell.marksLabel.text = [NSString stringWithFormat:@"%@ marks", info.subjectMarks];
    } else {
        cell.marksLabel.text = @"";
    }
    if ([info.subjectPrice isEqualToString:@"Free"] ||[info.subjectPrice isEqualToString:@"Demo"]) {
        cell.amountLabel.text = info.subjectPrice;
    } else if ([info.subjectPrice isEqualToString:@""]) {
        cell.amountLabel.text = [NSString stringWithFormat:@"₹ 0"];
    } else {
        cell.amountLabel.text = [NSString stringWithFormat:@"₹ %@", info.subjectPrice ];
    }
    [subjectIDArray addObject:info.subjectID];
    return cell;
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(collectionView.frame.size.width/2.02, 170);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CourseDetailsVC *myVC = [[CourseDetailsVC alloc] initWithNibName:@"CourseDetailsVC" bundle:nil];
    if (indexPath.row == 0) {
        myVC.isbuy = YES;
    } else {
        myVC.isbuy = NO;
    }
    
    myVC.fromSearch = NO;
    myVC.subjectID = [subjectIDArray objectAtIndex:indexPath.item];
    [self.navigationController pushViewController:myVC animated:YES];
}


#pragma mark - Button Action.
- (IBAction)sortBtnAction:(id)sender {
    [self.view endEditing:YES];
    [self AnimationFromBottomToTop];
    SortVC *customAlertVC = [[SortVC alloc] initWithNibName:@"SortVC" bundle:nil];
    [self.navigationController pushViewController:customAlertVC animated:YES];
}

- (IBAction)filterBtnAction:(id)sender {
    [self.view endEditing:YES];
    [self AnimationFromBottomToTop];
    FilterVC *customAlertVC = [[FilterVC alloc] initWithNibName:@"FilterVC" bundle:nil];
    [self.navigationController pushViewController:customAlertVC animated:YES];
}
- (IBAction)crossBtnAction:(id)sender {
    [self.view endEditing:YES];
    [self AnimationFromTopToBottom];
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)searchBtnAction:(id)sender {
    [self.view endEditing:YES];
    SearchScreenVC *customAlertVC = [[SearchScreenVC alloc] initWithNibName:@"SearchScreenVC" bundle:nil];
    customAlertVC.subjectName = self.course_id;
    [self.navigationController pushViewController:customAlertVC animated:YES];
}

#pragma mark - WebService.
-(void) callApiForCourseList {
    NSMutableDictionary *user_dict = [NSMutableDictionary dictionary];
    
    [user_dict setValue:[NSUSERDEFAULTS valueForKey:kuid] forKey:kuid];
    [user_dict setValue:self.course_id forKey:@"course_id"];
    [user_dict setValue:@"" forKey:@"group"];
    [user_dict setValue:@"" forKey:@"sort"];
    [user_dict setValue:@"" forKey:@"filter"];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:user_dict AndPath:ksubject_list WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        if (suceeded) {
            
            NSString *responseCode = [response objectForKeyNotNull:kresponseCode expectedClass:[NSString class]];
            NSString *responseMessage = [response objectForKeyNotNull:kresponseMessage expectedClass:[NSString class]];
            
            if (responseCode.integerValue == KSuccessCode) {
                [subjectArray removeAllObjects];
                NSDictionary *subjectListArray = [response objectForKeyNotNull:@"subjectList" expectedClass:[NSArray class]];
                for (NSDictionary  *subjectDict in subjectListArray) {
                    [subjectArray addObject :[CoursesInfo parseSubjectList:subjectDict]];
                }
                [self.collectionView reloadData];
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
