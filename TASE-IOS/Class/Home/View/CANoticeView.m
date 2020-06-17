
//
//  CANoticeView.m
//  TASE-IOS
//
//   9/12.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CANoticeView.h"
#import "CANoticeModel.h"

@interface CANoticeView()

/* 定时器 */
@property (strong , nonatomic) NSTimer *timer;

@property (nonatomic, strong) UIImageView * leftImageView;
/* 滚动按钮数组 */
@property (strong , nonatomic) NSMutableArray *saveMiddleArray;

@end

@implementation CANoticeView

-(CGFloat)getHeight{
    
    CGSize size1 = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size1.height;
}

- (void)setUpRollingCenter
{

    if (self.saveMiddleArray.count > 0) return;
    
    if (self.roleArray.count > 0) {
        CGRect middleFrame =  CGRectMake(CGRectGetMaxX(self.leftImageView.frame), 2, MainWidth-30 - CGRectGetMaxX(self.leftImageView.frame), [self getHeight]-4);
        for (NSInteger i = 0; i < self.roleArray.count; i++) {
            
            UIButton *middleView = [self getBackMiddleViewWithFrame:middleFrame WithIndex:i];

            UILabel *contentLabel = [UILabel new];
            [middleView addSubview:contentLabel];
            contentLabel.textAlignment = NSTextAlignmentLeft;
            CANoticeModel * model = self.roleArray[i];
            contentLabel.text = model.title;
            contentLabel.frame = CGRectMake(5, 0, middleView.width - 10, middleView.height);
            contentLabel.dk_textColorPicker = DKColorPickerWithKey(NormalBlackColor_1e2667);
            contentLabel.font = FONT_SEMOBOLD_SIZE(13);
            
            [self setUpCATransform3DWithIndex:i WithButton:middleView]; //旋转
        }
    }
}

#pragma mark - 开始滚动
- (void)beginRolling{
    
    if (self.roleArray.count>1) {
        _timer = [NSTimer scheduledAutoReleaseTimerWithTimeInterval:5 target:self selector:@selector(titleRolling) userinfo:nil repeats:YES];
        self.isRolling = YES;
    }
}

#pragma mark - 结束滚动
- (void)endRolling{
    
    [_timer invalidate];
    _timer = nil;
    self.isRolling = NO;
}

#pragma mark - 标题滚动
- (void)titleRolling{
    
    if (self.saveMiddleArray.count > 1) { //所存的每组滚动
        __weak typeof(self)weakSelf = self;
        
        [UIView animateWithDuration:0.5 animations:^{
            
            [self getMiddleArrayWithIndex:0 WithAngle:- M_PI_2 Height:- [self getHeight] / 2]; //第0组
            [self getMiddleArrayWithIndex:1 WithAngle:0 Height:0]; //第一组
            
        } completion:^(BOOL finished) {
            
            if (finished == YES) { //旋转结束
                UIButton *newMiddleView = [weakSelf getMiddleArrayWithIndex:0 WithAngle:M_PI_2 Height: -[self getHeight] / 2];
                [weakSelf.saveMiddleArray addObject:newMiddleView];
                [weakSelf.saveMiddleArray removeObjectAtIndex:0];
            }
        }];
    }
    
}
#pragma mark - CATransform3D翻转
- (UIButton *)getMiddleArrayWithIndex:(NSInteger)index WithAngle:(CGFloat)angle Height:(CGFloat)height
{
    if (index > _saveMiddleArray.count) return 0;
    UIButton *middleView = self.saveMiddleArray[index];
    
    CATransform3D trans = CATransform3DIdentity;
    trans = CATransform3DMakeRotation(angle, 1, 0, 0);
    trans = CATransform3DTranslate(trans, 0, height, height);
    middleView.layer.transform = trans;
    
    return middleView;
}

#pragma mark - 初始化中间View
- (UIButton *)getBackMiddleViewWithFrame:(CGRect)frame WithIndex:(NSInteger)index
{
    UIButton *middleView = [UIButton buttonWithType:UIButtonTypeCustom];
    middleView.adjustsImageWhenHighlighted = NO;
    
    [middleView addTarget:self action:@selector(titleButonAction:) forControlEvents:UIControlEventTouchUpInside];
    middleView.frame = frame;
    middleView.tag = 100+index;
    [self addSubview:middleView];
    [self.saveMiddleArray addObject:middleView];
    
    return middleView;
}
-(void)titleButonAction:(UIButton*)btn{
    
    NSLog(@"%ld",btn.tag);
    NSInteger tag = btn.tag-100;
    if (tag<self.roleArray.count) {
        CANoticeModel * model = self.roleArray[tag];
        [self routerEventWithName:NSStringFromClass([self class]) userInfo:model.url];
    }
}
#pragma mark - 初始布局
- (void)setUpCATransform3DWithIndex:(NSInteger)index WithButton:(UIButton *)contentButton
{
    if (index != 0) {
        CATransform3D trans = CATransform3DIdentity;
        trans = CATransform3DMakeRotation(M_PI_2, 1, 0, 0);
        trans = CATransform3DTranslate(trans, 0, -[self getHeight] / 2, -[self getHeight] / 2);
        contentButton.layer.transform = trans;
    }else{
        CATransform3D trans = CATransform3DIdentity;
        trans = CATransform3DMakeRotation(0, 1, 0, 0);
        trans = CATransform3DTranslate(trans, 0, 0, -[self getHeight] / 2);
        contentButton.layer.transform = trans;
    }
}

-(void)setRoleArray:(NSArray *)roleArray{
    
    _roleArray = roleArray;
    if (roleArray.count) {
        
        [self endRolling];
        
        for (UIView * view in self.saveMiddleArray) {
            [view removeFromSuperview];
        }
        
        [self.saveMiddleArray removeAllObjects];
        
        [self setUpRollingCenter];
    }
    
}

- (NSMutableArray *)saveMiddleArray
{
    if (!_saveMiddleArray) {
        _saveMiddleArray = [NSMutableArray array];
    }
    return _saveMiddleArray;
}

-(UIImageView *)leftImageView{
    if (!_leftImageView) {
        _leftImageView  = [[UIImageView alloc] init];
        [self addSubview:_leftImageView];
        _leftImageView.image = IMAGE_NAMED(@"Notice");
        
        CGSize size1 = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];

        _leftImageView.frame = CGRectMake(15,(size1.height-15)/2.f , 18, 15);
    }
    return _leftImageView;
}

@end
