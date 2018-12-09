//
//  CustomScrollView.h
//  NursingProject
//
//  Created by macmini01 on 23/09/15.
//  Copyright (c) 2015 Mac021. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ScrollDelegate <NSObject>
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;
@end

@interface CustomScrollView : UIScrollView
@property (assign, nonatomic) id<ScrollDelegate> maindelegate;

@end
