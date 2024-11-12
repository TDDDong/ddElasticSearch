# 数据库初始化
# @author <a href="https://github.com/liyupi">程序员鱼皮</a>
# @from <a href="https://yupi.icu">编程导航知识星球</a>

-- 创建库
create database if not exists my_db;

INSERT INTO user (userAccount, userPassword, unionId, mpOpenId, userName, userAvatar, userProfile, userRole, createTime, updateTime, isDelete) VALUES
('zhangsan123', 'e10adc3949ba59abbe56e057f20f883e', 'wx123456', 'mp123456', '张三', 'https://example.com/avatar1.jpg', '爱好运动，喜欢交朋友', 'user', '2023-11-01 08:00:00', '2023-11-01 08:00:00', 0),
('lisi456', 'e10adc3949ba59abbe56e057f20f883e', 'wx654321', 'mp654321', '李四', 'https://example.com/avatar2.jpg', '旅行达人，探索世界', 'admin', '2023-11-02 09:00:00', '2023-11-02 09:00:00', 0),
('wangwu789', 'e10adc3949ba59abbe56e057f20f883e', NULL, NULL, '王五', 'https://example.com/avatar3.jpg', '美食博主，热爱烹饪', 'user', '2023-11-03 10:00:00', '2023-11-03 10:00:00', 0),
('zhaoliu101', 'e10adc3949ba59abbe56e057f20f883e', NULL, NULL, '赵六', 'https://example.com/avatar4.jpg', 'IT工程师，喜欢编程', 'ban', '2023-11-04 11:00:00', '2023-11-04 11:00:00', 0),
('zhouqi202', 'e10adc3949ba59abbe56e057f20f883e', 'wx789012', NULL, '周七', 'https://example.com/avatar5.jpg', '户外爱好者，徒步旅行', 'user', '2023-11-05 12:00:00', '2023-11-05 12:00:00', 0);


-- 切换库
use my_db;

-- 用户表
create table if not exists user
(
    id           bigint auto_increment comment 'id' primary key,
    userAccount  varchar(256)                           not null comment '账号',
    userPassword varchar(512)                           not null comment '密码',
    unionId      varchar(256)                           null comment '微信开放平台id',
    mpOpenId     varchar(256)                           null comment '公众号openId',
    userName     varchar(256)                           null comment '用户昵称',
    userAvatar   varchar(1024)                          null comment '用户头像',
    userProfile  varchar(512)                           null comment '用户简介',
    userRole     varchar(256) default 'user'            not null comment '用户角色：user/admin/ban',
    createTime   datetime     default CURRENT_TIMESTAMP not null comment '创建时间',
    updateTime   datetime     default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '更新时间',
    isDelete     tinyint      default 0                 not null comment '是否删除',
    index idx_unionId (unionId)
) comment '用户' collate = utf8mb4_unicode_ci;

-- 帖子表
create table if not exists post
(
    id         bigint auto_increment comment 'id' primary key,
    title      varchar(512)                       null comment '标题',
    content    text                               null comment '内容',
    tags       varchar(1024)                      null comment '标签列表（json 数组）',
    thumbNum   int      default 0                 not null comment '点赞数',
    favourNum  int      default 0                 not null comment '收藏数',
    userId     bigint                             not null comment '创建用户 id',
    createTime datetime default CURRENT_TIMESTAMP not null comment '创建时间',
    updateTime datetime default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '更新时间',
    isDelete   tinyint  default 0                 not null comment '是否删除',
    index idx_userId (userId)
) comment '帖子' collate = utf8mb4_unicode_ci;

-- 帖子点赞表（硬删除）
create table if not exists post_thumb
(
    id         bigint auto_increment comment 'id' primary key,
    postId     bigint                             not null comment '帖子 id',
    userId     bigint                             not null comment '创建用户 id',
    createTime datetime default CURRENT_TIMESTAMP not null comment '创建时间',
    updateTime datetime default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '更新时间',
    index idx_postId (postId),
    index idx_userId (userId)
) comment '帖子点赞';

-- 帖子收藏表（硬删除）
create table if not exists post_favour
(
    id         bigint auto_increment comment 'id' primary key,
    postId     bigint                             not null comment '帖子 id',
    userId     bigint                             not null comment '创建用户 id',
    createTime datetime default CURRENT_TIMESTAMP not null comment '创建时间',
    updateTime datetime default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '更新时间',
    index idx_postId (postId),
    index idx_userId (userId)
) comment '帖子收藏';
