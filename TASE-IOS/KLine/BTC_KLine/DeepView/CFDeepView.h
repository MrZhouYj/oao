//
//  CFDeepView.h
//  CCLineChart
//
//  Created by ZM on 2018/9/13.
//  Copyright © 2018年 hexuren. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CFDeepView : UIView

/** 卖点数据 记录坐标值*/
@property (nonatomic,strong) NSArray *sellDataArrOfPoint;
/** 买点数据 */
@property (nonatomic,strong) NSArray *buyDataArrOfPoint;
/** Y轴坐标数据 右侧显示数据*/
@property (nonatomic, strong) NSArray *dataArrOfY;
/** X轴坐标数据 三个数据*/
@property (nonatomic, strong) NSArray *dataArrOfX;

@end
