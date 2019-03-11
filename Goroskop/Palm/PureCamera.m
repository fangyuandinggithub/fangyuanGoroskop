/*!
 @abstract
 Created by 孙凯峰 on 2016/10/18.
 */
#define KScreenSize [UIScreen mainScreen].bounds.size
#define KScreenwidth [UIScreen mainScreen].bounds.size.width
#define KScreenheight [UIScreen mainScreen].bounds.size.height
#define IsIphone6P KScreenSize.width==414
#define IsIphone6 KScreenSize.width==375
#define IsIphone5S KScreenSize.height==568
#define IsIphone5 KScreenSize.height==568
//456字体大小
#define KIOS_Iphone456(iphone6p,iphone6,iphone5s,iphone5,iphone4s) (IsIphone6P?iphone6p:(IsIphone6?iphone6:((IsIphone5S||IsIphone5)?iphone5s:iphone4s)))
//宽高
#define KIphoneSize_Widith(iphone6) (IsIphone6P?1.104*iphone6:(IsIphone6?iphone6:((IsIphone5S||IsIphone5)?0.853*iphone6:0.853*iphone6)))
#define KIphoneSize_Height(iphone6) (IsIphone6P?1.103*iphone6:(IsIphone6?iphone6:((IsIphone5S||IsIphone5)?0.851*iphone6:0.720*iphone6)))

// 距顶部高度
#define Top_Height 0.2*kScreenHeight - 50
// 中间View的宽度
#define MiddleWidth 0.9*kScreenWidth

#define MiddleHeight 0.7*kScreenHeight
#import "PureCamera.h"
#import "LLSimpleCamera.h"
#import "HoroscopesArtistPalmScanResultViewController.h"
@interface PureCamera ()
{
    int num;
    BOOL upOrdown;
}
@property (strong, nonatomic) LLSimpleCamera *camera;
@property (strong, nonatomic) UILabel *errorLabel;
@property (strong, nonatomic) UIButton *snapButton;
@property (strong, nonatomic) UIButton *switchButton;
@property (strong, nonatomic) UIButton *flashButton;
@property (strong, nonatomic) UIButton *backButton;

@property (strong, nonatomic) NSTimer * timer;

@property (nonatomic, strong)UILabel *scanLabel;
@property (nonatomic, retain) UIImageView * line;

@property (nonatomic, strong)UIImageView * imageView;

@property (nonatomic, assign)NSInteger count;
@end

@implementation PureCamera

- (void)viewDidLoad
{
    [super viewDidLoad];
    //拍照按钮
    [self InitializeCamera];
    self.snapButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.snapButton.clipsToBounds = YES;
    self.snapButton.layer.cornerRadius =75 / 2.0f;
    [self.snapButton setImage:[UIImage imageNamed:@"cameraButton"] forState:UIControlStateNormal];
    [self.snapButton addTarget:self action:@selector(snapButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.snapButton];
    
    //闪关灯按钮
    self.flashButton = [UIButton buttonWithType:UIButtonTypeSystem];
    
    self.flashButton.tintColor = [UIColor whiteColor];
    //     UIImage *image = [UIImage imageNamed:@"PureCamera.bundle/camera-flash.png"];
    [self.flashButton setImage:[UIImage imageNamed:@"camera-flash"] forState:UIControlStateNormal];
    self.flashButton.imageEdgeInsets = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
    [self.flashButton addTarget:self action:@selector(flashButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.flashButton];
    if([LLSimpleCamera isFrontCameraAvailable] && [LLSimpleCamera isRearCameraAvailable]) {

        //返回按钮
        self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [self.backButton setImage:[UIImage imageNamed:@"closeButton"] forState:UIControlStateNormal];
        [self.backButton addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.backButton];
    }
    
    
    
    
    
    //扫描
    self.scanLabel = [[UILabel alloc]init];
    self.scanLabel.text = @"Scanning...";
    self.scanLabel.textColor = [UIColor whiteColor];
    self.scanLabel.font = [UIFont systemFontOfSize:18];
    self.scanLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.scanLabel];
    
    CGFloat leadSpace = (kScreenWidth - MiddleWidth)/ 2;
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(leadSpace, Top_Height, MiddleWidth, MiddleHeight)];
    self.imageView = imageView;
    imageView.image = [UIImage imageNamed:@"Icon_SaoYiSao"];
    [self.view addSubview:imageView];
    
    
    upOrdown = NO;
    num =0;
    self.count = 0;
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(leadSpace, Top_Height, MiddleWidth, 12)];
    _line.image = [UIImage imageNamed:@"Icon_SaoLine"];
    _line.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview:_line];
    
    self.scanLabel.hidden = YES;
    self.imageView.hidden = YES;
    _line.hidden = YES;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor blackColor];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    // snap button to capture image
    
    //判断前后摄像头是否可用
    [self.timer invalidate];
    self.timer = nil;
    
    self.snapButton.hidden = NO;
    self.backButton.hidden = NO;
    self.flashButton.hidden = NO;
    self.scanLabel.hidden = YES;
    self.imageView.hidden = YES;
    self.line.hidden = YES;
    // start the camera
    [self.camera start];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark   ------------- 初始化相机--------------
-(void)InitializeCamera{
    CGRect screenRect = self.view.frame;
    
    // 创建一个相机
    self.camera = [[LLSimpleCamera alloc] initWithQuality:AVCaptureSessionPresetHigh  position:LLCameraPositionRear];
    
    // attach to a view controller
    [self.camera attachToViewController:self withFrame:CGRectMake(0, 0, screenRect.size.width, screenRect.size.height)];
    
    self.camera.fixOrientationAfterCapture = NO;
    UIImageView *transparentImageView = [[UIImageView alloc]initWithFrame:screenRect];
    transparentImageView.image = [UIImage imageNamed:@"hand"];
    [self.camera.view addSubview:transparentImageView];
  
    
    // take the required actions on a device change
    __weak typeof(self) weakSelf = self;
    [self.camera setOnDeviceChange:^(LLSimpleCamera *camera, AVCaptureDevice * device) {
        
        NSLog(@"Device changed.");
        
        // device changed, check if flash is available
        if([camera isFlashAvailable]) {
            weakSelf.flashButton.hidden = NO;
            
            if(camera.flash == LLCameraFlashOff) {
                weakSelf.flashButton.selected = NO;
            }
            else {
                weakSelf.flashButton.selected = YES;
            }
        }
        else {
            weakSelf.flashButton.hidden = YES;
        }
    }];
    
    [self.camera setOnError:^(LLSimpleCamera *camera, NSError *error) {
        NSLog(@"Camera error: %@", error);
        
        if([error.domain isEqualToString:LLSimpleCameraErrorDomain]) {
            if(error.code == LLSimpleCameraErrorCodeCameraPermission) {
                if(weakSelf.errorLabel) {
                    [weakSelf.errorLabel removeFromSuperview];
                }
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
                label.text = @"未获取相机权限";
                label.numberOfLines = 2;
                label.lineBreakMode = NSLineBreakByWordWrapping;
                label.backgroundColor = [UIColor clearColor];
                label.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:13.0f];
                label.textColor = [UIColor whiteColor];
                label.textAlignment = NSTextAlignmentCenter;
                [label sizeToFit];
                label.center = CGPointMake(screenRect.size.width / 2.0f, screenRect.size.height / 2.0f);
                weakSelf.errorLabel = label;
                [weakSelf.view addSubview:weakSelf.errorLabel];
            }
        }
    }];
    
    
}

/* camera button methods */

- (void)switchButtonPressed:(UIButton *)button
{
    [self.camera togglePosition];
}
-(void)backButtonPressed:(UIButton *)button{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (void)flashButtonPressed:(UIButton *)button
{
    if(self.camera.flash == LLCameraFlashOff) {
        BOOL done = [self.camera updateFlashMode:LLCameraFlashOn];
        if(done) {
            self.flashButton.selected = YES;
            self.flashButton.tintColor = [UIColor yellowColor];
        }
    }
    else {
        BOOL done = [self.camera updateFlashMode:LLCameraFlashOff];
        if(done) {
            self.flashButton.selected = NO;
            self.flashButton.tintColor = [UIColor whiteColor];
        }
    }
}
#pragma mark   -------------拍照--------------

- (void)snapButtonPressed:(UIButton *)button
{
//    __weak typeof(self) weakSelf = self;
    // 去拍照
     __weak typeof(self) weakSelf = self;
    [self.camera capture:^(LLSimpleCamera *camera, UIImage *image, NSDictionary *metadata, NSError *error) {
        NSLog(@"拍照结束");
         [self.camera stop];
        if(!error) {

            weakSelf.fininshcapture(image);
            [UIView animateWithDuration:1 animations:^{
                weakSelf.snapButton.hidden = YES;
                weakSelf.backButton.hidden = YES;
                weakSelf.flashButton.hidden = YES;
                weakSelf.scanLabel.hidden = NO;
                weakSelf.imageView.hidden = NO;
                weakSelf.line.hidden = NO;
                
            }];
            weakSelf.timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(lineAnimation) userInfo:nil repeats:YES];
           

        }
        else {
            NSLog(@"An error has occured: %@", error);
        }
    } exactSeenImage:YES];
}
//扫描动画
-(void)lineAnimation{
    CGFloat leadSpace = (kScreenWidth - MiddleWidth)/ 2;
    if (upOrdown == NO) {
        num ++;
        _line.frame = CGRectMake(leadSpace, Top_Height+2*num, MiddleWidth, 12);
        if (2*num >= MiddleHeight-12) {
            upOrdown = YES;
            _line.image = [UIImage imageNamed:@"Icon_SaoLineOn"];
        }
    }else {
        num --;
        _line.frame = CGRectMake(leadSpace, Top_Height+2*num, MiddleWidth, 12);
        if (num == 0) {
            upOrdown = NO;
            _line.image = [UIImage imageNamed:@"Icon_SaoLine"];
        }
    }
      self.count ++ ;
    if(self.count == 600){
        [self.timer invalidate];
        self.timer = nil;
        HoroscopesArtistPalmScanResultViewController *result = [[HoroscopesArtistPalmScanResultViewController alloc]init];
        [self presentViewController:result animated:YES completion:nil];
    }
}
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    self.camera.view.frame=self.view.frame;
    self.snapButton.frame=CGRectMake((KScreenwidth-KIphoneSize_Widith(75))/2, KScreenheight-KIphoneSize_Widith(90), KIphoneSize_Widith(75), KIphoneSize_Widith(75));
      self.scanLabel.frame=CGRectMake((KScreenwidth-KIphoneSize_Widith(150))/2, KScreenheight-KIphoneSize_Widith(90), KIphoneSize_Widith(150), KIphoneSize_Widith(75));
    self.flashButton.frame=CGRectMake((KScreenwidth-KIphoneSize_Widith(36))/2, 25, KIphoneSize_Widith(36), KIphoneSize_Widith(44));
    self.switchButton.frame=CGRectMake(KScreenwidth-50, KScreenheight-KIphoneSize_Widith(75), KIphoneSize_Widith(45), KIphoneSize_Widith(45));
    self.backButton.frame=CGRectMake(5, KScreenheight-KIphoneSize_Widith(75), KIphoneSize_Widith(45), KIphoneSize_Widith(45));
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc{
    [self.timer invalidate];
    self.timer = nil;
}
@end
