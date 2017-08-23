//
//  CompleteProfile.h
//  AnyTimeClass
//
//  Created by Aman Goswami on 14/01/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "userInfo.h"

@interface CompleteProfile : UIViewController
@property (nonatomic,strong) userInfo  *objSignUp;
@property (nonatomic,strong) NSString *fromFacebook;
@property (nonatomic,assign) BOOL emailSignUp;
@end
