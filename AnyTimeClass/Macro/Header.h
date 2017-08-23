//
//  Header.h
//  AnyTimeClass
//
//  Created by Aman Goswami on 14/01/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

#ifndef Header_h
#define Header_h

//******************Constants***************************************//
#define APP_DELEGATE             (AppDelegate*)[[UIApplication sharedApplication] delegate]
#define WIN_WIDTH               [[UIScreen mainScreen]bounds].size.width
#define WIN_HEIGHT              [[UIScreen mainScreen]bounds].size.height
#define TRIM_SPACE(str)            [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]
#define NSUSERDEFAULTS              [NSUserDefaults standardUserDefaults]


/**************************** Alerts  **************************/
#define AlertMessagePassword           @"*Please enter password."
#define AlertMessageOldPassword           @"*Please enter current password."
#define AlertMessageNewPassword           @"*Please enter new password."
#define AlertMessageOldAndNewPassword           @"*Current and new password should not be same."
#define AlertMessagePasswordValidate            @"*Password must be at least 6 characters."
#define AlertMessageConfirmPassword          @"*Please enter confirm password."
#define AlertMessageNewAndConfirmSame           @"*Password and confirm password must be same."
#define AlertMessageEmailID           @"*Please enter email address."
#define AlertMessageValidEmailID           @"*Please enter valid email address."
#define AlertMessageMobileNumber           @"*Please enter mobile number."
#define AlertMessageMobileNumberValidation           @"*Mobile number should be of atleast 10 digits."

#define AlertMessageValidMobile           @"*Please enter valid mobile number."
#define AlertMessageFullName          @"*Please enter your name."
#define AlertMessageMinValidName          @"*Name must be more than 2 characters."
#define AlertMessageValidFullName          @"*Please enter valid name."

#define AlertMessageAcceptTermsServices           @"*Please agree to terms & services."
#define AlertMessageDOB           @"*Please enter date of birth."
#define AlertMessageAddress           @"*Please enter address."

/**************************** Utility Class **************************/
#import "DatePickerSheetView.h"
#import "OptionsPickerSheetView.h"

/**************************** External Classes **************************/
#import "VSDropdown.h"
#import "TAPageControl.h"
#import "CarbonKit.h"
#import "TTRangeSlider.h"
#import "VSDropdown.h"
#import "NSDictionary+NullChecker.h"
#import "ServiceHelper_AF3.h"
#import "MBProgressHUD.h"

/**************************** View Controllers **************************/
#import "SignUpVC.h"
#import "SocialMediaSignUp.h"
#import "LoginVC.h"
#import "ForgotPasswordVC.h"
#import "TAAboutUsVC.h"
#import "CompleteProfile.h"
#import "TutorialVC.h"
#import "SidePannelVC.h"
#import "HomeVC.h"
#import "NotificationVC.h"
#import "ChangePasswordVC.h"
#import "SettingsVC.h"
#import "ReferFriendVC.h"
#import "LCBannerView.h"
#import "CACPTVC.h"
#import "FilterVC.h"
#import "SortVC.h"
#import "CAIPCVC.h"
#import "CAFinalsVC.h"
#import "MyVideosVC.h"
#import "MyTestVC.h"
#import "MyProfileVC.h"
#import "MyTestDetailsVC.h"
#import "MyVideosDetailsVC.h"
#import "SearchScreenVC.h"
#import "LogoutPopUpVC.h"
#import "QuestionForumVC.h"
#import "AskedQuestionVC.h"
#import "AskQuestionVC.h"
#import "CourseDetailsVC.h"
#import "SplashVideoVC.h"
#import "TestVideosListVC.h"
#import "PurchaseHistoryVC.h"
#import "SubSubjectVC.h"
#import "PurchaseHistoryDetailsVC.h"

/**************************** Cells **************************/
#import "SignUpTVCell.h"
#import "TutorialCVCell.h"
#import "SidePannelTVCell.h"
#import "NotificationTVCell.h"
#import "ChangePasswordTVCell.h"
#import "CACVCell.h"
#import "MyVideosTVCell.h"
#import "MyProfileTVCell.h"
#import "SearchTVCell.h"
#import "textViewTVCell.h"
#import "CourseDetailTVCell.h"
#import "HomeCVCell.h"
#import "TestVideosListTVCell.h"
#import "PurchaseHistoryTVCell.h"

/**************************** Category Classes **************************/
#import "NSString+Validator.h"
#import "UIView+Addition.h"
#import "AlertView.h"
#import "UIImageView+WebCache.h"
#import "TWMessageBarManager.h"

/**************************** App Delegate **************************/
#import "AppDelegate.h"

/**************************** Model Classes **************************/
#import "userInfo.h"
#import "CoursesInfo.h"

/**************************** FrameWorks **************************/
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <Bolts/Bolts.h>



/**************************** Social Login **************************/
#import "FacebookLogin.h"
#import "Reachability.h"

#import "Macro.h"


#endif /* Header_h */
