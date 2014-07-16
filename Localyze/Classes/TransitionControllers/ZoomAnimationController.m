//
//  ZoomAnimationController.m
//  Notes
//
//  Created by Tope Abayomi on 26/07/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import "ZoomAnimationController.h"

@implementation ZoomAnimationController

-(id)init{
    self = [super init];
    
    if(self){
        
        self.presentationDuration = 0.4;
        self.dismissalDuration = 1.0;
    }
    
    return self;
}

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    return self.isPresenting ? self.presentationDuration : self.dismissalDuration;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    if(self.isPresenting){
        [self executePresentationAnimation:transitionContext];
    }
    else{
     
        [self executeDismissalAnimation:transitionContext];
    }
    
}

-(void)executePresentationAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    UIView* inView = [transitionContext containerView];
    
    UIViewController* toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIViewController* fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    
    CGRect offScreenFrame = inView.frame;
    offScreenFrame.origin.y = inView.frame.size.height;
    toViewController.view.frame = offScreenFrame;
    
    [inView insertSubview:toViewController.view aboveSubview:fromViewController.view];
    
    CATransform3D tiltTransform = CATransform3DIdentity;
    tiltTransform.m34 = 1.0/-900;
    tiltTransform = CATransform3DScale(tiltTransform, 0.95, 0.95, 1);
    tiltTransform = CATransform3DRotate(tiltTransform, 15.0f*M_PI/180.0f, 1, 0, 0);
    
    
    CATransform3D slideTransform = CATransform3DIdentity;
    slideTransform.m34 = tiltTransform.m34;
    slideTransform = CATransform3DTranslate(slideTransform, 0, inView.frame.size.height*-0.08, 0);
    slideTransform = CATransform3DScale(slideTransform, 0.8, 0.8, 1);
    
    CALayer *fromLayer = fromViewController.view.layer;
    
    [UIView animateKeyframesWithDuration:self.presentationDuration delay:0.3f options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.5 animations:^{
            
            fromLayer.transform = tiltTransform;
        }];
        
        [UIView addKeyframeWithRelativeStartTime:0.5 relativeDuration:0.5 animations:^{
            
            fromLayer.transform = slideTransform;
        }];
        
        
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
    
    [UIView animateWithDuration:self.presentationDuration delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        toViewController.view.center = inView.center;
        
    } completion:^(BOOL finished) {
    }];
}

-(void)executeDismissalAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    UIView* inView = [transitionContext containerView];
    
    UIViewController* toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIViewController* fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    [inView insertSubview:toViewController.view belowSubview:fromViewController.view];
    
    CGPoint centerOffScreen = inView.center;
    centerOffScreen.y = (-1)*inView.frame.size.height;
    
    [UIView animateKeyframesWithDuration:self.dismissalDuration delay:0.0f options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.5 animations:^{
            
            CGPoint center = fromViewController.view.center;
            center.y += 50;
            fromViewController.view.center = center;
        }];
        
        [UIView addKeyframeWithRelativeStartTime:0.5 relativeDuration:0.5 animations:^{
            
            fromViewController.view.center = centerOffScreen;
            
        }];
        
        
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}
@end
