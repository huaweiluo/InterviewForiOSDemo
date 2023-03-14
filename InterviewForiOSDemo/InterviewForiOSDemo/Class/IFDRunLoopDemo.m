//
//  IFDRunLoopDemo.m
//  InterviewForiOSDemo
//
//  Created by jipengfei on 2023/3/13.
//

#import "IFDRunLoopDemo.h"
#import <UIKit/UIKit.h>

@interface IFDRunLoopDemo()
@property (nonatomic, strong, readwrite) NSThread *thread;
@end

@implementation IFDRunLoopDemo

- (instancetype)init {
    self = [super init];
    if (self) {
        
        // 创建观察者
        CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(CFAllocatorGetDefault(), kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
            NSLog(@"监听到RunLoop发生改变---%zd",activity);
        });
        
        // 添加观察者到当前RunLoop中
        CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer, kCFRunLoopDefaultMode);
        
        // 释放observer，最后添加完需要释放掉
        CFRelease(observer);
        
    }
    return self;
}

#pragma mark -
#pragma mark internal method
- (void)run {
    
    NSLog(@"IFDRunLoopDemo - %@", NSStringFromSelector(_cmd));
}

#pragma mark -
#pragma mark start resident thread
- (void)startResidentThread {
    /// 创建线程，并调用run1方法执行任务
    self.thread = [[NSThread alloc] initWithTarget:self selector:@selector(runResidentMethod) object:nil];
    /// 开启线程
    [self.thread start];
}

- (void)runResidentMethod {
    /// 这里写任务
    NSLog(@"runResidentMethod - running, self.thread:%@.", [NSThread currentThread]);
    
    /// 添加下边两句代码，就可以开启RunLoop，之后self.thread就变成了常驻线程，可随时添加任务，并交于RunLoop处理
    [[NSRunLoop currentRunLoop] addPort:[NSPort port] forMode:NSDefaultRunLoopMode];
    [[NSRunLoop currentRunLoop] run];
    
    /// 测试是否开启了RunLoop，如果开启RunLoop，则来不了这里，因为RunLoop开启了循环。
    NSLog(@"runResidentMethod - 未开启RunLoop");
}

#pragma mark -
#pragma mark export method
- (void)testRunLoop {
    
    /// 定义一个定时器，约定两秒之后调用self的run方法
    NSTimer *timer = [NSTimer timerWithTimeInterval:0.1f target:self selector:@selector(run) userInfo:nil repeats:YES];
    
    /// 将定时器添加到当前RunLoop的NSDefaultRunLoopMode下
//    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
//    [[NSRunLoop currentRunLoop] addTimer:timer forMode:UITrackingRunLoopMode];
//    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
//    [self startResidentThread];
}

@end
