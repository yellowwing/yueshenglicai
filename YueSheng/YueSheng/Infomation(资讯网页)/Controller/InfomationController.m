//
//  InfomationController.m
//  YueSheng
//
//  Created by yellow on 16/7/21.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import "InfomationController.h"
#import "ASProgressPopUpView.h"
@interface InfomationController ()<UIWebViewDelegate>
{
    NSTimer *_timer;
}
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (weak, nonatomic) IBOutlet ASProgressPopUpView *progressView;

@end

@implementation InfomationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
#warning - 到时还是分开两个控制器比较好
    self.webView.scalesPageToFit = YES;
    
    NSString *urlString;
    if (self.isLoadPagePicture) {
        urlString = self.pictureStatus.Url;
    }else{
      urlString = [NSString stringWithFormat:@"http://app.etz927.com/AppJson/news/news.aspx?nid=%@",self.status.NiId];
    }
    
  
    NSURL *url = [NSURL URLWithString:urlString];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    self.progressView.popUpViewAnimatedColors = @[ [UIColor greenColor], [UIColor yellowColor], [UIColor orangeColor]];
    [self progress];
    
}

- (void)progress
{
    float progress = self.progressView.progress;
    if (progress < 1.0) {
        
        progress += 0.1;
        
        [self.progressView setProgress:progress animated:YES];
        
       NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.2
                                         target:self
                                       selector:@selector(progress)
                                       userInfo:nil
                                        repeats:NO];
          [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    }
    else{
    
     self.progressView.hidden = YES;
    
    }
}


#pragma mark - webView代理方法
/**
 *  webView开始发送请求的时候就会调用
 */
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    self.progressView.hidden = NO;
}


/**
 *  webView请求完毕的时候就会调用
 */
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
//    self.progressView.hidden = YES;
}


/**
 *  webView请求失败的时候就会调用
 */
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
//   self.progressView.hidden = YES;
}

/**
 *  当webView发送一个请求之前都会先调用这个方法, 询问代理可不可以加载这个页面(请求)
 *
 *  @return YES : 可以加载页面,  NO : 不可以加载页面
 */
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    
    return YES;
}


@end
