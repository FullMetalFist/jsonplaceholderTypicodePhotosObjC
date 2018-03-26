//
//  PhotoCollectionViewCell.m
//  PhotosLargeAndSmall
//
//  Created by Michael Vilabrera on 3/26/18.
//  Copyright © 2018 Michael Vilabrera. All rights reserved.
//

#import "PhotoCollectionViewCell.h"

@interface PhotoCollectionViewCell ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation PhotoCollectionViewCell

- (instancetype)init
{
    self = [super init];
    
    [self createViews];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    [self createViews];
    return self;
}

- (void)createViews
{
    self.imageView = [[UIImageView alloc] init];
    NSDictionary *viewsDict = NSDictionaryOfVariableBindings(_imageView);
    
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.imageView];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_imageView]|" options:0 metrics:nil views:viewsDict]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_imageView]|" options:0 metrics:nil views:viewsDict]];
    self.imageView.image = self.image;
}

@end
