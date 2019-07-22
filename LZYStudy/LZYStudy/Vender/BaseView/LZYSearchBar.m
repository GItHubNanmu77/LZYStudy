//
//  LZYSearchBar.m
//  LZYStudy
//
//  Created by cisdi on 2019/7/22.
//  Copyright © 2019 lzy. All rights reserved.
//

#import "LZYSearchBar.h"

#import "NSString+Modify.h"

#define kSearchBarBgPaddingX (7)
#define kSearchBarBgHeight (28)

@interface LZYSearchBar () <UITextFieldDelegate> {
    CGFloat _placeholderWidth;
}

@property (nonatomic, strong) UIControl *searchControl;

/// 取消搜索按钮
@property (nonatomic, strong) UIButton *cancelButton;
/// 搜索条背景
@property (nonatomic, strong) UIImageView *searchBarBgImageView;
/// 搜索图标
@property (nonatomic, strong) UIImageView *searchBarIconImageView;

@end

@implementation LZYSearchBar

/**
 *  <#Description#>
 *
 *  @return <#return value description#>
 */
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        [self searchControl];
        [self cancelButton];
        [self searchBarBgImageView];
        [self searchBarIconImageView];
        [self searchTextField];
        [self setCancelButtonHidden:NO];
    }
    return self;
}

- (void)loadSkin {
    // placeHolder文字颜色
    if (self.sPlaceholderTextColorName) {
//        UIColor *placeHolderTextColor = QZ_COLOR_FROM_RGB(self.sPlaceholderTextColorName);
        
            [self.searchTextField setValue:self.sPlaceholderTextColorName forKeyPath:@"_placeholderLabel.textColor"];
        
    }
    
    self.searchTextField.keyboardAppearance = UIKeyboardAppearanceDefault;
}

#pragma mark-- Event Response
/**
 *  显示/隐藏取消按钮
 *
 *  @param hidden <#hidden description#>
 */
- (void)setCancelButtonHidden:(BOOL)hidden {
    CGRect cancelRect = self.cancelButton.frame;
    if (hidden) {
        // 取消按钮
        cancelRect.size.width = 0.0;
        cancelRect.origin.x = self.searchControl.frame.size.width;
        self.cancelButton.frame = cancelRect;
        //解决searchTextField和SearchControl事件冲突
        self.searchTextField.userInteractionEnabled=NO;
        
        if(self.type == SearchBarTypePlaceholderLeft){
            [self.searchTextField resignFirstResponder];
            [UIView animateWithDuration:0.25 animations:^{
                // 搜索框背景
                CGRect bgRect = self.searchBarBgImageView.frame;
                bgRect.size.width = self.searchControl.frame.size.width - (30.0 + cancelRect.size.width);
                self.searchBarBgImageView.frame = bgRect;
                
                self.searchTextField.width = 140.0;
            }];
            return ;
        }
        // 搜索框背景
        CGRect bgRect = self.searchBarBgImageView.frame;
        bgRect.size.width = self.searchControl.frame.size.width - (14.0 + cancelRect.size.width);
        self.searchBarBgImageView.frame = bgRect;
        
        __block CGRect iconRect = self.searchBarIconImageView.frame;
        __block CGRect textFieldRect = self.searchTextField.frame;
        [UIView animateWithDuration:0.25
                         animations:^{
                             iconRect.origin.x = (self.searchBarBgImageView.width - (self.searchBarIconImageView.width + 10.0 + self->_placeholderWidth)) / 2.0;
                             textFieldRect.origin.x = iconRect.origin.x + iconRect.size.width + 10.0;
                             textFieldRect.size.width = 140.0;
                             self.searchBarIconImageView.frame = iconRect;
                             self.searchTextField.frame = textFieldRect;
                         }
                         completion:nil];
        
    } else {
        // 取消按钮
        cancelRect.size.width = 60.0;
        cancelRect.origin.x = self.searchControl.frame.size.width - cancelRect.size.width;
        self.cancelButton.frame = cancelRect;
        
        __block CGRect bgRect = self.searchBarBgImageView.frame;
        __block CGRect iconRect = self.searchBarIconImageView.frame;
        __block CGRect textFieldRect = self.searchTextField.frame;
        
        if(self.type == SearchBarTypePlaceholderLeft){
            [self.searchTextField resignFirstResponder];
            [UIView animateWithDuration:0.25 animations:^{
                
                bgRect.size.width = self.searchControl.frame.size.width - (7.0 + cancelRect.size.width);
                self.searchBarBgImageView.frame = bgRect;
                
                textFieldRect.size.width = self.searchBarBgImageView.frame.size.width - (textFieldRect.origin.x - 5.0);
                self.searchTextField.frame = textFieldRect;
                
            }];
            return ;
        }else{
            // 搜索框背景
            [UIView animateWithDuration:0.25
                             animations:^{
                                 bgRect.size.width = self.searchControl.frame.size.width - (7.0 + cancelRect.size.width);
                                 self.searchBarBgImageView.frame = bgRect;
                                 
                                 iconRect.origin.x = 7.0 + 10.0;
                                 textFieldRect.origin.x = iconRect.origin.x + iconRect.size.width + 5.0;
                                 textFieldRect.size.width = self.searchBarBgImageView.frame.size.width - (textFieldRect.origin.x - 5.0);
                                 self.searchBarIconImageView.frame = iconRect;
                                 self.searchTextField.frame = textFieldRect;
                             }
                             completion:nil];
        }
    }
}

#pragma mark-- TextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)aTextfield {
    [self.searchTextField resignFirstResponder];
    //当搜索条件为空时，隐藏键盘和取消按钮
    if(aTextfield.text.length==0){
        self.showsCancelButton=NO;
        // 显示完整数据
        if ([self.delegate respondsToSelector:@selector(searchBarCancelButtonClicked:)]) {
            [self.delegate searchBarCancelButtonClicked:self];
        }
        return YES;
    }
    if ([self.delegate respondsToSelector:@selector(searchBarSearchButtonClicked:)]) {
        [self.delegate searchBarSearchButtonClicked:self];
    }
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField {
    // 判断当前输入法是否是中文
    bool isChinese;
    
    if ([[[UITextInputMode currentInputMode] primaryLanguage] isEqualToString:@"en-US"]) {
        isChinese = false;
    } else {
        isChinese = true;
    }
    if (isChinese) {
        // 中文输入法下
        UITextRange *selectedRange = [textField markedTextRange];
        // 获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if ([self.delegate respondsToSelector:@selector(searchBar:textDidChange:)]) {
                [self.delegate searchBar:self textDidChange:textField.text];
            }
        } else {
            // 输入的英文还没有转化为汉字的状态
        }
    } else {
        // 英文输入法下
        if ([self.delegate respondsToSelector:@selector(searchBar:textDidChange:)]) {
            [self.delegate searchBar:self textDidChange:textField.text];
        }
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if ([self.delegate respondsToSelector:@selector(searchBarTextDidBeginEditing:)]) {
        [self.delegate searchBarTextDidBeginEditing:self];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if ([self.delegate respondsToSelector:@selector(searchBarTextDidEndEditing:)]) {
        [self.delegate searchBarTextDidEndEditing:self];
    }
}

#pragma mark-- Init Control
/**
 *  搜索控件
 *
 *  @return <#return value description#>
 */
- (UIControl *)searchControl {
    if (_searchControl == nil) {
        _searchControl = ({
            UIControl *searchControl = [[UIControl alloc] initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height)];
            searchControl.backgroundColor = [UIColor clearColor];
            __weak __typeof(self) weakSelf = self;
            [searchControl bk_addEventHandler:^(id sender) {
                __strong __typeof(weakSelf) strongSelf = weakSelf;
                
                [strongSelf setCancelButtonHidden:NO];
                //文本框
                strongSelf.searchTextField.userInteractionEnabled = YES;
                [strongSelf.searchTextField becomeFirstResponder];
                
            }
                             forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:searchControl];
            searchControl;
        });
    }
    return _searchControl;
}

/**
 *  取消按钮
 *
 *  @return <#return value description#>
 */
- (UIButton *)cancelButton {
    if (_cancelButton == nil) {
        _cancelButton = ({
            UIButton *cancelButton = [[UIButton alloc] init];
            cancelButton.frame = CGRectMake(self.searchControl.frame.size.width, 0.0, 0.0, self.searchControl.frame.size.height);
            cancelButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
            [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
            [cancelButton setTitleColor:RGB3(102) forState:UIControlStateNormal];
            
            __weak __typeof(self) weakSelf = self;
            [cancelButton bk_addEventHandler:^(id sender) {
                __strong __typeof(weakSelf) strongSelf = weakSelf;
                [strongSelf setCancelButtonHidden:YES];
                
                // 文本框
                [strongSelf.searchTextField resignFirstResponder];
                strongSelf.searchTextField.text = nil;
                strongSelf.searchTextField.userInteractionEnabled = NO;
                
                // 显示完整数据
                if ([strongSelf.delegate respondsToSelector:@selector(searchBarCancelButtonClicked:)]) {
                    [strongSelf.delegate searchBarCancelButtonClicked:self];
                }
            }
                            forControlEvents:UIControlEventTouchUpInside];
            [self.searchControl addSubview:cancelButton];
            cancelButton;
        });
    }
    return _cancelButton;
}

/**
 *  搜索框背景
 *
 *  @return <#return value description#>
 */
- (UIImageView *)searchBarBgImageView {
    if (_searchBarBgImageView == nil) {
        _searchBarBgImageView = ({
            CGFloat y = (CGRectGetHeight(self.frame) - kSearchBarBgHeight) / 2;
            UIImageView *searchBarBgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kSearchBarBgPaddingX, y, CGRectGetWidth(self.frame), kSearchBarBgHeight)];
            searchBarBgImageView.userInteractionEnabled = NO;
            searchBarBgImageView.layer.cornerRadius = 5.0;
            [self.searchControl addSubview:searchBarBgImageView];
            searchBarBgImageView;
        });
    }
    return _searchBarBgImageView;
}

/**
 *  搜索小图标
 *
 *  @return <#return value description#>
 */
- (UIImageView *)searchBarIconImageView {
    if (_searchBarIconImageView == nil) {
        _searchBarIconImageView = ({
            UIImage *searchBarIconImage = [UIImage imageNamed:@"Search_Icon"];
            UIImageView *searchBarIconImageView = [[UIImageView alloc] init];
            searchBarIconImageView.image = searchBarIconImage;
            CGFloat y = (self.searchControl.frame.size.height - searchBarIconImage.size.height) / 2.0;
            searchBarIconImageView.frame = CGRectMake(0.0, y, searchBarIconImage.size.width, searchBarIconImage.size.height);
            [self.searchControl addSubview:searchBarIconImageView];
            searchBarIconImageView;
        });
    }
    return _searchBarIconImageView;
}

/**
 *  文本编辑框
 *
 *  @return <#return value description#>
 */
- (UITextField *)searchTextField {
    if (_searchTextField == nil) {
        _searchTextField = ({
            UITextField *searchTextField = [[UITextField alloc] init];
            searchTextField.frame = CGRectMake(0.0, self.searchBarBgImageView.frame.origin.y, 0.0, self.searchBarBgImageView.frame.size.height);
            searchTextField.delegate = self;
            searchTextField.backgroundColor = [UIColor clearColor];
            searchTextField.font = [UIFont systemFontOfSize:14.0];
            searchTextField.autocorrectionType = UITextAutocorrectionTypeNo;
            searchTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
            searchTextField.returnKeyType = UIReturnKeySearch;
            searchTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            searchTextField.textColor = [UIColor colorWithRed:0.00 green:0.00 blue:0.00 alpha:1.00];
            searchTextField.userInteractionEnabled = NO;
            searchTextField.placeholder = @"搜索";
            __weak __typeof(self) weakSelf = self;
            [searchTextField bk_addEventHandler:^(id sender) {
                [weakSelf textFieldDidChange:sender];
            }
             
                               forControlEvents:UIControlEventEditingChanged];
            [self.searchControl addSubview:searchTextField];
            searchTextField;
        });
    }
    return _searchTextField;
}


#pragma mark-- setter
- (void)setSBackgroundColorName:(UIColor *)sBackgroundColorName {
    _sBackgroundColorName = sBackgroundColorName;
//
//    if (_sBackgroundColorName) {
//        self.searchBarBgImageView.backgroundColor = QZ_COLOR_FROM_RGB(_sBackgroundColorName);
//    }
       self.searchBarBgImageView.backgroundColor = _sBackgroundColorName;
}

- (void)setSBackgroundImageName:(NSString *)sBackgroundImageName {
    _sBackgroundImageName = sBackgroundImageName;
    
    if (_sBackgroundImageName) {
//        self.searchBarBgImageView.image = QZ_IMAGE_FROM_PATH_RESIZEABLE(_sBackgroundImageName,YES);
        self.searchBarBgImageView.image = [UIImage imageNamed:_sBackgroundImageName];
    }
}

- (void)setSSearchIconImageName:(NSString *)sSearchIconImageName {
    _sSearchIconImageName = sSearchIconImageName;
    
    if (_sSearchIconImageName) {
//        self.searchBarIconImageView.image = QZ_IMAGE_FROM_PATH(_sSearchIconImageName);
        self.searchBarIconImageView.image= [UIImage imageNamed:_sSearchIconImageName];
    }
}

- (void)setSBoderWidth:(CGFloat)sBoderWidth {
    _sBoderWidth = sBoderWidth;
    
    if (_sBoderWidth > 0) {
        [self.searchBarBgImageView.layer setBorderWidth:_sBoderWidth];
    }
}

- (void)setSCornerRadius:(CGFloat)sCornerRadius {
    _sCornerRadius = sCornerRadius;
    
    if (_sCornerRadius > 0) {
        [self.searchBarBgImageView.layer setCornerRadius:_sCornerRadius];
    }
}

- (void)setSBoderColorName:(UIColor *)sBoderColorName {
    _sBoderColorName = sBoderColorName;
//
//    if (_sBoderColorName) {
//        self.searchBarBgImageView.layer.borderColor = QZ_COLOR_FROM_RGB(_sBoderColorName).CGColor;
//    }
    self.searchBarBgImageView.layer.borderColor = _sBoderColorName.CGColor;
}

- (void)setSPlaceholderTextColorName:(UIColor *)sPlaceholderTextColorName {
    _sPlaceholderTextColorName = sPlaceholderTextColorName;
    
    [self loadSkin];
}

- (void)setSTextColorName:(UIColor *)sTextColorName {
    _sTextColorName = sTextColorName;
    
    if (_sTextColorName) {
//        self.searchTextField.textColor = QZ_COLOR_FROM_RGB(_sTextColorName);
    }
    self.searchTextField.textColor = _sTextColorName;
}

- (void)setPlaceholder:(NSString *)placeholder {
    self.searchTextField.placeholder = placeholder;
    
    // 计算默认文本的宽度
    CGSize size = [placeholder getSizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(200.0, kSearchBarBgHeight)];
    _placeholderWidth = size.width;
}

- (void)setSCancelButtonColorName:(UIColor *)sCancelButtonColorName {
    _sCancelButtonColorName = sCancelButtonColorName;
    
    if (_sCancelButtonColorName) {
//        [self.cancelButton setTitleColor:QZ_COLOR_FROM_RGB(_sCancelButtonColorName) forState:UIControlStateNormal];
    }
    [self.cancelButton setTitleColor:_sCancelButtonColorName forState:UIControlStateNormal];
}

- (void)setSFont:(CGFloat)sFont {
    _sFont = sFont;
    
    self.searchTextField.font = [UIFont systemFontOfSize:sFont];
}

- (void)setShowsCancelButton:(BOOL)showsCancelButton {
    [self setCancelButtonHidden:!showsCancelButton];
}

-(void)setType:(SearchBarType)type{
    _type = type;
    
    switch (type) {
        case SearchBarTypePlaceholderLeft:{
            self.searchControl.backgroundColor = [UIColor whiteColor];
            self.searchBarIconImageView.x = 20.0;
            self.searchTextField.x = self.searchBarIconImageView.right + 5.0;
            
            self.searchBarBgImageView.x = 15;
            self.searchBarBgImageView.width = LZY_SCREEN_WIDTH - 30;
        }
            break;
        case SearchBarTypePlaceholderCenter:{
            
        }
            break;
        default:
            break;
    }
}

@end
