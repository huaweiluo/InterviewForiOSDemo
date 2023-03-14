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
@property (nonatomic, assign, readonly) const char* bundleIdentifier;
@property (nonatomic, assign) NSInteger ticketSurplusCount;
@property (nonatomic, strong) dispatch_semaphore_t semaphoreLock;
@end

@implementation IFDDemoForGCD

- (void)testMainQueue {
//    DISPATCH_GLOBAL_OBJECT(dispatch_queue_t, _dispatch_main_q);
//
//    //** 运行在主线程的Main queue */
//    dispatch_queue_main_t dqMainT = dispatch_get_main_queue();
//    NSLog(@"dqMainT:%@.", dqMainT);
//
//    //** 主线程执行 */
//     dispatch_async(dispatch_get_main_queue(), ^{
//          // something
//     });
//
//    //** 并行队列global dispatch queue (并行队列的执行顺序与其加入队列的顺序相同。) */
//
//    //**  后台执行 */
//    //** Returns the requested global queue or NULL if the requested global queue does not exist. */
//    dispatch_queue_global_t qgT = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 1);
//    NSLog(@"qgT is %@.", qgT ? qgT :@"nil");
//
//     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//          // something
//         NSLog(@"dispatch_get_global_queue");
//     });
//
//    //** 一次性执行 */
//     static dispatch_once_t onceToken;
//     dispatch_once(&onceToken, ^{
//         // code to be executed once
//     });
//
//    //** 延迟2秒执行 */
//     double delayInSeconds = 2.0;
//     dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
//     dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//         // code to be executed on the main queue after delay
//     });
//
//    //** 自定义dispatch_queue_t */
//     dispatch_queue_t urls_queue = dispatch_queue_create("blog.devtang.com", DISPATCH_QUEUE_SERIAL);
//     dispatch_async(urls_queue, ^{
//         // your code
//     });
////    DISPATCH_SWIFT_UNAVAILABLE("Can't be used with ARC")
////     dispatch_release(urls_queue);
//
//    //** 合并汇总结果 */
//     dispatch_group_t group = dispatch_group_create();
//     dispatch_group_async(group, dispatch_get_global_queue(0,0), ^{
//          // 并行执行的线程一
//     });
//     dispatch_group_async(group, dispatch_get_global_queue(0,0), ^{
//          // 并行执行的线程二
//     });
//     dispatch_group_notify(group, dispatch_get_global_queue(0,0), ^{
//          // 汇总结果
//     });
//
//    //** 栅栏方法 dispatch_barrier_async */
//    [self barrier];
//
//    [self testSynchronousOnMainThread];
//    [self testAsynchronousOnMainThread];
//    [self testSynchronousOnSerialQueue];
//    [self testAsynchronousOnSerialQueue];
//    [self testSynchronousOnConcurrentQueue];
//    [self testAsynchronousOnConcurrentQueue];
//    [self testDeadlockBySerialQueue];
//
//    [self testNest];
    
//    [self syncConcurrent];
//    [self asyncConcurrent];
//    [self syncSerial];
//    [self asyncSerial];
//    [self syncMain];
//    [self syncMainByOtherThread];
//    [self asyncMain];
    [self testBelow];
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

#pragma mark -
#pragma mark 同步执行 + 并发队列
/**
 * 同步执行 + 并发队列
 * 特点：在当前线程中执行任务，不会开启新线程，执行完一个任务，再执行下一个任务。
 */
- (void)syncConcurrent {
    NSLog(@"syncConcurrent - currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"syncConcurrent - syncConcurrent---begin");
    
    dispatch_queue_t queue = dispatch_queue_create(self.bundleIdentifier, DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_sync(queue, ^{
        // 追加任务 1
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"syncConcurrent - 1---%@",[NSThread currentThread]);      // 打印当前线程
    });
    
    dispatch_sync(queue, ^{
        // 追加任务 2
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"syncConcurrent - 2---%@",[NSThread currentThread]);      // 打印当前线程
    });
    
    dispatch_sync(queue, ^{
        // 追加任务 3
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"syncConcurrent - 3---%@",[NSThread currentThread]);      // 打印当前线程
    });
    
    NSLog(@"syncConcurrent - syncConcurrent---end");
}

#pragma mark -
#pragma mark 异步执行 + 并发队列
/**
 * 异步执行 + 并发队列
 * 特点：可以开启多个线程，任务交替（同时）执行。
 */
- (void)asyncConcurrent {
    NSLog(@"asyncConcurrent - currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"asyncConcurrent - asyncConcurrent---begin");
    
    dispatch_queue_t queue = dispatch_queue_create(self.bundleIdentifier, DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        // 追加任务 1
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"asyncConcurrent - 1---%@",[NSThread currentThread]);      // 打印当前线程
    });
    
    dispatch_async(queue, ^{
        // 追加任务 2
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"asyncConcurrent - 2---%@",[NSThread currentThread]);      // 打印当前线程
    });
    
    dispatch_async(queue, ^{
        // 追加任务 3
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"asyncConcurrent - 3---%@",[NSThread currentThread]);      // 打印当前线程
    });
    
    NSLog(@"asyncConcurrent - asyncConcurrent---end");
}

#pragma mark -
#pragma mark 同步执行 + 串行队列
/**
 * 同步执行 + 串行队列
 * 特点：不会开启新线程，在当前线程执行任务。任务是串行的，执行完一个任务，再执行下一个任务。
 */
- (void)syncSerial {
    NSLog(@"syncSerial - currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"syncSerial - syncSerial---begin");
    
    dispatch_queue_t queue = dispatch_queue_create("net.bujige.testQueue", DISPATCH_QUEUE_SERIAL);
    
    dispatch_sync(queue, ^{
        // 追加任务 1
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"syncSerial - 1---%@",[NSThread currentThread]);      // 打印当前线程
    });
    dispatch_sync(queue, ^{
        // 追加任务 2
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"syncSerial - 2---%@",[NSThread currentThread]);      // 打印当前线程
    });
    dispatch_sync(queue, ^{
        // 追加任务 3
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"syncSerial - 3---%@",[NSThread currentThread]);      // 打印当前线程
    });
    
    NSLog(@"syncSerial - syncSerial---end");
}

#pragma mark -
#pragma mark 异步执行 + 串行队列
/**
 * 异步执行 + 串行队列
 * 特点：会开启新线程，但是因为任务是串行的，执行完一个任务，再执行下一个任务。
 */
- (void)asyncSerial {
    NSLog(@"asyncSerial - currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"asyncSerial - asyncSerial---begin");
    
    dispatch_queue_t queue = dispatch_queue_create("net.bujige.testQueue", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(queue, ^{
        // 追加任务 1
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"asyncSerial - 1---%@",[NSThread currentThread]);      // 打印当前线程
    });
    dispatch_async(queue, ^{
        // 追加任务 2
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"asyncSerial - 2---%@",[NSThread currentThread]);      // 打印当前线程
    });
    dispatch_async(queue, ^{
        // 追加任务 3
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"asyncSerial - 3---%@",[NSThread currentThread]);      // 打印当前线程
    });
    
    NSLog(@"asyncSerial - asyncSerial---end");
}

#pragma mark -
#pragma mark 同步执行 + 主队列
/**
 * 同步执行 + 主队列
 * 特点(主线程调用)：互等卡主不执行。
 * 特点(其他线程调用)：不会开启新线程，执行完一个任务，再执行下一个任务。
 */
- (void)syncMain {
    
    NSLog(@"syncMain - currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"syncMain - syncMain---begin");
    
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    dispatch_sync(queue, ^{
        // 追加任务 1
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"syncMain - 1---%@",[NSThread currentThread]);      // 打印当前线程
    });
    
    dispatch_sync(queue, ^{
        // 追加任务 2
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"syncMain - 2---%@",[NSThread currentThread]);      // 打印当前线程
    });
    
    dispatch_sync(queue, ^{
        // 追加任务 3
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"syncMain - 3---%@",[NSThread currentThread]);      // 打印当前线程
    });
    
    NSLog(@"syncMain - syncMain---end");
}

#pragma mark -
#pragma mark 在其他线程中调用『同步执行 + 主队列』
- (void)syncMainByOtherThread {
    // 使用 NSThread 的 detachNewThreadSelector 方法会创建线程，并自动启动线程执行 selector 任务
    [NSThread detachNewThreadSelector:@selector(syncMain) toTarget:self withObject:nil];
}

#pragma mark -
#pragma mark 异步执行 + 主队列
/**
 * 异步执行 + 主队列
 * 特点：只在主线程中执行任务，执行完一个任务，再执行下一个任务
 */
- (void)asyncMain {
    NSLog(@"asyncMain - currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"asyncMain - asyncMain---begin");
    
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    dispatch_async(queue, ^{
        // 追加任务 1
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"asyncMain - 1---%@",[NSThread currentThread]);      // 打印当前线程
    });
    
    dispatch_async(queue, ^{
        // 追加任务 2
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"asyncMain - 2---%@",[NSThread currentThread]);      // 打印当前线程
    });
    
    dispatch_async(queue, ^{
        // 追加任务 3
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"asyncMain - 3---%@",[NSThread currentThread]);      // 打印当前线程
    });
    
    NSLog(@"asyncMain - asyncMain---end");
}

#pragma mark -
#pragma mark GCD 线程间的通信
/**
 * 线程间通信
 */
- (void)communication {
    // 获取全局并发队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    // 获取主队列
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    
    NSLog(@"communication - begin ---%@",[NSThread currentThread]);      // 打印当前线程
    
    dispatch_async(queue, ^{
        // 异步追加任务 1
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"communication - 1---%@",[NSThread currentThread]);      // 打印当前线程
        
        // 回到主线程
        dispatch_async(mainQueue, ^{
            // 追加在主线程中执行的任务
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"communication - 2---%@",[NSThread currentThread]);      // 打印当前线程
        });
    });
    
    NSLog(@"communication - end ---%@",[NSThread currentThread]);      // 打印当前线程
}

#pragma mark -
#pragma mark GCD 快速迭代方法：dispatch_apply
/**
 * 快速迭代方法 dispatch_apply
 */
- (void)apply {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    NSLog(@"apply---begin");
    dispatch_apply(6, queue, ^(size_t index) {
        NSLog(@"apply---%zd---%@",index, [NSThread currentThread]);
    });
    
    NSLog(@"apply---end");
}

#pragma mark -
#pragma mark GCD dispatch_group_wait
/**
 * 队列组 dispatch_group_wait
 */
- (void)groupWait {
    NSLog(@"groupWait -- currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"groupWait -- group---begin");
    
    dispatch_group_t group =  dispatch_group_create();
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 追加任务 1
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"groupWait -- 1---%@",[NSThread currentThread]);      // 打印当前线程
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 追加任务 2
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"groupWait -- 2---%@",[NSThread currentThread]);      // 打印当前线程
    });
    
    // 等待上面的任务全部完成后，会往下继续执行（会阻塞当前线程）
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    
    NSLog(@"groupWait -- group---end");
    
}

#pragma mark -
#pragma mark GCD dispatch_group_enter / dispatch_group_leave
/**
 * 队列组 dispatch_group_enter、dispatch_group_leave
 */
- (void)groupEnterAndLeave {
    NSLog(@"groupEnterAndLeave -- currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"groupEnterAndLeave -- group---begin");
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        // 追加任务 1
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"groupEnterAndLeave -- 1---%@",[NSThread currentThread]);      // 打印当前线程

        dispatch_group_leave(group);
    });
    
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        // 追加任务 2
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"groupEnterAndLeave -- 2---%@",[NSThread currentThread]);      // 打印当前线程
        
        dispatch_group_leave(group);
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        // 等前面的异步操作都执行完毕后，回到主线程.
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"groupEnterAndLeave -- 3---%@",[NSThread currentThread]);      // 打印当前线程
    
        NSLog(@"groupEnterAndLeave -- group---end");
    });
}

#pragma mark -
#pragma mark GCD 信号量：dispatch_semaphore
/**
 * semaphore 线程同步
 */
- (void)semaphoreSync {
    
    NSLog(@"semaphoreSync - currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"semaphoreSync - semaphore---begin");
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    __block int number = 0;
    dispatch_async(queue, ^{
        // 追加任务 1
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"semaphoreSync - 1---%@",[NSThread currentThread]);      // 打印当前线程
        
        number = 100;
        
        dispatch_semaphore_signal(semaphore);
    });
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    NSLog(@"semaphoreSync - semaphore---end,number = %d", number);
}

#pragma mark -
#pragma mark Dispatch Semaphore 线程安全和线程同步（为线程加锁）
//** 非线程安全（不使用 semaphore） */
/**
 * 非线程安全：不使用 semaphore
 * 初始化火车票数量、卖票窗口（非线程安全）、并开始卖票
 */
- (void)initTicketStatusNotSave {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"semaphore---begin");
    
    self.ticketSurplusCount = 50;
    
    // queue1 代表北京火车票售卖窗口
    dispatch_queue_t queue1 = dispatch_queue_create("net.bujige.testQueue1", DISPATCH_QUEUE_SERIAL);
    // queue2 代表上海火车票售卖窗口
    dispatch_queue_t queue2 = dispatch_queue_create("net.bujige.testQueue2", DISPATCH_QUEUE_SERIAL);
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(queue1, ^{
        [weakSelf saleTicketNotSafe];
    });
    
    dispatch_async(queue2, ^{
        [weakSelf saleTicketNotSafe];
    });
}

/**
 * 售卖火车票（非线程安全）
 */
- (void)saleTicketNotSafe {
    while (1) {
        
        if (self.ticketSurplusCount > 0) {  // 如果还有票，继续售卖
            self.ticketSurplusCount--;
            NSLog(@"%@", [NSString stringWithFormat:@"剩余票数：%ld 窗口：%@", (long)self.ticketSurplusCount, [NSThread currentThread]]);
            [NSThread sleepForTimeInterval:0.2];
        } else { // 如果已卖完，关闭售票窗口
            NSLog(@"所有火车票均已售完");
            break;
        }
        
    }
}

//** 线程安全（使用 semaphore 加锁）*/
/**
 * 线程安全：使用 semaphore 加锁
 * 初始化火车票数量、卖票窗口（线程安全）、并开始卖票
 */
- (void)initTicketStatusSave {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"semaphore---begin");
    
    self.semaphoreLock = dispatch_semaphore_create(1);
    
    self.ticketSurplusCount = 50;
    
    // queue1 代表北京火车票售卖窗口
    dispatch_queue_t queue1 = dispatch_queue_create("net.bujige.testQueue1", DISPATCH_QUEUE_SERIAL);
    // queue2 代表上海火车票售卖窗口
    dispatch_queue_t queue2 = dispatch_queue_create("net.bujige.testQueue2", DISPATCH_QUEUE_SERIAL);
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(queue1, ^{
        [weakSelf saleTicketSafe];
    });
    
    dispatch_async(queue2, ^{
        [weakSelf saleTicketSafe];
    });
}

/**
 * 售卖火车票（线程安全）
 */
- (void)saleTicketSafe {
    while (1) {
        // 相当于加锁
        dispatch_semaphore_wait(self.semaphoreLock, DISPATCH_TIME_FOREVER);
        
        if (self.ticketSurplusCount > 0) {  // 如果还有票，继续售卖
            self.ticketSurplusCount--;
            NSLog(@"%@", [NSString stringWithFormat:@"剩余票数：%ld 窗口：%@", (long)self.ticketSurplusCount, [NSThread currentThread]]);
            [NSThread sleepForTimeInterval:0.2];
        } else { // 如果已卖完，关闭售票窗口
            NSLog(@"所有火车票均已售完");
            
            // 相当于解锁
            dispatch_semaphore_signal(self.semaphoreLock);
            break;
        }
        
        // 相当于解锁
        dispatch_semaphore_signal(self.semaphoreLock);
    }
}

#pragma mark -
#pragma mark test below method
- (void)testBelow {
//    [self communication];
//    [self apply];
//    [self groupWait];
//    [self groupEnterAndLeave];
//    [self semaphoreSync];
//    [self initTicketStatusSave];
}

#pragma mark -
#pragma mark propety method
- (const char*)bundleIdentifier {
    return [[[NSBundle mainBundle] bundleIdentifier] UTF8String];
}

@end
