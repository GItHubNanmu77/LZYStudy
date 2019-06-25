//
//  LLCardSwitchLayout.h
//  LZYStudy
//
//  Created by cisdi on 2019/6/24.
//  Copyright © 2019 lzy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^XLCenterIndexPathBlock)(NSIndexPath *indexPath);

@interface LLCardSwitchLayout : UICollectionViewFlowLayout

@property (nonatomic , strong) XLCenterIndexPathBlock centerBlock;
@end

NS_ASSUME_NONNULL_END
