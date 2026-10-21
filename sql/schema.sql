-- 用户中心数据库初始化脚本
-- 执行方式：mysql -u root -p < sql/schema.sql

CREATE DATABASE IF NOT EXISTS user_center
  DEFAULT CHARACTER SET utf8mb4
  COLLATE utf8mb4_general_ci;

USE user_center;

DROP TABLE IF EXISTS t_user;

CREATE TABLE t_user (
  id         BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
  username   VARCHAR(50)     NOT NULL                COMMENT '登录名',
  email      VARCHAR(100)    NOT NULL                COMMENT '邮箱',
  password   VARCHAR(200)    NOT NULL                COMMENT 'PBKDF2 编码后的密码，格式 pbkdf2$迭代次数$盐$摘要',
  created_at DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  updated_at DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (id),
  UNIQUE KEY uk_user_username (username),
  UNIQUE KEY uk_user_email (email)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COMMENT = '用户表';
