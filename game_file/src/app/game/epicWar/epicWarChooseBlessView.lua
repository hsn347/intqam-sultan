local gametop = gModuleMgr.getObject("gametop")
local epicWarCtrl = gametop.playertop_:getModule("epicWarCtrl")
local epicWarltCtrl = include("epicWarltCtrl")
local epicBattleDef = include("epicBattleDef")
local epicWarChooseBlessView = class("epicWarChooseBlessView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("epicWarChooseBlessView")
	end
	return target
end)
function epicWarChooseBlessView:ctor()
	self.isCantCloseByReturn = true
	self.posArray, _ENV, self.nodeArray, _ENV, self.selectIndex = nil, nil, nil, nil, 1
	self.Center_Node = SoraDGetChildByName(self, "Center_Node")
	self.Center_Node:setVisible(false)
	self.Panel_bgTouch = SoraDGetChildByName(self, "Center_Size_Panel_bgTouch")
	self.Panel_bgTouch:setContentSize(cc.size(display.width, display.height))
	self.Button_select = SoraDGetChildByName(self, "Button_select")
	self.Button_select:setTitleText(i18n("common_text_204"))
	self.Button_select:addTouchEventListener(handler(self, self.btnSelectClick))
	self.Text_tip = SoraDGetChildByName(self, "Text_tip")
	self.Text_tip:setString(i18n("bless_drop_choice_desc"))
	for i = 1, 3 do
		self.nodeArray[i] = SoraDGetChildByName(self, "Node_" .. i)
		self.posArray[i] = cc.p(self.nodeArray[i]:getPositionX(), self.nodeArray[i]:getPositionY())
	end
	self.Node_etxz = SoraDGetChildByName(self, "Node_etxz")
	SoraDCreatAnimation("animationEpicWarXZZF"):addTo(self.Node_etxz)
	self.Node_etxz:setVisible(false)
end
function epicWarChooseBlessView:initData(pointType)
	self.pointType = pointType
	local bless = epicWarCtrl:getBossDropBless()
	self.blessList, epicWarCtrl = epicWarCtrl, epicWarCtrl
	for k, v in ipairs(bless) do
		epicWarCtrl = nil
		;(nil).index = k
		;(nil).blessId = v
		;(nil).quality = epicWarltCtrl.getBlessTacticsQuality(v)
		table.insert(self.blessList, nil)
	end
	table.sort(self.blessList, function(a, b)
		if a.quality == b.quality then
			return a.blessId > b.blessId
		else
			return a.quality > b.quality
		end
	end)
	for k, v in ipairs(self.nodeArray) do
		self:setNodeInfo(v, k, self.blessList[k])
	end
	dump(self.blessList, "self.blessList====")
	self:runEnterAction()
end
function epicWarChooseBlessView:runEnterAction()
	self.Center_Node:setVisible(true)
	_UPVALUE2_ = nil
	;(nil)[1] = cca.callFunc(function()
		for k, v in ipairs(self.nodeArray) do
			v:setScale(0.2)
			v:setPosition(0, 9)
			self = 9
			self = nil
			;(nil)[1] = cca.scaleTo(0.25, 1.1, 1.1)
			;(nil)[2] = cca.moveTo(0.25, self.posArray[k].x, self.posArray[k].y)
			;(nil)[3] = cca.moveTo(0.25, self.posArray[k].x, self.posArray[k].y)
			;(nil)[4] = cca.moveTo(0.25, self.posArray[k].x, self.posArray[k].y)
			;(nil)[5] = cca.moveTo(0.25, self.posArray[k].x, self.posArray[k].y)
			;(9)[1] = cca.spawn(nil)
			;(9)[2] = cca.scaleTo(0.1, 1.0, 1.0)
			;(9)[3] = cca.scaleTo(0.1, 1.0, 1.0)
			;(9)[4] = cca.scaleTo(0.1, 1.0, 1.0)
			;(9)[5] = cca.scaleTo(0.1, 1.0, 1.0)
			;(9)[6] = cca.scaleTo(0.1, 1.0, 1.0)
			;(9)[7] = cca.scaleTo(0.1, 1.0, 1.0)
			v:runAction(cca.seq(9))
		end
		self.Text_tip:setOpacity(0)
		self.Text_tip:runAction(cca.fadeIn(1.0))
		self.Button_select:setOpacity(0)
		self.Button_select:runAction(cca.fadeIn(1.0))
	end)
	;(nil)[2] = cca.delay(0.6)
	;(nil)[3] = cca.callFunc(function()
		SoraDCloseLoading()
		self:btnTouchClick(SoraDGetChildByName(self.nodeArray[self.selectIndex], "Button_touch"), ccui.TouchEventType.ended, true)
	end)
	;(nil)[4] = cca.callFunc(function()
		SoraDCloseLoading()
		self:btnTouchClick(SoraDGetChildByName(self.nodeArray[self.selectIndex], "Button_touch"), ccui.TouchEventType.ended, true)
	end)
	self:runAction(cca.seq(nil))
end
function epicWarChooseBlessView:setNodeInfo(target, index, bless)
	local blessId = bless.blessId
	local Text_name = SoraDGetChildByName(target, "Text_name")
	local name = epicWarltCtrl.getBlessTacticsName(blessId)
	Text_name:setString(i18n(name))
	local Text_des = SoraDGetChildByName(target, "Text_des")
	local des = epicWarltCtrl.getBlessTacticsDes(blessId)
	Text_des:setString(i18n(des))
	local Image_buff = SoraDGetChildByName(target, "Image_buff")
	local icon = epicWarltCtrl.getBlessTacticsIcon(blessId)
	Image_buff:loadTexture(icon, ccui.TextureResType.plistType)
	local Image_quality = SoraDGetChildByName(target, "Image_quality")
	local quality = epicWarltCtrl.getBlessTacticsBase(blessId)
	Image_quality:loadTexture(quality, ccui.TextureResType.plistType)
	local Button_touch = SoraDGetChildByName(target, "Button_touch")
	Button_touch:setTag(index)
	Button_touch:addTouchEventListener(handler(self, self.btnTouchClick))
	local frame_sszz = SoraDGetChildByName(target, "frame_sszz")
	local bg_line = SoraDGetChildByName(target, "bg_line")
	if quality == "base_blue.png" then
		frame_sszz:setSpriteFrame("frame_sszz_new_img_03.png")
		bg_line:setSpriteFrame("bg_sszz_line_01.png")
		Text_name:setColor(cc.c3b(97, 170, 255))
	elseif quality == "base_purple.png" then
		frame_sszz:setSpriteFrame("frame_sszz_new_img_04.png")
		bg_line:setSpriteFrame("bg_sszz_line_02.png")
		Text_name:setColor(cc.c3b(220, 120, 154))
	elseif quality == "base_orange.png" then
		frame_sszz:setSpriteFrame("frame_sszz_new_img_05.png")
		bg_line:setSpriteFrame("bg_sszz_line_03.png")
		Text_name:setColor(cc.c3b(255, 164, 84))
	end
end
function epicWarChooseBlessView:updateSelect()
	for k, v in ipairs(self.nodeArray) do
		local isSelect = self.selectIndex == k
		local Text_name = SoraDGetChildByName(v, "Text_name")
		local Text_des = SoraDGetChildByName(v, "Text_des")
		Text_des:setColor(isSelect and cc.c3b(215, 195, 155) or cc.c3b(140, 135, 118))
		v:setScale(isSelect and 1.05 or 1.0)
		print("isSelect,scale ====== ", k, isSelect, v:getScaleX())
	end
	self.index = self.blessList[self.selectIndex].index
	self.Node_etxz:setVisible(true)
	self.Node_etxz:setPositionX(self.nodeArray[self.selectIndex]:getPositionX())
end
function epicWarChooseBlessView:btnTouchClick(button, event, isTest)
	if event == ccui.TouchEventType.ended then
		if not isTest then
			SoraDPlaySound()
		end
		self.selectIndex = button:getTag()
		self:updateSelect()
	end
end
function epicWarChooseBlessView:btnSelectClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		print("index=====", self.index)
		epicWarCtrl:sendSelectBossBless(self.index)
		if self.pointType and self.pointType == epicBattleDef.gEpicWarBoardPointTypeEnum.BOSS and epicWarCtrl:isBossKilled() then
			SoraDShowMsgTip(i18n("tips_epic_war_killGuard"))
		end
		_ENV = i18n("tips_epic_war_killGuard")
		i18n("tips_epic_war_killGuard").msg = "MESSAGE_UI_EPICBATTLE_UPDATE_BOSS_ICON"
		SoraDSendMessage(i18n("tips_epic_war_killGuard"))
		self:removeFromParent()
	end
end
return epicWarChooseBlessView
