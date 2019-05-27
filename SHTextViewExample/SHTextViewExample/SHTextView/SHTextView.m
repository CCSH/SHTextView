//
//  SHTextView.m
//  SHTextViewExample
//
//  Created by CSH on 2019/5/23.
//  Copyright © 2019 CSH. All rights reserved.
//

#import "SHTextView.h"

@interface SHTextView () <UITextViewDelegate>

@end

@implementation SHTextView

#pragma mark - 实例化
- (instancetype)init {
    self = [super init];
    if (self) {
        //初始化
        [self setup];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

#pragma mark - 初始化
- (void)setup {
    self.delegate = self;
    self.textContainerInset = UIEdgeInsetsZero;
    self.dataDetectorTypes = UIDataDetectorTypeAll;
    self.autocorrectionType = UITextAutocorrectionTypeNo;
}

#pragma mark - SET
- (void)setTextContainerInset:(UIEdgeInsets)textContainerInset {
    CGFloat padding = self.textContainer.lineFragmentPadding;
    [super setTextContainerInset:UIEdgeInsetsMake(textContainerInset.top, textContainerInset.left - padding, textContainerInset.bottom, textContainerInset.right - padding)];
}

- (void)setEditable:(BOOL)editable {
    [super setEditable:editable];

    if (!editable) {
        self.placeholderLab.hidden = YES;
    }
}

- (void)setMinH:(CGFloat)minH {
    _minH = minH;

    CGRect frame = self.frame;
    frame.size.height = minH;
    self.frame = frame;
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    [super setAttributedText:attributedText];
    [self dealPlaceholder];
}

- (void)setText:(NSString *)text {
    [super setText:text];
    [self dealPlaceholder];
}

- (CGRect)caretRectForPosition:(UITextPosition *)position {
    CGRect rect = [super caretRectForPosition:position];

    if (self.positionF.origin.x) {
        rect.origin.x += self.positionF.origin.x;
    }
    if (self.positionF.origin.y) {
        rect.origin.y += self.positionF.origin.y;
    }
    if (self.positionF.size.height) {
        rect.size.height = self.positionF.size.height;
    }
    if (self.positionF.size.width) {
        rect.size.width = self.positionF.size.width;
    }
    return rect;
}

#pragma mark - 懒加载
- (UILabel *)placeholderLab {
    if (!_placeholderLab) {
        _placeholderLab = [[UILabel alloc] init];
        _placeholderLab.font = self.font;
        _placeholderLab.textColor = [UIColor grayColor];
        [self addSubview:_placeholderLab];

        [self dealPlaceholder];
    }
    return _placeholderLab;
}

#pragma mark - editable (YES) 默认
- (void)setGlobalAtts:(NSDictionary *)globalAtts {
    _globalAtts = globalAtts;
    [self dealStyle];
}

static NSString *mark = @"link";

#pragma mark 处理提示文字
- (void)dealPlaceholder {
    self.placeholderLab.hidden = self.text.length || self.attributedText.length;
}

#pragma mark 处理样式
- (void)dealStyle {
    if (self.attributedText.length && self.globalAtts) {
        NSRange range = self.selectedRange;

        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
        [att addAttributes:self.globalAtts range:NSMakeRange(0, att.length)];
        self.attributedText = att;

        self.selectedRange = range;
    }
    
    if (self.maxH && self.minH) {
        
        __block CGRect frame = self.frame;
        
        CGFloat textH = ceil([self.attributedText boundingRectWithSize:CGSizeMake(frame.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size.height);
        textH = MIN(self.maxH, textH);
        textH = MAX(textH, self.minH);
        
        if (frame.size.height != textH) {
            
            frame.origin.y += frame.size.height - textH;
            frame.size.height = textH;
            
            [UIView animateWithDuration:0.25 animations:^{
                self.frame = frame;
            }];
        }
    }
    [self scrollRangeToVisible:self.selectedRange];
}

#pragma mark - editable (NO)
- (void)setLinkAtts:(NSDictionary *)linkAtts {
    _linkAtts = linkAtts;
    self.linkTextAttributes = linkAtts;
}

- (void)setLinkArr:(NSArray<SHTextModel *> *)linkArr {
    _linkArr = linkArr;
    //添加链接
    [linkArr enumerateObjectsUsingBlock:^(SHTextModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {

        [self addClickWithModel:obj idx:idx];
    }];
}

- (void)setFrameArr:(NSArray *)frameArr {
    _frameArr = frameArr;

    NSMutableArray<UIBezierPath *> *exclusionPaths = [[NSMutableArray alloc] init];
    for (id obj in frameArr) {
        CGRect frame = [obj CGRectValue];
        [exclusionPaths addObject:[self getBezierPathWithFrame:frame]];
    }

    self.textContainer.exclusionPaths = exclusionPaths;
}

- (UIBezierPath *)getBezierPathWithFrame:(CGRect)frame {
    CGRect rect = [self convertRect:frame fromView:self];
    return [UIBezierPath bezierPathWithRect:rect];
}

#pragma mark 添加点击
- (void)addClickWithModel:(SHTextModel *)model idx:(NSInteger)idx {
    //拿到字符串
    NSMutableAttributedString *atrString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];

    //添加属性
    if (atrString.length && model.range.length) {
        NSString *value = [NSString stringWithFormat:@"%@:%ld", mark, (long)idx];
        //添加点击
        [atrString addAttribute:NSLinkAttributeName value:value range:model.range];
        self.attributedText = atrString;
    }
}

#pragma mark - 点击判断
- (BOOL)didSelectLinkWithUrl:(NSURL *)URL {
    //是否是自定义的
    if ([URL.scheme isEqualToString:mark]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            __weak typeof(self) weakSelf = self;
            if (self.textClickBlock) {
                NSInteger idx = [URL.resourceSpecifier integerValue];
                self.textClickBlock(weakSelf.linkArr[idx], self);
            }
        });
        return YES;
    }
    return NO;
}

#pragma mark 拦截系统弹框
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (self.editable) {
        return YES;
    }
    return NO;
}

- (BOOL)canBecameFirstResponder {
    return YES;
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    if ([self didSelectLinkWithUrl:URL]) {
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    //处理提示文字
    [self dealPlaceholder];

    if (self.markedTextRange) {
        return;
    }

    //处理样式
    [self dealStyle];

    if (self.textDidChangeBlock) {
        self.textDidChangeBlock(self);
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if (self.textDidBeginBlock) {
        self.textDidBeginBlock(self);
    }
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    if (self.textDidEndBlock) {
        self.textDidEndBlock(self);
    }
    return YES;
}

@end


/**
 文字局部点击Model
 */
@implementation SHTextModel

@end
