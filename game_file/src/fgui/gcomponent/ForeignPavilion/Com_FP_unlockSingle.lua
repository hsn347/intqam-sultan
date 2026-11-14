local baseComponent = require("fgui.base.baseComponent")
local Com_FP_unlockSingle = fgui.extension_class(fgui.GComponent, baseComponent)
local exoticPavilionCtrl = SoraDGetCtrl("exoticPavilionCtrl")
fgui.register_extension("ui://ForeignPavilion/Com_FP_unlockSingle", Com_FP_unlockSingle)
local foreignPavilionRead = include("foreignPavilionRead")
local color1 = cc.c3b(235, 185, 105)
local color2 = cc.c3b(195, 175, 125)
function Com_FP_unlockSingle:onInit()
	if not SoraDFIsRA() then
		self:fixChildrenPos(false, true)
	end
	self.maxLv = foreignPavilionRead:getMaxIntimacyLv()
	self.fields.btn_look:addClickEventListener(handler(self, self.openDress))
end
function Com_FP_unlockSingle:onShow()
end
function Com_FP_unlockSingle:initData(intimacyCfg, isCurIdx, idx)
	self.intimacyLv = exoticPavilionCtrl:getCurIntimacyLv()
	local intimacyLv = intimacyCfg.intimacy
	self.fields.text_name:setString(i18n("exitic_pavillion_text_00" .. 46 + intimacyLv))
	self.fields.text_value:setString(intimacyCfg.value[1] .. "-" .. intimacyCfg.value[2])
	exoticPavilionCtrl = intimacyCfg.value[2]
	intimacyCfg.value[2].var = i18n(intimacyCfg.clothesname)
	self.fields.text_att_1:setString(i18n("exitic_pavillion_text_0144", intimacyCfg.value[2]))
	self.fields.text_att_2:setString(i18n(intimacyCfg.boxdes))
	self.fields.text_att_3:setString(i18n(intimacyCfg.buffdes[1], intimacyCfg.buffdes))
	self.fields.lock:setVisible(intimacyLv > self.intimacyLv)
	self.fields.heart:setVisible(intimacyLv <= self.intimacyLv)
	if intimacyLv <= self.intimacyLv then
		local intimacyValue = exoticPavilionCtrl:getCurIntimacyValue()
		local curIntimacyCfg = foreignPavilionRead:getCurIntimacyCfg(intimacyLv)
		self.fields.heart:updateValue(intimacyLv >= self.maxLv and 100 or intimacyValue / curIntimacyCfg.value[2] * 100, false, false)
		local valueStr = intimacyValue / curIntimacyCfg.value[2] * 100
		valueStr = 100 < valueStr and 100 or valueStr
		self.fields.curValue:setString(intimacyLv >= self.maxLv and "MAX" or math.floor(valueStr) .. "%")
	end
	self.idx = idx
	self.fields.line:setVisible(idx ~= 3)
end
function Com_FP_unlockSingle:openDress()
	SoraDPlaySound()
	_ENV = nil
	;(nil).idx = self.idx + 1
	uiManager:show("ForeignPDress", nil)
	uiManager:close("ForeignPIntimacy")
end
return Com_FP_unlockSingle
