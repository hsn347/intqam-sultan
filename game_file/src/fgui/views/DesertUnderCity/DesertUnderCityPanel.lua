local publicRead = include("publicRead")
local itemDesRead = include("itemDesRead")
local desertUnderCityCtrl = SoraDGetCtrl("desertUnderCityCtrl")
local flameSecretOrderRead = include("flameSecretOrderRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local DesertUnderCityPanel = class("DesertUnderCityPanel", baseFguiPanel)
function DesertUnderCityPanel:ctor(...)
	self.super.ctor(self, ...)
	print("DesertUnderCityPanel:ctor", self.viewName)
end
function DesertUnderCityPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function DesertUnderCityPanel:onInit()
	print("=======DesertUnderCityPanel:onInit")
	self.isRunning = false
	self.activityID = gActivityTimeActivityID.DESERT_UNDERGROUND_CITY_ACTIVITY
	_ENV = nil
	;(nil).num = 1
	self.fields.Com_title:initData(i18n("desert_dungeons_01", nil), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Labe_Time:initCommonActivityTime(self.activityID)
	self.fields.Button_Award:addClickListener(handler(self, self.onClickAward))
	self.fields.Button_Award:setString(i18n("decrypt_text_03"))
	self.fields.Button_icon:addClickListener(handler(self, self.onClickChoose))
	self.fields.Text_Tips:setString(i18n("desert_dungeons_02"))
	self.fields.Text_AwardTitle:setString(i18n("desert_dungeons_05"))
	self.fields.Button_Next:addClickListener(handler(self, self.onClickNextFloor))
	self.fields.Button_Next:setTitleText(i18n("Promise_Summit_text_37"))
	self.fields.Text_final:setString(i18n("fire_sercet_09"))
	self.fields.Button_GoTo:setTitle(i18n("fire_sercet_13"))
	self.fields.Button_GoTo:addClickListener(handler(self, self.onClickAllOpen))
	self.fields.Usm_11:setCompleteCallback(function()
		self.fields.Usm_11:setVisible(false)
	end)
	desertUnderCityCtrl:reqInit()
end
function DesertUnderCityPanel:onShow()
	print("=======DesertUnderCityPanel:onShow")
end
function DesertUnderCityPanel:updateItemNum()
	if self.floorNum == nil then
		return
	end
	local itemInfo = flameSecretOrderRead.getItemInfoByFloor(self.floorNum, true)
	self.itemID, self.itemNeedNum = itemInfo[1], itemInfo[2]
	self.materialCount = backpackCtrl:getItemCount(self.itemID)
	local freeTime = desertUnderCityCtrl:getFreeTime()
	if 0 < freeTime then
		self.fields.Label_Num:getController("c1"):setSelectedIndex(1)
		flameSecretOrderRead = nil
		;(nil).num = freeTime
		self.fields.Label_Num:setString(i18n("desert_dungeons_10", nil))
	else
		self.fields.Label_Num:getController("c1"):setSelectedIndex(0)
		flameSecretOrderRead = i18n("desert_dungeons_10", nil)
		i18n("desert_dungeons_10", nil).num = self.materialCount
		self.fields.Label_Num:setString(i18n("common_text_531", i18n("desert_dungeons_10", nil)))
	end
end
function DesertUnderCityPanel:updateFloor()
	self.floorNum = desertUnderCityCtrl:getFloor()
	desertUnderCityCtrl = nil
	;(nil).num = self.floorNum
	self.fields.Com_title:setTitle(i18n("desert_dungeons_01", nil))
	self:updateItemNum()
end
function DesertUnderCityPanel:updateAwardNode()
	for i = 0, 15 do
		self.fields["n" .. i]:initData(desertUnderCityCtrl:getFloorInfo(i + 1), i + 1)
		self.fields["n" .. i]:setClickCallback(handler(self, self.onClickItemAward))
	end
end
function DesertUnderCityPanel:updateStatus()
	local totalFloorNum = flameSecretOrderRead.getTotalFloorNum(true)
	local remainGrids = desertUnderCityCtrl:getRemainGrids()
	local chooseID = desertUnderCityCtrl:getChooseID()
	local greatRewardList = flameSecretOrderRead.getGreatRewardsByFloor(self.floorNum, true)
	_ENV = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	greatRewardList = serviceFunctions.tableFormat(greatRewardList, nil)
	if greatRewardList[chooseID] then
		self.fields.Button_icon:setIcon(publicRead.getIcon(greatRewardList[chooseID].id))
	else
		self.fields.Button_icon:setIcon("frame_Desert_dungeons_jiahao.png")
	end
	local isBigPrizeGot = false
	for i = 1, 16 do
		local floorInfo = desertUnderCityCtrl:getFloorInfo(i)
		if floorInfo.isGreate then
			isBigPrizeGot = true
			break
		end
	end
	local freeTime = desertUnderCityCtrl:getFreeTime()
	local isEnough = 0 < remainGrids and self.materialCount >= self.itemNeedNum * (remainGrids - freeTime)
	self.controllers.c1:setSelectedIndex(desertUnderCityCtrl:isAlreadyChosen() and (self.floorNum ~= totalFloorNum and 1 or isBigPrizeGot and 2 or 1) or 0)
	if self.controllers.c1:getSelectedIndex() == 1 then
		if isBigPrizeGot and isEnough then
			self.controllers.c2:setSelectedIndex(2)
		elseif isBigPrizeGot then
			self.controllers.c2:setSelectedIndex(1)
		elseif isEnough then
			self.controllers.c2:setSelectedIndex(0)
		else
			self.controllers.c2:setSelectedIndex(3)
		end
	else
		self.controllers.c2:setSelectedIndex(3)
	end
end
function DesertUnderCityPanel:onClickAward()
	SoraDPlaySound()
	uiManager:show("DesertUnderCityPreAward", param)
end
function DesertUnderCityPanel:onClickChoose()
	SoraDPlaySound()
	if self.isRunning then
		return
	end
	self:updateGuideAcion(false)
	local remainGrids = desertUnderCityCtrl:getRemainGrids()
	local totalFloorNum = flameSecretOrderRead.getTotalFloorNum(true)
	if self.floorNum == totalFloorNum and remainGrids == 0 then
		SoraDShowMsgTip(i18n("fire_sercet_07"))
		return
	end
	uiManager:show("DesertUnderCityChoose", param)
end
function DesertUnderCityPanel:onClickNextFloor()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("desert_dungeons_04")
	;(nil).confirmString = i18n("common_text_054")
	;(nil).cancelString = i18n("common_text_185")
	;(nil).confirmFunc = function()
		desertUnderCityCtrl:reqNext()
		SoraDShowLoading()
	end
	uiManager:show("DesertUnderCityBox", nil)
end
function DesertUnderCityPanel:onClickAllOpen()
	SoraDPlaySound()
	desertUnderCityCtrl:reqAllOpen(true)
end
function DesertUnderCityPanel:onClickItemAward(floorInfo, index)
	print(floorInfo, index)
	if self.isRunning then
		return
	end
	local totalFloorNum = flameSecretOrderRead.getTotalFloorNum(true)
	local remainGrids = desertUnderCityCtrl:getRemainGrids()
	if self.floorNum == totalFloorNum and remainGrids == 0 then
		SoraDShowMsgTip(i18n("fire_sercet_07"))
		return
	end
	if self.floorNum == totalFloorNum and floorInfo.isGreate then
		SoraDShowMsgTip(i18n("fire_sercet_07"))
		return
	end
	if next(floorInfo) and floorInfo.isGreate then
		_ENV = i18n("fire_sercet_07")
		i18n("fire_sercet_07").content = i18n("desert_dungeons_04")
		i18n("fire_sercet_07").confirmString = i18n("common_text_054")
		i18n("fire_sercet_07").cancelString = i18n("common_text_185")
		i18n("fire_sercet_07").confirmFunc = function()
			desertUnderCityCtrl:reqNext()
			SoraDShowLoading()
		end
		uiManager:show("DesertUnderCityBox", i18n("fire_sercet_07"))
		return
	end
	if not desertUnderCityCtrl:isAlreadyChosen() then
		SoraDShowMsgTip(i18n("desert_dungeons_03"))
		self:updateGuideAcion(true)
		return
	end
	if desertUnderCityCtrl:getFreeTime() == 0 and self.materialCount < self.itemNeedNum then
		local data = itemDesRead.getOutput(self.itemID)
		if next(data) then
			_ENV = i18n("desert_dungeons_03")
			i18n("desert_dungeons_03").itemID = self.itemID
			uiManager:show("commonGetWayView", i18n("desert_dungeons_03"))
		end
		return
	end
	desertUnderCityCtrl:reqOpen(index)
	SoraDShowLoading()
end
function DesertUnderCityPanel:onClickHelp()
	_ENV = nil
	;(nil).content = i18n("desert_dungeons_11")
	uiManager:show("RuleView", nil):setOwnerKey(self)
end
function DesertUnderCityPanel:updateGuideAcion(isGuide)
	self.fields.Effect_finger:setVisible(isGuide)
end
function DesertUnderCityPanel:showOpenEffect(index)
	self.fields["n" .. index - 1]:showOpenEffect(desertUnderCityCtrl:getFloorInfo(index))
end
function DesertUnderCityPanel:showNextEffect()
	self.isRunning = true
	self.fields.Usm_11:play(false)
	_UPVALUE1_ = nil
	;(nil)[1] = ffa.delay(1)
	;(nil)[2] = ffa.callFunc(function()
		self.isRunning = false
	end)
	;(nil)[3] = ffa.callFunc(function()
		self.isRunning = false
	end)
	self:runAction(ffa.seq(nil))
end
return DesertUnderCityPanel
