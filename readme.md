iOS 加载大图时，解码时会导致内存爆增，
主要原因是开辟的 BitmapContext 很大，在往BitmapContext不断写数据的过程中，会导致 BitmapContext持续增大。

方案：
将图片分割成多个块，每块使用 CALayer 进行渲染。

![../memory.png](内存消耗)