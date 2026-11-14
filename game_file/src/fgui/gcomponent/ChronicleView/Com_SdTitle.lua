local kingdomLevelDataModuleAPI = include("kingdomLevelDataModuleAPI")
local gametop = gModuleMgr.getObject("gametop")
local legendMCtrl = gametop.playertop_:getModule("legendMCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_SdTitle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ChronicleView/Com_SdTitle", Com_SdTitle)
function Com_SdTitle:onInit()
end
function Com_SdTitle:onShow()
	local klv = kingdomLevelDataModuleAPI:getKingdomLevel()
	local strHistory = legendMCtrl:getHistoryYear(nil, true)
	kingdomLevelDataModuleAPI = nil
	;(nil).lv = klv
	self.fields.Text_sd_kingdom:setString(i18n("common_text_4434", nil))
	self.fields.Text_sd_year:setString(strHistory)
end
function Com_SdTitle:showTitleAnimation()
	self.fields.Text_sd_year:setAlpha(0)
	self.fields.Text_sd_kingdom:setAlpha(0)
	local fadeTime = 3.0
	_UPVALUE1_ = nil
	;(nil)[1] = ffa.delay(0.1)
	;(nil)[2] = ffa.fadeIn(fadeTime)
	;(nil)[3] = ffa.fadeIn(fadeTime)
	self.fields.Text_sd_kingdom:runAction(ffa.seq(nil))
	_UPVALUE1_ = ffa.seq(nil)
	ffa.seq(nil)[1] = ffa.delay(0.1)
	ffa.seq(nil)[2] = ffa.fadeIn(fadeTime)
	ffa.seq(nil)[3] = ffa.fadeIn(fadeTime)
	self.fields.Text_sd_year:runAction(ffa.seq(ffa.seq(nil)))
end
return Com_SdTitle
