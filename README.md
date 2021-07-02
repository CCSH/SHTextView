# SHTextView
文本局部点击，定制文本输入框

# 使用 pod 导入

```
pod 'SHTextView'
```

- [x] 自定义点击链接样式
- [x] 自定义文本样式
- [x] 自定义占位文字
- [x] 随用户输入自动改变文本框高度
- [x] 光标自定义
- [x] 小细节优化

**文本局部点击方法 其中textview的有点小问题，长按点击位置拖动会显示自定义链接，下面这个基于label的点击没问题**
>[`基于TextView代码`](https://github.com/CCSH/SHTextView)使用textview自带NSLinkAttributeName链接识别点击

>[`基于Label代码`](https://github.com/CCSH/SHLabel)使用点击位置识别点击了哪个字符
