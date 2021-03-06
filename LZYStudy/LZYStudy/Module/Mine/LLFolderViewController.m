//
//  LLFolderViewController.m
//  LZYStudy
//
//  Created by cisdi on 2019/7/18.
//  Copyright © 2019 lzy. All rights reserved.
//

#import "LLFolderViewController.h"
#import "NSString+Modify.h"

@interface LLFolderViewController ()
@property (nonatomic, strong) UITextField *inputTextField;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIButton *expandButton;
@property (nonatomic, assign) CGFloat textHeight;
@end

@implementation LLFolderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.textHeight = 44;
    
    [self.view addSubview:self.inputTextField];
    [self.view addSubview:self.contentLabel];
    [self.view addSubview:self.expandButton];
    
    [self layout];
    
    
    //    [self convertToArrayFromHexString:@"4154440000046affffff98ffffffebc423"];
    [self convertToArrayFromHexString:@"4154440000085cffffff10ffffffcd1423"];
    
    // 角度X
    NSString *angleYStr = @"FFFFFCC0"; // 230
    int outVal;
    NSScanner *scanner = [NSScanner scannerWithString:angleYStr];
    [scanner scanHexInt:&outVal];
    double angleY = ((double)outVal) / 10;
    NSLog(@"角度Y:%.3f", angleY);
}

- (void)textFieldDidChange:(UITextField *)tf {
    self.contentLabel.text  = tf.text;
}
- (void)refresh{
    CGSize size = [self.contentLabel.text getSizeWithFont:LZY_FONT_FROM_NAME_SIZE(15) constrainedToSize:CGSizeMake(200, MAXFLOAT)];
    if (self.expandButton.selected) {
        if (size.height > 47) {
            self.textHeight = size.height;
            [self.contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(self.textHeight);
            }];
        }
        
    } else {
        [self.contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(47);
        }];
    }
    
    
    
}
- (void)layout{
    [self.inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(64);
        make.left.equalTo(self.view).offset(16);
        make.right.equalTo(self.view).offset(-16);
        make.height.mas_equalTo(40);
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.inputTextField.mas_bottom).offset(20);
        make.left.equalTo(self.view).offset(66);
        make.width.mas_equalTo(200);
    }];
    [self.expandButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentLabel.mas_bottom);
        make.left.equalTo(self.contentLabel.mas_right).offset(-50);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(20);
    }];
}
- (UITextField *)inputTextField {
    if (!_inputTextField) {
        _inputTextField = ({
            UITextField *textField = [[UITextField alloc] init];
            textField.font = LZY_FONT_FROM_NAME_SIZE(16.0);
            textField.textAlignment = NSTextAlignmentLeft;
            textField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            textField.placeholder = @"placeHolder";
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            textField;
        });
    }
    return _inputTextField;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.font = LZY_FONT_FROM_NAME_SIZE(15);
            label.textColor = RGB3(51);
            label.numberOfLines = 0;
            label.backgroundColor = [UIColor yellowColor];
            label.lineBreakMode = NSLineBreakByTruncatingMiddle;
            
            label;
        });
    }
    return _contentLabel;
}

- (UIButton *)expandButton {
    if (!_expandButton) {
        _expandButton = ({
            @LZY_weakify(self)
            UIButton *button = [[UIButton alloc] init];
            button.showsTouchWhenHighlighted = YES;
            button.titleLabel.font = LZY_FONT_FROM_NAME_SIZE(15.0);
            [button setTitleColor:RGB3(120) forState:UIControlStateNormal];
            [button setTitle:@"展开" forState:UIControlStateNormal];
            [button setTitle:@"隐藏" forState:UIControlStateSelected];
            [button setBackgroundColor:[UIColor clearColor]];
            [button bk_addEventHandler:^(UIButton *sender) {
                @LZY_strongify(self)
                sender.selected = !sender.selected;
                [self refresh];
            } forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _expandButton;
}
- (NSMutableArray *)convertToArrayFromHexString:(NSString *)hexString {
    
    if (!hexString || hexString.length == 0) {
        return nil;
    }
    NSMutableArray *array = [NSMutableArray array];
    if(hexString.length == 34) {
        // 前缀：ATD
        NSString *prefixStr = [hexString substringToIndex:6];
        
        char *myBuffer = (char *)malloc((int)[prefixStr length] / 2 + 1);
        bzero(myBuffer, [prefixStr length] / 2 + 1);
        for (int i = 0; i < [prefixStr length] - 1; i += 2) {
            unsigned int anInt;
            NSString *hexCharStr = [prefixStr substringWithRange:NSMakeRange(i, 2)];
            NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
            [scanner scanHexInt:&anInt];
            myBuffer[i / 2] = (char)anInt;
        }
        NSString *unicodeString = [NSString stringWithCString:myBuffer encoding:4];
        NSLog(@"前缀字符串:%@",unicodeString);
        
        if ([unicodeString isEqualToString:@"ATD"]) {
            // 距离
            NSString *distanceStr = [hexString substringWithRange:NSMakeRange(6, 8)];
            long distance = strtoul(distanceStr.UTF8String, 0, 16);
            double distanceD = ((double)distance) / 10000;
            NSLog(@"距离:%.3f米", distanceD);
            
            // 角度X
            NSString *angleXStr = [hexString substringWithRange:NSMakeRange(14, 8)];
            if([angleXStr hasPrefix:@"f"]) {
                
            }
            int outValX;
            NSScanner *scannerX = [NSScanner scannerWithString:angleXStr];
            [scannerX scanHexInt:&outValX];
            double angleX = ((double)outValX) / 10;
            NSLog(@"角度X:%.3f", angleX);
            
            // 角度Y
            NSString *angleYStr = [hexString substringWithRange:NSMakeRange(22, 8)];
            int outValY;
            NSScanner *scannerY = [NSScanner scannerWithString:angleYStr];
            [scannerY scanHexInt:&outValY];
            double angleY = ((double)outValY) / 10;
            NSLog(@"角度Y:%.3f", angleY);
            
            [array addObject:@(distanceD)];
            [array addObject:@(angleX)];
            [array addObject:@(angleY)];
        }
    }
    return array;
    
}

@end
