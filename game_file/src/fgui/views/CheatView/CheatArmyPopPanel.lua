local armyLogic = include("armyLogic")
local armyDesRead = include("armyDesRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local CheatArmyPopPanel = class("CheatArmyPopPanel", baseFguiPanel)
function CheatArmyPopPanel:ctor(...)
	self.isLRU = true
	CheatArmyPopPanel.super.ctor(self, ...)
	print("CheatArmyPopPanel:ctor", self.viewName)
end
function CheatArmyPopPanel:onInit()
	print("=======CheatArmyPopPanel:onInit")
	self.fields.Panel_bg:setString("选择士兵")
	self.fields.Text_army:setString("士兵")
	self.fields.Text_name:setString("士兵名字")
	self.fields.Text_id:setString("士兵ID")
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.input_name = self.fields.input_name:getChild("input")
	self.input_name:setPromptHolder("兵种ID或者士兵名")
	self.fields.Button_search:setString("搜索")
	self.fields.Button_search:addClickListener(handler(self, self.btnSearchClick))
end
function CheatArmyPopPanel:onItemRenderer(index, obj)
	obj:initData(self.armyShowList[index + 1])
end
function CheatArmyPopPanel:endShow()
	print("=======CheatArmyPopPanel:endShow")
	self.lv = self.param.lv
	_UPVALUE5_, self.armyList, _ENV, self.starLv = self.param.starLv, self.param.starLv, self.param.starLv, self.param.starLv
	self.param.starLv[1] = BUILDID.STABLES
	self.param.starLv[2] = BUILDID.RANGE
	self.param.starLv[3] = BUILDID.CHARIOT_PLANT
	self.param.starLv[4] = BUILDID.BARRACKS
	local self.param.starLv[5], buildID = BUILDID.ELITE_PALACE, self.param.starLv
	for k, v in pairs(buildID) do
		local armyIDCfg = armyLogic.getDemoArmyList(v, self.lv, self.starLv)
		for _, id in ipairs(armyIDCfg) do
			table.insert(self.armyList, id)
		end
	end
	self.armyShowList = clone(self.armyList)
	self.fields.List:setNumItems(#self.armyShowList)
end
function CheatArmyPopPanel:btnSearchClick()
	SoraDPlaySound()
	local text = self.input_name:getText()
	local armyID = tonumber(text)
	local _ENV, suitArray = text, text
	if armyID then
		table.insert(suitArray, armyID)
	else
		for _, id in ipairs(self.armyList) do
			local name = armyDesRead.getName(id)
			if string.find(name, text) then
				table.insert(suitArray, id)
			end
		end
	end
	if 0 < #suitArray then
		self.armyShowList = suitArray
		self.fields.List:setNumItems(#self.armyShowList)
	else
		SoraDShowMsgTip("未搜索到匹配结果！")
	end
end
return CheatArmyPopPanel
