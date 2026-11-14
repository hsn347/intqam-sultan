local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local roaringFlameWarRead = include("roaringFlameWarRead")
local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RoaringFlameActivity_MainPanel = class("RoaringFlameActivity_MainPanel", baseFguiPanel)
function RoaringFlameActivity_MainPanel:ctor(...)
	self.isLRU = true
	RoaringFlameActivity_MainPanel.super.ctor(self, ...)
	print("RoaringFlameActivity_MainPanel:ctor", self.viewName)
end
function RoaringFlameActivity_MainPanel:onInit()
	print("=======RoaringFlameActivity_MainPanel:onInit")
	self.fields.Com_title:initData(i18n("flames_dunes_text118"), handler(self, self.onClickClose))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function RoaringFlameActivity_MainPanel:endShow()
	print("=======RoaringFlameActivity_MainPanel:endShow")
	local showConfig = roaringFlameWarRead.getActivityShowConfig()
	_ENV, _ENV = nil, "=======RoaringFlameActivity_MainPanel:endShow"
	;(nil).activityName = roaringFlameWarRead.getActivityShowName(1)
	;(nil).activityBg = roaringFlameWarRead.getActivityShowBg(1)
	_ENV, ("=======RoaringFlameActivity_MainPanel:endShow")[1], (nil).rewards = nil, nil, roaringFlameWarRead.getActivityShowRewards(1)
	;(nil).activityName = roaringFlameWarRead.getActivityShowName(2)
	;(nil).activityBg = roaringFlameWarRead.getActivityShowBg(2)
	_ENV, ("=======RoaringFlameActivity_MainPanel:endShow")[2], (nil).rewards = nil, nil, roaringFlameWarRead.getActivityShowRewards(2)
	;(nil).activityName = roaringFlameWarRead.getActivityShowName(3)
	;(nil).activityBg = roaringFlameWarRead.getActivityShowBg(3)
	;("=======RoaringFlameActivity_MainPanel:endShow")[3], (nil).rewards = nil, roaringFlameWarRead.getActivityShowRewards(3)
	local config = "=======RoaringFlameActivity_MainPanel:endShow"
	self.activityConfig = config
	self:updateView()
	self.newsTag, _ENV = self.updateView, self.updateView
	roaringFlameWarCtrl:reqSetActivityNew()
	if self:checkIsBattleState() then
		roaringFlameWarCtrl:reqPhoenixList()
		roaringFlameWarCtrl:reqCampCaveList()
	end
end
function RoaringFlameActivity_MainPanel:updateView()
	self.fields.List:setNumItems(#self.activityConfig)
end
function RoaringFlameActivity_MainPanel:onItemRenderer(index, obj)
	local _fields = obj._fields
	if not _fields then
		obj._fields = fguiHelper.get_fields(obj)
		_fields = obj._fields
		_fields.touch:addClickListener(handler(self, self.onClickItem))
		obj:fixChildrenPos()
		_fields.n1:fix()
		_fields.n2:fix()
	end
	_fields.touch:setTag(index)
	local cfg = self.activityConfig[index + 1]
	_fields.Text_name:setString(cfg.activityName)
	_fields.Label_banner:setIcon(cfg.activityBg)
	if self:checkIsBattleState() then
		if index + 1 == 1 and roaringFlameWarCtrl:getPhoenixData() then
			local taskRedNum = roaringFlameWarCtrl:getPhoenixTaskRedNum()
			obj:setReddot(0 < taskRedNum, taskRedNum)
		end
		if index + 1 == 2 then
			local turntableNum = roaringFlameWarCtrl:getTurntableRewardNum()
			local isShow_zp, isShow_count = roaringFlameWarCtrl:isTurntableShowRed()
			obj:setReddot(0 < turntableNum or isShow_count)
		end
		if index + 1 == 3 then
			local isShow_cbd, isShow_count = roaringFlameWarCtrl:isTreasureCaveShowRed()
			local caveNum = roaringFlameWarCtrl:getCaveListNum()
			obj:setReddot(isShow_cbd and isShow_count or 0 < caveNum)
		end
	else
		obj:setReddot(false)
	end
	local activityID = gActivityTimeActivityID.ROARING_FLAME_WAR_ACTIVITY
	local beginTime = roaringFlameWarCtrl:getStateBeginTime(ROARING_FLAME_WAR_STATE.BATTLE)
	local endTime = roaringFlameWarCtrl:getStateBeginTime(ROARING_FLAME_WAR_STATE.SETTLE)
	local timeLast = os.date("!%Y/%m/%d", beginTime) .. "-" .. os.date("!%Y/%m/%d", endTime)
	_fields.Text_timeLast:setString(timeLast)
	_fields.touch:setAlpha(roaringFlameWarCtrl:getCurState() >= ROARING_FLAME_WAR_STATE.BATTLE and 0 or 0.55)
	if not cfg.rewards then
		local _ENV, rewards = cfg.rewards, cfg.rewards
	end
	_fields.List_reward:setItemRenderer(function(_index, _obj)
		local item = rewards[_index + 1]
		_obj:initData(item.id, item.count)
	end)
	_fields.List_reward:setNumItems(#rewards)
	_fields.Com_new:setVisible(false)
end
function RoaringFlameActivity_MainPanel:checkIsBattleState(isTip)
	local curState = roaringFlameWarCtrl:getCurState()
	local isEnable = curState == ROARING_FLAME_WAR_STATE.BATTLE
	if isTip and not isEnable then
		if curState < ROARING_FLAME_WAR_STATE.BATTLE then
			SoraDShowMsgTip(i18n("flames_dunes_text291"))
		elseif curState >= ROARING_FLAME_WAR_STATE.SETTLE then
			SoraDShowMsgTip(i18n("common_text_1859"))
		end
	end
	return isEnable
end
function RoaringFlameActivity_MainPanel:onClickItem(EventContext)
	SoraDPlaySound()
	local index = EventContext:getSender():getTag()
	if index == 0 then
		if self:checkIsBattleState(true) then
			uiManager:show("RoaringFlame_PhoenixMain")
		end
	elseif index == 1 then
		if self:checkIsBattleState(true) then
			uiManager:show("RoaringFlameTurntable_Main")
		end
	elseif index == 2 and self:checkIsBattleState(true) then
		uiManager:show("RoaringFlameTreasureCave_Main")
	end
	local activityId = index + 1
	if not self.newsTag[tostring(activityId)] then
		roaringFlameWarCtrl:reqSetActivityNew(activityId)
	end
end
function RoaringFlameActivity_MainPanel:onMsgUpdateActivityNew(target, event)
	if not event.rspdata.news then
		_ENV = event.rspdata.news
	end
	self.newsTag = event.rspdata.news
	for i = 1, #self.activityConfig do
		if self.newsTag[tostring(i)] then
			self:updateObjComNew(i - 1, false)
		else
			self:updateObjComNew(i - 1, true)
		end
	end
end
function RoaringFlameActivity_MainPanel:updateObjComNew(index, show)
	local obj = self.fields.List:getChildAt(index)
	local Com_new = obj:getChild("Com_new")
	Com_new:setVisible(show)
end
return RoaringFlameActivity_MainPanel
