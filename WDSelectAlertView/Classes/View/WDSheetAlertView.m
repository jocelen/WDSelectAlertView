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

/**  标题*/
@property (nonatomic, strong) UIView * titleView;
@property (nonatomic, strong) UILabel * titleLabel;

/**  ScrollView*/
@property (nonatomic, strong) UIScrollView * scrollView;

/**  取消*/
@property (nonatomic, strong) UIButton * cancelButton;

@end


@implementation WDSheetAlertView


// MARK: -  life cycle
@synthesize styleModel = _styleModel;
-(instancetype)initWithModel:(WDSheetAlertStyleModel *)model;
{
    if (self = [super initWithFrame:CGRectZero]) {
        self.styleModel = model;
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
    [self.titleView addSubview:self.titleLabel];
    [self addSubview:self.titleView];
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
    _titleView.frame = _styleModel.layoutTitleViewFrame;
    _titleLabel.frame = _styleModel.layoutTitleFrame;
    for (int i = 0; i < _styleModel.dataArr.count; i++) {
        UIButton * button = [self createItemButton];
        button.tag = kButtonTage + i;
        button.frame = CGRectMake(0, i * (_styleModel.cellHeight + _styleModel.lineHeight), self.frame.size.width, _styleModel.cellHeight);
        [button setTitle:_styleModel.dataArr[i] forState:UIControlStateNormal];
        button.enabled = ![_styleModel.disAbleDataArr containsObject:_styleModel.dataArr[i]];
        [button addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:button];
    }
    
    CGRect scrollFrame = CGRectMake(0, CGRectGetMaxY(_titleView.frame), self.frame.size.width, 0);
    if (_styleModel.dataArr.count > _styleModel.maxShowCount) {
        _scrollView.scrollEnabled = YES;
        scrollFrame.size.height = (_styleModel.maxShowCount + 0.6f) *_styleModel.cellHeight;
    }
    else {
        _scrollView.scrollEnabled = NO;
        scrollFrame.size.height = _styleModel.dataArr.count*_styleModel.cellHeight;
    }
    
    CGSize cancelSize = CGSizeMake(self.frame.size.width, _styleModel.cellHeight + _styleModel.safeEdgeBottomMargin);
    CGFloat contentHeight = _titleView.frame.size.height + scrollFrame.size.height + self.spaceHeight + cancelSize.height;

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

-(UIView *)titleView
{
    if (_titleView == nil) {
        UIView * view = [[UIView alloc] init];
        view.backgroundColor = self.styleModel.cellBackgroudColor;
        _titleView = view;
    }
    return _titleView;
}

-(UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        UILabel * label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = self.styleModel.titleFont;
        label.textColor = self.styleModel.titleColor;
        label.text = self.styleModel.title;
        label.numberOfLines = self.styleModel.titleNumberOfLines;
        _titleLabel = label;
    }
    return _titleLabel;
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
        [button setTitleColor:_styleModel.cancelTitleTextColor forState:UIControlStateNormal];
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
    [button setTitleColor:_styleModel.disableCellTextColor forState:UIControlStateDisabled];
    return button;
}


@end

