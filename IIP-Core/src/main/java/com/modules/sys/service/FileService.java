package com.modules.sys.service;

import com.modules.sys.dto.Result;
import com.modules.sys.entity.FileInfo;

public interface FileService {
	
	/**
	 * 新增
	 * @return
	 */
	public Result save(FileInfo file);
	
	/**
	 * 删除
	 * @param id
	 * @return
	 */
	public Result delt(String id);
	
	/**
	 * 查询
	 * @param id
	 * @return
	 */
	public FileInfo findOne(String id);
	

}
