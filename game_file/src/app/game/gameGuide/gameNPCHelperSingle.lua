local gametop = gModuleMgr.getObject("gametop")
local queueCtrl = gametop.playertop_:getModule("queueCtrl")
local stuffWorkshopCtrl = gametop.playertop_:getModule("stuffWorkshopCtrl")
local cityCtrl = gametop.playertop_:getModule("cityCtrl")
local buildLogic = include("buildLogic")
local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
local questCtrl = gametop.playertop_:getModule("questCtrl")
local questltCtrl = gModuleMgr.sharedMgr("questltCtrl")
local GameNPCHelperSingle = class("gameNPCHelperSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("gameNPCHelperSingle")
	end
	return target
end)
function GameNPCHelperSingle:ctor()
	_ENV, _UPVALUE4_, self.type = nil, gNPCHelperTypeDef.college, gNPCHelperTypeDef.college
	;(nil).bid = BUILDID.CHARIOT_PLANT
	_ENV, (nil).queue = gQueueTypeDef.chariot_plant_queue, gQueueTypeDef.chariot_plant_queue
	gQueueTypeDef.chariot_plant_queue.bid = BUILDID.STABLES
	_ENV, gQueueTypeDef.chariot_plant_queue.queue = gQueueTypeDef.stables_queue, gQueueTypeDef.stables_queue
	gQueueTypeDef.stables_queue.bid = BUILDID.RANGE
	_ENV, gQueueTypeDef.stables_queue.queue = gQueueTypeDef.range_queue, gQueueTypeDef.range_queue
	gQueueTypeDef.range_queue.bid = BUILDID.BARRACKS
	gQueueTypeDef.range_queue.queue = gQueueTypeDef.barracks_queue
	self.tableArmyBuild, gNPCHelperTypeDef.college[1] = gNPCHelperTypeDef.college
	self.tableArmyBuild, gNPCHelperTypeDef.college[2] = gNPCHelperTypeDef.college, gQueueTypeDef.chariot_plant_queue
	self.tableArmyBuild, gNPCHelperTypeDef.college[3] = gNPCHelperTypeDef.college, gQueueTypeDef.stables_queue
	self.tableArmyBuild, gNPCHelperTypeDef.college[4] = gNPCHelperTypeDef.college, gQueueTypeDef.range_queue
	self.labelFull = SoraDGetChildByName(self, "Text_full")
	self.labelFull:setString(i18n("common_text_708"))
	self.btnGo = SoraDGetChildByName(self, "Button_go")
	self.btnGo:setTitleText(i18n("common_text_477"))
	self.labelName = SoraDGetChildByName(self, "Text_name")
	self.labelDes = SoraDGetChildByName(self, "Text_des")
	self.imgGrey0 = SoraDGetChildByName(self, "Image_grey_0")
	if self.btnGo then
		self.btnGo:addTouchEventListener(handler(self, self.btnClickCallBack))
	end
end
function GameNPCHelperSingle:initData(type)
	self.type = type
	local total = 0
	local cur = 0
	local notice = ""
	local des = ""
	if self.type == gNPCHelperTypeDef.college then
		total = 0 < cityCtrl:getBuildCount(BUILDID.COLLEGE) and 1 or 0
		cur = queueCtrl:queryQueue(gQueueTypeDef.technology_upgrade_queue) == nil and 0 or 1
		notice = i18n("common_text_2275")
		des = i18n("common_text_330")
	elseif self.type == gNPCHelperTypeDef.stuff then
		if tonumber(cityCtrl:getBuildCellByIndex(1050).info.lv) >= CASTLE_LV10_LIMITED and stuffWorkshopCtrl.dataTable.list then
			for i, v in ipairs(stuffWorkshopCtrl.dataTable.list) do
				if v.mid then
					cur = cur + 1
				elseif v.gold then
					break
				end
				total = total + 1
			end
		else
			total = 0
			cur = 0
		end
		notice = i18n("common_text_2276")
		des = i18n("common_text_2280")
	elseif self.type == gNPCHelperTypeDef.troops then
		total = buildLogic.getExpQueueCount().total
		cur = kingdomMapCtrl:isHasQueue()
		notice = i18n("common_text_2277")
		des = i18n("common_text_2281")
	elseif self.type == gNPCHelperTypeDef.army then
		for i, v in ipairs(self.tableArmyBuild) do
			if 0 < cityCtrl:getBuildCount(v.bid) then
				total = 1 + total
				if queueCtrl:queryQueue(v.queue) then
					cur = 1 + cur
				end
			end
		end
		notice = i18n("common_text_2278")
		des = i18n("common_text_2282")
	elseif self.type == gNPCHelperTypeDef.build then
		total = cityCtrl:getCurCity():queryQueue(gQueueTypeDef.charge_build_queue) and 2 or 1
		if queueCtrl:queryQueue(gQueueTypeDef.free_build_queue) then
			cur = cur + 1
		end
		if 2 <= total and queueCtrl:queryQueue(gQueueTypeDef.charge_build_queue) then
			cur = cur + 1
		end
		notice = i18n("common_text_2279")
		des = i18n("common_text_2283")
	end
	_ENV = nil
	;(nil).name = notice
	_ENV = v.queue
	v.queue.member = cur
	v.queue.total = total
	;(nil).msg = i18n("common_text_155", v.queue)
	self.labelName:setString(i18n("common_text_1000", nil))
	self.labelDes:setString(des)
	self.btnGo:setVisible(0 < total and total > cur)
	self.labelFull:setVisible(not self.btnGo:isVisible())
	self.labelFull:setString(total == 0 and i18n("common_text_2274") or i18n("common_text_708"))
	return self.btnGo:isVisible() and total ~= 0
end
function GameNPCHelperSingle:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.type == gNPCHelperTypeDef.college then
			_ENV = self.type
			self.type.msg = "MESSAGE_MAINCITYVIEW_OFFSET_BUILD_TIP_HAND"
			self.type.offsetType = MAINCITYVIEW_OFFSET_TYPE_BUILD_TIP_HAND
			self.type.bid = BUILDID.COLLEGE
			local self.type.iid, data = nil, self.type
			SoraDGotoCityBuild(data)
		elseif self.type == gNPCHelperTypeDef.stuff then
			_ENV = self.type
			self.type.msg = "MESSAGE_MAINCITYVIEW_OFFSET_BUILD_TIP_HAND"
			self.type.offsetType = MAINCITYVIEW_OFFSET_TYPE_BUILD_TIP_HAND
			self.type.bid = BUILDID.MATERIAL_WORKSHOP
			local self.type.iid, data = nil, self.type
			SoraDGotoCityBuild(data)
		elseif self.type == gNPCHelperTypeDef.troops then
			SoraDGotoWorldMapPoint()
		elseif self.type == gNPCHelperTypeDef.army then
			for i, v in ipairs(self.tableArmyBuild) do
				if cityCtrl:getBuildCount(v.bid) > 0 and queueCtrl:queryQueue(v.queue) == nil then
					_ENV = queueCtrl:queryQueue(v.queue)
					queueCtrl:queryQueue(v.queue).msg = "MESSAGE_MAINCITYVIEW_OFFSET_BUILD_TIP_HAND"
					queueCtrl:queryQueue(v.queue).offsetType = MAINCITYVIEW_OFFSET_TYPE_BUILD_TIP_HAND
					queueCtrl:queryQueue(v.queue).bid = v.bid
					local queueCtrl:queryQueue(v.queue).iid, data = nil, queueCtrl:queryQueue(v.queue)
					SoraDGotoCityBuild(data)
					break
				end
			end
		elseif self.type == gNPCHelperTypeDef.build then
			local quest = questCtrl:getPerformingGuideQuest()
			if quest then
				local questID = quest.questID
				local questType = questltCtrl:getQuestType(questID)
				if gQuestType.BUILD_BUILDING == questType or gQuestType.UPGRADE_BUILDING == questType or gQuestType.RESOURCE_OUTPUT == questType then
					questltCtrl:jumpToFinishedById(questID)
				else
					_ENV = questltCtrl.jumpToFinishedById
					questltCtrl.jumpToFinishedById.msg = "MESSAGE_MAINCITYVIEW_OFFSET_BUILD_TIP_HAND"
					questltCtrl.jumpToFinishedById.offsetType = MAINCITYVIEW_OFFSET_TYPE_BUILD_TIP_HAND
					questltCtrl.jumpToFinishedById.bid = nil
					local questltCtrl.jumpToFinishedById.iid, data = nil, questltCtrl.jumpToFinishedById
					SoraDGotoCityBuild(data)
				end
			else
				_ENV = quest.questID
				quest.questID.msg = "MESSAGE_MAINCITYVIEW_OFFSET_BUILD_TIP_HAND"
				quest.questID.offsetType = MAINCITYVIEW_OFFSET_TYPE_BUILD_TIP_HAND
				quest.questID.bid = nil
				local quest.questID.iid, data = nil, quest.questID
				SoraDGotoCityBuild(data)
			end
		end
		_ENV = SoraDGotoCityBuild
		SoraDGotoCityBuild.type = 0
		SoraDGotoCityBuild.jump = self.type
		userSDKManager.logEvent(gSDKDef.TDonEvent.game_assistant_log, SoraDGotoCityBuild)
		SoraDRemoveAllPanelFromManager()
	end
end
return GameNPCHelperSingle
