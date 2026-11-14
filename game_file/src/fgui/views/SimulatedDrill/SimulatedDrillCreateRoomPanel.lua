local simulatedDrillCtrl = SoraDGetCtrl("simulatedDrillCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local SimulatedDrillCreateRoomPanel = class("SimulatedDrillCreateRoomPanel", baseFguiPanel)
function SimulatedDrillCreateRoomPanel:ctor(...)
	self.isLRU = true
	SimulatedDrillCreateRoomPanel.super.ctor(self, ...)
	print("SimulatedDrillCreateRoomPanel:ctor", self.viewName)
end
function SimulatedDrillCreateRoomPanel:onInit()
	print("=======SimulatedDrillCreateRoomPanel:onInit")
	self.fields.Text_title1:setString(i18n("simulated_drill_text_43"))
	self.fields.Check_tick1_1:setString(i18n("simulated_drill_text_41"))
	self.fields.Check_tick1_2:setString(i18n("simulated_drill_text_08"))
	self.fields.Text_title3:setString(i18n("simulated_drill_text_40"))
	self.fields.Check_tick3_1:setString(i18n("simulated_drill_text_11"))
	self.fields.Check_tick3_2:setString(i18n("simulated_drill_text_12"))
	self.fields.Button_create:addClickListener(handler(self, self.onClickBtnCreate))
	self.input = self.fields.input:getChild("input")
	self.input:setPrompt(i18n("simulated_drill_text_10"))
	self.input:addEventListener(fgui.UIEventType.Changed, handler(self, self.onInputChanged))
	if not SoraDFIsRA() then
		_UPVALUE4_ = SoraDFIsRA()
		SoraDFIsRA()[1] = self.fields.Check_tick1_1
		SoraDFIsRA()[2] = self.fields.Check_tick1_2
		SoraDFIsRA()[3] = self.fields.Check_tick3_1
		local SoraDFIsRA()[4], config = self.fields.Check_tick3_2, SoraDFIsRA()
		for _, v in pairs(config) do
			v:fixPos()
			v:fixChildrenPos()
		end
		_UPVALUE3_ = (for generator)
		pairs(config)[1] = self.fields.input
		pairs(config)[2] = self.fields.Image_yes
		local pairs(config)[3], config = self.fields.Image_no, pairs(config)
		for _, v in pairs(config) do
			v:fixPos()
		end
	end
end
function SimulatedDrillCreateRoomPanel:endShow()
	print("=======SimulatedDrillCreateRoomPanel:endShow")
	SoraDCloseLoading(self)
	self.isSetting = self.param.isSetting
	if self.isSetting then
		self.fields.Panel_bg:setString(i18n("simulated_drill_title_08"))
		self.fields.Button_create:setString(i18n("simulated_drill_btn_04"))
		local private = simulatedDrillCtrl:getRoomPrivate()
		if private then
			self.controllers.state:setSelectedIndex(1)
		else
			self.controllers.state:setSelectedIndex(0)
		end
		local password = simulatedDrillCtrl:getRoomPassword()
		if password then
			self.controllers.password:setSelectedIndex(1)
			self.input:setText(tostring(password))
			self.fields.Image_yes:setVisible(true)
			self.fields.Image_no:setVisible(false)
		else
			self.controllers.password:setSelectedIndex(0)
			self.input:setText("")
			self.fields.Image_yes:setVisible(false)
			self.fields.Image_no:setVisible(true)
		end
	else
		self.fields.Panel_bg:setString(i18n("chat_btn_02"))
		self.fields.Button_create:setString(i18n("chat_btn_02"))
		self.controllers.state:setSelectedIndex(0)
		self.controllers.password:setSelectedIndex(0)
		self.input:setText("")
		self.fields.Image_yes:setVisible(false)
		self.fields.Image_no:setVisible(true)
	end
end
function SimulatedDrillCreateRoomPanel:onClickBtnCreate(context)
	SoraDPlaySound()
	local password
	local hasPassword = not self.fields.Check_tick1_1:isSelected()
	if hasPassword then
		local inputText = self.input:getText()
		password = string.match(inputText, "^%d+$")
		if not password then
			SoraDShowMsgTip(i18n("simulated_drill_text_13"))
			self.input:setText("")
			return
		end
	end
	local private = not self.fields.Check_tick3_1:isSelected()
	if self.isSetting then
		simulatedDrillCtrl:reqRoomSet(private, password)
		self:closePanel()
	else
		simulatedDrillCtrl:reqRoomCreate(private, password)
		SoraDShowLoading()
	end
end
function SimulatedDrillCreateRoomPanel:onInputChanged(context)
	local showYes = false
	local inputText = self.input:getText()
	if tonumber(inputText) and string.match(inputText, "^%d+$") then
		local keyLen = string.utf8len(inputText)
		if 1 <= keyLen and keyLen <= 15 then
			showYes = true
		end
	end
	self.fields.Image_yes:setVisible(showYes)
	self.fields.Image_no:setVisible(not showYes)
end
return SimulatedDrillCreateRoomPanel
