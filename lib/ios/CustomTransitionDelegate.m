#import "CustomTransitionDelegate.h"
#import "DisplayLinkAnimator.h"
#import "SharedElementTransitionsCreator.h"
#import "ScreenTransitionsCreator.h"

@implementation CustomTransitionDelegate {
    ScreenTransitionsCreator* _transitionsCreator;
}

- (instancetype)initWithScreenTransition:(RNNScreenTransition *)screenTransition {
    self = [super init];
	_transitionsCreator = [[ScreenTransitionsCreator alloc] initWithScreenTransition:screenTransition];
    return self;
}

- (void)animateTransitions:(NSArray<id<DisplayLinkAnimation>>*)animations andTransitioningContext:(id<UIViewControllerContextTransitioning>)transitionContext {
    DisplayLinkAnimator* displayLinkAnimator = [[DisplayLinkAnimator alloc] initWithDisplayLinkAnimations:animations duration:[self transitionDuration:transitionContext]];
    
    [displayLinkAnimator setCompletion:^{
        if (![transitionContext transitionWasCancelled]) {
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }
    }];
    
    [displayLinkAnimator start];
}

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return _transitionsCreator.minDuration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController* fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController* toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    [transitionContext.containerView addSubview:toVC.view];
    
	NSArray* transitions = [_transitionsCreator createFromVC:fromVC toVC:toVC containerView:transitionContext.containerView];
    [self animateTransitions:transitions andTransitioningContext:transitionContext];
}

@end