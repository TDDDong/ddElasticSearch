package com.yupi.springbootinit.job.once;

import cn.hutool.http.HttpRequest;
import cn.hutool.json.JSONArray;
import cn.hutool.json.JSONObject;
import cn.hutool.json.JSONUtil;
import com.yupi.springbootinit.model.entity.Post;
import com.yupi.springbootinit.service.PostService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * 获取初始化帖子列表
 *
 * @author <a href="https://github.com/liyupi">程序员鱼皮</a>
 * @from <a href="https://yupi.icu">编程导航知识星球</a>
 */
// todo 取消注释开启任务
//@Component
@Slf4j
public class FetchInitPostList implements CommandLineRunner {

    @Resource
    private PostService postService;


    @Override
    public void run(String... args) {
        //1.获取数据
        String json = "{\"reviewStatus\":1,\"current\":1,\"needNotInterests\":true,\"hiddenContent\":true,\"sorterList\":[{\"field\":\"createTime\",\"asc\":false}],\"queryType\":\"hot\"}";
        String url = "https://api.codefather.cn/api/post/list/page/vo";
        String result = HttpRequest
                .post(url)
                .body(json)
                .execute().body();

        //2.json转对象
        Map<String, Object> map = JSONUtil.toBean(result, Map.class);
        JSONObject data = (JSONObject) map.get("data");
        JSONArray records = (JSONArray) data.get("records");
        List<Post> postList = new ArrayList<>();
        for (Object obj : records) {
            JSONObject tempRecord = (JSONObject) obj;
            Post post = new Post();
            post.setTitle(tempRecord.getStr("title"));
            post.setContent(tempRecord.getStr("plainTextDescription"));
            JSONArray tags = (JSONArray) tempRecord.get("tags");
            List<String> list = tags.toList(String.class);
            post.setTags(JSONUtil.toJsonStr(list));
            post.setUserId(1L);
            postList.add(post);
        }
        System.out.println(postList);

        //3.数据入库
        boolean b = postService.saveBatch(postList);
        if (b) {
            log.info("执行FetchInitPostList批量插入任务成功, 条数= {}", postList.size());
        } else {
            log.error("执行FetchInitPostList批量插入任务失败");
        }
    }
}
