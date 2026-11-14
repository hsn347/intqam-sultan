local baseComponent = require("fgui.base.baseComponent")
local Com_DivineBeast_Test = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CastleChange/Com_DivineBeast_Test", Com_DivineBeast_Test)
function Com_DivineBeast_Test:onInit()
	self.fields.x:setString("X:")
	self.fields.y:setString("Y:")
	self.fields.ix:addEventListener(fgui.UIEventType.Changed, handler(self, self.onChanged))
	self.fields.iy:addEventListener(fgui.UIEventType.Changed, handler(self, self.onChanged))
end
function Com_DivineBeast_Test:onShow()
end
function Com_DivineBeast_Test:initTroop(troopsMatrix)
	self.troopsMatrix = troopsMatrix
	self.fields.ix:setText("0")
	self.fields.iy:setText("0")
	self.divineBeastNode = self.troopsMatrix.matrix._divineBeast
	if not self.divineBeastNode then
		return
	end
	self.oX = self.divineBeastNode:getPositionX()
	self.oY = self.divineBeastNode:getPositionY()
	self.fields.txt_Type:setString("方阵类型：" .. self.troopsMatrix.matrix:getMatrixType())
end
function Com_DivineBeast_Test:onChanged()
	local x = tonumber(self.fields.ix:getText()) or 0
	local y = tonumber(self.fields.iy:getText()) or 0
	if self.divineBeastNode then
		self.divineBeastNode:setSoldierPos(cc.p(self.oX + x, self.oY + y))
	end
end
return Com_DivineBeast_Test
