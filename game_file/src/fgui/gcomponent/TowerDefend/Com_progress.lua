local baseComponent = require("fgui.base.baseComponent")
local Com_progress = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://TowerDefend/Com_progress", Com_progress)
function Com_progress:onInit()
	self.fields.bar:setFillAmount(0)
	self.fields.Ani_energy:setBlendFunc(gl.ONE, gl.ONE)
	self.fields.Ani_energy:setAllFrameName("dh_jinengyj01_%03d.png", 0)
	self.fields.Ani_energy:setPlaying(false)
end
function Com_progress:initData(curValue, totalValue)
	if totalValue < curValue then
		curValue = totalValue
		self.fields.Ani_energy:setVisible(true)
		self.fields.Ani_energy:setPlaying(true)
		self.fields.skillIcon:setGrayed(false)
	else
		self.fields.Ani_energy:setVisible(false)
		self.fields.Ani_energy:setPlaying(false)
		self.fields.skillIcon:setGrayed(true)
	end
	self.fields.Text_energy:setString(curValue .. "/" .. totalValue)
	self.fields.bar:setFillAmount(curValue / totalValue)
	self.fields.highlight:setRotation(curValue / totalValue * 360 + 90)
end
function Com_progress:onShow()
end
return Com_progress
