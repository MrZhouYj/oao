//
//  CFKLineFullScreenViewController.h
//


#import <UIKit/UIKit.h>

@class CASymbolsModel,BTMarketModel;

@protocol LineFullScreenViewControllerDelegate <NSObject>

-(void)lineFullScreenViewConteller_BackWithNewIndex:(Y_KLineType)newType;

@end

@interface LineKFullScreenViewController : UIViewController

@property (nonatomic, weak) id<LineFullScreenViewControllerDelegate> delegata;

@property (copy, nonatomic) void (^ onClickBackButton)(LineKFullScreenViewController *controller);

@property (nonatomic, strong) CASymbolsModel * currentSymbolModel;

@property (nonatomic, assign) Y_KLineType lastType;

@property (nonatomic, assign) BOOL isHasGroupModel;

@property (nonatomic, strong) Y_KLineGroupModel *groupModel;

@end
