local baseComponent = require("fgui.base.baseComponent")
local Com_FP_intimacy = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ForeignPavilion/Com_FP_intimacy", Com_FP_intimacy)
local exoticPavilionCtrl = SoraDGetCtrl("exoticPavilionCtrl")
local foreignPavilionRead = include("foreignPavilionRead")
function Com_FP_intimacy:onInit()
	self.maxLv = foreignPavilionRead:getMaxIntimacyLv()
end
function Com_FP_intimacy:onShow()
end
function Com_FP_intimacy:updateData()
	local intimacyLv = exoticPavilionCtrl:getCurIntimacyLv()
	local intimacyValue = exoticPavilionCtrl:getCurIntimacyValue()
	local curIntimacyCfg = foreignPavilionRead:getCurIntimacyCfg(intimacyLv)
	self.isCanUp = intimacyValue >= curIntimacyCfg.value[2] and intimacyLv < self.maxLv
	exoticPavilionCtrl = nil
	;(nil).var = i18n("exitic_pavillion_text_00" .. 46 + intimacyLv)
	self.fields.text_cur_name:setString(i18n("exitic_pavillion_text_0052", nil))
	local value2 = intimacyLv >= self.maxLv and "" or intimacyValue .. "/" .. curIntimacyCfg.value[2]
	self.fields.text_cur_value:setString(value2)
	local valueStr = intimacyValue * 100 / curIntimacyCfg.value[2]
	valueStr = 100 < valueStr and 100 or valueStr
	self.fields.text_cur:setString(intimacyLv >= self.maxLv and "MAX" or math.floor(valueStr) .. "%")
	self.fields.heart:updateValue(intimacyLv >= self.maxLv and 100 or intimacyValue / curIntimacyCfg.value[2] * 100, true, self.isCanUp)
	return self.isCanUp
end
function Com_FP_intimacy:addHeartShow(callback, sender)
	self.fields.heart:addHeartShow(callback, sender)
end
return Com_FP_intimacy
