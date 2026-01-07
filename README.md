


## 简介

本项目源于 screw，只是新增了对翰高数据库的支持。感谢[screw](https://github.com/pingfangushi/screw.git)
## 特点

+ 简洁、轻量、设计良好

+ 多数据库支持
+ 多种格式文档
+ 灵活扩展
+ 支持自定义模板

## 数据库支持

- [x] MySQL 
- [x] MariaDB 
- [x] TIDB 
- [x] Oracle 
- [x] SqlServer 
- [x] PostgreSQL
- [x] Cache DB（2016）
- [x] 瀚高
- [ ] H2 （开发中）
- [ ] DB2  （开发中）
- [ ] HSQL  （开发中）
- [ ] SQLite（开发中）
- [ ] 达梦 （开发中）
- [ ] 虚谷  （开发中）
- [ ] 人大金仓（开发中）

## 文档生成支持

- [x] html
- [x] word
- [x] markdown

## 文档截图

+ **html**

<p align="center">
   <img alt="HTML" src="https://images.gitee.com/uploads/images/2020/0622/161414_74cd0b68_1407605.png">
</p>
<p align="center">
   <img alt="screw-logo" src="https://images.gitee.com/uploads/images/2020/0622/161723_6da58c41_1407605.png">
</p>

+ **word**

<p align="center">
   <img alt="word" src="https://images.gitee.com/uploads/images/2020/0625/200946_1dc0717f_1407605.png">
</p>

+ **markdwon**

<p align="center">
   <img alt="markdwon" src="https://images.gitee.com/uploads/images/2020/0625/214749_7b15d8bd_1407605.png">
</p>
<p align="center">
   <img alt="markdwon" src="https://images.gitee.com/uploads/images/2020/0625/215006_3601e135_1407605.png">
</p>

# 快速开始
1. clone本项目
2. 找到 [properties](screw-core/src/main/resources/properties)  目录 
3. 修改对应的配置文件
4. 找到[produce](screw-core/src/test/java/cn/smallodd/screw/core/produce) 目录 执行对应数据库的测试类
