include("worldMapDefine")
include("worldMapFunction")
local queueTimeUtil = include("queueTimeUtil")
local gametop = gModuleMgr.getObject("gametop")
local buffCtrl = gametop.playertop_:getModule("buffCtrl")
local buildLogic = include("buildLogic")
local resDesRead = include("resDesRead")
local cityEffectInfoRead = include("cityEffectInfoRead")
local GridScrollView = include("GridScrollView")
local htBattleMgr = include("htBattleMgr")
local technologyCtrl = gametop.playertop_:getModule("technologyCtrl")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local HeroTrialDispatchArmy = class("heroTrialDispatchArmy", function(target)
	if target == nil then
		return SoraDCreateBasePanel("heroTrialDispatchArmy")
	end
	return target
end)
function HeroTrialDispatchArmy:ctor()
	self.isHideCurrentSceneView = true
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_title")
	self.nodeTitle:setTitle(i18n("common_text_481"))
	self.tableArmy, _ENV, self.tableArmySingle, _ENV, self.countList, _ENV, self.autoTip = SoraDGetChildByName(self, "autoTip"), SoraDGetChildByName(self, "autoTip"), SoraDGetChildByName(self, "autoTip"), SoraDGetChildByName(self, "autoTip"), SoraDGetChildByName(self, "autoTip"), SoraDGetChildByName(self, "autoTip"), SoraDGetChildByName(self, "autoTip")
	self.allCount = 0
	self.allowMaxCount = nil
	self.curCount = 0
	self.isSelectFull = false
	self.btnQuickChoose = SoraDGetChildByName(self, "Button_quick")
	self.btnQuickChoose:setTitleText(i18n("common_text_852"))
	self.btnGo = SoraDGetChildByName(self, "Button_go")
	self.labelNotice = SoraDGetChildByName(self, "Text_notice")
	self.labelNotice:setString(i18n("common_text_858"))
	self.autoTip:setString(i18n("common_text_1840"))
	self.btnCountPlus = SoraDGetChildByName(self, "Button_countPlus")
	self.btn_convene = SoraDGetChildByName(self, "Button_convene")
	self.btn_convene:setTitleText(i18n("common_text_3616"))
	self.labelCount = SoraDGetChildByName(self, "Text_count")
	self.labelTotal = SoraDGetChildByName(self, "Text_total")
	self.spriteCount = SoraDGetChildByName(self, "Sprite_count")
	self.labelTime = SoraDGetChildByName(self, "Text_time")
	self.labelTime:setString("00:00:00")
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_go")
	self.btnQuickChoose:addTouchEventListener(handler(self, self.btnQuickClickCallBack))
	self.btnGo:addTouchEventListener(handler(self, self.btnGoClickCallBack))
	self.btnCountPlus:addTouchEventListener(handler(self, self.btnCountPlusClickCallBack))
	self.btn_convene:addTouchEventListener(handler(self, self.btnConveneClickCallBack))
	SoraDGetChildByName(self, "Image_bg"):setFillType(1)
	self.labelGoTitle = SoraDGetChildByName(self, "Text_btnGoTitle")
	self.labelGoTitle:setString(i18n("common_text_481"))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_CITYBUFF_ADD", function(target, data)
		if data.data and data.data.effectType == 19 then
			if buildLogic.getExpArmyCount().total > buildLogic.getExpArmyCount().unchangesize then
				self.labelTotal:setColor(display.COLOR_GREEN)
			end
			self.allCount = buildLogic.getExpArmyCount().total
			self.labelTotal:setString(tostring(self.allCount))
		end
	end)
end
function HeroTrialDispatchArmy:initData(isAuto, beginTile, endTile)
	self.isAuto = isAuto
	self.beginTile = beginTile
	self.endTile = endTile
	if buildLogic.getExpArmyCount().total > buildLogic.getExpArmyCount().unchangesize then
		self.labelTotal:setColor(display.COLOR_GREEN)
	end
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
	self.labelNotice:setVisible(0 >= #self.tableArmy)
	self.btn_convene:setVisible(0 >= #self.tableArmy)
	self.labelCount:setString(tostring(self.curCount) .. "/")
	self.labelTotal:setString(tostring(self.allCount))
	self.nodeTitle:setTitle(i18n("common_text_481"))
	self.labelGoTitle:setString(i18n("common_text_481"))
	if isAuto then
		self.autoTip:setVisible(true)
	else
		self.autoTip:setVisible(false)
	end
	self:initScroll()
	self:quickChoose(true)
end
function HeroTrialDispatchArmy:onEnterPanel()
	self.scroll:updateNum(#self.tableArmy)
end
function HeroTrialDispatchArmy:btnConveneClickCallBack(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		print("召集士兵")
		SoraDCreatePanel("armyBuildingsView"):show()
	end
end
function HeroTrialDispatchArmy:btnCountPlusClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local buffid = 19
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
end
function HeroTrialDispatchArmy:updateMaxCount(maxCount)
	self.allowMaxCount = maxCount
	self.allCount = math.min(buildLogic.getExpArmyCount().total, self.allowMaxCount)
	if self.isSelectFull then
		self:quickChoose(self.isSelectFull)
	end
end
function HeroTrialDispatchArmy:initScroll()
	self.scroll:removeAllChildren()
	self.scroll = GridScrollView.new(self.scroll)
	GridScrollView = nil
	;(nil).col = 1
	;(nil).h = 20
	;(nil).left = 8
	self.scroll:init(nil, #self.tableArmy, function()
		return SoraDCreatePanel("worldDispatchArmySingle")
	end, function(cell, index)
		local count = self.countList[cell.idx]
		cell:initData(self.tableArmy[index])
		cell:setCurVal(count or 0)
		cell:setSliderChangeBack(handler(self, self.singleSliderChange))
	end)
end
function HeroTrialDispatchArmy:singleSliderChange(target, data)
	self.curCount = 0
	local curI = 1
	for i, v in ipairs(self.tableArmy) do
		if v.armyid == data.armyid then
			v.curCount = 0
			curI = i
		end
		self.curCount = self.curCount + v.curCount
	end
	if self.curCount + data.armycount > self.allCount and 0 < data.armycount then
		data.armycount = self.allCount - self.curCount
		target:setCurVal(data.armycount)
	else
		self.tableArmy[curI].curCount = data.armycount
		self.curCount = self.curCount + data.armycount
		self.labelCount:setString(tostring(self.curCount) .. "/")
		self.labelTotal:setString(tostring(self.allCount))
		self:updateMoveTime()
	end
	self.countList[target.idx] = data.armycount
end
function HeroTrialDispatchArmy:calMarchTime(armyList)
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
	local speedPlus = include("queueTimeUtil").getSpeedPlus()
	local allPlus = speedPlus * 1000 + extraAdd
	local ret = math.floor(baseTime * 1000 / (1000 + allPlus))
	return ret
end
function HeroTrialDispatchArmy:updateMoveTime()
	local _ENV, needGetList
	for i, v in ipairs(self.tableArmy) do
		if v.curCount > 0 then
			_ENV = nil
			;(nil).id = v.armyid
			;(nil).num = v.curCount
			table.insert(needGetList, nil)
		end
	end
	if 0 < #needGetList then
		local ret = math.ceil(self:calMarchTime(needGetList))
		self.labelTime:setString(SoraDConvertSecondToString(ret))
	else
		self.labelTime:setString(SoraDConvertSecondToString(0))
	end
end
function HeroTrialDispatchArmy:quickChoose(isFull)
	local children = self.scroll:getChildren()
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
		for i, v in pairs(children) do
			v:setCurVal(self.countList[v.idx])
		end
	else
		for i, v in ipairs(self.tableArmy) do
			v.curCount = 0
			self.countList[i] = 0
		end
		for i, v in pairs(children) do
			v:setCurVal(0)
		end
	end
	self.isSelectFull = isFull
end
function HeroTrialDispatchArmy:btnQuickClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:quickChoose(not self.isSelectFull)
	end
end
function HeroTrialDispatchArmy:btnGoClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
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
		self:close(button, type)
	end
end
return HeroTrialDispatchArmy
