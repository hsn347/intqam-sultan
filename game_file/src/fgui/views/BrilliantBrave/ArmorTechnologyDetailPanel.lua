local technologyCtrl = SoraDGetCtrl("technologyCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local collegeDesRead = include("collegeDesRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local ArmorTechnologyDetailPanel = class("ArmorTechnologyDetailPanel", baseFguiPanel)
function ArmorTechnologyDetailPanel:ctor(...)
	self.super.ctor(self, ...)
	print("ArmorTechnologyDetailPanel:ctor", self.viewName)
end
function ArmorTechnologyDetailPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "CollegeView"
	end
	return self._packageList
end
function ArmorTechnologyDetailPanel:onInit()
	print("=======ArmorTechnologyDetailPanel:onInit")
	self.tid = self.proxy.param.technologyID
	self.type = "process"
	self.queueType = gQueueTypeDef.craft_study
	_ENV = nil
	;(nil).need = ""
	self.fields.Com_title:setString(i18n("common_text_380", nil))
	self.fields.Text_maxLv:setString(i18n("common_text_339"))
	self.fields.Text_leftTime:setString(i18n("common_text_1663"))
	self.textShowTime = self.fields.Button_studying:getChild("Text_ShowTime")
	self.fields.Button_studying:setString(i18n("Soldiers_armor_text_12"))
	self.fields.Button_studyingNow:setString(i18n("Soldiers_armor_text_10"))
	self.fields.Button_speedUp:setString(i18n("common_text_018"))
	self.fields.Button_speedUp:addClickListener(handler(self, self.btnSpeedUpClickCallBack))
	self.fields.Button_studyingNow:addClickListener(handler(self, self.btnStudyingNowClickCallBack))
	self.fields.Button_studying:addClickListener(handler(self, self.btnStudyingClickCallBack))
	self.fields.List_condition:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Text_time:setTimeUpdateListener(handler(self, self.timeUpdate))
	self.fields.Text_leftTime:fixPos()
	self.fields.bar:fixPos()
	self.fields.bar:setScaleX(SoraDFIsRA() and -1 or 1)
	self.fields.Text_time:fixPos()
end
function ArmorTechnologyDetailPanel:onShow()
	print("=======ArmorTechnologyDetailPanel:onShow")
	self:updateView()
end
function ArmorTechnologyDetailPanel:onItemRenderer(index, obj)
	obj:initData(self.tableNeedList[index + 1])
end
function ArmorTechnologyDetailPanel:updateView()
	local singleleData = technologyCtrl:getTechnoDataByID(self.tid, self.type)
	if singleleData then
		self.tableSingleData = singleleData
	end
	local singleDetails = technologyCtrl:getTechnologyDetails(self.tid, self.tableSingleData.currentLevel)
	if singleDetails then
		self.tableSingleDetails = singleDetails
	end
	dump(singleDetails, "self.technologyLocalData.technologyDat")
	local basetime = self.tableSingleDetails.technologyTime
	local finaltime = technologyCtrl:getResearchTime(basetime, self.queueType)
	self.textShowTime:setString(SoraDConvertSecondToString(finaltime))
	self.fields.Com_top:initData(self.tid, self.type, self.tableSingleData, self.tableSingleDetails)
	if self.tableSingleData.currentLevel >= self.tableSingleData.maxLevel then
		self.controllers.c1:setSelectedIndex(2)
		self.isUnlock = true
	elseif self.tableSingleDetails.upgradeIngTechnology and self.tableSingleDetails.upgradeIngTechnology[3] then
		self.controllers.c1:setSelectedIndex(1)
		local queueCtrl = SoraDGetCtrl("queueCtrl")
		self.queue = queueCtrl:queryQueue(self.queueType)
		local time = self.queue.timerNode.timer:getRemainTime()
		if 0 < time then
			self.fields.Text_time:beginTime(time)
		end
		self.fields.bar:setMax(self.queue.totaltime)
		local itemList = backpackCtrl:getSpeedUpItemList(gAbbrSpeedUpType.CRAFT_STUDY)
		if #itemList <= 0 then
			self.fields.Button_studyingNow:setPositionX(self:getWidth() / 2)
			self.fields.Button_speedUp:setVisible(false)
		else
			self.fields.Button_studyingNow:setPositionX(SoraDFIsRA() and self:getWidth() / 2 + 120 or self:getWidth() / 2 - 120)
			self.fields.Button_speedUp:setVisible(true)
			self.fields.Button_speedUp:setPositionX(not SoraDFIsRA() and self:getWidth() / 2 + 120 or self:getWidth() / 2 - 120)
		end
		self.isUnlock = true
	else
		self.controllers.c1:setSelectedIndex(0)
		local basetime = self.tableSingleDetails.technologyTime
		local finaltime = technologyCtrl:getResearchTime(basetime, self.queueType)
		self.textShowTime:setString(SoraDConvertSecondToString(finaltime))
		self.fields.Button_studyingNow:setCostTitle(string.formatnumberthousands(self.tableSingleDetails.cost))
		self:updateBtnState()
		self:initScroll()
	end
	if self.isUnlock then
		self.fields.Panel_bg:setString(collegeDesRead.getName(self.tid))
	else
		technologyCtrl = collegeDesRead.getName(self.tid)
		collegeDesRead.getName(self.tid).name = collegeDesRead.getName(self.tid)
		self.fields.Panel_bg:setString(i18n("hero_mastery_02", collegeDesRead.getName(self.tid)))
	end
	self.fields.Button_speedUp:setPositionX(SoraDFPosX(200))
	self.fields.Button_studying:setPositionX(SoraDFPosX(200))
	self.fields.Button_studyingNow:setPositionX(SoraDFPosX(440))
end
function ArmorTechnologyDetailPanel:updateBtnState()
	local isOpened = true
	self.cantStudying = TECHNOLOGY_SINGLE_TYPE.NONE
	local tableStuding, techType = technologyCtrl:studyingTechnology(self.queueType)
	if tableStuding then
		self.cantStudying = TECHNOLOGY_SINGLE_TYPE.QUEUE
	end
	if self.tableSingleDetails.build then
		for i, v in ipairs(self.tableSingleDetails.build) do
			if not v.isContentmented then
				isOpened = false
				break
			end
		end
	end
	local needlv = 0
	if self.tableSingleDetails.starbuild then
		for i, v in ipairs(self.tableSingleDetails.starbuild) do
			needlv = v.consumeLevel
			if not v.isContentmented then
				isOpened = false
				break
			end
		end
	end
	self.isUnlock = isOpened
	self.fields.Button_studying:setVisible(self.isUnlock)
	self.fields.Button_studyingNow:setVisible(self.isUnlock)
end
function ArmorTechnologyDetailPanel:initScroll()
	self.tableNeedList, technologyCtrl = nil, nil
	local tableStuding, techType = technologyCtrl:studyingTechnology(self.queueType)
	if tableStuding then
		technologyCtrl = nil
		;(nil).data = tableStuding
		;(nil).singleType = TECHNOLOGY_SINGLE_TYPE.QUEUE
		;(nil).queueType = self.queueType
		table.insert(self.tableNeedList, nil)
		self.cantStudying = TECHNOLOGY_SINGLE_TYPE.QUEUE
	end
	for i, v in ipairs(self.tableSingleDetails.starbuild) do
		technologyCtrl = nil
		;(nil).data = v
		;(nil).singleType = TECHNOLOGY_SINGLE_TYPE.STAR
		table.insert(self.tableNeedList, nil)
	end
	self.fields.List_condition:setNumItems(#self.tableNeedList)
end
function ArmorTechnologyDetailPanel:timeUpdate(time)
	self.fields.bar:setValue(self.queue.totaltime - time)
	local goldPay = serviceFunctions.timeConvertToGold(time)
	self.fields.Button_studyingNow:setCostTitle(tostring(math.floor(goldPay)))
	if time <= 0 then
		self:updateView()
	end
end
function ArmorTechnologyDetailPanel:btnStudyingNowClickCallBack()
	SoraDPlaySound()
	if self.controllers.c1:getSelectedIndex() == 1 then
		SoraDShowSpeedUpBox(self.queue, handler(self, self.speedUpBack), i18n("common_text_765"))
	elseif SoraDEnoughGold(self.tableSingleDetails.cost) then
		local dailyRemindManager = include("dailyRemindManager")
		if dailyRemindManager.checkNeedRemind(dailyRemindManager.REMIND_TYPE.armorTechnologyGold) then
			_ENV = i18n("common_text_765")
			_ENV = i18n("common_text_765")
			i18n("common_text_765").gold = self.tableSingleDetails.cost
			i18n("common_text_765").science = collegeDesRead.getName(self.tid)
			i18n("common_text_765").content = i18n("magic_lamp_text_161", i18n("common_text_765"))
			i18n("common_text_765").confirmString = i18n("common_text_204")
			i18n("common_text_765").confirmFunc = function()
				self = nil
				;(nil)[1] = self.tableSingleData.technologyID
				technologyCtrl:instantResearch(self.tableSingleData.technologyID, nil)
				self:removeFromParent()
			end
			i18n("common_text_765").remindString = i18n("coffeeCraftsman_text_27")
			i18n("common_text_765").remindFunc = function(value)
				if value then
					dailyRemindManager.addRemindToManager(dailyRemindManager.REMIND_TYPE.armorTechnologyGold)
				end
			end
			uiManager:show("MessageBox", i18n("common_text_765"))
		else
			collegeDesRead = i18n("common_text_765")
			i18n("common_text_765")[1] = self.tableSingleData.technologyID
			technologyCtrl:instantResearch(self.tableSingleData.technologyID, i18n("common_text_765"))
			self:removeFromParent()
		end
	end
end
function ArmorTechnologyDetailPanel:btnStudyingClickCallBack()
	SoraDPlaySound()
	if self.cantStudying == TECHNOLOGY_SINGLE_TYPE.QUEUE then
		SoraDShowMsgBox(i18n("Soldiers_armor_text_14"), i18n("common_text_204"))
	else
		technologyCtrl = i18n("common_text_204")
		i18n("common_text_204")[1] = self.tableSingleData.technologyID
		technologyCtrl:research(self.tableSingleData.technologyID, UPGRADE_CONDITION.RESOURCES_NOT_ENOUGH, i18n("common_text_204"))
		self:removeFromParent()
	end
end
function ArmorTechnologyDetailPanel:btnSpeedUpClickCallBack()
	SoraDPlaySound()
	SoraDShowSpeedUpByItemBox(self.queue.qtype, handler(self, self.speedUpBack))
end
function ArmorTechnologyDetailPanel:speedUpBack(type)
	if type == MSGBOX_CALLBACK_SPEEDUP then
		self:removeFromParent()
	end
end
return ArmorTechnologyDetailPanel
