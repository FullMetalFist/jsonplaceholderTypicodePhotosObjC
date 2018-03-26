//
//  PhotosViewController.m
//  PhotosLargeAndSmall
//
//  Created by Michael Vilabrera on 3/26/18.
//  Copyright © 2018 Michael Vilabrera. All rights reserved.
//

#import "PhotosViewController.h"
#import "APIClient.h"
#import "Constants.h"
#import "PhotoCollectionViewCell.h"

@interface PhotosViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate>

//@property (nonatomic, strong) APIClient *apiClient;
@property (nonatomic, strong) NSArray *photosArray;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableDictionary *imageDownloadInProgress;
@property (nonatomic, strong) NSCache *imagesDownloaded;

@end

@implementation PhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createViews];
    
    self.photosArray = [NSArray array];
    self.imageDownloadInProgress = [NSMutableDictionary dictionary];
    
    APIClient *apiClient = [[APIClient alloc] init];
    [apiClient fetchDataWithCompletionBlock:^(BOOL succeeded, NSArray *array) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (succeeded)
            {
                self.photosArray = array;
                [self.collectionView reloadData];
            }
            else
            {
                NSLog(@"fetch data error");
            }
        });
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [self clearCache];
}

- (void)dealloc
{
    [self clearCache];
}

- (void)clearCache
{
    [self.imagesDownloaded removeAllObjects];
    NSArray *allDownloads = [self.imageDownloadInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
    [self.imageDownloadInProgress removeAllObjects];
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

- (void)startIconDownload:(PhotoModel *)photoModel forIndexPath:(NSIndexPath *)indexPath
{
    APIClient *apiClient = (self.imageDownloadInProgress)[indexPath];
    if (apiClient == nil)
    {
        apiClient = [[APIClient alloc] init];
        apiClient.photoModel = photoModel;
        [apiClient setCompletionHandler:^{
            
            PhotoCollectionViewCell *cell = (PhotoCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
//            [self.imagesDownloaded setObject:(nonnull id) forKey:<#(nonnull id)#>
            cell.image = [_imagesDownloaded objectForKey:photoModel.ID];
            [self.imageDownloadInProgress removeObjectForKey:indexPath];
        }];
        (self.imageDownloadInProgress)[indexPath] = apiClient;
        [apiClient startDownload];
    }
}

- (void)loadImagesForOnscreenCells
{
    if (self.photosArray.count > 0)
    {
        NSArray *visibleCells = [self.collectionView indexPathsForVisibleItems];
        for (NSIndexPath *indexPath in visibleCells)
        {
            PhotoModel *photoModel = (self.photosArray)[indexPath.row];
            if (![_imagesDownloaded objectForKey:photoModel.ID])
            {
                [self startIconDownload:photoModel forIndexPath:indexPath];
            }
        }
    }
}

#pragma MARK: UICollectionView methods

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFY forIndexPath:indexPath];
    
    if (self.photosArray.count > 0)
    {
        PhotoModel *pModel = (self.photosArray)[indexPath.row];
        if (![_imagesDownloaded valueForKey:pModel.ID])
        {
            if (self.collectionView.dragging == NO && self.collectionView.decelerating == NO)
            {
                [self startIconDownload:pModel forIndexPath:indexPath];
            }
            cell.image = [UIImage imageNamed:@"Placeholder.png"];
        }
        else
        {
            cell.image = [_imagesDownloaded valueForKey:pModel.ID];
        }
    }

    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.photosArray.count > 0)
    {
        return self.photosArray.count;
    }
    else
    {
        return 0;
    }
}

#pragma MARK: - UIScrollViewDelegate methods

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        [self loadImagesForOnscreenCells];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenCells];
}

@end
