local queueCtrl = SoraDGetCtrl("queueCtrl")
local technologyCtrl = SoraDGetCtrl("technologyCtrl")
local collegeDesRead = include("collegeDesRead")
local baseComponent = require("fgui.base.baseComponent")
local processSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://BrilliantBrave/processSingle", processSingle)
function processSingle:onInit()
	self.queueType = gQueueTypeDef.craft_study
	self.fields.Text_Max:setString(i18n("common_text_283"))
	self.textTime = SoraDCreateTimerLabel(self, self.fields.Text_Time)
	self.textTime:setTimeEndListener(function(...)
		self.controllers.c1:setSelectedIndex(0)
	end)
	self:addClickListener(handler(self, self.btnDetailClick))
end
function processSingle:registerEvent()
	SoraDAddMessage(self, "MESSAGE_UPDATE_TECHNOLOGY", handler(self, self.msgCallBack))
end
_ENV, _ENV, processSingle.onShow = "ui://BrilliantBrave/processSingle", function(self)
end, function(self)
end
;("ui://BrilliantBrave/processSingle").index = 2
_ENV, (function(self)
end).red, ("ui://BrilliantBrave/processSingle").color = "ui://BrilliantBrave/processSingle", "ui://BrilliantBrave/processSingle", cc.c3b(198, 96, 97)
;("ui://BrilliantBrave/processSingle").index = 3
_ENV, (function(self)
end).yellow, ("ui://BrilliantBrave/processSingle").color = "ui://BrilliantBrave/processSingle", "ui://BrilliantBrave/processSingle", cc.c3b(223, 178, 88)
;("ui://BrilliantBrave/processSingle").index = 1
_ENV, (function(self)
end).blue, ("ui://BrilliantBrave/processSingle").color = "ui://BrilliantBrave/processSingle", "ui://BrilliantBrave/processSingle", cc.c3b(106, 175, 255)
;("ui://BrilliantBrave/processSingle").index = 5
_ENV, (function(self)
end).green, ("ui://BrilliantBrave/processSingle").color = "ui://BrilliantBrave/processSingle", "ui://BrilliantBrave/processSingle", cc.c3b(84, 155, 169)
;("ui://BrilliantBrave/processSingle").index = 4
;(function(self)
end).purple, ("ui://BrilliantBrave/processSingle").color = "ui://BrilliantBrave/processSingle", cc.c3b(141, 88, 223)
local function colorIndex(self)
end
function processSingle:initData(data, needQuality, isHideTime)
	self.needQuality = needQuality
	self.isHideTime = isHideTime
	self.needBuildLv = data.lv
	self.technologyID = data.technologyID
	self.type = "process"
	if not technologyCtrl:getTechnoDataByID(self.technologyID, self.type) then
		local technologyCtrl, singleleData = technologyCtrl:getTechnoDataByID(self.technologyID, self.type), technologyCtrl:getTechnoDataByID(self.technologyID, self.type)
	end
	local singleDetails = technologyCtrl:getTechnologyDetails(self.technologyID, singleleData.currentLevel)
	self.isUnlock = self:checkTechUnlock(singleDetails.starbuild)
	self.isSpecialShow = self:warframeSpecialShow()
	if self.isSpecialShow then
		self.fields.icon:setURL("icon_lostRuins_quest.png")
		self.fields.Text_Name:setColor(display.COLOR_RED)
		self.fields.Text_Name:setString("???")
	else
		self.fields.icon:setURL(collegeDesRead.getIcon(self.technologyID))
		self.fields.Text_Name:setColor(cc.c3b(255, 200, 100))
		self.fields.Text_Name:setString(collegeDesRead.getName(self.technologyID))
	end
	local colorID = string.sub(collegeDesRead.getIcon(self.technologyID), 19, 20)
	local colorName = collegeDesRead.getColorByID(tonumber(colorID)) or "red"
	print("colorIndex[colorName]", colorName, colorID, self.technologyID, collegeDesRead.getIcon(self.technologyID))
	local framesNpc = display.newFrames("dh_gybs" .. colorIndex[colorName].index .. "_%03d.png", 0, 14)
	local animationNpc = display.newAnimation(framesNpc, 0.08333333333333333)
	self.fields.Movie_Icon:setAnimation(animationNpc)
	self.fields.effect:setColor(colorIndex[colorName].color)
	self:runUnlockAction()
	self:updateTime()
end
function processSingle:runUnlockAction()
	self.fields.Com_Lock:setVisible(not self.isUnlock)
end
function processSingle:updateTime()
	if not technologyCtrl:getTechnoDataByID(self.technologyID, self.type) then
		local technologyCtrl, singleleData = technologyCtrl:getTechnoDataByID(self.technologyID, self.type), technologyCtrl:getTechnoDataByID(self.technologyID, self.type)
	end
	local singleDetails = technologyCtrl:getTechnologyDetails(self.technologyID, singleleData.currentLevel)
	self.controllers.c1:setSelectedIndex(0)
	if singleDetails.upgradeIngTechnology and singleDetails.upgradeIngTechnology[3] then
		local forgQueue = queueCtrl:queryQueue(self.queueType)
		if forgQueue then
			local leftTime = forgQueue.timerNode.timer:getRemainTime()
			if 0 < leftTime and not self.isHideTime then
				self.controllers.c1:setSelectedIndex(1)
				self.textTime:beginTime(leftTime)
			end
		end
	end
	self.fields.Text_Lv:setString(singleleData.currentLevel)
	if singleleData.currentLevel >= singleleData.maxLevel then
		self.controllers.c2:setSelectedIndex(1)
	else
		self.controllers.c2:setSelectedIndex(0)
	end
	if singleleData.currentLevel == 0 then
		self.fields.icon:setColor(cc.c3b(120, 120, 120))
		self.controllers.c3:setSelectedIndex(0)
	else
		self.fields.icon:setColor(cc.c3b(255, 255, 255))
		self.controllers.c3:setSelectedIndex(1)
		self.transitions.t0:play(-1, 0, 0, -1)
	end
end
function processSingle:msgCallBack(target, data)
	if data.technology and data.technology[tostring(self.technologyID)] then
		self:updateTime()
		if self.ownView then
			self.ownView:updateMaxNum()
		end
	end
end
function processSingle:warframeSpecialShow()
	if self.needQuality then
		_UPVALUE1_ = nil
		;(nil)[1] = 9
		for i, v in ipairs(nil) do
			if v == self.needQuality and SoraDGetBuildQuality() < self.needQuality then
				return true
			end
		end
	end
end
function processSingle:checkTechUnlock(starbuild)
	for i, v in ipairs(starbuild) do
		if v.bid == 304 and not v.isContentmented then
			return false
		end
	end
	return true
end
function processSingle:btnDetailClick()
	SoraDPlaySound()
	if self.isSpecialShow then
		local panel = SoraDCreatePanel("commonLimitBox")
		panel:setImageTouchEnable()
		local _ENV, lockInfo = panel.setImageTouchEnable, panel.setImageTouchEnable
		local cityltCtrl = include("cityltCtrl")
		local qualityInfo = cityltCtrl.getQualityByStarLv(self.needBuildLv)
		_ENV = nil
		_ENV = nil
		;(nil).quality = cityltCtrl.getStatueBraveQualityName(self.needQuality)
		;(nil).lv = qualityInfo.level
		;(nil).content = i18n("Soldiers_armor_text_60", nil)
		;(nil).icon = include("buildDescribeRead").getIcon(304)
		;(nil).btnTitle = i18n("common_text_477")
		;(nil).btnFun = function(target)
			local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
			_ENV = nil
			;(nil).key = "OpstatueBrave"
			mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.TO_BUILD_STATUE_BRAVE, nil)
			SoraDRemoveAllPanelFromManager()
		end
		;(nil).isReach = false
		table.insert(lockInfo, nil)
		if panel:judgeData(lockInfo) then
			panel:hideTitle()
			panel:initData(lockInfo)
			panel:show()
		end
	else
		_ENV = cityltCtrl.getQualityByStarLv(self.needBuildLv)
		cityltCtrl.getQualityByStarLv(self.needBuildLv).technologyID = self.technologyID
		uiManager:show("ArmorTechnologyDetail", (cityltCtrl.getQualityByStarLv(self.needBuildLv)))
	end
end
return processSingle
