package cn.smallodd.screw.web.controller;

import cn.smallodd.screw.core.Configuration;
import cn.smallodd.screw.core.engine.EngineConfig;
import cn.smallodd.screw.core.engine.EngineFileType;
import cn.smallodd.screw.core.engine.EngineTemplateType;
import cn.smallodd.screw.core.execute.DocumentationExecute;
import cn.smallodd.screw.core.metadata.model.DataModel;
import cn.smallodd.screw.core.process.DataModelProcess;
import cn.smallodd.screw.core.query.DatabaseType;
import cn.smallodd.screw.core.util.FileUtils;
import cn.smallodd.screw.core.util.StringUtils;
import cn.smallodd.screw.web.dto.DocBuilderDTO;
import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.io.IOUtils;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.sql.DataSource;
import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.*;

@RestController
@RequestMapping("/web/smallodd/v1")
@Slf4j
public class SmallScrewController {

    private static final String fileOutputDir = System.getProperty("java.io.tmpdir");

    @RequestMapping("/listDbType")
    public Map<String, String> listDbType() {
        Map<String, DatabaseType> enumMap = DatabaseType.ENUM_MAP;
        Set<Map.Entry<String, DatabaseType>> entries = enumMap.entrySet();
        Map<String, String> map = new TreeMap<>();
        for (Map.Entry<String, DatabaseType> entry : entries) {
            map.put(entry.getKey(), entry.getValue().getDesc());
        }
        return map;
    }


    @RequestMapping("/docFileType")
    public Map<String, String> docFileType() {
        Map<String, EngineFileType> enumMap = EngineFileType.ENUM_MAP;
        Set<Map.Entry<String, EngineFileType>> entries = enumMap.entrySet();
        Map<String, String> map = new TreeMap<>();
        for (Map.Entry<String, EngineFileType> entry : entries) {
            map.put(entry.getKey(), entry.getValue().getDesc());
        }
        return map;

    }

    @RequestMapping("/docBuilder")
    public void docBuilder(@RequestBody DocBuilderDTO docBuilderDTO, HttpServletResponse response) {
        try {
            //数据源
            HikariConfig hikariConfig = new HikariConfig();
            hikariConfig.setDriverClassName(docBuilderDTO.getDbDriver());
            hikariConfig.setJdbcUrl(docBuilderDTO.getJdbcUrl());
            hikariConfig.setUsername(docBuilderDTO.getUserName());
            hikariConfig.setPassword(docBuilderDTO.getPassword());
            hikariConfig.setMinimumIdle(2);
            hikariConfig.setMaximumPoolSize(5);
            DataSource dataSource = new HikariDataSource(hikariConfig);
            //生成配置
            String fileDir = fileOutputDir + File.separator + new SimpleDateFormat("yyyyMMddHHmmssSSS").format(new Date());
            EngineConfig engineConfig = EngineConfig.builder()
                    //生成文件路径
                    .fileOutputDir(fileDir)
                    //文件类型
                    .fileType(EngineFileType.of(docBuilderDTO.getDocFileType()))
                    //生成模板实现
                    .produceType(EngineTemplateType.freemarker).build();

            //配置
            Configuration config = Configuration.builder()
                    //版本
                    .version(StringUtils.isBlank(docBuilderDTO.getDocVersion()) ? "1.0.0" : docBuilderDTO.getDocVersion())
                    //描述
                    .description(StringUtils.isBlank(docBuilderDTO.getDocDescription()) ? "数据库设计文档生成" : docBuilderDTO.getDocDescription())
                    //数据源
                    .dataSource(dataSource)
                    //生成配置
                    .engineConfig(engineConfig).build();

            DataModel dataModel = new DataModelProcess(config).process();
            DocumentationExecute documentationExecute = new DocumentationExecute(config);
            String docName = documentationExecute.getDocName(dataModel.getDatabase());
            documentationExecute
                    .execute();

            File file = new File(fileDir + File.separator + docName + docBuilderDTO.getDocFileType());

            // 设置响应头
            response.setContentType("application/octet-stream");
            response.setContentLengthLong(file.length());

            // 处理中文文件名
            String encodedFileName = java.net.URLEncoder.encode(file.getName(), "UTF-8")
                    .replace("+", "%20");
            response.setHeader("Content-Disposition", "attachment; filename=\"" + encodedFileName + "\"");

            // 使用 Common IO 简化流操作
            try (FileInputStream fis = new FileInputStream(file);
                 BufferedInputStream bis = new BufferedInputStream(fis)) {
                IOUtils.copy(bis, response.getOutputStream());
            }
        } catch (Exception e) {
            log.error("生成文档失败", e);
        }

    }

}
