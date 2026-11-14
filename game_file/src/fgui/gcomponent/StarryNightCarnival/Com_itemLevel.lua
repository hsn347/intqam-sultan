local starryNightCarnivalCtrl = SoraDGetCtrl("starryNightCarnivalCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_itemLevel = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://StarryNightCarnival/Com_itemLevel", Com_itemLevel)
function Com_itemLevel:onInit()
	self.initedAni = false
	self:addClickListener(handler(self, self.onClickReward))
end
function Com_itemLevel:initData(index, data, levelState, hadGet, unlock, level, special)
	self.level = level
	self.unlock = unlock
	self.hadGet = hadGet
	self.levelState = levelState
	self.special = special
	self.fields.Com_item:initData(data.id, data.count)
	if unlock ~= nil and unlock == false then
		self.controllers.state:setSelectedIndex(0)
	elseif not levelState then
		self.controllers.state:setSelectedIndex(3)
	else
		self.controllers.state:setSelectedIndex(hadGet == true and 2 or 1)
		if not hadGet and not self.initedAni then
			self.initedAni = true
			self.fields.Ani_item:setAllFrameName("dh_chuanqijunwang_%02d.png", 1)
		end
	end
end
function Com_itemLevel:setState()
	self.controllers.state:setSelectedIndex(0)
	self:setTouchable(false)
end
function Com_itemLevel:onClickReward()
	if self.special then
		return
	end
	SoraDPlaySound()
	if self.hadGet then
		SoraDShowMsgTip(i18n("common_text_1892"))
		return
	end
	if self.unlock ~= nil and self.unlock == false then
		SoraDShowMsgTip(i18n("common_text_2274"))
	else
		if not self.levelState then
			SoraDShowMsgTip(i18n("PrideRebate_text_13"))
		else
		end
	end
end
function Com_itemLevel:onShow()
end
return Com_itemLevel
