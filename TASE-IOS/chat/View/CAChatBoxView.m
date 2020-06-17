//
//  CAChatBoxView.m
//  TASE-IOS
//
//  Copyright © 2019 CA. All rights reserved.
//

#import "CAChatBoxView.h"
#import "CAChatBoxMoreView.h"

#define     MAX_TEXTVIEW_HEIGHT         104

@interface CAChatBoxView()
<UITextViewDelegate,
CAChatBoxMoreViewDelegate>
{
    CGFloat _originTextViewH;
    CGFloat _keyboardHeight;
}
@property (nonatomic, strong) UITextView *textView;  // 输入框
@property (nonatomic, strong) UIView *contentView;  // 输入框
@property (nonatomic, strong) UIButton *moreButton;  // 选择图片
@property (nonatomic, strong) CAPhotoAlbumImagePicker * picker;
@property (nonatomic, strong) CAChatBoxMoreView * moreView;

@end

@implementation CAChatBoxView

-(CAPhotoAlbumImagePicker *)picker{
    if (!_picker) {
        _picker  = [CAPhotoAlbumImagePicker shareImgaePicker];
    }
    return _picker;
}

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        _curHeight = frame.size.height;
        self.dk_backgroundColorPicker = DKColorPickerWithKey(LineColor);
        
        [self.contentView addSubview:self.textView];
//        [self.contentView addSubview:self.moreButton];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        // 键盘的Frame值即将发生变化的时候创建的额监听
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
        
        self.state = CAChatBoxViewNone;
    }
    
    return self;
}

-(BOOL)resignFirstResponder{
    
    if (self.textView.isFirstResponder) {
        [self.textView resignFirstResponder];
    }
    
    if (self.state==CAChatBoxViewMore) {
        
        [_moreButton setImage:IMAGE_NAMED(@"tupian") forState:UIControlStateNormal];
        [_moreButton setImage:IMAGE_NAMED(@"tupian_hightlight") forState:UIControlStateHighlighted];
        
        [UIView animateWithDuration:0.25 animations:^{
            self.height-=self.moreView.height;
            if (self.delegate && [self.delegate respondsToSelector:@selector(chatBox:changeChatBoxHeight:)]) {
                [self.delegate chatBox:self changeChatBoxHeight:self.height+SafeAreaBottomHeight];
               }
        }completion:^(BOOL finished) {
            [self.moreView removeFromSuperview];
            self.state = CAChatBoxViewNone;
        }];
        
    }else if(self.state == CAChatBoxViewKeyBoard){
        
        [UIView animateWithDuration:0.25 animations:^{
        
            if (self.delegate && [self.delegate respondsToSelector:@selector(chatBox:changeChatBoxHeight:)]) {
                [self.delegate chatBox:self changeChatBoxHeight:self.height];
            }
        }completion:^(BOOL finished) {
            
            self.state = CAChatBoxViewNone;
        }];
    }else{
        
    }
    
    return [super resignFirstResponder];
}

#pragma mark - Private Methods
- (void)keyboardWillHide:(NSNotification *)notification{

    if (self.state == CAChatBoxViewKeyBoard) {
        
        if (_delegate && [_delegate respondsToSelector:@selector(chatBox:changeChatBoxHeight:)]) {
            
            [_delegate chatBox:self changeChatBoxHeight:self.height+SafeAreaBottomHeight];
        }
    }
    
    
    self.state = CAChatBoxViewNone;
    
}


- (void)keyboardFrameWillChange:(NSNotification *)notification{
    
    _keyboardHeight = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    if (self.state==CAChatBoxViewMore) {
        
        [UIView animateWithDuration:0.25 animations:^{
            self.height-=self.moreView.height;
            if (self.delegate && [self.delegate respondsToSelector:@selector(chatBox:changeChatBoxHeight:)]) {
                [self.delegate chatBox:self changeChatBoxHeight:self->_keyboardHeight+self.height];
               }
        }completion:^(BOOL finished) {
            [self.moreView removeFromSuperview];
             
        }];
        
    }else{
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(chatBox:changeChatBoxHeight:)]) {
            [self.delegate chatBox:self changeChatBoxHeight:self->_keyboardHeight+self.height];
        }
    }
    
    self.state = CAChatBoxViewKeyBoard;
    [_moreButton setImage:IMAGE_NAMED(@"tupian") forState:UIControlStateNormal];
    [_moreButton setImage:IMAGE_NAMED(@"tupian_hightlight") forState:UIControlStateHighlighted];
}


/**
 *  发送当前消息
 */

- (void) sendCurrentMessage
{
    if (self.textView.text.length > 0) {     // send Text
        if(_delegate && [_delegate respondsToSelector:@selector(chatBox:sendTextMessage:)]) {
            [_delegate chatBox:self sendTextMessage:self.textView.text];
        }
    }
    [self.textView setText:@""];
    [self textViewDidChange:self.textView];
}


- (void) textViewDidChange:(UITextView *)textView
{
//    
//    //内容高度
//    CGFloat contentSizeH = self.textView.contentSize.height;
//        //最大高度
//    CGFloat maxHeight = ceil(self.textView.font.lineHeight * 4);
//        //初始高度
//    CGFloat initiTextViewHeight = self.textView.font.lineHeight;
//    
//    if (contentSizeH <= maxHeight) {
//        
//        if (contentSizeH <= initiTextViewHeight) {
//            self.textView.height = initiTextViewHeight;
//        }else{
//            self.textView.height = contentSizeH;
//        }
//        
//    }else{
//        
//        self.textView.height = maxHeight;
//    }
//    
//   
//     self.height = self.textView.height + 2*6;
//     self.contentView.height = self.height-12;
//    
//    [textView scrollRangeToVisible:NSMakeRange(textView.selectedRange.location, 1)];
//    
//    if (self.delegate && [self.delegate respondsToSelector:@selector(chatBox:changeChatBoxHeight:)]) {
//
//        [self.delegate chatBox:self changeChatBoxHeight:self.height+self->_keyboardHeight];
//
//    }
   
}

////内容将要发生改变编辑
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]){
        [self sendCurrentMessage];
     
        return NO;
    }
   
    return YES;
}

-(void)CAChatBoxMoreViewActionType_didSelectItem:(CAChatBoxMoreViewActionType)type{
    switch (type) {
        case CAChatBoxMoreViewActionTypeAlbum:
        {
            [self.picker getPhotoInAlbumPhotoBlock:^(UIImage * _Nonnull image) {
                if (self.delegate &&[self.delegate respondsToSelector:@selector(chatBox:sendImageMessage:)]) {
                    [self.delegate chatBox:self sendImageMessage:image];
                }
            }];
        }
            break;
        case CAChatBoxMoreViewActionTypeCamera:
        {
            [self.picker getPhotoByTakeAPhotoBlock:^(UIImage * _Nonnull image) {
                if (self.delegate &&[self.delegate respondsToSelector:@selector(chatBox:sendImageMessage:)]) {
                    [self.delegate chatBox:self sendImageMessage:image];
                }
            }];
        }
            break;
            
        default:
            break;
    }
}

-(void)moreButtonClick{
    
    switch (self.state) {
        case CAChatBoxViewMore:
        {
            
             [_moreButton setImage:IMAGE_NAMED(@"tupian") forState:UIControlStateNormal];
             [_moreButton setImage:IMAGE_NAMED(@"tupian_hightlight") forState:UIControlStateHighlighted];
            
            [self.textView becomeFirstResponder];
        
        }
            break;
        case CAChatBoxViewKeyBoard:
        
        {
            [self resignFirstResponder];
            [self moreButtonClick];
        }
            
            break;
        case CAChatBoxViewNone:
        {
             self.state = CAChatBoxViewMore;
            [self.moreView setY:49];
            [self addSubview:self.moreView];
            [self.moreButton setImage:IMAGE_NAMED(@"jianpan") forState:UIControlStateNormal];
            [self.moreButton setImage:IMAGE_NAMED(@"tupian") forState:UIControlStateHighlighted];
            
            [UIView animateWithDuration:0.2 animations:^{
                 self.height += self.moreView.height;
                 if (self.delegate && [self.delegate respondsToSelector:@selector(chatBox:changeChatBoxHeight:)]) {
                    [self.delegate chatBox:self changeChatBoxHeight:self.height];
                }
            }];
           
        }
            break;
        default:
            break;
    }
}

- (UITextView *) textView
{
    if (_textView == nil) {

        _textView = [[UITextView alloc] initWithFrame:CGRectMake(15, 0, self.contentView.width-30, self.contentView.height)];
        _originTextViewH = _textView.height;
        [_textView setFont:FONT_MEDIUM_SIZE(15)];
        
        [_textView setScrollsToTop:NO];
        [_textView setReturnKeyType:UIReturnKeySend];// 返回按钮更改为发送
        [_textView setDelegate:self];
        _textView.inputAccessoryView = [UIView new];
        
    }
    return _textView;
}

-(UIButton *)moreButton{
    if (!_moreButton) {
        _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _moreButton.frame = CGRectMake(_textView.right, 0, 30, 22);
        _moreButton.centerY = _textView.centerY;
        _moreButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [_moreButton setImage:IMAGE_NAMED(@"tupian") forState:UIControlStateNormal];
        [_moreButton setImage:IMAGE_NAMED(@"tupian_hightlight") forState:UIControlStateHighlighted];
        [_moreButton addTarget:self action:@selector(moreButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _moreButton;
}

-(CAChatBoxMoreView *)moreView{
    if (!_moreView) {
        _moreView = [CAChatBoxMoreView new];
         CGFloat height = 100+SafeAreaBottomHeight;
        _moreView.frame = CGRectMake(0, 49, self.width, height);
        _moreView.backgroundColor = [UIColor whiteColor];
        _moreView.delegate = self;
        
    }
    return _moreView;
}

-(UIView *)contentView{
    if (!_contentView) {
        _contentView = [UIView new];
        [self addSubview:_contentView];
        _contentView.frame = CGRectMake(12, 6, self.width-24, 49-12);
        _contentView.backgroundColor = [UIColor whiteColor];
        [_contentView.layer setMasksToBounds:YES];
        [_contentView.layer setCornerRadius:(self.height-12)/2.f];
    }
    return _contentView;
}

@end
