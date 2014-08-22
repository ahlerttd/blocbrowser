//
//  BLCAwesomeFloatingToolbar.h
//  BlocBrowser
//
//  Created by Trevor Ahlert on 8/13/14.
//  Copyright (c) 2014 Trevor Ahlert. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BLCAwesomeFloatingToolbar;

@protocol BLCAwesomeFloatingToolbarDelegate <NSObject>

@optional

- (void) floatingToolbar:(BLCAwesomeFloatingToolbar *)toolbar didSelectButtonWithTitle: (NSString *)title;
- (void) floatingToolbar:(BLCAwesomeFloatingToolbar *)toolbar didSelectButton: (UIButton *)button;
- (void) floatingToolbar:(BLCAwesomeFloatingToolbar *)toolbar didTryToPanWithOffset:(CGPoint)offset;
- (void) floatingToolbar:(BLCAwesomeFloatingToolbar *)toolbar didTryToPinchWithOffset: (CGFloat) pinchScale;
- (void) floatingToolbar:(BLCAwesomeFloatingToolbar *)toolbar didLongPressButton:(UIButton *)longPressButton;

@end


@interface BLCAwesomeFloatingToolbar : UIView

- (instancetype) initWithFourTitles:(NSArray *)titles;

- (void) setEnabled:(BOOL)enabled forButtonWithTitle:(NSString *)title;

///- (void) setBackgroundColor:(UIColor *)backgroundColor forColorButtonWithTitle: (UIButton *)colorButton;

@property (nonatomic, weak) id <BLCAwesomeFloatingToolbarDelegate> delegate;

@end
