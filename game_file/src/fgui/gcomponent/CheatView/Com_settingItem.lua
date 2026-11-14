local cityltCtrl = include("cityltCtrl")
local divineBeastRead = include("divineBeastRead")
local artifactRuneRead = include("artifactRuneRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_settingItem = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CheatView/Com_settingItem", Com_settingItem)
function Com_settingItem:onInit()
	self.fields.Label_title:addClickListener(handler(self, self.btnClick))
	self.fields.List_hero:setItemRenderer(handler(self, self.onHeroRenderer))
	self.fields.Button_biography:setString("英雄列传")
	self.fields.Button_biography:addClickListener(handler(self, self.btnBiographyClick))
	self.fields.Button_viewBuff:setString("属性")
	self.fields.Button_viewBuff:addClickListener(handler(self, self.btnViewBuffClick))
	self.fields.List_equip:setItemRenderer(handler(self, self.onEquipRenderer))
	self.fields.Button_each:setString("每个小队数量")
	self.fields.Button_each:addClickListener(handler(self, self.btnEachClick))
	self.input_count = self.fields.input_count:getChild("input")
	self.input_lv = self.fields.input_lv:getChild("input")
	self.input_starLv = self.fields.input_starLv:getChild("input")
	self.fields.Button_addArmy:setString("选择士兵")
	self.fields.Button_addArmy:addClickListener(handler(self, self.btnAddArmyClick))
	self.fields.List_army:setItemRenderer(handler(self, self.onArmyRenderer))
	self.fields.List_jinn1:setItemRenderer(handler(self, self.onJinn1Renderer))
	self.fields.List_jinn2:setItemRenderer(handler(self, self.onJinn2Renderer))
	self.input_divineBeast = self.fields.input_divineBeast:getChild("input")
	self.input_divineBeast:addEventListener(fgui.UIEventType.Submit, handler(self, self.onSubmit))
	self.fields.List_mark:setItemRenderer(handler(self, self.onMarkRenderer))
	self.fields.Button_delDivine:addClickListener(handler(self, self.btnDelDivineClick))
	self.fields.List_rune:setItemRenderer(handler(self, self.onRuneRenderer))
	self.fields.List_rune:setVisible(false)
end
function Com_settingItem:onSubmit()
	local text = self.input_divineBeast:getText()
	local splitArray = string.split(text, ";")
	if #splitArray ~= 3 then
		SoraDShowMsgTip("输入参数格式不对!!")
		return
	end
	local divineID = tonumber(splitArray[1])
	if divineID ~= divineBeastRead.getDefaultDivineID() then
		divineID = divineBeastRead.getDefaultDivineID()
		SoraDShowMsgTip("输入神兽ID不对!!")
	end
	local stepLv = tonumber(splitArray[2])
	if stepLv > divineBeastRead.getMaxStepLv(divineID) then
		stepLv = divineBeastRead.getMaxStepLv(divineID)
		SoraDShowMsgTip("输入神兽阶级太大!!")
	end
	local starLv = tonumber(splitArray[3])
	if starLv > divineBeastRead.getMaxStarLv(divineID) then
		starLv = divineBeastRead.getMaxStarLv(divineID)
		SoraDShowMsgTip("输入神兽星级太大!!")
	end
	self.input_divineBeast:setText(string.format("%d;%d;%d", divineID, stepLv, starLv))
	_ENV = self.input_divineBeast
	self.input_divineBeast.msg = "MESSAGE_CHEAT_UI_FIGHTDEMO_DIVINE"
	self.input_divineBeast.divineID = divineID
	self.input_divineBeast.stepLv = stepLv
	self.input_divineBeast.starLv = starLv
	SoraDSendMessage(self.input_divineBeast)
end
function Com_settingItem:btnDelDivineClick()
	SoraDPlaySound()
	self.input_divineBeast:setText("")
	self.input_divineBeast:setPromptHolder(string.format("%d;%d;%d", self.divineID, self.divineStepLv, self.divineStarLv))
	_ENV = self.input_divineBeast
	self.input_divineBeast.msg = "MESSAGE_CHEAT_UI_FIGHTDEMO_DIVINE"
	self.input_divineBeast.remove = true
	SoraDSendMessage(self.input_divineBeast)
end
function Com_settingItem:onHeroRenderer(index, obj)
	obj:initData(index + 1, self.editData)
end
function Com_settingItem:onEquipRenderer(index, obj)
	obj:initData(index + 1, self.editData)
end
function Com_settingItem:onArmyRenderer(index, obj)
	obj:initData(index + 1, self.editData)
end
function Com_settingItem:onJinn1Renderer(index, obj)
	obj:initData(index + 1, 1, self.editData)
end
function Com_settingItem:onJinn2Renderer(index, obj)
	obj:initData(index + 1, 2, self.editData)
end
function Com_settingItem:onMarkRenderer(index, obj)
	obj:initData(index + 1, self.divineID, self.editData)
end
function Com_settingItem:onRuneRenderer(index, obj)
	obj:initData(index + 1, self.editData)
end
function Com_settingItem:onShow()
end
function Com_settingItem:initData(cfg, editData)
	self.cfg = cfg
	self.editData = editData
	self.fields.Label_title:setString(self.cfg.title)
	self.fields.Button_switch:setRotation(self.cfg.isOpen and 0 or 180)
	self.controllers.c1:setSelectedIndex(self.cfg.tag - 1)
	if self.cfg.tag == 1 then
		self:setHero()
	elseif self.cfg.tag == 2 then
		self:setAttribute()
	elseif self.cfg.tag == 3 then
		self:setArmy()
	end
	self:setHeight(self.cfg.isOpen and self.cfg.height or 50)
end
function Com_settingItem:setArmy()
	self.fields.Text_campLv:setString("兵营等级")
	self.maxCampLv = cityltCtrl.buildAttr(BUILDID.CHARIOT_PLANT, "maxlv")
	self.input_lv:setPromptHolder(self.maxCampLv)
	self.fields.Text_starLv:setString("光辉等级")
	self.maxStarLv = cityltCtrl.buildAttr(BUILDID.CHARIOT_PLANT, "maxstarlv")
	self.input_starLv:setPromptHolder(self.maxStarLv)
	self.input_count:setText(self.editData.muSetMaxNum)
	self.fields.List_army:setNumItems(#self.editData.armyDataInfo)
end
function Com_settingItem:setAttribute()
	self.fields.Label_equip:setString("领主装备")
	self.fields.List_equip:setNumItems(8)
	self.fields.Label_jinn:setString("神力")
	self.fields.Text_jinn1:setString("神灯1")
	self.fields.Text_jinn2:setString("神灯2")
	self.fields.List_jinn1:setNumItems(4)
	self.fields.List_jinn2:setNumItems(8)
	self.fields.Label_divineBeast:setString("神兽")
	self.fields.Text_divineBeastInfo:setString("神兽信息(神兽ID;阶级;星级)")
	self.divineID = divineBeastRead.getDefaultDivineID()
	self.divineStepLv = divineBeastRead.getMaxStepLv(self.divineID)
	self.divineStarLv = divineBeastRead.getMaxStarLv(self.divineID)
	if next(self.editData.divineBeastList) then
		for divineID, data in pairs(self.editData.divineBeastList) do
			self.divineID = divineID
			self.divineStepLv = data.stepLv
			self.divineStarLv = data.starLv
		end
		self.input_divineBeast:setText(string.format("%d;%d;%d", self.divineID, self.divineStepLv, self.divineStarLv))
	else
		self.input_divineBeast:setText("")
		self.input_divineBeast:setPromptHolder(string.format("%d;%d;%d", self.divineID, self.divineStepLv, self.divineStarLv))
	end
	self.fields.List_mark:setNumItems(6)
	self.fields.Label_arms:setString("神器")
	self.fields.Text_dispatchArms:setString("出征神器")
	local armsID = self.editData.armsInfo[1]
	self.fields.Com_armsAdd:initData(armsID)
	self.holeMap = artifactRuneRead.getHoleMap()
	if armsID and self.holeMap[armsID] then
		self.fields.List_rune:setVisible(true)
		self.fields.List_rune:setNumItems(8)
	else
		self.fields.List_rune:setVisible(false)
	end
end
function Com_settingItem:setHero()
	self.fields.Text_mainHero:setString("主将")
	self.fields.Text_weapon:setString("携带武器")
	self.fields.Text_viceHero:setString("副将")
	self.fields.List_hero:setNumItems(5)
end
function Com_settingItem:btnBiographyClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).editData = self.editData
	uiManager:show("CheatHeroBiography", nil)
end
function Com_settingItem:btnViewBuffClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).editData = self.editData
	uiManager:show("CheatViewBuffPop", nil)
end
function Com_settingItem:btnClick()
	SoraDPlaySound()
	self.cfg.isOpen = not self.cfg.isOpen
	_ENV = not self.cfg.isOpen
	;(not self.cfg.isOpen).msg = "MESSAGE_CHEAT_UI_FIGHTDEMO_SWITCH"
	;(not self.cfg.isOpen).tag = self.cfg.tag
	;(not self.cfg.isOpen).isOpen = self.cfg.isOpen
	SoraDSendMessage(not self.cfg.isOpen)
end
function Com_settingItem:btnEachClick()
	SoraDPlaySound()
	local inputCount = tonumber(self.input_count:getText())
	if inputCount and 0 < inputCount then
		_ENV = self.input_count:getText()
		self.input_count:getText().msg = "MESSAGE_CHEAT_UI_FIGHTDEMO_ARMY"
		self.input_count:getText().muSetMaxNum = inputCount
		SoraDSendMessage(self.input_count:getText())
	else
		SoraDShowMsgTip("请输入每个小队数量！")
	end
end
function Com_settingItem:btnAddArmyClick()
	SoraDPlaySound()
	local lv = tonumber(self.input_lv:getText()) or self.maxCampLv
	local starLv = tonumber(self.input_starLv:getText()) or self.maxStarLv
	_ENV = self.input_starLv:getText()
	self.input_starLv:getText().lv = lv
	self.input_starLv:getText().starLv = starLv
	uiManager:show("CheatArmyPop", self.input_starLv:getText())
end
return Com_settingItem
