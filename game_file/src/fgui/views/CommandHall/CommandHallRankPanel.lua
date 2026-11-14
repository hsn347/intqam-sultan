local gametop = gModuleMgr.getObject("gametop")
local commandHallCtrl = SoraDGetCtrl("commandHallCtrl")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local CommandHallRankPanel = class("CommandHallRankPanel", baseFguiPanel)
function CommandHallRankPanel:ctor(...)
	self.super.ctor(self, ...)
	print("CommandHallRankPanel:ctor", self.viewName)
	self.selfUid = gametop.playertop_:getPlayerID()
end
function CommandHallRankPanel:onInit()
	print("=======CommandHallRankPanel:onInit")
	self.fields.Com_title:initData(i18n("commandhall_text_95"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	local fields = fguiHelper.get_fields(self.fields.Com_rankTitle)
	fields.title1:setString(i18n("common_text_2193"))
	fields.title2:setString(i18n("hero_text_93"))
	fields.title3:setString(i18n("commandhall_text_97"))
	self.fields.List_rank:setItemRenderer(handler(self, self.onRankItemRenderer))
	self.fields.List_rank:setVirtual()
	self.fields.Text_noData:setString(i18n("herobattle_text_05"))
	if not SoraDFIsRA() then
		self.fields.Com_rankTitle:fixChildrenPos()
	end
end
function CommandHallRankPanel:onShow()
	print("=======CommandHallRankPanel:onShow")
	commandHallCtrl:reqGetRankInfo()
	SoraDShowLoading(self.view:displayObject())
end
function CommandHallRankPanel:onClickHelp()
	SoraDPlaySound()
	SoraDShowHelpMsgTip(i18n("commandhall_text_96"))
end
function CommandHallRankPanel:onRankItemRenderer(index, obj)
	local rank = index + 1
	local data = self.rankInfo[rank]
	self:refreshRankSingle(obj, rank, data)
end
function CommandHallRankPanel:refreshRankSingle(obj, rank, data)
	if not obj.fields then
		obj.fields = fguiHelper.get_fields(obj)
		obj.controllers = fguiHelper.get_controllers(obj)
		obj:fixChildrenPos()
		obj.fields.Load_bg:fix()
	end
	local isTop3 = 0 < rank and rank <= 3
	if isTop3 then
		obj.controllers.c1:setSelectedIndex(rank)
	else
		obj.controllers.c1:setSelectedIndex(0)
		if 0 < rank then
			obj.fields.Text_rank:setString(tostring(rank))
		else
			obj.fields.Text_rank:setString(i18n("herobattle_text_05"))
		end
	end
	if data.uid == self.selfUid then
		obj.controllers.c3:setSelectedIndex(1)
	else
		obj.controllers.c3:setSelectedIndex(0)
	end
	local Com_head = obj.fields.Com_head
	Com_head:setHeadSprite(data.iconID, data.avatar)
	Com_head:setPlayerID(data.uid)
	_ENV = data.uid
	data.uid.allianceAbb = data.allianceAbbr
	data.uid.nickName = data.nickName
	local nameStr = lordInfoCtrl:getSplitName(data.uid)
	obj.fields.Text_name:setString(nameStr)
	local maxArmyGroupID = data.maxArmyGroupID
	local hasData = maxArmyGroupID and maxArmyGroupID ~= 0
	obj.fields.Text_noData:setVisible(not hasData)
	obj.fields.Text_score:setVisible(hasData)
	obj.fields.Text_time:setVisible(hasData)
	if hasData then
		obj.fields.Text_score:setString(string.formatnumberthousands(maxArmyGroupID or 0))
		obj.fields.Text_time:setString(SoraDConvertSecondToString(data.costTime or 0))
	else
		obj.fields.Text_noData:setString(i18n("common_text_927"))
	end
end
function CommandHallRankPanel:onMsgUpdateRank(target, event)
	SoraDCloseLoading(self.view:displayObject())
	if not event.rspdata then
		local _ENV, rspdata = event.rspdata, event.rspdata
	end
	if not rspdata.selfInfo then
		local _ENV, selfInfo = rspdata.selfInfo, rspdata.selfInfo
	end
	local lordInfo = lordInfoCtrl:getLordInfo()
	_ENV = lordInfoCtrl
	lordInfoCtrl.nickName = lordInfo.base.nickName
	local lordInfoCtrl.allianceAbbr, data = lordInfo.abbr, lordInfoCtrl
	data.maxArmyGroupID = selfInfo.maxArmyGroupID
	data.costTime = selfInfo.costTime
	self:refreshRankSingle(self.fields.Com_ownRank, selfInfo.rank or 0, data)
	if not rspdata.rankInfo then
		_ENV = rspdata.rankInfo
	end
	self.rankInfo = rspdata.rankInfo
	self.fields.List_rank:setNumItems(#self.rankInfo)
	self.fields.Text_noData:setVisible(#self.rankInfo == 0)
end
return CommandHallRankPanel
