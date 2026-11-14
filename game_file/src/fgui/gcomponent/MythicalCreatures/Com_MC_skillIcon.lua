local baseComponent = require("fgui.base.baseComponent")
local divineBeastRead = include("divineBeastRead")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local Com_MC_skillIcon = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://MythicalCreatures/Com_MC_skillIcon", Com_MC_skillIcon)
function Com_MC_skillIcon:onInit()
	self:addClickEventListener(handler(self, self.onClick))
end
function Com_MC_skillIcon:onShow()
end
function Com_MC_skillIcon:initData(beastCfg, beastData, index, autoHide, mode)
	local skillID = beastCfg.divineSkill[index]
	self:setVisible(skillID ~= nil)
	if skillID == nil then
		return
	end
	self.beastCfg = beastCfg
	self.beastData = beastData
	self.starCfg = divineBeastRead.getStarCfg(beastData.divineID, beastData.starLv)
	self.index = index
	self.skillID = skillID
	local unLockStar = beastCfg.unlockStar[index]
	local skillCfg = divineBeastRead.getSkillCfg(skillID)[self.starCfg and self.starCfg.skillLevel[index] or 1]
	local isLock = false
	if beastData ~= nil then
		isLock = beastData.starLv == nil or unLockStar > beastData.starLv
	end
	dump(mode, "Com_MC_skillIcon:initData")
	if autoHide then
		self:setVisible(not isLock and (skillCfg.activeType == 2 or mode == gHeroSelectBannerStyle.defend and skillCfg.activeType == 3))
	else
		self.controllers.c1:setSelectedIndex(isLock and 1 or 0)
		if isLock then
			divineBeastRead = nil
			;(nil).num = unLockStar
			self.fields.title:setString(i18n("Divine_beast_text_47", nil))
		end
	end
	self.fields.icon:setURL(skillCfg.skillIcon)
	self.fields.quality:setURL(heroltCtrl.getSkillBg(skillCfg.quality))
end
function Com_MC_skillIcon:setShowOnly()
	self.showOnly = true
	self.controllers.c1:setSelectedIndex(0)
end
function Com_MC_skillIcon:setClickPopType(isOnlyCurLv)
	self.isOnlyCurLv = isOnlyCurLv
end
function Com_MC_skillIcon:onClick()
	if self.showOnly then
		return
	end
	SoraDPlaySound()
	_ENV = nil
	;(nil).index = self.index
	;(nil).beastCfg = self.beastCfg
	;(nil).beastData = self.beastData
	;(nil).isOnlyCurLv = self.isOnlyCurLv
	uiManager:show("MythicalCreaturesSkill", nil)
end
return Com_MC_skillIcon
