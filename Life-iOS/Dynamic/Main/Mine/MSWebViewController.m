//
//  MSWebViewController.m
//  Music
//
//  Created by miss on 2018/3/1.
//  Copyright © 2018年 miss. All rights reserved.
//

#import "MSWebViewController.h"
#import <WebKit/WebKit.h>

@interface MSWebViewController () <WKUIDelegate, WKNavigationDelegate>

@property (nonatomic, weak) UIProgressView *progressView;
@property (nonatomic, weak) WKWebView *webView;

@end

@implementation MSWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.titleString) {
        self.title = self.titleString;
    }else {
        self.title = @"详情";
    }
    [self initPage];
}

- (void)initPage {
    WKWebView *webView = [[WKWebView alloc]init];
    [webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    webView.navigationDelegate = self;
    if ([self.url hasPrefix:@"http://"] || [self.url hasPrefix:@"https://"]) {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
        [webView loadRequest:request];
    }
    [self.view addSubview:webView];
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    if (@available(iOS 11.0, *)) {
        webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }

    self.webView = webView;
    
    UIProgressView *progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 2)];
    progressView.trackTintColor = [UIColor whiteColor];
    progressView.progressTintColor = COLOR(57, 141, 255);
    [self.view addSubview:progressView];
    self.progressView = progressView;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress == 1) {
            self.progressView.hidden = YES;
            [self.progressView setProgress:0 animated:NO];
        }else {
            self.progressView.hidden = NO;
            [self.progressView setProgress:newprogress animated:YES];
        }
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    self.title = webView.title;
    self.progressView.hidden = YES;
    [self.progressView setProgress:0 animated:NO];
}

- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
