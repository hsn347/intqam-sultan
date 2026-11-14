local gametop = gModuleMgr.getObject("gametop")
local activity_9001657_Ctrl = SoraDGetCtrl("activity_9001657_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001657_MergePanel = class("Activity_9001657_MergePanel", baseFguiPanel)
function Activity_9001657_MergePanel:ctor(...)
	Activity_9001657_MergePanel.super.ctor(self, ...)
	print("Activity_9001657_MergePanel:ctor", self.viewName)
	self.debug = true
	self.activityID = gActivityTimeActivityID.MERGE_SERVER_ACTIVITY
end
function Activity_9001657_MergePanel:onInit()
	print("=======Activity_9001657_MergePanel:onInit")
	self.fields.Com_title:initActivityData(self.activityID, handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Text_time:setString(i18n("kingdom_merger_text1"))
	self.fields.atlantisTimeNode:initActivityData(self.activityID)
	local kingdomID = gametop.playertop_:getKingdomID()
	_ENV = kingdomID
	kingdomID.color = "#FFD719"
	local var1 = SoraDWrapHtmlTagByStyle("#" .. kingdomID, kingdomID)
	_ENV = i18n("kingdom_merger_text1")
	i18n("kingdom_merger_text1").var1 = var1
	local kingStr = i18n("across_move_myKingdom_name", i18n("kingdom_merger_text1"))
	self.fields.Text_king:setString(kingStr)
	self.fields.Button_chat:setString(i18n("common_text_4673"))
	self.fields.Button_chat:addClickListener(handler(self, self.btnChatRoomClick))
	self.fields.Text_List:setString(i18n("across_kingdom_list_title"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List:setVirtual()
	self.fields.Text_tip:setString(i18n("kingdom_merger_text9"))
	if not SoraDFIsRA() then
		_UPVALUE3_ = self.fields.Text_tip
		self.fields.Text_tip[1] = self.fields.Button_chat
		self.fields.Text_tip[2] = self.fields.Image_king
		self.fields.Text_tip[3] = self.fields.Text_king
		for __, v in pairs(self.fields.Text_tip) do
			v:fixPos()
		end
	end
end
function Activity_9001657_MergePanel:onShow()
	print("=======Activity_9001657_MergePanel:onShow")
	activity_9001657_Ctrl:reqMoveInKingdomInfo()
	SoraDShowLoading(self)
end
function Activity_9001657_MergePanel:onClickHelp()
	SoraDPlaySound()
	activity_9001657_Ctrl:showFAQ()
end
function Activity_9001657_MergePanel:onItemRenderer(index, obj)
	local data = self.moveInKingdomInfo[index + 1]
	obj:initData(data)
end
function Activity_9001657_MergePanel:onMsgUpdateKingdomList(target, event)
	local subMsg = event.subMsg
	local errCode = event.errCode
	if errCode and errCode ~= gErrDef.Err_None then
		activity_9001657_Ctrl:reqMoveInKingdomInfo()
		SoraDShowLoading(self)
	else
		SoraDCloseLoading(self)
		self:updateKingdomList()
	end
end
function Activity_9001657_MergePanel:updateKingdomList()
	self.moveInKingdomInfo = activity_9001657_Ctrl:getMoveInKingdomInfo()
	self.fields.List:setNumItems(#self.moveInKingdomInfo)
end
function Activity_9001657_MergePanel:btnChatRoomClick()
	SoraDPlaySound()
	local enterChatRoom = function()
		if activity_9001657_Ctrl:getChannelID() ~= 0 then
			self:onMsgEnterChatRoom()
		else
			activity_9001657_Ctrl:reqEnterChatRoom()
			SoraDShowLoading(self)
		end
	end
	if activity_9001657_Ctrl:getIsEnterChatRoom() then
		enterChatRoom()
	else
		local constantRead = include("constantRead")
		local cost = constantRead.getConstValue("KOH_MIGRATE_ENTER_CHAT_ROOM_NEED_GOLD", 0)
		_ENV = nil
		;(nil).num = cost
		local showMsg = i18n("common_text_4674", nil)
		SoraDShowMsgBox(showMsg, i18n("common_text_204"), i18n("common_text_185"), function(exitType)
			if exitType == MSGBOX_CALLBACK_YES and SoraDEnoughGold(cost) then
				enterChatRoom()
			end
		end)
	end
end
function Activity_9001657_MergePanel:onMsgEnterChatRoom(...)
	SoraDCloseLoading(self)
	local panel = SoraDCreatePanel("teamChatView")
	panel:init9001657ChatRoom()
	panel:show()
end
return Activity_9001657_MergePanel
