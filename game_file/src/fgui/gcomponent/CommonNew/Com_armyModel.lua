local armyDesRead = include("armyDesRead")
local armyLogic = include("armyLogic")
local eliteSoldiersDef = include("eliteSoldiersDef")
local baseComponent = require("fgui.base.baseComponent")
local Com_armyModel = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CommonNew/Com_armyModel", Com_armyModel)
function Com_armyModel:onInit()
end
function Com_armyModel:onShow()
end
function Com_armyModel:initData(armyID)
	local spineCfg = armyDesRead.getSpecialArmyCfg(armyID)
	local spineInfo = spineCfg and spineCfg.spine
	if spineInfo then
		self.fields.Spine_army:setVisible(true)
		self.fields.Image_army:setVisible(false)
		self.fields.Spine_army:setEffectPath(spineInfo)
		if spineCfg.prefabCfg then
			for boneName, prefab in pairs(spineCfg.prefabCfg) do
				self.fields.Spine_army:addPrefab(boneName, prefab)
			end
		end
		local pos = spineCfg.pos or cc.p(0, 0)
		self.fields.Spine_army:setSpinePos(cc.p(pos.x, -pos.y))
	else
		self:initElite(armyID)
	end
end
function Com_armyModel:initElite(armyID)
	local modelType = armyDesRead.getModelType(armyID)
	local alv = armyLogic.getArmyLV(armyID)
	local spineCfg = eliteSoldiersDef.getSpineCfg(modelType, alv)
	local spineInfo = spineCfg and spineCfg.json
	if spineInfo then
		self.fields.Spine_army:setVisible(true)
		self.fields.Image_army:setVisible(false)
		self.fields.Spine_army:setEffectPath(spineInfo)
		local pos = spineCfg.pos or cc.p(0, 0)
		self.fields.Spine_army:setSpinePos(cc.p(pos.x, -pos.y))
	else
		self.fields.Image_army:setSpriteFrame(armyDesRead.getPortrait(armyID))
		self.fields.Image_army:setVisible(true)
		self.fields.Spine_army:setVisible(false)
	end
end
return Com_armyModel
