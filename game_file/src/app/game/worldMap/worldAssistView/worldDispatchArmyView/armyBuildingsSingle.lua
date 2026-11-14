local gametop = gModuleMgr.getObject("gametop")
local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
local buildLogic = include("buildLogic")
local armyBuildingsSingle = class("armyBuildingsSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("armyBuildingsSingle")
	end
	return target
end)
function armyBuildingsSingle:ctor()
	self.Image_event = SoraDGetChildByName(self, "Image_event")
	self.Image_shader = SoraDGetChildByName(self, "Image_shader")
	self.Image_shader:setVisible(false)
	self.Text_name = SoraDGetChildByName(self, "Text_name")
	self.Text_status = SoraDGetChildByName(self, "Text_status")
	self.Text_status:setVisible(false)
	self.Button_go = SoraDGetChildByName(self, "Button_go")
	self.Button_go:setTitleText(i18n("common_text_477"))
	self.Button_go:setSwallowTouches(false)
	self.Button_go:addTouchEventListener(handler(self, self.btnGoClick))
end
function armyBuildingsSingle:initData(data, otherData)
	self.data = data
	self.scroll = otherData.scroll
	self.Image_event:loadTexture(self.data.png, ccui.TextureResType.plistType)
	self.Text_name:setString(self.data.name)
	self:setBuildStatus()
end
function armyBuildingsSingle:setBuildStatus()
	local setBusyStatus = function(str)
		self.Button_go:setVisible(false)
		self.Text_status:setVisible(true)
		self.Text_status:setString(str)
		self.Text_status:setColor(cc.c3b(0, 190, 30))
		self.Image_shader:setVisible(true)
	end
	local setNoBuildStatus = function()
		self.Button_go:setVisible(true)
		self.Text_status:setVisible(false)
		self.Button_go:setTitleText(i18n("common_text_042"))
		self.Image_shader:setVisible(false)
	end
	local setNormalStatus = function()
		self.Button_go:setVisible(true)
		self.Text_status:setVisible(false)
		self.Button_go:setTitleText(i18n("common_text_477"))
		self.Image_shader:setVisible(false)
	end
	local setLessStatus = function(str)
		self.Button_go:setVisible(false)
		self.Text_status:setVisible(true)
		self.Text_status:setString(str)
		self.Text_status:setColor(cc.c3b(190, 40, 40))
		self.Image_shader:setVisible(true)
	end
	if self.data.isTrain then
		local hasBuild = buildLogic.isOwnBuild(self.data.bid)
		if hasBuild then
			if worldMapDefine.isInWarForbid(true) then
				setLessStatus(worldMapDefine.getWarTips())
			else
				local statusStr = buildLogic.getBuildStateStr(self.data.bid)
				if statusStr then
					setBusyStatus(statusStr)
				else
					setNormalStatus()
				end
			end
		else
			setNoBuildStatus()
		end
	end
	if self.data.isTreat then
		local hasBuild = buildLogic.isOwnBuild(self.data.bid)
		if hasBuild then
			local armyCtrl = gametop.playertop_:getModule("armyCtrl")
			local woundedArmyData = armyCtrl:getWoundedArmy()
			if woundedArmyData and next(woundedArmyData) then
				local statusStr = buildLogic.getBuildStateStr(self.data.bid)
				if statusStr then
					setBusyStatus(statusStr)
				else
					setNormalStatus()
				end
			else
				setLessStatus(i18n("common_text_409"))
			end
		else
			setNoBuildStatus()
		end
	end
	if self.data.isItem then
		local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
		local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
		local list = backpackltCtrl:getItemArray(self.data.goodType)
		for i, v in ipairs(list) do
			if backpackCtrl:getItemCount(v) > 0 then
				self.data.iid = v
				break
			end
		end
		if worldMapDefine.isInWarForbid(true) then
			setLessStatus(worldMapDefine.getWarTips())
		elseif self.data.iid then
			setNormalStatus()
		else
			setLessStatus(i18n("hero_text_84"))
		end
	end
	if self.data.isResurgence then
		if SoraDGetCastleLv() < CASTLE_LV6_LIMITED then
			setLessStatus(i18n("common_text_2274"))
		else
			local isTree = self.data.key == "OpResuscitate"
			local openStatus = self.data.key == "OpResuscitate" and gResurrectionActivityState.OPEN or gLifeWaterActivityState.OPEN
			local resurgenceCtrl = isTree and gametop.playertop_:getModule("resurrectionCtrl") or gametop.playertop_:getModule("lifeWaterCtrl")
			local status = resurgenceCtrl:getResurrectionState()
			if status == openStatus then
				local armyCount = resurgenceCtrl:getUnResurrectionArmyCount()
				if 0 < armyCount then
					setNormalStatus()
				else
					setLessStatus(i18n("common_text_1415"))
				end
			else
				setLessStatus(i18n("common_text_3675"))
			end
		end
	end
end
function armyBuildingsSingle:btnGoClick(button, event)
	if event == ccui.TouchEventType.ended then
		if self.scroll and not SoraDIsNodeVisibleOnScroll(button, self.scroll) then
			return
		end
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		local data = self.data
		SoraDRemoveAllPanelFromManager()
		if data.isTrain then
			_ENV = nil
			;(nil).bid = data.bid
			mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.TRAIN_SOLDIERS, nil)
		elseif data.isTreat then
			_ENV = nil
			mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.TREAT, nil)
		elseif data.isResurgence then
			_ENV = nil
			;(nil).key = data.key
			mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.RESURGENCE, nil)
		elseif data.isItem then
			_ENV = nil
			;(nil).type = 0
			;(nil).item = data.iid
			uiManager:show("bagView", nil)
		end
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = button:getTouchBeganPosition()
		local touchmovePoint = button:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif event == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
return armyBuildingsSingle
