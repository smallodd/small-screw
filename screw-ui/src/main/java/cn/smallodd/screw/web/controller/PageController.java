package cn.smallodd.screw.web.controller;

import cn.smallodd.screw.core.engine.EngineFileType;
import cn.smallodd.screw.core.query.DatabaseType;
import cn.smallodd.screw.web.vo.DocFileTypeVO;
import cn.smallodd.screw.web.vo.ListDbTypeVO;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Set;

@Controller
public class PageController {
    @GetMapping("/")
    public String showGenerator(Model model) {
        model.addAttribute("dbTypes", listDbType());
        model.addAttribute("fileTypes", docFileType());
        return "doc-generator"; // 返回模板文件名
    }


    /**
     * 获取数据库类型
     *
     * @return
     */
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
}
