//
//  LLDynamicCollectionViewCell.h
//  LZYStudy
//
//  Created by cisdi on 2019/5/17.
//  Copyright © 2019 lzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLDynamicModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LLDynamicCollectionViewCell : UICollectionViewCell
- (void)updateData:(LLDynamicModel *)model;
@end

NS_ASSUME_NONNULL_END
