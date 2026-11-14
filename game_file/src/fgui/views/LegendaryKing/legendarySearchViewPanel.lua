local legendTeamCtrl = SoraDGetCtrl("legendTeamCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local legendarySearchViewPanel = class("legendarySearchViewPanel", baseFguiPanel)
function legendarySearchViewPanel:ctor(...)
	legendarySearchViewPanel.super.ctor(self, ...)
	print("legendarySearchViewPanel:ctor", self.viewName)
end
function legendarySearchViewPanel:onInit()
	print("=======legendarySearchViewPanel:onInit")
	self.memberList, _ENV = print, print
	self.fields.Com_title:initData(i18n("legendary_commander_text10"), handler(self, self.onClickClose))
	self.fields.Text_tip:setString(i18n("legendary_commander_text14"))
	self.fields.Text_none:setString(i18n("legendary_commander_text13"))
	self.fields.Text_none:setVisible(false)
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onChooseItem))
	self.fields.Button_search:setString(i18n("common_text_166"))
	self.fields.Button_search:addClickListener(handler(self, self.btnSearchClick))
	self.tfdSearch = self.fields.input:getChild("input")
	self.fields.input:fixPos()
	self.fields.Button_search:fixPos()
end
function legendarySearchViewPanel:onItemRenderer(index, obj)
	obj:initData(self.memberList[index + 1])
end
function legendarySearchViewPanel:onChooseItem()
	SoraDPlaySound()
	local selIndex = self.fields.List:getSelectedIndex() + 1
	_ENV = nil
	_ENV = nil
	;(nil).name = self.memberList[selIndex].nickName
	;(nil).content = i18n("legendary_commander_text31", nil)
	;(nil).confirmString = i18n("common_text_204")
	;(nil).confirmFunc = function()
		if legendTeamCtrl:isPrepareStatus() then
			legendTeamCtrl:reqTeamAddCommander(self.memberList[selIndex].uid)
			self:close()
		else
			SoraDShowMsgTip(i18n("legendary_commander_text7"))
		end
	end
	uiManager:show("MessageBox", nil)
end
function legendarySearchViewPanel:onShow()
	print("=======legendarySearchViewPanel:onShow")
	local _ENV, searchList = print, print
	local memberList = legendTeamCtrl:getTeamMemberList()
	for k, v in ipairs(memberList) do
		if SoraDGetPlayerID() ~= v.uid and not legendTeamCtrl:isTeamCommander(v.uid) then
			table.insert(searchList, v)
		end
	end
	self:initView(searchList)
end
function legendarySearchViewPanel:initView(memberList)
	self.memberList = memberList
	self.fields.List:setNumItems(#self.memberList)
	self.fields.Text_none:setVisible(#self.memberList == 0)
end
function legendarySearchViewPanel:btnSearchClick()
	SoraDPlaySound()
	local keyName = self.tfdSearch:getText()
	if keyName and string.utf8len(keyName) > 0 then
		local _ENV, searchList = string.utf8len(keyName), string.utf8len(keyName)
		local memberList = legendTeamCtrl:getTeamMemberList()
		for k, v in ipairs(memberList) do
			if SoraDGetPlayerID() ~= v.uid and not legendTeamCtrl:isTeamCommander(v.uid) and string.find(v.nickName, keyName) then
				table.insert(searchList, v)
			end
		end
		self:initView(searchList)
	end
end
return legendarySearchViewPanel
