local gametop = gModuleMgr.getObject("gametop")
local memberMgr = gametop.playertop_:getModule("memberMgr")
local allianceScience = gametop.playertop_:getModule("allianceScience")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local AllianceScienceInfoPanel = class("AllianceScienceInfoPanel", baseFguiPanel)
function AllianceScienceInfoPanel:ctor(...)
	self.super.ctor(self, ...)
	print("AllianceScienceInfoPanel:ctor", self.viewName)
end
function AllianceScienceInfoPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function AllianceScienceInfoPanel:onInit()
	print("=======AllianceScienceInfoPanel:onInit")
	_UPVALUE9_ = "=======AllianceScienceInfoPanel:onInit"
	;("=======AllianceScienceInfoPanel:onInit")[1] = "Text_des"
	;("=======AllianceScienceInfoPanel:onInit")[2] = "Text_cur"
	;("=======AllianceScienceInfoPanel:onInit")[3] = "Text_curValue"
	;("=======AllianceScienceInfoPanel:onInit")[4] = "Text_nextValue"
	;("=======AllianceScienceInfoPanel:onInit")[5] = "Text_next"
	;("=======AllianceScienceInfoPanel:onInit")[6] = "Label_science"
	;("=======AllianceScienceInfoPanel:onInit")[7] = "bar"
	;("=======AllianceScienceInfoPanel:onInit")[8] = "n7"
	;("=======AllianceScienceInfoPanel:onInit")[9] = "n14"
	for i, v in ipairs("=======AllianceScienceInfoPanel:onInit") do
		self.fields[v]:fixPos()
	end
	if not SoraDFIsRA() then
		self.fields.n14:setPositionX(self.fields.n14:getPositionX() + 4)
	end
	self.fields.bar:fixChildrenPos()
	self.fields.Text_notice:setString(i18n("common_text_281"))
	self.tableScienceData = self.proxy.param.data
	self.fields.Text_cur:setString(i18n("common_text_279"))
	self.fields.Text_next:setString(i18n("common_text_280"))
	self.fields.Button_recommend:setString(i18n("alliance_text_01"))
	self.fields.Button_recommend:addClickListener(handler(self, self.onClick_Button_Recommend))
	self.fields.List_star:setItemRenderer(handler(self, self.onItemStarRender))
	self.fields.Text_time:setTimeUpdateListener(handler(self, self.openTimeUp))
	for i = 1, 3 do
		self.fields["Com_Donate" .. i]:setDonateType(i)
		self.fields["Com_Donate" .. i]:setHandle(handler(self, self.donateBtnCallBack))
	end
end
function AllianceScienceInfoPanel:onShow()
	print("=======AllianceScienceInfoPanel:onShow")
	self:updateView()
end
function AllianceScienceInfoPanel:updateView()
	self:showPublic()
	if not self:showFull() then
		self:showDonate()
		self:updateQueue()
	end
end
function AllianceScienceInfoPanel:updateData()
	self.tableScienceData = allianceScience:getScienceData(self.tableScienceData.id)
	self:updateView()
	SoraDCloseLoading(self)
end
function AllianceScienceInfoPanel:showDonate()
	local allianceltCtrl = include("allianceltCtrl")
	local needPoint = allianceltCtrl.getSciStarLvUpNeedPoint(self.tableScienceData.id, self.tableScienceData.lv, self.tableScienceData.star + 1)
	if needPoint then
		self.fields.bar:getChild("Text_curPoint"):setString(string.formatnumberthousands(self.tableScienceData.point) .. "/" .. string.formatnumberthousands(needPoint))
		self.fields.bar:setMax(needPoint)
		self.fields.bar:setValue(self.tableScienceData.point)
	end
end
function AllianceScienceInfoPanel:showPublic()
	local allianceDesRead = include("allianceDesRead")
	local allianceltCtrl = include("allianceltCtrl")
	for i = 1, 3 do
		self.fields["Com_Donate" .. i]:initData(self.tableScienceData)
	end
	self.fields.Label_science:setIcon(allianceDesRead.getScienceIcon(self.tableScienceData.id))
	self.fields.Panel_bg:setString(allianceDesRead.getScienceName(self.tableScienceData.id))
	self.fields.Text_des:setString(allianceDesRead.getScienceDes(self.tableScienceData.id))
	local curdtype, curvalue = allianceltCtrl.getScienceValue(self.tableScienceData.id, self.tableScienceData.lv)
	local nextdtype, nextvalue = allianceltCtrl.getScienceValue(self.tableScienceData.id, self.tableScienceData.lv + 1)
	if curdtype and curdtype == 1 then
		curvalue = tostring(curvalue * 100) .. "%"
	end
	if nextdtype and nextdtype == 1 then
		nextvalue = tostring(nextvalue * 100) .. "%"
	end
	_ENV = allianceDesRead.getScienceDes(self.tableScienceData.id)
	allianceDesRead.getScienceDes(self.tableScienceData.id).level = self.tableScienceData.lv
	self.fields.Label_science:setString(i18n("common_text_420", allianceDesRead.getScienceDes(self.tableScienceData.id)))
	self.fields.Text_curValue:setString(curvalue)
	self.fields.Text_nextValue:setString(nextvalue)
	self.maxStar = allianceltCtrl.scienceAttr(self.tableScienceData.id, gAScienceInfo.MAXSTAR)
	self.fields.List_star:setNumItems(self.maxStar)
end
function AllianceScienceInfoPanel:updateQueue()
	self.isLock = memberMgr:getOwnMember():getProperty("donateLock") == 1
	self.queue = allianceScience:queryQueue(SCIENCE_DONATE_QUEUE)
	if self.queue then
		if self.isLock then
			self.fields.Text_time:setTitleColor(display.COLOR_RED)
		else
			self.fields.Text_time:setTitleColor(cc.c3b(105, 183, 232))
		end
		self.fields.Text_time:setVisible(true)
		local time = self.queue.timerNode.timer:getRemainTime()
		if 0 < time then
			self.fields.Text_time:beginTime(time)
		end
	else
		self.fields.Text_time:setVisible(false)
		self.fields.Text_time:endTimeNoCauseEndCallBack()
	end
	SoraDCloseLoading(self)
end
function AllianceScienceInfoPanel:openTimeUp(time)
	local leftTime = self.queue.timerNode.timer:getRemainTime()
	self.fields.Text_time:setString(SoraDConvertSecondToString(leftTime))
	if time <= 0 then
		self:updateQueue()
	end
end
function AllianceScienceInfoPanel:showFull()
	local allianceltCtrl = include("allianceltCtrl")
	local maxLv = allianceltCtrl.scienceAttr(self.tableScienceData.id, gAScienceInfo.MAXLV)
	local maxStar = allianceltCtrl.scienceAttr(self.tableScienceData.id, gAScienceInfo.MAXSTAR)
	local isFull = maxLv <= self.tableScienceData.lv or maxStar <= self.tableScienceData.star
	self.controllers.c1:setSelectedIndex(isFull and 1 or 0)
	self.fields.Text_next:setVisible(maxLv > self.tableScienceData.lv)
	self.fields.Text_nextValue:setVisible(maxLv > self.tableScienceData.lv)
	self.fields.List_star:setVisible(maxLv > self.tableScienceData.lv)
	if not isFull then
		self:updateRecommend()
	elseif maxLv <= self.tableScienceData.lv and not self.tableScienceData.isRecommended then
		self.fields.Button_recommend:setVisible(false)
	else
		self:updateRecommend()
	end
	return isFull
end
function AllianceScienceInfoPanel:updateRecommend()
	local gametop = gModuleMgr.getObject("gametop")
	local allianceScience = gametop.playertop_:getModule("allianceScience")
	local member = memberMgr:getOwnMember()
	local rank = member:getProperty("rank")
	local isShowRecommend = false
	if rank >= gAllianceRank.R4 then
		isShowRecommend = true
	end
	if isShowRecommend then
		self.fields.Button_recommend:setVisible(true)
		if self.tableScienceData.isRecommended then
			self.fields.Button_recommend:setString(i18n("alliance_text_03"))
		elseif #allianceScience:getRecommendList() < 2 then
			self.fields.Button_recommend:setString(i18n("alliance_text_01"))
		else
			self.fields.Button_recommend:setVisible(false)
			return
		end
	else
		self.fields.Button_recommend:setVisible(false)
		return
	end
end
function AllianceScienceInfoPanel:speedUpCallBack(type)
	if type == MSGBOX_CALLBACK_SPEEDUP then
		allianceScience:reqCleanDonateSciCD()
		SoraDShowLoading(self)
	end
end
function AllianceScienceInfoPanel:donateBtnCallBack(id, type)
	local gametop = gModuleMgr.getObject("gametop")
	local memberMgr = gametop.playertop_:getModule("memberMgr")
	local jointime = memberMgr:getOwnMember():getProperty("joinTime")
	local curtime = serviceFunctions.systemTime()
	local needtime = gConstValue.ALLIANCE_DONATE_NEE_JOIN_ALLIANCE_TIME
	if needtime > curtime - jointime then
		SoraDShowMsgTip(i18n("common_text_654"), nil, nil)
		return
	end
	if self.isLock and self.queue then
		_ENV = "common_text_656"
		;("common_text_656").speedUpName = i18n("common_text_655")
		;("common_text_656").isBySelf = false
		;("common_text_656").isAllianceTech = true
		local speedUpBox = SoraDShowSpeedUpBox(self.queue, handler(self, self.speedUpCallBack), i18n("common_text_656"), "common_text_656")
	elseif self.isLock == false then
		SoraDShowLoading(self)
		for i = 1, 3 do
			self.fields["Com_Donate" .. i]:btnStateChange(false, true)
		end
		allianceScience:reqDonateSci(id, type)
	end
end
function AllianceScienceInfoPanel:onClick_Button_Recommend()
	SoraDPlaySound()
	print("发起推荐请求:", self.tableScienceData.id)
	if self.tableScienceData.isRecommended then
		allianceScience:reqRemoveRecommendSci(self.tableScienceData.id)
	else
		allianceScience:reqAddRecommendSci(self.tableScienceData.id)
	end
	self:closePanel()
end
function AllianceScienceInfoPanel:onItemStarRender(index, target)
	local showType = 0
	if self.tableScienceData.star >= self.maxStar then
		showType = 3
	elseif index + 1 <= self.tableScienceData.star then
		showType = 1
	elseif index + 1 == self.tableScienceData.star + 1 then
		showType = 2
	end
	target:getController("c1"):setSelectedIndex(showType)
end
return AllianceScienceInfoPanel
