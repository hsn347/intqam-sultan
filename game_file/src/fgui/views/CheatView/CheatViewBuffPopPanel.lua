local buffDesRead = include("buffDesRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local CheatViewBuffPopPanel = class("CheatViewBuffPopPanel", baseFguiPanel)
function CheatViewBuffPopPanel:ctor(...)
	CheatViewBuffPopPanel.super.ctor(self, ...)
	print("CheatViewBuffPopPanel:ctor", self.viewName)
end
function CheatViewBuffPopPanel:onInit()
	print("=======CheatViewBuffPopPanel:onInit")
	self.tag = 1
	self.extraCfg, _ENV, self.basicCfg, _ENV, self.isEditModel = print, print, print, print, false
	self.fields.Panel_bg:setString("属性")
	self.fields.List_basic:setItemRenderer(handler(self, self.onBasicRender))
	self.fields.Text_id:setString("ID")
	self.fields.Text_buff:setString("效果描述")
	self.fields.Text_value:setString("参数")
	self.fields.List_extra:setItemRenderer(handler(self, self.onExtraRender))
	self.fields.Button_ok:setString("设置")
	self.fields.Button_ok:addClickListener(handler(self, self.btnClick))
	self.fields.Button_zero:setString("重置参数")
	self.fields.Button_zero:addClickListener(handler(self, self.btnZeroClick))
	self.fields.Button_skip:setString("跳转ID")
	self.fields.Button_skip:addClickListener(handler(self, self.btnSkipClick))
end
function CheatViewBuffPopPanel:onBasicRender(index, obj)
	obj:initData(self.basicCfg[index + 1], index + 1, self.isEditModel)
end
function CheatViewBuffPopPanel:onExtraRender(index, obj)
	local cfg = self.extraCfg[index + 1]
	obj:getChild("bg"):setVisible(index % 2 == 0)
	obj:getChild("Text_id"):setString(cfg.buffid)
	obj:getChild("Text_buff"):setString(cfg.des)
	local val = cfg.inputNumTest
	obj:getController("c1"):setSelectedIndex(0 < val and 0 or 1)
	if cfg.numType == 1 then
		val = tostring(cfg.inputNumTest / 10) .. "%"
	elseif cfg.numType == 3 then
		val = SoraDConvertSecondToString(cfg.inputNumTest)
	end
	obj:getChild("Text_value"):setString(val)
	obj:getChild("Text_value"):setVisible(not self.isEditModel)
	obj:getChild("input"):setText(cfg.inputNumTest)
	obj:getChild("input"):setVisible(self.isEditModel or false)
end
function CheatViewBuffPopPanel:onShow()
	print("=======CheatViewBuffPopPanel:onShow")
	self.editData = self.param.editData
	self.basicCfg = clone(buffDesRead.getBasicAttrCfg())
	self.extraCfg = clone(buffDesRead.getExtraAttrCfg())
	for i = 1, #self.basicCfg do
		for j = 1, #self.basicCfg[i] do
			self.basicCfg[i][j].inputNumTest = self.editData.buffMap[tostring(self.basicCfg[i][j].buffid)] or self.basicCfg[i][j].inputNumTest
		end
	end
	for k = 1, #self.extraCfg do
		self.extraCfg[k].inputNumTest = self.editData.buffMap[tostring(self.extraCfg[k].buffid)] or self.extraCfg[k].inputNumTest
	end
	_ENV = 1
	_ENV, _ENV, (1).defaultClick = self.extraCfg[k], self.tag, self.tag
	self.extraCfg[k].title = "基础属性"
	_ENV, self.tag[1], self.extraCfg[k].tag = self.extraCfg[k], self.extraCfg[k], 1
	self.extraCfg[k].title = "扩展属性"
	;(1).tabsetArray, self.tag[2], self.extraCfg[k].tag = self.tag, self.extraCfg[k], 2
	;(1).callback = handler(self, self.onTabClick)
	self.fields.Com_Tab:initView(1)
end
function CheatViewBuffPopPanel:onTabClick(tag)
	self:saveData()
	self.tag = tag
	self.controllers.c1:setSelectedIndex(self.tag - 1)
	self.fields.Button_zero:setEnabled(self.tag == 2)
	self.fields.Button_skip:setEnabled(self.tag == 2)
	if self.tag == 1 then
		self.fields.List_basic:setNumItems(#self.basicCfg)
	else
		self:sortExtra()
	end
end
function CheatViewBuffPopPanel:saveData()
	if not self.isEditModel then
		return
	end
	if self.tag == 1 then
		for i = 1, #self.basicCfg do
			local item = self.fields.List_basic:getChildAt(i - 1)
			for j = 1, #self.basicCfg[i] do
				local val = item:getChild("List"):getChildAt(j - 1):getChild("input"):getText()
				self.basicCfg[i][j].inputNumTest = tonumber(val)
			end
		end
		self.fields.List_basic:setNumItems(#self.basicCfg)
	else
		for k = 1, #self.extraCfg do
			local item = self.fields.List_extra:getChildAt(k - 1)
			local val = item:getChild("input"):getText()
			self.extraCfg[k].inputNumTest = tonumber(val)
		end
		self:sortExtra()
	end
end
function CheatViewBuffPopPanel:sortExtra()
	table.sort(self.extraCfg, function(a, b)
		if a.inputNumTest > 0 and b.inputNumTest > 0 or a.inputNumTest <= 0 and b.inputNumTest <= 0 then
			return a.index < b.index
		else
			return a.inputNumTest > 0
		end
	end)
	self.fields.List_extra:setNumItems(#self.extraCfg)
end
function CheatViewBuffPopPanel:skipToExtraBuff(text)
	local buffID = tonumber(text)
	local jumpIndex = -1
	if buffID then
		for k = 1, #self.extraCfg do
			if self.extraCfg[k].buffid == buffID then
				jumpIndex = k - 1
				break
			end
		end
	else
		for k = 1, #self.extraCfg do
			if string.find(self.extraCfg[k].des, text) then
				jumpIndex = k - 1
				break
			end
		end
	end
	if 0 <= jumpIndex then
		self.fields.List_extra:scrollToView(jumpIndex)
	else
		SoraDShowMsgTip(text .. "未匹配到，请重新输入！")
	end
end
function CheatViewBuffPopPanel:btnClick()
	SoraDPlaySound()
	self:saveData()
	self.isEditModel = not self.isEditModel
	self.fields.Button_ok:setString(self.isEditModel and "保存" or "设置")
	if self.tag == 1 then
		self.fields.List_basic:setNumItems(#self.basicCfg)
	else
		self:sortExtra()
	end
	if not self.isEditModel then
		local _ENV, buffMap = self.isEditModel, self.isEditModel
		for i = 1, #self.basicCfg do
			for j = 1, #self.basicCfg[i] do
				buffMap[tostring(self.basicCfg[i][j].buffid)] = self.basicCfg[i][j].inputNumTest
			end
		end
		for k = 1, #self.extraCfg do
			buffMap[tostring(self.extraCfg[k].buffid)] = self.extraCfg[k].inputNumTest
		end
		_ENV = #self.extraCfg
		;(#self.extraCfg).msg = "MESSAGE_CHEAT_UI_FIGHTDEMO_BUFF"
		;(#self.extraCfg).buffMap = buffMap
		SoraDSendMessage(#self.extraCfg)
	end
end
function CheatViewBuffPopPanel:btnZeroClick()
	SoraDPlaySound()
	for k = 1, #self.extraCfg do
		self.extraCfg[k].inputNumTest = 0
	end
	self:sortExtra()
end
function CheatViewBuffPopPanel:btnSkipClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).prompt = "BUFFID或描述"
	;(nil).btnTitle = "前往"
	;(nil).handle = handler(self, self.skipToExtraBuff)
	uiManager:show("CheatCmdPop", nil)
end
return CheatViewBuffPopPanel
