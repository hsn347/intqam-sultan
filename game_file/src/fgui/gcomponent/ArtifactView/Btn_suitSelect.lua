local baseComponent = require("fgui.base.baseComponent")
local Btn_suitSelect = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://ArtifactView/Btn_suitSelect", Btn_suitSelect)
function Btn_suitSelect:onInit()
end
function Btn_suitSelect:onShow()
end
function Btn_suitSelect:initData(data, myMode)
	self.data = data
	self.myMode = myMode
	self.fields.Image_icon:setURL(data.icon)
	self.fields.Text_name:setString(i18n(data.name))
	if data.isLock then
		self.fields.spriteLock:setVisible(true)
		_ENV = i18n(data.name)
		i18n(data.name).lv = 1
		self.fields.Text_lv:setString(i18n("common_text_100", i18n(data.name)))
		self.fields.Text_lv:setColor(cc.c3b(75, 75, 75))
		self.fields.Text_name:setColor(cc.c3b(75, 75, 75))
		self.fields.Image_icon:setGrayed(true)
	else
		self.fields.spriteLock:setVisible(false)
		_ENV = cc.c3b(75, 75, 75)
		cc.c3b(75, 75, 75).lv = data.info.level
		self.fields.Text_lv:setString(i18n("common_text_100", cc.c3b(75, 75, 75)))
	end
end
function Btn_suitSelect:buttonClickcheck()
	if self.data.isLock then
		SoraDShowMsgTip(i18n("artifact_text_28"))
	elseif self.myMode == gHeroSelectBannerStyle.dispatch and self.data.info.marchCount >= 1 and self.data.info.awakeStatus == ARMS_AWAKE_STATUS.STATUS_NORMAL then
		SoraDShowMsgTip(i18n("artifact_text_27"))
	else
		return true
	end
	return false
end
return Btn_suitSelect
