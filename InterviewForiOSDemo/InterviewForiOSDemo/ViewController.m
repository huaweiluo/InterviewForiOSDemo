//
//  ViewController.m
//  InterviewForiOSDemo
//
//  Created by jipengfei on 2023/3/4.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, strong) NSString *nameString;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.nameString = @"I am a string.";
    
    [self test];
}

#pragma mark -
#pragma mark test
- (void)test {
    id objProperty = [self valueForKey:@"nameString"];
    
    if ([objProperty isKindOfClass:[NSString class]]) {
        
        NSLog(@"objProperty:%@.", objProperty);
    }
    
    [self setValue:@"I am a new string." forKey:@"nameString"];
    
    NSLog(@"objProperty:%@.", self.nameString);
}

@end
