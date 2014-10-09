//
//  ViewController.m
//  GoodnightMoon
//
//  Created by MM Driver on 10/9/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "ViewController.h"
#import "CollectionViewImageCell.h"

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property NSMutableArray *moonImages;
@property (strong, nonatomic) IBOutlet UIView *shadeView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.moonImages = [NSMutableArray array];
    [self.moonImages addObject:[UIImage imageNamed:@"moon_1"]];
    [self.moonImages addObject:[UIImage imageNamed:@"moon_2"]];
    [self.moonImages addObject:[UIImage imageNamed:@"moon_3"]];
    [self.moonImages addObject:[UIImage imageNamed:@"moon_4"]];
    [self.moonImages addObject:[UIImage imageNamed:@"moon_5"]];
    [self.moonImages addObject:[UIImage imageNamed:@"moon_6"]];
}

- (IBAction)handlePan:(UIPanGestureRecognizer *)gesture
{
    CGPoint point = [gesture translationInView:gesture.view];
    self.shadeView.center = CGPointMake(self.shadeView.center.x, self.shadeView.center.y + point.y);
    [gesture setTranslation:CGPointMake(0, 0) inView:gesture.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.moonImages.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
     CollectionViewImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];

    cell.imageView.image = [self.moonImages objectAtIndex:indexPath.row];
    return cell;
}
@end
