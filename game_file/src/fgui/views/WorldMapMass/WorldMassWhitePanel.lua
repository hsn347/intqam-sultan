local baseFguiPanel = require("fgui.base.baseFguiPanel")
local massSettingWhiteListCtrl = SoraDGetCtrl("massSettingWhiteListCtrl")
local WorldMassWhitePanel = class("WorldMassWhitePanel", baseFguiPanel)
function WorldMassWhitePanel:ctor(...)
	self.isLRU = true
	WorldMassWhitePanel.super.ctor(self, ...)
	print("WorldMassWhitePanel:ctor", self.viewName)
end
function WorldMassWhitePanel:onInit()
	print("=======WorldMassWhitePanel:onInit")
	self.checkBox, _ENV = print, print
	for i = 1, 2 do
		self.checkBox[i] = self.fields["Button_check" .. i]
		self.checkBox[i]:addClickListener(handler(self, self.checkBoxClick))
		self.checkBox[i]:setTag(i)
		if not SoraDFIsRA() then
			self.checkBox[i]:fixPos()
			self.checkBox[i]:fixChildrenPos()
		end
	end
	self.fields.Panel_bg:setTitle(i18n("common_text_4891"))
	self.fields.Node_title_queue:setString(i18n("common_text_4890"))
	self.fields.Node_title2:setString(i18n("common_text_4891"))
	self.checkBox[1]:setString(i18n("common_text_247"))
	self.checkBox[2]:setString(i18n("common_text_246"))
	self.fields.text_tip:setString(i18n("common_text_4888"))
	self.fields.list:setVirtual()
	self.fields.list:setItemRenderer(handler(self, self.itemRenderer))
	self.fields.Button_add:setString(i18n("shopping_text_10"))
	self.fields.Button_add:addClickListener(handler(self, self.addClick))
	self.fields.Button_del:setString(i18n("common_text_697"))
	self.fields.Button_del:addClickListener(handler(self, self.removeClick))
	self.fields.Button_yes:setString(i18n("common_text_4894"))
	self.fields.Button_yes:addClickListener(handler(self, self.yesClick))
	self.fields.Button_no:setString(i18n("common_text_185"))
	self.fields.Button_no:addClickListener(handler(self, self.noClick))
	if not SoraDFIsRA() then
		self.fields.Button_add:fixPos()
		self.fields.Button_del:fixPos()
		self.fields.Button_yes:fixPos()
		self.fields.Button_no:fixPos()
	end
end
function WorldMassWhitePanel:endShow()
	print("=======WorldMassWhitePanel:endShow")
	local kname = worldMapDefine.getKingdomName(true)
	_ENV = nil
	;(nil).name = kname
	self.fields.text_battlefield:setString(i18n("common_text_4889", nil))
	self.fields.text_battlefield:setVisible(worldMapDefine.isInKingdomBattle() or worldMapDefine.isInWar())
	SoraDShowLoading(self)
	massSettingWhiteListCtrl:sendReqData()
	self:updateView()
end
function WorldMassWhitePanel:updateView()
	local whiteList = massSettingWhiteListCtrl:getMembers()
	self.whiteList, massSettingWhiteListCtrl = massSettingWhiteListCtrl, massSettingWhiteListCtrl
	for _, v in pairs(whiteList) do
		table.insert(self.whiteList, v)
	end
	self.editSelectedIndex, massSettingWhiteListCtrl, self.isEditMode = pairs(whiteList)
	self.fields.Button_yes:setEnabled(false)
	self.fields.list:setNumItems(#self.whiteList)
	self.isQueueSpeedwhiteListOpen = massSettingWhiteListCtrl:isEnabled()
	self.curSelectedIndex = self.isQueueSpeedwhiteListOpen and 2 or 1
	self.closeCallback = self.param.closeCallback
	for i = 1, 2 do
		self.checkBox[i]:setSelected(self.curSelectedIndex == i)
	end
	self.controllers.c1:setSelectedIndex(0)
end
function WorldMassWhitePanel:onHide()
	print("=======WorldMassWhitePanel:onHide")
	if self.closeCallback then
		self.closeCallback(self.isQueueSpeedwhiteListOpen)
	end
end
function WorldMassWhitePanel:checkBoxClick(EventContext)
	SoraDPlaySound()
	local tag = EventContext:getSender():getTag()
	if tag == self.curSelectedIndex then
		EventContext:getSender():setSelected(true)
		return
	end
	self.isQueueSpeedwhiteListOpen = tag == 2
	self.checkBox[self.curSelectedIndex]:setSelected(false)
	self.curSelectedIndex = self.isQueueSpeedwhiteListOpen and 2 or 1
	self.checkBox[self.curSelectedIndex]:setSelected(true)
	massSettingWhiteListCtrl:sendReqEnable(self.isQueueSpeedwhiteListOpen)
end
function WorldMassWhitePanel:itemRenderer(index, obj)
	local data = self.whiteList[index + 1]
	obj:initData(data, self.isEditMode, self.editSelectedIndex[data.uid])
	obj:setSelectedCallack(handler(self, self.onSelectedClick))
end
function WorldMassWhitePanel:onSelectedClick(data, isSelected)
	dump(isSelected, "WorldMassWhitePanel:onSelectedClick", 10)
	if isSelected then
		self.editSelectedIndex[data.uid] = true
	else
		self.editSelectedIndex[data.uid] = nil
	end
	self.fields.Button_yes:setEnabled(table.nums(self.editSelectedIndex) > 0)
end
function WorldMassWhitePanel:addClick()
	SoraDPlaySound()
	uiManager:show("WorldMassSearch")
end
function WorldMassWhitePanel:removeClick()
	SoraDPlaySound()
	self.controllers.c1:setSelectedIndex(1)
	self.editSelectedIndex, _ENV, self.isEditMode = self.controllers.c1.setSelectedIndex, self.controllers.c1.setSelectedIndex, true
	self.fields.Button_yes:setEnabled(false)
	self.fields.list:setNumItems(#self.whiteList)
end
function WorldMassWhitePanel:yesClick()
	SoraDPlaySound()
	local _ENV, idList = SoraDPlaySound, SoraDPlaySound
	for uid, _ in pairs(self.editSelectedIndex) do
		table.insert(idList, uid)
	end
	massSettingWhiteListCtrl:sendReqRemove(idList)
	self.controllers.c1:setSelectedIndex(0)
	self.editSelectedIndex, _ENV = self.controllers.c1.setSelectedIndex, self.controllers.c1.setSelectedIndex
	self.fields.Button_yes:setEnabled(false)
	self.isEditMode = false
	self.fields.list:setNumItems(#self.whiteList)
end
function WorldMassWhitePanel:noClick()
	SoraDPlaySound()
	self.controllers.c1:setSelectedIndex(0)
	self.isEditMode = false
	self.fields.list:setNumItems(#self.whiteList)
end
return WorldMassWhitePanel
