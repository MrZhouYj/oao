//
//  CARealNameAuthViewController.m
//  TASE-IOS
//
//   9/29.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CARealNameAuthViewController.h"
#import "UIImage+Compress.h"

@interface CARealNameAuthViewController ()
<UINavigationControllerDelegate,
UIImagePickerControllerDelegate>
{
    NSInteger _curIndex;
    UIImage * _frontImage;
    UIImage * _backImage;
    UIImage * _holdFrontImage;
    LYEmptyView * _emptyView;
    CAUser * _user;
}

@property (nonatomic, strong) UIImageView * frontImageView;
@property (nonatomic, strong) UIImageView * backImageView;
@property (nonatomic, strong) UIImageView * holdFrontImageView;
@property (nonatomic, strong) CABaseButton * sendBtn;
@property (nonatomic, strong) CAPhotoAlbumImagePicker * picker;


@end

@implementation CARealNameAuthViewController

-(CAPhotoAlbumImagePicker *)picker{
    if (!_picker) {
        _picker = [CAPhotoAlbumImagePicker new];
    }
    return _picker;
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.navcTitle = @"实名认证";
    _user = [CAUser currentUser];
    
    if ([_user.identity_state isEqualToString:@"not_audit"]) {
        [self initNotAuditSubViews];
    }else if ([_user.identity_state isEqualToString:@"auditing"]){
        [self initAuditingEmptyView];
    }else if ([_user.identity_state isEqualToString:@"audit_failure"]){
        if (_user.is_read_my_identified_fail) {
            [self initNotAuditSubViews];
        }else{
            [self initAuditingFaliureEmptyView];
        }
    }
}
-(void)initAuditingFaliureEmptyView{
     
    _emptyView = [LYEmptyView emptyActionViewWithImage:IMAGE_NAMED(@"audit_faliure") titleStr:[CAUser currentUser].identity_state_name detailStr:nil btnTitleStr:CALanguages(@"重新认证") target:self action:@selector(againAction)];
    
    _emptyView.titleLabTextColor = RGB(171, 175, 204);
    _emptyView.titleLabFont = FONT_REGULAR_SIZE(15);
    _emptyView.actionBtnFont = FONT_REGULAR_SIZE(15);
    _emptyView.actionBtnTitleColor = RGB(0, 108, 219);
    _emptyView.actionBtnBorderColor = RGB(0, 108, 219);
    _emptyView.actionBtnBorderWidth = 1;
    _emptyView.actionBtnCornerRadius = 2;
    _emptyView.imageSize = CGSizeMake(83/414.f*MainWidth, 83/414.f*MainWidth);
    _emptyView.autoShowEmptyView = NO;
    _emptyView.emptyViewIsCompleteCoverSuperView = YES;
    
    [self.view addSubview:_emptyView];
    [self.view bringSubviewToFront:_emptyView];
}

-(void)initAuditingEmptyView{
    NSLog(@"初始化");
    _emptyView = [LYEmptyView emptyViewWithImage:IMAGE_NAMED(@"auditing") titleStr:[CAUser currentUser].identity_state_name detailStr:@""];
    _emptyView.titleLabTextColor = RGB(171, 175, 204);
    _emptyView.titleLabFont = FONT_REGULAR_SIZE(15);
    _emptyView.actionBtnFont = FONT_REGULAR_SIZE(15);
    _emptyView.actionBtnTitleColor = RGB(0, 108, 219);
    _emptyView.actionBtnBorderColor = RGB(0, 108, 219);
    _emptyView.actionBtnBorderWidth = 1;
    _emptyView.actionBtnCornerRadius = 2;
    _emptyView.imageSize = CGSizeMake(83/414.f*MainWidth, 83/414.f*MainWidth);
    _emptyView.contentViewY = kTopHeight+100;
//    _emptyView.emptyViewIsCompleteCoverSuperView = YES;

    [self.view addSubview:_emptyView];
    [self.view bringSubviewToFront:_emptyView];
}

-(void)againAction{
    
    if (_emptyView) {
        [_emptyView removeFromSuperview];
        _emptyView = nil;
    }
    _user.is_read_my_identified_fail = YES;
    [self.contentView removeAllSubViews];
    [self initNotAuditSubViews];
}
  
-(void)initNotAuditSubViews{
    
    UILabel * topNotiLabel = [UILabel new];
    [self.contentView addSubview:topNotiLabel];
    
    topNotiLabel.text =CALanguages(@"请使用修图工具，将图片裁剪为长和宽均为500以下的图片，太大的图片将无法上传。");
    topNotiLabel.textColor = RGB(138,138,146);
    topNotiLabel.font = FONT_REGULAR_SIZE(13);
    topNotiLabel.numberOfLines = 0;
    
    [topNotiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
    }];
    
    self.frontImageView = [self creatItem:@"身份证正面" topView:topNotiLabel offset:15 tag:1];
    self.backImageView = [self creatItem:@"身份证背面" topView:self.frontImageView offset:20 tag:2];
    self.holdFrontImageView = [self creatItem:@"手持身份证" topView:self.backImageView offset:20 tag:3];
    
    self.frontImageView.image = IMAGE_NAMED(@"idcard_front");
    self.backImageView.image = IMAGE_NAMED(@"idcard_back");
    self.holdFrontImageView.image = IMAGE_NAMED(@"idcard_hold_front");
    
   
    self.sendBtn = [CABaseButton buttonWithTitle:@"确认绑定"];
    [self.contentView addSubview:self.sendBtn];
    [self.sendBtn addTarget:self action:@selector(uploadImages) forControlEvents:UIControlEventTouchUpInside];
    [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.height.equalTo(@43);
        make.top.equalTo(self.holdFrontImageView.mas_bottom).offset(30);
    }];

    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.sendBtn.mas_bottom).offset(20);
    }];
    
}

-(UIImageView*)creatItem:(NSString*)notiTitle topView:(UIView*)view offset:(CGFloat)offset tag:(NSInteger)tag{
    
    UILabel * cardBrontNotiLabel = [UILabel new];
    [self.contentView addSubview:cardBrontNotiLabel];
    
    cardBrontNotiLabel.text = CALanguages(notiTitle);
    cardBrontNotiLabel.textColor = RGB(25,29,38);
    cardBrontNotiLabel.font = FONT_REGULAR_SIZE(14);
    
    [cardBrontNotiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(view.mas_bottom).offset(offset);
        make.right.equalTo(self.contentView).offset(-15);
    }];
    
    UIImageView * imageV = [UIImageView new];
    [self.contentView addSubview:imageV];
    
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cardBrontNotiLabel.mas_bottom).offset(15);
        make.centerX.equalTo(self.contentView);
        make.width.mas_equalTo(AutoNumber(212));
        make.height.mas_equalTo(AutoNumber(151));
    }];
    imageV.userInteractionEnabled = YES;
    imageV.contentMode = UIViewContentModeScaleAspectFit;
    [imageV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(event_choseImageCick:)]];
    imageV.tag = tag;
    
    return imageV;
}

-(void)event_choseImageCick:(UIGestureRecognizer*)tap{
    
    _curIndex  = [[tap view] tag];
    [self.picker  getPhotoAlbumOrTakeAPhotoWithController:self photoBlock:^(UIImage * _Nonnull image) {

        NSData * originData = UIImagePNGRepresentation(image);
        NSLog(@"originData==%f",originData.length/1024.0/1024.0);

        NSData * ssData = [image compressBelowOneMBytes];
        NSLog(@"ssData==%f",ssData.length/1024.0/1024.0);

        [self dealImage:[UIImage imageWithData:ssData]];
    }];
}

-(void)dealImage:(UIImage*)image{
    
    switch (_curIndex) {
        case 1:
            self.frontImageView.image = image;
            _frontImage = image;
            break;
        case 2:
            self.backImageView.image = image;
            _backImage = image;
            break;
        case 3:
            self.holdFrontImageView.image = image;
            _holdFrontImage = image;
            break;
            
        default:
            break;
    }
    
    if (_backImage&&_frontImage&&_holdFrontImage) {
        self.sendBtn.enabled = YES;

    }else{
        self.sendBtn.enabled = NO;
    }
}

-(void)uploadImages{
    
    if (!(_backImage&&_frontImage&&_holdFrontImage)) {
        return;
    }

    [SVProgressHUD show];
    [CANetworkHelper uploadImagesWithURL:CAAPI_MINE_UPLOAD_ID_CARD_FILES parameters:nil name:@[@"front",@"back",@"man"] images:@[_frontImage,_backImage,_holdFrontImage] progress:^(NSProgress *progress) {
        
    } success:^(id responseObject) {
        Toast(responseObject[@"message"]);
        if ([responseObject[@"code"] integerValue]==20000) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self->_emptyView) {
                    [self->_emptyView removeFromSuperview];
                    self->_emptyView = nil;
                }
                self->_user.identity_state = responseObject[@"data"][@"identity_state"];
                self->_user.identity_state_name = responseObject[@"data"][@"identity_state_name"];
                self->_user.is_read_my_identified_fail = NO;
                
                [self.contentView removeFromSuperview];
                [self initAuditingEmptyView];
            });
        }
        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
    
}

@end
