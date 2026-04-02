//
//  SLShotViewController.h
//

#import <UIKit/UIKit.h>
#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

/// 拍摄视图控制器
@interface SLShotViewController : UIViewController

@property (assign, nonatomic) NSInteger faceType;
@property (assign, nonatomic) NSInteger sourceType;
@property (assign, nonatomic) NSInteger appType;
@property (assign, nonatomic) NSInteger flashType;
@property (assign, nonatomic) NSString *themeColor;

@property (copy, nonatomic) FlutterResult flutterResult;


@end

NS_ASSUME_NONNULL_END
