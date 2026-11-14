local baseComponent = require("fgui.base.baseComponent")
local marketResSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://marketView/marketResSingle", marketResSingle)
local ON_PERCENTAGE_CHANGED = 0
local resDesRead = include("resDesRead")
function marketResSingle:onInit()
	self.sliderControl, _ENV = nil, nil
	self.sliderHandl = nil
	self.finalWeight = 0
	self.panelLock = SoraDGetChildByName(self, "Com_lock")
	self.resSlider = SoraDGetChildByName(self, "Slider")
	self.txtCount = SoraDGetChildByName(self, "Text_count")
	self.imgResBar = SoraDGetChildByName(self, "Image_bagBg")
	self.spRes = SoraDGetChildByName(self, "Sprite_res")
	self.bottomLine = SoraDGetChildByName(self, "Com_lock")
	self.resSlider:addEventListener(fgui.UIEventType.Changed, handler(self, self.resSliderChange))
	self.panelLock:setTitle(i18n("common_text_577"))
	self:fixChildrenPos()
end
function marketResSingle:onShow()
end
function marketResSingle:setBottomLineVisible(isVisible)
end
function marketResSingle:setSliderCallBack(handl)
	self.sliderHandl = handl
end
function marketResSingle:initData(controlData, toEnable)
	self.sliderControl = controlData
	local resImg = resDesRead.getMIcon(self.sliderControl.resid)
	self.spRes:setSpriteFrame(resImg)
	self:meLock(not toEnable)
end
function marketResSingle:setCanMax(val)
	self.sliderControl.canMax = val
end
function marketResSingle:setMax(val)
	self.sliderControl.max = val
end
function marketResSingle:correctSlider()
	if self.sliderControl.max < self.sliderControl.canMax then
		self.sliderControl.canMax = self.sliderControl.max
	end
	if self.sliderControl.max > 0 then
		if self.resSlider:getValue() * self.sliderControl.max / 100 >= self.sliderControl.canMax then
			self.resSlider:setValue(self.sliderControl.canMax / self.sliderControl.max * 100)
		end
	else
		self.resSlider:setValue(0)
	end
	self.txtCount:setString(string.formatnumberthousands(math.floor(self.resSlider:getValue() * self.sliderControl.max / 100 / self.sliderControl.perWeight)))
	if self.resSlider:getValue() == math.floor(self.sliderControl.canMax / self.sliderControl.max * 100) then
		local finalCount = self.sliderControl.canMax
		self.txtCount:setString(string.formatnumberthousands(math.floor(finalCount / self.sliderControl.perWeight)))
		self.finalWeight = finalCount
	else
		self.finalWeight = math.floor(self.resSlider:getValue() * self.sliderControl.max / 100)
	end
	self.sliderHandl(false)
end
function marketResSingle:getWeight()
	return self.resSlider:getValue() * self.sliderControl.max / 100
end
function marketResSingle:getFinalWeight()
	return self.finalWeight
end
function marketResSingle:getFinalCount(...)
	return self.finalWeight / self.sliderControl.perWeight
end
function marketResSingle:getCount()
	return self.resSlider:getValue() * self.sliderControl.max / 100 / self.sliderControl.perWeight
end
function marketResSingle:resSliderChange(slider, eventType)
	if eventType == ON_PERCENTAGE_CHANGED then
		if self.sliderControl.max > 0 then
			if self.resSlider:getValue() * self.sliderControl.max / 100 >= self.sliderControl.canMax then
				self.resSlider:setValue(self.sliderControl.canMax / self.sliderControl.max * 100)
			end
		else
			self.resSlider:setValue(0)
		end
		self.finalWeight = math.floor(self.resSlider:getValue() * self.sliderControl.max / 100 / self.sliderControl.perWeight)
		self.txtCount:setString(string.formatnumberthousands(self.finalWeight))
		self.sliderHandl()
	end
end
function marketResSingle:meLock(boolean)
	self.panelLock:setVisible(boolean)
	self.panelLock:setSwallowTouches(not boolean)
	self.resSlider:setTouchEnabled(not boolean)
	if boolean then
		self.resSlider:setValue(0)
		self.txtCount:setString(0)
	end
end
return marketResSingle
