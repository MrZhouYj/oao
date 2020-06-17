//
//  CAWebViewController.m
//  TASE-IOS
//
//   10/29.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CAWebViewController.h"
#import <WebKit/WKWebView.h>
#import <WebKit/WebKit.h>

@interface CAWebViewController ()

@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, strong) UIProgressView *progressView;

@end

@implementation CAWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self loadData];
        
    [self.navcBar.closeButton addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    self.navcBar.closeButton.hidden = YES;
}

-(void)loadData{
    
   if ([self.webUrl containsString:@"?"]) {
       self.webUrl = [self.webUrl stringByAppendingFormat:@"&lang=%@",[CALanguageManager language]];
   }else{
       self.webUrl = [self.webUrl stringByAppendingFormat:@"?lang=%@",[CALanguageManager language]];
   }
    
    NSURL *url = [NSURL URLWithString:self.webUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    [self.webView loadRequest:request];
    
    
}

-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    decisionHandler(WKNavigationActionPolicyAllow);
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))] && object == self.webView) {
       
        [self.progressView setAlpha:1.0f];
        BOOL animated = self.webView.estimatedProgress > self.progressView.progress;
        [self.progressView setProgress:self.webView.estimatedProgress animated:animated];
        if(self.webView.estimatedProgress >= 1.0f) {
            [UIView animateWithDuration:0.3f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0f animated:NO];
            }];
        }
    }else if([keyPath isEqualToString:NSStringFromSelector(@selector(title))]
             && object == self.webView){
        
        if (self.appointTitle.length) {
            self.navcTitle = self.appointTitle;
        }else{
            self.navcTitle = _webView.title;
        }
        
        [self updateBackItems];
        
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
    
}

-(void)updateBackItems{
    
     self.navcBar.closeButton.hidden = !self.webView.canGoBack;
}

-(void)closeAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)backAction{
    if (self.webView.canGoBack) {
        [self.webView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(WKWebView *)webView{
    
    if (!_webView) {
        
        WKWebViewConfiguration * webConfig = [[WKWebViewConfiguration alloc] init];
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, kTopHeight, MainWidth, MainHeight - kTopHeight) configuration:webConfig];
        _webView.backgroundColor = [UIColor whiteColor];
        _webView.scrollView.showsVerticalScrollIndicator = NO;
        _webView.scrollView.showsHorizontalScrollIndicator = NO;
        [_webView sizeToFit];
        _webView.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
        _webView.allowsBackForwardNavigationGestures = YES;
        [_webView addObserver:self
                   forKeyPath:NSStringFromSelector(@selector(estimatedProgress))
                      options:0
                      context:nil];
        [_webView addObserver:self
                          forKeyPath:NSStringFromSelector(@selector(title))
                             options:NSKeyValueObservingOptionNew
                             context:nil];
        [self.view addSubview:_webView];

    }
    
    return _webView;
}
-(UIProgressView *)progressView{
    
    if (!_progressView) {
        
        _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.trackTintColor = [UIColor groupTableViewBackgroundColor];
        _progressView.progressTintColor = HexRGB(0x0091db);
        [self.view addSubview:_progressView];
        _progressView.frame = CGRectMake(0, kTopHeight, MainWidth, 3);
    }
    
    return _progressView;
}

-(void)dealloc{
    NSLog(@"销毁了");
    [self.webView removeObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
    [self.webView removeObserver:self forKeyPath:NSStringFromSelector(@selector(title))];
    
}

@end
