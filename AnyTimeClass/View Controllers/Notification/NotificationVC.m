//
//  NotificationVC.m
//  AnyTimeClass
//
//  Created by Aman Goswami on 16/01/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

#import "NotificationVC.h"
#import "Header.h"

@interface NotificationVC ()<CAAnimationDelegate> {
    NSMutableArray *NotiArray,*notiIDArray;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation NotificationVC
#pragma mark - View Life cycle.
- (void)viewDidLoad {
    [super viewDidLoad];
    /////// cell register
    [self.tableView registerNib:[UINib nibWithNibName:@"NotificationTVCell" bundle:nil] forCellReuseIdentifier:@"NotificationTVCell"];
    ///// Automatic dimension
    self.tableView.estimatedRowHeight = 108.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    /////array initialzation.
    notiIDArray = [[NSMutableArray alloc] init];
    NotiArray = [[NSMutableArray alloc] init];
    [self callApiForAllNotification];
}

#pragma mark - Animation.
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
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView Delegate and DataSource.
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return NotiArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NotificationTVCell *cell = (NotificationTVCell *)[self.tableView dequeueReusableCellWithIdentifier: @"NotificationTVCell" forIndexPath:indexPath];
    userInfo *obj  = [NotiArray objectAtIndex:indexPath.row];
    cell.notificationLabel.text = obj.title;
    NSString * timeStampString =obj.created  ;
    NSTimeInterval _interval=[timeStampString doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *_formatter=[[NSDateFormatter alloc]init];
    [_formatter setDateFormat:@"dd/MM/yy"];
    cell.timeLabel.text = [_formatter stringFromDate:date];
    return cell;
}

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //// deletion selected cell.
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"          "  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        [[AlertView sharedManager] presentAlertWithTitle:@"" message:@"Are you sure you want to delete?"
                                     andButtonsWithTitle:@[@"Yes",@"No"] onController:self
                                           dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                                               if (index == 0) {
                                                   userInfo *obj = [notiIDArray objectAtIndex:indexPath.row];
                                                   [self callApiForDeleteNotification:obj];
                                                   [self.tableView reloadData];
                                               }
                                           }];
    }];
    UIImageView *img2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"del"]];
    img2.frame = CGRectMake(cell.frame.size.width, 20, 80, 30);
    img2.contentMode = UIViewContentModeScaleAspectFit;
    [cell.contentView addSubview:img2];
    deleteAction.backgroundColor = [UIColor colorWithRed:212.0f/255.0f green:31.0f/255.0f blue:31.0f/255.0f alpha:1.0];
    
    
    return @[deleteAction];
    
}


#pragma mark - Button Action.
- (IBAction)crossBtnAction:(id)sender {
    [self.view endEditing:YES];
    [self AnimationFromBottomToTop];
    [self.navigationController popViewControllerAnimated:YES];
}
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

#pragma mark - Web Api.

-(void) callApiForAllNotification {
    
    NSMutableDictionary *noti_dic = [NSMutableDictionary dictionary];
    [noti_dic setValue:[NSUSERDEFAULTS valueForKey:kuid] forKey:kuid];
    [noti_dic setValue:@"1" forKey:@"pageNumber"];
    [noti_dic setValue:@"20" forKey:@"pageSize"];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:noti_dic AndPath:knotification_list WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        if (suceeded) {
            
            NSString *responseCode = [response objectForKeyNotNull:kresponseCode expectedClass:[NSString class]];
            NSString *responseMessage = [response objectForKeyNotNull:kresponseMessage expectedClass:[NSString class]];
            //    NSString *maxpage = [response objectForKeyNotNull:@"maxpage" expectedClass:[NSString class]];
            
            if (responseCode.integerValue == KSuccessCode) {
                [NotiArray removeAllObjects];
                NSDictionary *notificationListArray = [response objectForKeyNotNull:@"notificationList" expectedClass:[NSArray class]];
                for (NSDictionary  *notificationDict in notificationListArray) {
                    
                    [NotiArray addObject :[userInfo parseNotification:notificationDict]];
                    [notiIDArray addObject :[[userInfo parseNotification:notificationDict] noti_id]];
                }
                [self.tableView reloadData];
            }else{
                [[AlertView sharedManager] displayInformativeAlertwithTitle:@"Error!" andMessage:responseMessage onController:self];
            }
        } else {
            NSError *error = [response objectForKeyNotNull:@"Error" expectedClass:[NSError class]];
            
            if (error != nil) {
                
                [[AlertView sharedManager] displayInformativeAlertwithTitle:@"Error!" andMessage:error.localizedDescription onController:self];
            }else{
                [[AlertView sharedManager] displayInformativeAlertwithTitle:@"Error!" andMessage:KError_Message onController:self];
            }
        }
    }];
    
}


-(void) callApiForDeleteNotification:(userInfo *)user {
    NSMutableDictionary *noti_dic = [NSMutableDictionary dictionary];
    [noti_dic setValue:[NSUSERDEFAULTS valueForKey:kuid] forKey:kuid];
    [noti_dic setValue:user forKey:@"noti_id"];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:noti_dic AndPath:kdelete_notification WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        if (suceeded) {
            NSString *responseCode = [response objectForKeyNotNull:kresponseCode expectedClass:[NSString class]];
            NSString *responseMessage = [response objectForKeyNotNull:kresponseMessage expectedClass:[NSString class]];
            
            if (responseCode.integerValue == KSuccessCode) {
                for (userInfo *obj in NotiArray) {
                    if ([obj.noti_id isEqualToString:[NSString stringWithFormat:@"%@", user]]) {
                        [NotiArray removeObject:obj];
                        break;
                    }
                }
                [self.tableView reloadData];
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



@end
