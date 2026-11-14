local magicFlipCtrl = SoraDGetCtrl("magicFlipCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local MagicLampGainTenPanel = class("MagicLampGainTenPanel", baseFguiPanel)
function MagicLampGainTenPanel:ctor(...)
	self.super.ctor(self, ...)
	print("MagicLampGainTenPanel:ctor", self.viewName)
end
function MagicLampGainTenPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "Effect_baoxiang"
	end
	return self._packageList
end
function MagicLampGainTenPanel:onInit()
	print("=======MagicLampGainTenPanel:onInit")
	self.itemID = 860901
	_UPVALUE2_ = nil
	;(nil)[1] = "ar"
	;(nil)[2] = "en"
	local icon = SoraDGetImageNameByLang("frame_shmc_congratulation_%s.png", nil)
	self.fields.Load_title:setURL(icon)
	self.fields.Com_Have:initData(self.itemID)
	_ENV = nil
	;(nil).num = 1
	self.fields.Button_One:setString(i18n("magic_flip_5", nil))
	self.fields.Button_One:addClickListener(handler(self, self.onClickOne))
	_ENV = handler(self, self.onClickOne)
	handler(self, self.onClickOne).num = 10
	self.fields.Button_Ten:setString(i18n("magic_flip_5", handler(self, self.onClickOne)))
	self.fields.Button_Ten:addClickListener(handler(self, self.onClickTen))
	self.fields.List:setItemRenderer(handler(self, self.onItemRederer))
	self.fields.List:addClickListener(handler(self, self.onClickScroll))
	self.retRandomCards = self.proxy.param.retRandomCards
	self.fields.List:setNumItems(#self.retRandomCards)
end
function MagicLampGainTenPanel:onShow()
	print("=======MagicLampGainTenPanel:onShow")
	self:updateButton()
end
function MagicLampGainTenPanel:updateButton()
	self.fields.Button_One:setCost(self.itemID, 1)
	self.fields.Button_Ten:setCost(self.itemID, 10)
	self.fields.Com_Have:updateNum()
	self:showDouble(magicFlipCtrl:getIsDouble())
end
function MagicLampGainTenPanel:showDouble(isShow)
	self.controllers.c1:setSelectedIndex(isShow and 1 or 0)
end
function MagicLampGainTenPanel:onItemRederer(index, cell)
	cell:initData(index, self.retRandomCards[index + 1])
	_UPVALUE1_ = self.retRandomCards[index + 1]
	self.retRandomCards[index + 1][1] = ffa.delay(index * 6 / 60)
	self.retRandomCards[index + 1][2] = ffa.callFunc(function(...)
		self.fields.List:getScrollPane():setPercY((index + 1) / 10, true)
	end)
	self.retRandomCards[index + 1][3] = ffa.callFunc(function(...)
		self.fields.List:getScrollPane():setPercY((index + 1) / 10, true)
	end)
	self.fields.List:runAction(ffa.seq(self.retRandomCards[index + 1]))
end
function MagicLampGainTenPanel:onClickScroll()
	self.fields.List:stopAllActions()
end
function MagicLampGainTenPanel:onClickOne()
	SoraDPlaySound()
	if backpackCtrl:getItemCount(self.itemID) > 0 then
		magicFlipCtrl:reqMagicFlipOpenOne()
		self:close()
	else
		SoraDShowMsgTip(i18n("common_text_2512"))
	end
end
function MagicLampGainTenPanel:onClickTen()
	SoraDPlaySound()
	if backpackCtrl:getItemCount(self.itemID) > 0 then
		magicFlipCtrl:reqMagicFlipOpenTen()
		self:close()
	else
		SoraDShowMsgTip(i18n("common_text_2512"))
	end
end
return MagicLampGainTenPanel
