//
//  ViewController.m
//  SHTextViewExample
//
//  Created by CSH on 2019/5/23.
//  Copyright © 2019 CSH. All rights reserved.
//

#import "ViewController.h"
#import "SHTextView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet SHTextView *textView1;
@property (weak, nonatomic) IBOutlet SHTextView *textView2;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    //编辑
    //提示文字
    self.textView1.placeholderLab.frame = CGRectMake(5, 2, 0, 0);
    self.textView1.placeholderLab.text = @"我是提示文字";
    self.textView1.placeholderLab.font = [UIFont systemFontOfSize:16];
    [self.textView1.placeholderLab sizeToFit];
    CGRect frame = self.textView1.placeholderLab.frame;
    frame.size = self.textView1.placeholderLab.frame.size;
    self.textView1.placeholderLab.frame = frame;
    
    //光标位置
    self.textView1.positionF = CGRectMake(0, 4, 0, 16);

    self.textView1.text = @"1234";
    
    //全局属性
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 6;
    self.textView1.globalAtts = @{ NSForegroundColorAttributeName: [UIColor whiteColor],
                                   NSFontAttributeName: [UIFont systemFontOfSize:18],
                                   NSParagraphStyleAttributeName: style };
    
    //自适应
    self.textView1.maxH = 100;
    self.textView1.minH = 20;

    [self.view addSubview:self.textView1];
    
    
    //点击
    NSString *content = @"阿松的海景房abcdefghijklmnopqrstuvwxy结婚的高发杉本繁郎火213472013sadf我被批好闻哦内存三次吧类型国产赛跑堵车比USA的撒开了短发后撒电话发菩我和谁都烦死了都快分17600017559 啊啥的反馈个撒 624089195@qq.com   was 看到法国萨的";

    NSMutableArray *modelArr = [[NSMutableArray alloc] init];
    NSInteger loc = 0;
    NSInteger len = 0;

    for (int i = 0; i < 10; i++) {
        loc += len + arc4random() % 5;

        len = 1 + arc4random() % 4;

        if ((loc + len) > content.length) {
            break;
        }

        SHTextModel *model = [[SHTextModel alloc] init];
        model.parameter = [content substringWithRange:NSMakeRange(loc, len)];
        model.range = NSMakeRange(loc, len);

        [modelArr addObject:model];
    }

    self.textView2.editable = NO;

    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:content];
    [attStr addAttributes:@{ NSFontAttributeName: [UIFont systemFontOfSize:18] } range:NSMakeRange(0, attStr.length)];
    //设置内容
    self.textView2.attributedText = attStr;

    //设置内容填充
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(100, 25, 30, 30);
    view.backgroundColor = [UIColor redColor];
    [self.textView2 addSubview:view];
    self.textView2.frameArr = @[[NSValue valueWithCGRect:view.frame]];

    //设置链接属性
    NSDictionary *linkAttributes = @{ NSForegroundColorAttributeName: [UIColor orangeColor] };
    self.textView2.linkAtts = linkAttributes;

    //设置点击属性
    self.textView2.linkArr = modelArr;

    //回调
    self.textView2.textClickBlock = ^(SHTextModel *_Nonnull model, SHTextView *_Nonnull textView) {
        //内容回调
        UIAlertView *ale = [[UIAlertView alloc] initWithTitle:@"点击响应" message:[NSString stringWithFormat:@"参数:%@", model.parameter] delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
        [ale show];
    };
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
