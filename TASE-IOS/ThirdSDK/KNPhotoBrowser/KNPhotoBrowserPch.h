//
//  KNPhotoBrowser.h
//  KNPhotoBrowser

#define iPhoneX  ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : false)

#define iPhoneXR ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828 , 1792), [[UIScreen mainScreen] currentMode].size) : false)

#define iPhoneXs_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242 , 2688), [[UIScreen mainScreen] currentMode].size) : false)


#define PhotoShowPlaceHolderImageColor [UIColor blackColor]

#define isPortrait ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortraitUpsideDown)

#define PhotoPlaceHolderDefaultColor [UIColor grayColor]

// pic max zoom num
#define PhotoBrowserImageMaxScale   2.f
// pic min zoom out num
#define PhotoBrowserImageMinScale   1.f

#define PhotoBrowserAnimateTime 0.3

// define SDWebImagePrefetcher max number
#define PhotoBrowserPrefetchNum     8


