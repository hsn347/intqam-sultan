local activity_9001736_Read = include("activity_9001736_Read")
local activity_9001736_Ctrl = SoraDGetCtrl("activity_9001736_Ctrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local itemDesRead = include("itemDesRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001736_GetSeedPanel = class("Activity_9001736_GetSeedPanel", baseFguiPanel)
function Activity_9001736_GetSeedPanel:ctor(...)
	Activity_9001736_GetSeedPanel.super.ctor(self, ...)
	print("Activity_9001736_GetSeedPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001736
	self.itemIdList = activity_9001736_Ctrl:getItemIdList()
end
function Activity_9001736_GetSeedPanel:onInit()
	print("=======Activity_9001736_GetSeedPanel:onInit")
	self.fields.Com_title:initData(i18n("football_match_text_024"), handler(self, self.onClickClose))
	self.fields.List:setItemRenderer(handler(self, self.itemRenderer_List))
	self.fields.List:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onClickItem))
	_ENV = handler(self, self.onClickItem)
	handler(self, self.onClickItem).num = 1
	self.fields.Button_drawOne:setTitle(i18n("football_match_text_064", handler(self, self.onClickItem)))
	self.fields.Button_drawOne:addClickListener(handler(self, self.onClick_Button_drawOne))
	_ENV = handler(self, self.onClick_Button_drawOne)
	handler(self, self.onClick_Button_drawOne).num = 10
	self.fields.Button_drawTen:setTitle(i18n("football_match_text_064", handler(self, self.onClick_Button_drawOne)))
	self.fields.Button_drawTen:addClickListener(handler(self, self.onClick_Button_drawTen))
	self.fields.Lab_tip:setString(i18n("football_match_text_067"))
end
function Activity_9001736_GetSeedPanel:endShow()
	print("=======Activity_9001736_GetSeedPanel:endShow")
	self.fields.List:setNumItems(#self.itemIdList)
end
function Activity_9001736_GetSeedPanel:itemRenderer_List(index, obj)
	local itemId = self.itemIdList[index + 1]
	local itemName = itemDesRead.getName(itemId)
	local itemCount = backpackCtrl:getItemCount(itemId)
	itemDesRead = nil
	;(nil).itemname = itemName
	itemDesRead, itemDesRead, (nil).num = nil, nil, itemCount
	;(nil).num, (nil).color = nil, "#FFD43E"
	local numStr = i18n_html("migrant_move_text44", nil, nil)
	obj:setString(numStr)
	local imageName = ""
	if index == 0 then
		imageName = "frame_9001736_ptkp.png"
	else
		imageName = "frame_9001736_gjkp.png"
	end
	obj:setIcon(imageName)
	local mv_1 = obj:getChild("mv_1")
	mv_1:setAllFrameName("dh_budui1_%.2d.png", 0)
end
function Activity_9001736_GetSeedPanel:onClickItem(context)
	SoraDPlaySound()
	local selectIdx = self.fields.List:getSelectedIndex()
	local itemId = self.itemIdList[selectIdx + 1]
	if not itemId then
		return
	end
	local itemCount = backpackCtrl:getItemCount(itemId)
	if itemCount == 0 then
		_ENV = nil
		;(nil).itemId = itemId
		uiManager:show("Activity_9001736_SourceGuide", nil)
	end
end
function Activity_9001736_GetSeedPanel:onClick_Button_drawOne(context)
	SoraDPlaySound()
	self:reqDrawCard(1)
end
function Activity_9001736_GetSeedPanel:onClick_Button_drawTen(context)
	SoraDPlaySound()
	self:reqDrawCard(10)
end
function Activity_9001736_GetSeedPanel:reqDrawCard(times)
	local selectIdx = self.fields.List:getSelectedIndex()
	local itemId = self.itemIdList[selectIdx + 1]
	if not itemId then
		SoraDShowMsgTip(i18n("football_match_text_065"))
		return
	end
	local itemCount = backpackCtrl:getItemCount(itemId)
	if times > itemCount then
		_ENV = i18n("football_match_text_065")
		i18n("football_match_text_065").itemId = itemId
		uiManager:show("Activity_9001736_SourceGuide", i18n("football_match_text_065"))
		return
	end
	activity_9001736_Ctrl:reqDrawCard(itemId, times)
end
function Activity_9001736_GetSeedPanel:onMsgUpdateItemCount(target, event)
	dump(event, "Activity_9001736_GetSeedPanel:onMsgUpdateItemCount")
	self.fields.List:setNumItems(#self.itemIdList)
end
function Activity_9001736_GetSeedPanel:showGetSeedShow()
	self.transitions.t_show:play()
end
function Activity_9001736_GetSeedPanel:showInShow()
	self.transitions.t_show:playReverse()
end
return Activity_9001736_GetSeedPanel
