package com.modules.sys.web;

import java.io.IOException;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONObject;

import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authc.IncorrectCredentialsException;
import org.apache.shiro.authc.UnknownAccountException;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.apache.shiro.authz.annotation.RequiresRoles;
import org.apache.shiro.subject.Subject;
import org.redis.web.RedisClientTemplate;
import org.shiro.web.helper.ActivityUserHelper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.modules.sys.dto.Result;
import com.modules.sys.entity.FileInfo;
import com.modules.sys.entity.Plupload;
import com.modules.sys.entity.User;
import com.modules.sys.service.UserService;
import com.modules.sys.utils.Upload;

@Controller
public class SysCTRL {

	@Autowired
	private RedisClientTemplate template;

	@Autowired
	private ActivityUserHelper activity;

	@Autowired
	private UserService service;

	/**
	 * 首页
	 * 
	 * @return
	 */
	@RequestMapping(value = "/index", method = RequestMethod.GET)
	public String index(Model model) {
		// 测试jedis
		System.out.println("aa=" + template.get("aa"));

		List<User> list = service.queryUser();
		onLine(list);
		model.addAttribute("list", list);
		return "index";
	}

	/**
	 * 首页
	 * 
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String indexOther(Model model) {
		return "redirect:/index";
	}

	/**
	 * 登录
	 * 
	 * @return
	 */
	@RequestMapping(value = "/login", method = RequestMethod.GET)
	public String login() {
		// 测试jedis
		template.set("aa", "10086");
		return "login";
	}

	/**
	 * 登录
	 * 
	 * @param request
	 * @param model
	 */
	@RequestMapping(value = "/login", method = RequestMethod.POST, produces = { "application/json; charset=utf-8" })
	public @ResponseBody
	Result submitLoginForm(User user, HttpServletRequest request, Model model) {
		String errorClassName = (String) request
				.getAttribute("shiroLoginFailure");
		if (UnknownAccountException.class.getName().equals(errorClassName)) {
			return Result.error("用户名/密码错误");
		} else if (IncorrectCredentialsException.class.getName().equals(
				errorClassName)) {
			return Result.error("用户名/密码错误");
		} else if (errorClassName != null) {
			return Result.error("未知错误：" + errorClassName);
		}
		return Result.ok("登录成功");
	}

	/**
	 * 登出
	 */
	@RequestMapping(value = "/logout", method = RequestMethod.GET)
	public String logout() {
		Subject subject = SecurityUtils.getSubject();
		subject.logout();
		return "redirect:/login";
	}

	/**
	 * 没有权限指定页面
	 * 
	 * @return
	 */
	@RequestMapping(value = "/unauthor", method = RequestMethod.GET)
	public String unauthor() {
		return "unauthor";
	}

	/**
	 * 判断用户是否在线
	 * 
	 * @param user
	 * @return
	 */
	private List<User> onLine(List<User> userList) {
		if (userList.size() > 0) {
			for (User user : userList) {
				user.setLine(activity.getActivityUser(user.getUsername()));
			}
		}
		return userList;
	}

	/** ==========【用户操作】========== **/

	/**
	 * 只有查看权限才能查看
	 */
	@RequiresPermissions("user:view")
	@RequestMapping(value = "/user/view", method = RequestMethod.GET)
	public String userView() {
		return "user/userView";
	}

	/**
	 * 只有查看权限才能查看
	 */
	@RequiresPermissions("user:edit")
	@RequestMapping(value = "/user/edit", method = RequestMethod.GET)
	public String userEdit() {
		return "user/userEdit";
	}

	/**
	 * 踢出登录用户
	 * 
	 * @param id
	 * @return
	 */
	@RequiresRoles("admin")
	@RequestMapping(value = "/user/kick", method = RequestMethod.POST)
	public @ResponseBody
	Result loginout(String id, User locUser) {
		User user = service.getUser(id);
		if (locUser.getId().equals(user.getId())) {
			return Result.error("请点击退出按钮");
		}
		Result r = activity.forceQuit(user.getUsername());
		return r;
	}

	/** ==========================[上传附件]=========================== **/

	@RequestMapping(value = "/upload", method = RequestMethod.GET)
	public String uplod() {
		return "upload1";
	}

	/**
	 * 上传图片
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/uploadImg", method = RequestMethod.POST)
	public @ResponseBody
	Result uploadImg(HttpServletRequest request, Plupload plupload)
			throws IOException {
		MultipartHttpServletRequest fileReq = (MultipartHttpServletRequest) request;
		MultipartFile file = fileReq.getFile("file");
		plupload.setMultipartFile(file);
		FileInfo imgInfo = new FileInfo();
		imgInfo.setName(file.getOriginalFilename());
		imgInfo.setContentType(file.getContentType());
		imgInfo.setLength(file.getSize());

		JSONObject jsonStu = new JSONObject();
		try {
			Upload.upload(request, plupload,imgInfo);
			// 判断文件是否上传成功（被分成块的文件是否全部上传完成）
			if (!Upload.isUploadFinish(plupload)) {
				jsonStu = JSONObject.fromObject(imgInfo);  
			}
		} catch (IllegalStateException e) {
			e.printStackTrace();
		}
		return Result.data(jsonStu);
	}

	/**
	 * 文件上传
	 * 
	 * @param request
	 * @param plupload
	 * @return
	 * @throws IOException
	 */
	@RequestMapping(value = "/upload", method = RequestMethod.POST)
	public @ResponseBody
	Result uload(HttpServletRequest request, Plupload plupload)
			throws IOException {

		MultipartHttpServletRequest fileReq = (MultipartHttpServletRequest) request;
		MultipartFile file = fileReq.getFile("file");
		plupload.setMultipartFile(file);

		try {
			Upload.upload(request, plupload);
			// 判断文件是否上传成功（被分成块的文件是否全部上传完成）
			/*
			 * if (Upload.isUploadFinish(plupload)) {
			 * System.out.println("name="+plupload.getName() +
			 * "----id="+plupload.getId()); }
			 */
		} catch (IllegalStateException e) {
			e.printStackTrace();
		}
		// return Result.data(fileInfo);
		return Result.data(plupload.getName());
	}

	/**
	 * 事务测试
	 * 
	 * @return
	 */

	@Transactional
	@RequestMapping(value = "test/1", method = RequestMethod.GET)
	public String gotoTransaction() {
		User user = new User();
		user.setUsername("10086");
		user.setPassword("123");
		user.setRoleId("2");
		service.save(user);
		return "/chat.jsp";
	}

	@Transactional
	@RequestMapping(value = "test/2", method = RequestMethod.GET)
	public String gotoTransaction2() {
		User user = new User();
		user.setUsername("10086");
		user.setPassword("123");
		user.setRoleId("2");
		service.save(user);

		System.out.println(1000 / 0);
		return "/chat.jsp";
	}
}
