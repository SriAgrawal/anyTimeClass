//
//  TAAboutUsVC.h
//  TourishApp
//
//  Created by Aman Goswami on 17/11/16.
//  Copyright © 2016 mobiloitte. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum FromStateTypes
{
    Terms_condition,
    Privacy_policy,
    About_us,
} FromState;

@interface TAAboutUsVC : UIViewController
@property (assign,nonatomic) FromState enumVariable;
@property (assign, nonatomic) BOOL isFrom;
@property (strong, nonatomic) NSString *months;
@property (assign,nonatomic) BOOL fromTerms;
@end
