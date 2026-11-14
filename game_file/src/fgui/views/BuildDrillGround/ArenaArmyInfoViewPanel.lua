local arenaCtrl = SoraDGetCtrl("arenaCtrl")
local arenaltCtrl = include("arenaltCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local ArenaArmyInfoViewPanel = class("ArenaArmyInfoViewPanel", baseFguiPanel)
function ArenaArmyInfoViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("ArenaArmyInfoViewPanel:ctor", self.viewName)
	self.attributeData, _ENV, self.myArmyAttributeData, _ENV, self.isOwn = print, print, print, print, false
end
function ArenaArmyInfoViewPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "BuildWatchTower"
	end
	return self._packageList
end
function ArenaArmyInfoViewPanel:onInit()
	print("=======ArenaArmyInfoViewPanel:onInit")
	self.fields.Panel_bg:setString(i18n("common_text_019"))
	self.fields.List_attr:setItemRenderer(handler(self, self.onAttrItemRenderer))
	self.fields.List_attr:setVirtual()
	_ENV = handler(self, self.onAttrItemRenderer)
	_ENV, _ENV, handler(self, self.onAttrItemRenderer).defaultClick = handler(self, self.onAttrItemRenderer)
	_ENV, handler(self, self.onAttrItemRenderer)[1], handler(self, self.onAttrItemRenderer).title = handler(self, self.onAttrItemRenderer)
	handler(self, self.onAttrItemRenderer).tabsetArray, handler(self, self.onAttrItemRenderer)[2], handler(self, self.onAttrItemRenderer).title = handler(self, self.onAttrItemRenderer)
	handler(self, self.onAttrItemRenderer).callback = handler(self, self.onClickTab)
	self.fields.com_TabW:initView(handler(self, self.onAttrItemRenderer))
	if not SoraDFIsRA() then
		_UPVALUE4_ = self.fields.com_TabW
		self.fields.com_TabW[1] = self.fields.Com_head
		self.fields.com_TabW[2] = self.fields.Text_lordName
		self.fields.com_TabW[3] = self.fields.Text_lordForce
		self.fields.com_TabW[4] = self.fields.Text_lordCastelLv
		for i, v in ipairs(self.fields.com_TabW) do
			v:fixPos()
		end
	end
end
function ArenaArmyInfoViewPanel:onShow()
	print("=======ArenaArmyInfoViewPanel:onShow")
	local param = self.param
	self:initData(param.lordInfo, param.armyList, param.armyBuff, param.battleType, param.isOwn)
end
function ArenaArmyInfoViewPanel:onClickTab(tag)
	self.controllers.c1:setSelectedIndex(tag - 1)
	if tag == 2 then
		self:initAttribute()
	end
end
function ArenaArmyInfoViewPanel:initAttributeData(target, data)
	if not data.akPlus then
		_ENV = data.akPlus
	end
	self.myArmyAttributeData.akPlus = data.akPlus
	if not data.dfPlus then
		_ENV = data.dfPlus
	end
	self.myArmyAttributeData.dfPlus = data.dfPlus
	if not data.hpPlus then
		_ENV = data.hpPlus
	end
	_ENV, _ENV, self.myArmyAttributeData.hpPlus = data.hpPlus, self.myArmyAttributeData, data.hpPlus
	data.hpPlus.archer = "common_text_1315"
	data.hpPlus.infantry = "common_text_1313"
	data.hpPlus.cavalry = "common_text_1314"
	data.hpPlus.charists = "common_text_1316"
	_ENV, self.myArmyAttributeData.akPlus, data.hpPlus.elite = data.hpPlus, data.hpPlus, "common_text_3238"
	data.hpPlus.archer = "common_text_1319"
	data.hpPlus.infantry = "common_text_1317"
	data.hpPlus.cavalry = "common_text_1318"
	data.hpPlus.charists = "common_text_1320"
	_ENV, self.myArmyAttributeData.dfPlus, data.hpPlus.elite = data.hpPlus, data.hpPlus, "common_text_3239"
	data.hpPlus.archer = "common_text_1323"
	data.hpPlus.infantry = "common_text_1321"
	data.hpPlus.cavalry = "common_text_1322"
	data.hpPlus.charists = "common_text_1324"
	_UPVALUE3_, self.attributeData, _ENV, self.myArmyAttributeData.hpPlus, data.hpPlus.elite = data.hpPlus, data.hpPlus, data.hpPlus, data.hpPlus, "common_text_3240"
	local plusConfig = self.myArmyAttributeData
	_UPVALUE5_, data.hpPlus[1] = "akPlus", "akPlus"
	_UPVALUE5_, data.hpPlus[2] = "akPlus", "dfPlus"
	local _UPVALUE5_, data.hpPlus[3], attributeList = "akPlus", "hpPlus", data.hpPlus
	;("akPlus")[1] = "infantry"
	;("akPlus")[2] = "cavalry"
	;("akPlus")[3] = "archer"
	;("akPlus")[4] = "charists"
	local ("akPlus")[5], armyList = "elite", "akPlus"
	for k, v in ipairs(attributeList) do
		for ki, vi in ipairs(armyList) do
			local name = plusConfig[v][vi]
			local value = self.myArmyAttributeData[v][vi]
			_ENV = nil
			;(nil).name = name
			;(nil).value = value
			table.insert(self.attributeData, nil)
		end
	end
end
function ArenaArmyInfoViewPanel:initData(lordInfo, armyList, armyBuff, battleType, isOwn)
	self.moduleInfo, arenaCtrl = nil, nil
	self.moduleInfo.lordInfo = lordInfo
	self.moduleInfo.armyList = armyList
	self.moduleInfo.armyBuff = armyBuff
	self.battleType = battleType
	self.isOwn = isOwn or false
	self:suitView()
	if self.isOwn then
		arenaCtrl:req4BattleInfo(self.battleType)
	end
	self:initView()
end
function ArenaArmyInfoViewPanel:suitView()
	self.controllers.c_isOwn:setSelectedIndex(self.isOwn and 0 or 1)
end
function ArenaArmyInfoViewPanel:initAttribute()
	if not self.isOwn then
		return
	end
	self.fields.List_attr:setNumItems(#self.attributeData)
end
function ArenaArmyInfoViewPanel:onAttrItemRenderer(index, obj)
	local data = self.attributeData[index + 1]
	if not obj._fields then
		obj._fields = fguiHelper.get_fields(obj)
		obj:fixChildrenPos()
	end
	local _fields = obj._fields
	_fields.Image_aBg:setVisible(index % 2 == 1)
	_fields.Text_attribute:setString(i18n(data.name))
	_fields.Text_value:setString(data.value / 10 .. "%")
end
function ArenaArmyInfoViewPanel:initView()
	self:setHead()
	local totalCount = self:setArmyList()
	_ENV = nil
	;(nil).count = totalCount
	self.fields.Text_totalArmyCount:setString(i18n("common_text_466", nil))
end
function ArenaArmyInfoViewPanel:setHead(...)
	local lordInfo = self.moduleInfo and self.moduleInfo.lordInfo
	if lordInfo then
		self.fields.Com_head:setHeadSprite(lordInfo.iconID, lordInfo.avatar)
		if not lordInfo.robotFlag and lordInfo.uid then
			self.fields.Com_head:setPlayerID(lordInfo.uid)
			self.fields.Com_head:setKid(lordInfo.kid)
		end
		local showName = arenaltCtrl.specialCreateName(lordInfo, self.battleType ~= gArenaBattleType.ARENA_LOCAL)
		self.fields.Text_lordName:setString(showName)
		arenaltCtrl = nil
		;(nil).pow = string.formatnumberthousands(lordInfo.fightCapacity)
		self.fields.Text_lordForce:setString(i18n("arena_columntext_04", nil))
		if lordInfo.castleLv then
			local buildLogic = include("buildLogic")
			local buildRead = include("buildDescribeRead")
			local bLevel = lordInfo.castleLv
			local warLv = buildLogic.transformBuildLvToWarLv(bLevel)
			if 0 < warLv then
				arenaltCtrl = i18n("arena_columntext_04", nil)
				i18n("arena_columntext_04", nil).build = buildRead.getName(BUILDID.CASTLE)
				i18n("arena_columntext_04", nil).lv = warLv
				self.fields.Text_lordCastelLv:setString(i18n("common_text_1957", i18n("arena_columntext_04", nil)))
			elseif bLevel > CASTLE_MAXLV_NOWAR then
				arenaltCtrl = i18n("common_text_1957", i18n("arena_columntext_04", nil))
				i18n("common_text_1957", i18n("arena_columntext_04", nil)).level = CASTLE_MAXLV_NOWAR
				self.fields.Text_lordCastelLv:setString(i18n("common_text_410", i18n("common_text_1957", i18n("arena_columntext_04", nil))))
			else
				arenaltCtrl = i18n("common_text_410", i18n("common_text_1957", i18n("arena_columntext_04", nil)))
				i18n("common_text_410", i18n("common_text_1957", i18n("arena_columntext_04", nil))).level = bLevel
				self.fields.Text_lordCastelLv:setString(i18n("common_text_410", i18n("common_text_410", i18n("common_text_1957", i18n("arena_columntext_04", nil)))))
			end
		else
			self.fields.Text_lordCastelLv:setString("")
		end
	end
end
function ArenaArmyInfoViewPanel:setArmyList(...)
	if not self.moduleInfo or not self.moduleInfo.lordInfo then
		local _ENV, lordInfo = self.moduleInfo.lordInfo, self.moduleInfo.lordInfo
	end
	local Com_armyDetail = self.fields.scroll:getChild("Com_armyDetail")
	_ENV = nil
	;(nil).heroInfo = lordInfo.heroInfo
	;(nil).armsInfo = lordInfo.armsInfo
	;(nil).divineBeastInfo = lordInfo.divineBeastInfo
	;(nil).army = self.moduleInfo.armyList
	Com_armyDetail:initMemberData(nil)
	local totoalCount = 0
	if self.moduleInfo and self.moduleInfo.armyList then
		for i, v in ipairs(self.moduleInfo.armyList) do
			totoalCount = totoalCount + v.num
		end
	end
	return totoalCount
end
return ArenaArmyInfoViewPanel
