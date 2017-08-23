//
//  AskedQuestionVC.m
//  AnyTimeClass
//
//  Created by Aman Goswami on 18/01/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

#import "AskedQuestionVC.h"
#import "Header.h"

@interface AskedQuestionVC ()<UITableViewDelegate,UITableViewDataSource>{
    CoursesInfo *objModel;
    NSMutableArray *questionArray,*quesArray;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation AskedQuestionVC
#pragma mark - view Life Cycle.
- (void)viewDidLoad {
    [super viewDidLoad];
    [self InitialSetup];
}

#pragma mark - Helper Class.
-(void) InitialSetup {
    /////// cell register
    [self.tableView registerNib:[UINib nibWithNibName:@"CourseDetailTVCell" bundle:nil] forCellReuseIdentifier:@"CourseDetailTVCell"];
    self.tableView.estimatedRowHeight = 60.0f;
    self.tableView.rowHeight =  UITableViewAutomaticDimension;
    ///// Array Initialisation.
    questionArray = [NSMutableArray array];
    quesArray = [NSMutableArray array];
    objModel = [[CoursesInfo alloc] init];
    /////// Api Calling
    [self callApiForAskedQuestion];
}


#pragma  mark - UITableViewDataSource, UITableViewDelegate methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return questionArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    CoursesInfo *objExpand = [questionArray objectAtIndex:section];
    return objExpand.isTapped ?  1 : 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CourseDetailTVCell *cell = (CourseDetailTVCell *)[tableView dequeueReusableCellWithIdentifier:@"CourseDetailTVCell"];
    for (CoursesInfo *obj in questionArray) {
        cell.cellLabel.text = obj.answer;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 55.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    //// Setting Up the section of the Cell.
    CoursesInfo *ObjExpand = [questionArray objectAtIndex:section];
    UIButton *headerView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 55)];
    [headerView setTag:section + 100];
    [headerView setTitleEdgeInsets:UIEdgeInsetsMake(15, 12, 15, 0)];
    [headerView setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    headerView.titleLabel.font = [UIFont fontWithName:@"advent-pro.semibold" size:19];
    [headerView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //////// Tap On Header Selector.
    [headerView addTarget:self action:@selector(headerTapButton:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *headerLabel=[[UILabel alloc]initWithFrame:CGRectMake(0,headerView.frame.size.height -1,headerView.frame.size.width,1)];
    headerLabel.backgroundColor=[UIColor colorWithRed:227.0/255.0f green:227.0/255.0f blue:227.0/255.0f alpha:0.9f];
    [headerView addSubview:headerLabel];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-35, 20, 16, 10)];
    [headerView addSubview:imageView];
    ([ObjExpand isTapped]) ? [imageView setImage:[UIImage imageNamed:@"arrow1"]] : [imageView setImage:[UIImage imageNamed:@"arrow2"]];
    [quesArray removeAllObjects];
    for (CoursesInfo *obj in questionArray) {
        [quesArray addObject:obj.question];
    }
    
    [headerView setTitle:[quesArray objectAtIndex:section] forState:UIControlStateNormal];
    return headerView;
}

-(CGFloat) tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

#pragma mark - UIButton selector method
-(void)headerTapButton:(UIButton *)sender {
    CoursesInfo *objExpand = [questionArray objectAtIndex:sender.tag - 100];
    objExpand.isTapped = !objExpand.isTapped;
    [self.tableView reloadData];
}

-(void) callApiForAskedQuestion {
    
    NSMutableDictionary *user_dict = [NSMutableDictionary dictionary];
    
    [user_dict setValue:[NSUSERDEFAULTS valueForKey:kuid] forKey:kuid];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:user_dict AndPath:kasked_questions WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        if (suceeded) {
            
            NSString *responseCode = [response objectForKeyNotNull:kresponseCode expectedClass:[NSString class]];
            NSString *responseMessage = [response objectForKeyNotNull:kresponseMessage expectedClass:[NSString class]];
            
            if (responseCode.integerValue == KSuccessCode) {
                [questionArray removeAllObjects];
                NSDictionary *subjectListArray = [response objectForKeyNotNull:@"questionList" expectedClass:[NSArray class]];
                for (NSDictionary  *subjectDict in subjectListArray) {
                    objModel = [CoursesInfo parseQuestionList:subjectDict];
                    [questionArray addObject:objModel];
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

#pragma mark  -Memory management.
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
