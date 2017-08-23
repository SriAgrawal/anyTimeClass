//
//  PurchaseHistoryTVCell.h
//  AnyTimeClass
//
//  Created by Aman Goswami on 06/02/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PurchaseHistoryTVCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *orderIdLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *AmountLabel;

@end
