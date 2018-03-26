//
//  PhotoModel.h
//  PhotosLargeAndSmall
//
//  Created by Michael Vilabrera on 3/26/18.
//  Copyright © 2018 Michael Vilabrera. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoModel : NSObject

@property (strong, nonatomic) NSString *albumID;
@property (strong, nonatomic) NSString *ID;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *thumbnailURL;

- (instancetype)initWithDictionary:(NSDictionary *) dictionary;

@end
