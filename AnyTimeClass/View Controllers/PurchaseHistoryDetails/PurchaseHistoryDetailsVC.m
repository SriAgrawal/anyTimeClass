//
//  PurchaseHistoryDetailsVC.m
//  AnyTimeClass
//
//  Created by Aman Goswami on 04/03/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

#import "PurchaseHistoryDetailsVC.h"
#import "Header.h"

@interface PurchaseHistoryDetailsVC ()<CAAnimationDelegate>{
    NSMutableArray *detailArray;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation PurchaseHistoryDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    /////// cell register
    [self.tableView registerNib:[UINib nibWithNibName:@"MyVideosTVCell" bundle:nil] forCellReuseIdentifier:@"MyVideosTVCell"];
    ///// Array Initiazation.
    detailArray = [[NSMutableArray alloc] init];
    /////// Api Calling

    [self callApiForOrderList];
}
#pragma Mark - Animation.
-(void) AnimationFromTopToBottom {
    CATransition *animation = [CATransition animation];
    [animation setDelegate:self];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromBottom];
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
        return detailArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyVideosTVCell *cell = (MyVideosTVCell *)[self.tableView dequeueReusableCellWithIdentifier: @"MyVideosTVCell" forIndexPath:indexPath];
    cell.playerImageView.hidden = YES;
    CoursesInfo *info = [detailArray objectAtIndex:indexPath.row];
    [cell.titleImageView sd_setImageWithURL:[NSURL URLWithString:info.subjectImage] placeholderImage:[UIImage imageNamed:@"img1"]];
    cell.subjectLabel.text = info.testName;
    cell.typeLabel.text = info.subjectName;
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


#pragma mark - Button Action.
- (IBAction)crossBtnAction:(id)sender {
    [self.view endEditing:YES];
    [self AnimationFromTopToBottom];
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - WebService.

-(void) callApiForOrderList {
    NSMutableDictionary *user_dict = [NSMutableDictionary dictionary];
    
    [user_dict setValue:[NSUSERDEFAULTS valueForKey:kuid] forKey:kuid];
    [user_dict setValue:self.orderId forKey:@"orderId"];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:user_dict AndPath:korder_detail  WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        if (suceeded) {
            NSString *responseCode = [response objectForKeyNotNull:kresponseCode expectedClass:[NSString class]];
            NSString *responseMessage = [response objectForKeyNotNull:kresponseMessage expectedClass:[NSString class]];
            
            if (responseCode.integerValue == KSuccessCode) {
                [detailArray removeAllObjects];
                NSDictionary *subjectListArray = [response objectForKeyNotNull:@"orderData" expectedClass:[NSArray class]];
                for (NSDictionary  *subjectDict in subjectListArray) {
                    [detailArray addObject :[CoursesInfo parseTestsList:subjectDict]];
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
