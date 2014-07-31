//
//  AppDelegate.m
//  Localyze
//
//  Created by Valentin Filip on 24/08/2013.
//  Copyright (c) 2013 AppDesignVault. All rights reserved.
//

#import "AppDelegate.h"
#import "DetailiPadViewController.h"
#import "ADVTheme.h"



#import "SDSyncEngine.h"
#import "AgencyData.h"

@interface AppDelegate ()

void drawLinearGradient(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef endColor);

@end




@implementation AppDelegate

@synthesize window = _window;


+ (AppDelegate *)sharedDelegate {
    return [[UIApplication sharedApplication] delegate];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [ADVThemeManager customizeAppAppearance];
 
    UIUserInterfaceIdiom idiom = [[UIDevice currentDevice] userInterfaceIdiom];
    
    if (idiom == UIUserInterfaceIdiomPad) {
        
    } else {
        
    }
    
    //[[SDSyncEngine sharedEngine] registerNSManagedObjectClassToSync:[Holiday class]];
    
     // [[SDSyncEngine sharedEngine] registerNSManagedObjectClassToSync:[AgencyData class]];
    [[SDSyncEngine sharedEngine] registerStringToSync:@"AgencyData;AgencyData"];
    // Override point for customization after application launch.
    return YES;
}


+ (UIColor *)colorBetweenColor:(UIColor *)topColor andColor:(UIColor *)bottomColor forDegreesFahrenheit:(double) fahrenheit {
    double t = fahrenheit; // - kBottomThreshold) / (kTopThreshold - kBottomThreshold);
    
    // Clamp t to the range [0 ... 1].
    t = MAX(0.0, MIN(t, 1.0));
    
    const CGFloat* componentsTop = CGColorGetComponents(topColor.CGColor);
    const CGFloat* componentsBottom = CGColorGetComponents(bottomColor.CGColor);
    
    double r = componentsBottom[0] + t * (componentsTop[0] - componentsBottom[0]);
    double g = componentsBottom[1] + t * (componentsTop[1] - componentsBottom[1]);
    double b = componentsBottom[2] + t * (componentsTop[2] - componentsBottom[2]);
    
    return [UIColor colorWithRed:r green:g blue:b alpha:1];
}

+ (UIImage*)createSolidColorImageWithColor:(UIColor*)color andSize:(CGSize)size {
    
    CGFloat scale = [[UIScreen mainScreen] scale];
    UIGraphicsBeginImageContextWithOptions(size, NO, scale);
    
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGRect fillRect = CGRectMake(0,0,size.width,size.height);
    CGContextSetFillColorWithColor(currentContext, color.CGColor);
    CGContextFillRect(currentContext, fillRect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage*)createGradientImageFromColor:(UIColor *)startColor toColor:(UIColor *)endColor withSize:(CGSize)size {
    
    
    CGFloat scale = [[UIScreen mainScreen] scale];
    UIGraphicsBeginImageContextWithOptions(size, NO, scale);
    
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGRect fillRect = CGRectMake(0,0,size.width,size.height);
    drawLinearGradient(currentContext, fillRect, startColor.CGColor, endColor.CGColor);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage*)createWhiteGradientImageWithSize:(CGSize)size {
    
    
    CGFloat scale = [[UIScreen mainScreen] scale];
    UIGraphicsBeginImageContextWithOptions(size, NO, scale);
    
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGRect fillRect = CGRectMake(0,0,size.width,size.height);
    UIColor * whiteColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5];
    UIColor* whiteTransparent = [UIColor colorWithWhite:1.0f alpha:0.2f];
    drawLinearGradient(currentContext, fillRect, whiteColor.CGColor, whiteTransparent.CGColor);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

void drawLinearGradient(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef endColor)
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    
    NSArray *colors = @[(__bridge id) startColor, (__bridge id) endColor];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    
    CGContextSaveGState(context);
    CGContextAddRect(context, rect);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}



- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    NSLog(@"Inside applicationDidBecomeActive");
    [[SDSyncEngine sharedEngine] startSync];

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
