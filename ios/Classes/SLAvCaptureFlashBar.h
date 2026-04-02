//
//  SLAvCaptureFlashBar.h
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLAvCaptureFlashBar : UIView

- (instancetype)initWithFrame:(CGRect)frame type:(NSInteger)type;

@property (copy, nonatomic) void (^onChooseFlashCompleted)(NSInteger type);

@end

NS_ASSUME_NONNULL_END
