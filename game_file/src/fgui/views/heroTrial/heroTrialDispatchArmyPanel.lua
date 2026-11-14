local queueTimeUtil = include("queueTimeUtil")
local buildLogic = include("buildLogic")
local resDesRead = include("resDesRead")
local cityEffectInfoRead = include("cityEffectInfoRead")
local htBattleMgr = include("htBattleMgr")
local buffCtrl = SoraDGetCtrl("buffCtrl")
local technologyCtrl = SoraDGetCtrl("technologyCtrl")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local armyCtrl = SoraDGetCtrl("armyCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local heroTrialDispatchArmyPanel = class("heroTrialDispatchArmyPanel", baseFguiPanel)
function heroTrialDispatchArmyPanel:ctor(...)
	self.isLRU = true
	heroTrialDispatchArmyPanel.super.ctor(self, ...)
	print("heroTrialDispatchArmyPanel:ctor", self.viewName)
end
function heroTrialDispatchArmyPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "CommonDispatch"
	end
	return self._packageList
end
function heroTrialDispatchArmyPanel:onInit()
	print("=======heroTrialDispatchArmyPanel:onInit")
	self.fields.Com_title:initData(i18n("common_text_481"), handler(self, self.onClickClose))
	self.fields.Text_autoTip:setString(i18n("common_text_1840"))
	self.fields.Text_autoTip:setVisible(false)
	self.fields.Text_notice:setString(i18n("common_text_858"))
	self.fields.Text_notice:setVisible(false)
	self.fields.Button_convene:setString(i18n("common_text_3616"))
	self.fields.Button_convene:addClickListener(handler(self, self.btnConveneClick))
	self.fields.Button_convene:setVisible(false)
	self.fields.Button_quick:setString(i18n("common_text_852"))
	self.fields.Button_quick:addClickListener(handler(self, self.btnQuickClick))
	self.fields.Button_go:setString(i18n("common_text_481"))
	self.fields.Button_go:addClickListener(handler(self, self.btnGoClick))
	self.fields.Com_count:setAddCallBack(handler(self, self.btnAddClick))
	self.fields.List_army:setItemRenderer(handler(self, self.onArmyRenderer))
	self.fields.Button_quick:fixPos()
	self.fields.Button_go:fixPos()
end
function heroTrialDispatchArmyPanel:onArmyRenderer(index, obj)
	obj:initData(self.tableArmy[index + 1], index + 1)
end
function heroTrialDispatchArmyPanel:endShow()
	print("=======heroTrialDispatchArmyPanel:endShow")
	self.isAuto = self.param.isAuto or false
	self.beginTile = self.param.beginTile
	self.tableArmy, _ENV, self.tableArmySingle, _ENV, self.countList, _ENV, self.endTile = self.param.endTile, self.param.endTile, self.param.endTile, self.param.endTile, self.param.endTile, self.param.endTile, self.param.endTile
	self.allCount = 0
	self.allowMaxCount = nil
	self.curCount = 0
	self.isSelectFull = false
	self:initData()
end
function heroTrialDispatchArmyPanel:initData()
	self.fields.Text_autoTip:setVisible(self.isAuto)
	self.allCount = buildLogic.getExpArmyCount().total
	self.curCount = 0
	if not htBattleMgr.getSoldiersList() then
		local buildLogic, soldiersList = htBattleMgr.getSoldiersList(), htBattleMgr.getSoldiersList()
	end
	for i, v in ipairs(soldiersList) do
		buildLogic = nil
		;(nil).armyid = v.id
		;(nil).armycount = tonumber(v.num)
		;(nil).curCount = 0
		table.insert(self.tableArmy, nil)
	end
	self.fields.Text_notice:setVisible(0 >= #self.tableArmy)
	self.fields.Button_convene:setVisible(0 >= #self.tableArmy)
	self.fields.List_army:setVisible(0 < #self.tableArmy)
	if 0 < #self.tableArmy then
		self:updateScrollList()
		self:quickChoose(true)
	end
	self:updateCount()
end
function heroTrialDispatchArmyPanel:updateScrollList()
	for __, v in ipairs(self.tableArmy) do
		v.sliderChangeHandle = handler(self, self.singleSliderChange)
	end
	self.fields.List_army:setNumItems(#self.tableArmy)
end
function heroTrialDispatchArmyPanel:updateCount()
	local tColor = buildLogic.getExpArmyCount().total > buildLogic.getExpArmyCount().unchangesize and "#70C723" or "#F0E6D2"
	buildLogic = nil
	;(nil).cur = self.curCount
	;(nil).total = fguiHelper.getColorString(tColor, self.allCount)
	self.fields.Com_count:setNum(i18n("%{cur}/%{total}", nil))
end
function heroTrialDispatchArmyPanel:singleSliderChange(target, data)
	self.curCount = 0
	for i, v in ipairs(self.tableArmy) do
		if v.armyid ~= data.armyid then
			self.curCount = self.curCount + v.curCount
		end
	end
	if self.curCount + data.armycount > self.allCount and 0 < data.armycount then
		data.armycount = self.allCount - self.curCount
		self.curCount = self.allCount
	else
		self.curCount = self.curCount + data.armycount
	end
	self.tableArmy[data.index].curCount = data.armycount
	local children = self.fields.List_army:getChildren()
	for k, v in ipairs(children) do
		if v.index == data.index then
			_ENV = nil
			;(nil).notBack = true
			v:setCurVal(data.armycount, nil)
			break
		end
	end
	self:updateCount()
	self.countList[data.index] = data.armycount
end
function heroTrialDispatchArmyPanel:calMarchTime(armyList)
	queueTimeUtil = nil
	;(nil).worldMapTipButtonType = worldMapDefine.worldMapTipButtonType_gongJi
	;(nil).lstArmy = armyList
	;(nil).fromPoint = self.beginTile
	;(nil).toPoint = self.endTile
	local speed = queueTimeUtil.getArmyBaseMoveSpeed(nil)
	local moveDistance = serviceFunctions.getMapDistance(self.beginTile.x, self.beginTile.y, self.endTile.x, self.endTile.y)
	local y = 1100 / (1100 + moveDistance)
	local baseTime = math.ceil(moveDistance * y / speed)
	local extraAdd = include("constantRead").getConstValue("HT_MARCH_BUFF") or 0
	local speedPlus = queueTimeUtil.getSpeedPlus()
	local allPlus = speedPlus * 1000 + extraAdd
	local ret = math.floor(baseTime * 1000 / (1000 + allPlus))
	return ret
end
function heroTrialDispatchArmyPanel:quickChoose(isFull)
	local children = self.fields.List_army:getChildren()
	if isFull then
		local totalCount = 0
		for i, v in ipairs(self.tableArmy) do
			local armyCount = v.armycount
			if totalCount + v.armycount > self.allCount then
				armyCount = self.allCount - totalCount
			end
			totalCount = totalCount + armyCount
			v.curCount = armyCount
			self.countList[i] = armyCount
		end
		for i, v in ipairs(children) do
			v:setCurVal(self.countList[v.index])
		end
		self.curCount = totalCount
	else
		for i, v in ipairs(self.tableArmy) do
			v.curCount = 0
			self.countList[i] = 0
		end
		for i, v in ipairs(children) do
			v:setCurVal(0)
		end
	end
	self.isSelectFull = isFull
end
function heroTrialDispatchArmyPanel:cityBuffAdd(target, data)
	if data.data and data.data.effectType == gBuffEffect.MARCH_LIMIT_BOOST then
		self.allCount = buildLogic.getExpArmyCount().total
		self:updateCount()
	end
end
function heroTrialDispatchArmyPanel:btnAddClick()
	SoraDPlaySound()
	local buffid = gBuffEffect.MARCH_LIMIT_BOOST
	local buffData = buffCtrl:queryCityBuff(buffid)
	_ENV = buffCtrl
	buffCtrl.bid = buffid
	buffCtrl.buffname = cityEffectInfoRead.getName(buffid)
	buffCtrl.bufdes = cityEffectInfoRead.getDes(buffid)
	local buffCtrl.buftip, tableBuff = cityEffectInfoRead.getTip(buffid), buffCtrl
	_ENV = nil
	;(nil).tableBuff = tableBuff
	uiManager:show("citybuffItemView", nil)
end
function heroTrialDispatchArmyPanel:btnConveneClick()
	SoraDPlaySound()
	SoraDCreatePanel("armyBuildingsView"):show()
end
function heroTrialDispatchArmyPanel:btnQuickClick()
	SoraDPlaySound()
	self:quickChoose(not self.isSelectFull)
end
function heroTrialDispatchArmyPanel:btnGoClick()
	SoraDPlaySound()
	local _ENV, armyList = SoraDPlaySound, SoraDPlaySound
	for i, v in ipairs(self.tableArmy) do
		if v.curCount > 0 then
			_ENV = nil
			;(nil).id = v.armyid
			;(nil).num = v.curCount
			table.insert(armyList, nil)
		end
	end
	if #armyList <= 0 then
		SoraDShowMsgBox(i18n("notice_0158"), i18n("common_text_204"))
	elseif self.isAuto then
		_ENV = i18n("notice_0158")
		i18n("notice_0158").msg = "MESSAGE_UI_HEROTRIAL_AUTOBATTLE"
		i18n("notice_0158").armyList = armyList
		SoraDSendMessage((i18n("notice_0158")))
	else
		_ENV = i18n("notice_0158")
		i18n("notice_0158").msg = "MESSAGE_UI_HEROTRIAL_ARMYGO"
		i18n("notice_0158").armyList = armyList
		SoraDSendMessage((i18n("notice_0158")))
	end
	self:close()
end
return heroTrialDispatchArmyPanel
