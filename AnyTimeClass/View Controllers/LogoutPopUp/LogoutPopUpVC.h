//
//  LogoutPopUpVC.h
//  AnyTimeClass
//
//  Created by Aman Goswami on 18/01/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LogoutPopUpVCDelegate <NSObject>
-(void)dismissPopUp;
@end

@interface LogoutPopUpVC : UIViewController
@property (nonatomic, assign) id <LogoutPopUpVCDelegate> popUpDelegate;
@end
