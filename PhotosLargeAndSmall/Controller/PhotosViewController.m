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

@end

@implementation PhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    APIClient *apiClient = [[APIClient alloc] init];
    [apiClient fetchData];
}

@end
