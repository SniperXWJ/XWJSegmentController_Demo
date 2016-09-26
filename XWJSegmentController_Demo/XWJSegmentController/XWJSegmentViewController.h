//
//  XWJSegmentViewController.h
//  XWJSegmentControllerProject
//
//  Created by qianfeng on 16/9/24.
//  Copyright © 2016年 com.xuwenjie. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 自定义颜色
 
 @param r 红 （0-255）
 @param g 绿 （0-255）
 @param b 蓝 （0-255）
 
 @return 自定义颜色
 */
#define ColorWith(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]


/**
 随机颜色
 */
#define RandomColor ColorWith(arc4random_uniform(256),arc4random_uniform(256),arc4random_uniform(256))


/**
 分页控制器的子控制器必须遵守的协议
 */
@protocol XWJSegmentChildrenControllerProtocol <NSObject>

@required

/**
 子控制器名称

 @return 子控制器title
 */
- (NSString *)childrenControllerTitle;

@end






@interface XWJSegmentViewController : UIViewController


/**
 分页控制器的子控制器数组
 */
@property (nonatomic,strong) NSMutableArray<UIViewController<XWJSegmentChildrenControllerProtocol> *> *segmentChildrenControllers;


@end
