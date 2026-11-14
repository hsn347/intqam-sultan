local armyDesRead = include("armyDesRead")
local armyCtrl = SoraDGetCtrl("armyCtrl")
local eliteSoldiersDef = include("eliteSoldiersDef")
local armyLogic = include("armyLogic")
local baseComponent = require("fgui.base.baseComponent")
local Com_soldierShow = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://soldiersCampView/Com_soldierShow", Com_soldierShow)
fgui.register_extension("ui://soldiersCampView/Com_soldierShow2", Com_soldierShow)
function Com_soldierShow:onInit()
	self:fixChildrenPos()
end
function Com_soldierShow:onShow()
end
function Com_soldierShow:initData(armyid, promoteCount, isTarget, isTrap)
	local promoteCount = promoteCount or 0
	local isTarget = isTarget or false
	local isTrap = isTrap or false
	self.fields.Com_army:initData(armyid)
	local warLv = armyDesRead.getWarLv(armyid)
	self.fields.Lab_warLv:setVisible(0 < warLv)
	self.fields.Lab_warLv:setString(warLv)
	if self.fields.Text_own then
		local armyCount = armyCtrl:getArmyCount(armyid, ARMY_OPTYPE.NORMAL_ARMY)
		if isTarget then
			armyDesRead = nil
			;(nil).num = string.formatnumberthousands(armyCount + promoteCount)
			self.fields.Text_own:setString(i18n("common_text_531", nil))
		else
			armyDesRead = i18n("common_text_531", nil)
			i18n("common_text_531", nil).num = string.formatnumberthousands(math.max(0, armyCount - promoteCount))
			self.fields.Text_own:setString(i18n("common_text_531", i18n("common_text_531", nil)))
		end
	end
	self.fields.Text_name:setString(armyDesRead.getName(armyid))
	self.fields.icon_level:setSpriteFrame(isTrap and armyDesRead.getTrapLvImg(armyid) or armyDesRead.getLvImg(armyid))
end
return Com_soldierShow
