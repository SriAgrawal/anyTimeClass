//
//  TutorialVC.m
//  AnyTimeClass
//
//  Created by Aman Goswami on 14/01/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

#import "TutorialVC.h"
#import "Header.h"

@interface TutorialVC (){
    NSArray *images;
    int a;
}
@property (strong, nonatomic) IBOutlet UICollectionView *CollectionView;
@property (strong, nonatomic) IBOutlet UIButton *SkipButtonOutlet;
@property (strong, nonatomic) IBOutlet TAPageControl *dotPageControlView;



@end

@implementation TutorialVC
#pragma mark - View Life cycle.
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetUp];
}

-(void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
}

#pragma mark - Helper Class.
-(void) initialSetUp {
    [self.CollectionView registerNib:[UINib nibWithNibName:@"TutorialCVCell" bundle:nil] forCellWithReuseIdentifier:@"TutorialCVCell"];
    images=[NSArray arrayWithObjects:@"tut1",@"tut2",@"tut3",nil];
    _dotPageControlView.numberOfPages = 3;
    _dotPageControlView.dotImage = [UIImage imageNamed:@"cir_blank"];
    _dotPageControlView.currentDotImage = [UIImage imageNamed:@"cir_filled"];
    
}

#pragma mark - UICollectionView Delegate Methods

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return collectionView.frame.size;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 3;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TutorialCVCell *cell = [self.CollectionView dequeueReusableCellWithReuseIdentifier:@"TutorialCVCell" forIndexPath:indexPath];
    self.CollectionView.pagingEnabled = YES;
    cell.imageView.image = [UIImage imageNamed:[images objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark- UIScrollView Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = self.CollectionView.frame.size.width;
    self.dotPageControlView.currentPage = self.CollectionView.contentOffset.x / pageWidth;
    
    if (  self.dotPageControlView.currentPage == 2) {
        if (a==1) {
            LoginVC *controller = [[LoginVC alloc] initWithNibName:@"LoginVC" bundle:nil];
            [self.navigationController pushViewController:controller animated:YES];
        } else {
            a = 1;
            [self.SkipButtonOutlet setTitle:@"Done" forState:UIControlStateNormal];
        }
        
    } else {
        a=0;
        [self.SkipButtonOutlet setTitle:@"Skip" forState:UIControlStateNormal];
    }
}

#pragma mark - Button Action
- (IBAction)skipButtonAction:(id)sender {
    LoginVC *controller = [[LoginVC alloc] initWithNibName:@"LoginVC" bundle:nil];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - Memory management.
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
