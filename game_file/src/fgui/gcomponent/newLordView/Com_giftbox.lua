local guardianCtrl = SoraDGetCtrl("guardianCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_giftbox = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://newLordView/Com_giftbox", Com_giftbox)
function Com_giftbox:onInit()
	self.fields.Button_Box:addClickListener(handler(self, self.btnClickShowReward))
end
function Com_giftbox:onShow()
end
function Com_giftbox:initData(index)
	self.index = index
	self.controllers.c1:setSelectedIndex(index)
	self:isShowAct(index == 2)
	if index == 0 then
		self.fields.Text_BoxState:setString(i18n("protect_text_08"))
	elseif index == 1 then
		self.fields.Text_BoxState:setString(i18n("protect_text_09"))
	elseif index == 2 then
		self.fields.Text_BoxState:setString(i18n("common_text_1146"))
	end
end
function Com_giftbox:setParticle(ret)
	self.fields.Particle_1:setVisible(ret)
	self.fields.Particle_2:setVisible(ret)
end
function Com_giftbox:isShowAct(ret)
	self.fields.icon:stopAllActions()
	self.fields.icon:setRotation(0)
	self:setParticle(ret)
	if ret then
		_UPVALUE6_ = nil
		;(nil)[1] = ffa.rotateTo(0.25, 10)
		;(nil)[2] = ffa.rotateTo(0.21666666666666667, -10)
		;(nil)[3] = ffa.rotateTo(0.2, 8)
		;(nil)[4] = ffa.rotateTo(0.16666666666666666, -5)
		;(nil)[5] = ffa.rotateTo(0.15, 2)
		;(nil)[6] = ffa.rotateTo(0.15, 0)
		;(nil)[7] = ffa.delay(0.38333333333333336)
		;(nil)[8] = ffa.delay(0.38333333333333336)
		self.fields.icon:runAction(ffa.repeatForever(ffa.seq(nil)))
	end
end
function Com_giftbox:btnClickShowReward()
	SoraDPlaySound()
	if self.index == 2 then
		guardianCtrl:sendReqGetReward()
	else
		SoraDCreatePanel("guardianRewardView"):show()
	end
end
return Com_giftbox
