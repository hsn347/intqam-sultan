local babelTowerCtrl = SoraDGetCtrl("babelTowerCtrl")
local babelTowerRead = gModuleMgr.sharedMgr("babelTowerRead")
local babelTowerBuffChoose = class("babelTowerBuffChoose", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateTouchPanel(target)
	end
	return target or SoraDCreateTouchPanel("babelTowerBuffChoose")
end)
function babelTowerBuffChoose:ctor(properties)
	self.isAddToPopManager = true
	self.enableTouchCloseSelf = true
	self.buffNodeList, _ENV, self.isCantCloseByReturn = nil, nil, true
	self.node = SoraDGetChildByName(self, "Center_Node")
	self.nodeVisible = SoraDGetChildByName(self.node, "Node_Visible")
	self.textTitle = SoraDGetChildByName(self.node, "Text_Title")
	self.textTips = SoraDGetChildByName(self.node, "Text_Tips")
	self.textTitle:setString(i18n("Promise_Summit_text_14"))
	self.textTips:setString(i18n("Promise_Summit_text_15"))
	self.textChooseTips = SoraDGetChildByName(self.node, "Text_ChooseTips")
	self.nodeBuffSingle = SoraDGetChildByName(self, "Node_BuffSingle")
	self.nodeBuffChoose = SoraDGetChildByName(self.node, "Node_ChooseBuff")
	self.nodeEffect_2 = SoraDGetChildByName(self, "Node_Effect_ttt01_002")
	self.nodeEffect_2:setVisible(false)
	self.nodeEffect_1 = SoraDGetChildByName(self, "Node_Effect_ttt01_001")
	self.nodeEffect_1:setVisible(false)
	self.ballEffect = SoraDGetChildByName(self, "Node_BallEffect")
	self.ballEffect:setVisible(false)
	self.nodeWayEffect = SoraDGetChildByName(self, "Node_WayEffect")
	self.nodeWayEffect:setVisible(false)
	self.closeBtn = SoraDGetChildByName(self, "Button_close")
	self.closeBtn:addTouchEventListener(handler(self, self.btnClickClose))
end
function babelTowerBuffChoose:initEffect()
	local cssFileName = "babelTowerBuffChoose"
	local cssFilePath = getCCSPath(cssFileName)
	self.action = cc.CSLoader:createTimeline(cssFilePath)
	self.action:gotoFrameAndPlay(0, true)
	self:runAction(self.action)
	self.action:setFrameEventCallFunc(handler(self, self.endAction))
end
function babelTowerBuffChoose:endAction(frameEventName)
	local frameEvent = frameEventName:getEvent()
	if frameEvent and frameEvent == "ENDEVENT" then
		if self.isInPreview then
			babelTowerCtrl:reqTen(self.chooseIndex)
		else
			babelTowerCtrl = self.chooseIndex
			self.chooseIndex.floor = self.nowFloor
			self.chooseIndex.index = self.chooseIndex
			babelTowerCtrl:reqTongtianTowerBuffChoose(self.chooseIndex)
		end
		self:removeFromParent()
	end
end
function babelTowerBuffChoose:initData(floor, iconPos, isInPreview)
	self.isCantCloseByReturn = isInPreview ~= true
	self.isInPreview = isInPreview
	self.iconPos = cc.p(iconPos.x - display.cx, iconPos.y - display.cy)
	self.nodeEffect_2:setPosition(self.iconPos)
	self.nowFloor = floor
	self.buffList = babelTowerRead:getBuffList(floor)
	for i, v in ipairs(self.buffList) do
		local single = self.nodeBuffSingle:clone()
		single:addTo(self.nodeBuffChoose)
		single:setPosition(0, 0)
		self:initBuffNode(single, i, v)
		table.insert(self.buffNodeList, single)
	end
	SoraDToCenter(self.nodeBuffChoose, 320)
	self.closeBtn:setVisible(self.isInPreview or false)
	self.textChooseTips:setString(i18n(self.isInPreview and "Promise_Summit_text_52" or "Promise_Summit_text_43"))
end
function babelTowerBuffChoose:initBuffNode(parent, tag, buffData)
	local spBg = SoraDGetChildByName(parent, "Sprite_Qbg")
	local spKuang = SoraDGetChildByName(parent, "frame_ttt_buff_01_3")
	local spIcon = SoraDGetChildByName(parent, "Sprite_BuffIcon")
	local spBuffNum = SoraDGetChildByName(parent, "Sprite_BuffNum")
	local textDescribe = SoraDGetChildByName(parent, "Text_Describe")
	local btnChoose = SoraDGetChildByName(parent, "Button_Choose")
	local textTips = SoraDGetChildByName(parent, "Text_Tips")
	textTips:setVisible(false)
	btnChoose:setTag(tag)
	btnChoose:addTouchEventListener(handler(self, self.btnChooseClick))
	if next(buffData) then
		local paramNum = buffData.buffType == 1 and buffData.buffValue - 1 or buffData.buffValue + 2
		print(string.format("frame_ttt_buffnum_0%d.png", paramNum), buffData.buffValue, paramNum)
		spBuffNum:setVisible(buffData.buffType ~= 2 and buffData.buffType ~= 4)
		local buffConfig = babelTowerRead:getBuffConfig(buffData.buffType)
		spIcon:setSpriteFrame(buffConfig.imgIcon)
		spBg:setSpriteFrame(buffConfig.imgQbg)
		spBuffNum:setSpriteFrame(string.format("frame_ttt_buffnum_0%d.png", paramNum))
		_ENV = string.format("frame_ttt_buffnum_0%d.png", paramNum)
		string.format("frame_ttt_buffnum_0%d.png", paramNum).level = buffData.buffType
		string.format("frame_ttt_buffnum_0%d.png", paramNum).num = buffData.buffValue
		textDescribe:setString(i18n(buffConfig.describe, string.format("frame_ttt_buffnum_0%d.png", paramNum)))
		if self:checkBuffInvalid(buffData.buffType) then
			textTips:setVisible(true)
			textTips:setString(i18n("Promise_Summit_text_33"))
			SoraDSetNodeGray(spBg, true)
			SoraDSetNodeGray(spKuang, true)
			btnChoose:setTouchEnabled(false)
		end
	end
end
function babelTowerBuffChoose:checkBuffInvalid(buffType)
	if self.isInPreview then
		return false
	end
	local nowBlood = babelTowerCtrl:getBlood()
	local maxBlood = babelTowerCtrl:getBloodMax()
	if buffType == 2 and nowBlood >= math.ceil(maxBlood / 2) or buffType == 4 and nowBlood == maxBlood then
		return true
	else
		return false
	end
end
function babelTowerBuffChoose:btnSureClick()
	if self.chooseIndex then
		self.isInAction = true
		local nodeBuff = self.buffNodeList[self.chooseIndex]
		_UPVALUE1_ = nil
		_ENV = nil
		;(nil)[1] = cca.moveTo(0.26666666666666666, self.iconPos.x, self.iconPos.y)
		;(nil)[2] = cca.moveTo(0.26666666666666666, self.iconPos.x, self.iconPos.y)
		;(nil)[3] = cca.moveTo(0.26666666666666666, self.iconPos.x, self.iconPos.y)
		;(nil)[4] = cca.moveTo(0.26666666666666666, self.iconPos.x, self.iconPos.y)
		;(nil)[5] = cca.moveTo(0.26666666666666666, self.iconPos.x, self.iconPos.y)
		;(nil)[1] = cca.delay(0.5166666666666667)
		;(nil)[2] = cca.seq(nil)
		;(nil)[3] = cca.seq(nil)
		;(nil)[4] = cca.seq(nil)
		;(nil)[5] = cca.seq(nil)
		;(nil)[6] = cca.seq(nil)
		;(nil)[7] = cca.seq(nil)
		;(nil)[8] = cca.seq(nil)
		local action = cca.seq(nil)
		self:setBackGround(0)
		for i, v in ipairs(self.buffNodeList) do
			if i ~= self.chooseIndex then
				v:setVisible(false)
			end
		end
		self.nodeVisible:setVisible(false)
		_UPVALUE1_ = self.nodeVisible
		_UPVALUE1_ = 0.8
		;(0.8)[1] = cca.delay(0.08333333333333333)
		;(0.8)[2] = cca.fadeTo(0.08333333333333333, 0)
		;(0.8)[3] = cca.fadeTo(0.08333333333333333, 0)
		;(0.8)[4] = cca.fadeTo(0.08333333333333333, 0)
		self.nodeVisible[1] = cca.scaleTo(0.16666666666666666, 0.8)
		self.nodeVisible[2] = cca.seq(0.8)
		self.nodeVisible[3] = cca.seq(0.8)
		self.nodeVisible[4] = cca.seq(0.8)
		self.nodeVisible[5] = cca.seq(0.8)
		self.nodeVisible[6] = cca.seq(0.8)
		self.nodeVisible[7] = cca.seq(0.8)
		local noedSingleAction = cca.spawn(self.nodeVisible)
		nodeBuff:runAction(noedSingleAction)
		self.ballEffect:runAction(action)
		self.nodeEffect_2:setVisible(true)
		self.nodeEffect_1:setVisible(true)
		self.ballEffect:setVisible(true)
		self.nodeWayEffect:setVisible(true)
		self.closeBtn:setVisible(false)
		self:initEffect()
	else
		SoraDShowMsgTip(i18n("Promise_Summit_text_15"))
	end
end
function babelTowerBuffChoose:btnChooseClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tag = target:getTag()
		if tag == chooseIndex then
			return
		end
		self.chooseIndex = tag
		self:chooseBuffNode()
		self:btnSureClick()
	end
end
function babelTowerBuffChoose:chooseBuffNode()
	local nodeBuff = self.buffNodeList[self.chooseIndex]
	local posX = nodeBuff:getPositionX()
	local posY = nodeBuff:getPositionY()
	local offsetX = math.abs(self.iconPos.x - posX)
	local offsetY = math.abs(self.iconPos.y - posY)
	local angle = math.deg(math.atan(offsetY / offsetX))
	local G_dh_Tex_Way = SoraDGetChildByName(self.nodeWayEffect, "G_dh_Tex_Way")
	G_dh_Tex_Way:setScaleX((offsetX + offsetY) / 256)
	G_dh_Tex_Way:setRotation(SoraDFPosX(180 - angle, 0))
	SoraDGetChildByName(self.nodeWayEffect, "et_Par_ttt_015"):setRotation(SoraDFPosX(90 - angle, 0))
	self.nodeWayEffect:setPosition(Linear_Interpolate(self.iconPos.x, posX, 0.5), Linear_Interpolate(self.iconPos.y, posY, 0.5))
	self.nodeEffect_1:setPosition(posX, posY)
	self.ballEffect:setPosition(posX, posY)
end
function babelTowerBuffChoose:btnClickClose(button, EventType)
	if EventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:removeFromParent()
	end
end
return babelTowerBuffChoose
