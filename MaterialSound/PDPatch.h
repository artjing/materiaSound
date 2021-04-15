//
//  PDPatch.h
//  emptyExample
//
//  Created by 董静 on 6/18/20.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PdDispatcher.h"

NS_ASSUME_NONNULL_BEGIN

@interface PDPatch : NSObject

-(instancetype)initWithFile:(NSString *)pdfile;

-(void)onPatch:(float)on;
-(void)changeNoise:(float)num;
@end

NS_ASSUME_NONNULL_END
