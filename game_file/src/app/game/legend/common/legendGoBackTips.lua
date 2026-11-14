local gametop = gModuleMgr.getObject("gametop")
local armyCtrl = gametop.playertop_:getModule("armyCtrl")
local armyLogic = include("armyLogic")
local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
local resDesRead = include("resDesRead")
local worldMapWarDef = include("worldMapWarDef")
local legendGoBackTips = class("legendGoBackTips", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("legendGoBackTips")
	end
	return target
end)
function legendGoBackTips:ctor()
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("free_team_text_26"))
	self.txtStatus = SoraDGetChildByName(self, "Text_status")
	self.txtStatus:setString(i18n("free_team_text_27"))
	self.txtTips1 = SoraDGetChildByName(self, "Text_hospital_tip1")
	self.txtTips2 = SoraDGetChildByName(self, "Text_hospital_tip2")
	self.txtTips2:setString(i18n("free_team_text_31"))
	self.txtTitleWorld = SoraDGetChildByName(self, "Text_scroll_title_world")
	self.txtTitleNormal = SoraDGetChildByName(self, "Text_scroll_title_normal")
	self.txtTitleNormal:setString(i18n("free_team_text_30"))
	self.txtTitle = SoraDGetChildByName(self, "Text_score_title")
	self.txtTitle:setString(i18n("free_team_text_29"))
	self.txtProgressTitle = SoraDGetChildByName(self, "Text_progress")
	self.loadingBar = SoraDGetChildByName(self, "LoadingBar_progress")
	self.btnBack = SoraDGetChildByName(self, "Button_back")
	self.btnBack:setTitleText(i18n("common_text_4256"))
	self.btnBack:addTouchEventListener(handler(self, self.onBackClick))
	self.btnHospital = SoraDGetChildByName(self, "Button_hospital")
	self.btnHospital:setTitleText(i18n("free_team_text_32"))
	self.btnHospital:addTouchEventListener(handler(self, self.onHospicalClick))
	SoraDAutoSizeButtonText(self.btnBack)
	SoraDAutoSizeButtonText(self.btnHospital)
	self.single = SoraDGetChildByName(self, "Node_single")
	self.single:setVisible(false)
	self.scroll = SoraDGetChildByName(self, "ScrollView_list")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCreate(handler(self, self.createSingle))
	self.scroll:setSingleRefresh(handler(self, self.initSingle))
	if worldMapDefine.isInNebulaEmperor() then
		self.txtTips1:setString(i18n("nebulaemperor_text_71"))
		self.txtTitleWorld:setString(i18n("nebulaemperor_text_72"))
	elseif worldMapDefine.isKingStarMapId(gametop.playertop_:getMapID()) then
		self.txtTips1:setString(i18n("kingstarbattle_text_38"))
		self.txtTitleWorld:setString(i18n("kingstarbattle_text_20"))
	else
		self.txtTips1:setString(i18n("free_team_text_28"))
		self.txtTitleWorld:setString(i18n("common_text_4244"))
	end
	self:initData()
end
function legendGoBackTips:setHandle(handle)
	self._handle = handle
end
function legendGoBackTips:initData(target, data)
	self:initArmyData()
	self:initScroll()
	self:initProgressBar()
end
function legendGoBackTips:initArmyData()
	local tmpArmyData = armyCtrl:getWoundedArmy()
	local woundedArmyList = kingdomMapCtrl.kingdomMapCell:getAllQueueWoundedArmy()
	local curingArmyData = armyCtrl:getCuringArmy()
	local allnum = 0
	local transList = function(list, reTbl)
		if not list and next(list) == nil then
			return reTbl
		end
		local keys = table.keys(list)
		table.sort(keys)
		for _, v in ipairs(keys) do
			local num = tonumber(list[v])
			local oldNum = reTbl[v] or 0
			reTbl[v] = oldNum + num
		end
		return reTbl
	end
	local transList_del = function(list, reTbl)
		if not list and next(list) == nil then
			return reTbl
		end
		local keys = table.keys(list)
		table.sort(keys)
		for _, v in ipairs(keys) do
			local num = tonumber(list[v])
			local oldNum = reTbl[v] or 0
			reTbl[v] = oldNum - num
		end
		return reTbl
	end
	local armyCtrl, reTbl
	reTbl = transList(tmpArmyData, reTbl)
	reTbl = transList(woundedArmyList, reTbl)
	reTbl = transList_del(curingArmyData, reTbl)
	self.tableHospitalData = reTbl
	self.allnum = allnum
	self:initArmyCostAndTime()
end
function legendGoBackTips:initArmyCostAndTime()
	self.armyCostTime, _ENV, self.armyCostRes, _ENV = nil, nil, nil, nil
	for id, _ in pairs(self.tableHospitalData) do
		_ENV = nil
		;(nil).normal = armyLogic.getArmyCureTime(id, true)
		self.armyCostTime[id], (nil).world = nil, armyLogic.getArmyCureTime(id)
		_ENV = nil
		;(nil).normal = armyLogic.getArmyCureCostRes(id, true)
		self.armyCostRes[id], (nil).world = nil, armyLogic.getArmyCureCostRes(id)
	end
end
function legendGoBackTips:initScroll()
	local _ENV, tmpResTblNormal
	local _ENV, tmpResTblWorld
	local healTimeNormal = 0
	local healTimeWorld = 0
	for id, num in pairs(self.tableHospitalData) do
		local constTime = self.armyCostTime[id]
		if 0 < num then
			if constTime then
				healTimeWorld = healTimeWorld + constTime.world * num
				healTimeNormal = healTimeNormal + constTime.normal * num
			end
			local constRes = self.armyCostRes[id]
			if constRes then
				for _, val in pairs(constRes.world) do
					if not tmpResTblWorld[val.resid] then
						tmpResTblWorld[val.resid] = 0
					end
					tmpResTblWorld[val.resid] = tmpResTblWorld[val.resid] + val.rescount * num
				end
				for _, val in pairs(constRes.normal) do
					if not tmpResTblNormal[val.resid] then
						tmpResTblNormal[val.resid] = 0
					end
					tmpResTblNormal[val.resid] = tmpResTblNormal[val.resid] + val.rescount * num
				end
			end
		end
	end
	if SoraDIsBrave8Level() then
		tmpResTblWorld = armyLogic.cureWoundedArmyResTransfer(tmpResTblWorld)
	end
	_UPVALUE5_ = armyLogic.cureWoundedArmyResTransfer(tmpResTblWorld)
	armyLogic.cureWoundedArmyResTransfer(tmpResTblWorld)[1] = gIDDef.WOOD
	armyLogic.cureWoundedArmyResTransfer(tmpResTblWorld)[2] = gIDDef.FOOD
	armyLogic.cureWoundedArmyResTransfer(tmpResTblWorld)[3] = gIDDef.IRON
	armyLogic.cureWoundedArmyResTransfer(tmpResTblWorld)[4] = gIDDef.MITHRIL
	local armyLogic.cureWoundedArmyResTransfer(tmpResTblWorld)[5], tableKey = gIDDef.CRYSTAL, armyLogic.cureWoundedArmyResTransfer(tmpResTblWorld)
	if SoraDIsBrave8Level() then
		table.insert(tableKey, gIDDef.METEOR_CRYSTAL)
		table.insert(tableKey, gIDDef.LEGEND_CRYSTAL)
		table.insert(tableKey, gIDDef.NEBULA_CRYSTAL)
	end
	self.list, _ENV = table.insert, table.insert
	for i, v in ipairs(tableKey) do
		local constWorld = tmpResTblWorld[v] or 0
		local constNormal = tmpResTblNormal[v] or 0
		if 0 < constWorld or 0 < constNormal then
			_ENV = nil
			;(nil).index = i
			;(nil).resid = v
			;(nil).constWorld = constWorld
			;(nil).constNormal = constNormal
			table.insert(self.list, nil)
		end
	end
	_ENV = ipairs(tableKey)
	ipairs(tableKey).index = #self.list + 1
	ipairs(tableKey).constWorld = healTimeWorld
	ipairs(tableKey).constNormal = healTimeNormal
	table.insert(self.list, ipairs(tableKey))
	_ENV = 0
	;(0).view = self
	self.scroll:updateScrollView(cc.size(536, 70), self.list, 1, 0)
end
function legendGoBackTips:initProgressBar()
	local woundedCount = self.allnum or 0
	local total = armyLogic:getHostpitalMaxCapacity().total
	self.txtProgressTitle:setString(tostring(woundedCount) .. "/" .. tostring(total))
	self.loadingBar:setPercent(woundedCount / total * 100)
end
function legendGoBackTips:createSingle(info)
	local single = self.single:clone()
	single:setVisible(true)
	return single
end
function legendGoBackTips:initSingle(target, info)
	local txtWorld = SoraDGetChildByName(target, "Text_value_new")
	local txtNormal = SoraDGetChildByName(target, "Text_value_old")
	if info.resid then
		local constWorld = SoraDPreciseDecimal(info.constWorld, 1)
		txtWorld:setString(SoraDConvertNumberWithUnit(constWorld))
		local constNormal = SoraDPreciseDecimal(info.constNormal, 1)
		txtNormal:setString(SoraDConvertNumberWithUnit(constNormal))
		local spriteRes = SoraDGetChildByName(target, "Sprite_res")
		local resImg = resDesRead.getIcon(info.resid)
		spriteRes:setSpriteFrame(resImg)
		if info.resid ~= gIDDef.METEOR_CRYSTAL and worldMapWarDef.checkIsWarCrystalID(info.resid) then
			spriteRes:setScale(30 / spriteRes:getContentSize().width)
		end
	else
		local spriteRes = SoraDGetChildByName(target, "Sprite_res")
		spriteRes:setSpriteFrame("icon_hourglass.png")
		txtWorld:setString(SoraDConvertSecondToString(math.ceil(info.constWorld)))
		txtNormal:setString(SoraDConvertSecondToString(math.ceil(info.constNormal)))
	end
	local bg = SoraDGetChildByName(target, "img_bg_item")
	bg:setVisible(info.index % 2 == 1)
end
function legendGoBackTips:onBackClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self._handle then
			self._handle(button, type)
		end
		self:removeFromParent()
	end
end
function legendGoBackTips:onHospicalClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local woundedCount = armyCtrl:getTotalWoundedArmyCount()
		local curingNum = armyCtrl:getCuringArmyCount() or 0
		if 0 < curingNum then
			SoraDShowMsgTip(i18n("common_text_768"))
		elseif 0 < woundedCount and 0 < woundedCount - curingNum then
			uiManager:show("HospitalView"):setLV()
		elseif kingdomMapCtrl.kingdomMapCell:hasWoundedQueueArmy() then
			SoraDShowMsgTip(i18n("free_team_text_79"))
		end
		self:removeFromParent()
	end
end
return legendGoBackTips
