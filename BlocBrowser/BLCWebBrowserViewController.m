//
//  BLCWebBrowserViewController.m
//  BlocBrowser
//
//  Created by Trevor Ahlert on 8/7/14.
//  Copyright (c) 2014 Trevor Ahlert. All rights reserved.
//

#import "BLCWebBrowserViewController.h"
#import "BLCAwesomeFloatingToolbar.h"

#define kBLCWebBrowserBackString NSLocalizedString(@"Back", @"Back command")
#define kBLCWebBrowserForwardString \
  NSLocalizedString(@"Forward", @"Forward command")
#define kBLCWebBrowserStopString NSLocalizedString(@"Stop", @"Stop command")
#define kBLCWebBrowserRefreshString \
  NSLocalizedString(@"Refresh", @"Reload command")

@interface BLCWebBrowserViewController ()<
    UIWebViewDelegate, UITextFieldDelegate, BLCAwesomeFloatingToolbarDelegate>

@property(nonatomic, strong) UIWebView *webview;
@property(nonatomic, strong) UITextField *textField;
@property(nonatomic, strong) BLCAwesomeFloatingToolbar *awesomeToolbar;
@property(nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property(nonatomic, assign) NSUInteger frameCount;

@end

@implementation BLCWebBrowserViewController

#pragma mark - UIViewController

- (void)loadView {
  UIView *mainView = [UIView new];

  self.webview = [[UIWebView alloc] init];
  self.webview.delegate = self;

  self.textField = [[UITextField alloc] init];
  self.textField.keyboardType = UIKeyboardTypeURL;
  self.textField.returnKeyType = UIReturnKeyDone;
  self.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
  self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
  self.textField.placeholder =
      NSLocalizedString(@"Enter Website URL or Search",
                        @"Placeholder text for web browser URL field");
  self.textField.backgroundColor =
      [UIColor colorWithWhite:220 / 255.0f alpha:1];
  self.textField.delegate = self;

  self.awesomeToolbar = [[BLCAwesomeFloatingToolbar alloc]
      initWithFourTitles:@[
                           kBLCWebBrowserBackString,
                           kBLCWebBrowserForwardString,
                           kBLCWebBrowserStopString,
                           kBLCWebBrowserRefreshString
                         ]];
  self.awesomeToolbar.delegate = self;

  for (UIView *viewToAdd in
       @[ self.webview, self.textField, self.awesomeToolbar ]) {
    [mainView addSubview:viewToAdd];
  }

  self.view = mainView;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.edgesForExtendedLayout = UIRectEdgeNone;
  self.activityIndicator = [[UIActivityIndicatorView alloc]
      initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
  self.navigationItem.rightBarButtonItem =
      [[UIBarButtonItem alloc] initWithCustomView:self.activityIndicator];
 
  
  // Size Toolbar in View
  CGFloat width = CGRectGetWidth(self.view.bounds);
  CGFloat centerX;
  centerX = width;
  NSLog(@"View Width %2F", width);
  self.awesomeToolbar.frame =
  CGRectMake(centerX - 140, 100, (280 * 1.01), (60 * 1.01));
}

- (void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];

  NSLog(@"willLayoutSubviews");
  
  static CGFloat itemHeight = 50;
  CGFloat width = CGRectGetWidth(self.view.bounds);
  CGFloat browserHeight = CGRectGetHeight(self.view.bounds) - itemHeight;
  NSLog(@"Will Layout Subviews %f", width);

  

  self.textField.frame = CGRectMake(0, 0, width, itemHeight);
  self.webview.frame =
      CGRectMake(0, CGRectGetMaxY(self.textField.frame), width, browserHeight);

  
}

- (void)resetWebView {
  [self.webview removeFromSuperview];

  UIWebView *newWebView = [[UIWebView alloc] init];
  newWebView.delegate = self;
  [self.view addSubview:newWebView];

  self.webview = newWebView;

  self.textField.text = nil;
  [self updateButtonsAndTitle];
}

#pragma mark - BLCAwesomeFloatingToolbarDelegate


- (void)floatingToolbar:(BLCAwesomeFloatingToolbar *)toolbar
        didSelectButton:(UIButton *)button {
  NSString *title = button.currentTitle;
  NSLog(@"%@", title);
  if ([title isEqual:kBLCWebBrowserBackString]) {
    [self.webview goBack];
  } else if ([title isEqual:kBLCWebBrowserForwardString]) {
    [self.webview goForward];
  } else if ([title isEqual:kBLCWebBrowserStopString]) {
    [self.webview stopLoading];
  } else if ([title isEqual:kBLCWebBrowserRefreshString]) {
    [self.webview reload];
  }
}

- (void)floatingToolbar:(BLCAwesomeFloatingToolbar *)toolbar
    didTryToPanWithOffset:(CGPoint)offset {
  CGPoint startingPoint = toolbar.frame.origin;
  CGPoint newPoint =
      CGPointMake(startingPoint.x + offset.x, startingPoint.y + offset.y);

  CGRect potentialNewFrame =
      CGRectMake(newPoint.x, newPoint.y, CGRectGetWidth(toolbar.frame),
                 CGRectGetHeight(toolbar.frame));

  if (CGRectContainsRect(self.view.bounds, potentialNewFrame)) {
    toolbar.frame = potentialNewFrame;
  }
}

- (void)floatingToolbar:(BLCAwesomeFloatingToolbar *)toolbar
    didTryToPinchWithOffset:(CGFloat)pinchScale {
  
  self.awesomeToolbar.transform = CGAffineTransformScale(
      self.awesomeToolbar.transform, (pinchScale), (pinchScale));
  if (!(CGRectContainsRect(self.webview.bounds, self.awesomeToolbar.frame))){
    
    self.awesomeToolbar.transform = CGAffineTransformIdentity;
  }
  
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [textField resignFirstResponder];

  NSString *URLString = textField.text;

  NSURL *URL = [NSURL URLWithString:URLString];
  NSRange whiteSpaceRange = [URLString
      rangeOfCharacterFromSet:[NSCharacterSet whitespaceCharacterSet]];
  NSString *searchString =
      [URLString stringByReplacingOccurrencesOfString:@" " withString:@"+"];

  if (!URL.scheme) {
    // The user didn't type http: or https:
    if (whiteSpaceRange.location != NSNotFound) {
      URL = [NSURL
          URLWithString:[NSString
                            stringWithFormat:@"http://google.com/search?q=%@",
                                             searchString]];
    } else
      URL = [NSURL
          URLWithString:[NSString stringWithFormat:@"http://%@", URLString]];
  }

  if (URL) {
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    [self.webview loadRequest:request];
  }

  return NO;
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
  self.frameCount++;
  [self updateButtonsAndTitle];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
  self.frameCount--;
  [self updateButtonsAndTitle];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
  UIAlertView *alert =
      [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error")
                                 message:[error localizedDescription]
                                delegate:nil
                       cancelButtonTitle:NSLocalizedString(@"OK", nil)
                       otherButtonTitles:nil];
  [alert show];

  [self updateButtonsAndTitle];
  self.frameCount--;
}

#pragma mark - Micellaneous

- (void)updateButtonsAndTitle {
  NSString *webpageTitle =
      [self.webview stringByEvaluatingJavaScriptFromString:@"document.title"];

  if (webpageTitle) {
    self.title = webpageTitle;
  } else {
    self.title = self.webview.request.URL.absoluteString;
  }

  if (self.frameCount > 0) {
    [self.activityIndicator startAnimating];
  } else {
    [self.activityIndicator stopAnimating];
  }

  [self.awesomeToolbar setEnabled:[self.webview canGoBack]
               forButtonWithTitle:kBLCWebBrowserBackString];
  [self.awesomeToolbar setEnabled:[self.webview canGoForward]
               forButtonWithTitle:kBLCWebBrowserForwardString];
  [self.awesomeToolbar setEnabled:self.frameCount > 0
               forButtonWithTitle:kBLCWebBrowserStopString];
  [self.awesomeToolbar
              setEnabled:self.webview.request.URL && self.frameCount == 0
      forButtonWithTitle:kBLCWebBrowserRefreshString];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little
preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
