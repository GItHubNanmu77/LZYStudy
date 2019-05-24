//
//  UIView+Snapshot.m
//  LZYStudy
//
//  Created by cisdi on 2019/5/24.
//  Copyright © 2019 lzy. All rights reserved.
//

#import "UIView+Snapshot.h"

@implementation UIView (Snapshot)
- (UIImage *)snapshotImage {
    @autoreleasepool {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, [UIScreen mainScreen].scale);
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *snap = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return snap;
    }
}

- (UIImage *)snapshotScrollViewWithHeight:(CGFloat)height {
    @autoreleasepool {
        if (![self isKindOfClass:[UIScrollView class]]) {
            return [self snapshotImage];
        }
        
        UIScrollView *scrollView = (UIScrollView *)self;
        if (scrollView.contentSize.height < height) {
            return [self snapshotImage];
        }
        
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(scrollView.contentSize.width, height), self.opaque, [UIScreen mainScreen].scale);
        CGPoint savedContentOffset = ((UIScrollView *)self).contentOffset;
        CGRect savedFrame = ((UIScrollView *)self).frame;
        ((UIScrollView *)self).contentOffset = CGPointZero;
        ((UIScrollView *)self).frame = CGRectMake(0, 0, ((UIScrollView *)self).contentSize.width, height);
        [((UIScrollView *)self).layer renderInContext: UIGraphicsGetCurrentContext()];
        UIImage *snap = UIGraphicsGetImageFromCurrentImageContext();
        ((UIScrollView *)self).contentOffset = savedContentOffset;
        ((UIScrollView *)self).frame = savedFrame;
        UIGraphicsEndImageContext();
        return snap;
    }
}

- (UIImage *)snapshotImageAfterScreenUpdates:(BOOL)afterUpdates {
    @autoreleasepool {
        if (![self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
            return [self snapshotImage];
        }
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, [UIScreen mainScreen].scale);
        [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:afterUpdates];
        UIImage *snap = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return snap;
    }
}

- (NSData *)snapshotPDF {
    @autoreleasepool {
        CGRect bounds = self.bounds;
        NSMutableData* data = [NSMutableData data];
        CGDataConsumerRef consumer = CGDataConsumerCreateWithCFData((__bridge CFMutableDataRef)data);
        CGContextRef context = CGPDFContextCreate(consumer, &bounds, NULL);
        CGDataConsumerRelease(consumer);
        if (!context) return nil;
        CGPDFContextBeginPage(context, NULL);
        CGContextTranslateCTM(context, 0, bounds.size.height);
        CGContextScaleCTM(context, 1.0, -1.0);
        [self.layer renderInContext:context];
        CGPDFContextEndPage(context);
        CGPDFContextClose(context);
        CGContextRelease(context);
        return data;
    }
}

@end
