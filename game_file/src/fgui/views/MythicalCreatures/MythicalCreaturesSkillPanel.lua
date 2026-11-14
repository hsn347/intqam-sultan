local baseFguiPanel = require("fgui.base.baseFguiPanel")
local divineBeastRead = include("divineBeastRead")
local MythicalCreaturesSkillPanel = class("MythicalCreaturesSkillPanel", baseFguiPanel)
function MythicalCreaturesSkillPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("MythicalCreaturesSkillPanel:ctor", self.viewName)
end
function MythicalCreaturesSkillPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function MythicalCreaturesSkillPanel:onInit()
	print("=======MythicalCreaturesSkillPanel:onInit")
	self.index = self.param.index
	self.beastCfg = self.param.beastCfg
	self.beastData = self.param.beastData
	self.isOnlyCurLv = self.param.isOnlyCurLv
	self.skillID = self.beastCfg.divineSkill[self.index]
	self.unLockStar = self.beastCfg.unlockStar[self.index]
end
function MythicalCreaturesSkillPanel:onShow()
	print("=======MythicalCreaturesSkillPanel:onShow")
	self:updateView()
end
function MythicalCreaturesSkillPanel:updateView()
	local isLock = self.beastData.starLv == nil or self.beastData.starLv < self.unLockStar
	self.skillCfgs = divineBeastRead.getSkillCfg(self.skillID)
	if isLock then
		self.curSkillLv = 1
	else
		self.starCfg = divineBeastRead.getStarCfg(self.beastCfg.divineID, self.beastData.starLv or 0)
		self.curSkillLv = self.starCfg.skillLevel[self.index]
	end
	self.curSkillCfg = self.skillCfgs[self.curSkillLv]
	self.fields.Panel_bg:setTitle(self.curSkillCfg.skillName == "" and "" or i18n(self.curSkillCfg.skillName))
	self.fields.Com_MC_SkillIcon:initData(self.beastCfg, self.beastData, self.index)
	self.fields.Com_MC_SkillIcon:setShowOnly()
	divineBeastRead = self.index
	self.index.lv = self.curSkillLv
	self.fields.txt_nowlv:setString(i18n("common_text_100", self.index))
	dump(type(self.curSkillCfg.skillDes), "type(self.curSkillCfg.skillDes)")
	if type(self.curSkillCfg.skillDes) == "table" then
		self.fields.txt_skill_desc:setString(i18n(self.curSkillCfg.skillDes[1], self.curSkillCfg.skillDes))
	else
		self.fields.txt_skill_desc:setString(self.curSkillCfg.skillDes == "" and "" or i18n(self.curSkillCfg.skillDes))
	end
	if self.isOnlyCurLv then
		self.controllers.c1:setSelectedIndex(1)
		self.fields.txt_unlockDesc:setVisible(false)
		return
	end
	if isLock then
		self.controllers.c1:setSelectedIndex(1)
		divineBeastRead = i18n(self.curSkillCfg.skillDes[1], self.curSkillCfg.skillDes)
		i18n(self.curSkillCfg.skillDes[1], self.curSkillCfg.skillDes).num = self.unLockStar
		self.fields.txt_unlockDesc:setString(i18n("Divine_beast_text_22", i18n(self.curSkillCfg.skillDes[1], self.curSkillCfg.skillDes)))
		return
	end
	local nextSkillCfg = self.skillCfgs[self.curSkillLv + 1]
	if nextSkillCfg == nil then
		self.controllers.c1:setSelectedIndex(1)
		self.fields.txt_unlockDesc:setString("")
		return
	end
	self.controllers.c1:setSelectedIndex(0)
	divineBeastRead = i18n("Divine_beast_text_22", i18n(self.curSkillCfg.skillDes[1], self.curSkillCfg.skillDes))
	i18n("Divine_beast_text_22", i18n(self.curSkillCfg.skillDes[1], self.curSkillCfg.skillDes)).lv = self.curSkillLv + 1
	self.fields.txt_nextlv:setString(i18n("common_text_100", i18n("Divine_beast_text_22", i18n(self.curSkillCfg.skillDes[1], self.curSkillCfg.skillDes))))
	if type(nextSkillCfg.skillDes) == "table" then
		self.fields.txt_nextskill_desc:setString(i18n(nextSkillCfg.skillDes[1], nextSkillCfg.skillDes))
	else
		self.fields.txt_nextskill_desc:setString(nextSkillCfg.skillDes == "" and "" or i18n(nextSkillCfg.skillDes))
	end
	local starCfgs = divineBeastRead.getStarCfgs(self.beastCfg.divineID)
	for i = 0, table.nums(starCfgs) - 1 do
		local tmpStarCfg = starCfgs[i]
		if tmpStarCfg.skillLevel[self.index] == self.curSkillLv + 1 then
			divineBeastRead = i18n(nextSkillCfg.skillDes[1], nextSkillCfg.skillDes)
			i18n(nextSkillCfg.skillDes[1], nextSkillCfg.skillDes).num = tmpStarCfg.starLevel
			i18n(nextSkillCfg.skillDes[1], nextSkillCfg.skillDes).lv = self.curSkillLv + 1
			self.fields.txt_unlockDesc:setString(i18n("Divine_beast_text_21", i18n(nextSkillCfg.skillDes[1], nextSkillCfg.skillDes)))
			return
		end
	end
end
return MythicalCreaturesSkillPanel
