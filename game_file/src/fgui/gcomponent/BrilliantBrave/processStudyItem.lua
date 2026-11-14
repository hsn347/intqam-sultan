local cityltCtrl = include("cityltCtrl")
local technologyCtrl = SoraDGetCtrl("technologyCtrl")
local baseComponent = require("fgui.base.baseComponent")
local processStudyItem = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://BrilliantBrave/processStudyItem", processStudyItem)
function processStudyItem:onInit()
	self.fields.Panel_touch:addClickListener(handler(self, self.btnTouchClick))
	self.fields.List:setItemRenderer(handler(self, self.onListRenderer))
	self:fixChildrenPos()
end
function processStudyItem:registerEvent()
	SoraDAddMessage(self, "MESSAGE_UPDATE_TECHNOLOGY", handler(self, self.updateMaxNum))
end
function processStudyItem:onListRenderer(index, obj)
	obj:initData(self.singleList[index + 1], self.needQuality)
end
function processStudyItem:onShow()
end
function processStudyItem:initData(data, index, openList)
	self.index = index
	self.itemList = data.itemList
	self.singleList, _ENV, self.listData = self:getSortList(self.itemList), self:getSortList(self.itemList), self:getSortList(self.itemList)
	for i = 1, math.ceil(#self.listData / 3) do
		self.singleList[i], _ENV = nil, nil
		for j = 1, 3 do
			table.insert(self.singleList[i], self.listData[(i - 1) * 3 + j])
		end
	end
	self.isLastUnLock = SoraDGetBuildQuality() >= data.quality - 1
	self.isUnlock = SoraDGetBuildQuality() >= data.quality
	self.needQuality = data.quality
	self.fields.lock:setVisible(not self.isLastUnLock)
	self.fields.arrow:setVisible(self.isLastUnLock)
	self.fields.title:setColor(cc.c3b(215, 195, 155))
	if index == 1 then
		self.fields.title:setString(i18n("Soldiers_armor_text_11"))
	elseif not self.isUnlock and self.isLastUnLock then
		self.fields.title:setColor(cc.c3b(190, 40, 40))
		self.fields.title:setString(cityltCtrl.getStatueBraveQualityName(data.quality))
	elseif self.isUnlock then
		self.fields.title:setString(cityltCtrl.getStatueBraveQualityName(data.quality))
	elseif not self.isLastUnLock then
		_ENV = cityltCtrl.getStatueBraveQualityName(data.quality)
		cityltCtrl.getStatueBraveQualityName(data.quality).var = index
		self.fields.title:setString(i18n("Soldiers_armor_text_18", cityltCtrl.getStatueBraveQualityName(data.quality)))
	end
	self.isOpen = openList[index] and true or false
	if self.isLastUnLock then
		self:updateMaxNum()
		if openList[index] then
			self.fields.arrow:setRotation(0)
			self.fields.List:setNumItems(#self.singleList)
			self.fields.List:setHeight(#self.singleList * 250)
		else
			self.fields.arrow:setRotation(180)
			self.fields.List:setNumItems(0)
			self.fields.List:setHeight(0)
		end
	else
		self.fields.Text_process:setString(i18n("exitic_pavillion_text_0055"))
	end
end
function processStudyItem:getSortList(itemList)
	local _ENV, reTbl
	for i, technologyID in ipairs(itemList) do
		local isUnlock, isStudying, consumeLevel, curLv = self:checkTechStatue(technologyID)
		local isActive = technologyCtrl:isActiveTech(technologyID)
		_ENV = nil
		;(nil).technologyID = technologyID
		;(nil).isUnlock = isUnlock
		;(nil).isActive = isActive
		;(nil).isStudying = isStudying
		;(nil).lv = consumeLevel
		;(nil).curLv = curLv
		table.insert(reTbl, nil)
	end
	table.sort(reTbl, function(l, r)
		if not l.isUnlock and r.isUnlock then
			return false
		elseif l.isUnlock and not r.isUnlock then
			return true
		else
			return l.technologyID < r.technologyID
		end
	end)
	return reTbl
end
function processStudyItem:checkTechStatue(technologyID)
	if not technologyCtrl:getTechnoDataByID(technologyID, "process") then
		local technologyCtrl, singleleData = technologyCtrl:getTechnoDataByID(technologyID, "process"), technologyCtrl:getTechnoDataByID(technologyID, "process")
	end
	local singleDetails = technologyCtrl:getTechnologyDetails(technologyID, singleleData.currentLevel)
	local starbuild = singleDetails.starbuild
	local isUnlock = true
	local isStudying = false
	if singleDetails.upgradeIngTechnology and singleDetails.upgradeIngTechnology[3] then
		isStudying = true
	end
	for i, v in ipairs(starbuild) do
		if v.bid == 304 and not v.isContentmented then
			isUnlock = false
			break
		end
	end
	local consumeLevel = 0
	local singleOriDetails = technologyCtrl:getTechnologyDetailById(technologyID, singleleData.currentLevel)
	if singleOriDetails and singleOriDetails.starbuild[1] == BUILDID.STAR_BRAVE_STATUE then
		consumeLevel = singleOriDetails.starbuild[2]
	end
	return isUnlock, isStudying, consumeLevel, singleleData.currentLevel
end
function processStudyItem:updateMaxNum()
	local num = self:getMaxNum()
	local maxNum = #self.itemList
	self.fields.Text_process:setColor(num >= maxNum and cc.c3b(255, 215, 110) or cc.c3b(215, 195, 155))
	_ENV = 195
	;(195).num1 = num
	;(195).num2 = maxNum
	self.fields.Text_process:setString(i18n("common_text_4739", 195))
end
function processStudyItem:getMaxNum()
	local num = 0
	for i, technologyID in ipairs(self.itemList) do
		local singleleData = technologyCtrl:getTechnoDataByID(technologyID, "process")
		if singleleData.currentLevel >= singleleData.maxLevel then
			num = num + 1
		end
	end
	return num
end
function processStudyItem:btnTouchClick()
	SoraDPlaySound()
	if not self.isLastUnLock then
		SoraDShowMsgTip(i18n("exitic_pavillion_text_0055"))
	else
		_ENV = i18n("exitic_pavillion_text_0055")
		i18n("exitic_pavillion_text_0055").msg = "MESSAGE_ARMOR_TECHNOLOGY_UI_SWITCH"
		i18n("exitic_pavillion_text_0055").index = self.index
		i18n("exitic_pavillion_text_0055").isOpen = not self.isOpen
		SoraDSendMessage(i18n("exitic_pavillion_text_0055"))
	end
end
return processStudyItem
