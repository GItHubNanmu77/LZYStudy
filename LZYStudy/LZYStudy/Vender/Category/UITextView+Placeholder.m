//
//  UITextView+Placeholder.m
//  LZYStudy
//
//  Created by cisdi on 2019/5/23.
//  Copyright © 2019 lzy. All rights reserved.
//

#import "UITextView+Placeholder.h"

@implementation UITextView (Placeholder)
-(void)setPlaceholder:(NSString *)placeholdStr placeholdColor:(UIColor *)placeholdColor
{
    NSString *version = [UIDevice currentDevice].systemVersion;
    if (version.doubleValue >= 8.0) {
        UILabel *placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        placeHolderLabel.text = placeholdStr;
        placeHolderLabel.numberOfLines = 0;
        placeHolderLabel.textColor = placeholdColor;
        placeHolderLabel.font = self.font;
        [placeHolderLabel sizeToFit];
        [self addSubview:placeHolderLabel];
        [self setValue:placeHolderLabel forKey:@"_placeholderLabel"];
    }
}
@end
