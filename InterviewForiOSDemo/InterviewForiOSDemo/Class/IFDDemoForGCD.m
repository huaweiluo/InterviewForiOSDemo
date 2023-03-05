//
//  IFDDemoForGCD.m
//  InterviewForiOSDemo
//
//  Created by jipengfei on 2023/3/5.
//

#import "IFDDemoForGCD.h"

/**
 GCD 的使用步骤其实很简单，只有两步：

 1.创建一个队列（串行队列或并发队列）；
 2.将任务追加到任务的等待队列中，然后系统就会根据任务类型执行任务（同步执行或异步执行）。
 */

@interface IFDDemoForGCD()
@end

@implementation IFDDemoForGCD

- (void)testMainQueue {
    DISPATCH_GLOBAL_OBJECT(dispatch_queue_t, _dispatch_main_q);
    
    //** 运行在主线程的Main queue */
    dispatch_queue_main_t dqMainT = dispatch_get_main_queue();
    NSLog(@"dqMainT:%@.", dqMainT);
    
    //** 主线程执行 */
     dispatch_async(dispatch_get_main_queue(), ^{
          // something
     });
    
    //** 并行队列global dispatch queue (并行队列的执行顺序与其加入队列的顺序相同。) */
    
    //**  后台执行 */
    //** Returns the requested global queue or NULL if the requested global queue does not exist. */
    dispatch_queue_global_t qgT = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 1);
    NSLog(@"qgT is %@.", qgT ? qgT :@"nil");
    
     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
          // something
         NSLog(@"dispatch_get_global_queue");
     });
    
    //** 一次性执行 */
     static dispatch_once_t onceToken;
     dispatch_once(&onceToken, ^{
         // code to be executed once
     });
    
    //** 延迟2秒执行 */
     double delayInSeconds = 2.0;
     dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
     dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
         // code to be executed on the main queue after delay
     });
    
    //** 自定义dispatch_queue_t */
     dispatch_queue_t urls_queue = dispatch_queue_create("blog.devtang.com", DISPATCH_QUEUE_SERIAL);
     dispatch_async(urls_queue, ^{
         // your code
     });
//    DISPATCH_SWIFT_UNAVAILABLE("Can't be used with ARC")
//     dispatch_release(urls_queue);
    
    //** 合并汇总结果 */
     dispatch_group_t group = dispatch_group_create();
     dispatch_group_async(group, dispatch_get_global_queue(0,0), ^{
          // 并行执行的线程一
     });
     dispatch_group_async(group, dispatch_get_global_queue(0,0), ^{
          // 并行执行的线程二
     });
     dispatch_group_notify(group, dispatch_get_global_queue(0,0), ^{
          // 汇总结果
     });
    
    //** 栅栏方法 dispatch_barrier_async */
    [self barrier];
    
    [self testSynchronousOnMainThread];
    [self testAsynchronousOnMainThread];
    [self testSynchronousOnSerialQueue];
    [self testAsynchronousOnSerialQueue];
    [self testSynchronousOnConcurrentQueue];
    [self testAsynchronousOnConcurrentQueue];
    [self testDeadlockBySerialQueue];
    
    [self testNest];
}

/**
 * 栅栏方法 dispatch_barrier_async
 */
- (void)barrier {
    dispatch_queue_t queue = dispatch_queue_create("net.bujige.testQueue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        // 追加任务 1
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
    });
    dispatch_async(queue, ^{
        // 追加任务 2
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
    });
    
    dispatch_barrier_async(queue, ^{
        // 追加任务 barrier
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"barrier---%@",[NSThread currentThread]);// 打印当前线程
    });
    
    dispatch_async(queue, ^{
        // 追加任务 3
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
    });
    dispatch_async(queue, ^{
        // 追加任务 4
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"4---%@",[NSThread currentThread]);      // 打印当前线程
    });
}

#pragma mark -
#pragma mark 同步执行 + 主队列 ①
- (void)testSynchronousOnMainThread {
    
    //** 同步任务, 添加到主队列执行, 锁死 */
//    dispatch_sync(dispatch_get_main_queue(), ^{
//
//        NSLog(@"testSynchronousMainThread 11111.");
//    });
}

#pragma mark -
#pragma mark 异步执行 + 主队列 ②
//** 没有开启新线程，串行执行任务 */
- (void)testAsynchronousOnMainThread {
    
    //** 没有开启新线程，串行执行任务 */
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSLog(@"testSynchronousMainThread 11111.");
        [NSThread sleepForTimeInterval:2.f];
    });
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSLog(@"testSynchronousMainThread 22222.");
    });
    
    NSLog(@"testSynchronousMainThread 33333.");
}

#pragma mark -
#pragma mark 同步执行, 串行队列 ③
//** 没有开启新线程，串行执行任务 */
- (void)testSynchronousOnSerialQueue {
    dispatch_queue_t urls_queue = dispatch_queue_create("huaweiluo.com.InterviewForiOSDemo", DISPATCH_QUEUE_SERIAL);
    
    dispatch_sync(urls_queue, ^{
        
        NSLog(@"testSynchronousOnSerialQueue 11111.");
        [NSThread sleepForTimeInterval:2.f];
    });
    
    dispatch_sync(urls_queue, ^{
        
        NSLog(@"testSynchronousOnSerialQueue 22222.");
    });
    
    NSLog(@"testSynchronousOnSerialQueue 33333.");
}

#pragma mark -
#pragma mark 异步执行, 串行队列 ④
//** 有开启新线程（1条），串行执行任务 */
- (void)testAsynchronousOnSerialQueue {
    dispatch_queue_t urls_queue = dispatch_queue_create("huaweiluo.com.InterviewForiOSDemo", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(urls_queue, ^{
        
        NSLog(@"testAsynchronousOnSerialQueue 11111.");
        [NSThread sleepForTimeInterval:2.f];
    });
    
    dispatch_async(urls_queue, ^{
        
        NSLog(@"testAsynchronousOnSerialQueue 22222.");
    });
    
    NSLog(@"testAsynchronousOnSerialQueue 33333.");
}

#pragma mark -
#pragma mark 同步执行, 并发队列 ⑤
//** 没有开启新线程，串行执行任务 */
- (void)testSynchronousOnConcurrentQueue {
    dispatch_queue_t urls_queue = dispatch_queue_create("huaweiluo.com.InterviewForiOSDemo", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_sync(urls_queue, ^{
        
        NSLog(@"testSynchronousOnConcurrentQueue 11111.");
        [NSThread sleepForTimeInterval:2.f];
        NSLog(@"testSynchronousOnConcurrentQueue 44444.");
    });
    
    dispatch_sync(urls_queue, ^{
        
        NSLog(@"testSynchronousOnConcurrentQueue 22222.");
    });
    
    NSLog(@"testSynchronousOnConcurrentQueue 33333.");
}

#pragma mark -
#pragma mark 异步执行, 并发队列 ⑥
//** 有开启新线程，并发执行任务 */
- (void)testAsynchronousOnConcurrentQueue {
    dispatch_queue_t urls_queue = dispatch_queue_create("huaweiluo.com.InterviewForiOSDemo", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(urls_queue, ^{
        
        NSLog(@"testAsynchronousOnConcurrentQueue 11111.");
        [NSThread sleepForTimeInterval:2.f];
        NSLog(@"testAsynchronousOnConcurrentQueue 44444.");
    });
    
    dispatch_async(urls_queue, ^{
        
        NSLog(@"testAsynchronousOnConcurrentQueue 22222.");
    });
    
    NSLog(@"testAsynchronousOnConcurrentQueue 33333.");
}

#pragma mark -
#pragma mark 锁死case
- (void)testDeadlockBySerialQueue {
    dispatch_queue_t queue = dispatch_queue_create("huaweiluo.com.InterviewForiOSDemo", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{    // 异步执行 + 串行队列
        
        NSLog(@"testDeadlockBySerialQueue 11111");
        
//        dispatch_sync(queue, ^{  // 同步执行 + 当前串行队列 (锁死)
//
//            NSLog(@"testDeadlockBySerialQueue 22222");
//
//            // 追加任务 1
//            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
//            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
//        });
        
        //** 1.内部队列是同步执行, 需要执行完当前任务, 再往下执行 */
        //** 2.任务添加到串行队列, 所以当前任务的执行需要等待队列中上个任务执行完毕, 再执行. */
        //** 3.任务2是任务1的一部分, 任务2不执行完毕, 任务1一直处于任务重, 导致锁死. */
        
    });
    
    NSLog(@"testDeadlockBySerialQueue 33333");
}

#pragma mark -
#pragma mark 嵌套
- (void)testNest {
    [self testSynchronousNest1];
    [self testAsynchronousNest1];
    [self testSynchronousNest2];
    [self testAsynchronousNest2];
    [self testSynchronousNest3];
    [self testAsynchronousNest3];
    [self testSynchronousNest4];
    [self tesAsynchronousNest4];
}

#pragma mark -
#pragma mark 嵌套 - [异步执行+并发队列] 嵌套 [同一个并发队列]
//** 没有开启新线程，串行执行任务 */
- (void)testSynchronousNest1 {
    NSLog(@"testSynchronousNest1 - 00000");
    
    dispatch_queue_t queue = dispatch_queue_create("huaweiluo.com.InterviewForiOSDemo", DISPATCH_QUEUE_CONCURRENT);
    dispatch_sync(queue, ^{
        
        NSLog(@"testSynchronousNest1 - 11111");
        
        dispatch_async(queue, ^{
            
            NSLog(@"testSynchronousNest1 - 22222");
        });
    });
    
    NSLog(@"testSynchronousNest1 - 33333");
    
    /**
     result:
     2023-03-05 19:13:07.199725+0800 InterviewForiOSDemo[45152:1448916] testSynchronousNest1 - 00000
     2023-03-05 19:13:07.199880+0800 InterviewForiOSDemo[45152:1448916] testSynchronousNest1 - 11111
     2023-03-05 19:13:07.200106+0800 InterviewForiOSDemo[45152:1448916] testSynchronousNest1 - 33333
     2023-03-05 19:13:07.200129+0800 InterviewForiOSDemo[45152:1449057] testSynchronousNest1 - 22222
     */
}

//** 有开启新线程，并发执行任务 */
- (void)testAsynchronousNest1 {
    NSLog(@"testAsynchronousNest1 - 00000");
    
    dispatch_queue_t queue = dispatch_queue_create("huaweiluo.com.InterviewForiOSDemo", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        
        NSLog(@"testAsynchronousNest1 - 11111");
        
        dispatch_async(queue, ^{
            
            NSLog(@"testAsynchronousNest1 - 22222");
        });
    });
    
    NSLog(@"testAsynchronousNest1 - 33333");
    
    /**
     result:
     2023-03-05 19:27:59.102076+0800 InterviewForiOSDemo[45758:1463975] testAsynchronousNest1 - 00000
     2023-03-05 19:27:59.102214+0800 InterviewForiOSDemo[45758:1463975] testAsynchronousNest1 - 33333
     2023-03-05 19:27:59.102233+0800 InterviewForiOSDemo[45758:1464228] testAsynchronousNest1 - 11111
     2023-03-05 19:27:59.102475+0800 InterviewForiOSDemo[45758:1464228] testAsynchronousNest1 - 22222
     */
}

#pragma mark -
#pragma mark 嵌套 - [同步执行+并发队列] 嵌套 [同一个并发队列]
//** 没有开启新线程，串行执行任务 */
- (void)testSynchronousNest2 {
    NSLog(@"testSynchronousNest2 - 00000");
    
    dispatch_queue_t queue = dispatch_queue_create("huaweiluo.com.InterviewForiOSDemo", DISPATCH_QUEUE_CONCURRENT);
    dispatch_sync(queue, ^{
        
        NSLog(@"testSynchronousNest2 - 11111");
        
        dispatch_sync(queue, ^{
            
            NSLog(@"testSynchronousNest2 - 22222");
        });
    });
    
    NSLog(@"testSynchronousNest2 - 33333");
    
    /**
     result:
     2023-03-05 19:30:57.887278+0800 InterviewForiOSDemo[45873:1467951] testSynchronousNest2 - 00000
     2023-03-05 19:30:57.887501+0800 InterviewForiOSDemo[45873:1467951] testSynchronousNest2 - 11111
     2023-03-05 19:30:57.887666+0800 InterviewForiOSDemo[45873:1467951] testSynchronousNest2 - 22222
     2023-03-05 19:30:57.887973+0800 InterviewForiOSDemo[45873:1467951] testSynchronousNest2 - 33333
     */
}

//** 有开启新线程，并发执行任务 */
- (void)testAsynchronousNest2 {
    NSLog(@"testAsynchronousNest2 - 00000");
    
    dispatch_queue_t queue = dispatch_queue_create("huaweiluo.com.InterviewForiOSDemo", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        
        NSLog(@"testAsynchronousNest2 - 11111");
        
        dispatch_sync(queue, ^{
            
            NSLog(@"testAsynchronousNest2 - 22222");
        });
    });
    
    NSLog(@"testAsynchronousNest2 - 33333");
    
    /**
     result:
     2023-03-05 19:34:28.709287+0800 InterviewForiOSDemo[46004:1472153] testAsynchronousNest2 - 00000
     2023-03-05 19:34:28.709429+0800 InterviewForiOSDemo[46004:1472153] testAsynchronousNest2 - 33333
     2023-03-05 19:34:28.709459+0800 InterviewForiOSDemo[46004:1472242] testAsynchronousNest2 - 11111
     2023-03-05 19:34:28.709772+0800 InterviewForiOSDemo[46004:1472242] testAsynchronousNest2 - 22222
     */
}

#pragma mark -
#pragma mark 嵌套 - [异步执行+串行队列] 嵌套 [同一个串行队列]
- (void)testSynchronousNest3 {
    NSLog(@"testSynchronousNest3 - 00000");
    
    dispatch_queue_t queue = dispatch_queue_create("huaweiluo.com.InterviewForiOSDemo", DISPATCH_QUEUE_SERIAL);
    dispatch_sync(queue, ^{
        
        NSLog(@"testSynchronousNest3 - 11111");
        
        dispatch_async(queue, ^{
            
            NSLog(@"testSynchronousNest3 - 22222");
        });
        
        NSLog(@"testSynchronousNest3 - 44444");
    });
    
    NSLog(@"testSynchronousNest3 - 33333");
    
    /**
     result:
     2023-03-05 20:02:59.416806+0800 InterviewForiOSDemo[46796:1500326] testSynchronousNest3 - 00000
     2023-03-05 20:03:04.891763+0800 InterviewForiOSDemo[46796:1500326] testSynchronousNest3 - 11111
     2023-03-05 20:03:07.035902+0800 InterviewForiOSDemo[46796:1500326] testSynchronousNest3 - 44444
     2023-03-05 20:03:08.258424+0800 InterviewForiOSDemo[46796:1500326] testSynchronousNest3 - 33333
     2023-03-05 20:03:08.258424+0800 InterviewForiOSDemo[46796:1500570] testSynchronousNest3 - 22222
     */
}

- (void)testAsynchronousNest3 {
    NSLog(@"testAsynchronousNest3 - 00000");
    
    dispatch_queue_t queue = dispatch_queue_create("huaweiluo.com.InterviewForiOSDemo", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        
        NSLog(@"testAsynchronousNest3 - 11111");
        
        dispatch_async(queue, ^{
            
            NSLog(@"testAsynchronousNest3 - 22222");
        });
        
        NSLog(@"testAsynchronousNest3 - 44444");
    });
    
    NSLog(@"testAsynchronousNest3 - 33333");
    
    /**
     result:
     2023-03-05 20:05:54.316416+0800 InterviewForiOSDemo[46921:1504755] testAsynchronousNest3 - 00000
     2023-03-05 20:05:59.947030+0800 InterviewForiOSDemo[46921:1504755] testAsynchronousNest3 - 33333
     2023-03-05 20:05:59.947039+0800 InterviewForiOSDemo[46921:1505016] testAsynchronousNest3 - 11111
     2023-03-05 20:05:59.947234+0800 InterviewForiOSDemo[46921:1505016] testAsynchronousNest3 - 44444
     2023-03-05 20:05:59.947345+0800 InterviewForiOSDemo[46921:1505016] testAsynchronousNest3 - 22222
     */
}

#pragma mark -
#pragma mark 嵌套 - [同步执行+串行队列] 嵌套 [同一个串行队列]
- (void)testSynchronousNest4 {
    NSLog(@"testSynchronousNest4 - 00000");
    
    dispatch_queue_t queue = dispatch_queue_create("huaweiluo.com.InterviewForiOSDemo", DISPATCH_QUEUE_SERIAL);
    dispatch_sync(queue, ^{
        
        NSLog(@"testSynchronousNest4 - 11111");
        
        //** 互相等待, 锁死 */
//        dispatch_sync(queue, ^{
//
//            NSLog(@"testSynchronousNest4 - 22222");
//        });
        
        NSLog(@"testSynchronousNest4 - 44444");
    });
    
    NSLog(@"testSynchronousNest4 - 33333");
    
    /**
     result: 锁死
     */
}

- (void)tesAsynchronousNest4 {
    NSLog(@"tesAsynchronousNest4 - 00000");
    
    dispatch_queue_t queue = dispatch_queue_create("huaweiluo.com.InterviewForiOSDemo", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        
        NSLog(@"tesAsynchronousNest4 - 11111");
        
        //** 互相等待, 锁死 */
//        dispatch_sync(queue, ^{
//
//            NSLog(@"tesAsynchronousNest4 - 22222");
//        });
        
        NSLog(@"tesAsynchronousNest4 - 44444");
    });
    
    NSLog(@"tesAsynchronousNest4 - 33333");
    
    /**
     result: 锁死
     */
}

@end
