package cn.smallodd.screw.web;

import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;


@SpringBootApplication
@Slf4j
public class SmallScrewApplication {

    public static void main(String[] args) {
        SpringApplication.run(SmallScrewApplication.class, args);
        log.info("account-statement-data-auth 平台启动成功");
    }

}
