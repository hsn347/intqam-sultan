local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaAreaTechPanel = class("NebulaAreaTechPanel", baseFguiPanel)
local waitQueueCtrl = SoraDGetCtrl("waitQueueCtrl")
local technologyCtrl = SoraDGetCtrl("technologyCtrl")
local technologyLocalData = include("technologyLocalData")
local collegeDesRead = include("collegeDesRead")
function NebulaAreaTechPanel:ctor(...)
	self.super.ctor(self, ...)
	self.isHideCurrentSceneView = true
	self.debug = true
end
function NebulaAreaTechPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "fonts"
	end
	return self._packageList
end
function NebulaAreaTechPanel:onInit()
	if not SoraDFIsRA() then
		self.view:fixChildrenPos(false, true)
	end
	self.fields.Usm_bg:updateUsmColor(cc.c3b(179, 179, 179))
	print("=======NebulaAreaTechPanel:onInit")
	self.isFree = false
	self.fields.Com_title:initData(i18n("nebula_war_text_0156"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.btn_add:setTitle(i18n("common_text_018"))
	self.fields.btn_add:addClickEventListener(handler(self, self.btnSpeedUpClickCallBack))
	self.fields.btn_add_gold:setTitle(i18n("common_text_335"))
	self.fields.btn_add_gold:addClickEventListener(handler(self, self.btnStudyingNowClickCallBack))
	self.fields.btn_add_gold2:addClickEventListener(handler(self, self.btnStudyingNowClickCallBack))
	self.fields.btn_add_gold2:setTitle(i18n("common_text_335"))
	self.fields.btn_add_gold2:setCostNum(0)
	self.fields.skill_list:setVirtual()
	self.fields.skill_list:setItemRenderer(handler(self, self.onTechsRender))
end
function NebulaAreaTechPanel:onShow()
	print("=======NebulaAreaTechPanel:onShow")
	self:updateView()
end
function NebulaAreaTechPanel:updateView(isEnd)
	self.tableStuding, self.studyingType = technologyCtrl:studyingTechnology(gQueueTypeDef.nebula_palace_technology)
	self.controllers.c1:setSelectedIndex(self.tableStuding ~= nil and 0 or 1)
	if self.timer then
		SoraDManagerRemoveTimer(self, self.timer)
	end
	if self.tableStuding and not isEnd then
		local backpackCtrl = SoraDGetCtrl("backpackCtrl")
		self.tableItemData = backpackCtrl:getSpeedUpItemList(gAbbrSpeedUpType.TECH)
		self.fields.text_tech_name:setString(collegeDesRead.getName(self.tableStuding.technologyID))
		self.fields.text_tech_desc:setString(collegeDesRead.getDes(self.tableStuding.technologyID))
		self.fields.btn_tech:setIcon(collegeDesRead.getIcon(self.tableStuding.technologyID))
		fguiHelper.get_fields(self.fields.btn_tech).bg:setURL(SoraDCheckPNG(collegeDesRead.getBg(self.tableStuding.technologyID), "frame_round_tech_01.png"))
		local queueCtrl = SoraDGetCtrl("queueCtrl")
		self.queue = queueCtrl:queryQueue(gQueueTypeDef.nebula_palace_technology)
		self:showParticle()
		self:openTimeUp()
		self.timer = SoradCreateTimer(self, handler(self, self.openTimeUp))
	else
		if self.isMildFree then
			self.isMildFree = false
			gModuleMgr.sharedMgr("mildGuideManager"):deleteRunEffect()
		end
		if technologyCtrl:checkIsFull("nebula") then
			self.fields.text_no_tip:setString(i18n("nebula_war_text_0159"))
		else
			self.fields.text_no_tip:setString(i18n("nebula_war_text_0160"))
		end
	end
	self:updateTechs()
end
function NebulaAreaTechPanel:updateTechs()
	local jumpTechId = gModuleMgr.sharedMgr("mildGuideManager"):getVariate("NebulaAreaTechPanel", "techId")
	local jumpIdx = -1
	local newbulaShow = technologyLocalData.getNebulaShow()
	local _ENV, showData = "techId", "techId"
	local cityCtrl = SoraDGetCtrl("cityCtrl")
	local isMaxLv = false
	local maxLv = 0
	local nextMaxLv = 0
	for i, v in ipairs(newbulaShow) do
		if type(jumpTechId) == "number" then
			for i2 = 1, 4 do
				if v.technologyID[i2] == jumpTechId then
					jumpIdx = i - 1
				end
			end
		end
		local blv = cityCtrl:getBuildMaxLv(v.lv.bid)
		if blv and blv >= v.lv.lv then
			table.insert(showData, v)
		elseif not isMaxLv then
			maxLv = v.lv.lv
			isMaxLv = true
			table.insert(showData, v)
		else
			nextMaxLv = v.lv.lv
			break
		end
	end
	self.maxLv = maxLv
	self.nextMaxLv = nextMaxLv
	self.showData = showData
	self.newbulaShow = newbulaShow
	local isAllShow = #showData == #newbulaShow
	self.fields.skill_list:setNumItems(isAllShow and #showData or #showData + 1)
	if type(jumpTechId) == "number" then
		jumpIdx = jumpIdx == -1 and self.fields.skill_list:getNumItems() - 1 or jumpIdx
		self.fields.skill_list:scrollToView(jumpIdx, true)
	end
end
function NebulaAreaTechPanel:openTimeUp(dt)
	local leftTime = self.queue.timerNode.timer:getRemainTime()
	local totalTime = self.queue.totaltime
	self.fields.time_progress:initData(SoraDConvertSecondToString(leftTime), (totalTime - leftTime) / totalTime)
	if leftTime <= 0 then
		self:updateView(true)
	end
	local freeTime = technologyCtrl:getFreeSpeedUpTime(self.queue.qtype)
	local newFree = self.isFree
	if leftTime <= freeTime then
		newFree = true
		if not SoraDIsGameGuide() and not self.isMildFree and self.fields.btn_add_gold2:isVisible() then
			_ENV = nil
			;(nil).z = 1
			gModuleMgr.sharedMgr("mildGuideManager"):drawFingerToTarget(self.fields.btn_add_gold2, nil)
			self.isMildFree = true
		end
		self.fields.btn_add_gold:setVisible(false)
		self.fields.btn_add:setVisible(false)
		self.fields.arrow:setVisible(false)
		self.fields.btn_add_gold2:setVisible(true)
		self.fields.btn_add_gold2:setCostNum(0)
	else
		if self.isMildFree then
			self.isMildFree = false
			gModuleMgr.sharedMgr("mildGuideManager"):deleteRunEffect()
		end
		local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
		local goldPay = serviceFunctions.timeConvertToGold(leftTime)
		local haveGold = lordInfoCtrl:getBaseInfo().gold
		if self.tableItemData ~= nil and next(self.tableItemData) == nil then
			self.fields.btn_add_gold2:setCostNum(math.floor(goldPay), haveGold)
			self.fields.btn_add_gold2:setVisible(true)
			self.fields.btn_add:setVisible(false)
			self.fields.btn_add_gold:setVisible(false)
			self.fields.arrow:setVisible(false)
		else
			self.fields.btn_add_gold:setCostNum(math.floor(goldPay), haveGold)
			self.fields.btn_add_gold:setVisible(true)
			self.fields.btn_add:setVisible(true)
			self.fields.btn_add_gold2:setVisible(false)
			self.fields.arrow:setVisible(true)
		end
		newFree = false
	end
	self.isFree = newFree
end
function NebulaAreaTechPanel:showParticle()
	fguiHelper.get_fields(self.fields.btn_tech).Particle_1:setVisible(true)
	for k, v in pairs(fguiHelper.get_fields(self.fields.btn_tech).Particle_1:getChildren()) do
		v:resetSystem()
	end
	fguiHelper.get_fields(self.fields.btn_tech).Particle_2:setVisible(true)
end
function NebulaAreaTechPanel:btnSpeedUpClickCallBack(button, type)
	SoraDPlaySound()
	SoraDShowSpeedUpByItemBox(self.queue.qtype)
end
function NebulaAreaTechPanel:btnStudyingNowClickCallBack(button, type)
	SoraDPlaySound()
	if self.timer then
		if self.isFree then
			local queueCtrl = SoraDGetCtrl("queueCtrl")
			queueCtrl:speedUpQueueReq(tonumber(self.queueType), SPEEDUP_TYPE.FREE)
			self:updateView()
		else
			SoraDShowSpeedUpBox(self.queue, nil, i18n("common_text_765"))
		end
	elseif self.isFree then
		technologyCtrl = i18n("common_text_765")
		i18n("common_text_765")[1] = self.tableSingleData.technologyID
		technologyCtrl:instantResearch(self.tableSingleData.technologyID, i18n("common_text_765"))
		self:updateView()
	else
		SoraDShowBuyBox(i18n("StarTreasure_text_03"), self.tableSingleDetails.cost, i18n("common_text_335"), function(eventType)
			if eventType == MSGBOX_CALLBACK_YES and not tolua.isnull(self) and SoraDEnoughGold(self.tableSingleDetails.cost) then
				self = nil
				;(nil)[1] = self.tableSingleData.technologyID
				technologyCtrl:instantResearch(self.tableSingleData.technologyID, nil)
				button:setTouchEnabled(false)
				self:updateView()
			end
		end)
	end
end
function NebulaAreaTechPanel:onClickHelp()
	SoraDPlaySound()
	if IsArClient then
		userSDKManager.showSingleFAQ(gSDKDef.FAQSingleType.NEBULA_AREA)
	else
		userSDKManager.showFAQSection(gSDKDef.FAQSectionType.NEBULA_AREA_ROS)
	end
end
function NebulaAreaTechPanel:onTechsRender(index, obj)
	local data = self.showData[index + 1]
	if not data then
		obj:setData()
		obj:setLv(self.nextMaxLv)
		return
	end
	local isLock = self.maxLv == data.lv.lv
	obj:setData(data, isLock, #self.newbulaShow == index + 1)
end
return NebulaAreaTechPanel
