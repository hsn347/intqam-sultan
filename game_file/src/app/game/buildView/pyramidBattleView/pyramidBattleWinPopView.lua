local publicRead = include("publicRead")
local gametop = gModuleMgr.getObject("gametop")
local legendLordWarCtrl = gametop.playertop_:getModule("legendLordWarCtrl")
local pyramidBattleWinPopView = class("pyramidBattleWinPopView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("pyramidBattleWinPopView")
	end
	return target
end)
function pyramidBattleWinPopView:ctor()
	self.style = 1
	self.node_action = SoraDGetChildByName(self, "Node_action")
	self.text_des = SoraDGetChildByName(self, "Text_des")
	self.text_tip = SoraDGetChildByName(self, "Text_tip")
	self.btn_ok = SoraDGetChildByName(self, "Button_ok")
	self.btn_ok:setTitleText(i18n("common_text_204"))
	self.btn_ok:addTouchEventListener(handler(self, self.btnOKClickCallBack))
	self.single = SoraDGetChildByName(self, "Panel_single")
	self.scroll = SoraDGetChildByName(self, "Size_ScrollView_rewards")
	local sharePicBtn = include("commonShareButton").createSnapshootButton(3, self)
	sharePicBtn:setPosition(self.btn_ok:getPositionX() - SoraDFSign(155), self.btn_ok:getPositionY())
	sharePicBtn:addTo(self.btn_ok:getParent(), self.btn_ok:getLocalZOrder())
	self.text_tip:setVisible(false)
	self.enableTouchCloseSelf = true
	self.timeHandler = SoraDCreateTimerEx(self, handler(self, self.endTime), 10)
	self.baseclose = self.close
	function self.close()
		print("overrided ")
	end
end
function pyramidBattleWinPopView:setStyle(style)
	self.style = style
	self:initAction()
end
function pyramidBattleWinPopView:initLegendData(data)
	local time = data.occupySecs
	local rank = data.rank
	self.enableTouchCloseSelf = false
	print(self.enableTouchCloseSelf, "self.enableTouchCloseSelf")
	local hegemonRead = include("hegemonRead")
	local bid = legendLordWarCtrl:getOpenBuildID(gametop.playertop_:getMapID())
	local name
	if not bid or bid <= 0 or hegemonRead.isLegendLordBuilding(bid) then
		if worldMapDefine.isKingStarMapId(gametop.playertop_:getMapID()) then
			name = i18n("kingstarbattle_text_55")
		else
			name = i18n("common_text_4213")
		end
	else
		name = hegemonRead.getName(bid)
	end
	local strTime = SoraDConvertSecondToString(time)
	_ENV = gametop.playertop_:getMapID()
	gametop.playertop_:getMapID().time = strTime
	gametop.playertop_:getMapID().rank = rank
	gametop.playertop_:getMapID().name = name
	self.text_des:setString(i18n("common_text_4238", gametop.playertop_:getMapID()))
	local reward = data.rewards
	self:setReward(reward)
end
function pyramidBattleWinPopView:initData(reward, tips)
	self.text_des:setString(i18n("common_text_3247"))
	self:setReward(reward)
	local showTip = tips or false
	if showTip then
		self.text_tip:setVisible(true)
		self.text_tip:setString(i18n("common_text_3451"))
	else
		self.text_tip:setVisible(false)
	end
end
function pyramidBattleWinPopView:setReward(reward)
	if not reward then
		reward, _ENV = nil, nil
	end
	local scrollH = math.max(self.scroll:getContentSize().height, 80 * table.nums(reward))
	self.scroll:setInnerContainerSize(cc.size(self.scroll:getContentSize().width, scrollH))
	for k, v in ipairs(reward) do
		local single = self:getSingle(v)
		single:setPosition(cc.p(0, scrollH - 80 * k))
		single:addTo(self.scroll)
	end
end
function pyramidBattleWinPopView:initAction()
	if self.style == 1 then
		local node = SoraDCreatAnimation("animationPyramidBattleWin", nil, false)
		node:addTo(self.node_action)
	elseif self.style == 2 then
		local node = SoraDCreatAnimation("animationKingWarWin", nil, false)
		node:addTo(self.node_action)
	elseif self.style == 3 then
		local hegemonRead = include("hegemonRead")
		local bid = legendLordWarCtrl:getOpenBuildID(worldMapDefine.currentMapKindomID)
		if not bid or bid <= 0 or hegemonRead.isLegendLordBuilding(bid) then
			if worldMapDefine.isKingStarMapId(gametop.playertop_:getMapID()) then
				local node = SoraDCreatAnimation("animationKingStar", nil, false)
				node:addTo(self.node_action)
			else
				local node = SoraDCreatAnimation("animationLegendKing", nil, false)
				node:addTo(self.node_action)
			end
		else
			local node = SoraDCreatAnimation("animationHegemon", nil, false)
			node:addTo(self.node_action)
		end
	end
end
function pyramidBattleWinPopView:btnOKClickCallBack(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		self:doReLogin()
	end
end
function pyramidBattleWinPopView:getSingle(data)
	local single = self.single:clone()
	local img_item = single:getChildByName("Image_item")
	local img_bg = single:getChildByName("Image_bg")
	local lab_name = single:getChildByName("Text_name")
	local lab_num = single:getChildByName("Text_num")
	img_bg:loadTexture(publicRead.getBg(data.id), ccui.TextureResType.plistType)
	img_item:loadTexture(publicRead.getIcon(data.id), ccui.TextureResType.plistType)
	lab_name:setString(publicRead.getName(data.id))
	lab_num:setString("x" .. data.count)
	return single
end
function pyramidBattleWinPopView:endTime(dt)
	self:doReLogin(true)
end
function pyramidBattleWinPopView:doReLogin(isTimeEnd)
	if self.style == 3 then
		if not isTimeEnd then
			self:removeFromParent()
		end
		return
	end
	gametop:Logout()
	SoraDShowLoginView()
end
return pyramidBattleWinPopView
