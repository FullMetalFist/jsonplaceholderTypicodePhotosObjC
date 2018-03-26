//
//  PhotosViewController.m
//  PhotosLargeAndSmall
//
//  Created by Michael Vilabrera on 3/26/18.
//  Copyright © 2018 Michael Vilabrera. All rights reserved.
//

#import "PhotosViewController.h"
#import "APIClient.h"

@interface PhotosViewController ()

@property (nonatomic, strong) APIClient *apiClient;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation PhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.apiClient = [[APIClient alloc] init];
    [self.apiClient fetchDataWithCompletionBlock:^(BOOL succeeded, NSArray *array) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (succeeded)
            {
                NSLog(@"%@", array);
            }
            else
            {
                NSLog(@"fetch data error");
            }
        });
    }];
}

- (void)createViews
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(100, 100);
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    [self.collectionView registerClass:[PhotoCollectionViewCell class] forCellWithReuseIdentifier:CELL_IDENTIFY];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.collectionView];
}

@end
