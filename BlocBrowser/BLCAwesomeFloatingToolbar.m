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
@property(nonatomic, strong) NSArray *labels;
@property(nonatomic, strong) NSArray *buttons;
@property(nonatomic, weak) UILabel *currentLabel;
@property(nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property(nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property(nonatomic, strong) UIPinchGestureRecognizer *pinchGesture;
@property(nonatomic, strong) UILongPressGestureRecognizer *longPress;
@property(nonatomic, strong) UIButton *toolButton;
@property(nonatomic, strong) UIButton *backButton;
@property(nonatomic, strong) UIButton *forwardButton;
@property(nonatomic, strong) UIButton *stopButton;
@property(nonatomic, strong) UIButton *refreshButton;

@end

@implementation BLCAwesomeFloatingToolbar

- (instancetype)initWithFourTitles:(NSArray *)titles {
  if (self = [super init]) {
    self.currentTitles = titles;

    NSLog(@"Titles %@ ", titles);

    self.colors = @[
      [UIColor redColor],
      [UIColor blueColor],
      [UIColor greenColor],
      [UIColor yellowColor]
    ];

    UIButton *buttonTopLeft = [UIButton buttonWithType:UIButtonTypeSystem];
    buttonTopLeft.backgroundColor = [UIColor redColor];
    buttonTopLeft.alpha = .25;
    [buttonTopLeft setTitle:@"Back" forState:UIControlStateNormal];
    [buttonTopLeft addTarget:self
                      action:@selector(buttonPressed:)
            forControlEvents:UIControlEventTouchUpInside];
    self.longPress = [[UILongPressGestureRecognizer alloc]
        initWithTarget:self
                action:@selector(longPressFired:)];
    [self addGestureRecognizer:self.longPress];
    self.backButton = buttonTopLeft;
    [self addSubview:self.backButton];

    UIButton *buttonTopRight = [UIButton buttonWithType:UIButtonTypeSystem];
    buttonTopRight.backgroundColor = [UIColor blueColor];
    buttonTopRight.alpha = .25;
    [buttonTopRight setTitle:@"Forward" forState:UIControlStateNormal];
    [buttonTopRight addTarget:self
                       action:@selector(buttonPressed:)
             forControlEvents:UIControlEventTouchUpInside];
    self.longPress = [[UILongPressGestureRecognizer alloc]
        initWithTarget:self
                action:@selector(longPressFired:)];
    [self addGestureRecognizer:self.longPress];
    self.forwardButton = buttonTopRight;
    [self addSubview:self.forwardButton];

    UIButton *buttonBottomLeft = [UIButton buttonWithType:UIButtonTypeSystem];
    buttonBottomLeft.backgroundColor = [UIColor greenColor];
    buttonBottomLeft.alpha = .25;
    [buttonBottomLeft setTitle:@"Stop" forState:UIControlStateNormal];
    [buttonBottomLeft addTarget:self
                         action:@selector(buttonPressed:)
               forControlEvents:UIControlEventTouchUpInside];
    self.longPress = [[UILongPressGestureRecognizer alloc]
        initWithTarget:self
                action:@selector(longPressFired:)];
    [self addGestureRecognizer:self.longPress];
    self.stopButton = buttonBottomLeft;
    [self addSubview:self.stopButton];

    UIButton *buttonBottomRight = [UIButton buttonWithType:UIButtonTypeSystem];
    buttonBottomRight.backgroundColor = [UIColor yellowColor];
    buttonBottomRight.alpha = .25;
    [buttonBottomRight setTitle:@"Refresh" forState:UIControlStateNormal];
    [buttonBottomRight addTarget:self
                          action:@selector(buttonPressed:)
                forControlEvents:UIControlEventTouchUpInside];
    self.longPress = [[UILongPressGestureRecognizer alloc]
        initWithTarget:self
                action:@selector(longPressFired:)];
    [self addGestureRecognizer:self.longPress];
    self.refreshButton = buttonBottomRight;
    [self addSubview:self.refreshButton];

    NSArray *buttonsArray = [[NSArray alloc]
        initWithObjects:buttonTopLeft, buttonTopRight, buttonBottomLeft,
                        buttonBottomRight, nil];

    self.buttons = buttonsArray;

    NSLog(@"Buttons Array %lu", (unsigned long)buttonsArray.count);
  }

  self.panGesture =
      [[UIPanGestureRecognizer alloc] initWithTarget:self
                                              action:@selector(panFired:)];
  [self addGestureRecognizer:self.panGesture];
  self.pinchGesture =
      [[UIPinchGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(pinchFired:)];
  [self addGestureRecognizer:self.pinchGesture];

  return self;

  /*for (NSString *currentTitle in self.currentTitles) {
      UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];

     ///button.userInteractionEnabled = NO;
      button.alpha = .25;

      NSUInteger currentTitleIndex =
      [self.currentTitles indexOfObject:currentTitle];
      NSString *titleForThisButton =
      [self.currentTitles objectAtIndex:currentTitleIndex];
      UIColor *colorForThisButton =
      [self.colors objectAtIndex:currentTitleIndex];

      button.backgroundColor = colorForThisButton;

      [button setTitle:titleForThisButton forState:UIControlStateNormal];

      [buttonsArray addObject:button];

      [button addTarget:self action:@selector(buttonPressed:)
  forControlEvents:UIControlEventTouchUpInside];
      self.longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self
  action:@selector(longPressFired:)];
      [self addGestureRecognizer: self.longPress];




      self.toolButton = button;
  }

  self.buttons = buttonsArray;

  for (UIButton *thisButon in self.buttons){
      [self addSubview: thisButon];

  }*/

  /*    NSMutableArray *labelsArray = [[NSMutableArray alloc] init];

      for (NSString *currentTitle in self.currentTitles) {
        UILabel *label = [[UILabel alloc] init];
        label.userInteractionEnabled = NO;
        label.alpha = .25;

        NSUInteger currentTitleIndex =
            [self.currentTitles indexOfObject:currentTitle];
        NSString *titleForThisLabel =
            [self.currentTitles objectAtIndex:currentTitleIndex];
        UIColor *colorForThisLabel =
            [self.colors objectAtIndex:currentTitleIndex];

        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:10];
        label.text = titleForThisLabel;
        label.backgroundColor = colorForThisLabel;
        label.textColor = [UIColor whiteColor];

        [labelsArray addObject:label];
      }

      self.labels = labelsArray;

      for (UILabel *thisLabel in self.labels) {
        [self addSubview:thisLabel];
      } */
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

  /*for (UIButton *thisButton in self.buttons) {
    NSUInteger currentButtonIndex = [self.buttons indexOfObject:thisButton];

    CGFloat labelHeight = CGRectGetHeight(self.bounds) / 2;
    CGFloat labelWidth = CGRectGetWidth(self.bounds) / 2;
      NSLog(@"%f", labelWidth);

    CGFloat labelX = 0;
    CGFloat labelY = 0;

    // adjust labelX and labelY for each label
    if (currentButtonIndex < 2) {
      // 0 or 1, so on top
      labelY = 0;
    } else {
      // 2 or 3, so on bottom
      labelY = CGRectGetHeight(self.bounds) / 2;
    }

    if (currentButtonIndex % 2 ==
        0) {  // is currentLabelIndex evenly divisible by 2?
      // 0 or 2, so on the left
      labelX = 0;
    } else {
      // 1 or 3, so on the right
      labelX = CGRectGetWidth(self.bounds) / 2;
    }

    thisButton.frame = CGRectMake(labelX, labelY, labelWidth, labelHeight);
  }*/
}

/*- (UILabel *)labelFromTouches:(NSSet *)touches withEvent:(UIEvent *)event {
 UITouch *touch = [touches anyObject];
 CGPoint location = [touch locationInView:self];
 UIView *subview = [self hitTest:location withEvent:event];
 return (UILabel *)subview;
} */

/* - (void) tapFired:(UITapGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateRecognized){
        CGPoint location = [recognizer locationInView:self];
        UIView *tappedView = [self hitTest:location withEvent:nil];

        if ([self.labels containsObject:tappedView]) {
            if ([self.delegate
respondsToSelector:@selector(floatingToolbar:didSelectButtonWithTitle:)]){
                [self.delegate floatingToolbar:self
didSelectButtonWithTitle:((UILabel *)tappedView).text];
            }
        }
    }

} */

- (void)buttonPressed:(UIButton *)sender {
  UIButton *pressed = sender;
  /// NSString *title = sender.currentTitle;

  if ([self.delegate
          respondsToSelector:@selector(floatingToolbar:didSelectButton:)]) {
    [self.delegate floatingToolbar:self didSelectButton:(UIButton *)pressed];
  }
}

- (void)longPressFired:(UILongPressGestureRecognizer *)recognizer {
  if (recognizer.state == UIGestureRecognizerStateRecognized) {
    CGPoint location = [recognizer locationInView:self];
    NSLog(@"LongPress x %2F LongPress y %2F", location.x, location.y);

    if ((self.backButton.backgroundColor == [UIColor redColor])) {
      self.backButton.backgroundColor = [UIColor greenColor];
      self.forwardButton.backgroundColor = [UIColor redColor];
      self.refreshButton.backgroundColor = [UIColor blueColor];
      self.stopButton.backgroundColor = [UIColor yellowColor];

    } else if ((self.backButton.backgroundColor == [UIColor greenColor])) {
      self.backButton.backgroundColor = [UIColor yellowColor];
      self.forwardButton.backgroundColor = [UIColor greenColor];
      self.refreshButton.backgroundColor = [UIColor redColor];
      self.stopButton.backgroundColor = [UIColor blueColor];

    } else if ((self.backButton.backgroundColor == [UIColor yellowColor])) {
      self.backButton.backgroundColor = [UIColor blueColor];
      self.forwardButton.backgroundColor = [UIColor yellowColor];
      self.refreshButton.backgroundColor = [UIColor greenColor];
      self.stopButton.backgroundColor = [UIColor redColor];

    } else if ((self.backButton.backgroundColor == [UIColor blueColor])) {
      self.backButton.backgroundColor = [UIColor redColor];
      self.forwardButton.backgroundColor = [UIColor blueColor];
      self.refreshButton.backgroundColor = [UIColor yellowColor];
      self.stopButton.backgroundColor = [UIColor greenColor];
    }
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
  if (recognizer.state == UIGestureRecognizerStateEnded) {
    CGFloat lastScale = 1.0;
    CGFloat scale = 1.0 - (lastScale - recognizer.scale);

    NSLog(@"Pinch Scale: %2F", scale);

    if ([self.delegate respondsToSelector:@selector(floatingToolbar:
                                              didTryToPinchWithOffset:)]) {
      [self.delegate floatingToolbar:self didTryToPinchWithOffset:scale];
    }
  }
}

#pragma mark - Button Enabling

/*- (void) setBackgroundColor:(UIColor *)backgroundColor
forColorButtonWithTitle: (UIButton *)colorButton {

    UIButton *button = [[UIButton alloc] init];

    NSArray *titles = self.buttons;

    for (button in titles){

    if (([self.backButton.currentTitle isEqualToString:@"Back"] &&
self.backButton.backgroundColor == [UIColor redColor]) ){

        self.backButton.backgroundColor = [UIColor greenColor];
        self.forwardButton.backgroundColor = [UIColor redColor];
        self.stopButton.backgroundColor = [UIColor blueColor];
        self.refreshButton.backgroundColor = [UIColor yellowColor];


    }


    }


        self.colors = @[
                    [UIColor redColor],
                    [UIColor blueColor],
                    [UIColor greenColor],
                    [UIColor yellowColor]
                    ];

    NSArray *titles = self.buttons;

    for (button in titles){

        UIColor *color = [[UIColor alloc] init];

       /// int i = 0;
        for (UIColor *colorArray in self.colors){
            NSLog(@"Color %@", colorArray);

            color = colorArray;


          ///  i++;

        }

        button.backgroundColor = color;
        NSLog(@"Next Button %@", button.currentTitle);

    }

        NSLog(@"Current Titles %@", titles);


        NSUInteger currentButtonIndex =
        [titles indexOfObject:colorButton];

        NSLog(@"Current Button Index %2lu", (unsigned long)currentButtonIndex);

        UIColor *colorForThisButton =
        [self.colors objectAtIndex:currentButtonIndex];

        NSLog(@"Color %@", colorForThisButton);

      if (currentButtonIndex == 1) {
            button.backgroundColor = [UIColor greenColor];
        }
    if (currentButtonIndex == 2) {
        button.backgroundColor = [UIColor grayColor]; }

    for (currentButtonIndex = 0; currentButtonIndex < 5; ++currentButtonIndex )
{
        button.backgroundColor = [UIColor grayColor];

} */

- (void)setEnabled:(BOOL)enabled forButtonWithTitle:(NSString *)title {
  NSUInteger index = [self.currentTitles indexOfObject:title];

  if (index != NSNotFound) {
    NSLog(@"ForButtonWith Title %lu", (unsigned long)index);
    UIButton *button = [self.buttons objectAtIndex:index];
    NSLog(@"ForButtonWith Title buttons %@", self.buttons);
    button.userInteractionEnabled = enabled;
    button.alpha = enabled ? 1.0 : 0.25;
  }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
