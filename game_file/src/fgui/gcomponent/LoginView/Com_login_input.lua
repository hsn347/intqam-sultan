local baseComponent = require("fgui.base.baseComponent")
local Com_login_input = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://LoginView/Com_login_input", Com_login_input)
local VERSION_PASSWORD = "0920"
function Com_login_input:onInit()
	self.fields.text_server:setString("服务器:")
	self.fields.text_user:setString("用户名/龙腾ID:")
	self.fields.text_language:setString("语言:")
	self.fields.testBtn:setTitleText("test")
	self.fields.btnLogin:setTitleText("登录")
	self.fields.testBtn:setVisible(device.platform == "mac")
	self.fields.testBtn:addTouchEventListener(handler(self, self.testBtnClick))
	self.fields.testBtn:setVisible(false)
	self.fields.btnLogin:addTouchEventListener(handler(self, self.loginBtnClick))
end
function Com_login_input:onShow()
end
function Com_login_input:setMode(mode, parent)
	self.mode = mode
	self.parent = parent
	self.curLanIndex = SoraDConfigGet("System:LoginView:Language~integer") or 1
	if self.curLanIndex > #gSvrlist.langConfig then
		self.curLanIndex = 1
	end
	local _ENV, lanitems = self.curLanIndex, self.curLanIndex
	local _ENV, lanvalues = #gSvrlist.langConfig, #gSvrlist.langConfig
	for k, v in ipairs(gSvrlist.langConfig) do
		table.insert(lanitems, v.name)
		table.insert(lanvalues, k)
	end
	_ENV = nil
	;(nil).items = lanitems
	;(nil).values = lanvalues
	;(nil).changedCallback = handler(self, self.onComboBoxLanguageClick)
	self.parent:setComboBox(self.fields.ComboBox_language, nil)
	local dropdown_lan = self.fields.ComboBox_language:getDropdown()
	self.comboBoxLanList = dropdown_lan:getChildByName("list")
	self.fields.ComboBox_language:addClickListener(function()
		self.comboBoxLanList:setSelectedIndex(self.curLanIndex - 1)
	end)
	dropdown_lan:setScale(1)
	local langInfo = gSvrlist.langConfig[self.curLanIndex]
	self.fields.ComboBox_language:setTitle(langInfo.name)
	self.curSvrIndex = SoraDConfigGet("System:LoginView:SvrTag~integer") or 1
	if self.curSvrIndex > #gSvrlist.serverConfig then
		self.curSvrIndex = 1
	end
	local _ENV, svritems = self.curSvrIndex, self.curSvrIndex
	local _ENV, svrvalues = #gSvrlist.serverConfig, #gSvrlist.serverConfig
	for k, v in ipairs(gSvrlist.serverConfig) do
		table.insert(svritems, v.name)
		table.insert(svrvalues, k)
	end
	_ENV = k
	k.items = svritems
	k.values = svrvalues
	k.changedCallback = handler(self, self.onComboBoxSvrClick)
	self.parent:setComboBox(self.fields.ComboBox_svr, k)
	local dropdown_svr = self.fields.ComboBox_svr:getDropdown()
	self.comboBoxSvrList = dropdown_svr:getChildByName("list")
	self.fields.ComboBox_svr:addClickListener(function()
		self.comboBoxSvrList:setSelectedIndex(self.curSvrIndex - 1)
	end)
	dropdown_svr:setScale(1)
	local svrInfo = gSvrlist.serverConfig[self.curSvrIndex]
	self.fields.ComboBox_svr:setTitle(svrInfo.name)
	self.curUserIndex = SoraDConfigGet("System:LoginView:UserIndex~integer") or 1
	local _ENV, useritems = SoraDConfigGet("System:LoginView:UserIndex~integer") or 1, SoraDConfigGet("System:LoginView:UserIndex~integer") or 1
	local _ENV, uservalues = "System:LoginView:UserIndex~integer", "System:LoginView:UserIndex~integer"
	if not SoraDConfigGet("System:LoginView:UserList~table") then
		_ENV = SoraDConfigGet("System:LoginView:UserList~table")
	end
	self.userList = SoraDConfigGet("System:LoginView:UserList~table")
	if self.curUserIndex > #self.userList then
		self.curUserIndex = 1
	end
	if #self.userList > 0 then
		for k, v in ipairs(self.userList) do
			table.insert(useritems, v)
			table.insert(uservalues, k)
		end
		self.fields.ComboBox_user:setVisible(true)
		_ENV = k
		k.items = useritems
		k.values = uservalues
		k.changedCallback = handler(self, self.onComboBoxUserClick)
		self.parent:setComboBox(self.fields.ComboBox_user, k)
		local dropdown_user = self.fields.ComboBox_user:getDropdown()
		self.comboBoxUserList = dropdown_user:getChildByName("list")
		self.comboBoxUserBg = dropdown_user:getChildByName("bg")
		self.fields.ComboBox_user:addClickListener(function()
			self.comboBoxUserList:setSelectedIndex(self.curUserIndex - 1)
		end)
		dropdown_user:setScale(1)
		self.comboBoxUserBg:setPositionX(-55)
		self.comboBoxUserList:setPositionX(-55)
		self.fields.ComboBox_user:setTitle("")
		self.fields.editbox_name:setText(self.userList[self.curUserIndex])
	else
		self.fields.ComboBox_user:setVisible(false)
	end
	self:initData()
end
function Com_login_input:onComboBoxLanguageClick()
	self.curLanIndex = tonumber(self.fields.ComboBox_language:getValue())
	print("self.curLanIndex=====", self.curLanIndex)
end
function Com_login_input:onComboBoxSvrClick()
	self.curSvrIndex = tonumber(self.fields.ComboBox_svr:getValue())
	print("self.curSvrIndex=====", self.curSvrIndex)
end
function Com_login_input:onComboBoxUserClick()
	self.curUserIndex = tonumber(self.fields.ComboBox_user:getValue())
	print("self.curUserIndex=====", self.curUserIndex)
	self.fields.ComboBox_user:setTitle("")
	self.fields.editbox_name:setText(self.userList[self.curUserIndex])
end
function Com_login_input:initData()
	if self.mode == 1 or self.mode == 3 then
		local default_name = #self.userList > 0 and self.userList[self.curUserIndex] or SoraDConfigGet("System:LoginView:UserName~string")
		self.fields.editbox_name:setText(default_name)
	end
	if device.platform == "mac" then
		self.fields.editbox_password:setText(VERSION_PASSWORD)
	else
		local default_password = SoraDConfigGet("System:LoginView:PassWord~string")
		self.fields.editbox_password:setText(default_password)
	end
	self.fields.btnLogin:setTitleText("登录")
end
function Com_login_input:loginBtnClick(button, type)
	SoraDPlaySound()
	self.fields.btnLogin:setTitleText("登录中...")
	if VERSION_PASSWORD ~= self.fields.editbox_password:getText() then
		return
	end
	SoraDConfigSet("System:LoginView:PassWord~string", self.fields.editbox_password:getText())
	local user = ""
	if self.mode == 1 or self.mode == 3 then
		user = self.fields.editbox_name:getText()
		user = string.trim(user)
		SoraDConfigSet("System:LoginView:UserName~string", user)
		local rIndex = table.indexof(self.userList, user)
		if rIndex then
			table.remove(self.userList, rIndex)
		end
		table.insert(self.userList, 1, user)
		SoraDConfigSet("System:LoginView:UserList~table", self.userList)
		self.curUserIndex = 1
		SoraDConfigSet("System:LoginView:UserIndex~integer", self.curUserIndex)
	end
	local svrInfo = gSvrlist.serverConfig[self.curSvrIndex]
	SoraDConfigSet("System:LoginView:SvrTag~integer", self.curSvrIndex)
	local langInfo = gSvrlist.langConfig[self.curLanIndex]
	SoraDConfigSet("System:LoginView:Language~integer", self.curLanIndex)
	if self.mode == 1 or self.mode == 3 then
		gSvrConfig.ip = svrInfo.ip
		gSvrConfig.loginPort = svrInfo.port
	end
	if self.mode == 1 or self.mode == 3 then
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
	if self.mode == 3 then
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
function Com_login_input:testBtnClick(button, eventType)
	SoraDPlaySound()
end
return Com_login_input
