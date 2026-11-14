local baseComponent = require("fgui.base.baseComponent")
local Btn_needSingle = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://Activity_9001663/Btn_needSingle", Btn_needSingle)
fgui.register_extension("ui://Activity_9001692/Btn_needSingle", Btn_needSingle)
function Btn_needSingle:onInit()
	if self.fields.mv_pp then
		self.fields.mv_pp:setAllFrameName("shanguangpaopao_%.2d.png", 1)
	end
	self.fields.mv_m:setAllFrameName("9001663_guangshu_%.2d.png", 1)
	self.fields.mv_m:setVisible(false)
end
function Btn_needSingle:onShow()
end
function Btn_needSingle:setMAct(target)
	self.fields.mv_m:setVisible(true)
	local beginPoint = self:localToGlobal(cc.p(50, 54))
	local endPoint = target:localToGlobal(cc.p(-25, -75))
	local rotation = SoraDGetAngleByPos(beginPoint, endPoint) + 90
	self.fields.mv_m:setRotation(rotation)
	local dis = math.sqrt((beginPoint.y - endPoint.y) * (beginPoint.y - endPoint.y) + (beginPoint.x - endPoint.x) * (beginPoint.x - endPoint.x)) + 300
	self.fields.mv_m:setHeight(dis)
	self.fields.mv_m:setPlaySettings(0, -1, 1, -1, function()
		self.fields.mv_m:setVisible(false)
	end)
	target:setVisible(true)
	target:play()
end
function Btn_needSingle:initData(id, count, needNum)
	self.id = id
	self.fields.item:initData(self.id)
	_ENV = nil
	;(nil).num1 = fguiHelper.getColorString(count < needNum and "#BE2828" or "#F0E6D2", string.formatnumberthousands(count))
	;(nil).num2 = string.formatnumberthousands(needNum)
	self.fields.title:setString(i18n("Ramadan_League_text_18", nil))
end
return Btn_needSingle
