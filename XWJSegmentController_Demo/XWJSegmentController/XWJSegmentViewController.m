//
//  XWJSegmentViewController.m
//  XWJSegmentControllerProject
//
//  Created by qianfeng on 16/9/24.
//  Copyright © 2016年 com.xuwenjie. All rights reserved.
//

#import "XWJSegmentViewController.h"


/**
 标题导航按钮的间距
 */
#define NavigatorButtonInterSpace 60


/**
 标题导航左右到边框的距离
 */
#define NavigatorButtonBoardSpace 20

/**
 标题导航按钮的大小
 */
#define NavigatorButtonSize CGRectMake(0, 0, 60, 40)


/**
 标题导航视图的高度
 */
#define titleNavigatorView_Height 50

/**
 主题颜色
 */
#define ThemeColor [UIColor redColor]


/**
 指示器高度
 */
#define directLineHeight 10



@interface XWJSegmentViewController ()<UIScrollViewDelegate>


/**
 标题导航栏
 */
@property (nonatomic,weak) UIScrollView *titleNavigatorView;

/**
 标题下标指示器
 */
@property (nonatomic,weak) UIView *directLine;

/**
 子控制器ScrollView
 */
@property (nonatomic,weak) UIScrollView *contentScrollView;


/**
 选中的控制器下标
 */
@property (nonatomic,assign) NSInteger selectedIndex;


@end

@implementation XWJSegmentViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self config];
    
    [self contentScrollView];
    
    [self titleNavigatorView];
    
    [self directLine];
}

#pragma mark - Lazy Load
- (NSMutableArray<UIViewController<XWJSegmentChildrenControllerProtocol> *> *)segmentChildrenControllers {
    if (!_segmentChildrenControllers) {
        _segmentChildrenControllers = [NSMutableArray array];
    }
    return _segmentChildrenControllers;
}

- (UIScrollView *)titleNavigatorView {
    if (!_titleNavigatorView) {
        UIScrollView *titleNavigatorView = [[UIScrollView alloc] init];
        titleNavigatorView.showsHorizontalScrollIndicator = NO;
        titleNavigatorView.bounces = NO;
        titleNavigatorView.frame = CGRectMake(0, 64, self.view.frame.size.width, titleNavigatorView_Height);
        
        __block CGFloat offX = NavigatorButtonBoardSpace;
        
        [self.segmentChildrenControllers enumerateObjectsUsingBlock:^(UIViewController<XWJSegmentChildrenControllerProtocol> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
           
            NSString *title = [obj childrenControllerTitle];
            UIButton *navigatorButton = [UIButton buttonWithType:UIButtonTypeCustom];
            
            [navigatorButton addTarget:self action:@selector(titleNavigatorButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [navigatorButton setTitle:title forState:UIControlStateNormal];
            
            navigatorButton.backgroundColor = [UIColor clearColor];
            [navigatorButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [navigatorButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
            [navigatorButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
            navigatorButton.frame = NavigatorButtonSize;
            
            
            CGRect temp = navigatorButton.frame;
            temp.origin.x = offX;
            navigatorButton.frame = temp;
            
            
            offX += navigatorButton.frame.size.width + NavigatorButtonInterSpace;
            
            [titleNavigatorView addSubview:navigatorButton];
            
        }];
        
        titleNavigatorView.contentSize = CGSizeMake(offX - NavigatorButtonInterSpace + NavigatorButtonBoardSpace, 1);
        
        
        [self.view addSubview:titleNavigatorView];
        
        [self.view bringSubviewToFront:titleNavigatorView];
        
        titleNavigatorView.backgroundColor = [UIColor whiteColor];
        
        _titleNavigatorView = titleNavigatorView;
    }
    return _titleNavigatorView;
}

- (UIView *)directLine {
    if (!_directLine) {
        
        UIView *directLine = [[UIView alloc] init];
        UIButton *selectedButton = self.titleNavigatorView.subviews[self.selectedIndex];
        directLine.frame = CGRectMake(NavigatorButtonBoardSpace, NavigatorButtonSize.size.height, selectedButton.frame.size.width, directLineHeight);
        [directLine setBackgroundColor:ThemeColor];
        
        [self.titleNavigatorView addSubview:directLine];
        _directLine = directLine;
    }
    return _directLine;
}

- (UIScrollView *)contentScrollView {
    if (!_contentScrollView) {
        UIScrollView *contentScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        contentScrollView.pagingEnabled = YES;
        contentScrollView.bounces = NO;
        contentScrollView.backgroundColor = [UIColor yellowColor];
        contentScrollView.delegate = self;
        contentScrollView.showsHorizontalScrollIndicator = NO;
        contentScrollView.contentSize = CGSizeMake(self.segmentChildrenControllers.count * contentScrollView.bounds.size.width, 1);
        
        
        [self.segmentChildrenControllers enumerateObjectsUsingBlock:^(UIViewController<XWJSegmentChildrenControllerProtocol> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
           
            CGRect temp = obj.view.frame;
            temp.origin = CGPointMake(contentScrollView.bounds.size.width * idx, titleNavigatorView_Height);
            obj.view.frame = temp;
            
            [contentScrollView addSubview:obj.view];
        }];
        
        [self.view addSubview:contentScrollView];
        _contentScrollView = contentScrollView;
    }
    return _contentScrollView;
}

#pragma mark - Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    //当前应该选中的按钮下标数字
    self.selectedIndex = scrollView.contentOffset.x / self.view.bounds.size.width + 0.5;
    //改变导航栏的标题
    self.title = [self.segmentChildrenControllers[self.selectedIndex] childrenControllerTitle];
    
    //以下是滑动时候改变按钮状态的代码
    
    for (UIButton *btn in self.titleNavigatorView.subviews) {
        
        if ([btn isKindOfClass:[UIButton class]]) {
            [btn setSelected:NO];
        }
    }
    
    UIButton *button = self.titleNavigatorView.subviews[self.selectedIndex];
    
    [button setSelected:YES];
    
    //以下是改变下标指示器的位置的代码
    
    CGFloat index_float = scrollView.contentOffset.x / self.view.bounds.size.width;
    
    CGRect temp = self.directLine.frame;
    temp.origin.x = NavigatorButtonBoardSpace + index_float * (NavigatorButtonInterSpace + button.frame.size.width);
    self.directLine.frame = temp;
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    //titleNavigationView偏移
    [self titleNavigatorChangeContentOffset];
}

#pragma mark - Others
- (void)config {
    self.title = [self.segmentChildrenControllers.firstObject childrenControllerTitle];
    self.view.backgroundColor = [UIColor orangeColor];
    
    [self navigationConfig];
}

- (void)goBack {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)navigationConfig {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"后退" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationController.navigationBar.barTintColor = ThemeColor;
}

- (void)titleNavigatorButtonClick:(UIButton *)sender {
    
    //改变按钮状态
    for (UIButton *btn in self.titleNavigatorView.subviews) {
        
        if ([btn isKindOfClass:[UIButton class]]) {
            [btn setSelected:NO];
        }
    }
    [sender setSelected:YES];
    
    [self.titleNavigatorView.subviews enumerateObjectsUsingBlock:^(__kindof UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        if ([obj isKindOfClass:[UIButton class]] && obj.selected) {
            self.selectedIndex = idx;
        }
        
    }];
    
    //改变contentView的偏移
    [UIView animateWithDuration:0.3 animations:^{
        self.contentScrollView.contentOffset = CGPointMake(self.selectedIndex * self.view.bounds.size.width, -64);
    }];
    
    //titleNavigationView偏移
    [self titleNavigatorChangeContentOffset];
}


/**
 根据选中按钮的位置偏移按钮到适合的位置不被遮挡
 */
- (void)titleNavigatorChangeContentOffset {
    //改变titleNavigator的contentOffset
    CGFloat distance = CGRectGetMaxX(self.directLine.frame) - self.titleNavigatorView.contentOffset.x - self.titleNavigatorView.frame.size.width;
    
    if (distance >= 0) {
        
        CGPoint offset = self.titleNavigatorView.contentOffset;
        
        offset.x += distance + NavigatorButtonBoardSpace;
        
        [UIView animateWithDuration:0.3 animations:^{
            self.titleNavigatorView.contentOffset = offset;
        }];
    }
    CGFloat distance2 = self.directLine.frame.origin.x - self.titleNavigatorView.contentOffset.x;
    if (distance2 <= 0) {
        
        CGPoint offset = self.titleNavigatorView.contentOffset;
        
        offset.x -= -distance2 + NavigatorButtonBoardSpace;
        
        [UIView animateWithDuration:0.3 animations:^{
            self.titleNavigatorView.contentOffset = offset;
        }];
    }
}

@end
