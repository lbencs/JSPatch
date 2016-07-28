//
//  AppDelegate.m
//  OCDome
//
//  Created by lbencs on 7/5/16.
//  Copyright © 2016 lbencs. All rights reserved.
#import "AppDelegate.h"
#import "JPEngine.h"
#import <objc/runtime.h>
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    
    [self typeEncoding];
    
    [JPEngine startEngine];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"main" ofType:@"js"];
    [JPEngine evaluateScriptWithPath:path];
    
    self.window.rootViewController = [[UIViewController alloc] init];
    
    [self configRootViewController];
    
    return YES;
}
- (void)configRootViewController{
    NSLog(@"log------------configRootViewController");
}



- (void)typeEncoding{
    double *t,*tt,*ttt;
    double T = 1.0,TT = 2.0, TTT = 3.0;
    t = &T;
    tt = &TT;
    ttt = &TTT;
    double * a[] = {t,tt,ttt};
//    char *t = "chart";
    char b[] = { 0,1,3.0,YES};
    NSLog(@"arry encoding type: %s",@encode(typeof(a)));
    NSLog(@"arry encoding type: %s",@encode(typeof(b)));
    
    NSArray *arr = @[@"1",@"2"];
    NSLog(@"Array encoding type: %s", @encode(typeof(arr)));
    
    NSString *str = @"String";
    NSLog(@"Strin encoding type: %s",@encode(typeof(str)));
    
    NSObject *obj = [[NSObject alloc] init];
    NSLog(@"Object encoding type: %s", @encode(typeof(obj)));
    
    CGRect frame = CGRectMake(0, 0, 0, 0);
    NSLog(@"Rect encoding type: %s", @encode(typeof(frame)));
    
    CGPoint point = CGPointZero;
    NSLog(@"Point encoding type: %s", @encode(typeof(point)));
    
    int int_ = 1;
    NSLog(@"Int encoding type: %s", @encode(typeof(int_)));
    
    NSLog(@"Class encoding type: %s", @encode(typeof(NSObject)));
    
    NSLog(@"Selector encoding type: %s", @encode(typeof(@selector(appendFormat:))));
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
