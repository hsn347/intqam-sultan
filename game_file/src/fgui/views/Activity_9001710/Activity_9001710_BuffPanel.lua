local activity_9001710_Read = include("activity_9001710_Read")
local buffDesRead = include("buffDesRead")
local buffltCtrl = gModuleMgr.sharedMgr("buffltCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001710_BuffPanel = class("Activity_9001710_BuffPanel", baseFguiPanel)
function Activity_9001710_BuffPanel:ctor(...)
	self.isLRU = true
	Activity_9001710_BuffPanel.super.ctor(self, ...)
	print("Activity_9001710_BuffPanel:ctor", self.viewName)
end
function Activity_9001710_BuffPanel:onInit()
	print("=======Activity_9001710_BuffPanel:onInit")
	self.fields.Panel_bg:setString(i18n("Battle_Towers_23"))
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.onItemRender))
	self.fields.Text_lv:fixPos()
	for i = 1, 4 do
		self.fields["buff_" .. i]:addClickListener(handlerEx(self, self.btnIconClick, i))
		self.fields["buff_" .. i]:fixPos()
	end
end
function Activity_9001710_BuffPanel:onItemRender(index, obj)
	local data = self.buffList[index + 1]
	obj:fixChildrenPos()
	obj:getChild("Text_lv"):setString(data.lv)
	obj:getChild("nbg"):setVisible(index % 2 == 0)
	for i = 1, 4 do
		obj:getChild("Text_" .. i):setString(data["buff_" .. i])
	end
end
function Activity_9001710_BuffPanel:endShow()
	print("=======Activity_9001710_BuffPanel:endShow")
	self.buildType = self.param and self.param.buildType or 2
	self.tag = self.buildType - 1
	_ENV = nil
	_ENV, _ENV, (nil).defaultClick = nil, self.tag, self.tag
	;(nil).title = i18n("recharge_label_022")
	_ENV, self.tag[1], (nil).tag = nil, nil, 1
	;(nil).title = i18n("Soldiers_armor_text_48")
	;(nil).tabsetArray, self.tag[2], (nil).tag = self.tag, nil, 2
	;(nil).callback = handler(self, self.onTabClick)
	self.fields.com_TabW:initView(nil)
end
function Activity_9001710_BuffPanel:onTabClick(tag)
	self.tag = tag
	self.fields.Text_tips:setString(self.tag == 1 and i18n("CrescentDecree_text_06") or i18n("CrescentDecree_text_05"))
	self.fields.Text_lv:setString(self.tag == 1 and i18n("recharge_label_022") or i18n("Soldiers_armor_text_48"))
	self.buffList, _ENV, self.cfg = activity_9001710_Read.getBuffCfg(self.tag + 1), activity_9001710_Read.getBuffCfg(self.tag + 1), activity_9001710_Read.getBuffCfg(self.tag + 1)
	local _ENV, tmpData = activity_9001710_Read.getBuffCfg(self.tag + 1), activity_9001710_Read.getBuffCfg(self.tag + 1)
	tmpData.lv = self.cfg[1].lv[2] .. "-" .. self.cfg[1].lv[3]
	if self.tag == 2 then
		local cityltCtrl = include("cityltCtrl")
		local info = cityltCtrl.getQualityByStarLv(self.cfg[1].lv[3])
		tmpData.lv = cityltCtrl.getStatueBraveQualityName(info.quality)
	end
	for i = 1, 4 do
		if self.cfg[i] then
			self.fields["buff_" .. i]:setVisible(true)
			self.fields["buff_" .. i]:setIcon(self.cfg[i].bufftIcon)
		else
			self.fields["buff_" .. i]:setVisible(false)
		end
		tmpData["buff_" .. i] = buffDesRead.getTitleValueWithValue(self.cfg[i].buffID, self.cfg[i].buffVal)
	end
	table.insert(self.buffList, tmpData)
	self.fields.List:setNumItems(#self.buffList)
end
function Activity_9001710_BuffPanel:btnIconClick(index)
	SoraDPlaySound()
	SoraDShowMsgTip(i18n(self.cfg[index].buffDescription))
end
return Activity_9001710_BuffPanel
