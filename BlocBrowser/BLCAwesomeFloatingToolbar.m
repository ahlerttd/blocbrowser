//
//  BLCAwesomeFloatingToolbar.m
//  BlocBrowser
//
//  Created by Trevor Ahlert on 8/13/14.
//  Copyright (c) 2014 Trevor Ahlert. All rights reserved.
//

#import "BLCAwesomeFloatingToolbar.h"

@interface BLCAwesomeFloatingToolbar ()

@property(nonatomic, strong) NSArray *currentTitles;
@property(nonatomic, strong) NSArray *colors;
@property(nonatomic, strong) NSArray *buttons;

@property(nonatomic, strong) UIButton *backButton;
@property(nonatomic, strong) UIButton *forwardButton;
@property(nonatomic, strong) UIButton *stopButton;
@property(nonatomic, strong) UIButton *refreshButton;

@end

@implementation BLCAwesomeFloatingToolbar

#pragma mark - Setup

- (instancetype)initWithFourTitles:(NSArray *)titles {
  if (self = [super init]) {
    self.currentTitles = titles;

  self.colors = @[
      [UIColor redColor],
      [UIColor blueColor],
      [UIColor greenColor],
      [UIColor yellowColor]
    ];
  
    [self setupSubviews];
    [self setupGestures];

    self.buttons = @[self.backButton, self.forwardButton, self.stopButton, self.refreshButton];
  }
   return self;
}

- (void) setupSubviews {
  [self addSubview:self.backButton];
  [self addSubview:self.forwardButton];
  [self addSubview:self.stopButton];
  [self addSubview:self.refreshButton];
}

- (void) setupGestures {
  UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                             initWithTarget:self
                                             action:@selector(longPressFired:)];
  [self addGestureRecognizer:longPress];
  
  UIPanGestureRecognizer *panGesture =
  [[UIPanGestureRecognizer alloc] initWithTarget:self
                                          action:@selector(panFired:)];
  [self addGestureRecognizer:panGesture];
  UIPinchGestureRecognizer *pinchGesture =
  [[UIPinchGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(pinchFired:)];
  [self addGestureRecognizer:pinchGesture];
  
  
}

#pragma mark - Lazy Loading

-(UIButton *) refreshButton{
  if (!_refreshButton){
    _refreshButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _refreshButton.backgroundColor = [UIColor yellowColor];
    _refreshButton.alpha = .25;
    [_refreshButton setTitle:@"Refresh" forState:UIControlStateNormal];
    [_refreshButton addTarget:self
                           action:@selector(buttonPressed:)
                 forControlEvents:UIControlEventTouchUpInside];
  }
  return _refreshButton;
}

- (UIButton *) stopButton {
  if (!_stopButton){
    _stopButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _stopButton.backgroundColor = [UIColor greenColor];
    _stopButton.alpha = .25;
    [_stopButton setTitle:@"Stop" forState:UIControlStateNormal];
    [_stopButton addTarget:self
                        action:@selector(buttonPressed:)
              forControlEvents:UIControlEventTouchUpInside];
  }
  return _stopButton;
}


- (UIButton *) forwardButton {
  if (!_forwardButton){
  _forwardButton = [UIButton buttonWithType:UIButtonTypeSystem];
  _forwardButton.backgroundColor = [UIColor blueColor];
  _forwardButton.alpha = .25;
  [_forwardButton setTitle:@"Forward" forState:UIControlStateNormal];
  [_forwardButton addTarget:self
                         action:@selector(buttonPressed:)
               forControlEvents:UIControlEventTouchUpInside];
  }
  return _forwardButton;
}

- (UIButton *) backButton {
  if (!_backButton) {
    _backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _backButton.backgroundColor = [UIColor redColor];
    _backButton.alpha = .25;
    [_backButton setTitle:@"Back" forState:UIControlStateNormal];
    [_backButton addTarget:self
                        action:@selector(buttonPressed:)
              forControlEvents:UIControlEventTouchUpInside];
  }
  return _backButton;
}

- (void)layoutSubviews {
  CGFloat labelHeight = CGRectGetHeight(self.bounds) / 2;
  CGFloat labelWidth = CGRectGetWidth(self.bounds) / 2;
  self.backButton.frame = CGRectMake(0, 0, labelWidth, labelHeight);
  self.forwardButton.frame =
      CGRectMake((CGRectGetWidth(self.bounds)) / 2, 0, labelWidth, labelHeight);
  self.stopButton.frame =
      CGRectMake(0, CGRectGetHeight(self.bounds) / 2, labelWidth, labelHeight);
  self.refreshButton.frame =
      CGRectMake(labelWidth, labelHeight, labelWidth, labelHeight);

}

#pragma mark - Target/Action

- (void)buttonPressed:(UIButton *)sender {
  UIButton *pressed = sender;
  /// NSString *title = sender.currentTitle;

  if ([self.delegate
          respondsToSelector:@selector(floatingToolbar:didSelectButton:)]) {
    [self.delegate floatingToolbar:self didSelectButton:(UIButton *)pressed];
  }
}

#pragma mark - Gesture Recognizers

- (void)longPressFired:(UILongPressGestureRecognizer *)recognizer {
  if (recognizer.state == UIGestureRecognizerStateRecognized) {
    
    NSMutableArray *newColors = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < self.colors.count; ++i) {
      [newColors addObject:self.colors[(i - 1) % self.colors.count]];
     
    }
    
    self.colors = newColors;
    
    [self.buttons enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop) {
      button.backgroundColor = self.colors[idx];
    }];
  }
}

- (void)panFired:(UIPanGestureRecognizer *)recognizer {
  if (recognizer.state == UIGestureRecognizerStateChanged) {
    CGPoint translation = [recognizer translationInView:self];

    NSLog(@"New translation: %@", NSStringFromCGPoint(translation));

    if ([self.delegate respondsToSelector:@selector(floatingToolbar:
                                              didTryToPanWithOffset:)]) {
      [self.delegate floatingToolbar:self didTryToPanWithOffset:translation];
    }
    [recognizer setTranslation:CGPointZero inView:self];
  }
}

- (void)pinchFired:(UIPinchGestureRecognizer *)recognizer {
  if (recognizer.state == UIGestureRecognizerStateChanged) {
    

    
    if ([self.delegate respondsToSelector:@selector(floatingToolbar:
                                              didTryToPinchWithOffset:)]) {
      [self.delegate floatingToolbar:self didTryToPinchWithOffset:recognizer.scale];
    }
  }
}

#pragma mark - Button Enabling

- (void)setEnabled:(BOOL)enabled forButtonWithTitle:(NSString *)title {
  NSUInteger index = [self.currentTitles indexOfObject:title];
  if (index != NSNotFound) {
    UIButton *button = [self.buttons objectAtIndex:index];
    button.userInteractionEnabled = enabled;
    button.alpha = enabled ? 1.0 : 0.25;
  }
}

@end
