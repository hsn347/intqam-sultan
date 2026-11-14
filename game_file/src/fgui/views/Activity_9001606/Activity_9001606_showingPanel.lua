local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001606_showingPanel = class("Activity_9001606_showingPanel", baseFguiPanel)
local activity_9001606_Ctrl = SoraDGetCtrl("activity_9001606_Ctrl")
function Activity_9001606_showingPanel:ctor(...)
	Activity_9001606_showingPanel.super.ctor(self, ...)
	print("Activity_9001606_showingPanel:ctor", self.viewName)
end
function Activity_9001606_showingPanel:onInit()
	print("=======Activity_9001606_showingPanel:onInit")
	self.view:fixChildrenPos()
	self.fields.Com_title:initData(i18n("CombineServers_1"), handler(self, self.onClickClose))
	self.fields.btn_rules:setTitle(i18n("CombineServers_8"))
	self.fields.btn_rules:addClickEventListener(function()
		SoraDPlaySound()
		uiManager:show("Activity_9001606_rule")
	end)
	self.fields.btn_rule2:setTitle(i18n("CombineServers_8"))
	self.fields.btn_rule2:addClickEventListener(function()
		SoraDPlaySound()
		uiManager:show("Activity_9001606_rule")
	end)
	self.fields.btn_unbind:setTitle(i18n("CombineServers_18"))
	self.fields.btn_unbind:addClickEventListener(handler(self, self.onUnBindClick))
	self.fields.Button_chat:setVisible(false)
	self.fields.Button_chat:addClickEventListener(handler(self, self.onChatClick))
	self.fields.Com_myTitle:setTitle(i18n("CombineServers_9"))
	self.fields.Com_otherTitle:setTitle(i18n("CombineServers_10"))
	self.fields.list:setVirtual()
	self.fields.list:setItemRenderer(handler(self, self.onItemRenderer))
	self.type = self.param and self.param.type or nil
	if self.type == "detail" then
		local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
		local eventTime = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.NORMAL_ACTIVITY_9001605)
		if eventTime then
			_ENV = handler(self, self.onItemRenderer)
			handler(self, self.onItemRenderer).time = ""
			self.fields.Com_title:initSpecialActivityTime(eventTime.timerNode.timer:getRemainTime(), i18n("CombineServers_7", handler(self, self.onItemRenderer)))
		end
		self.fields.text_tip1:setString(i18n("CombineServers_21"))
		self.fields.text_tip2:setString(i18n("CombineServers_21"))
		activity_9001606_Ctrl:reqBindInfo()
		self.controllers.c1:setSelectedIndex(1)
	else
		self.fields.Com_title:setTimeShow(false)
		self.controllers.c1:setSelectedIndex(2)
		activity_9001606_Ctrl:reqShow()
	end
end
function Activity_9001606_showingPanel:onShow()
	print("=======Activity_9001606_showingPanel:onShow")
end
function Activity_9001606_showingPanel:updateData(data)
	self.data = data
	if self.type == "detail" then
		if not self.data.mergeKingdomInfo then
			activity_9001606_Ctrl = self.data.mergeKingdomInfo
		end
		self.dataList = self.data.mergeKingdomInfo
		self.isMainKingdom = self.data.mainKingInfo and activity_9001606_Ctrl:getIsSelfKingdom(self.data.mainKingInfo.kid) or false
		if self.isMainKingdom then
			self.fields.Com_titleBg:setTitle(i18n("CombineServers_20") .. i18n("CombineServers_9"))
		else
			self.fields.Com_titleBg:setTitle(i18n("CombineServers_20") .. (self.data.mainKingInfo and i18n("CombineServers_10") or i18n("guide_text_168")))
		end
		self.fields.Com_mainKingdom:initData(self.data.mainKingInfo, true)
		self.fields.Com_mainKingdom:setUnBindVisible(self.type == "detail" and not self.isMainKingdom)
		self.controllers.c1:setSelectedIndex(#self.dataList > 0 and 0 or 1)
	else
		if not self.data.mergekingdomsInfo then
			activity_9001606_Ctrl = self.data.mergekingdomsInfo
		end
		self.dataList = self.data.mergekingdomsInfo
		self.isMainKingdom = false
		local kindomName = self:getKindomName()
		self.fields.Com_titleBg:setTitle(i18n("CombineServers_13") .. ":" .. kindomName)
		self.fields.Com_mainKingdom:initData(self.data.mainKingdomInfo)
		self.fields.Com_mainKingdom:setUnBindVisible(self.type == "detail" and not self.isMainKingdom)
		self.controllers.c1:setSelectedIndex(self.data.mainKingdomInfo == nil and 1 or 2)
	end
	local teamDef = include("teamDef")
	local teamAreaEnum = teamDef.teamAreaEnum
	local teamCtrl = SoraDGetCtrl("teamCtrl")
	self.teamInfo = teamCtrl:getTeamData(teamAreaEnum.MERGE_SERVER_SHOW)
	self.fields.Button_chat:setVisible(self.teamInfo:getChannelID() ~= 0)
	self.fields.Button_chat:setReddot(self.teamInfo:isHasNewTeamMsg())
	if #self.dataList ~= 0 then
		self.fields.list:setNumItems(#self.dataList)
	end
end
function Activity_9001606_showingPanel:getKindomName()
	local kindomName = ""
	if self.data.mainKingdomInfo and activity_9001606_Ctrl:getIsSelfKingdom(self.data.mainKingdomInfo.kid) then
		kindomName = (self.data.mainKingdomInfo.kingdomName == "" and i18n("common_text_479") or self.data.mainKingdomInfo.kingdomName) .. "#" .. self.data.mainKingdomInfo.kid
	else
		for i, v in ipairs(self.dataList) do
			if activity_9001606_Ctrl:getIsSelfKingdom(v.kid) then
				kindomName = (v.kingdomName == "" and i18n("common_text_479") or v.kingdomName) .. "#" .. v.kid
			end
		end
	end
	return kindomName
end
function Activity_9001606_showingPanel:updateNewTeamMsg()
	self.fields.Button_chat:setReddot(self.teamInfo:isHasNewTeamMsg())
end
function Activity_9001606_showingPanel:onItemRenderer(index, obj)
	local data = self.dataList[index + 1]
	obj:initData(data, self.type == "detail")
	obj.controllers.c2:setSelectedIndex(1)
	obj:setUnBindVisible(self.isMainKingdom)
end
function Activity_9001606_showingPanel:onUnBindClick()
	SoraDPlaySound()
	SoraDShowMsgBoxNew(i18n("CombineServers_40"), i18n("common_text_204"), i18n("common_text_185"), function(exitType, other)
		if exitType ~= MSGBOX_CALLBACK_YES then
			return
		end
		activity_9001606_Ctrl:reqUnbind(self.data.mainKingInfo.kid)
	end)
end
function Activity_9001606_showingPanel:onChatClick()
	SoraDPlaySound()
	local panel = SoraDCreatePanel("teamChatView")
	panel:init9001606ChatRoom()
	panel:show()
end
return Activity_9001606_showingPanel
