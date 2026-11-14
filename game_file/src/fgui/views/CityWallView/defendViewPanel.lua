local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local wallsCtrl = SoraDGetCtrl("wallsCtrl")
local queueCtrl = SoraDGetCtrl("queueCtrl")
local shopCtrl = SoraDGetCtrl("shopCtrl")
local heroCtrl = SoraDGetCtrl("heroCtrl")
local armyCtrl = SoraDGetCtrl("armyCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local shopltCtrl = gModuleMgr.sharedMgr("shopltCtrl")
local cityBuildConstDef = include("cityBuildConstDef")
local cityWallConfig = include("cityWallConfig")
local worldMapDefine = include("worldMapDefine")
local quickBuildStoreID = IsArClient and 1000106 or 1000102
local quickBuildBackpackID = 502101
local QUICK_BUILD_WALL = shopltCtrl:getPrice(quickBuildStoreID)
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local defendViewPanel = class("defendViewPanel", baseFguiPanel)
function defendViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("defendViewPanel:ctor", self.viewName)
end
function defendViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function defendViewPanel:onInit()
	print("=======defendViewPanel:onInit")
	_ENV = "=======defendViewPanel:onInit"
	;("=======defendViewPanel:onInit").isHideMainUI = true
	SoraDHideCurrentSceneViewAndMainUI("=======defendViewPanel:onInit")
	self.burnNormalWallCount = 18
	self.burnPyramidWallCount = 1
	_UPVALUE4_, self.tableWall, _ENV, self.burnDevilWallCount = SoraDHideCurrentSceneViewAndMainUI, SoraDHideCurrentSceneViewAndMainUI, SoraDHideCurrentSceneViewAndMainUI, 100
	self.btnTreamArray, SoraDHideCurrentSceneViewAndMainUI[1] = SoraDHideCurrentSceneViewAndMainUI, 1
	self.btnTreamArray, SoraDHideCurrentSceneViewAndMainUI[2] = SoraDHideCurrentSceneViewAndMainUI, 2
	self.btnTreamArray, SoraDHideCurrentSceneViewAndMainUI[3] = SoraDHideCurrentSceneViewAndMainUI, 3
	self.btnTreamArray, SoraDHideCurrentSceneViewAndMainUI[4] = SoraDHideCurrentSceneViewAndMainUI, 4
	local selectIndex = armyCtrl:getActiveDefCompile()
	print("selectIndex=====", selectIndex)
	if selectIndex ~= 0 then
		self.selectIndex = selectIndex
	else
		self.selectIndex = 1
	end
	self.isInit = true
	self.fields.Com_title:initData(i18n("bulidDyf_title_1022"), handler(self, self.onClickClose))
	self.fields.Text_perfect:setString(i18n("common_text_392"))
	self.fields.Text_helpTip:setVisible(false)
	self.fields.List_troops:setItemRenderer(handler(self, self.onTeamRenderer))
	self.fields.Button_rename:addClickListener(handler(self, self.onClickBtnRename))
	self.fields.Button_help:addClickListener(handler(self, self.btnHelpClick))
	self.fields.Button_clear:setString(i18n("hero_text_72"))
	self.fields.Button_clear:addClickListener(handler(self, self.btnClearClick))
	self.fields.Button_ok:setString(i18n("cityDefense_formation_set_btn"))
	self.fields.Button_ok:addClickListener(handler(self, self.btnOkClick))
	self.Com_status = self.fields.Com_content:getChildByName("Com_status")
	self.Com_fireTime = self.fields.Com_content:getChildByName("Com_fireTime")
	self.fields.Button_help:fixPos()
	self.fields.Bar_green:fixPos()
	self.fields.Bar_green:setScaleX(SoraDFIsRA() and -1 or 1)
	self.fields.Bar_red:fixPos()
	self.fields.Bar_red:setScaleX(SoraDFIsRA() and -1 or 1)
	self.fields.Text_progress:fixPos()
	self.fields.Button_clear:fixPos()
	self.fields.Button_ok:fixPos()
end
function defendViewPanel:onTeamRenderer(index, obj)
	obj:initData(self.btnTreamArray[index + 1], self.selectIndex)
end
function defendViewPanel:onShow()
	print("=======defendViewPanel:onShow")
	self.defaultHeros = self.fields.heroBanner:exportHeros()
	_ENV = self.fields.heroBanner
	self.fields.heroBanner.msg = "MESSAGE_MAINCITYVIEW_OFFSET_BUILD"
	self.fields.heroBanner.offsetType = MAINCITYVIEW_OFFSET_TYPE_BUILD
	self.fields.heroBanner.scale = 1.0
	self.fields.heroBanner.xOffset = display.size.width * 0.5
	self.fields.heroBanner.yOffset = display.size.height - 230
	self.fields.heroBanner.buildIndex = cityBuildConstDef.buildIndexDef.index_wall
	SoraDSendMessage(self.fields.heroBanner)
	self.fields.heroBanner:setMode(gHeroSelectBannerStyle.defend)
	self.fields.heroBanner:setInnerSelectCallBack(handler(self, self.defendSelectBack))
	self.fields.heroBanner:setRemoveCallBack(handler(self, self.defendRemoveBack))
	self.fields.heroBanner:setArtifactUpdateCallBack(handler(self, self.defendSelectArmsBack))
	self.fields.heroBanner:setDivineBeastUpdateCallBack(handler(self, self.defendSelectDivineBeastBack))
	self.isInWar = worldMapDefine.isInPyramid()
	self.fields.line:setWidth(#self.btnTreamArray * 54 + (#self.btnTreamArray - 1) * 15 + 140)
	self:bindData()
	self:beginTime()
	self:setTream()
	self:changeCompileFun()
end
function defendViewPanel:beginTime()
	if self.timeHandler then
		SoraDManagerRemoveTimer(self, self.timeHandler)
		self.timeHandler = nil
	end
	self:updateTime()
	self.timeHandler = SoradCreateTimer(self, handler(self, self.updateTime))
end
function defendViewPanel:bindData()
	self.burnNormalWallCount = cityWallConfig.getIntervalOfDefence()
	self.burnPyramidWallCount = string.format("%.2f", 1 / cityWallConfig.getIntervalOfDefence())
	local defendVal = wallsCtrl:getMaxDefence()
	local defendCur = wallsCtrl:getCurDefence()
	local burningTime = wallsCtrl:getBurningTime()
	cityWallConfig = wallsCtrl
	wallsCtrl.burnTime = burningTime
	wallsCtrl.addDefendTime = 0
	wallsCtrl.defendVal = defendVal
	self.tableWall, wallsCtrl.defendCur = wallsCtrl, defendCur
	self.fields.Bar_red:setMax(defendVal)
	self.fields.Bar_green:setMax(defendVal)
	self:initData()
end
function defendViewPanel:initData()
	if self.tableWall.defendCur < self.tableWall.defendVal then
		self.controllers.c1:setSelectedIndex(1)
		self.fields.Bar_red:setValue(self.tableWall.defendCur)
		_ENV = nil
		;(nil).cur = string.formatnumberthousands(self.tableWall.defendCur)
		;(nil).max = string.formatnumberthousands(self.tableWall.defendVal)
		self.fields.Text_progress:setString(i18n("common_text_550", nil))
	else
		self.controllers.c1:setSelectedIndex(0)
		self.fields.Bar_green:setValue(self.tableWall.defendCur)
		_ENV = i18n("common_text_550", nil)
		i18n("common_text_550", nil).cur = string.formatnumberthousands(self.tableWall.defendCur)
		i18n("common_text_550", nil).max = string.formatnumberthousands(self.tableWall.defendVal)
		self.fields.Text_progress:setString(i18n("common_text_550", i18n("common_text_550", nil)))
	end
	self:defendValTest()
	self:updateTime()
	self.controllers.c2:setSelectedIndex(0)
end
function defendViewPanel:updateData(target, data)
	local redata = data.data
	if redata then
		wallsCtrl = nil
		;(nil).burnTime = redata.burningTime
		;(nil).defendVal = redata.maxDefence
		self.tableWall, (nil).defendCur = nil, redata.defence
	end
	self.tableWall.burningTime = wallsCtrl:getBurningTime()
	self.tableWall.defendCur = wallsCtrl:getCurDefence()
	self.tableWall.defendVal = wallsCtrl:getMaxDefence()
	self:initData()
end
function defendViewPanel:updateTime()
	self.queueDefence = queueCtrl:queryQueue(gQueueTypeDef.walls_defence)
	self.queueFire = queueCtrl:queryQueue(gQueueTypeDef.walls_burn)
	if self.queueDefence then
		local defenceTime = self.queueDefence.timerNode.timer:getRemainTime()
		self.tableWall.addDefendTime = defenceTime
		self.Com_status:setDefenceTime(SoraDConvertSecondToString(defenceTime))
		self:addDefendTest()
	else
		self.tableWall.addDefendTime = 0
		self:addDefendTest()
	end
	if self.queueFire then
		local fireTime = wallsCtrl:getBurningTime()
		self.tableWall.burnTime = fireTime
		if 3600 < fireTime then
			queueCtrl = SoraDConvertSecondToString(defenceTime)
			SoraDConvertSecondToString(defenceTime).count = tostring(math.floor(fireTime / 3600))
			if i18n("common_text_552", SoraDConvertSecondToString(defenceTime)) then
				goto lbl_70
			end
		end
		queueCtrl = SoraDConvertSecondToString(defenceTime)
		SoraDConvertSecondToString(defenceTime).count = tostring(math.ceil(fireTime / 60))
		local burnTime = i18n("common_text_445", SoraDConvertSecondToString(defenceTime))
		::lbl_70::
		queueCtrl = math.ceil(fireTime / 60)
		math.ceil(fireTime / 60).time = burnTime
		self.Com_fireTime:setBurnContent(i18n("common_text_389", math.ceil(fireTime / 60)))
		self:burnTest()
		self:defendValTest(true)
	else
		self.tableWall.burnTime = 0
		self:burnTest()
	end
end
function defendViewPanel:addDefendTest()
	self.Com_status:initData(self.tableWall)
	if self.tableWall.defendCur < self.tableWall.defendVal and self.tableWall.burnTime <= 0 then
		self.fields.Text_helpTip:setString(i18n("common_text_396"))
		self.fields.Text_helpTip:setVisible(true)
	end
end
function defendViewPanel:defendValTest(boolean)
	if self.tableWall.defendCur < self.tableWall.defendVal then
		self.controllers.c1:setSelectedIndex(1)
	else
		self.controllers.c1:setSelectedIndex(0)
		self.fields.Text_helpTip:setVisible(false)
	end
	if boolean then
		self.controllers.c1:setSelectedIndex(1)
		self.fields.Text_helpTip:setString(i18n("common_text_394"))
	end
	if self.controllers.c1:getSelectedIndex() == 1 then
		self.Com_fireTime:isShowPyramidText(self.isInWar)
	end
end
function defendViewPanel:burnTest()
	self.Com_fireTime:initData(self.tableWall)
	if self.tableWall.burnTime > 0 then
		self.fields.Text_helpTip:setString(i18n("common_text_394"))
		self.fields.Text_helpTip:setVisible(true)
		self.Com_status:setBurnStr(i18n("common_text_399"), 1)
		_ENV = i18n("common_text_399")
		i18n("common_text_399").count = 1
		i18n("common_text_399").time = self.burnNormalWallCount
		local defendStr = i18n("common_text_390", (i18n("common_text_399")))
		if worldMapDefine.isInNewTrial() then
			_ENV = self.burnNormalWallCount
			self.burnNormalWallCount.count = self.burnDevilWallCount
			self.burnNormalWallCount.time = 1
			defendStr = i18n("common_text_390", self.burnNormalWallCount)
		elseif self.isInWar then
			_ENV = self.burnNormalWallCount
			self.burnNormalWallCount.count = self.burnPyramidWallCount
			self.burnNormalWallCount.time = 1
			defendStr = i18n("common_text_390", self.burnNormalWallCount)
		end
		self.Com_status:setDefendStr(defendStr)
	else
		self.fields.Text_helpTip:setVisible(false)
		self.Com_status:setBurnStr(i18n("common_text_400"), 0)
	end
end
function defendViewPanel:defendSelectBack(heros)
	self.controllers.c2:setSelectedIndex(0)
end
function defendViewPanel:defendRemoveBack(heroID)
	self.controllers.c2:setSelectedIndex(0)
end
function defendViewPanel:defendSelectArmsBack()
	self.controllers.c2:setSelectedIndex(0)
end
function defendViewPanel:defendSelectDivineBeastBack()
	self.controllers.c2:setSelectedIndex(0)
end
function defendViewPanel:defendHerosChange()
	self.fields.heroBanner:setMode(gHeroSelectBannerStyle.defend)
end
function defendViewPanel:defendSetSuccessCallBack()
	SoraDCloseLoading(self)
end
function defendViewPanel:setTream()
	self.fields.List_troops:setNumItems(#self.btnTreamArray)
end
function defendViewPanel:updateTream()
	self.defCompileInfo = clone(armyCtrl:getDefCompile(self.selectIndex))
	dump(self.defCompileInfo, "self.defCompileInfo")
	local _ENV, heroList = dump, dump
	if not self.defCompileInfo.heroList then
		_ENV = self.defCompileInfo.heroList
	end
	for _, v in ipairs(self.defCompileInfo.heroList) do
		if heroCtrl:getHeroInfoByID(v.heroID) then
			table.insert(heroList, v)
		end
	end
	local heroIDList, lieutenantList = heroCtrl:getHeroAndLieutenant(heroList)
	armyCtrl = table.insert
	table.insert[1] = self.defCompileInfo.armsID or 0
	self.fields.heroBanner:initHeros(heroIDList, table.insert, nil, lieutenantList, self.defCompileInfo.divineBeastList)
end
function defendViewPanel:changeCompileFun(index)
	self.selectIndex = index or self.selectIndex
	local defCompileInfo = clone(armyCtrl:getDefCompile(self.selectIndex))
	if defCompileInfo and next(defCompileInfo) then
		armyCtrl:activeDefendCompile(self.selectIndex, self.isInit)
	else
		local heroIDList, lieutenantList = heroCtrl:getHeroAndLieutenant(defCompileInfo.heroList)
		armyCtrl = armyCtrl:getDefCompile(self.selectIndex)
		armyCtrl:getDefCompile(self.selectIndex)[1] = defCompileInfo.armsID or 0
		self.fields.heroBanner:initHeros(heroIDList, armyCtrl:getDefCompile(self.selectIndex))
	end
	self:setTream()
	self.controllers.c2:setSelectedIndex(1)
	self.isInit = false
end
function defendViewPanel:treamSelect(target, data)
	if self.selectIndex == data.index then
		return
	end
	local changeCompile = function()
		self:changeCompileFun(data.index)
	end
	local tmp_defCompileInfo = clone(armyCtrl:getDefCompile(self.selectIndex))
	local ser_heroList, ser_lieutenantList = heroCtrl:getHeroAndLieutenant(tmp_defCompileInfo.heroList)
	local cur_info_heroList = self.fields.heroBanner:exportHeros()
	local cur_info_lieutenantList = self.fields.heroBanner:exportLieutenant()
	local cur_info_arms = self.fields.heroBanner:exportArms()
	local cur_info_divineBeastList = self.fields.heroBanner:exportDivineBeast()
	self.ret_change = false
	for k, v in ipairs(cur_info_heroList) do
		local index = table.keyof(ser_heroList, v)
		local setLieu = ser_lieutenantList[index]
		local curLieu = cur_info_lieutenantList[tostring(v)]
		if not index then
			self.ret_change = true
			break
		elseif setLieu ~= curLieu then
			self.ret_change = true
			break
		end
	end
	if #cur_info_heroList ~= #ser_heroList and (0 < #cur_info_heroList or 0 < #ser_heroList) then
		self.ret_change = true
	end
	if not SoraDisInList(tmp_defCompileInfo.armsID or 0, cur_info_arms) then
		self.ret_change = true
	end
	local divineID = tmp_defCompileInfo.divineBeastList and tmp_defCompileInfo.divineBeastList[1] or 0
	local curDivineID = cur_info_divineBeastList[1] or 0
	if divineID ~= curDivineID then
		self.ret_change = true
	end
	if self.ret_change then
		print("--有变动")
		SoraDShowMsgBox(i18n("cityDefense_formation_set_sure_desc"), i18n("common_text_204"), i18n("common_text_185"), function(callType)
			if callType == MSGBOX_CALLBACK_YES then
				self:setDefendCompileInfo()
				changeCompile()
			elseif callType == MSGBOX_CALLBACK_NO then
				changeCompile()
			end
		end)
	else
		changeCompile()
	end
end
function defendViewPanel:setDefendCompileInfo(...)
	local armsID = self.fields.heroBanner:getArm()
	local heroList = self.fields.heroBanner:exportNewHeros()
	local divineBeastList = self.fields.heroBanner:exportDivineBeast()
	local compileName = armyCtrl:getDefendCompileName(self.selectIndex)
	armyCtrl:setDefendCompileInfo(self.selectIndex, armsID, heroList, divineBeastList, compileName)
end
function defendViewPanel:btnOkClick()
	SoraDPlaySound()
	self:setDefendCompileInfo()
	self.controllers.c2:setSelectedIndex(1)
end
function defendViewPanel:btnClearClick()
	SoraDPlaySound()
	self.fields.heroBanner:clearHerosAndArms()
end
function defendViewPanel:btnHelpClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).time = WALL_FIRE_TIME
	;(nil).count = WALL_DEFEND_MOVE_VALUE
	SoraDShowHelpMsgTip(i18n("common_text_393", nil))
end
function defendViewPanel:onClickBtnRename()
	SoraDPlaySound()
	_ENV = nil
	;(nil).setID = self.selectIndex
	;(nil).renameType = 9
	uiManager:show("lordEquipRename", nil)
end
function defendViewPanel:closePanel()
	local superClosePanel = include("basePanel").closePanel
	local tmp_defCompileInfo = clone(armyCtrl:getDefCompile(self.selectIndex))
	local ser_heroList, ser_lieutenantList = heroCtrl:getHeroAndLieutenant(tmp_defCompileInfo.heroList)
	local cur_info_heroList = self.fields.heroBanner:exportHeros()
	local cur_info_lieutenantList = self.fields.heroBanner:exportLieutenant()
	local cur_info_arms = self.fields.heroBanner:exportArms()
	local cur_info_divineBeast = self.fields.heroBanner:exportDivineBeast()
	self.ret_change = false
	for k, v in ipairs(cur_info_heroList) do
		local index = table.keyof(ser_heroList, v)
		local setLieu = ser_lieutenantList[index]
		local curLieu = cur_info_lieutenantList[tostring(v)]
		if not index then
			self.ret_change = true
			break
		elseif setLieu ~= curLieu then
			self.ret_change = true
			break
		end
	end
	if #cur_info_heroList ~= #ser_heroList and (0 < #cur_info_heroList or 0 < #ser_heroList) then
		self.ret_change = true
	end
	if not SoraDisInList(tmp_defCompileInfo.armsID or 0, cur_info_arms) then
		self.ret_change = true
	end
	local divineID = tmp_defCompileInfo.divineBeastList and tmp_defCompileInfo.divineBeastList[1] or 0
	local curDivineID = cur_info_divineBeast[1] or 0
	if divineID ~= curDivineID then
		self.ret_change = true
	end
	local changeCompile = function()
		local defCompileInfo = clone(armyCtrl:getDefCompile(self.selectIndex))
		if defCompileInfo and next(defCompileInfo) then
			armyCtrl:activeDefendCompile(self.selectIndex)
		else
			local heroIDList, lieutenantList = heroCtrl:getHeroAndLieutenant(defCompileInfo.heroList)
			armyCtrl = armyCtrl:getDefCompile(self.selectIndex)
			armyCtrl:getDefCompile(self.selectIndex)[1] = defCompileInfo.armsID or 0
			self.fields.heroBanner:initHeros(heroIDList, armyCtrl:getDefCompile(self.selectIndex))
		end
		self.controllers.c2:setSelectedIndex(1)
	end
	if self.ret_change then
		SoraDShowMsgBox(i18n("cityDefense_formation_set_sure_desc"), i18n("common_text_204"), i18n("common_text_185"), function(callType)
			if tolua.isnull(self) then
				return
			end
			if callType == MSGBOX_CALLBACK_YES then
				self:setDefendCompileInfo()
				changeCompile()
				superClosePanel(self)
			elseif callType == MSGBOX_CALLBACK_NO then
				changeCompile()
			end
		end)
	else
		superClosePanel(self)
	end
end
function defendViewPanel:onHide()
	if self.timeHandler then
		SoraDManagerRemoveTimer(self, self.timeHandler)
		self.timeHandler = nil
	end
	_ENV = self
	self.isHideMainUI = false
	SoraDHideCurrentSceneViewAndMainUI(self)
	_ENV = self
	self.msg = "MESSAGE_MAINCITYVIEW_OFFSET_BUILD"
	self.offsetType = MAINCITYVIEW_OFFSET_TYPE_BUILD
	self.buildIndex = cityBuildConstDef.buildIndexDef.index_wall
	self.scale = MAINCITY_DEFAULT_SCALE
	self.skip = true
	SoraDSendMessage(self)
end
return defendViewPanel
