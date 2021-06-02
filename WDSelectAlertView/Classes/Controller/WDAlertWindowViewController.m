//
//  WDAlertWindowViewController.m
//  WDSelectAlertView
//
//  Created by dzkj on 2020/12/10.
//  Copyright © 2020 jocelen. All rights reserved.
//

#import "WDAlertWindowViewController.h"

@interface WDAlertWindowViewController ()

/**  毛玻璃view*/
@property (nonatomic, strong) UIVisualEffectView * effectView;

/**  背景view*/
@property (nonatomic, strong) UIView * backView;



@end

@implementation WDAlertWindowViewController

#pragma mark -  life cycle
@synthesize styleModel = _styleModel;
-(instancetype)initWithModel:(WDAlertWindowStyleModel *)model;
{
    if (self = [super init]) {
        self.styleModel = model;
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
    }
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addSubviews];
    [self loadConfig];
}

-(void)addSubviews
{
    [self.view addSubview:self.backView];
    [self.view addSubview:self.effectView];
    [self.view addSubview:self.contentView];
}

-(void)loadConfig
{
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    CGRect frame = self.contentView.frame;
    CGSize boundSize = UIScreen.mainScreen.bounds.size;
    /// 调整位置
    switch (self.styleModel.position) {
        case BCAlertViewPositionTypeTop:
        {
            frame.origin = CGPointMake(frame.origin.x, 0);
            self.contentView.frame = frame;
        }
            break;
        case BCAlertViewPositionTypeCenter:
        {
            self.contentView.center = self.view.center;
        }
            break;
        case BCAlertViewPositionTypeBottom:
        {
            frame.origin = CGPointMake(frame.origin.x, boundSize.height - frame.size.height);
            self.contentView.frame = frame;
        }
            break;
        default:
            break;
    }
}

-(void)dissmissAction
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark -  event response

-(void)didCancelAction
{
    if (YES == _styleModel.canTouchCancel) {
        [self dissmissAction];
    }
}

#pragma mark -  getters and setters

-(void)setStyleModel:(WDAlertWindowStyleModel * _Nonnull)styleModel
{
    _styleModel = styleModel;
    self.effectView.hidden = !_styleModel.isGroundGlass;
    if (_styleModel.dismissNotificationKey.length) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dissmissAction) name:_styleModel.dismissNotificationKey object:nil];
    }
}


-(UIView *)backView
{
    if (nil == _backView) {
        _backView = [[UIView alloc] init];
        _backView.frame = self.view.bounds;
        _backView.backgroundColor = _styleModel.backgroudColor;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didCancelAction)];
        [_backView addGestureRecognizer:tap];
        
    }
    return _backView;
}


-(UIVisualEffectView *)effectView
{
    if (nil == _effectView) {
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        _effectView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
        _effectView.frame = self.view.bounds;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didCancelAction)];
        [_effectView addGestureRecognizer:tap];
    }
    return _effectView;
}

-(void)setContentView:(UIView *)contentView
{
    _contentView = contentView;
    
    if (_contentView) {
        [_contentView removeFromSuperview];
        [self.view addSubview:_contentView];
    }
}

@end
