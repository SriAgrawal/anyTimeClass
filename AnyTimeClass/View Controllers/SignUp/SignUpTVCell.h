//
//  SignUpTVCell.h
//  AnyTimeClass
//
//  Created by Aman Goswami on 14/01/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpTVCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *cellImageView;
@property (strong, nonatomic) IBOutlet UITextField *cellTextField;
@property (strong, nonatomic) IBOutlet UILabel *underLabel;
@property (strong, nonatomic) IBOutlet UILabel *errorLabel;
@property (strong, nonatomic) IBOutlet UIButton *cellBtnOutlet;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *textFieldContraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *textFieldBackConstraint;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutlet UIImageView *passwordImage;

@end
