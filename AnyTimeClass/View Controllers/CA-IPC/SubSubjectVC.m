//
//  SubSubjectVC.m
//  AnyTimeClass
//
//  Created by Aman Goswami on 22/02/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

#import "SubSubjectVC.h"
#import "Header.h"

@interface SubSubjectVC ()<CAAnimationDelegate>
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@end

@implementation SubSubjectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpPages];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - pages Setup.
- (void)setUpPages {
    ///// cell register
    [self.collectionView registerNib:[UINib nibWithNibName:@"CACVCell" bundle:nil] forCellWithReuseIdentifier:@"CACVCell"];
}

#pragma mark - Animation.
-(void) AnimationFromTopToBottom {
    CATransition *animation = [CATransition animation];
    [animation setDelegate:self];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromBottom];
    [animation setDuration:0.65f];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [[self.navigationController.view layer] addAnimation:animation forKey:@"AnimationFromBottomToTop"];
}


#pragma collectionView Delgate and DataSource
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return self.subSubjectArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CACVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CACVCell" forIndexPath:indexPath];\
    CoursesInfo *info = [self.subSubjectArray objectAtIndex:indexPath.row];
    [cell.backImageView sd_setImageWithURL:[NSURL URLWithString:info.subjectImage] placeholderImage:[UIImage imageNamed:@"img1"]];
    cell.subjectLabel.text = info.subjectName;
    if (![info.subjectMarks isEqualToString:@""]) {
        cell.marksLabel.text = [NSString stringWithFormat:@"%@ marks", info.subjectMarks];
    } else {
        cell.marksLabel.text = @"";
    }
    if ([info.subjectPrice isEqualToString:@"Free"] ||[info.subjectPrice isEqualToString:@"Demo"]) {
        cell.amountLabel.text = info.subjectPrice;
    } else {
        cell.amountLabel.text = [NSString stringWithFormat:@"₹ %@", info.subjectPrice ];
    }
    return cell;
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(collectionView.frame.size.width/2.02, 170);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
    CoursesInfo *objCourseInfo = [self.subSubjectArray objectAtIndex:indexPath.item];
        CourseDetailsVC *myVC = [[CourseDetailsVC alloc] initWithNibName:@"CourseDetailsVC" bundle:nil];
        myVC.fromSearch = NO;
        myVC.subjectID = objCourseInfo.subjectID;
        [self.navigationController pushViewController:myVC animated:YES];
}
#pragma mark - Button Action.
- (IBAction)crossBtnAction:(id)sender {
    [self.view endEditing:YES];
    [self AnimationFromTopToBottom];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
