//
//  MusicController.m
//  YueSheng
//
//  Created by yellow on 16/8/6.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import "MusicController.h"
#import <AVFoundation/AVFoundation.h>

@interface MusicController ()
@property (weak, nonatomic) IBOutlet UIImageView *bgView;

@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *compereLabel;
@property (weak, nonatomic) IBOutlet UISlider *slider;
- (IBAction)preClick:(id)sender;
- (IBAction)playClick:(id)sender;
- (IBAction)nextClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *playBtn;

@property(nonatomic,strong)AVPlayer *player;

@property(nonatomic,assign)CGFloat progress;//进度百分比

@property(nonatomic,copy)NSString *playTime;//目前播放的用时

@property(nonatomic,copy)NSString *playDuration;//总需要播放的时间

@property(nonatomic,strong)id timeObserve;

@property (nonatomic, strong) CADisplayLink *link;

@end

@implementation MusicController

#warning - 暂不做缓冲显示和slider拖拉循环单一播放单例列表播放锁屏界面耳机控制

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //一开始清空navigationBar背景色
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    self.bgView.clipsToBounds = YES;
    
    self.playBtn.layer.cornerRadius = self.playBtn.bounds.size.width/2;
    self.iconView.layer.cornerRadius = self.iconView.layer.bounds.size.width/2;
    self.iconView.clipsToBounds = YES;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:self.detailStatus.RadP_Img] placeholderImage:[UIImage imageNamed:@"right_img"]];
    self.nameLabel.text = self.detailStatus.RadP_Name;
    self.compereLabel.text = [NSString stringWithFormat:@"主持人：%@",self.detailStatus.RadP_Compere];
    self.playBtn.selected = YES;
    
    //通过一个网络链接播放音乐
    NSURL * url  = [NSURL URLWithString:self.status.song];
    
    AVPlayer *player = [[AVPlayer alloc] initWithURL:url];
    
    [player play];
    
    self.player = player;
    
    //监听播放
    [self observe];
    
    //动画旋转图像
    [self startRotating];
   
}


-(void)observe{
    
     //监听播放进度
    __weak __typeof(self)weakSelf = self;
    id timeObserve = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        float current = CMTimeGetSeconds(time);
        float total = CMTimeGetSeconds(weakSelf.player.currentItem.duration);
        if (current) {
            weakSelf.progress = current / total;
            weakSelf.playTime = [NSString stringWithFormat:@"%.f",current];
            weakSelf.playDuration = [NSString stringWithFormat:@"%.2f",total];
            
            weakSelf.slider.value = current / total;
        }
    }];
    self.timeObserve = timeObserve;
    
    //监听改播放器状态
    //媒体加载状态
    [self.player.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    //数据缓冲状态
    [self.player.currentItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    //播放完毕状态
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
}

- (void)playbackFinished:(NSNotification *)notice {
    YWLog(@"播放完成");
    [self playNext];
}

-(void)playNext{

    [self.player pause];
    
    [self cancelDealloc];
    
    self.slider.value = 0;
    
    NSInteger index = [self.statusArray indexOfObject:self.status];
    
    if (index == self.statusArray.count - 1) {
        index = -1;
    }
    
    ReviewListStatus *nextStatus = self.statusArray[index + 1];
    self.status = nextStatus;
    
    //通过一个网络链接播放音乐
    NSURL * url  = [NSURL URLWithString:nextStatus.song];
    
    AVPlayer *player = [[AVPlayer alloc] initWithURL:url];
    
    [player play];
    
    self.player = player;
    
    [self observe];
}

-(void)playPre{
    [self.player pause];
    
    [self cancelDealloc];
    
    self.slider.value = 0;
    
    NSInteger index = [self.statusArray indexOfObject:self.status];
    
    if (index == 0) {
        index = self.statusArray.count;
    }
    
    ReviewListStatus *preStatus = self.statusArray[index - 1];
    self.status = preStatus;
    
    //通过一个网络链接播放音乐
    NSURL * url  = [NSURL URLWithString:preStatus.song];
    
    AVPlayer *player = [[AVPlayer alloc] initWithURL:url];
    
    [player play];
    
    self.player = player;

    [self observe];
}

//kvo监听加载与缓冲状态
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void *)context {
    
    //加载状态
    if ([keyPath isEqualToString:@"status"]) {
        switch (self.player.status) {
            case AVPlayerStatusUnknown:
                YWLog(@"KVO：未知状态，此时不能播放");
                break;
            case AVPlayerStatusReadyToPlay:
//                self.status = SUPlayStatusReadyToPlay;
                YWLog(@"KVO：准备完毕，可以播放");
                break;
            case AVPlayerStatusFailed:
                YWLog(@"KVO：加载失败，网络或者服务器出现问题");
                break;
            default:
                break;
        }
    }
    
    //缓冲状态
    AVPlayerItem * songItem = object;
    if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        NSArray * array = songItem.loadedTimeRanges;
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue]; //本次缓冲的时间范围
        NSTimeInterval totalBuffer = CMTimeGetSeconds(timeRange.start) + CMTimeGetSeconds(timeRange.duration); //缓冲总长度
        YWLog(@"共缓冲%.2f",totalBuffer);
    }

}


-(void)cancelDealloc{
    if (self.timeObserve) {
        [self.player removeTimeObserver:_timeObserve];
        self.timeObserve = nil;
    }
    [self.player.currentItem removeObserver:self forKeyPath:@"status"];
    [self.player.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

-(void)dealloc{
    [self cancelDealloc];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    UIColor * color = [UIColor colorWithRed:0/255.0 green:175/255.0 blue:240/255.0 alpha:1];
    [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
    
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar lt_reset];
    
}

- (IBAction)playClick:(id)sender {
    
    self.playBtn.selected = !self.playBtn.selected;
    
    if (self.playBtn.selected) {
        [self startRotating];
        [self.player play];
    }else{
        [self stopRotating];
        [self.player pause];
    }
    
}

- (IBAction)nextClick:(id)sender {
    self.playBtn.selected = YES;
    [self startRotating];
    [self playNext];

}
- (IBAction)preClick:(id)sender {
    self.playBtn.selected = YES;
    [self startRotating];
    [self playPre];
}
/**
 *  开始不停得旋转
 */
- (void)startRotating
{
    if (self.link) return;
    
    // 1秒内刷新60次
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(update)];
    [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    self.link = link;
}

- (void)stopRotating
{
    [self.link invalidate];
    self.link = nil;
}

- (void)update
{
    self.iconView.transform = CGAffineTransformRotate(self.iconView.transform, M_PI / 500);
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [self cancelDealloc];
    
    [self.player pause];

}

@end
