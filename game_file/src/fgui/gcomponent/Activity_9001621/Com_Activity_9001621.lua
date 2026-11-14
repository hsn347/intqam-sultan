local baseComponent = require("fgui.base.baseComponent")
local Com_Activity_9001621 = fgui.extension_class(fgui.GComponent, baseComponent)
local armyDesRead = include("armyDesRead")
local activity_9001621_Read = include("activity_9001621_Read")
local activity_9001621_Ctrl = SoraDGetCtrl("activity_9001621_Ctrl")
fgui.register_extension("ui://Activity_9001621/Com_Activity_9001621", Com_Activity_9001621)
function Com_Activity_9001621:onInit()
	self.activityID = gActivityTimeActivityID.HONOR_BACK_ARMY_SUBSIDY
	self.fields.Label_time:initCommonActivityTime(self.activityID)
	self.fields.List_soldier:setItemRenderer(handler(self, self.onSoldierRender))
	self.fields.List_soldier:addEventListener(fgui.UIEventType.Scroll, handler(self, self.onScrollItem))
	self.fields.List_soldier:addEventListener(fgui.UIEventType.ScrollEnd, handler(self, self.onScrollEndItem))
	self.fields.List_skill:setItemRenderer(handler(self, self.onSkillRender))
	self.text_desc = SoraDCreateTimerLabel(self, self.fields.text_desc)
	self.text_desc:setTimeLast(function(timeStr)
		_ENV = nil
		;(nil).time = timeStr
		return i18n("Army_subtidy_text_07", nil)
	end)
	self.text_desc:setTimeEndListener(function()
		self:updateView()
	end)
	self.fields.Button_train:setString(i18n("common_text_061"))
	self.fields.Button_train:addClickListener(handler(self, self.onTrainClick))
end
function Com_Activity_9001621:registerEvent()
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001621_UPDATE", handler(self, self.updateView))
end
function Com_Activity_9001621:onShow()
	self.spineArmyPos = cc.p(self:getWidth() / 2, self.fields.Spine_army:getPositionY())
	self.trainType = TRAIN_TYPE.SOLDIERS
	local curIndex = 1
	self.soldierList, _ENV = self:getWidth() / 2, self:getWidth() / 2
	self.buildArmyData = activity_9001621_Ctrl:getBuildArmyData()
	self.armyCfg = activity_9001621_Read.getArmyCfg(activity_9001621_Ctrl:getBackDay())
	if self.armyCfg == nil then
		return
	end
	_UPVALUE3_ = self.armyCfg
	self.armyCfg[1] = BUILDID.CHARIOT_PLANT
	self.armyCfg[2] = BUILDID.RANGE
	local self.armyCfg[3], bids = BUILDID.STABLES, self.armyCfg
	for i, v in ipairs(bids) do
		local armyid = self.buildArmyData[tostring(v)]
		if armyid ~= nil then
			_ENV = activity_9001621_Ctrl:getBackDay()
			activity_9001621_Ctrl:getBackDay().bid = v
			activity_9001621_Ctrl:getBackDay().armyid = armyid
			activity_9001621_Ctrl:getBackDay().iscantrain = true
			table.insert(self.soldierList, activity_9001621_Ctrl:getBackDay())
		end
	end
	_ENV = activity_9001621_Ctrl:getBackDay()
	activity_9001621_Ctrl:getBackDay().isEmpty = true
	table.insert(self.soldierList, 1, activity_9001621_Ctrl:getBackDay())
	_ENV = activity_9001621_Ctrl:getBackDay()
	activity_9001621_Ctrl:getBackDay().isEmpty = true
	table.insert(self.soldierList, 1, activity_9001621_Ctrl:getBackDay())
	_ENV = 1
	;(1).isEmpty = true
	table.insert(self.soldierList, 1)
	_ENV = 1
	;(1).isEmpty = true
	table.insert(self.soldierList, 1)
	curIndex = curIndex + 2
	self.curIndex = curIndex
	self:updateView()
end
function Com_Activity_9001621:onScrollItem()
	local offsetX = self.fields.List_soldier:getScrollPane():getPositionX()
	local listW = self.fields.List_soldier:getContentSize().width
	local scrollW = self.fields.List_soldier:getInnerContainerSize().width
	local centerX = offsetX + listW / 2
	for i = 1, self.fields.List_soldier:getNumItems() do
		local objW = self.fields.List_soldier:getChildAt(i - 1):getContentSize().width
		local objOffsetX = self.fields.List_soldier:getChildAt(i - 1):getX() + objW / 2 - offsetX - listW / 2
		self.fields.List_soldier:getChildAt(i - 1):setRatio((listW - math.abs(objOffsetX) * 0.25) / listW)
	end
end
function Com_Activity_9001621:onScrollEndItem()
	local midIndex = 0
	local ratio = 0
	for i = 1, self.fields.List_soldier:getNumItems() do
		if ratio <= self.fields.List_soldier:getChildAt(i - 1):getRatio() and not self.fields.List_soldier:getChildAt(i - 1):isEmptyCom() then
			ratio = self.fields.List_soldier:getChildAt(i - 1):getRatio()
			midIndex = i
		end
	end
	self.curIndex = midIndex
	self:updateView()
end
function Com_Activity_9001621:updateView(target, data)
	self.trainArmyId = activity_9001621_Ctrl:getTrainArmyId()
	if self.trainArmyId ~= 0 then
		for i, v in ipairs(self.soldierList) do
			if v.armyid and v.armyid == self.trainArmyId then
				self.curIndex = i
				dump(self.curIndex, "self.curIndex")
				break
			end
		end
	end
	armyDesRead = ipairs(self.soldierList)
	ipairs(self.soldierList)[1] = self.soldierList
	ipairs(self.soldierList)[2] = self.curIndex
	dump(ipairs(self.soldierList))
	self.preArmyID = self.armyID
	self.armyID = self.soldierList[self.curIndex].armyid
	self.bid = self.soldierList[self.curIndex].bid
	self.fields.List_soldier:setNumItems(#self.soldierList)
	self.fields.List_soldier:scrollToCenter(self.fields.List_soldier:getChildAt(self.curIndex - 1), true)
	self:onScrollItem()
	self.fields.Image_army:setSpriteFrame(armyDesRead.getPortrait(self.armyID))
	self.fields.Image_army:setVisible(true)
	self.fields.Spine_army:setVisible(false)
	self.fields.Com_baseInfo:initData(self.armyID, self.bid, self.trainType)
	self.armyName = armyDesRead.getName(self.armyID)
	self.fields.Com_num:setTitle(self.armyName)
	self.skillList = armyDesRead.getSkill(self.armyID)
	self.fields.List_skill:setNumItems(#self.skillList)
	local tranLastTime = activity_9001621_Ctrl:getTrainLastTime()
	local trainTimes = activity_9001621_Ctrl:getTrainTimes()
	armyDesRead = self.bid
	self.bid[1] = self.armyCfg.trainNum
	self.bid[2] = tranLastTime
	dump(self.bid, "self.armyCfg.trainNum[tranLastTime >0 and trainTimes or trainTimes + 1]")
	activity_9001621_Ctrl = armyDesRead.getPortrait(self.armyID)
	armyDesRead.getPortrait(self.armyID).num = #self.armyCfg.trainNum - trainTimes
	self.fields.text_num:setString(i18n("Army_subtidy_text_09", armyDesRead.getPortrait(self.armyID)))
	local isInTrain = 0 < tranLastTime or self.trainArmyId ~= 0
	local trainNumCfg = self.armyCfg.trainNum[isInTrain and trainTimes or trainTimes + 1]
	local canTrainNum = trainNumCfg and trainNumCfg.count or 0
	self.canTrain = canTrainNum
	self.fields.text_trainNum:setString(string.formatnumberthousands(self.canTrain))
	armyDesRead = self.fields.text_trainNum
	self.fields.text_trainNum[1] = tranLastTime
	self.fields.text_trainNum[2] = self.canTrain
	dump(self.fields.text_trainNum, "tranLastTime <= 0 and self.canTrain")
	self.fields.Button_train:setEnabled(tranLastTime <= 0 and (0 < self.canTrain or self.trainArmyId ~= 0))
	self.fields.mask:setVisible(isInTrain)
	if canTrainNum == 0 and self.trainArmyId == 0 then
		self.fields.Button_train:setString(i18n("Anchor_text_21"))
	else
		self.fields.Button_train:setString(i18n(self.trainArmyId == 0 and "treasure_crystal_btn_02" or "cavalryrise_text_06"))
	end
	dump(tranLastTime, "tranLastTime >= 0 ")
	if 0 < tranLastTime then
		self.text_desc:beginTime(tranLastTime)
	else
		self.text_desc:endTimeNoCauseEndCallBack()
		if canTrainNum == 0 then
			self.text_desc:setString(i18n("Army_subtidy_text_08"))
		else
			self.text_desc:setString(i18n(self.trainArmyId == 0 and "Army_subtidy_text_05" or "Army_subtidy_text_06"))
		end
	end
end
function Com_Activity_9001621:onSoldierRender(index, obj)
	obj:initData(self.soldierList[index + 1], index + 1, self.curIndex)
end
function Com_Activity_9001621:onSkillRender(index, obj)
	obj:initData(self.skillList[index + 1])
end
function Com_Activity_9001621:onTrainClick()
	SoraDPlaySound()
	local tranLastTime = activity_9001621_Ctrl:getTrainLastTime()
	if tranLastTime <= 0 then
		if self.trainArmyId == 0 then
			_ENV = nil
			;(nil).name = self.armyName
			local str = i18n("Army_subtidy_text_02", nil)
			SoraDShowMsgBoxNew(str, i18n("common_text_204"), i18n("common_text_185"), function(exitType)
				if exitType == MSGBOX_CALLBACK_YES and not tolua.isnull(self) then
					activity_9001621_Ctrl:reqTrainArmy(self.bid)
				end
			end)
		else
			local worldMapDefine = include("worldMapDefine")
			local isInWar = worldMapDefine.isInWar()
			if isInWar then
				SoraDShowMsgTip(i18n("Army_subtidy_text_10"))
			else
				activity_9001621_Ctrl:reqGetArmy()
			end
		end
	end
end
return Com_Activity_9001621
