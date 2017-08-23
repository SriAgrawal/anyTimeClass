//
//  PurchaseHistoryVC.m
//  AnyTimeClass
//
//  Created by Aman Goswami on 06/02/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

#import "PurchaseHistoryVC.h"
#import "Header.h"

@interface PurchaseHistoryVC ()<CAAnimationDelegate>{
    NSMutableArray *purchaseArray,*purchaseIDArray, *orderId;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation PurchaseHistoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    /////// cell register
    [self.tableView registerNib:[UINib nibWithNibName:@"PurchaseHistoryTVCell" bundle:nil] forCellReuseIdentifier:@"PurchaseHistoryTVCell"];
    ////// Array initialization.
    purchaseArray = [[NSMutableArray alloc] init];
    purchaseIDArray = [[NSMutableArray alloc] init];
    orderId = [[NSMutableArray alloc] init];
    ////// Api Calling.
    [self callApiForPurchaseHistory];
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
    return purchaseArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PurchaseHistoryTVCell *cell = (PurchaseHistoryTVCell *)[self.tableView dequeueReusableCellWithIdentifier: @"PurchaseHistoryTVCell" forIndexPath:indexPath];
    CoursesInfo *info  = [purchaseArray objectAtIndex:indexPath.row];
    cell.orderIdLabel.text = info.orderId;
    if ([info.price isEqualToString:@"Free"]) {
       cell.AmountLabel.text = info.price;
    } else if ([info.subjectPrice isEqualToString:@""]) {
         cell.AmountLabel.text = [NSString stringWithFormat:@"₹ 0"];
    } else {
         cell.AmountLabel.text = [NSString stringWithFormat:@"₹ %@", info.price ];
    }
      [purchaseIDArray addObject:info.purchaseId];
      [orderId addObject:info.orderId];
    NSString * timeStampString =info.created  ;
    NSTimeInterval _interval=[timeStampString doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *_formatter=[[NSDateFormatter alloc]init];
    [_formatter setDateFormat:@"dd/MM/yy"];
    cell.dateLabel.text = [_formatter stringFromDate:date];
    return cell;
}


-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0f;
}

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //// deletion selected cell.
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"          "  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        [[AlertView sharedManager] presentAlertWithTitle:@"" message:@"Are you sure you want to delete?"
                                     andButtonsWithTitle:@[@"Yes",@"No"] onController:self
                                           dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                                               if (index == 0) {
                                                   //CoursesInfo *info = [purchaseIDArray objectAtIndex:indexPath.row];
                                                   [self callApiForDeletePurchase:[purchaseIDArray objectAtIndex:indexPath.row]];
                                                   
                                               }
                                           }];
    }];
    UIImageView *img2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"del"]];
    img2.frame = CGRectMake(cell.frame.size.width, 25, 80, 30);
    img2.contentMode = UIViewContentModeScaleAspectFit;
    [cell.contentView addSubview:img2];
    deleteAction.backgroundColor = [UIColor colorWithRed:212.0f/255.0f green:31.0f/255.0f blue:31.0f/255.0f alpha:1.0];
    
    return @[deleteAction];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PurchaseHistoryDetailsVC *myVC = [[PurchaseHistoryDetailsVC alloc] initWithNibName:@"PurchaseHistoryDetailsVC" bundle:nil];
    myVC.orderId = [orderId objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:myVC animated:YES];
}


#pragma mark - Button Action.
- (IBAction)menuBtnAction:(id)sender {
    [self.view endEditing:YES];
    [self AnimationFromBottomToTop];
    NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
    for (UIViewController *aViewController in allViewControllers) {
        if ([aViewController isKindOfClass:[SidePannelVC class]]) {
            [self.navigationController popToViewController:aViewController animated:NO];
        }
    }
}

#pragma mark - WebService.
-(void) callApiForPurchaseHistory {
    NSMutableDictionary *user_dict = [NSMutableDictionary dictionary];
    [user_dict setValue:[NSUSERDEFAULTS valueForKey:kuid] forKey:kuid];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:user_dict AndPath:@"purchase_history" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        if (suceeded) {
            NSString *responseCode = [response objectForKeyNotNull:kresponseCode expectedClass:[NSString class]];
            NSString *responseMessage = [response objectForKeyNotNull:kresponseMessage expectedClass:[NSString class]];
            if (responseCode.integerValue == KSuccessCode) {
                
                [purchaseArray removeAllObjects];
                NSDictionary *subjectListArray = [response objectForKeyNotNull:@"orderList" expectedClass:[NSArray class]];
                for (NSDictionary  *subjectDict in subjectListArray) {
                    [purchaseArray addObject :[CoursesInfo parsePurchaseList:subjectDict]];
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


-(void) callApiForDeletePurchase : (NSString *) user {
    NSMutableDictionary *user_dict = [NSMutableDictionary dictionary];
    [user_dict setValue:[NSUSERDEFAULTS valueForKey:kuid] forKey:kuid];
    [user_dict setValue:user forKey:@"purchaseId"];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:user_dict AndPath:@"purchase_history" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        if (suceeded) {
            NSString *responseCode = [response objectForKeyNotNull:kresponseCode expectedClass:[NSString class]];
            NSString *responseMessage = [response objectForKeyNotNull:kresponseMessage expectedClass:[NSString class]];
            if (responseCode.integerValue == KSuccessCode) {
                
                
                for (CoursesInfo *obj in purchaseArray) {
                    if ([obj.purchaseId isEqualToString:user]) {
                        [purchaseArray removeObject:obj];
                    }
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
