# matrix_symbolization

一个命令行工具用于符号化腾讯开源的matrix的卡顿堆栈。

安装：
在项目根目录下执行以下命令:
1. swift build -c release (生成可执行文件)

2. cp .build/x86_64-apple-macosx/release/matrix_symbolization /user/local/bin (将可执行文件复制到执行路径中, 这样我们就可以在任何地方用这个工具了)

3. cp .source/matrix_symbolization/ks2apple.py /user/local/bin (因为依赖这个文件输出apple格式的crash报告，所以也需要拷贝)

使用：
matrix_symbolization -d dSYMs -c test.json



参考：
- https://github.com/pkclark/symbolicate
- https://github.com/kstenerud/KSCrash
- https://github.com/Tencent/matrix
