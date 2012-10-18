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

对于带有导航栏（UINavigationController）的 UIViewController／UITableViewController，您需要进行另外的设置，保证界面在左右拖动的过程中，不会出现令人尴尬的效果。如下图：

通过设置 `navigationBackgroundColor` 或者 `navigationBackgroundImage`。您可以指定显示特定的颜色或图片。在 `loadView` 的 `[super loadView]` 之后或 `viewDidLoad` 中加上如 `[self setNavigationBackgroundColor:[UIColor redColor]];` ，您就能够对带有导航栏的 ViewController 设置一个显示在背面的背景。

如果您的 SFViewController 没有用到 UINavigationController。也可以使用同样的方法，设置 SFViewController／SFTableViewController 的背景。

# ME

ShortFingerViewController 是 Sean Cheng 为其项目 CloudsFM 所写的一些代码。是我第一次写 Public Code，感到非常高兴。希望您会觉得这些代码有用。遇到 BUG 请告诉我。谢谢！