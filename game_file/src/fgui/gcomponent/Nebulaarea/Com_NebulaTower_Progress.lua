local baseComponent = require("fgui.base.baseComponent")
local Com_NebulaTower_Progress = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Nebulaarea/Com_NebulaTower_Progress", Com_NebulaTower_Progress)
local nebulaTowerLvDesRead = include("nebulaTowerLvDesRead")
local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
function Com_NebulaTower_Progress:onInit()
	if not SoraDFIsRA() then
		self:fixChildrenPos(false, true)
	end
	if not SoraDFIsRA() then
		self.fields.progress:fixChildrenPos(false, true)
	end
end
function Com_NebulaTower_Progress:onShow()
end
function Com_NebulaTower_Progress:setData()
	self.towerData = nebulaActivityCtrl:getTowerData()
	if not self.towerData then
		return
	end
	self.curLv = self.towerData.level
	local slv, blv = nebulaTowerLvDesRead.getLookCurLv(self.curLv)
	self.fields.level_now:setString(slv)
	self.fields.level_next:setString(blv)
	self.curExp = self.towerData.exp
	local lvCfg = nebulaTowerLvDesRead.getLvCfg(self.curLv)
	if not lvCfg or self.curLv == nebulaTowerLvDesRead.getMaxLevel() then
		self.fields.progress:setValue(100)
		fguiHelper.get_fields(self.fields.progress).title:setString("MAX")
		self.fields.level_next:setVisible(false)
		self.fields.level_now:setString(blv)
	else
		self.fields.progress:setMax(lvCfg.needExp / 10)
		self.fields.progress:setValue(self.curExp / 10)
		fguiHelper.get_fields(self.fields.progress).title:setString(self.curExp .. "/" .. lvCfg.needExp)
		self.fields.level_next:setVisible(true)
	end
end
return Com_NebulaTower_Progress
