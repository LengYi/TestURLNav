# 自定义协议样例
#### <a name="说明">注意:</a> navigator为App的 url schemel


## WebView
### 内部链接

~~~
navigator://web?url=
~~~
+ 参数说明
	+ url 打开的链接

### 外部链接

~~~
navigator://ext_web?url=
~~~
+ 参数说明
	+ url 打开的链接

### 本地H5
打开本地内置h5页面

~~~
navigator://localH5/<target>
~~~	
+ target参数说明
	+ help 帮助中心
	+ agree 服务协议

## 测试模块
打开本地测试模块

~~~
navigator://test?msg=&code=
~~~	

+ 参数说明
	+ msg 消息
	+ code 消息code