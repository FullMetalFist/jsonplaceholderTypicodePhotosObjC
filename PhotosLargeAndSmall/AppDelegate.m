//
//  AppDelegate.m
//  PhotosLargeAndSmall
//
//  Created by Michael Vilabrera on 3/26/18.
//  Copyright © 2018 Michael Vilabrera. All rights reserved.
//

#import "AppDelegate.h"

#import "PhotosViewController.h"

@interface AppDelegate ()

@property (nonatomic, strong) UINavigationController *navController;
@property (nonatomic, strong) PhotosViewController *photosVC;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self createViews];
    return YES;
}


- (void)createViews
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.photosVC = [[PhotosViewController alloc] initWithNibName:nil bundle:nil];
    self.navController = [[UINavigationController alloc] initWithRootViewController:_photosVC];
    self.window.rootViewController = self.navController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
}

@end
