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
import cn.smallodd.screw.web.vo.DocFileTypeVO;
import cn.smallodd.screw.web.vo.ListDbTypeVO;
import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.io.IOUtils;
import org.springframework.core.io.FileSystemResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
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

/**
 * 生成文档
 */
@RestController
@RequestMapping("/web/smallodd/v1")
@Slf4j
public class SmallScrewController {

    private static final String fileOutputDir = System.getProperty("java.io.tmpdir");

    /**
     * 获取数据库类型
     *
     * @return
     */
    @RequestMapping("/listDbType")
    public List<ListDbTypeVO> listDbType() {
        Map<String, DatabaseType> enumMap = DatabaseType.ENUM_MAP;
        Set<Map.Entry<String, DatabaseType>> entries = enumMap.entrySet();
        List<ListDbTypeVO> list = new ArrayList<>();
        for (Map.Entry<String, DatabaseType> entry : entries) {
            ListDbTypeVO listDbTypeVO = new ListDbTypeVO();
            listDbTypeVO.setDbDesc(entry.getValue().getDesc());
            listDbTypeVO.setDbType(entry.getKey());
            list.add(listDbTypeVO);
        }

        return list;


    }


    /**
     * 获取文档类型
     *
     * @return
     */
   @RequestMapping("/docFileType")
    public List<DocFileTypeVO> docFileType() {
        Map<String, EngineFileType> enumMap = EngineFileType.ENUM_MAP;
        Set<Map.Entry<String, EngineFileType>> entries = enumMap.entrySet();
        List<DocFileTypeVO> list = new ArrayList<>();
        for (Map.Entry<String, EngineFileType> entry : entries) {
            DocFileTypeVO vo = new DocFileTypeVO();
            vo.setFileType(entry.getKey());
            vo.setFileTypeDesc(entry.getValue().getDesc());
            list.add(vo);

        }
        return list;

    }

    @RequestMapping("/docBuilder")
    public ResponseEntity<?> docBuilder(@RequestBody DocBuilderDTO docBuilderDTO) {
        File tempFile = null;
        try {
            // 数据源配置
            HikariConfig hikariConfig = new HikariConfig();
            hikariConfig.setDriverClassName(docBuilderDTO.getDbDriver());
            hikariConfig.setJdbcUrl(docBuilderDTO.getJdbcUrl());
            hikariConfig.setUsername(docBuilderDTO.getUserName());
            hikariConfig.setPassword(docBuilderDTO.getPassword());
            hikariConfig.setMinimumIdle(2);
            hikariConfig.setMaximumPoolSize(5);
            DataSource dataSource = new HikariDataSource(hikariConfig);

            // 生成配置
            String fileDir = fileOutputDir + File.separator + new SimpleDateFormat("yyyyMMddHHmmssSSS").format(new Date());
            EngineConfig engineConfig = EngineConfig.builder()
                    .fileOutputDir(fileDir)
                    .fileType(EngineFileType.of(docBuilderDTO.getDocFileType()))
                    .produceType(EngineTemplateType.freemarker)
                    .build();

            // 配置
            Configuration config = Configuration.builder()
                    .version(StringUtils.isBlank(docBuilderDTO.getDocVersion()) ? "1.0.0" : docBuilderDTO.getDocVersion())
                    .description(StringUtils.isBlank(docBuilderDTO.getDocDescription()) ? "数据库设计文档生成" : docBuilderDTO.getDocDescription())
                    .dataSource(dataSource)
                    .engineConfig(engineConfig)
                    .build();

            DataModel dataModel = new DataModelProcess(config).process();
            DocumentationExecute documentationExecute = new DocumentationExecute(config);
            String docName = documentationExecute.getDocName(dataModel.getDatabase());
            documentationExecute.execute();

            tempFile = new File(fileDir + File.separator + docName + docBuilderDTO.getDocFileType());

            // 处理中文文件名
            String fileName = tempFile.getName();
            String encodedFileName = java.net.URLEncoder.encode(fileName, "UTF-8").replace("+", "%20");

            return ResponseEntity.ok()
                    .contentType(MediaType.APPLICATION_OCTET_STREAM)
                    .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename*=UTF-8''" + encodedFileName)
                    .contentLength(tempFile.length())
                    .body(new FileSystemResource(tempFile));
        } catch (Exception e) {
            log.error("生成文档失败", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .contentType(MediaType.APPLICATION_JSON)
                    .body(Map.of("error", true, "message", e.getMessage()));
        }
    }


    /**
     * 向响应中写入错误JSON信息
     *
     * @param response HTTP响应对象
     *                 * @param message 错误消息
     */
    private void writeErrorResponse(HttpServletResponse response, String message) {
        try {
            response.reset();
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write(message);
            response.flushBuffer();
        } catch (IOException e) {
            log.error("写入错误响应失败", e);
        }
    }

}
