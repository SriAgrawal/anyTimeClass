//
//  TestVideosListVC.m
//  AnyTimeClass
//
//  Created by Aman Goswami on 03/02/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

#import "TestVideosListVC.h"
#import "Header.h"
#import <PayUmoney_SDK/PayUmoney_SDK.h>
#import <CommonCrypto/CommonDigest.h>


@interface TestVideosListVC ()<CAAnimationDelegate,SortVCDelegate>{
    NSMutableArray *itemArray,*subjectArray,*videoArray,*testArray;
    NSArray *labelArray;
}
@property (strong, nonatomic) PUMRequestParams *params;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *totalAmountLabel;
@property (assign, nonatomic) int total;
@property (strong, nonatomic) NSString *orderId;


@end

@implementation TestVideosListVC
#pragma mark - View Life Cycle.
- (void)viewDidLoad {
    [super viewDidLoad];
    ////// cell register
    [self.tableView registerNib:[UINib nibWithNibName:@"TestVideosListTVCell" bundle:nil] forCellReuseIdentifier:@"TestVideosListTVCell"];
    ////// Array initilization
    itemArray = [NSMutableArray new];
    subjectArray = [[NSMutableArray alloc] init];
    videoArray = [[NSMutableArray alloc] init];
    testArray = [[NSMutableArray alloc] init];
    self.params.delegate = self;
     ////// Total Amount.
    self.total = 00.00;
    self.totalAmountLabel.text = [NSString stringWithFormat:@"₹ %d.00",  self.total];
    //////// Api Calling.
    [self callApiForVdeos];
}

//- (void)setPaymentParameters {
//    self.params = [PUMRequestParams sharedParams];
//    self.params.environment = PUMEnvironmentProduction;
//    self.params.amount = @"200";
//    self.params.key = @"SD8RiOL0";
//    self.params.merchantid = @"5750685";
//    self.params.txnid = [self  getRandomString:2];
//    self.params.surl = @"https://www.payumoney.com/mobileapp/payumoney/success.php";
//    self.params.furl = @"https://www.payumoney.com/mobileapp/payumoney/failure.php";
//    self.params.delegate = self;
//    self.params.firstname = @"Aman";
//    self.params.productinfo = @"abc";
//    self.params.email = @"aman@gmail.com";
//    self.params.phone = @"";
//    
//    //Below parameters are optional. It is to store any information you would like to save in PayU Database regarding trasnsaction. If you do not intend to store any additional info, set below params as empty strings.
//    
//    self.params.udf1 = @"";
//    self.params.udf2 = @"";
//    self.params.udf3 = @"";
//    self.params.udf4 = @"";
//    self.params.udf5 = @"";
//    self.params.udf6 = @"";
//    self.params.udf7 = @"";
//    self.params.udf8 = @"";
//    self.params.udf9 = @"";
//    self.params.udf10 = @"";
//    [self getHashValue];
//    
//}
//
//
//
//-(void) getHashValue {
//    
//    NSMutableDictionary *user_dict = [NSMutableDictionary dictionary];
//    
//    [user_dict setValue:[NSUSERDEFAULTS valueForKey:kuid] forKey:kuid];
//    NSString *hashSequence = [NSString stringWithFormat:@"SD8RiOL0|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|HcB5J8l9pa",self.params.txnid, self.params.amount, self.params.productinfo,self.params.firstname, self.params.email,self.params.udf1,self.params.udf2,self.params.udf3,self.params.udf4,self.params.udf5,self.params.udf6,self.params.udf7,self.params.udf8,self.params.udf9,self.params.udf10];
//    [user_dict setValue:hashSequence forKey:@"hash_string"];
//    
//    
//    __block NSString *str;
//    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:user_dict AndPath:kgenerate_hash WithCompletion:^(BOOL suceeded, NSString *error, id response) {
//        
//        if (suceeded) {
//            
//            NSString *responseCode = [response objectForKeyNotNull:kresponseCode expectedClass:[NSString class]];
//            NSString *responseMessage = [response objectForKeyNotNull:kresponseMessage expectedClass:[NSString class]];
//            
//            if (responseCode.integerValue == KSuccessCode) {
//               str = [response objectForKeyNotNull:@"hash_string" expectedClass:[NSString class]];
//               
//                NSString *rawHash = [str description];
//                NSString *hash = [[[rawHash stringByReplacingOccurrencesOfString:@"<" withString:@""]stringByReplacingOccurrencesOfString:@">" withString:@""]stringByReplacingOccurrencesOfString:@" " withString:@""];
//                 self.params.hashValue = hash;
//                //Start the payment flow
//                PUMMainVController *paymentVC = [[PUMMainVController alloc] init];
//                UINavigationController *paymentNavController = [[UINavigationController alloc] initWithRootViewController:paymentVC];
//                
//                [self presentViewController:paymentNavController
//                                   animated:YES
//                                 completion:nil];
//                
//            } else if (responseCode.integerValue == KLogoutCode) {
//                [[AlertView sharedManager] displayInformativeAlertwithTitle:@"Error!" andMessage:responseMessage onController:self];
//                [APP_DELEGATE logout];
//                [[APP_DELEGATE navController] popToRootViewControllerAnimated:YES];
//                
//            } else{
//                
//                [[AlertView sharedManager] displayInformativeAlertwithTitle:@"Error!" andMessage:responseMessage onController:self];
//                
//            }
//        }else{
//            NSError *error = [response objectForKeyNotNull:@"Error" expectedClass:[NSError class]];
//            
//            if (error != nil) {
//                
//                [[AlertView sharedManager] displayInformativeAlertwithTitle:@"Error!" andMessage:error.localizedDescription onController:self];
//            }else{
//                [[AlertView sharedManager] displayInformativeAlertwithTitle:@"Error!" andMessage:KError_Message onController:self];
//            }
//        }
//    }];
//}

- (void)setPaymentParameters {
    self.params = [PUMRequestParams sharedParams];
    self.params.environment = PUMEnvironmentTest;
    self.params.amount =[NSString stringWithFormat:@"%d", self.total ];
    self.params.key = @"SD8RiOL0";
    self.params.merchantid = @"5750685";
    self.params.txnid = [self  getRandomString:2];
    self.params.surl = @"https://www.payumoney.com/mobileapp/payumoney/success.php";
    self.params.furl = @"https://www.payumoney.com/mobileapp/payumoney/failure.php";
    self.params.delegate = self;
    self.params.firstname = @"abc";
    self.params.productinfo = @"Nice product";
    self.params.email = @"abc@gmail.com";
    self.params.phone = @"";
    
    //Below parameters are optional. It is to store any information you would like to save in PayU Database regarding trasnsaction. If you do not intend to store any additional info, set below params as empty strings.
    
    self.params.udf1 = @"";
    self.params.udf2 = @"";
    self.params.udf3 = @"";
    self.params.udf4 = @"";
    self.params.udf5 = @"";
    self.params.udf6 = @"";
    self.params.udf7 = @"";
    self.params.udf8 = @"";
    self.params.udf9 = @"";
    self.params.udf10 = @"";
    
    self.params.hashValue = [self getHash];
    
}



- (NSString *)getRandomString:(NSInteger)length {
    NSMutableString *returnString = [NSMutableString stringWithCapacity:length];
    NSString *numbers = @"0123456789";
    
    // First number cannot be 0
    [returnString appendFormat:@"%C", [numbers characterAtIndex:(arc4random() % ([numbers length]-1))+1]];
    
    for (int i = 1; i < length; i++) {
        [returnString appendFormat:@"%C", [numbers characterAtIndex:arc4random() % [numbers length]]];
    }
    return returnString;
}


#pragma mark - Never Generate hash from app
/*!
 Keeping salt in the app is a big security vulnerability. Never do this. Following function is just for demonstratin purpose
 In code below, salt Je7q3652 is mentioned. Never do this in prod app. You should get the hash from your server.
 */



- (NSString*)getHash {
    NSString *hashSequence = [NSString stringWithFormat:@"dRQuiA|%@|%@|%@|%@|%@|||||||||||teEkuVg2",self.params.txnid, self.params.amount, self.params.productinfo,self.params.firstname, self.params.email];
    
    NSString *rawHash = [[self createSHA512:hashSequence] description];
    NSString *hash = [[[rawHash stringByReplacingOccurrencesOfString:@"<" withString:@""]stringByReplacingOccurrencesOfString:@">" withString:@""]stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    
    
    return hash;
}

- (NSData *) createSHA512:(NSString *)source {
    
    const char *s = [source cStringUsingEncoding:NSASCIIStringEncoding];
    NSData *keyData = [NSData dataWithBytes:s length:strlen(s)];
    uint8_t digest[CC_SHA512_DIGEST_LENGTH] = {0};
    CC_SHA512(keyData.bytes, (CC_LONG)keyData.length, digest);
    
    NSData *output = [NSData dataWithBytes:digest length:CC_SHA512_DIGEST_LENGTH];
    NSLog(@"out --------- %@",output);
    return output;
}



#pragma mark - Completeion callbacks

-(void)transactionCompletedWithResponse:(NSDictionary*)response
                       errorDescription:(NSError* )error {
    
    self.orderId = [response objectForKeyNotNull:@"paymentId" expectedClass:[NSString class]];
    [self dismissViewControllerAnimated:YES completion:^{
        [self showAlertViewWithTitle:@"Message" message:@"congrats! Payment is Successful"];
     //   if ( videoArray.count == 0) {
            [self callApiTObuyTest];
//        } else {
//            [self callApiTObuyVideos];
//        }
//        
    }];
    
}

/*!
 * Transaction failure occured. Check Payment details in response. error shows any error
 if api failed.
 */
-(void)transactinFailedWithResponse:(NSDictionary* )response
                   errorDescription:(NSError* )error {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self showAlertViewWithTitle:@"Message" message:@"Oops!!! Payment Failed"];
}

-(void)transactinExpiredWithResponse: (NSString *)msg {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self showAlertViewWithTitle:@"Message" message:@"Trasaction expired!"];
}

/*!
 * Transaction cancelled by user.
 */
-(void)transactinCanceledByUser {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self showAlertViewWithTitle:@"Message" message:@"Payment Cancelled!"];
}

#pragma mark - Helper methods

- (void)showAlertViewWithTitle:(NSString*)title message:(NSString*)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    
    [self presentViewController:alertController animated:YES completion:nil];
}





#pragma mark - Animation.
-(void) AnimationFromTopToBottom {
    CATransition *animation = [CATransition animation];
    [animation setDelegate:self];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromBottom];
    [animation setDuration:0.65f];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [[self.navigationController.view layer] addAnimation:animation forKey:@"AnimationFromBottomToTop"];
}

-(void) AnimationFromBottomToTop {
    CATransition *animation = [CATransition animation];
    [animation setDelegate:self];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromTop];
    [animation setDuration:0.65f];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [[self.navigationController.view layer] addAnimation:animation forKey:@"AnimationFromBottomToTop"];
}

#pragma mark - Memory Management.
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma  mark - UITableViewDataSource, UITableViewDelegate methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return itemArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    CoursesInfo *objInfo=[itemArray objectAtIndex:section];
    return objInfo.array.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TestVideosListTVCell *cell = (TestVideosListTVCell *)[tableView dequeueReusableCellWithIdentifier:@"TestVideosListTVCell"];
    
    CoursesInfo *objInfo=[itemArray objectAtIndex:indexPath.section];
    if (!(objInfo.array.count  == 0)) {
        if (indexPath.section == 0) {
            CoursesInfo *objRow = [objInfo.array objectAtIndex:indexPath.row];
            cell.nameLabel.text = objRow.videoName;
            if ([objRow.videoPrice isEqualToString:@"0"]) {
                cell.priceLabel.text = objRow.videoPrice;
            } else {
                cell.priceLabel.text = [NSString stringWithFormat:@"₹ %@",objRow.videoPrice ];
            }
            if ([objRow.videoPurchaseStatus isEqualToString:@"1"]) {
                cell.priceLabel.hidden = YES;
                cell.radioBtnOutlet.hidden = YES;
                cell.alreadyLabel.hidden = NO;
            } else {
                cell.priceLabel.hidden = NO;
                cell.radioBtnOutlet.hidden = NO;
                cell.alreadyLabel.hidden = YES;
            }
            cell.playImageView.hidden= NO;
            [cell.profileImageView sd_setImageWithURL:[NSURL URLWithString:objRow.videothumbnail] placeholderImage:[UIImage imageNamed:@"img1"]];
            if (objRow.isSelected) {
                [cell.radioBtnOutlet setSelected:YES];
            }else {
                [cell.radioBtnOutlet setSelected:NO];
            }
        } else {
            CoursesInfo *objRow = [objInfo.array objectAtIndex:indexPath.row];
            cell.nameLabel.text = objRow.testName;
            if ([objRow.testPrice isEqualToString:@"0"]) {
                cell.priceLabel.text = objRow.testPrice;
            } else {
                cell.priceLabel.text = [NSString stringWithFormat:@"₹ %@",objRow.testPrice ];
            }
            if ([objRow.testPurchaseStatus isEqualToString:@"1"]) {
                cell.priceLabel.hidden = YES;
                cell.radioBtnOutlet.hidden = YES;
                cell.alreadyLabel.hidden = NO;
            } else {
                cell.priceLabel.hidden = NO;
                cell.radioBtnOutlet.hidden = NO;
                cell.alreadyLabel.hidden = YES;
            }

            cell.playImageView.hidden = YES;
            [cell.profileImageView sd_setImageWithURL:[NSURL URLWithString:objRow.testthumbnail] placeholderImage:[UIImage imageNamed:@"img1"]];
            if (objRow.isSelected) {
                [cell.radioBtnOutlet setSelected:YES];
            } else {
                [cell.radioBtnOutlet setSelected:NO];
            }
        }
    }
    [cell.radioBtnOutlet addTarget:self action:@selector(selectBtnSelector:withEvent:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CoursesInfo *ObjExpand = [itemArray objectAtIndex:section];
    UIButton *headerImage = [[UIButton alloc]init];
    [headerImage setTag:section + 1];
    headerImage.frame=CGRectMake(WIN_WIDTH - 46, 10, 30, 30);
    ([ObjExpand isParentTapped]) ? [headerImage setBackgroundImage:[UIImage imageNamed:@"sel-1"] forState:UIControlStateNormal] : [headerImage setBackgroundImage:[UIImage imageNamed:@"un-1"] forState:UIControlStateNormal];
    UILabel *headerLabel = [[UILabel alloc] init];
    headerLabel.frame=CGRectMake(WIN_WIDTH - 125, 10, 120, 30);
    headerLabel.text = @"Select All";
    [headerImage addTarget:self action:@selector(headerbuttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *headerView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    [headerView setBackgroundColor:[UIColor colorWithRed:225.0f/255.0f green:225.0f/255.0f blue:225.0f/255.0f alpha:1.0]];
    [headerView setTag:section + 100];
    [headerView setTitleEdgeInsets:UIEdgeInsetsMake(15, 20, 15, 0)];
    [headerView setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [headerView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [headerView addSubview:headerImage];
    [headerView addSubview:headerLabel];
    switch (section) {
        case 0: {
            [headerView setTitle:@"Videos" forState:UIControlStateNormal];
        }
            break;
        case 1: {
            [headerView setTitle:@"Test" forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
    return headerView;
}

#pragma mark - UIButton selector method

-(void)selectBtnSelector :(UIButton *) button withEvent:(UIEvent *) event{
    
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:[[[event touchesForView: button] anyObject] locationInView: self.tableView]];
    CoursesInfo *objInfo=[itemArray objectAtIndex:indexPath.section];
    CoursesInfo *objRow = [objInfo.array objectAtIndex:indexPath.row];
    objRow.isSelected = !objRow.isSelected;
    if (indexPath.section == 0) {
        if ([objRow.videoPurchaseStatus isEqualToString:@"0"]) {
        if (objRow.isSelected == YES) {
            [videoArray addObject:objRow.videoID];
            self.total += [objRow.videoPrice intValue];
            self.totalAmountLabel.text = [NSString stringWithFormat:@"₹ %d.00",  self.total];
        } else {
            [videoArray removeObject:objRow.videoID];
            self.total -= [objRow.videoPrice intValue];
            self.totalAmountLabel.text = [NSString stringWithFormat:@"₹ %d.00",  self.total];
        }
        }
    } else {
        if ([objRow.testPurchaseStatus isEqualToString:@"0"]) {

        if (objRow.isSelected == YES) {
            [testArray addObject:objRow.testID];
            self.total += [objRow.testPrice intValue];
            self.totalAmountLabel.text = [NSString stringWithFormat:@"₹ %d.00",  self.total];
        } else {
            [testArray removeObject:objRow.testID];
            self.total -= [objRow.testPrice intValue];
            self.totalAmountLabel.text = [NSString stringWithFormat:@"₹ %d.00",  self.total];
        }
        }
    }
    [self.tableView reloadData];
}

-(void)headerbuttonTapped:(UIButton *)sender {
    CoursesInfo *objExpand = [itemArray objectAtIndex:sender.tag-1];
    objExpand.isParentTapped = !objExpand.isParentTapped;
    if (objExpand.isParentTapped == YES) {
        for (CoursesInfo *ob in objExpand.array) {
            ob.isSelected=YES;
            if ((sender.tag - 1) == 0) {
             if ([ob.videoPurchaseStatus isEqualToString:@"0"]) {
                [videoArray addObject:ob.videoID];
                self.total += [ob.videoPrice intValue];
                self.totalAmountLabel.text = [NSString stringWithFormat:@"₹ %d.00",  self.total];
          }
            } else {
                 if ([ob.testPurchaseStatus isEqualToString:@"0"]) {
                [testArray addObject:ob.testID];
                self.total += [ob.testPrice intValue];
                self.totalAmountLabel.text = [NSString stringWithFormat:@"₹ %d.00",  self.total];
            }
            }
        }
    } else {
        for (CoursesInfo *ob in objExpand.array) {
            ob.isSelected=NO;
            if ((sender.tag - 1) == 0) {
                if (videoArray.count == 0) {
                } else{
                    if ([ob.videoPurchaseStatus isEqualToString:@"1"]) {
                        
                    } else {
                         [videoArray removeObject:ob.videoID];
                            self.total -= [ob.videoPrice intValue];
                            self.totalAmountLabel.text = [NSString stringWithFormat:@"₹ %d.00",  self.total];
                        }
                    }
            }
             else {
                 if (testArray.count == 0) {
                 } else{
                     if ([ob.testPurchaseStatus isEqualToString:@"1"]) {
                         
                     } else {
                        [testArray removeObject:ob.testID];
                        self.total -= [ob.testPrice intValue];
                        self.totalAmountLabel.text = [NSString stringWithFormat:@"₹ %d.00",  self.total];

                    }
            }
             }
            }
            
        }
    
    [self.tableView reloadData];
}

#pragma mark - Button Action.

- (IBAction)wantToBuyBtnAction:(id)sender {
    [self.view endEditing:YES];
    if (self.total == 0) {
        [[AlertView sharedManager] presentAlertWithTitle:@"" message:@"Please select test and videos to buy." andButtonsWithTitle:@[@"OK"] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
        }];
        
    } else {

        [self setPaymentParameters];
        
        
        //Start the payment flow
        PUMMainVController *paymentVC = [[PUMMainVController alloc] init];
        UINavigationController *paymentNavController = [[UINavigationController alloc] initWithRootViewController:paymentVC];
        
        [self presentViewController:paymentNavController
                           animated:YES
                         completion:nil];

        
    }
}
- (IBAction)backBtnAction:(id)sender {
    [self.view endEditing:YES];
    [self AnimationFromTopToBottom];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)sortBtnAction:(id)sender {
    [self.view endEditing:YES];
//    [self AnimationFromBottomToTop];
    SortVC *customAlertVC = [[SortVC alloc] initWithNibName:@"SortVC" bundle:nil];
    customAlertVC.passingDelegate = self;
    [self presentViewController:customAlertVC animated:YES completion:nil];

}

-(void) passingData:(NSString *)string {
    self.sort = string;
}


#pragma mark - WebServices.
-(void) callApiForVdeos {
    NSMutableDictionary *user_dict = [NSMutableDictionary dictionary];
    
    [user_dict setValue:[NSUSERDEFAULTS valueForKey:kuid] forKey:kuid];
    [user_dict setValue:self.subjectID forKey:ksubjectID];
    [user_dict setValue:self.sort? self.sort : @"" forKey:@"sort"];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:user_dict AndPath:ksubject_video_list WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        if (suceeded) {
            
            NSString *responseCode = [response objectForKeyNotNull:kresponseCode expectedClass:[NSString class]];
            NSString *responseMessage = [response objectForKeyNotNull:kresponseMessage expectedClass:[NSString class]];
            
            if (responseCode.integerValue == KSuccessCode) {
                [subjectArray removeAllObjects];
                [itemArray removeAllObjects];
                NSArray *subjectListArray = [response objectForKeyNotNull:@"videoList" expectedClass:[NSArray class]];
                [itemArray addObject:[CoursesInfo parseVideoListWith:subjectListArray]];
                [self callApiForTest];
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

-(void) callApiForTest {
    NSMutableDictionary *user_dict = [NSMutableDictionary dictionary];
    
    [user_dict setValue:[NSUSERDEFAULTS valueForKey:kuid] forKey:kuid];
    [user_dict setValue:self.subjectID forKey:ksubjectID];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:user_dict AndPath:ksubject_test_list WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        if (suceeded) {
            
            NSString *responseCode = [response objectForKeyNotNull:kresponseCode expectedClass:[NSString class]];
            NSString *responseMessage = [response objectForKeyNotNull:kresponseMessage expectedClass:[NSString class]];
            
            if (responseCode.integerValue == KSuccessCode) {
                [subjectArray removeAllObjects];
                NSArray *subjectListArray = [response objectForKeyNotNull:@"testList" expectedClass:[NSArray class]];
                [itemArray addObject:[CoursesInfo parseTestListWith:subjectListArray]];
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

-(void) callApiTObuyTest {
    NSMutableDictionary *user_dict = [NSMutableDictionary dictionary];
    
    [user_dict setValue:[NSUSERDEFAULTS valueForKey:kuid] forKey:kuid];
    [user_dict setValue:[NSString stringWithFormat:@"%d",self.total] forKey:@"price"];
    [user_dict setValue:self.orderId forKey:@"orderId"];
    [user_dict setValue:@"0.0" forKey:@"wallet_balance"];
    [user_dict setValue:testArray forKey:@"testIdd"];
     [user_dict setValue:videoArray forKey:@"videoIdd"];
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:user_dict AndPath:kbuy_test WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        if (suceeded) {
            
            NSString *responseCode = [response objectForKeyNotNull:kresponseCode expectedClass:[NSString class]];
            NSString *responseMessage = [response objectForKeyNotNull:kresponseMessage expectedClass:[NSString class]];
            
            if (responseCode.integerValue == KSuccessCode) {
                                  NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
                    for (UIViewController *aViewController in allViewControllers) {
                        if ([aViewController isKindOfClass:[HomeVC class]]) {
                            [self.navigationController popToViewController:aViewController animated:YES];
                        }
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

@end
