package cn.smallodd.screw.web.dto;

import lombok.Data;

@Data
public class DocBuilderDTO {
    /**
     * 数据库连接地址
     */
    private String jdbcUrl;
    /**
     * 用户名
     */
    private String userName;
    /**
     * 密码
     */
    private String password;

    /**
     * 数据库驱动
     */
    private String dbDriver;
    /**
     * 数据库类型
     */
    private String dbType;

    /**
     * 文件类型
     */
    private String docFileType;

    /**
     * 文档版本
     */
    private String docVersion;

    /**
     * 文档描述
     */
    private String docDescription;

    /**
     * 文档标题
     */
    private String docTitle;

}
