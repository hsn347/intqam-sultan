local publicRead = include("publicRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_ransomBoard = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://HeroJail/Com_ransomBoard", Com_ransomBoard)
function Com_ransomBoard:onInit()
	self.fields.title:setString(i18n("prison_text_10"))
	self.fields.Label_1:fixPos()
end
function Com_ransomBoard:onShow()
end
function Com_ransomBoard:initData(resTbl)
	dump(resTbl, "resTbl")
	self.resTbl = resTbl
	self:initView()
end
function Com_ransomBoard:initView(...)
	if self.resTbl and next(self.resTbl) then
		self:setVisible(true)
		self.fields.Label_1:fixChildrenPos()
		self.fields.Label_1:setString(string.formatnumberthousands(self.resTbl.num))
		self.fields.Label_1:setIcon(publicRead.getSmallIcon(self.resTbl.id))
	else
		self:setVisible(false)
	end
end
return Com_ransomBoard
