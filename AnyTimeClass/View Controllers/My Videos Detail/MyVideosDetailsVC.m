//
//  MyVideosDetailsVC.m
//  AnyTimeClass
//
//  Created by Aman Goswami on 18/01/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

#import "MyVideosDetailsVC.h"
#import "Header.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import <PayUmoney_SDK/PayUmoney_SDK.h>
#import <CommonCrypto/CommonDigest.h>

@interface MyVideosDetailsVC ()<CAAnimationDelegate> {
    NSMutableArray *subjectArray;
    CoursesInfo *objModel;
}
@property (strong, nonatomic) IBOutlet UILabel *videoLabel;
@property (strong, nonatomic) IBOutlet UILabel *amountLabel;

@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *likeBtnOutlet;
@property (strong, nonatomic) IBOutlet UILabel *likesLabel;
@property (strong, nonatomic) IBOutlet UILabel *courseName;
@property (strong, nonatomic) IBOutlet UILabel *subjectName;
@property (strong, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (strong, nonatomic) IBOutlet UIImageView *bannerImage;
@property (strong, nonatomic) NSString *videoLink;
@property (strong, nonatomic) PUMRequestParams *param;
@end

@implementation MyVideosDetailsVC
#pragma mark - View Life Cycle.
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableHeaderView= self.headerView;
    self.tableView.tableFooterView = self.footerView;
    subjectArray = [NSMutableArray array];
    objModel = [[CoursesInfo alloc] init];
    /////// Api Call
    [self callApiForVideosDetails];
    self.likesLabel.text = [NSString stringWithFormat:@"52564 likes"];
}
#pragma mark - Memory Management.
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark -  Animation.
-(void) AnimationFromTopToBottom {
    CATransition *animation = [CATransition animation];
    [animation setDelegate:self];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromBottom];
    [animation setDuration:0.65f];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [[self.navigationController.view layer] addAnimation:animation forKey:@"AnimationFromBottomToTop"];
}


#pragma mark - Button Action.
- (IBAction)crossBtnAction:(id)sender {
    [self.view endEditing:YES];
    [self AnimationFromTopToBottom];
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)likeBtnAction:(id)sender {
    [self.view endEditing:YES];
    if (self.likeBtnOutlet.selected == YES) {
        self.likeBtnOutlet.selected = NO;
    } else {
        self.likeBtnOutlet.selected = YES;
    }
}

- (IBAction)playVideoBtnAction:(UIButton *)sender {
    if ([objModel.price isEqualToString:@"Free"]) {
        AVPlayer *player = [AVPlayer playerWithURL:[NSURL URLWithString:objModel.videolink]];
        AVPlayerViewController *playerViewController = [AVPlayerViewController new];
        playerViewController.player = player;
        [self presentViewController:playerViewController animated:YES completion:nil];
    } else {
        [self callApiForWatchVideo];
    }
}

#pragma mark - Webservices.

-(void) callApiForVideosDetails{
    NSMutableDictionary *user_dict = [NSMutableDictionary dictionary];
    
    [user_dict setValue:[NSUSERDEFAULTS valueForKey:kuid] forKey:kuid];
    [user_dict setValue:self.videoID forKey:kvideoId];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:user_dict AndPath:kvideoDetail WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        if (suceeded) {
            
            NSString *responseCode = [response objectForKeyNotNull:kresponseCode expectedClass:[NSString class]];
            NSString *responseMessage = [response objectForKeyNotNull:kresponseMessage expectedClass:[NSString class]];
            
            if (responseCode.integerValue == KSuccessCode) {
                
                [subjectArray removeAllObjects];
                NSDictionary *subjectListArray = [response objectForKeyNotNull:@"subjectList" expectedClass:[NSArray class]];
                for (NSDictionary  *subjectDict in subjectListArray) {
                    objModel = [CoursesInfo parseVideoList:subjectDict];
                }
                self.likesLabel.text = [NSString stringWithFormat:@"%@ likes",objModel.totalLikes];
                self.subjectName.text = objModel.subjectName;
                self.courseName.text = objModel.courseName;
                self.descriptionTextView.text = objModel.videoDescription;
                self.videoLink = objModel.videolink;
                self.videoLabel.text = objModel.videoName;
                self.price = objModel.price;
                if ([objModel.price isEqualToString:@"Free"] ||[objModel.price isEqualToString:@"Demo"]) {
                    self.amountLabel.text = objModel.price;
                } else if ([objModel.price isEqualToString:@""]) {
                    self.amountLabel.text = [NSString stringWithFormat:@"₹ 0"];
                } else {
                    self.amountLabel.text = [NSString stringWithFormat:@"₹ %@", objModel.price ];
                }
                [self.bannerImage sd_setImageWithURL:[NSURL URLWithString:objModel.videothumbnail ] placeholderImage:[UIImage imageNamed:@"ban1"]];
            } else if (responseCode.integerValue == KLogoutCode) {
                [[AlertView sharedManager] displayInformativeAlertwithTitle:@"Error!" andMessage:responseMessage onController:self];
                [APP_DELEGATE logout];
                [[APP_DELEGATE navController] popToRootViewControllerAnimated:YES];
                
            } else{
                [[AlertView sharedManager] displayInformativeAlertwithTitle:@"Error!" andMessage:responseMessage onController:self];
                
            }
        }else{
            NSError *error = [response objectForKeyNotNull:@"Error" expectedClass:[NSError class]];
            
            if (error != nil) {
                
                [[AlertView sharedManager] displayInformativeAlertwithTitle:@"Error!" andMessage:error.localizedDescription onController:self];
            }else{
                [[AlertView sharedManager] displayInformativeAlertwithTitle:@"Error!" andMessage:KError_Message onController:self];
            }
        }
    }];
}


-(void) callApiForWatchVideo{
    NSMutableDictionary *user_dict = [NSMutableDictionary dictionary];
    
    [user_dict setValue:[NSUSERDEFAULTS valueForKey:kuid] forKey:kuid];
    [user_dict setValue:self.videoID forKey:kvideoId];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:user_dict AndPath:kwatchVideo WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        if (suceeded) {
            
            NSString *responseCode = [response objectForKeyNotNull:kresponseCode expectedClass:[NSString class]];
            NSString *responseMessage = [response objectForKeyNotNull:kresponseMessage expectedClass:[NSString class]];
            
            if (responseCode.integerValue == KSuccessCode) {
                
                AVPlayer *player = [AVPlayer playerWithURL:[NSURL URLWithString:objModel.videolink]];
                AVPlayerViewController *playerViewController = [AVPlayerViewController new];
                playerViewController.player = player;
                [self presentViewController:playerViewController animated:YES completion:nil];
                
            } else if (responseCode.integerValue == 0) {
                 [self showAlertViewWithTitle:@"Message" message:@"Please buy the video again."];
//                [self setPaymentParameters];
//                
//                
//                //Start the payment flow
//                PUMMainVController *paymentVC = [[PUMMainVController alloc] init];
//                UINavigationController *paymentNavController = [[UINavigationController alloc] initWithRootViewController:paymentVC];
//                
//                [self presentViewController:paymentNavController
//                                   animated:YES
//                                 completion:nil];
                
            }
            else if (responseCode.integerValue == KLogoutCode) {
                [[AlertView sharedManager] displayInformativeAlertwithTitle:@"Error!" andMessage:responseMessage onController:self];
                [APP_DELEGATE logout];
                [[APP_DELEGATE navController] popToRootViewControllerAnimated:YES];
                
            } else{
                [[AlertView sharedManager] displayInformativeAlertwithTitle:@"Error!" andMessage:responseMessage onController:self];
                
            }
        }else{
            NSError *error = [response objectForKeyNotNull:@"Error" expectedClass:[NSError class]];
            
            if (error != nil) {
                
                [[AlertView sharedManager] displayInformativeAlertwithTitle:@"Error!" andMessage:error.localizedDescription onController:self];
            }else{
                [[AlertView sharedManager] displayInformativeAlertwithTitle:@"Error!" andMessage:KError_Message onController:self];
            }
        }
    }];
}

-(void) callApiForRenewVideo{
    NSMutableDictionary *user_dict = [NSMutableDictionary dictionary];
    
    [user_dict setValue:[NSUSERDEFAULTS valueForKey:kuid] forKey:kuid];
    [user_dict setValue:self.videoID forKey:kvideoId];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:user_dict AndPath:krenewVideo WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        if (suceeded) {
            
            NSString *responseCode = [response objectForKeyNotNull:kresponseCode expectedClass:[NSString class]];
            NSString *responseMessage = [response objectForKeyNotNull:kresponseMessage expectedClass:[NSString class]];
            
            if (responseCode.integerValue == KSuccessCode) {
                
                
                
            } else if (responseCode.integerValue == 0) {
                
                
            }
            else if (responseCode.integerValue == KLogoutCode) {
                [[AlertView sharedManager] displayInformativeAlertwithTitle:@"Error!" andMessage:responseMessage onController:self];
                [APP_DELEGATE logout];
                [[APP_DELEGATE navController] popToRootViewControllerAnimated:YES];
                
            } else{
                [[AlertView sharedManager] displayInformativeAlertwithTitle:@"Error!" andMessage:responseMessage onController:self];
                
            }
        }else{
            NSError *error = [response objectForKeyNotNull:@"Error" expectedClass:[NSError class]];
            
            if (error != nil) {
                
                [[AlertView sharedManager] displayInformativeAlertwithTitle:@"Error!" andMessage:error.localizedDescription onController:self];
            }else{
                [[AlertView sharedManager] displayInformativeAlertwithTitle:@"Error!" andMessage:KError_Message onController:self];
            }
        }
    }];
}

#pragma mark - PayU Integration.
- (void)setPaymentParameters {
    [PUMRequestParams resetPUMRequestParamsSharedInstance];
    self.param = [PUMRequestParams sharedParams];
    self.param.environment = PUMEnvironmentTest;
    self.param.amount =[NSString stringWithFormat:@"%@", self.price ];
    self.param.key = @"SD8RiOL0";
    self.param.merchantid = @"5750685";
    self.param.txnid = [self  getRandomString:2];
    self.param.surl = @"https://www.payumoney.com/mobileapp/payumoney/success.php";
    self.param.furl = @"https://www.payumoney.com/mobileapp/payumoney/failure.php";
    self.param.delegate = self;
    self.param.firstname = @"abcd";
    self.param.productinfo = @"Nice product.";
    self.param.email = @"abcd@gmail.com";
    self.param.phone = @"";
    
    //Below parameters are optional. It is to store any information you would like to save in PayU Database regarding trasnsaction. If you do not intend to store any additional info, set below param as empty strings.
    
    self.param.udf1 = @"";
    self.param.udf2 = @"";
    self.param.udf3 = @"";
    self.param.udf4 = @"";
    self.param.udf5 = @"";
    self.param.udf6 = @"";
    self.param.udf7 = @"";
    self.param.udf8 = @"";
    self.param.udf9 = @"";
    self.param.udf10 = @"";
    
    self.param.hashValue = [self getHash];
    
}



- (NSString *)getRandomString:(NSInteger)length {
    NSMutableString *returnString = [NSMutableString stringWithCapacity:length];
    NSString *numbers = @"0123456789";
    
    // First number cannot be 0
    [returnString appendFormat:@"%C", [numbers characterAtIndex:(arc4random() % ([numbers length]-1))+1]];
    
    for (int i = 1; i < length; i++) {
        [returnString appendFormat:@"%C", [numbers characterAtIndex:arc4random() % [numbers length]]];
    }
    return returnString;
}


#pragma mark - Never Generate hash from app
/*!
 Keeping salt in the app is a big security vulnerability. Never do this. Following function is just for demonstratin purpose
 In code below, salt Je7q3652 is mentioned. Never do this in prod app. You should get the hash from your server.
 */



- (NSString*)getHash {
    NSString *hashSequence = [NSString stringWithFormat:@"dRQuiA|%@|%@|%@|%@|%@|||||||||||teEkuVg2",self.param.txnid, self.param.amount, self.param.productinfo,self.param.firstname, self.param.email];
    
    NSString *rawHash = [[self createSHA512:hashSequence] description];
    NSString *hash = [[[rawHash stringByReplacingOccurrencesOfString:@"<" withString:@""]stringByReplacingOccurrencesOfString:@">" withString:@""]stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    
    
    return hash;
}

- (NSData *) createSHA512:(NSString *)source {
    
    const char *s = [source cStringUsingEncoding:NSASCIIStringEncoding];
    NSData *keyData = [NSData dataWithBytes:s length:strlen(s)];
    uint8_t digest[CC_SHA512_DIGEST_LENGTH] = {0};
    CC_SHA512(keyData.bytes, (CC_LONG)keyData.length, digest);
    
    NSData *output = [NSData dataWithBytes:digest length:CC_SHA512_DIGEST_LENGTH];
    NSLog(@"out --------- %@",output);
    return output;
}



#pragma mark - Completeion callbacks

-(void)transactionCompletedWithResponse:(NSDictionary*)response
                       errorDescription:(NSError* )error {
    
    
    [self dismissViewControllerAnimated:YES completion:^{
        [self showAlertViewWithTitle:@"Message" message:@"congrats! Payment is Successful"];
         [self callApiForRenewVideo];
        
    }];
    
}

/*!
 * Transaction failure occured. Check Payment details in response. error shows any error
 if api failed.
 */
-(void)transactinFailedWithResponse:(NSDictionary* )response
                   errorDescription:(NSError* )error {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self showAlertViewWithTitle:@"Message" message:@"Oops!!! Payment Failed"];
}

-(void)transactinExpiredWithResponse: (NSString *)msg {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self showAlertViewWithTitle:@"Message" message:@"Trasaction expired!"];
}

/*!
 * Transaction cancelled by user.
 */
-(void)transactinCanceledByUser {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self showAlertViewWithTitle:@"Message" message:@"Payment Cancelled!"];
}

#pragma mark - Helper methods

- (void)showAlertViewWithTitle:(NSString*)title message:(NSString*)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    
    [self presentViewController:alertController animated:YES completion:nil];
}



@end
