//
//  CourseDetailsVC.m
//  AnyTimeClass
//
//  Created by Aman Goswami on 19/01/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

#import "CourseDetailsVC.h"
#import "Header.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

@interface CourseDetailsVC () <CAAnimationDelegate>{
    NSMutableArray *imageArray,*subjectArray;
    CoursesInfo *objInfo;
}

@property (strong, nonatomic) IBOutlet UIButton *playVideoBtnOutlet;
@property (strong, nonatomic) IBOutlet UILabel *headerLabel;
@property (strong, nonatomic) IBOutlet UIButton *buyBtnOutlet;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UILabel *amountLabel;
@property (strong, nonatomic) IBOutlet UILabel *subjectNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *likesLabel;
@property (strong, nonatomic) IBOutlet UIButton *likeBtnOutlet;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (strong, nonatomic) IBOutlet UIImageView *bannerImageView;
@property (strong, nonatomic) IBOutlet UIView *videoView;
@property (assign, nonatomic) NSInteger totalVideo;

@end

@implementation CourseDetailsVC
#pragma mark - view Life Cycle.
- (void)viewDidLoad {
    [super viewDidLoad];
    [self InitialSetup];
}


#pragma mark -  Helper Class.
-(void)InitialSetup {
    ////// cell register
    [self.tableView registerNib:[UINib nibWithNibName:@"CourseDetailTVCell" bundle:nil] forCellReuseIdentifier:@"CourseDetailTVCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"CACVCell" bundle:nil] forCellWithReuseIdentifier:@"CACVCell"];
    /// Setting header and footer view
    self.tableView.tableHeaderView = self.headerView;
    if (self.isbuy == NO) {
        self.tableView.tableFooterView = self.footerView;
        self.videoView.hidden = YES;
        self.playVideoBtnOutlet.hidden = YES;
        self.likesLabel.hidden = NO;
        self.subjectNameLabel.hidden = NO;
        self.amountLabel.hidden  =NO;
        self.likeBtnOutlet.hidden = NO;
    } else {
        self.videoView.hidden = NO;
        self.playVideoBtnOutlet.hidden = NO;
        self.likeBtnOutlet.hidden = YES;
        self.likesLabel.hidden = YES;
        self.subjectNameLabel.hidden = YES;
        self.amountLabel.hidden  =YES;
    }
    ////// Array initialization.
    imageArray = [[NSMutableArray alloc]initWithObjects:@"img1",@"img2", nil];
    subjectArray = [[NSMutableArray alloc]initWithObjects:@"0 Videos",@"0 Mockup Test", nil];
    ///// Auto Dimension.
    self.tableView.estimatedRowHeight = 60.0f;
    self.tableView.rowHeight =  UITableViewAutomaticDimension;
    ////// From the navigation.
  self.headerLabel.text  =@"Course Detail";
    self.totalVideo = 0;
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    ////// Api Calling.
    [self callApiForCourseDetail];
}

#pragma mark -  Play Video.
-(void)playVideo {
    AVPlayer  *avPlayer =  [AVPlayer playerWithURL:[NSURL URLWithString:objInfo.subjectsampleVideo]];
    AVPlayerLayer *avPlayerLayer =[AVPlayerLayer playerLayerWithPlayer:avPlayer];
    avPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    avPlayerLayer.frame = self.videoView.bounds;
    [self.videoView.layer addSublayer:avPlayerLayer];
    [avPlayer seekToTime:kCMTimeZero];
    [self.videoView bringSubviewToFront:self.playVideoBtnOutlet];
    [avPlayer play];
}

-(UIImage *)generateThumbImage {
    NSURL *url = [NSURL URLWithString:objInfo.subjectsampleVideo];
    
    AVAsset *asset = [AVAsset assetWithURL:url];
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc]initWithAsset:asset];
    imageGenerator.appliesPreferredTrackTransform = YES;
    CMTime time = [asset duration];
    time.value = 0;
    CGImageRef imageRef = [imageGenerator copyCGImageAtTime:time actualTime:NULL error:NULL];
    UIImage *thumbnail = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);  // CGImageRef won't be released by ARC
    
    return thumbnail;
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

#pragma collectionView Delgate and DataSource
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CACVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CACVCell" forIndexPath:indexPath];
    cell.backImageView.image = [UIImage imageNamed:[imageArray objectAtIndex:indexPath.row ] ];
    [cell.subjectLabel setFont:[UIFont fontWithName:@"BreeSerif-Regular" size:19]];
    cell.amountLabel.hidden =YES;
    cell.subjectLabel.text = [subjectArray objectAtIndex:indexPath.item];
    
    return cell;
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(collectionView.frame.size.width/2.01, 160);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TestVideosListVC *myVC = [[TestVideosListVC alloc] initWithNibName:@"TestVideosListVC" bundle:nil];
    myVC.subjectID = self.subjectID;
    [self.navigationController pushViewController:myVC animated:YES];
}

#pragma mark - TableView Delegate and DataSource.

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CourseDetailTVCell *cell = (CourseDetailTVCell *)[self.tableView dequeueReusableCellWithIdentifier: @"CourseDetailTVCell" forIndexPath:indexPath];
    cell.cellLabel.text = objInfo.subjectDescription;
    return cell;
}

-(CGFloat) tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

#pragma mark  - Memory management.
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Button Action.
- (IBAction)buyBtnAction:(id)sender {
    if ([objInfo.subjectPriceStatus isEqualToString:@"0"]) {
        if (self.totalVideo == 0) {
            [[AlertView sharedManager] presentAlertWithTitle:@"" message:@"No test or video to avail." andButtonsWithTitle:@[@"OK"] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
            }];
        } else {
            [self callApiForAvailOffer];
        }
    } else {
        if (self.totalVideo == 0) {
            [[AlertView sharedManager] presentAlertWithTitle:@"" message:@"No video or test avaliable for this subject." andButtonsWithTitle:@[@"OK"] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
            }];
        } else {
            TestVideosListVC *myVC = [[TestVideosListVC alloc] initWithNibName:@"TestVideosListVC" bundle:nil];
            myVC.subjectID = self.subjectID;
            [self.navigationController pushViewController:myVC animated:YES];
        }
        
    }
}

- (IBAction)likeBtnAction:(id)sender {
    [self.view endEditing:YES];
    if (self.likeBtnOutlet.selected == YES) {
        self.likeBtnOutlet.selected = NO;
    } else {
        self.likeBtnOutlet.selected = YES;
    }
    //    [self callApiForLikeAndUnlike];
}

- (IBAction)crossBtnAction:(id)sender {
    [self.view endEditing:YES];
    [self AnimationFromTopToBottom];
    if (self.fromSearch == YES)
    {
        NSMutableArray *newStack = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
        [newStack removeLastObject];
        [newStack removeLastObject];
        [self.navigationController setViewControllers:newStack animated:YES];
    } else {
    [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)searchBtnAction:(id)sender {
    [self.view endEditing:YES];
    SearchScreenVC *customAlertVC = [[SearchScreenVC alloc] initWithNibName:@"SearchScreenVC" bundle:nil];
    [self.navigationController pushViewController:customAlertVC animated:YES];
}
- (IBAction)playVideoBtnAction:(UIButton *)sender {
    [self playVideo];
    self.playVideoBtnOutlet.hidden = YES;
    
}

#pragma mark - WebService.
-(void) callApiForCourseDetail {
    
    NSMutableDictionary *user_dict = [NSMutableDictionary dictionary];
    
    [user_dict setValue:[NSUSERDEFAULTS valueForKey:kuid] forKey:kuid];
    [user_dict setValue:self.subjectID forKey:ksubjectID];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:user_dict AndPath:ksubjectDetail WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        if (suceeded) {
            
            NSString *responseCode = [response objectForKeyNotNull:kresponseCode expectedClass:[NSString class]];
            NSString *responseMessage = [response objectForKeyNotNull:kresponseMessage expectedClass:[NSString class]];
            
            if (responseCode.integerValue == KSuccessCode) {
                [subjectArray removeAllObjects];
                NSDictionary *subjectListArray = [response objectForKeyNotNull:@"subjectList" expectedClass:[NSArray class]];
                for (NSDictionary  *subjectDict in subjectListArray) {
                    objInfo = [CoursesInfo parseSubjectList:subjectDict];
                }
                if (self.isbuy ==  YES) {
                    self.videoView.backgroundColor = [UIColor colorWithPatternImage:[self generateThumbImage]];
                } else {
                    [self.bannerImageView sd_setImageWithURL:[NSURL URLWithString:objInfo.subjectImage] placeholderImage:[UIImage imageNamed:@"ban2"]];
                }
                self.likesLabel.text = [NSString stringWithFormat:@"%@ likes",objInfo.totalLikes];
                self.subjectNameLabel.text = objInfo.subjectName;
                self.totalVideo = [objInfo.totalVideo integerValue] + [objInfo.totalTest integerValue];
                objInfo.totalVideo = [NSString stringWithFormat:@"%@ Videos",objInfo.totalVideo];
                objInfo.totalTest = [NSString stringWithFormat:@"%@ Mockup Test",objInfo.totalTest];
                subjectArray = [[NSMutableArray alloc] initWithObjects:objInfo.totalVideo,objInfo.totalTest, nil];
                
                if ([objInfo.subjectPriceStatus isEqualToString:@"0"]) {
                    self.amountLabel.text = objInfo.subjectPrice;
                    [self.buyBtnOutlet setTitle:@"Avail This Offer" forState:UIControlStateNormal];
                } else {
                    self.amountLabel.text = [NSString stringWithFormat:@"₹ %@",objInfo.subjectPrice ];
                    [self.buyBtnOutlet setTitle:@"Want To Buy" forState:UIControlStateNormal];
                }
                
                [self.tableView reloadData];
                [self.collectionView reloadData];
            } else if (responseCode.integerValue == KLogoutCode) {
                [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:responseMessage onController:self];
                [APP_DELEGATE logout];
                [[APP_DELEGATE navController] popToRootViewControllerAnimated:YES];
                
            } else{
                [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:responseMessage onController:self];
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

-(void) callApiForAvailOffer {
    
    NSMutableDictionary *user_dict = [NSMutableDictionary dictionary];
    
    [user_dict setValue:[NSUSERDEFAULTS valueForKey:kuid] forKey:kuid];
    [user_dict setValue:self.subjectID forKey:ksubjectID];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:user_dict AndPath:kavailOffer WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        if (suceeded) {
            
            NSString *responseCode = [response objectForKeyNotNull:kresponseCode expectedClass:[NSString class]];
            NSString *responseMessage = [response objectForKeyNotNull:kresponseMessage expectedClass:[NSString class]];
            
            if (responseCode.integerValue == KSuccessCode) {
                [[AlertView sharedManager] presentAlertWithTitle:@"Congratulations!!" message:responseMessage andButtonsWithTitle:@[@"Ok"] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                    [self.navigationController popViewControllerAnimated:YES];
                }];
                
            } else if (responseCode.integerValue == KLogoutCode) {
                [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:responseMessage onController:self];
                [APP_DELEGATE logout];
                [[APP_DELEGATE navController] popToRootViewControllerAnimated:YES];
                
            } else{
                [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:responseMessage onController:self];
                
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


-(void) callApiForLikeAndUnlike {
    NSMutableDictionary *user_dict = [NSMutableDictionary dictionary];
    
    [user_dict setValue:[NSUSERDEFAULTS valueForKey:kuid] forKey:kuid];
    [user_dict setValue:self.subjectID forKey:ksubjectID];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:user_dict AndPath:(self.likeBtnOutlet.selected == YES)?klike_subject:kunlike_subject WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        if (suceeded) {
            
            NSString *responseCode = [response objectForKeyNotNull:kresponseCode expectedClass:[NSString class]];
            NSString *responseMessage = [response objectForKeyNotNull:kresponseMessage expectedClass:[NSString class]];
            
            if (responseCode.integerValue == KSuccessCode) {
                
                self.likesLabel.text = [NSString stringWithFormat:@"%@ likes",[response objectForKeyNotNull:@"totalLikes" expectedClass:[NSString class]]];
                
            } else if (responseCode.integerValue == KLogoutCode) {
                [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:responseMessage onController:self];
                [APP_DELEGATE logout];
                [[APP_DELEGATE navController] popToRootViewControllerAnimated:YES];
                
            } else{
                [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:responseMessage onController:self];
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
