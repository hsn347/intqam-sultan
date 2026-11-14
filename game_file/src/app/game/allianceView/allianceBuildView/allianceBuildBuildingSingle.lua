local gametop = gModuleMgr.getObject("gametop")
local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
local allianceDesRead = include("allianceDesRead")
local allianceBuildBuildingSingle = class("allianceBuildBuildingSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceBuildBuildingSingle")
	end
	return target
end)
function allianceBuildBuildingSingle:ctor()
	self.singleIsMoved = false
	self.totalArmyCount = 0
	self.tableArmySingle, _ENV, self.data, _ENV, self.isFold = nil, nil, nil, nil, true
	self.handlRepatriate = nil
	self.scroll = nil
	self.Image_bgD = SoraDGetChildByName(self, "Image_bgD")
	self.Image_bgD:setVisible(false)
	self.Panel_touch = SoraDGetChildByName(self, "Panel_touch")
	self.Panel_touch:setSwallowTouches(false)
	self.Panel_touch:addTouchEventListener(handler(self, self.btnUnfoldCallBack))
	self.Node_info = SoraDGetChildByName(self, "Node_info")
	self.Sprite_arr = SoraDGetChildByName(self, "Sprite_arr")
	self.Text_name = SoraDGetChildByName(self, "Text_name")
	self.Text_troop = SoraDGetChildByName(self, "Text_troop")
	self.Text_status = SoraDGetChildByName(self, "Text_status")
	self.Text_status:setString(i18n("common_text_043"))
	self.ccs_head = SoraDGetExtendChildFromCCSByName(self, "CCS_commonHead_head")
	self.frame_add = SoraDGetChildByName(self, "frame_add")
	self.icon_lock = SoraDGetChildByName(self, "icon_lock")
	self.Text_notice = SoraDGetChildByName(self, "Text_notice")
	self.Button_back = SoraDGetChildByName(self, "Button_back")
	self.Button_back:setVisible(false)
	self.Button_back:setTitleText(i18n("common_text_017"))
	self.Button_back:addTouchEventListener(handler(self, self.btnBackClick))
end
function allianceBuildBuildingSingle:setScroll(scroll)
	self.scroll = scroll
end
function allianceBuildBuildingSingle:btnUnfoldCallBack(button, event)
	if event == ccui.TouchEventType.ended then
		if not SoraDIsNodeVisibleOnScroll(button, self.scroll) then
			print("node is not on view")
			return
		end
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		if self.data.sType == 3 then
			return
		end
		if self.data.army then
			self:meFoldOrNot()
		else
			if self.data.isSelfIn then
				SoraDShowMsgTip(i18n("alliance_stronghold_text_018"))
				return
			end
			if self.isFull then
				SoraDShowMsgTip(i18n("alliance_stronghold_text_109"))
				return
			end
			local dispatchPanel = uiManager:show("WorldDispatchArmyView")
			dispatchPanel:initData(self.data.dispatchData)
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
function allianceBuildBuildingSingle:getSingleHeight()
	local height = 110
	if not self.isFold then
		local addH = 0
		local btnH = 0
		if self.data then
			if self.data.heroInfo and next(self.data.heroInfo) then
				addH = addH + 125
			end
			if self.data.armsInfo and next(self.data.armsInfo) then
				addH = addH + 125
			end
			btnH = self.data.playerID and self.data.playerID == gametop.playertop_:getPlayerID() and 50 or 0
		end
		height = height + #self.data.army * 100 + addH + btnH + 50
	end
	return height
end
function allianceBuildBuildingSingle:isFold()
	return self.isFold
end
function allianceBuildBuildingSingle:getTotalArmyCount()
	return self.totalArmyCount
end
function allianceBuildBuildingSingle:getQid()
	return self.data.playerID
end
function allianceBuildBuildingSingle:setParent(parent)
	self.parent = parent
end
function allianceBuildBuildingSingle:btnBackClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		kingdomMapCtrl:reqBackQueueById(self.data.queueId)
		self.parent:removeFromParent()
	end
end
function allianceBuildBuildingSingle:initData(data, isFold, classID, isFull)
	self.data = data
	self.classID = classID
	self.isFull = isFull
	if isFold then
		self.isFold = isFold
	end
	self:update()
	if self.data.sType == 1 then
		self.Node_info:setVisible(true)
		self.ccs_head:setVisible(true)
		self.ccs_head:setPlayerID(self.data.playerID)
		self.ccs_head:setHeadSprite(self.data.headid, self.data.avatar)
		self.ccs_head:setScale(1.0)
		self.frame_add:setVisible(false)
		self.icon_lock:setVisible(false)
		self.Text_notice:setVisible(false)
		self.Text_name:setString(self.data.playerName)
		self.totalArmyCount = self.data.armyNum
		_ENV = nil
		;(nil).cur = string.formatnumberthousands(self.totalArmyCount)
		self.Text_troop:setString(i18n("common_text_297", nil))
	elseif self.data.sType == 2 then
		self.Node_info:setVisible(false)
		self.ccs_head:setVisible(false)
		self.frame_add:setVisible(true)
		self.icon_lock:setVisible(false)
		self.Text_notice:setVisible(true)
		_ENV = i18n("common_text_297", nil)
		i18n("common_text_297", nil).name = i18n(allianceDesRead.getBuildName(self.classID))
		self.Text_notice:setString(i18n("alliance_stronghold_text_092", i18n("common_text_297", nil)))
	elseif self.data.sType == 3 then
		self.Node_info:setVisible(false)
		self.ccs_head:setVisible(false)
		self.frame_add:setVisible(false)
		self.icon_lock:setVisible(true)
		self.Text_notice:setVisible(true)
		self.Text_notice:setString(i18n("common_text_304"))
	end
end
function allianceBuildBuildingSingle:update()
	if self.isFold == false then
		self:meFoldOrNot()
	end
end
function allianceBuildBuildingSingle:meFoldOrNot()
	if self.isFold and self.data and next(self.data) then
		self.isFold = false
		self.Sprite_arr:setRotation(SoraDFSign(0))
		local totalH = 110
		local HeroBannerH = 125
		local armyItemH = 100
		local isSelfArmy = self.data.playerID == gametop.playertop_:getPlayerID()
		local btnH = isSelfArmy and 50 or 0
		local bgSize = self.Image_bgD:getContentSize()
		self.Image_bgD:setVisible(true)
		self.Button_back:setVisible(isSelfArmy)
		local isHaveHero = false
		if self.data.heroInfo and next(self.data.heroInfo) then
			isHaveHero = true
			self.herosBanner = SoraDCreatePanel("heroShowBanner")
			self.herosBanner:setScale(0.85)
			self.herosBanner:initData(self.data.heroInfo)
			self.herosBanner:addTo(self.Image_bgD)
			totalH = totalH + HeroBannerH + self.herosBanner:getExtendHeight()
		end
		local isHaveArms = false
		if self.data.armsInfo and next(self.data.armsInfo) then
			isHaveArms = true
		end
		local isHaveDivineBeast = false
		if self.data.divineBeastInfo and next(self.data.divineBeastInfo) then
			isHaveDivineBeast = true
		end
		if isHaveArms or isHaveDivineBeast then
			totalH = totalH + HeroBannerH
		end
		if self.data.army then
			totalH = totalH + #self.data.army * 100 + btnH
		else
			totalH = totalH + btnH
		end
		self.Image_bgD:setContentSize(cc.size(self.Image_bgD:getContentSize().width, totalH))
		if isHaveHero then
			self.herosBanner:setPosition(bgSize.width / 2, totalH - 70)
			totalH = totalH - HeroBannerH - self.herosBanner:getExtendHeight()
		end
		if isHaveArms then
			self.artifactShowBanner = SoraDCreatePanel("artifactShowBanner")
			self.artifactShowBanner:setScale(0.85)
			self.artifactShowBanner:initData(self.data.armsInfo)
			self.artifactShowBanner:setPosition(bgSize.width / 2, totalH - 70)
			self.artifactShowBanner:addTo(self.Image_bgD)
		end
		if isHaveDivineBeast then
			self.divineBeastBanner = SoraDCreatePanel("commonDivinebeast")
			if not isHaveArms then
				self.divineBeastBanner:setPositionX(SoraDFIsRA() and 550 or 90)
			else
				self.divineBeastBanner:setPositionX(SoraDFIsRA() and 200 or 450)
			end
			self.divineBeastBanner:setScale(0.85)
			self.divineBeastBanner:setPositionY(totalH - 120)
			self.divineBeastBanner:addTo(self.Image_bgD)
			self.divineBeastBanner:initData(self.data.divineBeastInfo[1], 2)
		end
		if isHaveArms or isHaveDivineBeast then
			totalH = totalH - HeroBannerH
		end
		if self.data.army then
			for i, v in ipairs(self.data.army) do
				local nodeArmy = include("commonArmySingle").new()
				nodeArmy:initData(v)
				nodeArmy:setPosition(bgSize.width / 2, totalH - i * armyItemH - 70)
				nodeArmy:addTo(self.Image_bgD)
				table.insert(self.tableArmySingle, nodeArmy)
			end
		end
	else
		self.Sprite_arr:setRotation(SoraDFPosX(90, 0))
		self.isFold = true
		self.Button_back:setVisible(false)
		self.Image_bgD:setContentSize(cc.size(self.Image_bgD:getContentSize().width, 74))
		self.Image_bgD:setVisible(false)
		for i, v in ipairs(self.tableArmySingle) do
			v:removeFromParent()
		end
		if self.herosBanner then
			self.herosBanner:removeFromParent()
			self.herosBanner = nil
		end
		if self.artifactShowBanner then
			self.artifactShowBanner:removeFromParent()
			self.artifactShowBanner = nil
		end
		if self.divineBeastBanner then
			self.divineBeastBanner:removeFromParent()
			self.divineBeastBanner = nil
		end
		self.tableArmySingle, _ENV = self.divineBeastBanner.removeFromParent, self.divineBeastBanner.removeFromParent
	end
	self.handlRepatriate()
end
function allianceBuildBuildingSingle:setRepatriateCallBack(handl)
	self.handlRepatriate = handl
end
return allianceBuildBuildingSingle
