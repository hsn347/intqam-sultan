local activity_9001702_Read = include("activity_9001702_Read")
local activityTimeRead = include("activityTimeRead")
local activity_9001702_Ctrl = SoraDGetCtrl("activity_9001702_Ctrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_9001702_page1 = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001702/Com_9001702_page1", Com_9001702_page1)
function Com_9001702_page1:registerEvent()
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001702_UPDATE", handler(self, self.onMsgUpdate))
end
function Com_9001702_page1:onInit()
	self.activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001702
	self.itemMerge = activity_9001702_Read.getItemMerge()
	self.giftItemID = activity_9001702_Read.getGiftItemID()
	self.fields.Text_tip1:setString(i18n("Eidal_celebration_text_07"))
	self.fields.Com_item1:initData(self.giftItemID)
	local drawItemID = activity_9001702_Read.getDrawItemID()
	self.fields.Com_item2:initData(drawItemID)
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Button_merge:setString(i18n("btn_cooking"))
	self.fields.Button_merge:addClickListener(handler(self, self.onClickBtnMerge))
	self.fields.Button_send:setString(i18n("common_text_3644"))
	self.fields.Button_send:addClickListener(handler(self, self.onClickBtnSend))
	self.fields.Text_tip2:setString(i18n("Eidal_celebration_text_05"))
	if not SoraDFIsRA() then
		self.fields.Com_item1:fixPos()
		self.fields.arrow1:fixPos()
		self.fields.Com_item2:fixPos()
		self.fields.arrow2:fixPos()
		self.fields.List_reward:fixPos()
		self.fields.Button_merge:fixPos()
		self.fields.Button_send:fixPos()
		self.fields.arrow1:fix()
		self.fields.arrow2:fix()
	end
end
function Com_9001702_page1:switchTab()
	self.itemIDList = activityTimeRead.getActivityShowReward(self.activityID)
	self.fields.List_reward:setNumItems(#self.itemIDList)
	self.fields.Button_merge:setCostIcon(self.itemMerge.id)
	self:updateBtnMerge()
	self.fields.Button_send:setCostIcon(self.giftItemID)
	self:updateBtnSend()
end
function Com_9001702_page1:onItemRenderer(index, obj)
	local itemID = self.itemIDList[index + 1]
	obj:initData(itemID)
end
function Com_9001702_page1:onClickBtnMerge()
	SoraDPlaySound()
	uiManager:show("Activity_9001702_Merge")
end
function Com_9001702_page1:onClickBtnSend()
	SoraDPlaySound()
	if activity_9001702_Ctrl:checkItemCount(self.giftItemID, 1) then
		uiManager:show("Activity_9001702_Send")
	end
end
function Com_9001702_page1:updateBtnMerge()
	self.fields.Button_merge:updateCostNum(self.itemMerge.count, self.itemMerge.id)
end
function Com_9001702_page1:updateBtnSend()
	self.fields.Button_send:updateCostNum(1, self.giftItemID)
end
function Com_9001702_page1:onMsgUpdate(target, event)
	local subMsg = event.subMsg
	if subMsg == "itemCount" then
		if event.itemID == self.itemMerge.id then
			self:updateBtnMerge()
		elseif event.itemID == self.giftItemID then
			self:updateBtnSend()
		end
	end
end
return Com_9001702_page1
