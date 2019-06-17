//
//  LLShoppingCartTableViewCell.h
//  LZYStudy
//
//  Created by cisdi on 2019/6/14.
//  Copyright © 2019 lzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLShoppingCartModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LLShoppingCartTableViewCell : UITableViewCell

@property (nonatomic, copy) void(^cellButtonBlock) (UIButton *addButton);

- (void)updateData:(LLShoppingCartModel *)model;
@end

NS_ASSUME_NONNULL_END
