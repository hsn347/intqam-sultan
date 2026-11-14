local nebulaWonderlandCtrl = SoraDGetCtrl("nebulaWonderlandCtrl")
local baseComponent = require("fgui.base.baseComponent")
local com_planet = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://NebulaWonderland/com_planet", com_planet)
_ENV, com_planet.onInit = function(self)
	self.c1 = self.fields.Com_gift:getController("c1")
	self.c1:setSelectedIndex(0)
	self.fields.Com_gift:addClickListener(handler(self, self.onBtnClick))
end, function(self)
	self.c1 = self.fields.Com_gift:getController("c1")
	self.c1:setSelectedIndex(0)
	self.fields.Com_gift:addClickListener(handler(self, self.onBtnClick))
end
;(function(self)
	self.c1 = self.fields.Com_gift:getController("c1")
	self.c1:setSelectedIndex(0)
	self.fields.Com_gift:addClickListener(handler(self, self.onBtnClick))
end)[1] = 205
;(function(self)
	self.c1 = self.fields.Com_gift:getController("c1")
	self.c1:setSelectedIndex(0)
	self.fields.Com_gift:addClickListener(handler(self, self.onBtnClick))
end)[2] = 120
;(function(self)
	self.c1 = self.fields.Com_gift:getController("c1")
	self.c1:setSelectedIndex(0)
	self.fields.Com_gift:addClickListener(handler(self, self.onBtnClick))
end)[3] = 150
;(function(self)
	self.c1 = self.fields.Com_gift:getController("c1")
	self.c1:setSelectedIndex(0)
	self.fields.Com_gift:addClickListener(handler(self, self.onBtnClick))
end)[4] = 90
;(function(self)
	self.c1 = self.fields.Com_gift:getController("c1")
	self.c1:setSelectedIndex(0)
	self.fields.Com_gift:addClickListener(handler(self, self.onBtnClick))
end)[5] = 120
;(function(self)
	self.c1 = self.fields.Com_gift:getController("c1")
	self.c1:setSelectedIndex(0)
	self.fields.Com_gift:addClickListener(handler(self, self.onBtnClick))
end)[6] = 200
;(function(self)
	self.c1 = self.fields.Com_gift:getController("c1")
	self.c1:setSelectedIndex(0)
	self.fields.Com_gift:addClickListener(handler(self, self.onBtnClick))
end)[7] = 95
;(function(self)
	self.c1 = self.fields.Com_gift:getController("c1")
	self.c1:setSelectedIndex(0)
	self.fields.Com_gift:addClickListener(handler(self, self.onBtnClick))
end)[8] = 145
;(function(self)
	self.c1 = self.fields.Com_gift:getController("c1")
	self.c1:setSelectedIndex(0)
	self.fields.Com_gift:addClickListener(handler(self, self.onBtnClick))
end)[9] = 180
;(function(self)
	self.c1 = self.fields.Com_gift:getController("c1")
	self.c1:setSelectedIndex(0)
	self.fields.Com_gift:addClickListener(handler(self, self.onBtnClick))
end)[10] = 170
;(function(self)
	self.c1 = self.fields.Com_gift:getController("c1")
	self.c1:setSelectedIndex(0)
	self.fields.Com_gift:addClickListener(handler(self, self.onBtnClick))
end)[11] = 200
;(function(self)
	self.c1 = self.fields.Com_gift:getController("c1")
	self.c1:setSelectedIndex(0)
	self.fields.Com_gift:addClickListener(handler(self, self.onBtnClick))
end)[12] = 120
;(function(self)
	self.c1 = self.fields.Com_gift:getController("c1")
	self.c1:setSelectedIndex(0)
	self.fields.Com_gift:addClickListener(handler(self, self.onBtnClick))
end)[13] = 215
;(function(self)
	self.c1 = self.fields.Com_gift:getController("c1")
	self.c1:setSelectedIndex(0)
	self.fields.Com_gift:addClickListener(handler(self, self.onBtnClick))
end)[14] = 95
local (function(self)
	self.c1 = self.fields.Com_gift:getController("c1")
	self.c1:setSelectedIndex(0)
	self.fields.Com_gift:addClickListener(handler(self, self.onBtnClick))
end)[15], adjustOffset = 195, function(self)
	self.c1 = self.fields.Com_gift:getController("c1")
	self.c1:setSelectedIndex(0)
	self.fields.Com_gift:addClickListener(handler(self, self.onBtnClick))
end
function com_planet:initData(index, num)
	self.index = index
	self.num = num
	self.fields.title:setString(string.formatnumberthousands(num))
	if not self.first then
		self.first = true
		if self.num > nebulaWonderlandCtrl:getProgress() then
			self.c1:setSelectedIndex(0)
		elseif self.num <= nebulaWonderlandCtrl:getProgress() and not nebulaWonderlandCtrl:isInStageReward(index) then
			self.c1:setSelectedIndex(1)
		else
			self.c1:setSelectedIndex(2)
			self.fields.Com_gift:setGrayed(true)
			self.fields.Com_gift:setTouchable(false)
		end
		self.fields.title:setPositionY(self.fields.icon:getPositionY() + adjustOffset[index])
		if SoraDGetDefaultLanguage() == "ar" then
			self.fields.Com_gift:setPositionX(self.fields.title:getPositionX() + self.fields.title:getWidth() / 1)
		else
			self.fields.Com_gift:setPositionX(self.fields.title:getPositionX() - self.fields.Com_gift:getWidth())
		end
	end
end
function com_planet:setDynamicEffect(index)
	if self.num > nebulaWonderlandCtrl:getProgress() then
		self.c1:setSelectedIndex(0)
	elseif self.num <= nebulaWonderlandCtrl:getProgress() and not nebulaWonderlandCtrl:isInStageReward(index) then
		self.c1:setSelectedIndex(1)
		self.fields.Com_gift:setAlpha(0)
		self.fields.Com_gift:runAction(ffa.fadeIn(0.4))
	else
		self.c1:setSelectedIndex(2)
		self.fields.Com_gift:setGrayed(true)
		self.fields.Com_gift:setTouchable(false)
	end
end
function com_planet:onBtnClick()
	if self.num <= nebulaWonderlandCtrl:getProgress() and not nebulaWonderlandCtrl:isInStageReward(index) then
		nebulaWonderlandCtrl:sendScoreReward(self.index)
	end
end
function com_planet:onShow()
end
return com_planet
