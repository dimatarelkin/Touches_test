//
//  ViewController.m
//  Touches_test+Animation
//
//  Created by Dmitriy Tarelkin on 2/5/18.
//  Copyright © 2018 Dmitriy Tarelkin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) UIView* draggingView;
@property (assign, nonatomic) CGPoint touchOffset;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //create few subViews
    for (int i = 0; i <10; i+=1) {
        UIView* subView = [[UIView alloc] initWithFrame:CGRectMake(100, 100 + i*120, 100, 100)];
        subView.backgroundColor = [self randomColor];
        
        
//        UIImageView* imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bricks.png"]];
//        [subView addSubview:imgView];
        
        [self.view addSubview:subView];
    }
    
    //self.view.multipleTouchEnabled = YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - Custom Methods
-(void)logTouches:(NSSet*)touches withMethod:(NSString*)methodName {
    NSMutableString* string = [NSMutableString stringWithString:methodName];
    
    //add touch to string
    for (UITouch* touch in touches) {
        CGPoint point = [touch locationInView:self.view];
        [string appendFormat:@" %@", NSStringFromCGPoint(point)];
    }
    NSLog(@"%@",string);
    
}

-(UIColor*)randomColor {
    CGFloat r = (CGFloat)(arc4random() %256) /255.f;
    CGFloat g = (CGFloat)(arc4random() %256) /255.f;
    CGFloat b = (CGFloat)(arc4random() %256) /255.f;
    
    return [UIColor colorWithRed:r green:g blue:b alpha:1.f];
}

#pragma mark - Touches

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    [self logTouches:touches withMethod:@"touches Began"];
    
    UITouch* touch = [touches anyObject];
    CGPoint pointOnMainView = [touch locationInView: self.view];            //getting location of
    UIView* subView = [self.view hitTest:pointOnMainView withEvent:event];  //return the deepest subView
    
    //capture our view
    if (![subView isEqual:self.view]) {
        self.draggingView = subView;
        
        [self.view bringSubviewToFront:self.draggingView];                  //bring subView we touch to front
        
        CGPoint touchPoint = [touch locationInView:self.draggingView];
        self.touchOffset = CGPointMake(CGRectGetMidX(self.draggingView.bounds) - touchPoint.x,
                                       CGRectGetMidY(self.draggingView.bounds) - touchPoint.y);
        NSLog(@"Hit this view!");
        //[self.draggingView.layer removeAllAnimations];
        
        //add some animation when we touch :)
        self.draggingView.backgroundColor = [UIColor greenColor];           //when start move view will change color
        [UIView animateWithDuration:0.3
                         animations:^{
                             CGAffineTransform scale  = CGAffineTransformMakeScale(1.5f, 1.5f);
                             CGAffineTransform rotate = CGAffineTransformMakeRotation(M_PI);
                             self.draggingView.alpha  = 0.3f;
                             
                             self.draggingView.transform = CGAffineTransformConcat(scale, rotate);
                         }];
    } else {
        self.draggingView = nil;
    }
    
    
}




- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    [self logTouches:touches withMethod:@"touches Moved"];
    
    if (self.draggingView) {
        
        UITouch* touch = [touches anyObject];
        
        CGPoint pointOnMainView = [touch locationInView: self.view];
        
        CGPoint correctionPoint = CGPointMake(pointOnMainView.x + self.touchOffset.x,
                                              pointOnMainView.y + self.touchOffset.y);
        
        self.draggingView.center = correctionPoint;
    }
}

-(void)onTouchesEnded {
    //animation when touch ended
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.draggingView.transform = CGAffineTransformIdentity;
                         self.draggingView.alpha = 1.0f;
                         self.draggingView.backgroundColor = [self randomColor];
                     }];
    self.draggingView = nil;
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    [self logTouches:touches withMethod:@"touches Ended"];
    [self onTouchesEnded];
    self.draggingView = nil;
    
    
}


- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    [self logTouches:touches withMethod:@"touches Cancelled"];
    [self onTouchesEnded];
    self.draggingView = nil;
    
}
@end
