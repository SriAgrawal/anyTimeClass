//
//  FilterVC.m
//  AnyTimeClass
//
//  Created by Aman Goswami on 17/01/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

#import "FilterVC.h"
#import "Header.h"

@interface FilterVC ()<CAAnimationDelegate, TTRangeSliderDelegate,VSDropdownDelegate>{
    NSMutableArray *itemArray;
}
@property (strong, nonatomic) IBOutlet UITextField *subjectTextField;
@property (weak, nonatomic) IBOutlet TTRangeSlider *sliderView;
@property (strong, nonatomic) VSDropdown *dropdown;
@property (strong, nonatomic) IBOutlet UIButton *subjectBtnOutlet;

@end

@implementation FilterVC
#pragma mark -  View Life Cycle.
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.sliderView setDelegate:self];
    //// Drop Down
    _dropdown = [[VSDropdown alloc]initWithDelegate:self];
    [_dropdown setAdoptParentTheme:YES];
    [_dropdown setShouldSortItems:YES];
    ///// Array initalization.
    itemArray  = [[NSMutableArray alloc] initWithObjects:@"Maths",@"Accounts",@"Economics", nil];
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

#pragma mark - Memory management.
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - VSDropdown Delegate methods.
- (void)dropdown:(VSDropdown *)dropDown didChangeSelectionForValue:(NSString *)str atIndex:(NSUInteger)index selected:(BOOL)selected {
    
    NSString *allSelectedItems = nil;
    if (dropDown.selectedItems.count > 1) {
        allSelectedItems = [dropDown.selectedItems componentsJoinedByString:@";"];
    } else {
        allSelectedItems = [dropDown.selectedItems firstObject];
    }
    self.subjectTextField.text = allSelectedItems;
}

- (UIColor *)outlineColorForDropdown:(VSDropdown *)dropdown {
    UIButton *btn = (UIButton *)dropdown.dropDownView;
    return btn.titleLabel.textColor;
}

- (CGFloat)outlineWidthForDropdown:(VSDropdown *)dropdown {
    return 2.0;
}

- (CGFloat)cornerRadiusForDropdown:(VSDropdown *)dropdown {
    return 3.0;
}

- (CGFloat)offsetForDropdown:(VSDropdown *)dropdown {
    return -2.0;
}

-(void)showDropDownForButton:(UIButton *)sender adContents:(NSArray *)contents multipleSelection:(BOOL)multipleSelection {
    [_dropdown setDrodownAnimation:rand()%2];
    [_dropdown setAllowMultipleSelection:multipleSelection];
    [_dropdown setupDropdownForView:sender];
    [_dropdown setBorderColor:[UIColor lightGrayColor]];
    [_dropdown setSeparatorColor:[UIColor lightGrayColor]];
    [_dropdown reloadDropdownWithContents:contents andSelectedItems:[NSArray array]];
}

#pragma mark - Button Action.
- (IBAction)applyBtnAction:(id)sender {
    [self.view endEditing:YES];
    [self AnimationFromTopToBottom];
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)cancelBtnAction:(id)sender {
    [self.view endEditing:YES];
    [self AnimationFromTopToBottom];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)subjectBtnAction:(id)sender {
    self.subjectBtnOutlet.selected = !self.subjectBtnOutlet.selected;
    [self showDropDownForButton:sender adContents:itemArray multipleSelection:NO];
}
- (IBAction)crossBtnAction:(id)sender {
    [self.view endEditing:YES];
    [self AnimationFromTopToBottom];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -  Slider.
-(void)rangeSlider:(TTRangeSlider *)sender didChangeSelectedMinimumValue:(float)selectedMinimum andMaximumValue:(float)selectedMaximum {
    
}

@end
