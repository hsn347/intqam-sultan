local loginInput = class("loginInput", function(target)
	if target == nil then
		return SoraDCreateBasePanel("loginInput")
	end
	return target
end)
local VERSION_PASSWORD = "0920"
function loginInput:ctor()
	self.model = 1
	self.text_server = SoraDGetChildByName(self, "Text_server")
	self.text_server:setString("服务器:")
	self.text_user = SoraDGetChildByName(self, "Text_user")
	self.text_user:setString("用户名/龙腾ID:")
	self.text_language = SoraDGetChildByName(self, "Text_language")
	self.text_language:setString("语言:")
	self.btnLogin = SoraDGetChildByName(self, "Button_login")
	self.testBtn = self.btnLogin:clone()
	self.testBtn:setPositionY(self.testBtn:getPositionY() - 100)
	self.testBtn:setTitleText("test")
	self.testBtn:addTouchEventListener(handler(self, self.testBtnClick))
	self.testBtn:addTo(self.btnLogin:getParent())
	self.testBtn:setVisible(device.platform == "mac")
	self.btnLogin:addTouchEventListener(handler(self, self.loginBtnClick))
	self.dropBox_svr = include("commonDropBox").new()
	_ENV = handler(self, self.loginBtnClick)
	handler(self, self.loginBtnClick).width = 300
	handler(self, self.loginBtnClick).singleWidth = 250
	self.dropBox_svr:initConfig(handler(self, self.loginBtnClick))
	self.dropBox_svr:initData(gSvrlist.serverConfig)
	self.dropBox_svr:initView()
	self.dropBox_svr:setPosition(cc.p(-100, 25))
	self.dropBox_svr:addTo(self, 10)
	self.dropBox_lang = include("commonDropBox").new()
	_ENV = self
	self.width = 300
	self.singleWidth = 250
	self.dropBox_lang:initConfig(self)
	self.dropBox_lang:initData(gSvrlist.langConfig)
	self.dropBox_lang:initView()
	self.dropBox_lang:setPosition(cc.p(-100, -35))
	self.dropBox_lang:addTo(self, 9)
	self.editbox_password = ccui.EditBox:create(cc.size(300, 50), "frame_square_mac_bate.png", ccui.TextureResType.plistType)
	self.editbox_password:setPosition(cc.p(50, 60))
	self.editbox_password:setFontColor(display.COLOR_BLACK)
	self.editbox_password:setMaxLength(8)
	self.editbox_password:setInputFlag(cc.EDITBOX_INPUT_FLAG_INITIAL_CAPS_SENTENCE)
	self.editbox_password:setPlaceHolder("")
	self.editbox_password:addTo(self)
end
function loginInput:setModel(model)
	self.model = model
	self:initView()
	self:initData()
end
function loginInput:initView()
	if self.model == 1 then
		self.editbox_name = ccui.EditBox:create(cc.size(300, 50), "frame_square_mac_bate.png", ccui.TextureResType.plistType)
		self.editbox_name:setPosition(cc.p(50, 120))
		self.editbox_name:setFontColor(display.COLOR_BLACK)
		self.editbox_name:setMaxLength(100)
		self.editbox_name:setInputFlag(cc.EDITBOX_INPUT_FLAG_INITIAL_CAPS_SENTENCE)
		self.editbox_name:setPlaceHolder("")
		self.editbox_name:addTo(self)
	elseif self.model == 3 then
		self.editbox_name = ccui.EditBox:create(cc.size(300, 50), "frame_square_mac_bate.png", ccui.TextureResType.plistType)
		self.editbox_name:setPosition(cc.p(50, 120))
		self.editbox_name:setFontColor(display.COLOR_BLACK)
		self.editbox_name:setMaxLength(100)
		self.editbox_name:setInputFlag(cc.EDITBOX_INPUT_FLAG_INITIAL_CAPS_SENTENCE)
		self.editbox_name:setPlaceHolder("")
		self.editbox_name:addTo(self)
		self.dropBox_svr:setVisible(false)
		self.text_server:setVisible(false)
	else
		self.text_user:setVisible(false)
		self.text_language:setVisible(false)
		self.dropBox_lang:setVisible(false)
	end
end
function loginInput:initData()
	if self.model == 1 or self.model == 3 then
		local default_name = SoraDConfigGet("System:LoginView:UserName~string")
		self.editbox_name:setText(default_name)
		local language = SoraDConfigGet("System:LoginView:Language~integer")
		self.dropBox_lang:initDefaultIndex(language)
	end
	if device.platform == "mac" then
		self.editbox_password:setText(VERSION_PASSWORD)
	else
		local default_password = SoraDConfigGet("System:LoginView:PassWord~string")
		self.editbox_password:setText(default_password)
	end
	local tag = SoraDConfigGet("System:LoginView:SvrTag~integer")
	self.dropBox_svr:initDefaultIndex(tag)
	self.btnLogin:setTitleText("登录")
end
function loginInput:loginBtnClick(button, type)
	if type == ccui.TouchEventType.ended then
		self.btnLogin:setTitleText("登录中...")
		if VERSION_PASSWORD ~= self.editbox_password:getText() then
			return
		end
		SoraDConfigSet("System:LoginView:PassWord~string", self.editbox_password:getText())
		local user = ""
		if self.model == 1 or self.model == 3 then
			user = self.editbox_name:getText()
			user = string.trim(user)
			SoraDConfigSet("System:LoginView:UserName~string", user)
		end
		local svrInfo = self.dropBox_svr:getSelectedItem()
		SoraDConfigSet("System:LoginView:SvrTag~integer", svrInfo.index)
		local langInfo = self.dropBox_lang:getSelectedItem()
		SoraDConfigSet("System:LoginView:Language~integer", langInfo and langInfo.index or 1)
		if self.model ~= 3 then
			gSvrConfig.ip = svrInfo.ip
			gSvrConfig.loginPort = svrInfo.port
		end
		if self.model == 1 or self.model == 3 then
			local lang = langInfo and langInfo.lang or "zh_cn"
			SoraDSetGameLanguage(lang)
			local code = langInfo and langInfo.code or lang
			userSDKManager.setLanguage(gSDKDef.ClientLanguage[code])
		end
		local loginCallBack = function()
			if user ~= "" then
				print("loginCallBak userSDKManager.userid =", userSDKManager.userid)
				print("user = ", user)
				userSDKManager.userid = user
				local curTime = SoraDGetSocketTime()
				userSDKManager.timeInfo.t_total.tbegin = curTime
				userSDKManager.timeInfo.t_sdk.tbegin = curTime
				userSDKManager.timeInfo.t_sdk.tend = curTime
				SoraDAddLoginViewProgress(gLoginRangeTbl.connectServer, 50)
				_G.SoraDStartLoginServerAndCheckVersion()
			else
				print("user = nil")
				userSDKManager.checkIsEmulator(function(...)
					print("=============开始使用sdk登录=======funPermit======")
					userSDKManager.login("")
				end, function(...)
					print("============我是模拟器，禁止登陆=====funForbid=====")
					userSDKManager.login("")
				end)
				print("========LoginView:loginBtnClick user is nil")
				print("开始使用sdk登录")
			end
		end
		if self.model == 3 then
			SoraDShowMsgBox([[
please confirm your account info:

]] .. user, i18n("common_text_054"), i18n("common_text_185"), function(callType)
				if callType == MSGBOX_CALLBACK_YES then
					loginCallBack()
				elseif callType == MSGBOX_CALLBACK_NO then
				end
			end)
		else
			loginCallBack()
		end
	end
end
function loginInput:testBtnClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDCreatePanel("testShaderView"):show()
	end
end
return loginInput
