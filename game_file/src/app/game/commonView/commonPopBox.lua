local commonPopBox = class("commonPopBox", function(target)
	if target == nil then
		return SoraDCreateBasePanel("commonPopBox")
	end
	return target
end)
function commonPopBox:ctor()
	if G_IS_UNITY then
		local ___proj = SoraDGetChildByName(self, "___proj") or self
		self.Panel_cut = SoraDGetChildByName(___proj, "Panel_cut")
		self.Image_pop = SoraDGetChildByName(___proj, "Image_pop")
		self.Image_pop2 = SoraDGetChildByName(___proj, "Image_pop2")
		self.Text_name = SoraDGetChildByName(___proj, "Text_name")
	else
		self.Panel_cut = SoraDGetChildByName(self, "Panel_cut")
		self.Image_pop = SoraDGetChildByName(self, "Image_pop")
		self.Image_pop2 = SoraDGetChildByName(self, "Image_pop2")
		self.Text_name = SoraDGetChildByName(self, "Text_name")
	end
	self.Image_pop:setVisible(true)
	self.Image_pop2:setVisible(false)
	self:setSize(self:getContentSize())
end
function commonPopBox:setSize(size)
	self.Panel_cut:setContentSize(size)
	self.Panel_cut:setPosition(cc.p(size.width / 2, size.height / 2))
	local panel_size = self.Panel_cut:getContentSize()
	self.Image_pop:setContentSize(cc.size(panel_size.width, panel_size.height + 16))
	self.Image_pop2:setContentSize(cc.size(panel_size.width, panel_size.height + 18))
	self.Image_pop:setPosition(cc.p(panel_size.width / 2, panel_size.height / 2))
	self.Image_pop2:setPosition(cc.p(panel_size.width / 2, panel_size.height / 2))
	self.Text_name:setPosition(cc.p(panel_size.width / 2, panel_size.height - 28))
end
function commonPopBox:getSize()
	return self.Panel_cut:getContentSize()
end
function commonPopBox:setTitleName(name, color)
	self.Text_name:setTextAreaSize(cc.size(self:getContentSize().width - 20, 30))
	self.Text_name:setString(name)
	if color then
		self.Text_name:setColor(color)
	end
end
function commonPopBox:setTitleBg(png)
end
function commonPopBox:hideTitle()
	self.Text_name:setVisible(false)
	self.Image_pop:setVisible(false)
	self.Image_pop2:setVisible(true)
end
function commonPopBox:showTitle(title)
	self.Text_name:setVisible(true)
	self:setTitleName(title)
	self.Image_pop:setVisible(true)
	self.Image_pop2:setVisible(false)
end
function commonPopBox:setTitleSize(size)
	SoraDSetTextWidthHeight(self.Text_name, size)
end
function commonPopBox:getTitleContentSize()
	return self.Text_name:getContentSize()
end
function commonPopBox:setPanelTouchListener(handle)
	self.Panel_cut:addTouchEventListener(handle)
end
return commonPopBox
