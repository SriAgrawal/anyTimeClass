//
//  TestVideosListTVCell.h
//  AnyTimeClass
//
//  Created by Aman Goswami on 03/02/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestVideosListTVCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *typeLabel;
@property (strong, nonatomic) IBOutlet UIButton *radioBtnOutlet;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UIImageView *playImageView;
@property (strong, nonatomic) IBOutlet UILabel *alreadyLabel;

@end
