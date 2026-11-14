local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001661_SearchPanel = class("Activity_9001661_SearchPanel", baseFguiPanel)
function Activity_9001661_SearchPanel:ctor(...)
	Activity_9001661_SearchPanel.super.ctor(self, ...)
	print("Activity_9001661_SearchPanel:ctor", self.viewName)
end
function Activity_9001661_SearchPanel:onInit()
	print("=======Activity_9001661_SearchPanel:onInit")
	self.fields.Panel_bg:setString(i18n("bubble_farm_text17"))
	self.input = self.fields.input:getChild("input")
	self.input:setPromptHolder(i18n("bubble_farm_text18"))
	self.fields.Btn_search:setString(i18n("common_text_166"))
	self.fields.Btn_search:addClickListener(handler(self, self.btnSearchClick))
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.onMemberRenderer))
	self.fields.Text_none:setString(i18n("bubble_farm_text34"))
	self.fields.Text_none:setVisible(false)
	self.fields.input:fixPos()
	self.fields.Btn_search:fixPos()
end
function Activity_9001661_SearchPanel:onShow()
	print("=======Activity_9001661_SearchPanel:onShow")
	if not self.param.memebers then
		_ENV = self.param.memebers
	end
	self.memebers = self.param.memebers
	if not self.param.mapTable then
		_ENV = self.param.mapTable
	end
	self.showList, _ENV, self.mapTable = self.param.mapTable, self.param.mapTable, self.param.mapTable
	for k, v in ipairs(self.memebers) do
		for _, data in ipairs(self.mapTable) do
			if data.uid and data.uid == v.uid and SoraDGetPlayerID() ~= v.uid then
				table.insert(self.showList, v)
			end
		end
	end
	self.listData = self.showList
	self.fields.List:setNumItems(#self.listData)
	self.fields.Text_none:setVisible(#self.listData == 0)
end
function Activity_9001661_SearchPanel:onMemberRenderer(index, obj)
	obj:initData(self.listData[index + 1], self)
end
function Activity_9001661_SearchPanel:btnSearchClick()
	SoraDPlaySound()
	local name = self.input:getText()
	if string.len(name) > 0 then
		self.listData, _ENV = string.len(name), string.len(name)
		for k, v in ipairs(self.showList) do
			if string.match(v.nickName, name) and SoraDGetPlayerID() ~= v.uid then
				table.insert(self.listData, v)
			end
		end
		if 0 < #self.listData then
			self.fields.List:setNumItems(#self.listData)
		else
			SoraDShowMsgTip(i18n("bubble_farm_text32"))
		end
	else
		SoraDShowMsgTip(i18n("bubble_farm_text18"))
	end
end
return Activity_9001661_SearchPanel
