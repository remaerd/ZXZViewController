# WHY

iPhone 5 变长了，对于手指较短的人而言，拇指很难碰到导航栏上的按钮，操作并不方便。

ShortFingerViewController 主要为 UIViewController／UITableViewController 添加 '滑动检测' 功能，让 View 能够通过向下滑动／向左滑动等动作离开 ModalView 或返回到前一个菜单，让用户不需伸长手指点击导航栏上的相应按钮。

![](http://cloudsfm-show.b0.upaiyun.com/udjg1rLLGPHEcDzQp2IFWY2lDektsmVXuHtPhXsh7VU.jpeg)

### [看实际效果](http://d.pr/v/7g15)

# HOW
## 开始使用 ShortFingerViewController
ShortFingerViewController 继承了 UIViewController 的全部 API。这意味着你可以不需要大面积修改您现成的代码。

1. 下载后，将 SFViewController 文件夹中的所有文件拖入您的 XCode 项目中。

2. 在需要使用 SFViewController 的 *.h 文件中使用 `#import` 导入 `SFViewController.h` 文件。如果是 UITableViewController，需要导入 `SFTableViewController.h` 文件。如：`#import "SFTableViewController.h"`

3. 将超类（Superclass）改成 SFViewController。如：`@interface MainViewController : SFViewController`

4. 通过使用 `didPanToPositionX` 或者 `didPanToPositionY` 探测用户是否进行拖动。当用户拖动界面到达一定距离时，里面的代码就会执行。示范代码如下：`- (void)didPanToPositionX{[self dismissModalViewControllerAnimated:YES];}`

5. 如果您使用 Storyboard 或 Nib 开发软件，必须生成一个用于控制的 IBOutlet。打开助理编辑器（Assistant Editor，晚礼服图标），在 Interface Builder 中找到相应的 TableView 并按住右键，然后拖到右方的空白处。将 IBOutlet 命名为 tableView。这样能够保证您的设计能够在 SFViewController 中正常运行。

![](http://cloudsfm-show.b0.upaiyun.com/jkasdt20p983eijrdwfugofq.png)

只要完成以上步骤，ShortFingerViewController 就能正常运行。

## 可选项

ShortFingerViewController 自带一些可以设置的选项，其中包括

- `presentSpeed` 显示速度
- `previousViewMaskColor` 显示 ModalView 时背景 View 的背景颜色 
- `previousViewMaskAlpha` 显示 ModalView 时背景 View 的透明度
- `enableVerticalPull` 允许纵向拖动
- `enableHorizontalPull` 允许横向拖动
- `positionX` X 数值，在大于这个数值时激活 didPanToPositionX
- `positionY` Y 数值，在大于这个数值时激活 didPanToPositionY

## 背景

SFViewController 自带两张图片，用于显示标准 TableView 背景。如果您的 TableView 需要使用标准背景，您**必须**将他们导入到您的项目当中。

通过设置 `navigationBackgroundColor` ，您可以指定显示特定的颜色或图片。在 `loadView` 或 `viewDidLoad` 中加上如 `[self setNavigationBackgroundColor:[UIColor redColor]];` ，您就能够对带有导航栏的 ViewController 设置一个不受拖动干扰的背景。

当在不同的 ViewController 之间跳转时，背景会进行自动过渡。这意味着如果您的 ViewControllers 使用着同一个背景的话，您需要在每一个 ViewControllers 中分别设置一次背景，否则 ViewController 会显示标准背景。

# ME

ShortFingerViewController 是 Sean Cheng 为其项目 CloudsFM 所写的一些代码。是我第一次写 Public Code，感到非常高兴。希望您会觉得这些代码有用。遇到 BUG 请告诉我。谢谢！