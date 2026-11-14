local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001573_DetailsPanel = class("Activity_9001573_DetailsPanel", baseFguiPanel)
local activity_9001573_Read = include("activity_9001573_Read")
function Activity_9001573_DetailsPanel:ctor(...)
	Activity_9001573_DetailsPanel.super.ctor(self, ...)
	print("Activity_9001573_DetailsPanel:ctor", self.viewName)
	self.debug = true
end
function Activity_9001573_DetailsPanel:onInit()
	print("=======Activity_9001573_DetailsPanel:onInit")
	self.mapInstance = self.param.mapInstance
	if self.mapInstance:getInstanceType() ~= gMapObjTypeDef.mapObjTypeKingdomLevelBuild then
		self.buildCfg = activity_9001573_Read.getBuild(self.mapInstance.objId)
		if self.buildCfg.buildDes and self.buildCfg.buildDes ~= "" then
			self.fields.txt_tip:setString(i18n(self.buildCfg.buildDes))
		elseif self.buildCfg.buildType == gWorldTypeServerDef.subTypeNebulaDefenceWarWall then
			self.fields.txt_tip:setString(i18n("Celestial_defense_text_085"))
		end
		self.fields.Com_title:initData(i18n(self.buildCfg.buildName), handler(self, self.onClickClose))
	else
		self.fields.Com_title:initData(i18n("Celestial_defense_text_021"), handler(self, self.onClickClose))
		self.fields.txt_tip:setString(i18n("Celestial_defense_text_086"))
	end
	self.nebulaDefenceData = self.param.nebulaDefenceData
	self.debuff = self.param.debuff
end
function Activity_9001573_DetailsPanel:onShow()
	print("=======Activity_9001573_DetailsPanel:onShow")
	_ENV = "=======Activity_9001573_DetailsPanel:onShow"
	;("=======Activity_9001573_DetailsPanel:onShow").isHideMainUI = true
	SoraDHideCurrentSceneViewAndMainUI("=======Activity_9001573_DetailsPanel:onShow")
	_ENV = "=======Activity_9001573_DetailsPanel:onShow"
	;("=======Activity_9001573_DetailsPanel:onShow").msg = "MESSAGE_SERVER_WORLD_MAP_DISTANCE_VISIBLE"
	;("=======Activity_9001573_DetailsPanel:onShow").ret = true
	SoraDSendMessage("=======Activity_9001573_DetailsPanel:onShow")
	_ENV = "=======Activity_9001573_DetailsPanel:onShow"
	;("=======Activity_9001573_DetailsPanel:onShow").x = self.mapInstance.tilePoint.x + 2
	;("=======Activity_9001573_DetailsPanel:onShow").y = self.mapInstance.tilePoint.y + 2
	SoraDGotoWorldMapPoint("=======Activity_9001573_DetailsPanel:onShow", false)
	self:initData()
end
function Activity_9001573_DetailsPanel:onHide()
	_ENV = nil
	;(nil).isHideMainUI = false
	SoraDHideCurrentSceneViewAndMainUI(nil)
	_ENV = nil
	;(nil).msg = "MESSAGE_SERVER_WORLD_MAP_DISTANCE_VISIBLE"
	SoraDSendMessage(nil)
end
function Activity_9001573_DetailsPanel:initData()
	dump(self.nebulaDefenceData, "self.nebulaDefenceData")
	if self.nebulaDefenceData then
		local armyNum = 0
		local orgArmyNum = self.buildCfg.num
		if self.nebulaDefenceData and self.nebulaDefenceData.npc then
			armyNum = self.nebulaDefenceData.npc.life or 0
		end
		local defendArmyNum = 0
		if self.nebulaDefenceData and self.nebulaDefenceData.npc and self.nebulaDefenceData.npc.army then
			for _, v in ipairs(self.nebulaDefenceData.npc.army) do
				defendArmyNum = defendArmyNum + v.num
			end
		end
		_ENV = nil
		;(nil).num = defendArmyNum
		self.fields.txt_des2:setString(i18n("Celestial_defense_text_082", nil))
		_ENV = i18n("Celestial_defense_text_082", nil)
		i18n("Celestial_defense_text_082", nil).num1 = armyNum
		i18n("Celestial_defense_text_082", nil).num2 = orgArmyNum
		self.fields.txt_des:setString(i18n("Celestial_defense_text_019", i18n("Celestial_defense_text_082", nil)))
	else
		local defendArmyNum = 0
		if self.mapInstance and self.mapInstance.npcArmy and self.mapInstance.npcArmy then
			for _, v in ipairs(self.mapInstance.npcArmy) do
				defendArmyNum = defendArmyNum + v.num
			end
		end
		_ENV = i18n("Celestial_defense_text_019", i18n("Celestial_defense_text_082", nil))
		i18n("Celestial_defense_text_019", i18n("Celestial_defense_text_082", nil)).num = defendArmyNum
		self.fields.txt_des2:setString(i18n("Celestial_defense_text_082", i18n("Celestial_defense_text_019", i18n("Celestial_defense_text_082", nil))))
		_ENV = i18n("Celestial_defense_text_082", i18n("Celestial_defense_text_019", i18n("Celestial_defense_text_082", nil)))
		i18n("Celestial_defense_text_082", i18n("Celestial_defense_text_019", i18n("Celestial_defense_text_082", nil))).num = self.mapInstance.npcLife or 0
		self.fields.txt_des:setString(i18n("Celestial_defense_text_065", i18n("Celestial_defense_text_082", i18n("Celestial_defense_text_019", i18n("Celestial_defense_text_082", nil)))))
	end
	if self.buildCfg and self.buildCfg.buildType == 3 then
		self.controllers.c1:setSelectedIndex(1)
		_ENV = self.controllers.c1.setSelectedIndex
		self.controllers.c1.setSelectedIndex.infantry = 0
		self.controllers.c1.setSelectedIndex.archer = 0
		local self.controllers.c1.setSelectedIndex.cavalry, debuffValue = 0, self.controllers.c1.setSelectedIndex
		local buffValue = 0
		if self.debuff then
			for _, v in pairs(self.debuff) do
				for k, v2 in pairs(v) do
					debuffValue[k] = debuffValue[k] + v2
				end
				break
			end
		end
		local value1 = 100 + debuffValue.infantry / 10 + buffValue / 10
		local value2 = 100 + debuffValue.archer / 10 + buffValue / 10
		local value3 = 100 + debuffValue.cavalry / 10 + buffValue / 10
		self.fields.Com_detailsPro_1:initData(i18n("Celestial_defense_text_048"), string.format("%%%.02f", value1), "icon_artifact_bubing.png", "frame_sjbxxl_jdt4.png")
		self.fields.Com_detailsPro_1:setValue(value1)
		self.fields.Com_detailsPro_2:initData(i18n("Celestial_defense_text_050"), string.format("%%%.02f", value2), "icon_artifact_gongbing.png", "frame_sjbxxl_jdt2.png")
		self.fields.Com_detailsPro_2:setValue(value2)
		self.fields.Com_detailsPro_3:initData(i18n("Celestial_defense_text_049"), string.format("%%%.02f", value3), "icon_artifact_qibing.png", "frame_sjbxxl_jdt1.png")
		self.fields.Com_detailsPro_3:setValue(value3)
	else
		self.controllers.c1:setSelectedIndex(0)
	end
end
return Activity_9001573_DetailsPanel
