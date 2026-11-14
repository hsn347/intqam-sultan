local resDesRead = include("resDesRead")
local baseComponent = require("fgui.base.baseComponent")
local cityInfoSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CityInfoView/cityInfoSingle", cityInfoSingle)
function cityInfoSingle:onInit()
	self.resData, _ENV = nil, nil
	_ENV = nil
	;(nil).name = i18n("bulidDyf_title_1002")
	self.fields.Text_rice:setString(i18n("common_text_412", nil))
	self:addClickListener(handler(self, self.btnClick))
end
function cityInfoSingle:onShow()
end
function cityInfoSingle:initData(resitem)
	self.resData = resitem
	if self.resData.ricecost then
		self.controllers.c1:setSelectedIndex(1)
		self.fields.Text_ricecost:setString(tostring(string.formatnumberthousands(-self.resData.ricecost)))
	else
		self.controllers.c1:setSelectedIndex(0)
	end
	self.fields.Image_res:setSpriteFrame(resDesRead.getBIcon(self.resData.resid))
	self:setSelfLock(self.resData.islock)
	self:fixChildrenPos()
end
function cityInfoSingle:setSelfLock(bool)
	self.controllers.c2:setSelectedIndex(bool and 1 or 0)
	self:setTouchEnabled(not bool)
	local resName = resDesRead.getName(self.resData.resid)
	if not bool then
		resDesRead = nil
		;(nil).name = resName
		self.fields.Text_count:setString(i18n("common_text_411", nil))
		resDesRead = i18n("common_text_411", nil)
		i18n("common_text_411", nil).var = string.formatnumberthousands(self.resData.resper)
		self.fields.Text_perhour:setString(i18n("%{var}/h", i18n("common_text_411", nil)))
	else
		local unlockLv = resDesRead.getUnLockLevel(self.resData.resid)
		local isShowWarLv, textLv = SoraDGetBuildWarLv(unlockLv)
		if isShowWarLv then
			resDesRead = i18n("%{var}/h", i18n("common_text_411", nil))
			i18n("%{var}/h", i18n("common_text_411", nil)).level = textLv
			self.fields.Text_perhour:setString(i18n("common_text_4094", i18n("%{var}/h", i18n("common_text_411", nil))))
		else
			resDesRead = i18n("common_text_4094", i18n("%{var}/h", i18n("common_text_411", nil)))
			i18n("common_text_4094", i18n("%{var}/h", i18n("common_text_411", nil))).level = textLv
			self.fields.Text_perhour:setString(i18n("common_text_427", i18n("common_text_4094", i18n("%{var}/h", i18n("common_text_411", nil)))))
		end
		self.fields.Text_count:setString(resName)
	end
end
function cityInfoSingle:btnClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).resid = self.resData.resid
	uiManager:show("cityInfoResView", nil)
end
return cityInfoSingle
