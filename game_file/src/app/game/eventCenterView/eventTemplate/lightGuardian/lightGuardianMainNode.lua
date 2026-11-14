local lightGuardianCtrl = SoraDGetCtrl("lightGuardianCtrl")
local lightGuardianRead = include("lightGuardianRead")
local lightGuardianMainNode = class("lightGuardianMainNode", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	SoraDDeviceFitOffset(target)
	return target
end)
function lightGuardianMainNode:ctor(properties)
	_UPVALUE4_ = nil
	self.boxImgs, (nil)[1] = nil, "icon_KingGroupbuy_lv1_small.png"
	self.boxImgs, (nil)[2] = nil, "icon_KingGroupbuy_lv2_small.png"
	self.boxImgs, (nil)[3] = nil, "icon_KingGroupbuy_lv3_small.png"
	self.boxImgs, (nil)[4] = nil, "icon_KingGroupbuy_lv4_small.png"
	self.activityID = gActivityTimeActivityID.RADIANCE_GUARDIAN_ACTIVITY
	SoraDGetChildByName(self, "Image_Bg_Down_Size"):setFillType(1)
	self.textPointTitle = SoraDGetChildByName(self, "Text_PointTitle")
	self.textPointTitle:setString(i18n("guardLight_text_01"))
	self.textPoint = SoraDGetChildByName(self, "Text_Point")
	self.textPoint = SoraDChangeTextToHtml(self.textPoint)
	self.btnInfo = SoraDGetChildByName(self, "Button_info")
	self.btnInfo:addTouchEventListener(handler(self, self.btnInfoClick))
	self.nodeProgress = SoraDGetChildByName(self, "Node_progress")
	self.lBarProgress = SoraDGetChildByName(self.nodeProgress, "LoadingBar_progress")
	self.btnBox = SoraDGetChildByName(self.nodeProgress, "Button_box")
	self.btnBox:addTouchEventListener(handler(self, self.btnBoxClick))
	self.textTitleGetway = SoraDGetChildByName(self, "Text_TitleGetway")
	self.textTitleGetway:setString(i18n("remains_title_04"))
	self.btnGetPoints = SoraDGetChildByName(self, "Button_GetPoints")
	self.btnGetPoints:addTouchEventListener(handler(self, self.btnGetPointsClick))
	self.nodeGetWay = SoraDGetChildByName(self, "Node_Getway")
	self.scroll = SoraDGetChildByName(self, "ScrollView_Size")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setChildOffset(cc.p(0, -60))
	self.scroll:setSingleCCS("lightGuardianSingle")
	self.scroll:setEnabledFollowHeight()
	_UPVALUE3_ = 640
	;(640)[1] = 1
	;(640)[2] = 2
	;(640)[3] = 3
	_ENV = 2
	;(2).scroll = self.scroll
	;(2).view = self
	;(2).customHeight = 660
	self.scroll:updateScrollView(cc.size(640, 200), 640, 1, 2)
	self.scroll:setSwallowTouches(false)
	self.nodeGetWay:setPositionY(self.scroll:getInnerContainerSize().height)
	self:initData()
end
function lightGuardianMainNode:onEnterOther()
	lightGuardianCtrl:reqRadianceGuardianInitData()
end
function lightGuardianMainNode:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_RADIANCE_GUARDIAN_REFRESH", handler(self, self.msgCallBack))
end
function lightGuardianMainNode:initData(target, data)
	self:initProgressBar()
end
function lightGuardianMainNode:initProgressBar(...)
	local cur = math.floor(lightGuardianCtrl:getProperties("progress") or 0)
	if not lightGuardianCtrl:getProperties("reward") then
		_ENV = lightGuardianCtrl:getProperties("reward")
	end
	self.receivedReward = lightGuardianCtrl:getProperties("reward")
	_ENV = nil
	_ENV, _ENV, (nil).num = cur, string.formatnumberthousands(cur), string.formatnumberthousands(cur)
	_ENV, string.formatnumberthousands(cur).num, cur.color = cur, cur, "#FFD928"
	string.formatnumberthousands(cur).__default, cur.color = cur, "#E5CD87"
	self.textPoint:setString(i18n_html("guardLight_text_02", nil, (string.formatnumberthousands(cur))))
	self.btnInfo:setPositionX(SoraDFPosX(self.textPoint:getContentSize().width / 2 + 30, 0))
	self.boxData = lightGuardianRead.getStageReward()
	local belongNum = 0
	for i, v in ipairs(self.boxData) do
		if cur >= v.num then
			belongNum = i
		end
	end
	if 1 <= belongNum then
		local perDis = math.ceil(100 / (#self.boxData - 1))
		local baseDis = (belongNum - 1) * perDis
		local preTaskNum = self.boxData[belongNum] and self.boxData[belongNum].num or 0
		local afterTaskNum = self.boxData[belongNum + 1] and self.boxData[belongNum + 1].num or self.boxData[#self.boxData].num + 1
		local curDis = (cur - preTaskNum) / (afterTaskNum - preTaskNum) * perDis
		local totalDis = baseDis + curDis
		self.lBarProgress:setPercent(totalDis)
	else
		self.lBarProgress:setPercent(0)
	end
	local caculatePosX = function(num)
		local totalWidth = self.lBarProgress:getContentSize().width
		local perDis = totalWidth / (#self.boxData - 1)
		if SoraDFIsRA() then
			return totalWidth / 2 - (num - 1) * perDis
		else
			return (num - 1) * perDis - totalWidth / 2
		end
	end
	if not self.ocxBoxs then
		self.ocxBoxs, _ENV = self.ocxBoxs, self.ocxBoxs
		for i, v in ipairs(self.boxData) do
			local single
			if i == 1 then
				single = self.btnBox
			else
				single = self.btnBox:clone()
				single:addTo(self.nodeProgress)
			end
			single:getChildByName("Sprite_box"):setSpriteFrame(self.boxImgs[i] or self.boxImgs[1])
			single:getChildByName("Text_price"):setString(string.formatnumberthousands(v.num))
			single:getChildByName("Sprite_get"):setVisible(false)
			single:setTag(i)
			single:setPosition(caculatePosX(i), 0)
			single:addTouchEventListener(handler(self, self.btnBoxClick))
			table.insert(self.ocxBoxs, single)
		end
	end
	self:refreshBoxState()
end
function lightGuardianMainNode:refreshBoxState(...)
	local cur = lightGuardianCtrl:getProperties("progress") or 0
	for i, v in ipairs(self.boxData) do
		if cur >= v.num then
			if self.receivedReward[tostring(i)] and self.receivedReward[tostring(i)] == 1 then
				self:showRoundEffect(self.ocxBoxs[i], 3)
			else
				self:showRoundEffect(self.ocxBoxs[i], 1)
			end
		else
			self:showRoundEffect(self.ocxBoxs[i], 2)
		end
	end
end
function lightGuardianMainNode:showRoundEffect(pNode, state)
	if state == 1 then
		if not pNode:getChildByName("effect_node") then
			local _ENV, _ENV, _ENV, param = "effect_node", pNode, pNode:getChildByName("effect_node"), pNode:getChildByName("effect_node")
			;("effect_node").png = "dh_xsyd_02.png"
			;("effect_node").scale = 3
			_ENV = nil
			;(nil)[1] = cca.rotateBy(1.8666666666666667, 540)
			;(nil)[2] = cca.rotateBy(1.8666666666666667, 540)
			;(nil)[3] = cca.rotateBy(1.8666666666666667, 540)
			;(nil)[4] = cca.rotateBy(1.8666666666666667, 540)
			;(nil)[5] = cca.rotateBy(1.8666666666666667, 540)
			;(nil)[6] = cca.rotateBy(1.8666666666666667, 540)
			;(nil)[7] = cca.rotateBy(1.8666666666666667, 540)
			;(nil)[8] = cca.rotateBy(1.8666666666666667, 540)
			;(nil)[9] = cca.rotateBy(1.8666666666666667, 540)
			;(nil)[10] = cca.rotateBy(1.8666666666666667, 540)
			pNode[1], ("effect_node").seq = "effect_node", cca.seq(nil)
			local actionConfig = pNode
			local roundNode = display.newNode()
			roundNode:setName("effect_node")
			local nSize = pNode:getContentSize()
			roundNode:setPosition(nSize.width / 2, nSize.height / 2)
			roundNode:addTo(pNode, 1)
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
			roundNode:setScale(0.28)
		else
			pNode:getChildByName("effect_node"):setVisible(true)
		end
		pNode:getChildByName("Sprite_box"):setColor(cc.c3b(255, 255, 255))
		pNode:getChildByName("Sprite_get"):setVisible(false)
	elseif state == 2 then
		if pNode:getChildByName("effect_node") then
			pNode:getChildByName("effect_node"):setVisible(false)
		end
		pNode:getChildByName("Sprite_box"):setColor(cc.c3b(255, 255, 255))
		pNode:getChildByName("Sprite_get"):setVisible(false)
	elseif state == 3 then
		if pNode:getChildByName("effect_node") then
			pNode:getChildByName("effect_node"):setVisible(false)
		end
		pNode:getChildByName("Sprite_box"):setColor(cc.c3b(125, 125, 125))
		pNode:getChildByName("Sprite_get"):setVisible(true)
	end
end
function lightGuardianMainNode:btnInfoClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tag = target:getTag()
		SoraDCreatePanel("lightGuardianPointDetail"):show()
	end
end
function lightGuardianMainNode:btnBoxClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tag = target:getTag()
		local isNotGet = self.receivedReward[tostring(tag)] and self.receivedReward[tostring(tag)] == 0
		if tag <= (lightGuardianCtrl:getProperties("stage") or 0) and isNotGet then
			lightGuardianCtrl:reqRadianceGuardianReward(tag)
		else
			local panel = SoraDCreatePanel("lightGuardianRewardView")
			panel:initData(tag)
			panel:show()
		end
	end
end
function lightGuardianMainNode:btnGetPointsClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tag = target:getTag()
		SoraDCreatePanel("lightGuardianExplainView"):show()
	end
end
function lightGuardianMainNode:msgCallBack(target, data)
	if data.subMsg == "init" or data.subMsg == "getReward" then
		self:initData()
	end
end
return lightGuardianMainNode
