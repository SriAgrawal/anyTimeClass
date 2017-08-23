//
//  ChangePasswordTVCell.h
//  AnyTimeClass
//
//  Created by Aman Goswami on 17/01/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangePasswordTVCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UITextField *cellTextField;
@property (strong, nonatomic) IBOutlet UILabel *errorLabel;
@property (strong, nonatomic) IBOutlet UIButton *cellButton;
@property (strong, nonatomic) IBOutlet UILabel *underLabel;

@end
