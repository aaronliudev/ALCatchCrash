# ALCatchCrash
本次代码的主要思路来自于微信团队[iOS启动连续闪退保护方案](https://wereadteam.github.io/2016/05/23/GYBootingProtection/)。
还有一篇介绍连续闪退的保护方案：[iOS App 连续闪退时如何上报 crash 日志](http://mrpeak.cn/blog/ios-instacrash-reporting/)。需要的请阅读以上内容。

本项目做了一些改动，方案为第二篇博客内容提供的方式：是在发生crash的时候，与app的启动时间做比较来判断是否存储crash count，在下次启动时判断是否需要修复。


