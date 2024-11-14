package com.yupi.springbootinit.datasource;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.yupi.springbootinit.model.entity.Picture;

public interface DataSource<T> {

    Page<T> doSearch(String searchText, long pageNum, long pageSize);
}
