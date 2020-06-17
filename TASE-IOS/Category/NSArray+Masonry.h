//
//  NSArray+Masonry.h
//  TASE-IOS
//
//   10/22.
//  Copyright © 2019 CA. All rights reserved.
//



#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (Masonry)

-(void)mas_distributeViewsWithItemHeight:(CGFloat)itemHeight
             wrapLineCount:(NSInteger)count
                 lineSpace:(CGFloat)lineSpace
                 itemSpace:(CGFloat)itemSpace
                 superView:(UIView*)superView;
/**实现 九宫格*/
-(void)mas_distributeViewsWithItemHeight:(CGFloat)itemHeight
             wrapLineCount:(NSInteger)count
                 lineSpace:(CGFloat)lineSpace
                 itemSpace:(CGFloat)itemSpace
                topSpacing:(CGFloat)topSpacing
             bottomSpacing:(CGFloat)bottomSpacing
               leadSpacing:(CGFloat)leadSpacing
               tailSpacing:(CGFloat)tailSpacing
                 superView:(UIView*)superView;

@end

NS_ASSUME_NONNULL_END
