//
//  LLCategoryDetailTableViewCell.h
//  LZYStudy
//
//  Created by cisdi on 2019/6/14.
//  Copyright © 2019 lzy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLCategoryDetailTableViewCell : UITableViewCell
- (void)updateData:(NSString *)data;
@property (nonatomic, assign) BOOL isSelected;
@end

NS_ASSUME_NONNULL_END
