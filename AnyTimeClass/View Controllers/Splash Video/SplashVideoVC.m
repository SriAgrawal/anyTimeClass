//
//  SplashVideoVC.m
//  AnyTimeClass
//
//  Created by Aman Goswami on 20/01/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

#import "SplashVideoVC.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "Header.h"
@interface SplashVideoVC (){
    AVPlayer *avPlayer;
    BOOL status;
}
@property (weak, nonatomic) IBOutlet UIView *videoView;
@end

@implementation SplashVideoVC
#pragma mark - View Life Cycle.
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetup];
}

#pragma mark - Helper Class
-(void) initialSetup {
    ///// Player setup.
    // your filepath which is may be "http" type
    NSURL *basEURL = [[NSBundle mainBundle] URLForResource:@"dummyVideo" withExtension:@"mp4"];
    AVAsset * avAsset = [AVAsset assetWithURL:basEURL];
    AVPlayerItem *avPlayerItem =[[AVPlayerItem alloc]initWithAsset:avAsset];
    
    avPlayer = [[AVPlayer alloc]initWithPlayerItem:avPlayerItem];
    AVPlayerLayer *avPlayerLayer =[AVPlayerLayer playerLayerWithPlayer:avPlayer];
    avPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [avPlayerLayer setFrame:CGRectMake(self.videoView.frame.origin.x, self.videoView.frame.origin.y, WIN_WIDTH,WIN_HEIGHT)];;
    [self.videoView.layer addSublayer:avPlayerLayer];
    [avPlayer seekToTime:kCMTimeZero];
    NSLog(@"My view frame: %@", NSStringFromCGRect(_videoView.frame));
    
    [avPlayer play];
    status = YES;
    [self performSelector:@selector(changeLabel:) withObject:nil afterDelay:10.30];
}

-(void)changeLabel: (id) sender {
    [avPlayer pause];
    if (status == NO) {
        
    } else {
        TutorialVC *myVC = [[TutorialVC alloc] initWithNibName:@"TutorialVC" bundle:nil];
        [self.navigationController pushViewController:myVC animated:NO];
    }
}

#pragma mark - Button Action.

- (IBAction)nextBtnAction:(id)sender {
    [avPlayer pause];
    status = NO;
    TutorialVC *myVC = [[TutorialVC alloc] initWithNibName:@"TutorialVC" bundle:nil];
    [self.navigationController pushViewController:myVC animated:NO];
}

#pragma mark - memory management.
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
