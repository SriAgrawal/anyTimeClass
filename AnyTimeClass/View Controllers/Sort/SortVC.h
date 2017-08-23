//
//  SortVC.h
//  AnyTimeClass
//
//  Created by Aman Goswami on 17/01/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SortVCDelegate <NSObject>
-(void) passingData:(NSString *) string;
@end
@interface SortVC : UIViewController
@property(nonatomic,strong) id <SortVCDelegate> passingDelegate;
@end
