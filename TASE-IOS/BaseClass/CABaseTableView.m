//
//  CABaseTableView.m
//  TASE-IOS
//
//   9/17.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CABaseTableView.h"

@implementation CABaseTableView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

@end
