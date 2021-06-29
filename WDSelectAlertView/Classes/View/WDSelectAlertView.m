//
//  WDSelectAlertView.m
//  WDSelectAlertView
//
//  Created by dzkj on 2020/12/10.
//  Copyright © 2020 jocelen. All rights reserved.
//

#import "WDSelectAlertView.h"

static NSString * const kSelectAlertActionTag = @"ActionEvent%d";


@interface WDSelectAlertView ()<UITextViewDelegate>

/**  标题view*/
@property (nonatomic, strong, nullable) UILabel * titleLabel;
@property (nonatomic, strong, nullable) UIView * titleLine;

/**  内容view*/
@property (nonatomic, strong, nullable) UITextView * textView;

/**  按钮view*/
@property (nonatomic, strong, nullable) UIView * buttonView;
/**  确定按钮*/
@property (nonatomic, strong, nullable) UIButton * sureButton;
/**  取消按钮*/
@property (nonatomic, strong, nullable) UIButton * cancelButton;


@end


@implementation WDSelectAlertView
-(void)dealloc
{
    NSLog(@"%s 弹框被销毁了",__func__);
}



// MARK: -  life cycle
@synthesize styleModel = _styleModel;
-(instancetype)initWithModel:(WDSelectAlertStyleModel *)model;
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


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.layer.cornerRadius = self.styleModel.alertCornerRadius;
    self.layer.masksToBounds = YES;
    
    CGFloat width_max = self.styleModel.maxAlertWidth;
    CGFloat lineSapce = self.styleModel.lineSapceHeight;
    CGFloat leftPadding = self.styleModel.leftPadding;

    _titleLabel.frame = self.styleModel.layoutTitleFrame;
    /// 内容
    CGFloat conetntTopPadding = leftPadding * (self.styleModel.hasTitle ? 0 : 2);
    
    _textView.frame = CGRectMake(leftPadding, CGRectGetMaxY(_titleLabel.frame) + conetntTopPadding, width_max - leftPadding*2, self.styleModel.layoutContentHeight);
   
    /// 选项
    CGFloat contentY = self.frame.size.height - self.styleModel.selectButtonHeight;
    
    _buttonView.frame = CGRectMake(0, contentY-lineSapce, width_max, self.styleModel.selectButtonHeight);
    _cancelButton.frame = self.styleModel.layoutCancelButtonFrame;
    _sureButton.frame = self.styleModel.layoutSureButtonFrame;

}

// MARK: -  private methods

// 加载初始配置
-(void)loadConfig {
    self.backgroundColor = self.styleModel.backgroudColor;
}

// 添加view
-(void)addSubviews {
    [self addSubview:self.titleLine];
    [self addSubview:self.titleLabel];
    [self addSubview:self.textView];
    
    [self addSubview:self.buttonView];
    [self.buttonView addSubview:self.sureButton];
    [self.buttonView addSubview:self.cancelButton];
}

// 加载数据
-(void)loadData {
    self.textView.attributedText = self.attributesMessage;
    self.textView.linkTextAttributes = self.linkTextAttributes;
}

// 选中事件
-(void)selectAction:(UIButton *)sender
{
    BOOL isSure = [sender isEqual:_sureButton];
    NSString * message = isSure ? self.styleModel.sureTitle : self.styleModel.cancelTitle;
    if (_selectAction) {
        _selectAction(isSure,message);
    }
}

// MARK: -  public methods

-(CGFloat)layoutAlertHeight;
{
    
    CGFloat leftPadding = self.styleModel.leftPadding;
    CGFloat conetntTopPadding = leftPadding * (self.styleModel.hasTitle ? 1 : 2);
    CGFloat height_max = self.styleModel.maxAlertHeight;
    
    CGFloat titleHeight = self.styleModel.layoutTitleFrame.size.height;
    
    CGSize maxSize = CGSizeMake(self.styleModel.maxAlertWidth - self.styleModel.leftPadding*2, CGFLOAT_MAX);
    self.textView.textAlignment = self.styleModel.contentTextAlignment;
    CGRect contentMattStrRect = [self.styleModel.layoutAttributesContent boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    CGFloat layoutMessageHeight = contentMattStrRect.size.height;
    
    CGFloat selectHeight = self.styleModel.selectButtonHeight;

    CGFloat maxContentHight = (height_max - titleHeight - selectHeight - conetntTopPadding*2);
    BOOL canScrollEnabled = layoutMessageHeight > maxContentHight;
    
    CGFloat messageHeight = MIN(maxContentHight, layoutMessageHeight) + conetntTopPadding*2;
    
    /// 总高度
    CGFloat layoutAlertHeight = titleHeight + messageHeight + selectHeight;
    
    _textView.scrollEnabled = canScrollEnabled;
    self.styleModel.layoutContentHeight = canScrollEnabled ? maxContentHight : layoutMessageHeight;
    self.styleModel.layoutAlertHeight = layoutAlertHeight;
    
    return self.styleModel.layoutAlertHeight;

}



-(NSAttributedString *)attributesMessage
{
    NSMutableAttributedString *attributeStr = self.styleModel.layoutAttributesContent;

    /// 高亮
    for (int i = 0; i < self.styleModel.highlightArr.count; i++) {
        NSString * item = self.styleModel.highlightArr[i];
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        [dic setValue:self.styleModel.highlightColor forKey:NSForegroundColorAttributeName];
        [dic setValue:self.styleModel.highlightFont forKey:NSFontAttributeName];
        
        [attributeStr setAttributes:dic range:[self.styleModel.content rangeOfString:item]];
    }
    
    /// 链接
    for (int i = 0; i < self.styleModel.linkArr.count; i++) {
        NSString * item = self.styleModel.linkArr[i];
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        [dic setValue:self.styleModel.linkFont forKey:NSFontAttributeName];
        [dic setValue:[NSString stringWithFormat:@"%@://",[NSString stringWithFormat:kSelectAlertActionTag,i]] forKey:NSLinkAttributeName];
        
        [attributeStr setAttributes:dic range:[self.styleModel.content rangeOfString:item]];
    }
    
    return attributeStr;
}

-(NSDictionary<NSAttributedStringKey,id> *)linkTextAttributes
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:self.styleModel.linkColor forKey:NSForegroundColorAttributeName];
//    [dic setValue:@(NSUnderlineStyleSingle) forKey:NSUnderlineStyleAttributeName];
//    [dic setValue:self.styleModel.linkColor forKey:NSUnderlineColorAttributeName];
    return dic;
}

// MARK: -  UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction API_AVAILABLE(ios(10.0))
{
    if (interaction == UITextItemInteractionInvokeDefaultAction ||
        interaction == UITextItemInteractionPresentActions) {
        __weak typeof(self) weakSelf = self;
        for (int i = 0; i < self.styleModel.linkArr.count; i++) {
            if ([URL.scheme isEqualToString:[NSString stringWithFormat:kSelectAlertActionTag,i]]) {
                if (weakSelf.clickLinkAction) {
                    weakSelf.clickLinkAction(i);
                    return NO;
                }
            }
        }
    }
    
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    __weak typeof(self) weakSelf = self;
    for (int i = 0; i < self.styleModel.linkArr.count; i++) {
        if ([URL.scheme isEqualToString:[NSString stringWithFormat:kSelectAlertActionTag,i]]) {
            if (weakSelf.clickLinkAction) {
                weakSelf.clickLinkAction(i);
                return NO;
            }
        }
    }
    return YES;
}


- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    return NO;
}

/// 禁用复制粘贴
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    [self.textView resignFirstResponder];
    return NO;
}


// MARK: -  getters and setters
-(UIView *)titleLine
{
    if (_titleLine == nil) {
        UIView * view = [[UIView alloc] init];
        view.backgroundColor = self.styleModel.lineSpaceColor;
        _titleLine = view;
    }
    return _titleLine;
}


-(UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        UILabel * label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = self.styleModel.titleFont;
        label.textColor = self.styleModel.titleColor;
        label.text = self.styleModel.title;
        label.numberOfLines = 0;
        _titleLabel = label;
    }
    return _titleLabel;
}


-(UITextView *)textView
{
    if (_textView == nil) {
        UITextView * view = [[UITextView alloc] init];
        view.backgroundColor = self.styleModel.backgroudColor;
        view.textContainerInset = UIEdgeInsetsZero;
        view.textContainer.lineFragmentPadding = 0;
        view.showsVerticalScrollIndicator = NO;
        view.alwaysBounceVertical = YES;
        view.editable = NO;
        view.selectable = YES;
        view.dataDetectorTypes = UIDataDetectorTypeLink;
        view.delegate = self;
        _textView = view;
    }
    return _textView;
}

-(UIView *)buttonView
{
    if (_buttonView == nil) {
        UIView * view = [[UIView alloc] init];
        view.backgroundColor = self.styleModel.lineSpaceColor;
        _buttonView = view;
    }
    return _buttonView;
}

-(UIButton *)sureButton
{
    if (_sureButton == nil) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.backgroundColor = self.styleModel.backgroudColor;
        [button setTitleColor:self.styleModel.sureTitleColor forState:UIControlStateNormal];
        button.titleLabel.font = self.styleModel.sureTitleFont;
        [button setTitle:self.styleModel.sureTitle forState:UIControlStateNormal];
        [button addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
        _sureButton = button;
    }
    return _sureButton;
}


-(UIButton *)cancelButton
{
    if (_cancelButton == nil) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.backgroundColor = self.styleModel.backgroudColor;
        [button setTitleColor:self.styleModel.cancelTitleColor forState:UIControlStateNormal];
        [button setTitle:self.styleModel.cancelTitle forState:UIControlStateNormal];
        button.titleLabel.font = self.styleModel.cancelTitleFont;
        [button addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
        _cancelButton = button;
    }
    return _cancelButton;
}

@end

