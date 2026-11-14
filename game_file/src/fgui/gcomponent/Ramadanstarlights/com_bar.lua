local snowmanCelebrationltCtrl = include("snowmanCelebrationltCtrl")
local snowmanCelebrationCtrl = SoraDGetCtrl("snowmanCelebrationCtrl")
local baseComponent = require("fgui.base.baseComponent")
local com_bar = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://Ramadanstarlights/com_bar", com_bar)
function com_bar:onInit()
	self:fixChildrenPos()
	self.fields.bar:fix(false)
	self:initSnowmanBar()
	self.fields.Button_reward:addClickListener(handler(self, self.onClickReward))
end
function com_bar:initSnowmanBar()
	self.fields.refer:fix(false)
	self.fields.bar_headPoint:fix(false)
	self.fields.Ani_busrtPoint:fix(false)
	self.fields.Usm_bg:setBlendFunc(gl.ONE, gl.ONE)
	self.fields.Ani_busrtPoint:setAllFrameName("dh_ghgd_jdtbd_%.2d.png", 1)
	self.fields.Ani_anlliancePoint:setAllFrameName("dh_ghgd_qzbd_%.2d.png", 1)
	self.lang = SoraDGetDefaultLanguage()
	local per = 1 - snowmanCelebrationCtrl:getCurScore() / snowmanCelebrationltCtrl.getNeedIntegral()
	self.fields.bar2:setWidth((self.fields.bg:getWidth() - 20) * per)
	self:updateHeadPointPos()
	if snowmanCelebrationCtrl:getCurScore() == 0 then
		self.fields.bar_headPoint:setVisible(false)
		self.fields.line:setVisible(false)
	end
end
function com_bar:alliancePointEffect()
	self.transitions.alliancePoint:play(1, 2)
end
function com_bar:setHandle(handle1)
	self.handleFunc = handle1
end
function com_bar:onClickReward()
	self.handleFunc()
end
function com_bar:setNum(curValue, needValue)
	local lang = SoraDGetDefaultLanguage()
	self.fields.Text_point:setString(curValue .. "/" .. needValue)
	self.fields.Label_reddot:initData(snowmanCelebrationCtrl:isHaveBoxReward(), snowmanCelebrationCtrl:getcanReceiveNum())
	self.fields.Usm_box:setVisible(snowmanCelebrationCtrl:getcanReceiveNum() > 0 and true or false)
end
function com_bar:setZeroState()
	self.fields.bar_headPoint:setVisible(false)
	self.fields.line:setVisible(false)
	self:setProcessBarWidth(1, 20)
	self.fields.Text_point:setString(i18n("lost_ruins_text_10"))
	self:updateBox()
end
function com_bar:updateBox()
	self.fields.Label_reddot:initData(snowmanCelebrationCtrl:isHaveBoxReward(), snowmanCelebrationCtrl:getcanReceiveNum())
	self.fields.Usm_box:setVisible(snowmanCelebrationCtrl:getcanReceiveNum() > 0 and true or false)
end
function com_bar:setProcessBarWidth(per, offset)
	offset = offset or 0
	self.fields.bar:setWidth((self.fields.bg:getWidth() - offset) * per)
end
function com_bar:setProcessBar2Width(per, offset)
	offset = offset or 0
	self.fields.bar2:setWidth((self.fields.bg:getWidth() - offset) * per)
	self.percent = per
	self.offset = offset
end
function com_bar:processEffet(handle)
	self.handle = handle
	local offset = 0
	if self.lang == "ar" then
		offset = self.fields.refer:getPositionX() - 5
	else
		offset = self.fields.refer:getPositionX() - 5
	end
	_UPVALUE1_ = nil
	;(nil)[1] = self.fields.bar_headPoint:getPositionX()
	;(nil)[2] = self.fields.bar_headPoint:getPositionY()
	;(nil)[3] = self.fields.bar_headPoint:getPositionY()
	self.transitions.bar_headPoint:setValue("head_pos_F", nil)
	_UPVALUE1_ = nil
	;(nil)[1] = offset
	;(nil)[2] = self.fields.bar_headPoint:getPositionY()
	;(nil)[3] = self.fields.bar_headPoint:getPositionY()
	self.transitions.bar_headPoint:setValue("head_pos_B", nil)
	self.transitions.bar_headPoint:setHook("head_pos_B", function()
		if self.handle then
			self.handle()
		end
		self.fields.bar_headPoint:setPositionX(offset)
		if snowmanCelebrationCtrl:getCurScore() == 0 then
			self.fields.bar_headPoint:setVisible(false)
			self.fields.line:setVisible(false)
		else
			self.fields.bar_headPoint:setVisible(true)
			self.fields.line:setVisible(true)
		end
	end)
	self.transitions.bar_headPoint:play()
end
function com_bar:updateHeadPointPos()
	self:setProcessBar2Width(1 - snowmanCelebrationCtrl:getCurScore() / snowmanCelebrationltCtrl.getNeedIntegral(), 20)
	local offset = 0
	if self.lang == "ar" then
		offset = self.fields.refer:getPositionX() - 5
	else
		offset = self.fields.refer:getPositionX() - 5
	end
	self.fields.bar_headPoint:setPositionX(offset)
	if snowmanCelebrationCtrl:getCurScore() == 0 then
		self.fields.bar_headPoint:setVisible(false)
		self.fields.line:setVisible(false)
	else
		self.fields.bar_headPoint:setVisible(true)
		self.fields.line:setVisible(true)
	end
end
function com_bar:onShow()
end
return com_bar
