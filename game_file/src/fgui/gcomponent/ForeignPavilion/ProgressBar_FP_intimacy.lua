local baseComponent = require("fgui.base.baseComponent")
local ProgressBar_FP_intimacy = fgui.extension_class(fgui.GProgressBar, baseComponent)
fgui.register_extension("ui://ForeignPavilion/ProgressBar_FP_intimacy", ProgressBar_FP_intimacy)
local exoticPavilionCtrl = SoraDGetCtrl("exoticPavilionCtrl")
local foreignPavilionRead = include("foreignPavilionRead")
function ProgressBar_FP_intimacy:onInit()
	if not SoraDFIsRA() then
		self:fixChildrenPos(false, true)
	end
	self.fields.btn_intimacy:addClickEventListener(handler(self, self.intimacyClick))
	self.maxLv = foreignPavilionRead:getMaxIntimacyLv()
end
function ProgressBar_FP_intimacy:onShow()
end
function ProgressBar_FP_intimacy:initData(isHideBtn)
	dump(isHideBtn, "isHideBtn")
	self.isHideBtn = isHideBtn
	local intimacyLv = exoticPavilionCtrl:getCurIntimacyLv()
	local intimacyValue = exoticPavilionCtrl:getCurIntimacyValue()
	local curIntimacyCfg = foreignPavilionRead:getCurIntimacyCfg(intimacyLv)
	self.isCanUp = intimacyValue >= curIntimacyCfg.value[2] and intimacyLv < self.maxLv
	_ENV = nil
	;(nil).var = i18n("exitic_pavillion_text_00" .. 46 + intimacyLv)
	self.fields.text_cur_name:setString(i18n("exitic_pavillion_text_0052", nil))
	local value2 = intimacyLv >= self.maxLv and "MAX" or intimacyValue .. "/" .. curIntimacyCfg.value[2]
	self.fields.text_cur_value:setString(value2)
	self:setValue(intimacyValue / curIntimacyCfg.value[2] * 100)
end
function ProgressBar_FP_intimacy:intimacyClick(sender, params)
	SoraDPlaySound()
	if self.isHideBtn then
		return
	end
	if not self.isCanUp then
		uiManager:show("ForeignPIntimacy")
	else
		exoticPavilionCtrl:reqEPUpgradeIntimacyLv()
	end
end
return ProgressBar_FP_intimacy
