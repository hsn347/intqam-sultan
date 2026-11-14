local baseComponent = require("fgui.base.baseComponent")
local Com_FP_introduce = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ForeignPavilion/Com_FP_introduce", Com_FP_introduce)
local foreignPavilionRead = include("foreignPavilionRead")
local exoticPavilionCtrl = SoraDGetCtrl("exoticPavilionCtrl")
function Com_FP_introduce:onInit()
	self.fields.button_gift:addClickEventListener(handler(self, self.onGiftClick))
	self.maxLv = foreignPavilionRead:getMaxIntimacyLv()
end
function Com_FP_introduce:onShow()
end
function Com_FP_introduce:initData(cfg, idx)
	if not cfg then
		return
	end
	self.idx = idx
	self.giftId = cfg.rule
	local icon = fguiHelper.get_fields(self.fields.button_gift).icon
	icon:setURL("icon_ygg_shongli_0" .. idx .. ".png")
	self.fields.text_num:setString("+" .. cfg.point)
	local haveNum = exoticPavilionCtrl:getGiftNum(self.giftId)
	self.haveNum = haveNum
	_ENV = nil
	;(nil).num = haveNum
	self.fields.text_have:setString(i18n("common_text_531", nil))
end
function Com_FP_introduce:onGiftClick()
	SoraDPlaySound()
	local intimacyLv = exoticPavilionCtrl:getCurIntimacyLv()
	local intimacyValue = exoticPavilionCtrl:getCurIntimacyValue()
	local curIntimacyCfg = foreignPavilionRead:getCurIntimacyCfg(intimacyLv)
	self.overLv = intimacyValue >= curIntimacyCfg.value[2]
	if self.overLv then
		SoraDShowMsgTip(i18n("exitic_pavillion_text_0066"))
	elseif self.haveNum >= 1 then
		exoticPavilionCtrl:reqEpSendGiftToIncrIntimacy(self.giftId, self.idx, 1)
	else
		local publicRead = include("publicRead")
		_ENV = 1
		;(1).item = publicRead.getName(self.giftId)
		SoraDShowMsgTip(i18n("Glory_text_19", 1))
	end
end
return Com_FP_introduce
