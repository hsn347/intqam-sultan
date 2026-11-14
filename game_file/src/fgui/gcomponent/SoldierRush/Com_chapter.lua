local soldierRushRead = include("soldierRushRead")
local soldierRushCtrl = SoraDGetCtrl("soldierRushCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_chapter = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://SoldierRush/Com_chapter", Com_chapter)
function Com_chapter:onInit()
	self.fields.Text_done:setString(i18n("common_text_2601"))
	self.fields.icon_star:fixPos()
	self.fields.Text_stars:fixPos()
end
function Com_chapter:onShow()
end
function Com_chapter:initData(index)
	self.index = index
	local cfg = soldierRushRead.getChapterCfg(index)
	self.fields.icon:setSpriteFrame(cfg.Icon)
	soldierRushRead = nil
	;(nil).num = index
	self.fields.Text_name:setString(i18n("common_text_3162", nil) .. " " .. i18n(cfg.Name))
	local status, stars = soldierRushCtrl:getChpaterInfo(index)
	self.controllers.c1:setSelectedIndex(status)
	self.fields.Text_stars:setString(stars .. "/" .. soldierRushRead.getChapterAllStars(index))
end
return Com_chapter
