//
//  IFDKvc.h
//  InterviewForiOSDemo
//
//  Created by jipengfei on 2023/3/4.
//

#import <Foundation/Foundation.h>
#import "IFDPropertyClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface IFDKvc : NSObject
@property (nonatomic, strong) IFDPropertyClass *propertyClass;

- (void)testKeyValueMethod;

@end

NS_ASSUME_NONNULL_END
