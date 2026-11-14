local buffCtrl = SoraDGetCtrl("buffCtrl")
local buffltCtrl = gModuleMgr.sharedMgr("buffltCtrl")
local buffDesRead = include("buffDesRead")
local eventLightShiningBuff = class("eventLightShiningBuff", function(target)
	if target == nil then
		return SoraDCreateBasePanel("eventLightShiningBuff")
	end
	return target
end)
function eventLightShiningBuff:ctor()
	self.Image_bg = SoraDGetChildByName(self, "Image_bg")
	self.Image_buff = SoraDGetChildByName(self, "Image_buff")
	self.Button_buff = SoraDGetChildByName(self, "Button_buff")
	self.Button_buff = include("commonBtnInstance").new(self.Button_buff)
	self.Node_effect = SoraDGetChildByName(self, "Node_effect")
	self.Text_time = SoraDGetChildByName(self, "Text_time")
	self.Text_time = SoraDCreateTimerLabel(self, self.Text_time)
end
function eventLightShiningBuff:setBuff(parent, buff)
	self.buff = buff
	self.buffType = buffltCtrl:getEffectType(self.buff)
	self.buffValue = buffltCtrl:getEffect(self.buff)
	self.Image_buff:setSpriteFrame(buffDesRead.getBuffIcon(self.buffType))
	self.Button_buff:setItemInfo(parent, self.buffType, self.buffValue, true)
end
function eventLightShiningBuff:runFadeInAct(time)
	self.Image_bg:setOpacity(0)
	self.Image_buff:setOpacity(0)
	self.Text_time:setOpacity(0)
	self.Image_bg:runAction(cca.fadeIn(time))
	self.Image_buff:runAction(cca.fadeIn(time))
	self.Text_time:runAction(cca.fadeIn(time))
end
function eventLightShiningBuff:isActive(ret)
	self.Image_buff:setColor(ret and cc.c3b(255, 255, 255) or cc.c3b(160, 160, 160))
	self.Image_bg:setColor(ret and cc.c3b(255, 255, 255) or cc.c3b(160, 160, 160))
	self.Node_effect:setVisible(ret or false)
	self.Text_time:setVisible(ret or false)
	if ret then
		local remainTime = buffCtrl:getRemainTimeByBuffID(self.buff)
		if remainTime then
			self.Text_time:beginTime(remainTime)
			self.Text_time:setTimeEndListener(function()
				self:isActive(false)
			end)
		end
	end
end
return eventLightShiningBuff
