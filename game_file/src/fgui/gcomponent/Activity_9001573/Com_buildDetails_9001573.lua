local baseComponent = require("fgui.base.baseComponent")
local Com_buildDetails_9001573 = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001573/Com_buildDetails_9001573", Com_buildDetails_9001573)
function Com_buildDetails_9001573:onInit()
	self.fields.Text_jump:addEventListener(fgui.UIEventType.Click, handler(self, self.onJumpClick))
end
function Com_buildDetails_9001573:onShow()
end
function Com_buildDetails_9001573:initData(data)
	dump(data.data, "Com_buildDetails_9001573:initData")
	self.fields.Sprite_build:setURL(data.cfg.buildPic or "")
	if data.data == nil or next(data.data) == nil then
		self.fields.Text_des:setString(i18n("Celestial_defense_text_051"))
		self.fields.Text_jump:setVisible(false)
		self.fields.line:setVisible(false)
		self.fields.Sprite_build:setGrayed(true)
	else
		self.fields.Sprite_build:setGrayed(false)
		self.pos = cc.p(data.data.x - 1, data.data.y - 1)
		self.fields.Text_jump:setVisible(true)
		self.fields.line:setVisible(true)
		self.fields.Text_jump:setString(string.format("X:%d Y:%d", self.pos.x, self.pos.y))
		local nowNum = data.data.curNpcLife
		local oriNum = data.data.npcLife
		_ENV = string.format("X:%d Y:%d", self.pos.x, self.pos.y)
		string.format("X:%d Y:%d", self.pos.x, self.pos.y).num1 = nowNum
		string.format("X:%d Y:%d", self.pos.x, self.pos.y).num2 = oriNum
		self.fields.Text_des:setString(i18n("Celestial_defense_text_019", string.format("X:%d Y:%d", self.pos.x, self.pos.y)))
	end
end
function Com_buildDetails_9001573:onJumpClick()
	SoraDPlaySound()
	if self.pos then
		SoraDGotoWorldMapPoint(self.pos, true)
		SoraDRemoveAllPrePanelFromManager(self)
	end
end
return Com_buildDetails_9001573
