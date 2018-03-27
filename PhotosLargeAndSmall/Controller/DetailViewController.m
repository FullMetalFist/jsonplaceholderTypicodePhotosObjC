//
//  DetailViewController.m
//  PhotosLargeAndSmall
//
//  Created by Michael Vilabrera on 3/27/18.
//  Copyright © 2018 Michael Vilabrera. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (instancetype)init
{
    self = [super init];
    
    [self createViews];
    return self;
}

- (void)createViews
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    self.activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    NSDictionary *viewsDict = NSDictionaryOfVariableBindings(_imageView, _activityView);
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.activityView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.activityView];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_imageView]|" options:0 metrics:nil views:viewsDict]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_imageView]|" options:0 metrics:nil views:viewsDict]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_activityView]|" options:0 metrics:nil views:viewsDict]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_activityView]|" options:0 metrics:nil views:viewsDict]];
}

@end
