local cheatCtrl = SoraDGetCtrl("cheatCtrl")
local heroWeaponRead = include("heroWeaponRead")
local heroBiographyRead = include("heroBiographyRead")
local magicLampRead = include("magicLampRead")
local divineBeastMarkRead = include("divineBeastMarkRead")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local CheatFightDemoPanel = class("CheatFightDemoPanel", baseFguiPanel)
function CheatFightDemoPanel:ctor(...)
	CheatFightDemoPanel.super.ctor(self, ...)
	print("CheatFightDemoPanel:ctor", self.viewName)
end
function CheatFightDemoPanel:onInit()
	print("=======CheatFightDemoPanel:onInit")
	_ENV, _ENV = "=======CheatFightDemoPanel:onInit", print
	;("=======CheatFightDemoPanel:onInit").title = "阵容设置"
	;("=======CheatFightDemoPanel:onInit").tag = 1
	;("=======CheatFightDemoPanel:onInit").height = 688
	_ENV, print[1], ("=======CheatFightDemoPanel:onInit").isOpen = "=======CheatFightDemoPanel:onInit", "=======CheatFightDemoPanel:onInit", true
	;("=======CheatFightDemoPanel:onInit").title = "属性设置"
	;("=======CheatFightDemoPanel:onInit").tag = 2
	;("=======CheatFightDemoPanel:onInit").height = 1530
	_ENV, print[2], ("=======CheatFightDemoPanel:onInit").isOpen = "=======CheatFightDemoPanel:onInit", "=======CheatFightDemoPanel:onInit", false
	;("=======CheatFightDemoPanel:onInit").title = "队列设置"
	;("=======CheatFightDemoPanel:onInit").tag = 3
	;("=======CheatFightDemoPanel:onInit").height = 688
	self.settingList, print[3], ("=======CheatFightDemoPanel:onInit").isOpen = print, "=======CheatFightDemoPanel:onInit", false
	self.bagMarkIdIdx = 100
	self.fields.Com_title:initData("战斗模拟", handler(self, self.onClickClose))
	self.fields.Text_fightCount:setString("次数")
	self.fields.Text_fightCount:setAlign(0)
	self.input_count = self.fields.input_count:getChild("input")
	self.input_count:setPromptHolder(1)
	self.input_count:addEventListener(fgui.UIEventType.Submit, handler(self, self.onSubmit))
	self.fields.Button_fight:setString("开始模拟战斗")
	self.fields.Button_fight:addClickListener(handler(self, self.btnFightClick))
	self.fields.Button_in:setString("导入数据")
	self.fields.Button_in:addClickListener(handler(self, self.btnInDataClick))
	self.fields.Button_out:setString("导出数据")
	self.fields.Button_out:addClickListener(handler(self, self.btnOutDataClick))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function CheatFightDemoPanel:onItemRenderer(index, obj)
	obj:initData(self.settingList[index + 1], self.editData)
end
function CheatFightDemoPanel:onSubmit()
	local count = tonumber(self.input_count:getText())
	if not count then
		self.fields.input_count:setText(1)
	elseif count > self.maxCount then
		self.fields.input_count:setText(self.maxCount)
	end
end
function CheatFightDemoPanel:onShow()
	print("=======CheatFightDemoPanel:onShow")
	self.fields.Com_bg:setGradientColor()
	self.tag = 1
	_ENV, self.maxCount = self.fields.Com_bg.setGradientColor, 1000
	self.fields.Com_bg.setGradientColor.godArmsRune, ("attack_" .. tostring(serviceFunctions.systemTime())).runeList, _ENV, ("attack_" .. tostring(serviceFunctions.systemTime())).newGodArmsRuneList, _ENV, _ENV, self.fields.Com_bg.setGradientColor.armsInfo, _ENV, self.fields.Com_bg.setGradientColor.beastMarkBag, _ENV, self.fields.Com_bg.setGradientColor.beast, _ENV, self.fields.Com_bg.setGradientColor.divineBeastList, _ENV, self.fields.Com_bg.setGradientColor.jinnSkillCfg, _ENV, self.fields.Com_bg.setGradientColor.magicLampSkillList, _ENV, self.fields.Com_bg.setGradientColor.jinnList, _ENV, self.fields.Com_bg.setGradientColor.buffMap, _ENV, self.fields.Com_bg.setGradientColor.armyDataInfo, _ENV, self.fields.Com_bg.setGradientColor.biographyIndex, _ENV, self.fields.Com_bg.setGradientColor.biographyList, _ENV, self.fields.Com_bg.setGradientColor.viceHeroList, _ENV, self.fields.Com_bg.setGradientColor.heroList, _ENV, self.fields.Com_bg.setGradientColor.heroWeaponUID, _ENV, self.fields.Com_bg.setGradientColor.heroWeapon, _ENV, self.fields.Com_bg.setGradientColor.equipmentCfg, _ENV, self.fields.Com_bg.setGradientColor.equipment, _ENV, self.fields.Com_bg.setGradientColor.userid = "attack_" .. tostring(serviceFunctions.systemTime()), tostring(serviceFunctions.systemTime()), tostring(serviceFunctions.systemTime()), tostring(serviceFunctions.systemTime()), tostring(serviceFunctions.systemTime()), "attack_" .. tostring(serviceFunctions.systemTime()), "attack_" .. tostring(serviceFunctions.systemTime()), "attack_" .. tostring(serviceFunctions.systemTime()), "attack_" .. tostring(serviceFunctions.systemTime()), "attack_" .. tostring(serviceFunctions.systemTime()), "attack_" .. tostring(serviceFunctions.systemTime()), "attack_" .. tostring(serviceFunctions.systemTime()), "attack_" .. tostring(serviceFunctions.systemTime()), "attack_" .. tostring(serviceFunctions.systemTime()), "attack_" .. tostring(serviceFunctions.systemTime()), "attack_" .. tostring(serviceFunctions.systemTime()), "attack_" .. tostring(serviceFunctions.systemTime()), "attack_" .. tostring(serviceFunctions.systemTime()), "attack_" .. tostring(serviceFunctions.systemTime()), "attack_" .. tostring(serviceFunctions.systemTime()), "attack_" .. tostring(serviceFunctions.systemTime()), "attack_" .. tostring(serviceFunctions.systemTime()), "attack_" .. tostring(serviceFunctions.systemTime()), "attack_" .. tostring(serviceFunctions.systemTime()), "attack_" .. tostring(serviceFunctions.systemTime()), "attack_" .. tostring(serviceFunctions.systemTime()), "attack_" .. tostring(serviceFunctions.systemTime()), "attack_" .. tostring(serviceFunctions.systemTime()), "attack_" .. tostring(serviceFunctions.systemTime()), "attack_" .. tostring(serviceFunctions.systemTime()), "attack_" .. tostring(serviceFunctions.systemTime()), "attack_" .. tostring(serviceFunctions.systemTime()), "attack_" .. tostring(serviceFunctions.systemTime()), "attack_" .. tostring(serviceFunctions.systemTime()), "attack_" .. tostring(serviceFunctions.systemTime()), "attack_" .. tostring(serviceFunctions.systemTime()), "attack_" .. tostring(serviceFunctions.systemTime()), "attack_" .. tostring(serviceFunctions.systemTime()), "attack_" .. tostring(serviceFunctions.systemTime()), "attack_" .. tostring(serviceFunctions.systemTime()), "attack_" .. tostring(serviceFunctions.systemTime())
	_ENV, self.attack, self.fields.Com_bg.setGradientColor.muSetMaxNum = self.fields.Com_bg.setGradientColor, self.fields.Com_bg.setGradientColor, 1
	self.fields.Com_bg.setGradientColor.godArmsRune, ("defend_" .. tostring(serviceFunctions.systemTime())).runeList, _ENV, ("defend_" .. tostring(serviceFunctions.systemTime())).newGodArmsRuneList, _ENV, _ENV, self.fields.Com_bg.setGradientColor.armsInfo, _ENV, self.fields.Com_bg.setGradientColor.beastMarkBag, _ENV, self.fields.Com_bg.setGradientColor.beast, _ENV, self.fields.Com_bg.setGradientColor.divineBeastList, _ENV, self.fields.Com_bg.setGradientColor.jinnSkillCfg, _ENV, self.fields.Com_bg.setGradientColor.magicLampSkillList, _ENV, self.fields.Com_bg.setGradientColor.jinnList, _ENV, self.fields.Com_bg.setGradientColor.buffMap, _ENV, self.fields.Com_bg.setGradientColor.armyDataInfo, _ENV, self.fields.Com_bg.setGradientColor.biographyIndex, _ENV, self.fields.Com_bg.setGradientColor.biographyList, _ENV, self.fields.Com_bg.setGradientColor.viceHeroList, _ENV, self.fields.Com_bg.setGradientColor.heroList, _ENV, self.fields.Com_bg.setGradientColor.heroWeaponUID, _ENV, self.fields.Com_bg.setGradientColor.heroWeapon, _ENV, self.fields.Com_bg.setGradientColor.equipmentCfg, _ENV, self.fields.Com_bg.setGradientColor.equipment, _ENV, self.fields.Com_bg.setGradientColor.userid = "defend_" .. tostring(serviceFunctions.systemTime()), tostring(serviceFunctions.systemTime()), tostring(serviceFunctions.systemTime()), tostring(serviceFunctions.systemTime()), tostring(serviceFunctions.systemTime()), "defend_" .. tostring(serviceFunctions.systemTime()), "defend_" .. tostring(serviceFunctions.systemTime()), "defend_" .. tostring(serviceFunctions.systemTime()), "defend_" .. tostring(serviceFunctions.systemTime()), "defend_" .. tostring(serviceFunctions.systemTime()), "defend_" .. tostring(serviceFunctions.systemTime()), "defend_" .. tostring(serviceFunctions.systemTime()), "defend_" .. tostring(serviceFunctions.systemTime()), "defend_" .. tostring(serviceFunctions.systemTime()), "defend_" .. tostring(serviceFunctions.systemTime()), "defend_" .. tostring(serviceFunctions.systemTime()), "defend_" .. tostring(serviceFunctions.systemTime()), "defend_" .. tostring(serviceFunctions.systemTime()), "defend_" .. tostring(serviceFunctions.systemTime()), "defend_" .. tostring(serviceFunctions.systemTime()), "defend_" .. tostring(serviceFunctions.systemTime()), "defend_" .. tostring(serviceFunctions.systemTime()), "defend_" .. tostring(serviceFunctions.systemTime()), "defend_" .. tostring(serviceFunctions.systemTime()), "defend_" .. tostring(serviceFunctions.systemTime()), "defend_" .. tostring(serviceFunctions.systemTime()), "defend_" .. tostring(serviceFunctions.systemTime()), "defend_" .. tostring(serviceFunctions.systemTime()), "defend_" .. tostring(serviceFunctions.systemTime()), "defend_" .. tostring(serviceFunctions.systemTime()), "defend_" .. tostring(serviceFunctions.systemTime()), "defend_" .. tostring(serviceFunctions.systemTime()), "defend_" .. tostring(serviceFunctions.systemTime()), "defend_" .. tostring(serviceFunctions.systemTime()), "defend_" .. tostring(serviceFunctions.systemTime()), "defend_" .. tostring(serviceFunctions.systemTime()), "defend_" .. tostring(serviceFunctions.systemTime()), "defend_" .. tostring(serviceFunctions.systemTime()), "defend_" .. tostring(serviceFunctions.systemTime()), "defend_" .. tostring(serviceFunctions.systemTime()), "defend_" .. tostring(serviceFunctions.systemTime())
	self.defend, self.fields.Com_bg.setGradientColor.muSetMaxNum = self.fields.Com_bg.setGradientColor, 1
	self.editData = self.attack
	_ENV = tostring(serviceFunctions.systemTime())
	_ENV, _ENV, tostring(serviceFunctions.systemTime()).defaultClick = serviceFunctions.systemTime()
	serviceFunctions.systemTime().title = "进攻方"
	_ENV, self.tag[1], serviceFunctions.systemTime().tag = serviceFunctions.systemTime()
	serviceFunctions.systemTime().title = "防守方"
	tostring(serviceFunctions.systemTime()).tabsetArray, self.tag[2], serviceFunctions.systemTime().tag = self.tag, serviceFunctions.systemTime()
	tostring(serviceFunctions.systemTime()).callback = handler(self, self.onTabClick)
	self.fields.com_Tab:initView((tostring(serviceFunctions.systemTime())))
end
function CheatFightDemoPanel:onTabClick(tag)
	self.tag = tag
	self.editData = self.tag == 1 and self.attack or self.defend
	self:initView()
end
function CheatFightDemoPanel:initView(target, data)
	if data then
		self.settingList[data.tag].isOpen = data.isOpen
	end
	self.fields.List:setNumItems(#self.settingList)
end
function CheatFightDemoPanel:chooseBack(target, data)
	if data.style == 1 then
		if data.heroID then
			self.editData.heroList[data.index] = data.heroID
		else
			self.editData.heroList[data.index] = nil
			self.editData.heroWeapon[tostring(data.index)] = nil
			self.editData.viceHeroList[data.index] = nil
		end
		self.fields.List:setNumItems(#self.settingList)
	elseif data.style == 2 then
		if data.weaponID then
			_ENV = data.weaponID
			data.weaponID.id = data.index
			data.weaponID.exp = 0
			data.weaponID.lv = heroWeaponRead.getMaxLv()
			data.weaponID.stage = heroWeaponRead.getMaxStage()
			local data.weaponID.weaponID, weaponData = data.weaponID, data.weaponID
			self.editData.heroWeapon[tostring(data.index)] = weaponData
		else
			self.editData.heroWeapon[tostring(data.index)] = nil
		end
		self.fields.List:setNumItems(#self.settingList)
	elseif data.style == 3 then
		self.editData.viceHeroList[data.index] = data.heroID
		self.fields.List:setNumItems(#self.settingList)
	end
end
function CheatFightDemoPanel:biographyBack(target, data)
	if data.biographyIndex then
		self.editData.biographyIndex = data.biographyIndex
	end
	self.fields.List:setNumItems(#self.settingList)
end
function CheatFightDemoPanel:addArmyBack(target, data)
	if data.armyDataInfo then
		self.editData.armyDataInfo = data.armyDataInfo
		self.fields.List:setNumItems(#self.settingList)
		return
	end
	if data.muSetMaxNum then
		if self.tag == 1 then
			self.editData.muSetMaxNum = data.muSetMaxNum
			self.fields.List:setNumItems(#self.settingList)
		else
			SoraDShowMsgTip("每个小队数量只有进攻方的生效！")
		end
		return
	end
	local isMatch = false
	for k, v in ipairs(self.editData.armyDataInfo) do
		if v.id == data.id then
			v.num = data.value
			isMatch = true
			if data.value == 0 then
				table.remove(self.editData.armyDataInfo, k)
			end
			break
		end
	end
	if not isMatch and data.value > 0 then
		_ENV = ipairs(self.editData.armyDataInfo)
		ipairs(self.editData.armyDataInfo).id = data.id
		ipairs(self.editData.armyDataInfo).num = data.value
		table.insert(self.editData.armyDataInfo, ipairs(self.editData.armyDataInfo))
	end
	self.fields.List:setNumItems(#self.settingList)
end
function CheatFightDemoPanel:equipBack(target, data)
	if not self.editData.equipmentCfg then
		self.editData.equipmentCfg, _ENV = nil, nil
	end
	self.editData.equipmentCfg[tostring(data.part)] = data.equip
	self.fields.List:setNumItems(#self.settingList)
end
function CheatFightDemoPanel:buffBack(target, data)
	self.editData.buffMap = data.buffMap
	self.fields.List:setNumItems(#self.settingList)
end
function CheatFightDemoPanel:jinnBack(target, data)
	if not self.editData.jinnSkillCfg[data.jinnType] then
		self.editData.jinnSkillCfg[data.jinnType], _UPVALUE0_ = nil, nil
	end
	self.editData.jinnSkillCfg[data.jinnType][data.index] = data.skillData
	self.fields.List:setNumItems(#self.settingList)
end
function CheatFightDemoPanel:divineBack(target, data)
	if data.remove then
		self.editData.divineBeastList, _ENV = nil, nil
		return
	end
	if not self.editData.divineBeastList[tostring(data.divineID)] then
		self.editData.divineBeastList[tostring(data.divineID)], _ENV = data.divineID, data.divineID
	end
	self.editData.divineBeastList[tostring(data.divineID)].starLv = data.starLv
	self.editData.divineBeastList[tostring(data.divineID)].stepLv = data.stepLv
	self.editData.divineBeastList[tostring(data.divineID)].marchShow = true
	self.editData.divineBeastList[tostring(data.divineID)].state = self.tag == 1 and 3 or 2
	_UPVALUE3_ = tostring(data.divineID)
	self.editData.divineBeastList[tostring(data.divineID)].growLv, tostring(data.divineID)[1] = tostring(data.divineID), 10
	self.editData.divineBeastList[tostring(data.divineID)].growLv, tostring(data.divineID)[2] = tostring(data.divineID), 10
	self.editData.divineBeastList[tostring(data.divineID)].growLv, tostring(data.divineID)[3] = tostring(data.divineID), 10
	self.fields.List:setNumItems(#self.settingList)
end
function CheatFightDemoPanel:markBack(target, data)
	if not self.editData.beast[tostring(data.divineID)] then
		self.editData.beast[tostring(data.divineID)], _ENV = data.divineID, data.divineID
	end
	if data.cfg then
		local bagMarkId = self.bagMarkIdIdx
		self.bagMarkIdIdx = self.bagMarkIdIdx + 1
		local maxStar = divineBeastMarkRead.getStarByLv(data.cfg.lv)
		local maxLv = data.cfg.lv
		local randomElem = data.cfg.elem
		local randomBuff1 = data.cfg.buff1
		local randomBuff2 = data.cfg.buff2
		local mark = divineBeastMarkRead.sCombineKey(data.markID, maxLv, 0, randomElem, randomBuff1, randomBuff2, maxStar)
		self.editData.beastMarkBag[tostring(bagMarkId)] = mark
		self.editData.beast[tostring(data.divineID)][data.index] = bagMarkId
	elseif data.mark then
		local bagMarkId = self.bagMarkIdIdx
		self.bagMarkIdIdx = self.bagMarkIdIdx + 1
		self.editData.beast[tostring(data.divineID)][data.index] = bagMarkId
		self.editData.beastMarkBag[tostring(bagMarkId)] = data.mark
	else
		local bagMarkId = self.editData.beast[tostring(data.divineID)][data.index]
		self.editData.beastMarkBag[tostring(bagMarkId)] = nil
		self.editData.beast[tostring(data.divineID)][data.index] = 0
	end
	for i = 1, 6 do
		if not self.editData.beast[tostring(data.divineID)][i] then
			self.editData.beast[tostring(data.divineID)][i] = 0
		end
	end
	for k, v in pairs(self.editData.beastMarkBag) do
		local isIn = false
		for i = 1, 6 do
			local bagMarkId = self.editData.beast[tostring(data.divineID)][i]
			if bagMarkId == tonumber(k) then
				isIn = true
				break
			end
		end
		if not isIn then
			self.editData.beastMarkBag[k] = nil
		end
	end
	dump(self.editData.beastMarkBag, "markBack self.editData.beastMarkBag=====")
	dump(self.editData.beast, "markBack self.editData.beast=====")
	self.fields.List:setNumItems(#self.settingList)
end
function CheatFightDemoPanel:armsBack(target, data)
	self.editData.armsInfo[1] = data.armsID
	self.fields.List:setNumItems(#self.settingList)
end
function CheatFightDemoPanel:runeBack(target, data)
	self.editData.godArmsRune.runeList[data.index] = data.runeInfo
	self.fields.List:setNumItems(#self.settingList)
end
function CheatFightDemoPanel:mailBack(target, data)
	_UPVALUE1_ = nil
	;(nil)[1] = ffa.delay(2)
	;(nil)[2] = ffa.callFunc(function()
		local mail = gModuleMgr.sharedMgr("mailMgr"):queryMail(data.mailId)
		if mail then
			local panel = SoraDCreatePanel("mailItemDetailView")
			panel:show()
			panel:hideRightAndLeftBtn()
			panel:initWithData(mail, "key")
		end
	end)
	;(nil)[3] = ffa.callFunc(function()
		local mail = gModuleMgr.sharedMgr("mailMgr"):queryMail(data.mailId)
		if mail then
			local panel = SoraDCreatePanel("mailItemDetailView")
			panel:show()
			panel:hideRightAndLeftBtn()
			panel:initWithData(mail, "key")
		end
	end)
	self:runAction(ffa.seq(nil))
end
function CheatFightDemoPanel:btnFightClick()
	SoraDPlaySound()
	if #self.attack.armyDataInfo == 0 or #self.defend.armyDataInfo == 0 then
		SoraDShowMsgTip("双方士兵数据不能空!!")
		return
	end
	local times = math.min(self.maxCount, tonumber(self.input_count:getText()) or 1)
	local mnzdData = self:sortData()
	mnzdData.times = times
	if 1 < times then
		SoraDShowMsgTip("模拟战斗进行中，请稍等...")
	end
	cheatCtrl:reqMnzdBegin(mnzdData)
end
function CheatFightDemoPanel:sortData()
	self.attackClone = clone(self.attack)
	heroBiographyRead, self.defendClone = clone(self.defend), clone(self.defend)
	clone(self.defend)[1] = "attackClone"
	local clone(self.defend)[2], target = "defendClone", clone(self.defend)
	for _, player in ipairs(target) do
		self[player].heroInfo, _ENV = nil, nil
		for k, v in ipairs(self[player].heroList) do
			_ENV = nil
			;(nil).heroID = v
			;(nil).slaveHeroID = self[player].viceHeroList[k]
			table.insert(self[player].heroInfo, nil)
		end
		self[player].heroWeaponUID, _ENV = ipairs(self[player].heroList)
		for i, v in pairs(self[player].heroWeapon) do
			if v.weaponID then
				local heroID = self[player].heroList[tonumber(i)]
				local rarity = heroltCtrl:getHeroRarity(heroID)
				if rarity >= gHeroRarity.ORANGE then
					self[player].heroWeaponUID[tostring(heroID)] = tonumber(i)
				end
			end
		end
		self[player].biographyList, _ENV = pairs(self[player].heroWeapon)
		for k, v in pairs(self[player].biographyIndex) do
			if v then
				local retArray, mergeArray = heroBiographyRead.getStorySkillShowArray(tonumber(k), true)
				for _, cfg in ipairs(retArray) do
					self[player].biographyList[tostring(cfg.skillID)] = 1
				end
			end
		end
		self[player].equipment, _ENV = pairs(self[player].biographyIndex)
		if not self[player].equipmentCfg then
			_ENV = self[player].equipmentCfg
		end
		for part, v in pairs(self[player].equipmentCfg) do
			table.insert(self[player].equipment, v)
		end
		self[player].magicLampSkillList, _ENV = pairs(self[player].equipmentCfg)
		self[player].jinnList, _ENV = pairs(self[player].equipmentCfg)
		for jinnType, v in ipairs(self[player].jinnSkillCfg) do
			local maxJinnCfg = magicLampRead.getStrengthenCfg(jinnType)
			if not self[player].jinnList[tostring(jinnType)] then
				self[player].jinnList[tostring(jinnType)], _ENV = jinnType, jinnType
			end
			self[player].jinnList[tostring(jinnType)].power = 999
			self[player].jinnList[tostring(jinnType)].blessPoint = 0
			self[player].jinnList[tostring(jinnType)].lv = #maxJinnCfg
			self[player].jinnList[tostring(jinnType)].id = jinnType
			self[player].jinnList[tostring(jinnType)].classLv = maxJinnCfg[#maxJinnCfg].PreClass
			self[player].jinnList[tostring(jinnType)].starLv = magicLampRead.getMaxStar(jinnType)
			if not self[player].jinnList[tostring(jinnType)].skill then
				self[player].jinnList[tostring(jinnType)].skill, _ENV = tostring(jinnType), tostring(jinnType)
			end
			if not self[player].jinnList[tostring(jinnType)].blessList then
				self[player].jinnList[tostring(jinnType)].blessList, _ENV = tostring(jinnType), tostring(jinnType)
			end
			local blessCfgs = magicLampRead.getBlessMaxCfgs(jinnType)
			for k, cfg in pairs(blessCfgs) do
				_ENV = cfg.BlessID
				self[player].jinnList[tostring(jinnType)].blessList[tostring(cfg.BlessID)], cfg.BlessID.lv = cfg.BlessID, cfg.MaxLv
			end
			for _, skillData in ipairs(v) do
				self[player].jinnList[tostring(jinnType)].skill[tostring(skillData.id)] = tostring(skillData.bless)
				table.insert(self[player].magicLampSkillList, skillData)
			end
		end
		self[player].godArmsRune.newGodArmsRuneList, _ENV = ipairs(self[player].jinnSkillCfg)
		if self[player].armsInfo[1] then
			self[player].godArmsRune.newGodArmsRuneList[tostring(self[player].armsInfo[1])], _ENV = self[player].armsInfo[1], self[player].armsInfo[1]
			self[player].godArmsRune.newGodArmsRuneList[tostring(self[player].armsInfo[1])].group = 2
			self[player].godArmsRune.newGodArmsRuneList[tostring(self[player].armsInfo[1])].groupList, _ENV = tostring(self[player].armsInfo[1]), tostring(self[player].armsInfo[1])
			for i = 1, 4 do
				_ENV = tostring(self[player].armsInfo[1])
				self[player].godArmsRune.newGodArmsRuneList[tostring(self[player].armsInfo[1])].groupList[i], tostring(self[player].armsInfo[1]).detail, _ENV, tostring(self[player].armsInfo[1]).name = tostring(self[player].armsInfo[1]), self[player].armsInfo[1], self[player].armsInfo[1], ""
				for k, v in ipairs(self[player].godArmsRune.runeList) do
					self[player].godArmsRune.newGodArmsRuneList[tostring(self[player].armsInfo[1])].groupList[i].detail[tostring(k)] = v.uid
				end
			end
		end
	end
	_ENV, self.defendClone.muSetMaxNum = self.defendClone, self.attackClone.muSetMaxNum
	self.defendClone.attack = self.attackClone
	local self.defendClone.defend, mnzdData = self.defendClone, self.defendClone
	return mnzdData
end
function CheatFightDemoPanel:btnInDataClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).prompt = "fightDemo.json"
	;(nil).btnTitle = "导入"
	;(nil).handle = function(text)
		local fileName = string.len(text) > 0 and text or "fightDemo.json"
		local data = LocalLog:LogFightDemoIn(fileName)
		if data then
			local importData = json.decode(data)
			self.attack = importData.attack
			self.attack.userid = "attack_" .. tostring(serviceFunctions.systemTime())
			self.defend = importData.defend
			self.defend.userid = "defend_" .. tostring(serviceFunctions.systemTime())
			self.defend.muSetMaxNum = self.attack.muSetMaxNum
			self:onTabClick(self.tag)
		else
			SoraDShowMsgTip("暂无导入json文件:" .. fileName)
		end
	end
	uiManager:show("CheatCmdPop", nil)
end
function CheatFightDemoPanel:btnOutDataClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).prompt = "fightDemo.json"
	;(nil).btnTitle = "导出"
	;(nil).handle = function(text)
		local fileName = string.len(text) > 0 and text or "fightDemo.json"
		LocalLog:LogFightDemoOut(self:sortData(), fileName)
	end
	uiManager:show("CheatCmdPop", nil)
end
return CheatFightDemoPanel
