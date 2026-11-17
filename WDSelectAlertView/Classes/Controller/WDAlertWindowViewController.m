//
//  WDAlertWindowViewController.m
//  WDSelectAlertView
//
//  Created by dzkj on 2020/12/10.
//  Copyright © 2020 jocelen. All rights reserved.
//

#import "WDAlertWindowViewController.h"
#import "WDSelectAlertView.h"
#import "WDSheetAlertView.h"

#pragma mark - Built-in Transition Animator

@interface WDAlertWindowTransitionAnimator : NSObject <UIViewControllerAnimatedTransitioning>
@property (nonatomic, assign) BOOL presenting;
@property (nonatomic, assign) WDAlertViewPositionType position;
@end

@interface WDAlertWindowViewController () <UIViewControllerTransitioningDelegate>

@property (nonatomic, strong, readwrite) WDAlertWindowStyleModel *styleModel;
@property (nonatomic, strong) UIVisualEffectView *effectView;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, copy, nullable) NSString *registeredNotificationKey;
@property (nonatomic, assign) BOOL isTransitionAnimating;

- (void)prepareTransitionStartState;
- (void)applyTransitionPresentedState;
- (void)applyTransitionDismissedState;

@end

@implementation WDAlertWindowTransitionAnimator

- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext {
    if (self.presenting) {
        return (self.position == WDAlertViewPositionTypeCenter) ? 0.28 : 0.32;
    }
    return 0.22;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *containerView = transitionContext.containerView;
    NSTimeInterval duration = [self transitionDuration:transitionContext];

    if (self.presenting) {
        UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey] ?: toVC.view;
        [UIView performWithoutAnimation:^{
            toView.frame = containerView.bounds;
            toView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            [containerView addSubview:toView];
            [toView layoutIfNeeded];
        }];

        if ([toVC isKindOfClass:[WDAlertWindowViewController class]]) {
            WDAlertWindowViewController *alertVC = (WDAlertWindowViewController *)toVC;
            [UIView performWithoutAnimation:^{
                [alertVC prepareTransitionStartState];
            }];
            alertVC.isTransitionAnimating = YES;
            [UIView animateWithDuration:duration
                                  delay:0
                 usingSpringWithDamping:0.86
                  initialSpringVelocity:0
                                options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction
                             animations:^{
                                 [alertVC applyTransitionPresentedState];
                             }
                             completion:^(BOOL finished) {
                                 alertVC.isTransitionAnimating = NO;
                                 [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
                             }];
        } else {
            toView.alpha = 0;
            [UIView animateWithDuration:duration
                             animations:^{
                                 toView.alpha = 1;
                             }
                             completion:^(BOOL finished) {
                                 [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
                             }];
        }
    } else {
        UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey] ?: fromVC.view;

        if ([fromVC isKindOfClass:[WDAlertWindowViewController class]]) {
            WDAlertWindowViewController *alertVC = (WDAlertWindowViewController *)fromVC;
            alertVC.isTransitionAnimating = YES;
            [UIView animateWithDuration:duration
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 [alertVC applyTransitionDismissedState];
                             }
                             completion:^(BOOL finished) {
                                 alertVC.isTransitionAnimating = NO;
                                 if (!transitionContext.transitionWasCancelled) {
                                     [fromView removeFromSuperview];
                                 }
                                 [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
                             }];
        } else {
            [UIView animateWithDuration:duration
                             animations:^{
                                 fromView.alpha = 0;
                             }
                             completion:^(BOOL finished) {
                                 if (!transitionContext.transitionWasCancelled) {
                                     [fromView removeFromSuperview];
                                 }
                                 [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
                             }];
        }
    }
}

@end

#pragma mark - WDAlertWindowViewController

@implementation WDAlertWindowViewController

- (instancetype)initWithModel:(WDAlertWindowStyleModel *)model {
    if (self = [super initWithNibName:nil bundle:nil]) {
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.transitioningDelegate = self;
        [self configureWithStyleModel:model ?: [WDAlertWindowStyleModel defaultStyle]];
    }
    return self;
}

- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.transitioningDelegate = self;
        [self configureWithStyleModel:[WDAlertWindowStyleModel defaultStyle]];
    }
    return self;
}

- (nullable instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.transitioningDelegate = self;
        [self configureWithStyleModel:[WDAlertWindowStyleModel defaultStyle]];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.clearColor;
    [self addSubviews];
    [self syncStyleToViews];
}

- (void)addSubviews {
    [self.view addSubview:self.backView];
    [self.view addSubview:self.effectView];
    if (self.contentView != nil) {
        [self.view addSubview:self.contentView];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    self.backView.frame = self.view.bounds;
    self.effectView.frame = self.view.bounds;

    if (self.contentView == nil || self.isTransitionAnimating) {
        return;
    }

    // 保护动画期间的仿射变换不被 frame 计算破坏
    CGAffineTransform savedTransform = self.contentView.transform;
    BOOL hasTransform = !CGAffineTransformIsIdentity(savedTransform);
    if (hasTransform) {
        self.contentView.transform = CGAffineTransformIdentity;
    }

    CGSize boundSize = self.view.bounds.size;
    CGRect frame = self.contentView.frame;

    switch (self.styleModel.position) {
        case WDAlertViewPositionTypeTop: {
            if (frame.size.width <= 0 || frame.size.width > boundSize.width) {
                frame.size.width = boundSize.width;
            }
            frame.origin = CGPointMake((boundSize.width - frame.size.width) / 2.0, 0);
            self.contentView.frame = frame;
            break;
        }
        case WDAlertViewPositionTypeCenter: {
            if ([self.contentView isKindOfClass:[WDSelectAlertView class]]) {
                WDSelectAlertView *selectView = (WDSelectAlertView *)self.contentView;
                CGFloat maxAllowedWidth = MAX(200.0, boundSize.width - 32.0);
                CGFloat maxAllowedHeight = MAX(180.0, boundSize.height - 64.0);
                if (selectView.styleModel.maxAlertWidth > maxAllowedWidth) {
                    selectView.styleModel.maxAlertWidth = maxAllowedWidth;
                }
                if (selectView.styleModel.maxAlertHeight > maxAllowedHeight) {
                    selectView.styleModel.maxAlertHeight = maxAllowedHeight;
                }
                CGFloat height = [selectView layoutAlertHeight];
                frame.size = CGSizeMake(selectView.styleModel.maxAlertWidth, height);
                self.contentView.frame = frame;
            }
            self.contentView.center = CGPointMake(boundSize.width / 2.0, boundSize.height / 2.0);
            break;
        }
        case WDAlertViewPositionTypeBottom: {
            frame.size.width = boundSize.width;
            self.contentView.frame = frame;
            if ([self.contentView isKindOfClass:[WDSheetAlertView class]]) {
                [(WDSheetAlertView *)self.contentView updateFrame];
                frame = self.contentView.frame;
            }
            frame.origin = CGPointMake((boundSize.width - frame.size.width) / 2.0,
                                       boundSize.height - frame.size.height);
            self.contentView.frame = frame;
            break;
        }
        case WDAlertViewPositionTypeCustom:
        default:
            break;
    }

    if (hasTransform) {
        self.contentView.transform = savedTransform;
    }
}

#pragma mark - Actions

- (void)dismissAlertAnimated:(BOOL)animated completion:(nullable void (^)(void))completion {
    [self dismissViewControllerAnimated:animated completion:completion];
}

- (void)dissmissAction {
    [self dismissAlertAnimated:self.styleModel.animatedTransition completion:nil];
}

- (void)didCancelAction {
    if (self.styleModel.canTouchCancel) {
        [self dissmissAction];
    }
}

#pragma mark - Transition State Helpers

- (void)prepareTransitionStartState {
    self.backView.alpha = 0.0;
    self.effectView.alpha = 0.0;
    if (self.contentView == nil) {
        return;
    }

    switch (self.styleModel.position) {
        case WDAlertViewPositionTypeTop:
            self.contentView.alpha = 1.0;
            self.contentView.transform = CGAffineTransformMakeTranslation(0, -MAX(CGRectGetHeight(self.contentView.bounds), 100.0));
            break;
        case WDAlertViewPositionTypeBottom:
            self.contentView.alpha = 1.0;
            self.contentView.transform = CGAffineTransformMakeTranslation(0, MAX(CGRectGetHeight(self.contentView.bounds), 150.0));
            break;
        case WDAlertViewPositionTypeCenter:
            self.contentView.alpha = 0.0;
            self.contentView.transform = CGAffineTransformMakeScale(0.92, 0.92);
            break;
        case WDAlertViewPositionTypeCustom:
        default:
            self.contentView.alpha = 0.0;
            break;
    }
}

- (void)applyTransitionPresentedState {
    self.backView.alpha = 1.0;
    self.effectView.alpha = 1.0;
    self.contentView.alpha = 1.0;
    self.contentView.transform = CGAffineTransformIdentity;
}

- (void)applyTransitionDismissedState {
    self.backView.alpha = 0.0;
    self.effectView.alpha = 0.0;
    if (self.contentView == nil) {
        return;
    }

    switch (self.styleModel.position) {
        case WDAlertViewPositionTypeTop:
            self.contentView.transform = CGAffineTransformMakeTranslation(0, -CGRectGetHeight(self.contentView.bounds));
            break;
        case WDAlertViewPositionTypeBottom:
            self.contentView.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(self.contentView.bounds));
            break;
        case WDAlertViewPositionTypeCenter:
            self.contentView.alpha = 0.0;
            self.contentView.transform = CGAffineTransformMakeScale(0.95, 0.95);
            break;
        case WDAlertViewPositionTypeCustom:
        default:
            self.contentView.alpha = 0.0;
            break;
    }
}

#pragma mark - UIViewControllerTransitioningDelegate

- (nullable id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                           presentingController:(UIViewController *)presenting
                                                                               sourceController:(UIViewController *)source {
    if (!self.styleModel.animatedTransition) {
        return nil;
    }
    WDAlertWindowTransitionAnimator *animator = [[WDAlertWindowTransitionAnimator alloc] init];
    animator.presenting = YES;
    animator.position = self.styleModel.position;
    return animator;
}

- (nullable id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    if (!self.styleModel.animatedTransition) {
        return nil;
    }
    WDAlertWindowTransitionAnimator *animator = [[WDAlertWindowTransitionAnimator alloc] init];
    animator.presenting = NO;
    animator.position = self.styleModel.position;
    return animator;
}

#pragma mark - Private Configuration

- (void)configureWithStyleModel:(WDAlertWindowStyleModel *)styleModel {
    if (self.registeredNotificationKey.length > 0) {
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:self.registeredNotificationKey
                                                      object:nil];
        self.registeredNotificationKey = nil;
    }

    _styleModel = styleModel;

    if (styleModel.dismissNotificationKey.length > 0) {
        self.registeredNotificationKey = styleModel.dismissNotificationKey;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(dissmissAction)
                                                     name:styleModel.dismissNotificationKey
                                                   object:nil];
    }

    if (self.isViewLoaded) {
        [self syncStyleToViews];
        [self.view setNeedsLayout];
    }
}

- (void)syncStyleToViews {
    self.backView.backgroundColor = self.styleModel.backgroundColor;
    self.effectView.hidden = !self.styleModel.isGroundGlass;
}

#pragma mark - Getters & Setters

- (void)setStyleModel:(WDAlertWindowStyleModel *)styleModel {
    [self configureWithStyleModel:styleModel ?: [WDAlertWindowStyleModel defaultStyle]];
}

- (UIView *)backView {
    if (_backView == nil) {
        _backView = [[UIView alloc] initWithFrame:CGRectZero];
        _backView.backgroundColor = self.styleModel.backgroundColor;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didCancelAction)];
        [_backView addGestureRecognizer:tap];
    }
    return _backView;
}

- (UIVisualEffectView *)effectView {
    if (_effectView == nil) {
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemUltraThinMaterial];
        _effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        _effectView.hidden = !self.styleModel.isGroundGlass;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didCancelAction)];
        [_effectView addGestureRecognizer:tap];
    }
    return _effectView;
}

- (void)setContentView:(UIView *)contentView {
    if (_contentView == contentView) {
        return;
    }
    [_contentView removeFromSuperview];
    _contentView = contentView;

    if (self.isViewLoaded && _contentView != nil) {
        [self.view addSubview:_contentView];
        [self.view setNeedsLayout];
    }
}

@end
