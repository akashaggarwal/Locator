//
//  AppDelegate.h
//  Localyze
//
//  Created by Valentin Filip on 24/08/2013.
//  Copyright (c) 2013 AppDesignVault. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property CLLocationCoordinate2D currentcoordinate ;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIViewController *mainVC;

+ (AppDelegate*)sharedDelegate;

+ (UIColor *)colorBetweenColor:(UIColor *)topColor andColor:(UIColor *)bottomColor forDegreesFahrenheit:(double) fahrenheit;
+ (UIImage*)createWhiteGradientImageWithSize:(CGSize)size;
+ (UIImage*)createSolidColorImageWithColor:(UIColor*)color andSize:(CGSize)size;
+ (UIImage*)createGradientImageFromColor:(UIColor *)startColor toColor:(UIColor *)endColor withSize:(CGSize)size;



@end
