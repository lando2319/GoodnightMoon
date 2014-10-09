//
//  ViewController.m
//  GoodnightMoon
//
//  Created by MM Driver on 10/9/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "ViewController.h"
#import "CollectionViewImageCell.h"

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollisionBehaviorDelegate>
@property NSMutableArray *moonImages;
@property NSMutableArray *sunImages;
@property NSMutableArray *currentImages;
@property (strong, nonatomic) IBOutlet UIView *shadeView;
@property UICollisionBehavior *collisionBehavior;
@property UIDynamicItemBehavior *dynamicItemBehavior;
@property UIGravityBehavior *gravityBehavior;
@property UIPushBehavior *pushBehavior;
@property (weak, nonatomic) IBOutlet UICollectionView *imageCollectionView;
@property UIDynamicAnimator *dynamicAnimator;
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

    self.sunImages = [NSMutableArray array];
    [self.sunImages addObject:[UIImage imageNamed:@"sun_1"]];
    [self.sunImages addObject:[UIImage imageNamed:@"sun_2"]];
    [self.sunImages addObject:[UIImage imageNamed:@"sun_3"]];
    [self.sunImages addObject:[UIImage imageNamed:@"sun_4"]];
    [self.sunImages addObject:[UIImage imageNamed:@"sun_5"]];
    [self.sunImages addObject:[UIImage imageNamed:@"sun_6"]];

    self.currentImages = self.moonImages;
}

- (IBAction)handlePan:(UIPanGestureRecognizer *)gesture
{
    CGPoint point = [gesture translationInView:gesture.view];
    CGFloat yVelocity = [gesture velocityInView:gesture.view].y;

    self.shadeView.center = CGPointMake(self.shadeView.center.x, self.shadeView.center.y + point.y);
    [gesture setTranslation:CGPointMake(0, 0) inView:gesture.view];

    if (gesture.state == UIGestureRecognizerStateEnded) {
        [self.dynamicAnimator updateItemUsingCurrentState:self.shadeView];

        if (yVelocity >= -500) {
            [self.gravityBehavior setGravityDirection:CGVectorMake(0, -1)];
            [self.dynamicItemBehavior setElasticity:0.5];
            [self.pushBehavior setPushDirection:CGVectorMake(0, [gesture velocityInView:gesture.view].y)];
        } else if (yVelocity >= -500 && yVelocity < 0) {
            [self.gravityBehavior setGravityDirection:CGVectorMake(0, -1)];
            [self.dynamicItemBehavior setElasticity:0.25];
            [self.pushBehavior setPushDirection:CGVectorMake(0, -500)];
        } else if (yVelocity >= 0 && yVelocity < 500) {
            [self.gravityBehavior setGravityDirection:CGVectorMake(0, 1)];
            [self.dynamicItemBehavior setElasticity:0.25];
            [self.pushBehavior setPushDirection:CGVectorMake(0, 500)];
        } else {
            [self.gravityBehavior setGravityDirection:CGVectorMake(0, 1)];
            [self.dynamicItemBehavior setElasticity:0.5];
            [self.pushBehavior setPushDirection:CGVectorMake(0, [gesture velocityInView:gesture.view].y)];
        }

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.currentImages.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
     CollectionViewImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];

    cell.imageView.image = [self.currentImages objectAtIndex:indexPath.row];
    return cell;
}

-(void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p
{
    self.currentImages = self.sunImages;
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.0];
}

-(void)loadData
{
    [self.imageCollectionView reloadData];
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.dynamicAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    self.collisionBehavior = [[UICollisionBehavior alloc] initWithItems:[NSArray arrayWithObject:self.shadeView]];
    self.gravityBehavior = [[UIGravityBehavior alloc] initWithItems:[NSArray arrayWithObject:self.shadeView]];
    self.dynamicItemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:[NSArray arrayWithObject:self.shadeView]];
    self.pushBehavior = [[UIPushBehavior alloc] initWithItems:[NSArray arrayWithObject:self.shadeView] mode:UIPushBehaviorModeContinuous];

    [self.collisionBehavior addBoundaryWithIdentifier:@"bottom"
                                            fromPoint:CGPointMake(-10, self.view.frame.size.height)
                                              toPoint:CGPointMake(self.view.frame.size.width - 20, self.view.frame.size.height)];

    self.collisionBehavior.collisionDelegate = self;

    [self.gravityBehavior setGravityDirection:CGVectorMake(0, 0)];
    [self.dynamicItemBehavior setElasticity:0.25];
    [self.dynamicAnimator addBehavior:self.collisionBehavior];
    [self.dynamicAnimator addBehavior:self.gravityBehavior];
    [self.dynamicAnimator addBehavior:self.pushBehavior];
    [self.dynamicAnimator addBehavior:self.dynamicItemBehavior];
}

@end
