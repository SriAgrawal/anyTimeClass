//
//  QuestionForumVC.m
//  AnyTimeClass
//
//  Created by Aman Goswami on 18/01/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

#import "QuestionForumVC.h"
#import "Header.h"
@interface QuestionForumVC ()<CAAnimationDelegate>
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;
@property (strong, nonatomic) CarbonTabSwipeNavigation *pageVC;
@property (strong, nonatomic) NSArray *arrayItems;
@end

@implementation QuestionForumVC
#pragma mark -  View Life Cycle.
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpPages];
}

#pragma mark - Pages Setup.
- (void)setUpPages {
    
    self.arrayItems = @[@"Asked Questions", @"Ask Question"];
    self.pageVC = [[CarbonTabSwipeNavigation alloc] initWithItems:self.arrayItems toolBar:self.toolBar delegate:self];
    [self.pageVC.view setFrame:self.containerView.bounds];
    [self.containerView addSubview:self.pageVC.view];
    [self addChildViewController:self.pageVC];
    
    // set up page style
    [self.pageVC setIndicatorColor:[UIColor colorWithRed:212.0f/255.0f green:31.0f/255.0f blue:31.0f/255.0f alpha:1.0f]];
    [self.pageVC setTabBarHeight:40];
    [self.pageVC setIndicatorHeight:4];
    [self.pageVC.carbonSegmentedControl setWidth:WIN_WIDTH/self.arrayItems.count forSegmentAtIndex:0];
    [self.pageVC.carbonSegmentedControl setWidth:WIN_WIDTH/self.arrayItems.count forSegmentAtIndex:1];
    [self.pageVC setNormalColor:[UIColor blackColor]
                           font:[UIFont fontWithName:@"BreeSerif-Regular" size:17]];
    [self.pageVC setSelectedColor:[UIColor colorWithRed:212.0f/255.0f green:31.0f/255.0f blue:31.0f/255.0f alpha:1.0f] font:[UIFont fontWithName:@"BreeSerif-Regular" size:17]];
}
#pragma mark - Memory Management.
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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


#pragma mark - CarbonTabSwipeNavigation Delegate
// required
- (nonnull UIViewController *)carbonTabSwipeNavigation:(nonnull CarbonTabSwipeNavigation *)carbontTabSwipeNavigation viewControllerAtIndex:(NSUInteger)index {
    switch (index) {
        case 0: {
            AskedQuestionVC *vc = [[AskedQuestionVC alloc] initWithNibName:@"AskedQuestionVC" bundle:nil];
            return vc;
        }
        case 1: {
            AskQuestionVC *vc= [[AskQuestionVC alloc] initWithNibName:@"AskQuestionVC" bundle:nil];
            return vc;
        }
            
        default:{
            AskedQuestionVC *vc= [[AskedQuestionVC alloc] initWithNibName:@"AskedQuestionVC" bundle:nil];
            return vc;
        }
    }
}
- (UIBarPosition)barPositionForCarbonTabSwipeNavigation:(nonnull CarbonTabSwipeNavigation *)carbonTabSwipeNavigation {
    return UIBarPositionTop; // default UIBarPositionTop
}

#pragma mark - Button Action.
- (IBAction)menuBtnAction:(id)sender {
    [self.view endEditing:YES];
    [self AnimationFromBottomToTop];
    [self.navigationController popViewControllerAnimated:NO];
}

@end
