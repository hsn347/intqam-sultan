local snowyNightCarnivalCtrl = SoraDGetCtrl("snowyNightCarnivalCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_itemLevel = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://Activity2112/Com_itemLevel", Com_itemLevel)
function Com_itemLevel:onInit()
	if self.fields.Icon_lock_1 then
		self.fields.Icon_lock_1:fix(false)
	end
	self:addClickListener(handler(self, self.onClickReward))
	self.fields.Ani_itemSnow:setAllFrameName("dh_Tex_XL_xykh01_%03d.png", 0)
	self.fields.Ani_itemSnow:setBlendFunc(gl.ONE, gl.ONE)
end
function Com_itemLevel:initData(index, data, levelState, hadGet, unlock, level)
	self.level = level
	self.unlock = unlock
	self.hadGet = hadGet
	self.levelState = levelState
	self.fields.Com_item:initData(data.id, data.count)
	if unlock ~= nil and unlock == false then
		self.controllers.state:setSelectedIndex(0)
	elseif not levelState then
		self.controllers.state:setSelectedIndex(0)
	else
		self.controllers.state:setSelectedIndex(hadGet == true and 2 or 1)
	end
end
function Com_itemLevel:onClickReward()
	SoraDPlaySound()
	if self.hadGet then
		SoraDShowMsgTip(i18n("common_text_1892"))
		return
	end
	if self.unlock ~= nil and self.unlock == false then
		SoraDShowMsgTip(i18n("common_text_2274"))
	elseif not self.levelState then
		SoraDShowMsgTip(i18n("PrideRebate_text_13"))
	else
		snowyNightCarnivalCtrl:sendGetRewardByLevelMsg(self.level)
	end
end
function Com_itemLevel:onShow()
end
return Com_itemLevel
