//
//  CHPopoverListView.m
//  Mars
//
//  Created by jiamai on 15/10/10.
//  Copyright © 2015年 runsdata. All rights reserved.
//

#import "CHPopoverListView.h"
#import "Constant.h"
@interface CHPopoverListView()
@property (nonatomic, retain) UITableView *mainPopoverListView;
//@property (nonatomic, retain) UIControl *controlForDismiss;
@property (nonatomic, retain) UIVisualEffectView *effectView;
@property (nonatomic, retain) UIView *backgroundView;

- (void)initTheInterface;//初始化界面
- (void)animatedIn;//动画进入
- (void)animatedOut;//动画消失

@end

@implementation CHPopoverListView

@synthesize datasource = _datasource;
@synthesize delegate = _delegate;
@synthesize mainPopoverListView = _mainPopoverListView;
//@synthesize controlForDismiss = _controlForDismiss;
@synthesize effectView = _effectView;
@synthesize backgroundView = _backgroundView;

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initTheInterface];
    }
    return self;
}

- (void)initTheInterface{
    self.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    self.layer.borderWidth = 1.0f;
    self.layer.cornerRadius = 10.0f;
    self.clipsToBounds = YES;
    
    _mainPopoverListView = [[UITableView alloc]initWithFrame:self.bounds style:UITableViewStylePlain];
    self.mainPopoverListView.dataSource = self;
    self.mainPopoverListView.delegate = self;
    [self addSubview:self.mainPopoverListView];
    
}

- (void)refreshTheUserInterface{
    if (nil == _effectView) {
        _effectView = [[UIVisualEffectView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _effectView.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchForDismissSelf)];
        [_effectView addGestureRecognizer:tapGesture];
    }
}

- (void)refreshBackgroundView{
    if (nil == _backgroundView) {
        _backgroundView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _backgroundView.backgroundColor = [UIColor blackColor];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchForDismissSelf)];
        [_backgroundView addGestureRecognizer:tapGesture];
    }
}


- (NSIndexPath *)indexPathForSelectRow{
    return [self.mainPopoverListView indexPathForSelectedRow];
}

#pragma mark - UITableViewDatasource

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.datasource && [self.datasource respondsToSelector:@selector(popoverListView:numberOfRowsInSection:)]) {
        return [self.datasource popoverListView:self numberOfRowsInSection:section];
    }
    return 0;
}

- (UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if (self.datasource && [self.datasource respondsToSelector:@selector(popoverListView:cellForRowAtIndexPath:)]) {
        return [self.datasource popoverListView:self cellForRowAtIndexPath:indexPath];
    }
    return nil;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(nonnull UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if (self.delegate && [self.delegate respondsToSelector:@selector(popoverListView:didSelectRowAtIndexPath:)]) {
        [self.delegate popoverListView:self didSelectRowAtIndexPath:indexPath];
    }
}
- (void)tableView:(nonnull UITableView *)tableView didDeselectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if (self.delegate && [self.delegate respondsToSelector:@selector(popoverListView:didDeselectRowAtIndexPath:)]) {
        [self.delegate popoverListView:self didDeselectRowAtIndexPath:indexPath];
    }
}

#pragma mark - Animated Mthod
- (void)animatedIn{
    self.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.alpha = 0;
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 1;
        self.transform =CGAffineTransformMakeScale(1, 1);
    }];
}

- (void)animatedOut{
    [UIView animateWithDuration:0.5 animations:^{
        self.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            if (self) {
                [self removeFromSuperview];
            }
        }
    }];
}

#pragma mark - show of hide self
- (void)show{
    if (kIOSVerison < 8) {
        [self refreshBackgroundView];
        UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
        if (!(self.backgroundView == nil)) {
            self.backgroundView.alpha = 0.5;
            [keywindow addSubview:self.backgroundView];
        }
        [keywindow addSubview:self];
        self.center = CGPointMake(keywindow.bounds.size.width/2, keywindow.bounds.size.height/2);
        [self animatedIn];
    }else{
        [self refreshTheUserInterface];
        UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
        if (!(self.effectView == nil)) {
            UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
//            self.effectView.effect = blurEffect;
            //UIVisualEffectView *effectView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
            self.effectView.alpha = 0.5;
            //[self.controlForDismiss addSubview:effectView];
            [keywindow addSubview:self.effectView];
        }
        [keywindow addSubview:self];
        self.center = CGPointMake(keywindow.bounds.size.width/2, keywindow.bounds.size.height/2);
        [self animatedIn];
    }
}
- (void)dismiss
{
    [self animatedOut];
}

#pragma mark - Reuse Cycle
- (id)dequeueReusablePopoverCellWithIdentifier:(NSString *)identitier{
    return [self.mainPopoverListView dequeueReusableCellWithIdentifier:identitier];
}

- (UITableViewCell *)popoverCellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.mainPopoverListView cellForRowAtIndexPath:indexPath];
}

- (void)touchForDismissSelf{
    if (!(self.effectView ==nil)) {
        [self.effectView removeFromSuperview];
    }
    if (!(self.backgroundView ==nil)) {
        [self.backgroundView removeFromSuperview];
    }
    [self animatedOut];
}


@end
