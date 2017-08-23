//
//  HomeVC.m
//  AnyTimeClass
//
//  Created by Aman Goswami on 16/01/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

#import "HomeVC.h"
#import "Header.h"

@interface HomeVC ()<CAAnimationDelegate,LCBannerViewDelegate,UITableViewDelegate>{
    NSMutableArray *imageArray,*textArray,*arrayImages;
    LCBannerView *bannerView;
}

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollViewBannerImage;

@end

@implementation HomeVC
#pragma mark - View Life Cycle.
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetup];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [APP_DELEGATE setShouldAddTimer:YES];
    [self SetUpBannerScroll];
    //   [bannerView addTimer];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [APP_DELEGATE setShouldAddTimer:NO];
    [bannerView removeTimer];
}

#pragma mark - Helper Classes
-(void) initialSetup {
    ////// cell register
    [self.collectionView registerNib:[UINib nibWithNibName:@"HomeCVCell" bundle:nil] forCellWithReuseIdentifier:@"HomeCVCell"];
    
    /////// Array initialzation.
    imageArray = [[NSMutableArray alloc] initWithObjects:@"img",@"img2-1",@"img1-1",@"img4",@"img3", nil];
    textArray = [[NSMutableArray alloc] initWithObjects:@"CA-CPT",@"CA-IPC Group 1",@"CA-IPC Group 2",@"CA-FINAL Group 1",@"CA-FINAL Group 2", nil];
    arrayImages = [[NSMutableArray alloc] initWithObjects:@"B1",@"B2",@"B3",@"B4", nil];
    ///// Window management
    if (WIN_HEIGHT < 400) {
        self.tableView.scrollEnabled = YES;
    } else {
        self.tableView.scrollEnabled = NO;
    }
    
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


#pragma collectionView Delgate and DataSource
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return textArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HomeCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeCVCell" forIndexPath:indexPath];
    cell.cellImageView.image = [UIImage imageNamed:[imageArray objectAtIndex:indexPath.row ]];
    cell.nameLabel.text = [textArray objectAtIndex:indexPath.row];
    return cell;
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return CGSizeMake(collectionView.frame.size.width, 120);
    } else {
        return CGSizeMake(collectionView.frame.size.width/2, 120);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.item) {
        case 0: {
            /////// CA-CPT navigation.
            CACPTVC *customAlertVC = [[CACPTVC alloc] initWithNibName:@"CACPTVC" bundle:nil];
            customAlertVC.course_id = @"1";
            [self.navigationController pushViewController:customAlertVC animated:YES];
        }
            break;
        case 1: {
            /////// CA-IPC navigation.
            CAIPCVC *customAlertVC = [[CAIPCVC alloc] initWithNibName:@"CAIPCVC" bundle:nil];
            customAlertVC.course_id = @"4";
            customAlertVC.headerText = @"CA-IPC Group 1";
            [self.navigationController pushViewController:customAlertVC animated:YES];
        }
            break;
        case 2: {
            /////// CA-IPC navigation.
            CAIPCVC *customAlertVC = [[CAIPCVC alloc] initWithNibName:@"CAIPCVC" bundle:nil];
            customAlertVC.course_id = @"2";
            customAlertVC.headerText = @"CA-IPC Group 2";
            [self.navigationController pushViewController:customAlertVC animated:YES];
            
        }
            break;
            
        case 3: {
            /////// CA-Finals navigation.
            CAFinalsVC *customAlertVC = [[CAFinalsVC alloc] initWithNibName:@"CAFinalsVC" bundle:nil];
            customAlertVC.course_id = @"3";
            customAlertVC.headerText = @"CA-FINAL Group 1";
            [self.navigationController pushViewController:customAlertVC animated:YES];
        }
            break;
        case 4: {
            /////// CA-Finals navigation.
            CAFinalsVC *customAlertVC = [[CAFinalsVC alloc] initWithNibName:@"CAFinalsVC" bundle:nil];
            customAlertVC.course_id = @"5";
            customAlertVC.headerText = @"CA-FINAL Group 2";
            [self.navigationController pushViewController:customAlertVC animated:YES];
        }
            
            break;
        default:
            break;
    }
    
}
- (void)bannerView:(LCBannerView *)bannerView didClickedImageIndex:(NSInteger)index {
    
}


#pragma mark - Button Action.

- (IBAction)menuBtnAction:(id)sender {
    [self AnimationFromBottomToTop];
    SidePannelVC *customAlertVC = [[SidePannelVC alloc] initWithNibName:@"SidePannelVC" bundle:nil];
    [self.navigationController pushViewController:customAlertVC animated:YES];
}

- (IBAction)imageMoveBtnAction:(UIButton *)sender {
    switch (sender.tag) {
        case 500:{
            //////// move image left
            [bannerView previousImage];
        }
            break;
        case 501: {
            ////// move image right
            [bannerView nextImage];
        }
            break;
        default:
            break;
    }
}

#pragma mark - setting Banner Scroll.
-(void)SetUpBannerScroll{
    // autoscroll
    if (arrayImages.count) {
        BOOL doesContain = [_scrollViewBannerImage.subviews containsObject:bannerView];
        if (!doesContain ) {
            [_scrollViewBannerImage addSubview:({
                bannerView = [LCBannerView bannerViewWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 210.0f)
                                                      delegate:self
                                                     imageURLs:arrayImages
                                              placeholderImage:@"icon12"
                                                 timerInterval:3.0f
                                 currentPageIndicatorTintColor:[UIColor clearColor]
                                        pageIndicatorTintColor:[UIColor clearColor]withTimer:YES];
                bannerView;
            })];
        }
    }
}

#pragma mark - Memory Management.
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
