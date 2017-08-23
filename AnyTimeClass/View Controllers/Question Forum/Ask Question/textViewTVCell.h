//
//  textViewTVCell.h
//  AnyTimeClass
//
//  Created by Aman Goswami on 19/01/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface textViewTVCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UITextView *cellTextView;
@property (strong, nonatomic) IBOutlet UILabel *errorLabel;
@property (strong, nonatomic) IBOutlet UILabel *underLabel;
@end
