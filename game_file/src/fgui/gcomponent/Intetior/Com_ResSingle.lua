local ON_PERCENTAGE_CHANGED = 0
local resDesRead = include("resDesRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_ResSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Intetior/Com_ResSingle", Com_ResSingle)
function Com_ResSingle:onInit()
	self:fixChildrenPos()
	self.fields.Com_Slider:fixChildrenPos()
end
function Com_ResSingle:onShow()
end
function Com_ResSingle:initData(controlData, otherData)
	self.sliderControl = controlData
	local resImg = resDesRead.getMIcon(self.sliderControl.resid)
	self.fields.Icon:setSpriteFrame(resImg)
	self.fields.Text_name:setString(resDesRead.getName(self.sliderControl.resid))
	self.fields.Text_Max:setString(_p(tostring(self.sliderControl.max) .. "/"))
	resDesRead = _p(tostring(self.sliderControl.max) .. "/")
	_p(tostring(self.sliderControl.max) .. "/").maxValue = self.sliderControl.canMax
	_p(tostring(self.sliderControl.max) .. "/").minValue = 0
	_p(tostring(self.sliderControl.max) .. "/").curValue = 0
	self.fields.Com_Slider:initData(_p(tostring(self.sliderControl.max) .. "/"))
	self.fields.Com_Slider:setMinValue(0)
	self:meLock()
end
function Com_ResSingle:setSliderCallBack(handl)
	self.fields.Com_Slider:setSliderCallBack(handl)
end
function Com_ResSingle:meLock()
	local boolean = self.sliderControl.canMax <= 0
	self.controllers.c1:setSelectedIndex(boolean and 1 or 0)
	if boolean then
		self.fields.Com_Slider:setSliderCurValue(0)
		if 0 < self.sliderControl.count then
			self.fields.Text_lock:setString(i18n("parliament_text_127"))
		else
			self.fields.Text_lock:setString(i18n("hero_text_90"))
		end
	end
end
function Com_ResSingle:getChooseNum()
	return self.sliderControl.resid, self.fields.Com_Slider:getSliderCurValue()
end
return Com_ResSingle
