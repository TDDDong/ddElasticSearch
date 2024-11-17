package com.yupi.springbootinit.esdao;

import com.yupi.springbootinit.model.dto.post.PostEsDTO;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;

import javax.annotation.Resource;
import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.Optional;

@SpringBootTest
public class PostEsDaoTest {

    @Resource
    private PostEsDao postEsDao;

    @Test
    void testSelect() {
        System.out.println(postEsDao.count());
        Page<PostEsDTO> postPage = postEsDao.findAll(PageRequest.of(0, 5, Sort.by("createTime")));
        List<PostEsDTO> postList = postPage.getContent();
        Optional<PostEsDTO> byId = postEsDao.findById(1L);
        System.out.println(byId);
        System.out.println(postList);
    }

    @Test
    void testAdd() {
        PostEsDTO postEsDTO = new PostEsDTO();
        postEsDTO.setId(2L);
        postEsDTO.setTitle("dd是一个小黑子");
        postEsDTO.setContent("dd学习ElasticSearch 自己做项目");
        postEsDTO.setTags(Arrays.asList("java", "python"));
        postEsDTO.setUserId(1L);
        postEsDTO.setCreateTime(new Date());
        postEsDTO.setUpdateTime(new Date());
        postEsDTO.setIsDelete(0);
        postEsDao.save(postEsDTO);
        System.out.println(postEsDTO.getId());
    }

    @Test
    void testFindByTitle() {
        List<PostEsDTO> postEsDTOList = postEsDao.findByTitle("dd");
        System.out.println(postEsDTOList);
    }
}
