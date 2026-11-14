local buffDesRead = include("buffDesRead")
local buffltCtrl = gModuleMgr.sharedMgr("buffltCtrl")
local sultansBackRebateUtil = include("sultansBackRebateUtil")
local AWARD_STATUES = sultansBackRebateUtil.AWARD_STATUES
local sultansBackRebateMainBuff = class("sultansBackRebateMainBuff", function(target)
	if target == nil then
		target = SoraDCreateBasePanel("sultansBackRebateMainBuff")
	end
	return target
end)
function sultansBackRebateMainBuff:ctor()
	self.nodeTime = SoraDGetChildByName(self, "Node_time")
	self.nodeUnactivite = SoraDGetChildByName(self, "Node_unactivite")
	self.textTime = SoraDGetChildByName(self, "text_time")
	self.textTime = SoraDCreateTimerLabel(self, self.textTime)
	self.textUnactiv = SoraDGetChildByName(self, "text_unactivite")
	self.textBuffName = SoraDGetChildByName(self, "Text_buff_name")
	self.textBuffValue = SoraDGetChildByName(self, "Text_buff_value")
	self.spBg = SoraDGetChildByName(self, "Image_bg")
	self.Image_buff = SoraDGetChildByName(self, "Icon_bg")
	self.nodeEffect = SoraDGetChildByName(self, "Node_effect")
	self.initEffect = false
end
function sultansBackRebateMainBuff:initData(info)
	self.info = info
	self.buff = info.buff
	self.buffType = buffltCtrl:getEffectType(self.buff)
	self.buffValue = buffltCtrl:getEffect(self.buff)
	local statues = sultansBackRebateUtil.getRoundStatues(self.info)
	local isGet = statues == AWARD_STATUES.AWARD_STATUES_GET
	self.spBg:setVisible(isGet)
	self.nodeTime:setVisible(isGet)
	self.nodeUnactivite:setVisible(not isGet)
	self.Image_buff:setSpriteFrame(sultansBackRebateUtil.getBuffImg(self.buff, not isGet))
	self.textBuffName:setColor(isGet and cc.c3b(255, 241, 176) or cc.c3b(184, 174, 156))
	self.textBuffValue:setFntFile(isGet and "fonts/font_hgflbuff_01.fnt" or "fonts/font_hgflbuff_02.fnt")
	self.textBuffName:setString(buffDesRead.getTitleBase(self.buffType))
	self.textBuffValue:setString(buffDesRead.getTitleValueWithValue(self.buffType, self.buffValue))
	if isGet then
		local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
		local eventTime = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.SULTAN_BACK_REBATE_ACTIVITY)
		if eventTime then
			self.textTime:beginTime(eventTime.timerNode.timer:getRemainTime())
		end
	else
		self.textUnactiv:setString(i18n("back_recharge_text09"))
	end
	if isGet then
		if not self.initEffect then
			SoraDCreatAnimation("sultansBackRebateMainBuff", self)
			self.initEffect = true
		end
		self.nodeEffect:setVisible(true)
	else
		self.nodeEffect:setVisible(false)
	end
end
return sultansBackRebateMainBuff
