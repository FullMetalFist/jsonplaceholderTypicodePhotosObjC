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
#import "DetailViewController.h"

#define BlockWeakObject(o) __typeof(o) __weak
#define BlockWeakSelf BlockWeakObject(self)

@interface PhotosViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) APIClient *apiClient;
@property (nonatomic, strong) NSArray *photosArray;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableDictionary *imageDownloadInProgress;
//@property (nonatomic, strong) NSCache *imagesDownloaded;
@property (nonatomic, strong) UIImage *sampleImage;

@end

@implementation PhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createViews];
    self.sampleImage = [[UIImage alloc] initWithContentsOfFile:@"sample.jpg"];
    self.photosArray = [NSArray array];
    self.imageDownloadInProgress = [NSMutableDictionary dictionary];
    
    self.apiClient = [[APIClient alloc] init];
    [_apiClient fetchDataWithCompletionBlock:^(BOOL succeeded, NSArray *array) {
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
    [self.apiClient.cache removeAllObjects];
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
    if (_apiClient == nil)
    {
        _apiClient = [[APIClient alloc] init];
        _apiClient.photoModel = photoModel;
        BlockWeakSelf weakSelf = self;
        [_apiClient setCompletionHandler:^{
            
            PhotoCollectionViewCell *cell = (PhotoCollectionViewCell *)[weakSelf.collectionView cellForItemAtIndexPath:indexPath];
            cell.image = weakSelf.sampleImage;
            [cell setNeedsLayout];
            [weakSelf.apiClient.cache removeObjectForKey:indexPath];
        }];
        (self.imageDownloadInProgress)[indexPath] = _apiClient;
        [_apiClient startDownload];
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
            if (![self.apiClient.cache objectForKey:photoModel.ID])
            {
                [self startIconDownload:photoModel forIndexPath:indexPath];
            }
        }
    }
}

#pragma MARK: UICollectionView methods

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    PhotoCollectionViewCell *cell = (PhotoCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFY forIndexPath:indexPath];
    PhotoModel *pModel = (PhotoModel *)_photosArray[indexPath.row];
    if (!cell)
    {
        cell = [[PhotoCollectionViewCell alloc] init];
    }
    
    [cell.activityView startAnimating];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL shouldDownload = YES;
        UIImage *pImage = [_apiClient.cache objectForKey:pModel.ID];
        if (pImage != nil)
        {
            shouldDownload = NO;
            dispatch_async(dispatch_get_main_queue(), ^{
                [cell.activityView stopAnimating];
                cell.activityView.hidden = YES;
                [cell.imageView setImage:pImage];
            });
        }
        if (shouldDownload)
        {
            [_apiClient fetchSmallImageForPhotoModel:pModel completionBlock:^(BOOL succeeded, UIImage *image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (succeeded)
                    {
                        [cell.imageView setImage:image];
                    }
                    else
                    {
                        NSLog(@"something went wrong");
                    }
                });
            }];
        }
    });

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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    DetailViewController *dVC = [[DetailViewController alloc] init];
    PhotoModel *pModel = (PhotoModel *)_photosArray[indexPath.row];
    [dVC.activityView startAnimating];
    dVC.imageView.contentMode = UIViewContentModeScaleAspectFit;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [_apiClient fetchLargeImageForPhotoModel:pModel completionBlock:^(BOOL succeeded, UIImage *image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (succeeded)
                {
                    [dVC.imageView setImage:image];
                    [dVC.activityView stopAnimating];
                    dVC.activityView.hidden = YES;
                    [self.navigationController pushViewController:dVC animated:YES];
                }
                else
                {
                    NSLog(@"image load error");
                }
            });
        }];
    });
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
