local gametop = gModuleMgr.getObject("gametop")
local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
local ancientTreasureCtrl = gametop.playertop_:getModule("ancientTreasureCtrl")
local ancientTreasureRead = include("ancientTreasureRead")
local publicRead = include("publicRead")
local eventAncientSecretExploreView = class("eventAncientSecretExploreView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("eventAncientSecretExploreView")
	end
	return target
end)
local huobaID = 821701
local chanzID = 821801
local PLAYER_MAX = 10
function eventAncientSecretExploreView:ctor()
	SoraDGetAllChildFromWidget(self, self)
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.Text_status:setString(i18n("AncienTreasure_text_29"))
	self.Text_award:setString(i18n("common_text_2078"))
	self.BtnHB = SoraDGetExtendChildFromCCSByName(self, "CCS_commonGoldNormalBtn_hb")
	self.BtnHB:addTouchEventListener(handler(self, self.onUseHBClick))
	self.BtnCZ = SoraDGetExtendChildFromCCSByName(self, "CCS_commonGoldNormalBtn_cz")
	self.BtnCZ:addTouchEventListener(handler(self, self.onUseCZClick))
	self.torchTextNum = SoraDChangeTextToHtml(SoraDGetChildByName(self.Node_exploreType, "Text_num"))
	self.spadeTextNum = SoraDChangeTextToHtml(SoraDGetChildByName(self.Node_exploreCount, "Text_num"))
	local own = SoraDGetChildByName(self.BtnHB, "Text_own")
	own:setColor(cc.c3b(255, 255, 255))
	self.textOwnTorch = SoraDChangeTextToHtml(own)
	own = SoraDGetChildByName(self.BtnCZ, "Text_own")
	own:setColor(cc.c3b(255, 255, 255))
	self.textOwnSpade = SoraDChangeTextToHtml(own)
	self:setBoxInfo()
	self:setBtnInfo()
end
function eventAncientSecretExploreView:setBtnInfo()
	local num = backpackCtrl:getItemCount(huobaID)
	if num == 0 then
		backpackCtrl = num
		num.color = "#FF0000"
		local tCount = SoraDWrapHtmlTagByStyle(tostring(num), num)
		backpackCtrl = "common_text_3893"
		;("common_text_3893").color = "#786955"
		local pre = SoraDWrapHtmlTagByStyle(i18n("common_text_3893"), "common_text_3893")
		self.textOwnTorch:setString(pre .. tCount)
		self.BtnHB:setTextGoldColor(COLOR3.RED)
	else
		backpackCtrl = tostring(num)
		tostring(num).color = "#786955"
		local pre = SoraDWrapHtmlTagByStyle(i18n("common_text_3893") .. tostring(num), (tostring(num)))
		self.textOwnTorch:setString(pre)
		self.BtnHB:setTextGoldColor(COLOR3.YELLOW)
	end
	backpackCtrl = self.BtnHB
	self.BtnHB.title = i18n("AncienTreasure_btn_06")
	self.BtnHB.icon = publicRead.getIcon(huobaID)
	self.BtnHB.gold = 1
	self.BtnHB:initData(self.BtnHB, 1)
	num = backpackCtrl:getItemCount(chanzID)
	if num == 0 then
		backpackCtrl = num
		num.color = "#FF0000"
		local tCount = SoraDWrapHtmlTagByStyle(tostring(num), num)
		backpackCtrl = "common_text_3893"
		;("common_text_3893").color = "#786955"
		local pre = SoraDWrapHtmlTagByStyle(i18n("common_text_3893"), "common_text_3893")
		self.textOwnSpade:setString(pre .. tCount)
		self.BtnCZ:setTextGoldColor(COLOR3.RED)
	else
		backpackCtrl = tostring(num)
		tostring(num).color = "#786955"
		local pre = SoraDWrapHtmlTagByStyle(i18n("common_text_3893") .. tostring(num), (tostring(num)))
		self.textOwnSpade:setString(pre)
		self.BtnCZ:setTextGoldColor(COLOR3.YELLOW)
	end
	backpackCtrl = self.BtnCZ
	self.BtnCZ.title = i18n("AncienTreasure_btn_07")
	self.BtnCZ.icon = publicRead.getIcon(chanzID)
	self.BtnCZ.gold = 1
	self.BtnCZ:initData(self.BtnCZ, 1)
end
function eventAncientSecretExploreView:setBoxInfo()
	for i = 1, 3 do
		local nodeBox = SoraDGetChildByName(self, "Node_box_" .. i)
		local Button_box = SoraDGetChildByName(nodeBox, "Button_box")
		Button_box:setTag(i)
		Button_box:addTouchEventListener(handler(self, self.onBoxClick))
		local Sprite_box = SoraDGetChildByName(Button_box, "Sprite_box")
		local boxInfo = ancientTreasureRead.getBoxInfoByIndex(i)
		Sprite_box:setSpriteFrame(boxInfo.box)
		if i == 2 then
			self:setBoxEffect(nodeBox)
		end
	end
end
function eventAncientSecretExploreView:setBoxEffect(target)
	local eNode = self:getChildByName("effect_node")
	if not eNode then
		_ENV, _ENV = "effect_node", self
		;("effect_node").png = "dh_xsyd_01.png"
		;("effect_node").scale = 2.75
		;("effect_node").opacity = 178.5
		_UPVALUE1_ = nil
		;(nil)[1] = cca.fadeTo(0.55, 0.2)
		;(nil)[2] = cca.fadeTo(0.5333333333333333, 0.7)
		;(nil)[3] = cca.fadeTo(0.5333333333333333, 0.7)
		;(nil)[4] = cca.fadeTo(0.5333333333333333, 0.7)
		;(nil)[5] = cca.fadeTo(0.5333333333333333, 0.7)
		;(nil)[6] = cca.fadeTo(0.5333333333333333, 0.7)
		;(nil)[7] = cca.fadeTo(0.5333333333333333, 0.7)
		;(nil)[8] = cca.fadeTo(0.5333333333333333, 0.7)
		;(nil)[9] = cca.fadeTo(0.5333333333333333, 0.7)
		_ENV, self[1], ("effect_node").seq = "effect_node", "effect_node", cca.seq(nil)
		;("effect_node").png = "dh_xsyd_07.png"
		_ENV, self[2], ("effect_node").scale = "effect_node", "effect_node", 2
		;("effect_node").png = "dh_xsyd_02.png"
		;("effect_node").scale = 2.4
		_ENV = nil
		;(nil)[1] = cca.rotateBy(1.0833333333333333, 540)
		;(nil)[2] = cca.rotateBy(1.0833333333333333, 540)
		;(nil)[3] = cca.rotateBy(1.0833333333333333, 540)
		;(nil)[4] = cca.rotateBy(1.0833333333333333, 540)
		;(nil)[5] = cca.rotateBy(1.0833333333333333, 540)
		;(nil)[6] = cca.rotateBy(1.0833333333333333, 540)
		;(nil)[7] = cca.rotateBy(1.0833333333333333, 540)
		;(nil)[8] = cca.rotateBy(1.0833333333333333, 540)
		;(nil)[9] = cca.rotateBy(1.0833333333333333, 540)
		self[3], ("effect_node").seq = "effect_node", cca.seq(nil)
		local actionConfig = self
		local roundNode = display.newNode()
		roundNode:setScale(0.3)
		roundNode:setName("effect_node")
		roundNode:addTo(target, 9)
		for k, v in ipairs(actionConfig) do
			if v.png then
				local sprite = display.newSprite("#" .. v.png)
				if v.scale then
					sprite:setScale(v.scale)
				end
				if v.opacity then
					sprite:setOpacity(v.opacity)
				end
				if v.rotation then
					sprite:setRotation(v.rotation)
				end
				if v.seq then
					sprite:runAction(cc.RepeatForever:create(v.seq))
				end
				sprite:addTo(roundNode, k)
			end
		end
	else
		eNode:setVisible(true)
	end
end
function eventAncientSecretExploreView:initData(instance)
	self.instance = instance
	self.pos = instance:getTilePoint()
	self.buildID = instance.buildID
	self.buildType = instance.buildType
	local svrBuildInfo = ancientTreasureRead.getSvrBuildInfo(self.buildType)
	self.maxLimitTorch = svrBuildInfo.torch
	self.maxLimitSpade = svrBuildInfo.spade
	if userSDKManager.isBeta() or device.platform == "mac" then
		self.maxLimitTorch = 2
		self.maxLimitSpade = 2
	end
	if not ancientTreasureCtrl:getBuildInfoInAlliance(self.buildID) then
		local ancientTreasureRead, buildInfo = ancientTreasureCtrl:getBuildInfoInAlliance(self.buildID), ancientTreasureCtrl:getBuildInfoInAlliance(self.buildID)
	end
	ancientTreasureRead = nil
	;(nil).name = buildInfo.nickName or ""
	self.ccs_bg:setTitleName(i18n("AncienTreasure_text_28", nil))
	self.Text_pos:setString(self.pos.x .. "," .. self.pos.y)
	self.Text_pos:setTouchEnabled(true)
	self.Text_pos:addTouchEventListener(handler(self, self.onGoClick))
	SoraDDrawTextUnderLine(self.Text_pos, cc.c4b(105, 180, 230, 255))
	self:updateData()
end
function eventAncientSecretExploreView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_ANCIENT_TREASURE_UPDATE", handler(self, self.updateData))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function eventAncientSecretExploreView:judgeClose()
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.ANCIENT_TREASURE_ACTIVITY) then
		self:removeFromParent()
	end
end
function eventAncientSecretExploreView:updateData(target, data)
	SoraDCloseLoading(self)
	if data and data.instance and (tolua.isnull(self.instance) or self.instance == data.instance) then
		self.instance = data.instance
	end
	if self.instance.treasureState == gATBuildingStatus.AT_MINNING then
		local panel = SoraDCreatePanel("eventAncientSecretDigView")
		panel:initData(self.instance)
		panel:show()
		self:removeFromParent()
		return
	end
	self:setHuobaInfo()
	self:setChanzInfo()
	self:setBtnInfo()
	local alliSpadeCount = ancientTreasureCtrl:getAllianceSpadeCount(self.buildID)
	local alliTorchCount = ancientTreasureCtrl:getAllianceTorchCount(self.buildID)
	local svrBuildInfo = ancientTreasureRead.getSvrBuildInfo(self.buildType)
	local buildInfo = ancientTreasureRead.getBuildInfo(self.instance.buildType)
	if alliTorchCount >= svrBuildInfo.torch then
		_ENV = nil
		;(nil).type = i18n(buildInfo.name)
		self.Text_type:setString(i18n("common_text_3516", nil))
	else
		_ENV = i18n("common_text_3516", nil)
		i18n("common_text_3516", nil).type = i18n("AncienTreasure_text_60")
		self.Text_type:setString(i18n("common_text_3516", i18n("common_text_3516", nil)))
	end
	if alliSpadeCount >= self.maxLimitSpade then
		_ENV = i18n("common_text_3516", i18n("common_text_3516", nil))
		i18n("common_text_3516", i18n("common_text_3516", nil)).num = string.formatnumberthousands(buildInfo.num)
		self.Text_count:setString(i18n("AncienTreasure_text_31", i18n("common_text_3516", i18n("common_text_3516", nil))))
	else
		_ENV = i18n("AncienTreasure_text_31", i18n("common_text_3516", i18n("common_text_3516", nil)))
		i18n("AncienTreasure_text_31", i18n("common_text_3516", i18n("common_text_3516", nil))).num = i18n("AncienTreasure_text_60")
		self.Text_count:setString(i18n("AncienTreasure_text_31", i18n("AncienTreasure_text_31", i18n("common_text_3516", i18n("common_text_3516", nil)))))
	end
	local torchCount = ancientTreasureCtrl:getTorchCount(self.buildID)
	local spadeCount = ancientTreasureCtrl:getSpadeCount(self.buildID)
	local totalCount = torchCount + spadeCount
	self.Text_usedTool:setString(i18n("AncienTreasure_text_36") .. totalCount .. "/" .. PLAYER_MAX)
	self.Text_usedTool:setColor(totalCount < PLAYER_MAX and cc.c3b(215, 195, 155) or cc.c3b(190, 40, 40))
	local canTorch = alliTorchCount < self.maxLimitTorch and totalCount < PLAYER_MAX
	SoraDSetGray(self.BtnHB, not canTorch, true)
	self.BtnHB:setTouchEnabled(canTorch)
	local canSpade = alliSpadeCount < self.maxLimitSpade and totalCount < PLAYER_MAX
	SoraDSetGray(self.BtnCZ, not canSpade, true)
	self.BtnCZ:setTouchEnabled(canSpade)
	local percent = math.floor((torchCount + spadeCount) * 100 / (self.maxLimitTorch + self.maxLimitSpade))
	_ENV = i18n("AncienTreasure_text_31", i18n("AncienTreasure_text_31", i18n("common_text_3516", i18n("common_text_3516", nil))))
	i18n("AncienTreasure_text_31", i18n("AncienTreasure_text_31", i18n("common_text_3516", i18n("common_text_3516", nil)))).num = percent
	self.Text_des:setString(i18n("AncienTreasure_text_30", i18n("AncienTreasure_text_31", i18n("AncienTreasure_text_31", i18n("common_text_3516", i18n("common_text_3516", nil))))))
end
function eventAncientSecretExploreView:setHuobaInfo()
	local alliTorchCount = ancientTreasureCtrl:getAllianceTorchCount(self.buildID)
	local svrBuildInfo = ancientTreasureRead.getSvrBuildInfo(self.buildType)
	if alliTorchCount >= svrBuildInfo.torch then
		self.Text_exploreType:setString(i18n("AncienTreasure_text_33"))
	else
		self.Text_exploreType:setString(i18n("AncienTreasure_text_32"))
	end
	local Text_name = SoraDGetChildByName(self.Node_exploreType, "Text_name")
	local icon_tool = SoraDGetChildByName(self.Node_exploreType, "icon_tool")
	if alliTorchCount < self.maxLimitTorch then
		ancientTreasureCtrl = alliTorchCount
		alliTorchCount.color = "#FF0000"
		local tCount = SoraDWrapHtmlTagByStyle(tostring(alliTorchCount), alliTorchCount)
		self.torchTextNum:setString(tCount .. "/" .. self.maxLimitTorch)
	else
		self.torchTextNum:setString(alliTorchCount .. "/" .. self.maxLimitTorch)
	end
	self.BtnHB:setBright(alliTorchCount < self.maxLimitTorch)
	self.BtnHB:setTouchEnabled(alliTorchCount < self.maxLimitTorch)
	icon_tool:setSpriteFrame(publicRead.getIcon(huobaID))
	Text_name:setString(publicRead.getName(huobaID))
	SoraDToCenter(self.Node_exploreType)
end
function eventAncientSecretExploreView:setChanzInfo()
	local alliSpadeCount = ancientTreasureCtrl:getAllianceSpadeCount(self.buildID)
	local svrBuildInfo = ancientTreasureRead.getSvrBuildInfo(self.buildType)
	if alliSpadeCount > svrBuildInfo.spade then
		self.Text_exploreCount:setString(i18n("AncienTreasure_text_35"))
	else
		self.Text_exploreCount:setString(i18n("AncienTreasure_text_34"))
	end
	local Text_name = SoraDGetChildByName(self.Node_exploreCount, "Text_name")
	local icon_tool = SoraDGetChildByName(self.Node_exploreCount, "icon_tool")
	if alliSpadeCount < self.maxLimitSpade then
		ancientTreasureCtrl = alliSpadeCount
		alliSpadeCount.color = "#FF0000"
		local tCount = SoraDWrapHtmlTagByStyle(tostring(alliSpadeCount), alliSpadeCount)
		self.spadeTextNum:setString(tCount .. "/" .. self.maxLimitSpade)
	else
		self.spadeTextNum:setString(alliSpadeCount .. "/" .. self.maxLimitSpade)
	end
	self.BtnCZ:setBright(alliSpadeCount < self.maxLimitSpade)
	self.BtnCZ:setTouchEnabled(alliSpadeCount < self.maxLimitSpade)
	icon_tool:setSpriteFrame(publicRead.getIcon(chanzID))
	Text_name:setString(publicRead.getName(chanzID))
	SoraDToCenter(self.Node_exploreCount)
end
function eventAncientSecretExploreView:onGoClick(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		print("跳转到世界坐标======")
		_ENV = "跳转到世界坐标======"
		;("跳转到世界坐标======").x = self.pos.x
		;("跳转到世界坐标======").y = self.pos.y
		SoraDGotoWorldMapPoint("跳转到世界坐标======", true)
		SoraDRemoveAllPanelFromManager()
	end
end
function eventAncientSecretExploreView:onBoxClick(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("eventAncientSecretAwardView")
		panel:initData(target:getTag())
		panel:show()
	end
end
function eventAncientSecretExploreView:onUseHBClick(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if backpackCtrl:getItemCount(huobaID) > 0 then
			SoraDShowLoading(self)
			_ENV = nil
			;(nil).buildID = self.buildID
			backpackCtrl:reqUseItem(huobaID, 1, nil)
		else
			_ENV = 1
			;(1).name = publicRead.getName(huobaID)
			SoraDShowMsgTip(i18n("commom_text_4302", 1))
		end
	end
end
function eventAncientSecretExploreView:onUseCZClick(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if backpackCtrl:getItemCount(chanzID) > 0 then
			SoraDShowLoading(self)
			_ENV = nil
			;(nil).buildID = self.buildID
			backpackCtrl:reqUseItem(chanzID, 1, nil)
		else
			_ENV = 1
			;(1).name = publicRead.getName(chanzID)
			SoraDShowMsgTip(i18n("commom_text_4302", 1))
		end
	end
end
return eventAncientSecretExploreView
