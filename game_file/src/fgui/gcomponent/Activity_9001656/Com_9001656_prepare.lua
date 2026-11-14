local gametop = gModuleMgr.getObject("gametop")
local constantRead = include("constantRead")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_9001656_prepare = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001656/Com_9001656_prepare", Com_9001656_prepare)
function Com_9001656_prepare:onInit()
	self.timeLabel = SoraDCreateTimerLabel(self, self.fields.Text_time)
	self.fields.list_reward:setItemRenderer(handler(self, self.onItemRenderer))
end
function Com_9001656_prepare:onShow()
end
function Com_9001656_prepare:initData()
	self.fields.Usm_1:setVisible(true)
	_ENV = nil
	;(nil).num = gametop.playertop_:getKingdomID()
	self.fields.Text_desc:setString(i18n("warmongering_text3", nil))
	self.fields.txt_timeDes:setString(i18n("warmongering_text2"))
	local eventTime = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.PREPARE_FOR_WAR_ACTIVITY)
	if eventTime then
		self.timeLabel:beginTime(eventTime.timerNode.timer:getRemainTime())
	end
	self.fields.text_reward:setTitle(i18n("warmongering_text4"))
	self.fields.text_mail:setString(i18n("warmongering_text5"))
	_ENV = i18n("warmongering_text5")
	local rewradCfg = constantRead.getConstValueArray("WAR_PREPARTION_AREA_REWARD", i18n("warmongering_text5"))
	activityShowCtrl = i18n("warmongering_text5")
	i18n("warmongering_text5")[1] = "id"
	i18n("warmongering_text5")[2] = "num"
	self.rewards = serviceFunctions.tableFormat(rewradCfg, i18n("warmongering_text5"))
	self.fields.list_reward:setNumItems(#self.rewards)
end
function Com_9001656_prepare:onItemRenderer(index, obj)
	obj:initData(self.rewards[index + 1].id, self.rewards[index + 1].num)
end
return Com_9001656_prepare
