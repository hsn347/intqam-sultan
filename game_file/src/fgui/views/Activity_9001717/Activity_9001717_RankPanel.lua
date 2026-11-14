local activity_9001717_Read = include("activity_9001717_Read")
local activity_9001717_Ctrl = SoraDGetCtrl("activity_9001717_Ctrl")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001717_RankPanel = class("Activity_9001717_RankPanel", baseFguiPanel)
function Activity_9001717_RankPanel:ctor(...)
	self.isLRU = true
	Activity_9001717_RankPanel.super.ctor(self, ...)
	print("Activity_9001717_RankPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.FANTASY_LAND
end
function Activity_9001717_RankPanel:onInit()
	print("=======Activity_9001717_RankPanel:onInit")
	self.fields.Panel_bg:setString(i18n("Bubble_island_rebuild_text_11"))
	self.fields.Text_rank:setString(i18n("common_text_2193"))
	self.fields.Text_name:setString(i18n("common_text_264"))
	self.fields.Text_value:setString(i18n("Bubble_island_rebuild_text_12"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List:setVirtual()
	self.fields.Text_noData:setString(i18n("Celestial_defense_text_024"))
	self.fields.Com_ownRank:setVisible(false)
	self.fields.Text_rank:fixPos()
	self.fields.Text_name:fixPos()
	self.fields.Text_value:fixPos()
end
function Activity_9001717_RankPanel:endShow()
	print("=======Activity_9001717_RankPanel:endShow")
	activity_9001717_Ctrl:reqMemberScore()
end
function Activity_9001717_RankPanel:onItemRenderer(index, obj)
	local rank = index + 1
	local member = self.memberInfo[rank]
	self:updateRankSingle(obj, rank, member)
end
function Activity_9001717_RankPanel:updateRankSingle(obj, rank, member)
	local _fields = fguiHelper.get_fields(obj)
	_ENV = nil
	;(nil).rank = rank
	;(nil).uid = member.uid
	;(nil).name = member.nickName
	;(nil).iconID = member.headid
	;(nil).avatar = member.avatar
	;(nil).score = member.score
	;(nil).isOwnRank = obj == self.fields.Com_ownRank
	_fields.content:initData(nil)
end
function Activity_9001717_RankPanel:onMsgUpdateData(target, event)
	SoraDCloseLoading()
	local subMsg = event.subMsg
	local rspdata = event.rspdata
	if subMsg == "memberScore" then
		if not rspdata.memberInfo then
			_ENV = rspdata.memberInfo
		end
		self.memberInfo = rspdata.memberInfo
		self.fields.List:setNumItems(#self.memberInfo)
		self.fields.Text_noData:setVisible(#self.memberInfo <= 0)
		self.fields.Com_ownRank:setVisible(true)
		_ENV = self.fields.Com_ownRank.setVisible
		self.fields.Com_ownRank.setVisible.rank = 0
		self.fields.Com_ownRank.setVisible.uid = SoraDGetPlayerID()
		local self.fields.Com_ownRank.setVisible.nickName, myInfo = lordInfoCtrl:getNickName(), self.fields.Com_ownRank.setVisible
		for i, v in ipairs(self.memberInfo) do
			if v.uid == myInfo.uid then
				myInfo.rank = i
				myInfo.score = v.score
				break
			end
		end
		self:updateRankSingle(self.fields.Com_ownRank, myInfo.rank, myInfo)
	end
end
return Activity_9001717_RankPanel
