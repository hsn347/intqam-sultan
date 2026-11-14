local preDownloadBall = class("preDownloadBall", function(target)
	if target == nil then
		return SoraDCreateBasePanel("preDownloadBall")
	end
	return target
end)
function preDownloadBall:ctor()
	SoraDCreatAnimation(self.__cname, self, true)
	self.percent = 0
	self.Text_percent = SoraDGetChildByName(self, "Text_percent")
	self.Sprite_water = SoraDGetChildByName(self, "Sprite_water")
	self.Panel_cut = SoraDGetChildByName(self, "Panel_cut")
end
function preDownloadBall:setPercent(percent)
	self.percent = percent
	self.Text_percent:setString(string.format("%0.2f%%", percent))
	local tmp_scaleX = 0
	local tmp_scaleY = 0
	if self.percent <= 50 then
		tmp_scaleX = -5 * (self.percent / 100) * (self.percent / 100) + 4.5 * (self.percent / 100)
		tmp_scaleY = tmp_scaleX
	else
		tmp_scaleX = 1 - (self.percent - 50) / 100 * ((self.percent - 50) / 100) * 2
		tmp_scaleY = 1 - (self.percent - 50) / 100 * ((self.percent - 50) / 100) * 4
	end
	local tmp_posY = 0.5 * self.percent
	self.Sprite_water:setScaleX(tmp_scaleX)
	self.Sprite_water:setScaleY(tmp_scaleY)
	self.Sprite_water:setPositionY(tmp_posY)
	self.Panel_cut:setContentSize(cc.size(70, tmp_posY + 7))
end
return preDownloadBall
