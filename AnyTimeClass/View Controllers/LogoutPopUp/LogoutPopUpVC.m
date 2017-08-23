//
//  LogoutPopUpVC.m
//  AnyTimeClass
//
//  Created by Aman Goswami on 18/01/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

#import "LogoutPopUpVC.h"

@interface LogoutPopUpVC ()

@end

@implementation LogoutPopUpVC
#pragma mark - View life cycle.
- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Button Action.
- (IBAction)yesBtnAction:(id)sender {
    [self dismissViewControllerAnimated:NO completion:^{
        if (self && self.popUpDelegate && [self.popUpDelegate respondsToSelector:@selector(dismissPopUp)]) {
            [self.popUpDelegate dismissPopUp];
        }
    }];
    
}
- (IBAction)noBtnAction:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - Memory Management.
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
