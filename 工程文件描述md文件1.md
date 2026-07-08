# 工程文件描述1

| 文件路径 | 描述 |
| --- | --- |
| `.gitignore` | 忽略根目录依赖、构建产物、IDE配置、本地配置、C/C++缓存和测试临时目录。 |
| `AppScope/app.json5` | 声明应用包名、厂商、版本号、版本名、图标和应用名称资源。 |
| `AppScope/resources/base/element/string.json` | 定义应用级名称等基础字符串文案资源。 |
| `build-profile.json5` | 配置工程级签名、产品和 entry 模块构建目标。 |
| `entry/.gitignore` | 忽略 entry 模块依赖、预览缓存、构建目录、C/C++缓存和测试临时目录。 |
| `entry/build-profile.json5` | 配置 entry 模块源码目录、构建选项和目标设备相关构建信息。 |
| `entry/hvigorfile.ts` | 为 entry 模块应用 HarmonyOS Hvigor 构建插件。 |
| `entry/oh-package.json5` | 声明 entry 模块包名、版本和模块级依赖，目前未引入业务依赖。 |
| `entry/src/main/ets/common/bean/Category.ets` | 定义分类数据结构，包含分类标题和对应列表内容。 |
| `entry/src/main/ets/common/bean/ListItemData.ets` | 定义列表项数据结构，包含标题、摘要和右箭头图片资源。 |
| `entry/src/main/ets/common/constants/CommonConstants.ets` | 统一管理页面路由、参数键、列表数量、栅格断点、宽高比例等公共常量。 |
| `entry/src/main/ets/entryability/EntryAbility.ts` | 定义应用入口 Ability，记录生命周期日志，并加载 HomePage 作为启动页面。 |
| `entry/src/main/ets/pages/DailyRecommendPage.ets` | 实现每日推荐页 UI，包含 logo、手机号登录按钮和立即体验跳转按钮。 |
| `entry/src/main/ets/pages/HomePage.ets` | 实现登录页 UI，展示网易云风格 logo、手机号登录按钮和进入首页按钮。 |
| `entry/src/main/ets/pages/IndexPage.ets` | 实现主页标签 UI，包含我的、云村、推荐、发现四个 Tab、轮播图、导航入口、歌单、新碟和 MV 区块。 |
| `entry/src/main/ets/view/CategoryComponent.ets` | 渲染分类列表组件，展示标题、摘要、箭头，并点击跳转详情页。 |
| `entry/src/main/ets/view/DetailListComponent.ets` | 渲染详情列表组件，从视图模型读取详情数据并展示标题和摘要。 |
| `entry/src/main/ets/viewmodel/PageViewModel.ets` | 生成分类列表和详情列表所需的页面数据。 |
| `entry/src/main/module.json5` | 声明 entry 主模块、入口 Ability、手机和平板设备支持、页面配置和网络权限。 |
| `entry/src/main/resources/base/element/color.json` | 定义默认主题色、启动窗口背景色、列表文字色和分割线颜色。 |
| `entry/src/main/resources/base/element/float.json` | 定义列表高度、边距、圆角、字号、箭头尺寸等 UI 尺寸资源。 |
| `entry/src/main/resources/base/element/string.json` | 定义默认语言下的应用名、模块说明、Ability 文案、页面标题和列表文案。 |
| `entry/src/main/resources/base/profile/main_pages.json` | 声明主程序可路由页面，包括 HomePage、IndexPage 和 DailyRecommendPage。 |
| `entry/src/main/resources/en_US/element/string.json` | 定义英文环境下的应用名、页面标题、列表标题和说明文案。 |
| `entry/src/main/resources/zh_CN/element/string.json` | 定义中文环境下的应用名、页面标题、列表标题和说明文案。 |
| `entry/src/ohosTest/ets/test/Ability.test.ets` | 编写 Ability 相关自动化测试用例，验证应用 Ability 基础行为。 |
| `entry/src/ohosTest/ets/test/List.test.ets` | 编写列表相关自动化测试用例，验证列表页面或组件基础行为。 |
| `entry/src/ohosTest/ets/testability/pages/Index.ets` | 定义测试 Ability 的入口页面 UI，用于承载测试页面显示。 |
| `entry/src/ohosTest/ets/testability/TestAbility.ets` | 定义测试专用 Ability，加载测试入口页面并记录生命周期。 |
| `entry/src/ohosTest/ets/testrunner/OpenHarmonyTestRunner.ts` | 配置 OpenHarmony 测试运行器，用于发现并执行 Hypium 测试。 |
| `entry/src/ohosTest/module.json5` | 声明 ohosTest 测试模块、测试 Ability、测试页面和设备支持。 |
| `entry/src/ohosTest/resources/base/element/color.json` | 定义测试模块使用的基础颜色资源。 |
| `entry/src/ohosTest/resources/base/element/string.json` | 定义测试模块应用名、模块说明和测试 Ability 相关文案。 |
| `entry/src/ohosTest/resources/base/profile/test_pages.json` | 声明测试模块可加载的测试页面列表。 |
| `hvigor/hvigor-config.json5` | 配置 Hvigor 构建系统版本、模型版本和构建插件信息。 |
| `hvigor/hvigor-wrapper.js` | 封装 Hvigor 启动逻辑，定位本地构建工具并执行构建命令。 |
| `hvigorfile.ts` | 为整个工程应用 HarmonyOS 应用级构建插件。 |
| `hvigorw` | Linux/macOS 构建启动脚本，用于调用 Hvigor Wrapper。 |
| `hvigorw.bat` | Windows 构建启动脚本，用于调用 Hvigor Wrapper。 |
| `oh-package.json5` | 声明工程包名、版本和依赖，开发依赖包含 Hypium 测试框架。 |
| `oh-package-lock.json5` | 锁定工程依赖版本，记录 Hypium 等包的解析结果。 |
