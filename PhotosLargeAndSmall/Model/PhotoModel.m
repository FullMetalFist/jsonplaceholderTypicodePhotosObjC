//
//  PhotoModel.m
//  PhotosLargeAndSmall
//
//  Created by Michael Vilabrera on 3/26/18.
//  Copyright © 2018 Michael Vilabrera. All rights reserved.
//

#import "PhotoModel.h"

NSString *kAlbumID = @"albumId";
NSString *kID = @"id";
NSString *kTitle = @"title";
NSString *kURL = @"url";
NSString *kThumbnailURL = @"thumbnailUrl";

@implementation PhotoModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    
    if (self != nil)
    {
        self.albumID = dictionary[kAlbumID];
        self.ID = dictionary[kID];
        self.title = dictionary[kTitle];
        self.url = dictionary[kURL];
        self.thumbnailURL = dictionary[kThumbnailURL];
    }
    
    return self;
}

@end
