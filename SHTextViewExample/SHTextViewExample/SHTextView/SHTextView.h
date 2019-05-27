//
//  SHTextView.h
//  SHTextViewExample
//
//  Created by CSH on 2019/5/23.
//  Copyright © 2019 CSH. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SHTextView,SHTextModel;

@interface SHTextView : UITextView

// 内容全局样式
@property (nonatomic, copy) NSDictionary *globalAtts;

#pragma mark - editable (YES) 编辑功能

// 默认提示文案Lab
@property (nonatomic, strong) UILabel *placeholderLab;

//光标F
@property (nonatomic, assign) CGRect positionF;

//以下两个属性搭配使用
//最大高度(此属性设置了则会随着输入自动改变高度)
@property (nonatomic, assign) CGFloat maxH;
//最小高度(此属性设置了则会随着输入自动改变高度)
@property (nonatomic, assign) CGFloat minH;

// 文本改变
@property (nonatomic, strong) void(^textDidChangeBlock)(SHTextView *textView);
// 开始编辑
@property (nonatomic, strong) void(^textDidBeginBlock)(SHTextView *textView);
// 结束编辑
@property (nonatomic, strong) void(^textDidEndBlock)(SHTextView *textView);

//在editable 设置为 NO 时开启局部点击功能
#pragma mark - editable (NO) 展示功能

//链接属性(颜色，字体大小等)
@property (nonatomic, copy) NSDictionary *linkAtts;
//链接属性(需要提前设置attributedText)
@property (nonatomic, copy) NSArray <SHTextModel *>*linkArr;
//视图填充集合(frame集合 相对于 此视图)
@property (nonatomic, copy) NSArray <NSValue *>*frameArr;

//文本点击
@property (nonatomic, copy) void (^textClickBlock)(SHTextModel *model,SHTextView *textView);

//如果UITextViewDelegate在其他地方实现 请在
//- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
//中执行此方法（返回YES则是我的链接 NO则不是）
- (BOOL)didSelectLinkWithUrl:(NSURL *)url;

//处理样式
- (void)dealStyle;

@end

/**
 文字局部点击Model
 */
@interface SHTextModel : NSObject

//参数
@property (nonatomic, copy) id parameter;
//范围
@property (nonatomic, assign) NSRange range;

@end

NS_ASSUME_NONNULL_END
