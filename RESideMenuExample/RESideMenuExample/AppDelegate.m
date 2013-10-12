//
//  AppDelegate.m
//  RESideMenuExample
//
//  Created by Roman Efimov on 6/14/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "AppDelegate.h"
#import "DemoViewController.h"
#import "DemoViewController.h"
#import "SecondViewController.h"

#define IS_WIDESCREEN ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

@implementation AppDelegate {
    NSMutableArray *_addedItems;
    NSMutableArray *_menuItems;
}

+ (NSInteger)OSVersion
{
    static NSUInteger _deviceSystemMajorVersion = -1;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _deviceSystemMajorVersion = [[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] intValue];
    });
    return _deviceSystemMajorVersion;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    _addedItems = [NSMutableArray array];
    _menuItems = [NSMutableArray array];
    
    // Simple menus
    //
    RESideMenuItem *homeItem = [[RESideMenuItem alloc] initWithTitle:@"Home" action:^(RESideMenu *menu, RESideMenuItem *item) {
        DemoViewController *viewController = [[DemoViewController alloc] init];
        viewController.title = item.title;
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
        [menu displayContentController:navigationController];
    }];
    
    RESideMenuItem *exploreItem = [[RESideMenuItem alloc] initWithTitle:@"Explore" action:^(RESideMenu *menu, RESideMenuItem *item) {
        SecondViewController *secondViewController = [[SecondViewController alloc] init];
        secondViewController.title = item.title;
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:secondViewController];
        [menu displayContentController:navigationController];
    }];
    
    RESideMenuItem *helpPlus1 = [[RESideMenuItem alloc] initWithTitle:@"How to use" action:^(RESideMenu *menu, RESideMenuItem *item) {
        NSLog(@"Item %@", item);
        [menu hide];
    }];
    
    RESideMenuItem *helpPlus2 = [[RESideMenuItem alloc] initWithTitle:@"Helpdesk" action:^(RESideMenu *menu, RESideMenuItem *item) {
        NSLog(@"Item %@", item);
        [menu hide];
    }];
    
    RESideMenuItem *helpCenterItem = [[RESideMenuItem alloc] initWithTitle:@"Help +" action:^(RESideMenu *menu, RESideMenuItem *item) {
        NSLog(@"Item %@", item);
    }];
    helpCenterItem.subItems  = @[helpPlus1,helpPlus2];
    
    // Dynamic addable menus
    //
    RESideMenuItem *tagFieldItem = [[RESideMenuItem alloc] initFieldWithPlaceholder:@"+ Add tag" doneAction:^(RESideMenu *menu, RESideMenuItem *item) {
        __block RESideMenuItem *newTagItem = [[RESideMenuItem alloc] initWithTitle:menu.lastFieldInput image:[UIImage imageNamed:@"minus"] highlightedImage:nil imageAction:^(RESideMenu *menu, RESideMenuItem *item) {
            NSMutableArray * items = menu.items.mutableCopy;
            [items removeObject:newTagItem];
            [_addedItems removeObject:newTagItem];
            [menu reloadWithItems:items push:NO];
        } action:^(RESideMenu *menu, RESideMenuItem *item) {
            NSLog(@"Item %@", item);
            [menu hide];
        }];
        
        NSMutableArray * items = menu.items.mutableCopy;
        [items insertObject:newTagItem atIndex:2];
        [_addedItems addObject:newTagItem];
        [menu reloadWithItems:items push:NO];
    }];
    
    RESideMenuItem *tagMakerItem = [[RESideMenuItem alloc] initWithTitle:@"Tags +" action:^(RESideMenu *menu, RESideMenuItem *item) {
        NSLog(@"Item %@", item);
    }];
    
    NSMutableArray *otherItems = _addedItems;
    [otherItems insertObject:tagFieldItem atIndex:0];
    tagMakerItem.subItems = otherItems;
    
    // Simple menu with an alert
    //
    RESideMenuItem *logOutItem = [[RESideMenuItem alloc] initWithTitle:@"Log out" action:^(RESideMenu *menu, RESideMenuItem *item) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Confirmation" message:@"Are you sure you want to log out?" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"Log Out", nil];
        [alertView show];
    }];
    
    
    _sideMenu = [[RESideMenu alloc] initWithItems:@[homeItem, exploreItem, helpCenterItem, tagMakerItem, logOutItem]];
    _sideMenu.verticalPortraitOffset = IS_WIDESCREEN ? 110 : 76;
    _sideMenu.verticalLandscapeOffset = 16;
    
    _sideMenu.hideStatusBarArea = [AppDelegate OSVersion] < 7;
    
    _sideMenu.openStatusBarStyle = UIStatusBarStyleBlackTranslucent;
    
    _sideMenu.backgroundDrawRectBlock = ^(CGRect rect){
        //// General Declarations
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        //// Color Declarations
        UIColor* fillColor = [UIColor colorWithRed: 0.294 green: 0.2 blue: 0.353 alpha: 1];
        UIColor* strokeColor = [UIColor colorWithRed: 0.294 green: 0.2 blue: 0.353 alpha: 1];
        UIColor* gradientColor = [UIColor colorWithRed: 0.514 green: 0.333 blue: 0.4 alpha: 1];
        UIColor* gradientColor2 = [UIColor colorWithRed: 0.667 green: 0.533 blue: 0.467 alpha: 1];
        UIColor* gradientColor3 = [UIColor colorWithRed: 0.667 green: 0.467 blue: 0.467 alpha: 1];
        
        //// Gradient Declarations
        NSArray* gradientColors = [NSArray arrayWithObjects:
                                   (id)strokeColor.CGColor,
                                   (id)[UIColor colorWithRed: 0.404 green: 0.267 blue: 0.376 alpha: 1].CGColor,
                                   (id)gradientColor.CGColor,
                                   (id)gradientColor2.CGColor,
                                   (id)gradientColor3.CGColor,
                                   (id)fillColor.CGColor, nil];
        CGFloat gradientLocations[] = {0, 0.16, 0.29, 0.58, 0.8, 1};
        CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)gradientColors, gradientLocations);
        
        //// Rectangle Drawing
        UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake(0, 0, rect.size.width, rect.size.height)];
        CGContextSaveGState(context);
        [rectanglePath addClip];
        CGContextDrawLinearGradient(context, gradient, CGPointMake(rect.size.width / 2.0, 0), CGPointMake(rect.size.width / 2.0, rect.size.height), 0);
        CGContextRestoreGState(context);
        
        
        //// Cleanup
        CGGradientRelease(gradient);
        CGColorSpaceRelease(colorSpace);
    };
    
    
    // Call the home action rather than duplicating the initialisation
    homeItem.action(_sideMenu, homeItem);
    
    self.window.rootViewController = _sideMenu;
    self.window.backgroundColor = [UIColor clearColor];
    self.window.opaque = NO;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
