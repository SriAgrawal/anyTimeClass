//
//  SignUpVC.h
//  AnyTimeClass
//
//  Created by Aman Goswami on 14/01/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "userInfo.h"

@interface SignUpVC : UIViewController
@property (nonatomic,strong) userInfo  *objData;
@property(nonatomic ,strong) NSString *fromFacebook;
@end
