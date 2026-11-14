local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
local roaringFlameWarRead = include("roaringFlameWarRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_MilepostItem = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RoaringFlame/Com_MilepostItem", Com_MilepostItem)
function Com_MilepostItem:onInit()
	self.fields.Text_unlockBuild:setString(i18n("flames_dunes_text60"))
	self.fields.Text_timeClaim:setString(i18n("flames_dunes_text59"))
	self.fields.Text_achiveClaim:setString(i18n("flames_dunes_text58"))
	self.fields.Text_claimed:setString(i18n("common_text_1892"))
	self.fields.Text_finish:setString(i18n("flames_dunes_text56"))
	self.fields.Text_none:setString(i18n("flames_dunes_text327"))
	self.fields.Text_none:setVisible(false)
	self.fields.Text_time:setTimeLast(function(time)
		_ENV = nil
		;(nil).time = time
		return i18n("flames_dunes_text55", nil)
	end)
	self.fields.Text_time:setTimeEndListener(function()
		self:initData(self.cfg)
	end)
	self.fields.Button_build:addClickListener(handler(self, self.btnUnlockClick))
	self.fields.Button_reward:setString(i18n("common_text_1146"))
	self.fields.Button_reward:addClickListener(handler(self, self.btnRewardClick))
	self.fields.List_time:setItemRenderer(handler(self, self.onTimeRenderer))
	self.fields.List_achive:setItemRenderer(handler(self, self.onAchiveRenderer))
	self:fixChildrenPos()
end
function Com_MilepostItem:onTimeRenderer(index, obj)
	obj:getChild("Com_item"):initData(self.cfg.time_reward[index + 1].id, self.cfg.time_reward[index + 1].count)
	obj:getController("c1"):setSelectedIndex(self.isClaimed and 1 or 0)
end
function Com_MilepostItem:onAchiveRenderer(index, obj)
	obj:getChild("Com_item"):initData(self.cfg.task_reward[index + 1].id, self.cfg.task_reward[index + 1].count)
	obj:getController("c1"):setSelectedIndex(self.isClaimed and self.status == 2 and 1 or 0)
end
function Com_MilepostItem:onShow()
end
function Com_MilepostItem:initData(cfg)
	self.cfg = cfg
	self.fields.Text_name:setString(i18n(cfg.name))
	local condition = cfg.task_cond[1]
	_ENV = i18n(cfg.name)
	i18n(cfg.name).num = condition.num
	i18n(cfg.name).lv = condition.lv
	i18n(cfg.name).city = roaringFlameWarRead.getBuildName(condition.type)
	self.fields.Text_des:setString(i18n(cfg.des, i18n(cfg.name)))
	self.fields.icon_build:setSpriteFrame(roaringFlameWarRead.getBuildImage(condition.type))
	local battleTime = roaringFlameWarCtrl:getStateBeginTime(ROARING_FLAME_WAR_STATE.BATTLE)
	self.status = 0
	local status, remainTime = roaringFlameWarRead.getDuneHistoryStatus(cfg.task_id)
	self.status = status
	if status == 0 then
		_ENV = roaringFlameWarRead.getBuildImage(condition.type)
		roaringFlameWarRead.getBuildImage(condition.type).time = SoraDConvertSecondToString(roaringFlameWarRead.getDuneHistoryLastTime(cfg.task_id))
		self.fields.Text_lastTime:setString(i18n("flames_dunes_text57", roaringFlameWarRead.getBuildImage(condition.type)))
	elseif status == 1 then
		self.fields.Text_time:beginTime(remainTime)
	elseif status == 2 then
		local progress = roaringFlameWarCtrl:getMileStoneProgress(cfg.task_id)
		self.status = progress >= condition.num and 2 or 3
		_ENV = i18n("flames_dunes_text57", roaringFlameWarRead.getBuildImage(condition.type))
		i18n("flames_dunes_text57", roaringFlameWarRead.getBuildImage(condition.type)).time = os.date("%Y/%m/%d", battleTime + cfg.end_time)
		self.fields.Text_doneDate:setString(i18n("flames_dunes_text54", i18n("flames_dunes_text57", roaringFlameWarRead.getBuildImage(condition.type))))
	end
	self.fields.Button_reward:setEnabled(1 < self.status)
	self.controllers.c1:setSelectedIndex(self.status)
	self.isClaimed = roaringFlameWarCtrl:isMileStoneRewarded(cfg.task_id)
	self.controllers.c2:setSelectedIndex(self.isClaimed and 1 or 0)
	self.fields.Button_reward:setReddot(1 < self.status and not self.isClaimed)
	self.fields.List_time:setNumItems(math.min(2, #self.cfg.time_reward))
	self.fields.List_achive:setNumItems(#self.cfg.task_reward)
	self.fields.Text_none:setVisible(#self.cfg.open_show == 0)
	self.fields.Button_build:setVisible(0 < #self.cfg.open_show)
end
function Com_MilepostItem:btnRewardClick()
	SoraDPlaySound()
	roaringFlameWarCtrl:reqMileStoneReward(self.cfg.task_id)
end
function Com_MilepostItem:btnUnlockClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).list = self.cfg.open_show
	uiManager:show("RoaringFlame_MileStoneUnlock", nil)
end
return Com_MilepostItem
