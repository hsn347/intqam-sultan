local activityCommonMergeRead = include("activityCommonMergeRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001663_choosePanel = class("Activity_9001663_choosePanel", baseFguiPanel)
function Activity_9001663_choosePanel:ctor(...)
	Activity_9001663_choosePanel.super.ctor(self, ...)
	print("Activity_9001663_choosePanel:ctor", self.viewName)
end
function Activity_9001663_choosePanel:onInit()
	print("=======Activity_9001663_choosePanel:onInit")
	self.itemList, _ENV = print, print
	self.chooseID = nil
	self.fields.Panel_bg:setString(i18n("bubble_party_text_21"))
	self.fields.Text_none:setString(i18n("Nebulastore_text_03"))
	self.fields.Text_none:setVisible(false)
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Button_ok:setString(i18n("common_text_204"))
	self.fields.Button_ok:addClickListener(handler(self, self.btnOkClick))
	self.fields.Button_ok:setEnabled(false)
end
function Activity_9001663_choosePanel:onItemRenderer(index, obj)
	obj:initData(self.itemList[index + 1].id, self.itemList[index + 1].count)
	obj:setSelectShow(true)
	obj:setSelected(self.id and self.id == self.itemList[index + 1].id)
end
function Activity_9001663_choosePanel:onShow()
	print("=======Activity_9001663_choosePanel:onShow")
	self.activityID = self.param.activityID
	self.enum = self.param.enum
	self.id = self.param.id
	self.chooseMap = self.param.chooseMap
	self.fields.Text_tip:setString(self.enum == 1 and i18n("bubble_party_text_22") or i18n("bubble_party_text_23"))
	self:initData()
end
function Activity_9001663_choosePanel:chooseBack(target, data)
	self.chooseID = data.id
	self.fields.Button_ok:setEnabled(true)
end
function Activity_9001663_choosePanel:initData()
	self.itemList, activityCommonMergeRead = nil, nil
	local list = activityCommonMergeRead.getCfgFormula(self.activityID)
	if self.enum == 1 then
		for k, v in ipairs(list) do
			local count = backpackCtrl:getItemCount(v)
			if 0 < count and (not self.chooseMap[2] or v ~= self.chooseMap[2]) then
				activityCommonMergeRead = nil
				;(nil).id = v
				;(nil).count = count
				table.insert(self.itemList, nil)
			end
		end
	else
		for k, v in ipairs(list) do
			if not self.chooseMap[1] or v ~= self.chooseMap[1] then
				activityCommonMergeRead = self.itemList
				self.itemList.id = v
				table.insert(self.itemList, self.itemList)
			end
		end
	end
	self.fields.List:setNumItems(#self.itemList)
	self.fields.Text_none:setVisible(#self.itemList == 0)
end
function Activity_9001663_choosePanel:btnOkClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).msg = "MESSAGE_ACTIVITY_9001663_UI_CHOOSE"
	;(nil).enum = self.enum
	;(nil).id = self.chooseID
	SoraDSendMessage(nil)
	self:close()
end
return Activity_9001663_choosePanel
