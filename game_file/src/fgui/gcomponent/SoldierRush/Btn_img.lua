local soldierRushRead = include("soldierRushRead")
local soldierRushCtrl = SoraDGetCtrl("soldierRushCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Btn_img = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://SoldierRush/Btn_img1", Btn_img)
fgui.register_extension("ui://SoldierRush/Btn_img2", Btn_img)
fgui.register_extension("ui://SoldierRush/Btn_img3", Btn_img)
fgui.register_extension("ui://SoldierRush/Btn_img4", Btn_img)
fgui.register_extension("ui://SoldierRush/Btn_img5", Btn_img)
fgui.register_extension("ui://SoldierRush/Btn_img6", Btn_img)
fgui.register_extension("ui://SoldierRush/Btn_img7", Btn_img)
fgui.register_extension("ui://SoldierRush/Btn_img8", Btn_img)
fgui.register_extension("ui://SoldierRush/Btn_img9", Btn_img)
fgui.register_extension("ui://SoldierRush/Btn_img10", Btn_img)
function Btn_img:onInit()
end
function Btn_img:onShow()
end
function Btn_img:setShowModel(model, chapter)
	self.chapter = chapter
	self:setGateAndPath(model == 1)
	self:setGate()
	self:setPath()
end
function Btn_img:setGateAndPath(isVisible)
	for k, v in ipairs(self:getChildren()) do
		if string.find(v:getName(), "g%d+") or string.find(v:getName(), "p%d+") then
			v:setVisible(isVisible)
		end
	end
end
function Btn_img:setGate()
	for k, v in ipairs(self:getChildren()) do
		if string.find(v:getName(), "g%d+") then
			local gate = string.gsub(v:getName(), "g", "")
			v:initData(self.chapter, gate)
		end
	end
end
function Btn_img:setPath()
	local curGate = soldierRushCtrl:getToGateIndex()
	local toIndex = soldierRushRead.getPathRange(curGate)
	for k, v in ipairs(self:getChildren()) do
		if string.find(v:getName(), "p%d+") then
			local pIndex = string.gsub(v:getName(), "p", "")
			v:setPath(toIndex >= tonumber(pIndex))
		end
	end
end
function Btn_img:getGate(id)
	return self.fields["g" .. id]
end
return Btn_img
