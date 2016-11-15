package com.modules.sys.dao;

import com.modules.sys.entity.FileInfo;

public interface FileDAO {
	
	/**
	 * 新增
	 */
	public void save(FileInfo file);
	
	/**
	 * 删除
	 */
	public void delt(String id);
	
	/**
	 * 查询
	 * @return
	 */
	public FileInfo getById(String id);

}
