local allianceMgr = SoraDGetCtrl("allianceMgr")
local footballClothesCtrl = SoraDGetCtrl("footballClothesCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_box = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://JerseyActivity/Com_box", Com_box)
function Com_box:onInit()
	self.fields.Button_click:addClickListener(handler(self, self.onClickAward))
	self.fields.n17:runAction(ffa.repeatForever(ffa.rotateBy(1, 360)))
end
_ENV, Com_box.onShow = function(self)
end, function(self)
end
;(function(self)
end)[1] = cc.p(60, 50)
;(function(self)
end)[2] = cc.p(60, 51)
;(function(self)
end)[3] = cc.p(60, 46)
;(function(self)
end)[4] = cc.p(60, 44)
;(function(self)
end)[5] = cc.p(60, 46)
;(function(self)
end)[6] = cc.p(60, 33)
;(function(self)
end)[7] = cc.p(60, 33)
local (function(self)
end)[8], boxETPos = cc.p(60, 30), function(self)
end
function Com_box:initData(data, index, type)
	self.data = data
	self.type = type
	self.index = index
	self:setString(string.formatnumberthousands(self.data.num))
	self:updateItem()
end
function Com_box:updateItem()
	self.status = footballClothesCtrl:getStatusByTypeNum(self.type, self.data.num)
	print("status-Com_box", self.status, self.data.num)
	local strEnd = "closed"
	if self.status == gBtnTargetStatusDef.GET then
		strEnd = "open"
	elseif self.status == gBtnTargetStatusDef.GOT then
		strEnd = "FullyOpen"
	end
	print("status-Com_box", string.format("icon_lshs_common_%02d_%s.png", self.index, strEnd))
	self:setIcon(string.format("icon_lshs_common_%02d_%s.png", self.index, strEnd))
	if self.type == 2 and (footballClothesCtrl:isNewJoinAlliance() or not allianceMgr:hasJoinAlliance()) then
		self:setGrayed(true)
	else
		self:setGrayed(false)
	end
	self.controllers.c1:setSelectedIndex(self.status - 1)
	self.fields.Effect_et:setPosition(boxETPos[self.index])
end
function Com_box:onClickAward()
	SoraDPlaySound()
	if self.type == 2 and footballClothesCtrl:isNewJoinAlliance() then
		SoraDShowMsgTip(i18n("footballclothes_text_04"))
		return
	end
	_ENV = i18n("footballclothes_text_04")
	i18n("footballclothes_text_04").data = self.data
	i18n("footballclothes_text_04").status = self.status
	uiManager:show("jerseyReward", i18n("footballclothes_text_04"))
end
return Com_box
