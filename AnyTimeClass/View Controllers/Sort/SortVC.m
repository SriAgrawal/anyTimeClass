//
//  SortVC.m
//  AnyTimeClass
//
//  Created by Aman Goswami on 17/01/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

#import "SortVC.h"
#import "Header.h"

@interface SortVC ()<CAAnimationDelegate>
@property (strong, nonatomic) IBOutlet UIButton *mostLikelyBtnOutlet;
@property (strong, nonatomic) IBOutlet UIButton *recentlyBtnOutlet;
@property (strong, nonatomic) IBOutlet UIButton *lowCostBtnOutlet;
@property (strong,nonatomic) NSString *sortString;
@end

@implementation SortVC
#pragma mark -  View Life Cycle.
- (void)viewDidLoad {
    [super viewDidLoad];
    self.mostLikelyBtnOutlet.selected = YES;
    self.sortString  = @"most_liked";
}

#pragma mark - Memory Mangement.
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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

#pragma mark - button Action.
- (IBAction)radioBtnAction:(UIButton *)sender {
    switch (sender.tag) {
        case 100: {
            /////// Most Likely
            self.mostLikelyBtnOutlet.selected = YES;
            self.recentlyBtnOutlet.selected = NO;
            self.lowCostBtnOutlet.selected = NO;
            self.sortString  = @"most_liked";
        }
            break;
        case 101: {
            ////// Recently Posted
            self.mostLikelyBtnOutlet.selected = NO;
            self.recentlyBtnOutlet.selected = YES;
            self.lowCostBtnOutlet.selected = NO;
            self.sortString  = @"recently_posted";
        }
            break;
        case 102: {
            //////// Low Cost
            self.mostLikelyBtnOutlet.selected = NO;
            self.recentlyBtnOutlet.selected = NO;
            self.lowCostBtnOutlet.selected = YES;
            self.sortString  = @"low_cost";
        }
            break;
            
        default:
            break;
    }
}
- (IBAction)applyBtnAction:(id)sender {
    [self.view endEditing:YES];
    [self AnimationFromTopToBottom];
//    TestVideosListVC *customAlertVC = [[TestVideosListVC alloc] initWithNibName:@"TestVideosListVC" bundle:nil];
//    customAlertVC.sort = self.sortString;
//    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:NO completion:^{

    if (self && self.passingDelegate && [self.passingDelegate respondsToSelector:@selector(passingData:)]) {
        [self.passingDelegate passingData:self.sortString];
    }
    }];
}
- (IBAction)cancelBtnAction:(id)sender {
    [self.view endEditing:YES];
    [self AnimationFromTopToBottom];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)crossBtnAction:(id)sender {
    [self.view endEditing:YES];
    [self AnimationFromTopToBottom];
     [self dismissViewControllerAnimated:YES completion:nil];
}
@end
