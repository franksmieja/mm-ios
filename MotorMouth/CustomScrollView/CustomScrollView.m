//
//  CustomScrollView.m
//  NursingProject
//
//  Created by macmini01 on 23/09/15.
//  Copyright (c) 2015 Mac021. All rights reserved.
//

#import "CustomScrollView.h"

@implementation CustomScrollView
- (id) initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        self.contentMode=UIViewContentModeScaleAspectFit;
    }
    return self;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.maindelegate respondsToSelector:@selector(touchesBegan:withEvent:)]) {
        [self.maindelegate touchesBegan:touches withEvent:event];
    }

}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.maindelegate respondsToSelector:@selector(touchesEnded:withEvent:)]) {
        [self.maindelegate touchesEnded:touches withEvent:event];
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)dealloc
{
    NSLog(@"CustomScrollView Dealloc Call");
}


@end
