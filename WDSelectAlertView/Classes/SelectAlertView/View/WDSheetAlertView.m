//
//  WDSheetAlertView.m
//  WDSelectAlertView
//
//  Created by dzkj on 2020/12/10.
//  Copyright © 2020 jocelen. All rights reserved.
//

#import "WDSheetAlertView.h"

static NSInteger const kButtonTage = 1000;

@interface WDSheetAlertView ()

/**  ScrollView*/
@property (nonatomic, strong) UIScrollView * scrollView;

/**  取消*/
@property (nonatomic, strong) UIButton * cancelButton;

@end


@implementation WDSheetAlertView


// MARK: -  life cycle

-(instancetype)initWithModel:(WDSheetAlertStyleModel *)model;
{
    if (self = [super initWithFrame:CGRectZero]) {
        _styleModel = model;
        [self loadConfig];
        [self addSubviews];
        [self loadData];
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self loadConfig];
    [self addSubviews];
    [self loadData];
}

// MARK: -  private methods

// 加载初始配置
-(void)loadConfig {
    self.backgroundColor = _styleModel.backgroudColor;

}

// 添加view
-(void)addSubviews {
    
    [self addSubview:self.scrollView];
    [self addSubview:self.cancelButton];
}

// 加载数据
-(void)loadData {

}

-(void)selectAction:(UIButton *)sender
{
    if (_didSelect) {
        _didSelect(sender.tag - kButtonTage);
    }
}


-(void)cancelAction:(UIButton *)sender
{
    if (_didClickCancel) {
        _didClickCancel();
    }
}

// MARK: -  public methods

-(void)setStyleModel:(WDSheetAlertStyleModel * _Nonnull)styleModel
{
    _styleModel = styleModel;
    while (self.subviews.count > 0) {
        [self.subviews.lastObject removeFromSuperview];
    }
    
    [self addSubviews];
    [self loadData];
}


/// 计算高度
-(void)updateFrame;
{
    for (int i = 0; i < _styleModel.dataArr.count; i++) {
        UIButton * button = [self createItemButton];
        button.tag = kButtonTage + i;
        button.frame = CGRectMake(0, i * (_styleModel.cellHeight + _styleModel.lineHeight), self.frame.size.width, _styleModel.cellHeight);
        [button setTitle:_styleModel.dataArr[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:button];
    }
    
    CGRect scrollFrame = CGRectMake(0, 0, self.frame.size.width, 0);
    if (_styleModel.dataArr.count > _styleModel.maxShowCount) {
        _scrollView.scrollEnabled = YES;
        scrollFrame.size.height = (_styleModel.maxShowCount + 0.6f) *_styleModel.cellHeight;
    }
    else {
        _scrollView.scrollEnabled = NO;
        scrollFrame.size.height = _styleModel.dataArr.count*_styleModel.cellHeight;
    }
    
    CGSize cancelSize = CGSizeMake(self.frame.size.width, _styleModel.cellHeight + _styleModel.safeEdgeBottomMargin);
    CGFloat contentHeight = scrollFrame.size.height + self.spaceHeight + cancelSize.height;

    self.frame = CGRectMake(0, 0, self.frame.size.width, contentHeight);
    _scrollView.frame = scrollFrame;
    _scrollView.contentSize = CGSizeMake(scrollFrame.size.width, _styleModel.dataArr.count*(_styleModel.cellHeight + _styleModel.lineHeight));
    _cancelButton.frame = CGRectMake(0, self.frame.size.height - cancelSize.height , cancelSize.width, cancelSize.height);
}

// MARK: -  getters and setters

-(CGFloat)spaceHeight
{
    CGFloat height = 8 + MAX(0, (_styleModel.dataArr.count - 1)) * _styleModel.lineHeight;
    return height;
}

-(UIScrollView *)scrollView
{
    if (!_scrollView) {
        UIScrollView * view = [[UIScrollView alloc] init];
        view.showsHorizontalScrollIndicator = NO;
        view.directionalLockEnabled = YES;
        view.bounces = NO;
        _scrollView = view;
    }
    return _scrollView;
}

-(UIButton *)cancelButton
{
    if (!_cancelButton) {
        UIButton * button = [self createItemButton];
        [button setTitle:_styleModel.cancelTitle forState:UIControlStateNormal];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(-_styleModel.safeEdgeBottomMargin/2, 0, 0, 0)];
        [button addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
        _cancelButton = button;
    }
    return _cancelButton;
}


-(UIButton *)createItemButton
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.backgroundColor = _styleModel.cellBackgroudColor;
    button.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    [button setTitleColor:_styleModel.cellTextColor forState:UIControlStateNormal];
    
    return button;
}


@end

