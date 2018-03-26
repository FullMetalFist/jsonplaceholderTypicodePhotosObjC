//
//  APIClient.m
//  PhotosLargeAndSmall
//
//  Created by Michael Vilabrera on 3/26/18.
//  Copyright © 2018 Michael Vilabrera. All rights reserved.
//

#import "APIClient.h"
#import "Constants.h"


@interface APIClient () <NSURLSessionDelegate>

@end

@implementation APIClient

- (void)fetchDataWithCompletionBlock:(void (^)(BOOL succeeded, NSArray *array))completionBlock
{
    NSURL *jsonEndpoint = [NSURL URLWithString:JSON_ENDPOINT];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration ephemeralSessionConfiguration]];
    
    NSURLSessionDataTask *task = [session dataTaskWithURL:jsonEndpoint completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (!data)
        {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                NSLog(@"Error connecting: %@", [error localizedDescription]);
                completionBlock(NO, nil);
            }];
        }
        
        NSError *anyError = nil;
        
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&anyError];
        if (!jsonDictionary)
        {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                NSLog(@"Error creating JSON dictionary: %@", [anyError localizedDescription]);
                completionBlock(NO, nil);
            }];
        }
        
        NSArray *parsedJSONArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&anyError];
        
        
        NSMutableArray *populatePhotoModelArray = [NSMutableArray array];
        for (NSDictionary *jsonDict in parsedJSONArray) {
            PhotoModel *pModel = [[PhotoModel alloc] initWithDictionary:jsonDict];

            [populatePhotoModelArray addObject:pModel];
        }
        
        completionBlock(YES, populatePhotoModelArray);
    }];
    
    [task resume];
}

- (void)fetchImageForPhotoModel:(PhotoModel *)photoModel completionBlock:(void (^)(BOOL, UIImage *))completionBlock
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:photoModel.thumbnailURL]];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error)
        {
            UIImage *image = [[UIImage alloc] initWithData:data];
            completionBlock(YES, image);
        }
        else
        {
            completionBlock(NO, nil);
        }
    }];
    [task resume];
}

@end
