//
//  APIClient.m
//  PhotosLargeAndSmall
//
//  Created by Michael Vilabrera on 3/26/18.
//  Copyright © 2018 Michael Vilabrera. All rights reserved.
//

#import "APIClient.h"
#import "Constants.h"
#import "PhotoModel.h"

@interface APIClient () <NSURLSessionDelegate>

@end

@implementation APIClient

- (void)fetchData
{
    NSURL *jsonEndpoint = [NSURL URLWithString:JSON_ENDPOINT];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration ephemeralSessionConfiguration]];
    
    NSURLSessionDataTask *task = [session dataTaskWithURL:jsonEndpoint completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (!data)
        {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                NSLog(@"Error connecting: %@", [error localizedDescription]);
            }];
        }
        
        NSError *anyError = nil;
        
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&anyError];
        if (!jsonDictionary)
        {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                NSLog(@"Error creating JSON dictionary: %@", [anyError localizedDescription]);
            }];
        }
        
        NSArray *parsedJSONArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&anyError];
        
        
        NSMutableArray *populatePhotoModelArray = [NSMutableArray array];
        for (NSDictionary *jsonDict in parsedJSONArray) {
            PhotoModel *pModel = [[PhotoModel alloc] initWithDictionary:jsonDict];

            [populatePhotoModelArray addObject:pModel];
            NSLog(@"%@", jsonDict);
        }
        
        self.photoModelArray = [NSArray arrayWithArray:populatePhotoModelArray];
        NSLog(@"%@", self.photoModelArray);
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            // stop activity indicator
            // hide activity indicator
            
            NSLog(@"Reload");
        }];
    }];
    
    [task resume];
}

@end
