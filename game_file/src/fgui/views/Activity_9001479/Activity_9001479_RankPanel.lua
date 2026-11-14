local gametop = gModuleMgr.getObject("gametop")
local activity_9001479_Ctrl = SoraDGetCtrl("activity_9001479_Ctrl")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001479_RankPanel = class("Activity_9001479_RankPanel", baseFguiPanel)
function Activity_9001479_RankPanel:ctor(...)
	self.super.ctor(self, ...)
	print("Activity_9001479_RankPanel:ctor", self.viewName)
	self.iBegin = 1
	self.nCount = 10
	self.rankList, _ENV, self.hasMore = print, print, true
	self.showRound = self.proxy.param and self.proxy.param.showRound or activity_9001479_Ctrl:getCurRound()
	self.selfUid = gametop.playertop_:getPlayerID()
	self.selfCamp = activity_9001479_Ctrl:getSelfCampByRound(self.showRound)
end
function Activity_9001479_RankPanel:onInit()
	print("=======Activity_9001479_RankPanel:onInit")
	_ENV = nil
	;(nil).num = self.showRound
	local title = i18n("camp_integral_16", nil)
	self.fields.Com_title:initData(title, handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.Label_time = self.fields.Com_title:getLabelTime()
	self.Label_time:initSpecialTime(nil, "camp_integral_30")
	self.Label_time:setTimeEndListener(handler(self, self.timeEndListener))
	local fieldsTitle = fguiHelper.get_fields(self.fields.Com_rankTitle)
	fieldsTitle.Text_name:setString(i18n("common_text_264"))
	fieldsTitle.Text_score:setString(i18n("common_text_1764"))
	self.fields.List_rank:setItemRenderer(handler(self, self.onRankItemRenderer))
	self.fields.List_rank:setVirtual()
	self.fields.List_rank:addEventListener(fgui.UIEventType.PullUpRelease, handler(self, self.onPullUpRelease))
	self.fields.Text_noData:setString(i18n("herobattle_text_05"))
	if not SoraDFIsRA() then
		fieldsTitle.Text_name:fixPos()
		fieldsTitle.Text_score:fixPos()
	end
end
function Activity_9001479_RankPanel:onShow()
	print("=======Activity_9001479_RankPanel:onShow")
	self:req4Data()
	self:updateLabelTime()
end
function Activity_9001479_RankPanel:onClickHelp()
	SoraDPlaySound()
	SoraDShowHelpMsgTip(i18n("camp_integral_28"))
end
function Activity_9001479_RankPanel:req4Data()
	activity_9001479_Ctrl:reqRoundRank(self.showRound, self.iBegin, self.nCount)
	SoraDShowLoading(self:displayObject())
end
function Activity_9001479_RankPanel:onPullUpRelease(...)
	if self.hasMore then
		self:req4Data()
	end
end
function Activity_9001479_RankPanel:onRankItemRenderer(index, obj)
	local rank = index + 1
	local data = self.rankList[rank]
	self:refreshRankSingle(obj, rank, data)
end
function Activity_9001479_RankPanel:refreshRankSingle(obj, rank, data)
	if not obj.fields then
		obj.fields = fguiHelper.get_fields(obj)
		obj.controllers = fguiHelper.get_controllers(obj)
		obj:fixChildrenPos()
	end
	local isTop3 = 0 < rank and rank <= 3
	if isTop3 then
		obj.controllers.c_rank:setSelectedIndex(rank - 1)
	else
		obj.controllers.c_rank:setSelectedIndex(3)
		if 0 < rank then
			obj.fields.Text_rank:setString(tostring(rank))
		else
			obj.fields.Text_rank:setString(i18n("herobattle_text_05"))
		end
	end
	if obj == self.fields.Com_ownRank then
		obj.controllers.c_type:setSelectedIndex(0)
	else
		if isTop3 or rank % 2 == 1 then
			obj.controllers.c_type:setSelectedIndex(1)
		else
			obj.controllers.c_type:setSelectedIndex(0)
		end
		if data and data.uid == self.selfUid then
			obj.controllers.c_type:setSelectedIndex(1)
			obj.fields.Iamge_black:setColor(cc.c3b(52, 45, 42))
		end
	end
	if not data then
		data, _ENV = obj.fields.Iamge_black.setColor, obj.fields.Iamge_black.setColor
	end
	local Com_head = obj.fields.Com_head
	Com_head:setHeadSprite(data.headid or 0, data.avatar or 0)
	Com_head:setPlayerID(data.uid or 0)
	_ENV = cc.c3b(52, 45, 42)
	cc.c3b(52, 45, 42).kingdomName = data.nickName or ""
	cc.c3b(52, 45, 42).kid = data.kid or 0
	obj.fields.Text_name:setString(i18n("Nebula_Competition_text_06", cc.c3b(52, 45, 42)))
	obj.fields.Text_score:setString(string.formatnumberthousands(data.score or 0))
end
function Activity_9001479_RankPanel:onMsgUpdateRank(target, event)
	SoraDCloseLoading(self:displayObject())
	if not event.rspdata then
		local _ENV, rspdata = event.rspdata, event.rspdata
	end
	if self.iBegin == 1 then
		if not rspdata.myInfo then
			local _ENV, myInfo = rspdata.myInfo, rspdata.myInfo
		end
		local lordInfo = lordInfoCtrl:getLordInfo()
		_ENV = lordInfoCtrl
		lordInfoCtrl.nickName = lordInfo.base.nickName
		local lordInfoCtrl.kid, data = gametop.playertop_:getKingdomID(), lordInfoCtrl
		if myInfo then
			data.score = myInfo.score or 0
		end
		self:refreshRankSingle(self.fields.Com_ownRank, myInfo.rank or 0, data)
	end
	if not rspdata.rank then
		local _ENV, rankList = rspdata.rank, rspdata.rank
	end
	table.insertto(self.rankList, rankList)
	local addCount = #rankList
	self.iBegin = self.iBegin + addCount
	if addCount < self.nCount then
		self.hasMore = false
	end
	self.fields.List_rank:setNumItems(#self.rankList)
	self.fields.Text_noData:setVisible(#self.rankList == 0)
end
function Activity_9001479_RankPanel:timeEndListener(...)
	self.fields.List_rank:jumpToTop()
	self.rankList, _UPVALUE0_, self.iBegin = self.fields.List_rank.jumpToTop, self.fields.List_rank.jumpToTop, 1
	self:req4Data()
	self:updateLabelTime()
end
function Activity_9001479_RankPanel:updateLabelTime(...)
	local curTime = serviceFunctions.systemTime()
	local m, s = os.date("!%M"), os.date("!%S")
	local remain = 600 - (m % 10 * 60 + s) + 2
	if 0 < remain then
		self.Label_time:beginTime(remain)
	end
end
return Activity_9001479_RankPanel
