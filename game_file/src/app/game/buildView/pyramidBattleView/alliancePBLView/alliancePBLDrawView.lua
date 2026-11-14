local gametop = gModuleMgr.getObject("gametop")
local pyramidWarCtrl = gametop.playertop_:getModule("pyramidWarCtrl")
local pyramidWarltCtrl = include("pyramidWarltCtrl")
local alliancePBLDrawView = class("alliancePBLDrawView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("alliancePBLDrawView")
	end
	return target
end)
function alliancePBLDrawView:ctor()
	self.tableRAnimationNode, _ENV, self.tableAnimationNode, _ENV = nil, nil, nil, nil
	self.imgBg = SoraDGetChildByName(self, "Image_bg")
	self.nodePBLIcon = SoraDGetExtendChildFromCCSByName(self, "CCS_alliancePBLBigIconNode_pbl")
	self.nodeOut = SoraDGetChildByName(self, "Node_out")
	self.nodeOut:setVisible(false)
	self.spriteNum = SoraDGetChildByName(self, "Sprite_num")
	self.labelNum = SoraDGetChildByName(self, "Text_num")
	self.btnOut = SoraDGetChildByName(self, "Button_out")
	SoraDChangeTextToHtml(self.labelNum)
	self.labelNum:setTouchEnabled(true)
	self.labelNum:addTouchEventListener(handler(self, self.btnClickText))
	self.labelOut = SoraDGetChildByName(self, "Text_out")
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_pyramid")
	_ENV = handler(self, self.btnClickText)
	handler(self, self.btnClickText).num = pyramidWarCtrl.peakSeasonNo
	self.nodeTitle:setTitle(i18n("pyramid_text_47", handler(self, self.btnClickText)))
	self.btnHelp = SoraDGetChildByName(self, "Button_help")
	BottomNodeButtons = SoraDGetChildByName(self, "Bottom_Node_buttons")
	self.spriteBottomLine = SoraDGetChildByName(self, "Sprite_bottom_line")
	self.spriteBottomLine0 = SoraDGetChildByName(self, "Sprite_bottom_line_0")
	self.spriteOwnFlag = SoraDGetChildByName(self, "Sprite_ownflag")
	self.spriteOwnFlag:setVisible(false)
	self.centerNodeBg = SoraDGetChildByName(self, "Center_bg_jztdfs_djdr_1")
	self.centerNode = SoraDGetChildByName(self, "Center_Node")
	self.nodeEye = SoraDGetChildByName(self, "Node_eye")
	self:openEye(self.nodeEye)
	self.nodeGroup = SoraDGetChildByName(self, "Node_group")
	self.tableBlock = SoraDGetChildsArrayByName(self, "Node_group__", 8, 1)
	self.spritePBL = SoraDGetChildByName(self, "Sprite_PBL")
	self.nodeSelList = SoraDGetChildByName(self, "Node_SelList")
	self.dropDownBox = SoraDGetExtendChildFromCCSByName(self, "CCS_commonDropDownBox_sel")
	self.dropDownBox:setDir(0)
	self.dropDownBox:setIsCustom(true)
	_ENV = self.dropDownBox.setIsCustom
	self.dropDownBox.setIsCustom.scrollOffsetY = -5
	_UPVALUE4_, self.dropDownBox.setIsCustom.borderOffsetY = self.dropDownBox, 30
	self.dropDownBox.setIsCustom.borderPadding, self.dropDownBox[1] = self.dropDownBox, 15
	self.dropDownBox.setIsCustom.borderPadding, self.dropDownBox[2] = self.dropDownBox, 20
	self.dropDownBox.setIsCustom.borderPadding, self.dropDownBox[3] = self.dropDownBox, 15
	self.dropDownBox.setIsCustom.borderPadding, self.dropDownBox[4] = self.dropDownBox, 5
	local customParam = self.dropDownBox.setIsCustom
	self.dropDownBox:setCustomParam(customParam)
	self.dropDownBox:setOffset(cc.p(-72, -5))
	self.dropDownBox:setSelectSingleTarget("Image_select")
	self.dropDownBox:setTouchClose()
	_ENV = "Image_select"
	;("Image_select").maxHeight = 250
	_ENV, pyramidWarCtrl, ("Image_select").childSize = 300, cc.size(300, 42), cc.size(300, 42)
	;(300).title = "test"
	;(300).tag = 1
	;("Image_select").childData, cc.size(300, 42)[1] = cc.size(300, 42), 300
	self.dropDownBox:initData("Image_select")
	self.dropDownBox:addEventListener(handler(self, self.onSelDropDownBox))
	self.labelTitle = SoraDGetChildByName(self.nodeSelList, "Text_title")
	self.labelTime = SoraDGetChildByName(self, "Text_time")
	self.btnDraw = SoraDGetChildByName(self, "Button_draw")
	self.labelDes = SoraDGetChildByName(self, "Text_des")
	self.nodeBlock = SoraDGetChildByName(self, "Node_block")
	self.labelBlock1 = SoraDGetChildByName(self, "Text_block_1")
	self.labelBlock2 = SoraDGetChildByName(self, "Text_block_2")
	self.labelBlock1:setString(i18n("pyramid_text_39"))
	_ENV = i18n("pyramid_text_39")
	i18n("pyramid_text_39").time = ""
	self.labelTitle:setString(i18n("pyramid_text_52", i18n("pyramid_text_39")))
	self.labelDes:setString(i18n("pyramid_text_54"))
	self.labelOut:setString(i18n("common_text_3333"))
	if self.btnDraw then
		self.btnHelp:addTouchEventListener(handler(self, self.btnHelpClickCallBack))
		self.btnDraw:addTouchEventListener(handler(self, self.btnClickCallBack))
		self.btnOut:addTouchEventListener(handler(self, self.btnOutClick))
	end
	self:initView()
	SoraDCreatAnimationEx(self.__cname, self, true)
	SoraDTestButton(self, function(...)
		self.nodeSelList:setVisible(true)
	end)
	for i = 1, 4 do
		local particle = SoraDGetChildByName(self, "Particle_out_" .. i)
		if particle then
			particle:setAutoCull(false)
		end
	end
	if display.height < 1145 then
		local scale = (display.height - 145) / 1000
		self.centerNode:setScale(scale)
		self.centerNode:setPositionY(scale * 460 + 25)
		self.centerNodeBg:setPositionY(self.centerNode:getPositionY() + 145 * scale)
	else
		local offsetY = 0.5 * (display.height - 1145)
		self.centerNode:setPositionY(485 + offsetY)
		self.centerNodeBg:setPositionY(self.centerNode:getPositionY() + 145)
	end
end
function alliancePBLDrawView:runDrawAction(...)
	for i = 1, 8 do
		local basenode = self.tableBlock[i]
		local node = self:getAnimationNode()
		node.light = SoraDGetChildByName(node, "Sprite_light")
		node.light:setVisible(false)
		node:setPosition(basenode:getPositionX() - 1, basenode:getPositionY() + 2)
		node:setVisible(false)
		basenode.bfl1:setVisible(true)
		basenode.bfl2:setColor(display.COLOR_WHITE)
		if basenode.btn.isOwn then
			basenode.btn:loadTextures("frame_jztdfs_sqk.png", "", "", ccui.TextureResType.plistType)
		end
	end
	self.spriteOwnFlag:setVisible(false)
	self.isRunDraw = true
	local curIndex = self.curlegion.legionIndex
	print("self.curlegion.legionIndex", self.curlegion.pinnacleArea)
	_UPVALUE23_ = print
	print[1] = cca.callFunc(function(...)
		self.tableAnimationNode[1]:setVisible(true)
	end)
	print[2] = cca.delay(0.4)
	print[3] = cca.callFunc(function(...)
		self.tableAnimationNode[3]:setVisible(true)
	end)
	print[4] = cca.delay(0.2)
	print[5] = cca.callFunc(function(...)
		self.tableAnimationNode[1]:setVisible(false)
	end)
	print[6] = cca.delay(0.2)
	print[7] = cca.callFunc(function(...)
		self.tableAnimationNode[5]:setVisible(true)
	end)
	print[8] = cca.delay(0.2)
	print[9] = cca.callFunc(function(...)
		self.tableAnimationNode[3]:setVisible(false)
	end)
	print[10] = cca.delay(0.2)
	print[11] = cca.callFunc(function(...)
		self.tableAnimationNode[7]:setVisible(true)
	end)
	print[12] = cca.delay(0.2)
	print[13] = cca.callFunc(function(...)
		self.tableAnimationNode[5]:setVisible(false)
		self.tableAnimationNode[8]:setVisible(true)
	end)
	print[14] = cca.delay(0.2)
	print[15] = cca.callFunc(function(...)
		self.tableAnimationNode[7]:setVisible(false)
	end)
	print[16] = cca.delay(0.2)
	print[17] = cca.callFunc(function(...)
		self.tableAnimationNode[2]:setVisible(true)
	end)
	print[18] = cca.delay(0.2)
	print[19] = cca.callFunc(function(...)
		self.tableAnimationNode[8]:setVisible(false)
	end)
	print[20] = cca.delay(0.2)
	print[21] = cca.callFunc(function(...)
		self.tableAnimationNode[4]:setVisible(true)
	end)
	print[22] = cca.delay(0.2)
	print[23] = cca.callFunc(function(...)
		self.tableAnimationNode[2]:setVisible(false)
	end)
	print[24] = cca.delay(0.2)
	print[25] = cca.callFunc(function(...)
		self.tableAnimationNode[6]:setVisible(true)
	end)
	print[26] = cca.delay(0.2)
	print[27] = cca.callFunc(function(...)
		self.tableAnimationNode[4]:setVisible(false)
	end)
	print[28] = cca.delay(0.4)
	print[29] = cca.callFunc(function(...)
		self.tableAnimationNode[6]:setVisible(false)
		local legion = self.legionList[curIndex]
		if self.tableAnimationNode[legion.pinnacleArea] then
			self.tableAnimationNode[legion.pinnacleArea]:setVisible(true)
			self.tableAnimationNode[legion.pinnacleArea].light:setVisible(true)
		end
	end)
	print[30] = cca.delay(1.5)
	print[31] = cca.callFunc(function(...)
		self.isRunDraw = false
		self:publicView()
	end)
	local print[32], actionArray = cca.callFunc(function(...)
		self.isRunDraw = false
		self:publicView()
	end)
	self.nodeGroup:runAction(cca.seq(actionArray))
end
function alliancePBLDrawView:runStandbyAction(index)
	local basenode = self.tableBlock[index]
	local node = self:getAnimationNode()
	node.light = SoraDGetChildByName(node, "Sprite_light")
	node.light:setVisible(false)
	node:setPosition(basenode:getPositionX() - 1, basenode:getPositionY() + 2)
	node:setVisible(true)
end
function alliancePBLDrawView:cleanAllAnimationNode()
	for i, v in ipairs(self.tableAnimationNode) do
		v:setVisible(false)
		table.insert(self.tableRAnimationNode, v)
	end
	self.tableAnimationNode, _ENV = ipairs(self.tableAnimationNode)
end
function alliancePBLDrawView:getAnimationNode()
	local node
	if next(self.tableRAnimationNode) then
		node = table.remove(self.tableRAnimationNode)
	else
		node = SoraDCreatAnimationEx("animationPBLDrawNode", nil, true)
		node:addTo(self.nodeGroup, 1)
	end
	table.insert(self.tableAnimationNode, node)
	return node
end
function alliancePBLDrawView:updatePBLMark()
	self.nodeOut:setVisible(pyramidWarCtrl:getOwnPBLLegion() ~= nil)
end
function alliancePBLDrawView:onMessageListener(...)
	SoraDAddMessage(self, "MESSAGE_SERVER_PYRAMIDBATTLE_GROUP_UPDATE", handler(self, self.initView))
end
function alliancePBLDrawView:onSelDropDownBox(tag)
	print("选择了---------", tag)
	self.curlegion = self.legionList[tag]
	self:updateView()
end
function alliancePBLDrawView:initView()
	self.groupType = gPinnacleSeasonAllianceState.NOT_APPLY
	self.seasonState = pyramidWarCtrl.pinnacleSeasonState
	self.legionList = pyramidWarCtrl:getLegionInfoList()
	self.ownlegion = pyramidWarCtrl:getOwnPBLLegion()
	self.curlegion = self.ownlegion
	self.curMatchType = pyramidWarCtrl.curMatchType
	self:publicView(true)
	if self.timer == nil then
		self.timer = SoradCreateTimer(self, handler(self, self.openTimeUp))
	end
	self:openTimeUp()
	SoraDCloseLoading(self)
	if self.curMatchType == gPinnacleMatchType.GROUP_MATCH then
		print("分组赛")
		self:initGroup()
	else
		print("突围赛")
		self:initBreakout()
	end
end
function alliancePBLDrawView:initGroup(...)
	_ENV, _ENV, _ENV = nil, nil, nil
	;(nil).__default, (nil).u = nil, "true"
	self.labelNum:setString(i18n_html("pyramid_text_56", nil, nil))
	SoraDGetAutoHeightLabelNew(self.labelNum, 86, true)
	self:updateView()
end
function alliancePBLDrawView:initBreakout(...)
	_ENV, _ENV, _ENV = nil, nil, nil
	;(nil).__default, (nil).u = nil, "true"
	self.labelNum:setString(i18n_html("pyramid_btn_27", nil, nil))
	SoraDGetAutoHeightLabelNew(self.labelNum, 86, true)
	self:updateView()
end
function alliancePBLDrawView:openTimeUp()
	local nowTimeLeft = pyramidWarCtrl:getLeftTime(pyramidWarCtrl.pinnacleSeasonState)
	if nowTimeLeft and 0 <= nowTimeLeft then
		self.labelTime:setString(SoraDConvertSecondToString(nowTimeLeft))
	else
	end
end
function alliancePBLDrawView:updateView()
	if self.curlegion then
		self.groupType = self.curlegion.pinnacleSeasonAllianceState
		print("have curlegion", self.groupType)
	else
		print("empty curlegion")
		self.nodeSelList:setVisible(false)
		self.nodeBlock:setVisible(false)
		return
	end
	if self.groupType == gPinnacleSeasonAllianceState.PINNACLE_WAIT_GROUP_AREA then
		self.nodeSelList:setVisible(true)
		self.nodeBlock:setVisible(false)
		print("未抽签")
		self.btnDraw:setTouchEnabled(true)
		self.btnDraw:setTitleText(i18n("pyramid_btn_31"))
	elseif self.groupType == gPinnacleSeasonAllianceState.PINNACLE_GROUP_AREA_OK and self.seasonState ~= gPinnacleSeasonState.WAIT_APPLY_NEXT then
		self.nodeSelList:setVisible(true)
		self.nodeBlock:setVisible(false)
		print("已经抽签")
		self.btnDraw:setTouchEnabled(false)
		self.btnDraw:setTitleText(i18n("pyramid_text_53"))
	elseif self.groupType == gPinnacleSeasonAllianceState.PREPARE or self.groupType == gPinnacleSeasonAllianceState.NOT_MATCH or self.groupType == gPinnacleSeasonAllianceState.RUNNING or self.groupType == gPinnacleSeasonAllianceState.FINISH or self.groupType == gPinnacleSeasonAllianceState.NOT_APPLY or self.groupType == gPinnacleSeasonAllianceState.APPLY_ED or self.groupType == gPinnacleSeasonAllianceState.PINNACLE_GROUP_AREA_OK then
		print("等待结果")
		self.nodeSelList:setVisible(false)
		if self.ownlegion and self.ownlegion.pinnacleArea > 0 then
			self.nodeBlock:setVisible(true)
			self.labelBlock2:setString(self.ownlegion.pinnacleArea .. "--" .. pyramidWarltCtrl.getGroupName(self.ownlegion.pinnacleBreakoutGroup))
		else
			self.nodeBlock:setVisible(false)
		end
		if self.seasonState == gPinnacleSeasonState.WAIT_LOT and self.groupType == gPinnacleSeasonAllianceState.FINISH then
			include("pyramidClientModule").popPBLView()
			self:removeFromParent()
		end
	else
		print("没有对应的状态")
		self.nodeSelList:setVisible(false)
		self.nodeBlock:setVisible(false)
	end
end
function alliancePBLDrawView:publicView(skipUpdateView)
	if self.isRunDraw then
		return
	end
	self:cleanAllAnimationNode()
	local pyramidWarCtrl, dropData = self.cleanAllAnimationNode, self.cleanAllAnimationNode
	local pyramidWarCtrl, already = self, self
	local ownArea
	local ownlegion = pyramidWarCtrl:getOwnLegion()
	local index
	local ownRank = pyramidWarCtrl:getGroupManagerRank()
	if ownlegion and ownlegion.pinnacleArea > 0 then
		ownArea = ownlegion.pinnacleArea
	end
	for i, v in ipairs(self.legionList) do
		if v.battleSeasonType == gSeasonType.PINNACLE_SEASON then
			if 1 < ownRank then
				pyramidWarCtrl = nil
				;(nil).title = v.legionName
				;(nil).tag = i
				table.insert(dropData, nil)
				if v.pinnacleArea == 0 and index == nil then
					index = i
				end
			elseif ownlegion and ownlegion.legionIndex == v.legionIndex then
				pyramidWarCtrl = nil
				;(nil).title = v.legionName
				;(nil).tag = i
				table.insert(dropData, nil)
				index = i
			end
			if v.pinnacleArea > 0 then
				already[v.pinnacleArea] = true
			end
		end
	end
	if index == nil then
		index = 1
	end
	if 0 < #dropData then
		self.dropDownBox:setChooseTag(index)
		self.dropDownBox:refreshData(dropData)
		self.curlegion = self.legionList[index]
		if not skipUpdateView then
			self:updateView()
		end
	else
		self.dropDownBox:setVisible(false)
		self.btnDraw:setVisible(false)
	end
	for i, v in ipairs(self.tableBlock) do
		v.bfl1 = SoraDGetChildByName(v, "bfl_1")
		v.bfl2 = SoraDGetChildByName(v, "bfl_2")
		v.btn = SoraDGetChildByName(v, "Button_group")
		v.btn:setTag(i)
		v.btn:addTouchEventListener(handler(self, self.btnGroupClick))
		if already[i] then
			self:runStandbyAction(i)
		else
		end
		if ownArea and ownArea == i then
			self.spriteOwnFlag:setVisible(true)
			self.spriteOwnFlag:setPosition(v:getPositionX() + 30, v:getPositionY() + 30)
			v.btn:loadTextures("frame_jztdfs_sqk2.png", "", "", ccui.TextureResType.plistType)
			v.btn.isOwn = true
		end
	end
	self:updatePBLMark()
end
function alliancePBLDrawView:btnHelpClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		userSDKManager.showFAQSection(gSDKDef.FAQSectionType.PYRAMID_BATTLE)
	end
end
function alliancePBLDrawView:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.isRunDraw then
			return
		end
		if pyramidWarCtrl:getGroupManagerRank(self.curlegion.legionIndex) >= 1 then
			pyramidWarCtrl:newDrawGroupPinnacleReq(self.curlegion.legionId)
			SoraDShowLoading(self)
			self:runDrawAction()
		else
			SoraDShowMsgTip(i18n("pyramid_tips_11"))
		end
	end
end
function alliancePBLDrawView:btnOutClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("alliancePBLMarkView"):show()
	end
end
function alliancePBLDrawView:btnClickText(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("alliancePBLScheduleView")
		panel:show()
	end
end
function alliancePBLDrawView:btnGroupClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("alliancePBLDrawListView")
		panel:initData(button:getTag())
		panel:show()
	end
end
function alliancePBLDrawView:openEye(fNode)
	local nodeEyes = SoraDGetChildByName(fNode, "Node_eyes")
	local spEye = SoraDGetChildByName(fNode, "Sprite_eye")
	local spEyeUp, spEyeDown
	if not nodeEyes:getChildByName("eye_cliperNode") then
		local shapNode = display.newCircle(25)
		local cliperNode = cc.ClippingNode:create()
		cliperNode:setName("eye_cliperNode")
		cliperNode:setStencil(shapNode)
		cliperNode:setInverted(false)
		cliperNode:addTo(nodeEyes)
		spEyeUp = nodeEyes:getChildByName("Sprite_eye_up")
		spEyeDown = nodeEyes:getChildByName("Sprite_eye_down")
		spEyeUp:retain()
		spEyeDown:retain()
		spEyeUp:removeFromParent()
		spEyeDown:removeFromParent()
		spEyeUp:addTo(cliperNode)
		spEyeDown:addTo(cliperNode)
		spEyeUp:release()
		spEyeDown:release()
	else
		spEyeUp = nodeEyes:getChildByName("eye_cliperNode"):getChildByName("Sprite_eye_up")
		spEyeDown = nodeEyes:getChildByName("eye_cliperNode"):getChildByName("Sprite_eye_down")
	end
	spEyeUp:stopAllActions()
	spEyeDown:stopAllActions()
	local blinkEyes = function(sY, eY)
		_UPVALUE5_ = nil
		;(nil)[1] = cca.moveTo(0.05, 0, sY)
		;(nil)[2] = cca.moveTo(0.05, 0, eY)
		;(nil)[3] = cca.delay(0.4)
		;(nil)[4] = cca.moveTo(0.1, 0, sY)
		;(nil)[5] = cca.moveTo(0.1, 0, eY)
		;(nil)[6] = cca.delay(4)
		;(nil)[7] = cca.delay(4)
		;(nil)[8] = cca.delay(4)
		return cc.RepeatForever:create(cca.seq(nil))
	end
	spEyeUp:runAction(blinkEyes(0, 27))
	spEyeDown:runAction(blinkEyes(0, -27))
	_UPVALUE5_ = blinkEyes(0, -27)
	blinkEyes(0, -27)[1] = cca.moveTo(0.1, -4, 2)
	blinkEyes(0, -27)[2] = cca.delay(0.5)
	blinkEyes(0, -27)[3] = cca.moveTo(0.1, 0, -4)
	blinkEyes(0, -27)[4] = cca.delay(0.5)
	blinkEyes(0, -27)[5] = cca.moveTo(0.1, 2, 2)
	blinkEyes(0, -27)[6] = cca.delay(4)
	blinkEyes(0, -27)[7] = cca.delay(4)
	blinkEyes(0, -27)[8] = cca.delay(4)
	spEye:runAction(cc.RepeatForever:create(cca.seq(blinkEyes(0, -27))))
end
return alliancePBLDrawView
