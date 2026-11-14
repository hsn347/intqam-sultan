local mailWrathBeastTitle = class("mailWrathBeastTitle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("mailWrathBeastTitle")
	end
	return target
end)
function mailWrathBeastTitle:ctor()
	self:setCascadeOpacityEnabled(true)
	self.layout_content = SoraDGetChildByName(self, "layout_content")
	local itemSize = self.layout_content:getContentSize()
	self:setContentSize(cc.size(640, itemSize.height))
	if self.layout_content then
		self.layout_content:setSwallowTouches(false)
		self.layout_content:setPositionX((640 - itemSize.width) / 2)
	end
	self.Image_bg = SoraDGetChildByName(self, "Image_bg")
	self.LoadingBar = SoraDGetChildByName(self, "LoadingBar_1")
	self.Text_num = SoraDGetChildByName(self, "Text_num")
end
function mailWrathBeastTitle:initWithData(data)
	local content = data.content
	local lifeNum = content.lifeNum
	local leftLife = content.leftLife
	local lastHP = content.lastHP
	local normalHP = content.normalHP
	local percent = 1
	if leftLife <= lastHP then
		percent = leftLife / lastHP * 100
	else
		leftLife = leftLife - lastHP - (lifeNum - 2) * normalHP
		percent = leftLife / normalHP * 100
	end
	self.Text_num:setString(SoraDFValueSuit("x", lifeNum))
	self.LoadingBar:setPercent(percent)
end
return mailWrathBeastTitle
