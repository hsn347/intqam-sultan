local ancientTreasureRead = include("ancientTreasureRead")
local ancientTreasureCtrl = SoraDGetCtrl("ancientTreasureCtrl")
local eventAncientSecretDigSingle = class("eventAncientSecretDigSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("eventAncientSecretDigSingle")
	end
	return target
end)
function eventAncientSecretDigSingle:ctor()
	SoraDGetAllChildFromWidget(self, self)
	self.isOpen = false
	self.size = cc.size(630, 110)
	self.Image_bgD:setVisible(false)
	self.Panel_touch:setSwallowTouches(false)
	self.Panel_touch:addTouchEventListener(handler(self, self.onArrowClick))
end
function eventAncientSecretDigSingle:initData(data, otherData)
	self.data = data
	self.leftDigTime = otherData.leftDigTime
	self.outputNum = otherData.outputNum
	self.instance = otherData.instance
	self.buildID = self.instance.buildID
	self.view = otherData.view
	self.scroll = otherData.scroll
	self.isOccupy = otherData.isOccupy
	self.armyNum = 0
	dump(self.data, "self.data=====")
	if next(self.data) and self.data.armyList then
		self.Node_none:setVisible(false)
		self.Node_have:setVisible(true)
		self.ccs_head = SoraDGetExtendChildFromCCSByName(self, "CCS_commonHead_head")
		self.ccs_head:setScale(0.9)
		self.ccs_head:setHeadSprite(self.data.imageId, self.data.avatar)
		self.ccs_head:setPlayerID(self.data.uid)
		self.ccs_head:setScroll(self.scroll)
		self.Text_name:setString(self.data.nickName)
		for k, v in pairs(self.data.armyList) do
			self.armyNum = self.armyNum + v.num
		end
		self.Text_army:setString(i18n("AncienTreasure_text_52") .. ":" .. string.formatnumberthousands(self.armyNum))
		self.Text_status:setString(i18n("overview_text_03"))
		self:updateDonate()
		if not self.timeHandle then
			self.timeHandle = SoradCreateTimer(self, handler(self, self.updateDonate))
		end
		self.Panel_touch:setTouchEnabled(true)
	else
		self:removeTimeHandle()
		self.Node_none:setVisible(true)
		self.Node_have:setVisible(false)
		self.Text_tip:setString(i18n("AncienTreasure_text_54"))
		self.Button_join:setSwallowTouches(false)
		self.Button_join:addTouchEventListener(handler(self, self.onAddClick))
		self.Panel_touch:setTouchEnabled(false)
	end
end
function eventAncientSecretDigSingle:onAddClick(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.instance and not tolua.isnull(self.instance) then
			local dispatchPanel = uiManager:show("WorldDispatchArmyView")
			_ENV = nil
			;(nil).toPoint = self.instance.pos
			;(nil).dispatchType = worldMapDefine.worldMapTipButtonType_wajue
			;(nil).instanceID = self.instance.instanceID
			dispatchPanel:initData(nil)
		elseif self.view and not ancientTreasureCtrl:getBuildInfoInAlliance(self.buildID) then
			self.view:removeFromParent()
		end
	end
end
function eventAncientSecretDigSingle:onArrowClick(target, event)
	if event == ccui.TouchEventType.ended then
		if self.scroll and not SoraDIsNodeVisibleOnScroll(target, self.scroll, event) then
			print("node is not on view")
			return
		end
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		print("点击打开")
		self.isOpen = not self.isOpen
		local rotation = SoraDFIsRA() and (self.isOpen and 0 or 90) or self.isOpen and 0 or -90
		self.Sprite_arr:setRotation(rotation)
		self.Image_bgD:setVisible(self.isOpen)
		if self.isOpen then
			self:setArmyInfo()
		else
			self.size = cc.size(630, 110)
		end
		_ENV = 630
		;(630).msg = "MESSAGE_UI_ANCIENT_DIGDETAILVIEW"
		SoraDSendMessage(630)
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif event == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	elseif event == ccui.TouchEventType.began then
		self.singleIsMoved = false
	end
end
function eventAncientSecretDigSingle:setArmyInfo()
	self.Node_army:removeAllChildren()
	local armsData = self.data.armsInfo
	local divineBeastData = self.data.divineBeastInfo
	local hArms = 0
	local totalH = (next(self.data.heroInfo) and 96 or 0) + #self.data.armyList * 80 + 86
	if armsData and next(armsData) or divineBeastData and next(divineBeastData) then
		hArms = 140
		totalH = totalH + hArms
	end
	self.Image_bgD:setContentSize(cc.size(630, totalH))
	self.Node_army:setPositionY(0)
	local posYtmp = 0
	if next(self.data.heroInfo) then
		for k, v in ipairs(self.data.heroInfo) do
			local heroItem = include("heroShowItem").new()
			heroItem:setScale(0.8)
			heroItem:initData(v.heroID)
			heroItem:setPositionY(totalH - 70)
			heroItem:addTo(self.Node_army)
		end
		SoraDToCenter(self.Node_army, 100)
		posYtmp = posYtmp + 96
	end
	if armsData and next(armsData) then
		local armsShowBanner = include("artifactShowBanner").new()
		armsShowBanner:addTo(self.Node_army)
		armsShowBanner:initData(armsData)
		self.armsShowBanner = armsShowBanner
	end
	dump(divineBeastData, "divineBeastData")
	if divineBeastData and next(divineBeastData) then
		self.divineBeastBanner = SoraDCreatePanel("commonDivinebeast")
		self.divineBeastBanner:setScale(0.85)
		self.divineBeastBanner:addTo(self.Node_army)
		self.divineBeastBanner:initData(divineBeastData[1], 2)
	end
	posYtmp = posYtmp + hArms
	if self.armsShowBanner then
		self.armsShowBanner:setPosition(cc.p(SoraDFIsRA() and -20 or 20, totalH - posYtmp + 50))
	end
	if self.divineBeastBanner then
		if self.armsShowBanner == nil then
			self.divineBeastBanner:setPositionX(SoraDFIsRA() and 200 or -200)
		else
			self.divineBeastBanner:setPositionX(SoraDFIsRA() and -100 or 50)
		end
		self.divineBeastBanner:setPositionY(totalH - posYtmp - 10)
	end
	if next(self.data.armyList) then
		for k, v in ipairs(self.data.armyList) do
			local armyItem = include("commonArmySingle").new()
			armyItem:initData(v)
			armyItem:setPosition(0, totalH - posYtmp - 70 - 80 * k)
			armyItem:addTo(self.Node_army)
		end
	end
	self.size = cc.size(630, 46 + totalH)
end
function eventAncientSecretDigSingle:removeTimeHandle()
	if self.timeHandle then
		SoraDManagerRemoveTimer(self, self.timeHandle)
		self.timeHandle = nil
	end
end
function eventAncientSecretDigSingle:updateDonate()
	if next(self.data) and self.data.armyList and self.data.lastCollTime and self.data.alreadyCollNum then
		local donate = ancientTreasureCtrl:getPlayerDonate(self.data.armyList, self.data.lastCollTime, self.data.alreadyCollNum, self.armyNum, self.outputNum)
		self.Text_donate:setString(i18n("AncienTreasure_text_53") .. donate .. "%")
		if 100 <= donate then
			self:removeTimeHandle()
		end
	end
end
return eventAncientSecretDigSingle
