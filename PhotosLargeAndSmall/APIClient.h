//
//  APIClient.h
//  PhotosLargeAndSmall
//
//  Created by Michael Vilabrera on 3/26/18.
//  Copyright © 2018 Michael Vilabrera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoModel.h"

@interface APIClient : NSObject

@property (nonatomic, strong) NSCache *cache;
@property (nonatomic, strong) PhotoModel *photoModel;
@property (nonatomic, copy) void (^completionHandler)(void);

- (void)fetchDataWithCompletionBlock:(void (^)(BOOL succeeded, NSArray *array))completionBlock;
- (void)fetchImageForPhotoModel:(PhotoModel *)photoModel completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock;

- (void)startDownload;
- (void)cancelDownload;

@end
