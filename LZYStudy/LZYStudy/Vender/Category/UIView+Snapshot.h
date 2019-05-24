//
//  UIView+Snapshot.h
//  LZYStudy
//
//  Created by cisdi on 2019/5/24.
//  Copyright © 2019 lzy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Snapshot)
/**
 Create a snapshot image of the complete view hierarchy.
 */
- (nullable UIImage *)snapshotImage;

- (nullable UIImage *)snapshotScrollViewWithHeight:(CGFloat)height;

/**
 Create a snapshot image of the complete view hierarchy.
 @discussion It's faster than "snapshotImage", but may cause screen updates.
 See -[UIView drawViewHierarchyInRect:afterScreenUpdates:] for more information.
 */
- (nullable UIImage *)snapshotImageAfterScreenUpdates:(BOOL)afterUpdates;

/**
 Create a snapshot PDF of the complete view hierarchy.
 */
- (nullable NSData *)snapshotPDF;
@end

NS_ASSUME_NONNULL_END
