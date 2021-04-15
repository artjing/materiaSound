//
//  PDPatch.m
//  emptyExample
//
//  Created by 董静 on 6/18/20.
//

#import "PDPatch.h"

@implementation PDPatch


-(instancetype)initWithFile:(NSString *)pdfile
{
    void * patch;
    self = [super init];
    if(self){
        patch = [PdBase openFile:pdfile path:[[NSBundle mainBundle]resourcePath]];
        if (patch) {
            NSLog(@"path have");
        }
    }
    return self;
}

-(void)onPatch:(float)on
{
    float pn = (float)on;
    if( pn>0 ){
        [PdBase sendFloat:pn toReceiver:@"onOff"];
        [PdBase sendFloat:500 toReceiver:@"lopNum"];

    }else{
        [PdBase sendFloat:0 toReceiver:@"onOff"];
    }
}

-(void)switchPatch:(float)patchNum
{
    float num = (float)patchNum;
    if( num >0 )
    [PdBase sendFloat:num toReceiver:@"lopNum"];
}

-(void)changeNoise:(float)num
{
    float value = (float)num;
    if (value>0) {
        [PdBase sendFloat:value toReceiver:@"lopNum"];
    }
}

@end
