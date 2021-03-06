//
//  DatePickerSheetView.m
//  VPW
//
//  Created by Sunil Verma on 9/30/14.
//  Copyright (c) 2014 Halosys. All rights reserved.
//

#import "DatePickerSheetView.h"

@implementation DatePickerSheetView


PickerPickDateBlock datePickerBlock;
UIDatePicker *datePicker;
UIView *bgView;
static DatePickerSheetView *datePickerManager = nil;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}

//Birthday Date Picker
+(void)showDateOfBirth:(NSDate *)date AndTimeZone:(NSString *)timeZone datePickerType:(UIDatePickerMode)type WithReturnDate :(PickerPickDateBlock)block
{
    AppDelegate *appDel = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    datePickerBlock = [block copy];
    
    datePickerManager = [[DatePickerSheetView alloc] init];
    
    
    datePicker = [[UIDatePicker alloc] init];
    [datePicker setDatePickerMode:type];
    [datePicker setMinuteInterval:15];
    [datePicker setBackgroundColor:[UIColor whiteColor]];
    [datePickerManager addSubview:datePicker];
    [datePickerManager setBackgroundColor:[UIColor whiteColor]];
    
    UIButton *leftCancle = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftCancle setFrame:CGRectMake(5, 10, 60, 30)];
    [leftCancle setTitleColor:[UIColor colorWithRed:0.0/255.0 green:148.0/255.0 blue:251.0/255.0 alpha:1.f] forState:UIControlStateNormal];
    [leftCancle setTitle:@"Cancel" forState:UIControlStateNormal];
    [leftCancle addTarget:self action:@selector(cancelActionSheet:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *rightDone = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightDone setFrame:CGRectMake(appDel.window.frame.size.width-55, 10, 50, 30)];
    [rightDone setTitleColor:[UIColor colorWithRed:0.0/255.0 green:148.0/255.0 blue:251.0/255.0 alpha:1.f] forState:UIControlStateNormal];
    [rightDone setTitle:@"Done" forState:UIControlStateNormal];
    [rightDone addTarget:self action:@selector(doneActionSheet:) forControlEvents:UIControlEventTouchUpInside];
    
    [datePickerManager addSubview:leftCancle];
    [datePickerManager addSubview:rightDone];
    
    [datePicker setFrame:CGRectMake(0, 40, appDel.window.frame.size.width, 240)];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [datePicker setLocale:locale];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:-18];
    NSDate *maxDate = [gregorian dateByAddingComponents:comps toDate:currentDate  options:0];
    [comps setYear:0];
    NSDate *defaultDate = [gregorian dateByAddingComponents:comps toDate:[NSDate dateWithTimeIntervalSince1970:385650305]  options:0];

    datePicker.minimumDate = nil;
    datePicker.maximumDate = maxDate;

    
    if (date) {
        [datePicker setDate:date animated:YES];
    }else
        [datePicker setDate:defaultDate animated:YES];
    
    if(timeZone)
    {
        [datePicker setTimeZone:[NSTimeZone timeZoneWithName:timeZone]];
        
    }else
    {
        [datePicker setTimeZone:[NSTimeZone systemTimeZone]];
    }
    
    bgView = [[UIView alloc] initWithFrame:appDel.window.bounds];
    [bgView setBackgroundColor:[UIColor blackColor]];
    [bgView setAlpha:0.0];
    
    
    datePickerManager.frame = CGRectMake(0, appDel.window.frame.size.height, appDel.window.frame.size.width, 280);
    [appDel.window addSubview:bgView];
    
    [appDel.window addSubview:datePickerManager];
    [appDel.window bringSubviewToFront:datePickerManager];
    
    [UIView animateWithDuration:0.3 delay:0.0 usingSpringWithDamping:0.9 initialSpringVelocity:0.9 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
        datePickerManager.frame = CGRectMake(0, appDel.window.frame.size.height -280, appDel.window.frame.size.width, 280);
        [bgView setAlpha:0.6];
        
    } completion:^(BOOL finished) {
        
    }];
    
    
}


//Date Picker
+(void)showDatePickerWithDate:(NSDate *)date AndTimeZone:(NSString *)timeZone datePickerType:(UIDatePickerMode)type WithReturnDate :(PickerPickDateBlock)block
{
    AppDelegate *appDel = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    datePickerBlock = [block copy];
    
    datePickerManager = [[DatePickerSheetView alloc] init];
    
    
    datePicker = [[UIDatePicker alloc] init];
    [datePicker setDatePickerMode:type];
    
    [datePicker setBackgroundColor:[UIColor whiteColor]];
    [datePickerManager addSubview:datePicker];
    [datePickerManager setBackgroundColor:[UIColor whiteColor]];
    
    UIButton *leftCancle = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftCancle setFrame:CGRectMake(5, 10, 60, 30)];
    [leftCancle setTitleColor:[UIColor colorWithRed:0.0/255.0 green:148.0/255.0 blue:251.0/255.0 alpha:1.f] forState:UIControlStateNormal];
    [leftCancle setTitle:@"Cancel" forState:UIControlStateNormal];
    [leftCancle addTarget:self action:@selector(cancelActionSheet:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *rightDone = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightDone setFrame:CGRectMake(appDel.window.frame.size.width-55, 10, 50, 30)];
    [rightDone setTitleColor:[UIColor colorWithRed:0.0/255.0 green:148.0/255.0 blue:251.0/255.0 alpha:1.f] forState:UIControlStateNormal];
    [rightDone setTitle:@"Done" forState:UIControlStateNormal];
    [rightDone addTarget:self action:@selector(doneActionSheet:) forControlEvents:UIControlEventTouchUpInside];
    
    [datePickerManager addSubview:leftCancle];
    [datePickerManager addSubview:rightDone];
    
    [datePicker setFrame:CGRectMake(0, 40, appDel.window.frame.size.width, 240)];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [datePicker setLocale:locale];
    
    
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:[NSDate date]];
    [comps setYear:[comps year] - 100];
    datePicker.minimumDate = [gregorian dateFromComponents:comps];
    datePicker.maximumDate = [NSDate date];
    
    
    
    
    if (date) {
        [datePicker setDate:date animated:YES];
    }else
        [datePicker setDate:[NSDate date] animated:YES];
    
    if(timeZone)
    {
        [datePicker setTimeZone:[NSTimeZone timeZoneWithName:timeZone]];
        
    }else
    {
        [datePicker setTimeZone:[NSTimeZone systemTimeZone]];
    }
    appDel = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    bgView = [[UIView alloc] initWithFrame:appDel.window.bounds];
    [bgView setBackgroundColor:[UIColor blackColor]];
    [bgView setAlpha:0.0];
    
    
    datePickerManager.frame = CGRectMake(0, appDel.window.frame.size.height, appDel.window.frame.size.width, 280);
    [appDel.window addSubview:bgView];
    
    [appDel.window addSubview:datePickerManager];
    [appDel.window bringSubviewToFront:datePickerManager];
    
    [UIView animateWithDuration:0.3 delay:0.0 usingSpringWithDamping:0.9 initialSpringVelocity:0.9 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
        datePickerManager.frame = CGRectMake(0, appDel.window.frame.size.height -280, appDel.window.frame.size.width, 280);
        [bgView setAlpha:0.6];
        
    } completion:^(BOOL finished) {
        
    }];
    
    
}
+(void)cancelActionSheet:(id)sender{
//    datePickerBlock(nil);
    bgView.hidden=YES;
    [self removePickerView];
}/*
  +(void)cancelActionSheet:(id)sender
  {
  
  pickerBlock(nil);
  [DatePickerSheetView removePickerView];
  
  
  }*/


+(void)removePickerView
{
    AppDelegate *appDel = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [UIView animateWithDuration:0.1 animations:^{
        datePickerManager.frame = CGRectMake(0, appDel.window.frame.size.height -260, 320, 260);
        
    } completion:^(BOOL finished) {
        for (id obj  in datePickerManager.subviews) {
            [obj removeFromSuperview];
        }
        [datePickerManager removeFromSuperview];
        datePickerManager =nil;
        [[appDel.window viewWithTag:11] removeFromSuperview];
    }];
    
    
}
#pragma mark - Action Sheet Callback function

#pragma mark - Action Sheet Callback function
+(void)doneActionSheet:(id)sender{
    
    datePickerBlock(datePicker.date);
    bgView.hidden=YES;
    
    [DatePickerSheetView removePickerView];
}
/*
 +(void)doneActionSheet:(id)sender{
 
 
 pickerBlock(datePicker.date);
 
 [DatePickerSheetView removePickerView];
 
 }
 */
@end
