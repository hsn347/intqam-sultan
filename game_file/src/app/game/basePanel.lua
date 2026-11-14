local cca = ffa
local packageManager = requireLocal("fgui.base.packageManager")
local basePanel = class("basePanel", function(ccsFile, data)
	local view = include("ccsView").new(ccsFile)
	view.isFgui = true
	view:setTouchEnabled(true)
	if data and data.futureName then
		print("set basepanel name", data.futureName)
		view:setName(data.futureName)
		view._name = data.futureName
	end
	return view
end)
function basePanel:ctor()
	print("basePanel ctor", self._name)
	self.isADShow = include("rechargeADRead").isADOpen(self:getName())
	self.isHaveTextField = false
	self.isHideCurrentSceneView = false
	self.isHidePrePanel = true
	self.showPanelPowerValue = 1
	self.fadeInDelay = nil
	self.scaleActTarget = nil
	self.needCallBack2SDK = false
	self.isAddToPopManager = false
	self.isCantCloseByReturn = false
	self:deviceFitOffset()
end
function basePanel:bindBtnClose()
	self.closeButton = SoraDGetChildByName(self, "Button_close")
	print("self.closeButton = ", self.closeButton)
	if self.closeButton then
		self.closeButton:addTouchEventListener(function(ref, type)
			if type == ccui.TouchEventType.ended then
				SoraDPlaySound("uicontrol", 1)
				self:close(ref, type)
			end
		end)
	end
end
function basePanel:closeKeyBoard()
	local glView = cc.Director:getInstance():getOpenGLView()
	if glView then
		glView:setIMEKeyboardState(false)
	end
end
function basePanel:panelFadeIn()
	local ccsView = self:getChildByName("ccsView")
	if ccsView then
		ccsView:setOpacity(0)
		ccsView:runAction(cca.fadeIn(self.fadeInDelay))
	end
end
function basePanel:panelScaleAct()
	if self.scaleActTarget then
		self.scaleActTarget:setScale(0)
		self.scaleActTarget:runAction(cc.EaseBackOut:create(cca.scaleTo(0.3, 1.0)))
	end
end
function basePanel:panelScaleActBack()
	if self.scaleActTarget then
		self.scaleActTarget:setScale(1.0)
		_ENV = nil
		;(nil)[1] = cc.EaseBackIn:create(cca.scaleTo(0.3, 0.0))
		;(nil)[2] = cca.callFunc(function()
			self:removeFromParent()
		end)
		;(nil)[3] = cca.callFunc(function()
			self:removeFromParent()
		end)
		;(nil)[4] = cca.callFunc(function()
			self:removeFromParent()
		end)
		;(nil)[5] = cca.callFunc(function()
			self:removeFromParent()
		end)
		self.scaleActTarget:runAction(cca.seq(nil))
	end
end
function basePanel:deviceFitOffset()
	local preViewHeight = self:getContentSize().height
	local scale = self:getPanelOffsetHeight() / preViewHeight
	if preViewHeight ~= 960 and preViewHeight ~= 1136 then
		return
	end
	local target = self
	local ccsView = self:getChildByName("ccsView")
	if ccsView then
		target = ccsView
	end
	if ccsView then
		ccsView:setContentSize(display.size)
		self:setContentSize(display.size)
		local allChild = ccsView:getChildren()
		for k, v in pairs(allChild) do
			local childName = v:getName()
			local nameTabel = SoraDStringSplit(childName, "_")
			local offsetType = nameTabel[1]
			for i, m in pairs(nameTabel) do
				if m == "Size" then
					local setSize = cc.size(v:getContentSize().width, v:getContentSize().height + self:getPanelOffsetHeight() - preViewHeight)
					v:setContentSize(setSize)
				elseif m == "Tile" then
					v:setFillType(1)
				elseif m == "ySize" then
					local setSize = cc.size(v:getContentSize().width + self:getPanelOffsetHeight() - preViewHeight, v:getContentSize().height)
					v:setContentSize(setSize)
				end
			end
			if childName == "Image_bg" then
				v:setContentSize(display.size)
			end
			if offsetType == "Top" then
				if self.isADShow.ADType == 1 and nameTabel[3] == "commonFramTitle" then
					v:setPositionY(display.height - (preViewHeight - v:getPositionY()))
					self:addRechargeADNode(v)
					self.isADShow.ADType = 2
				else
					v:setPositionY(self:getPanelOffsetHeight() - (preViewHeight - v:getPositionY()))
				end
				if self.isADShow.ADType == 1 then
					local topNodeChild = v:getChildren()
					for j, topChild in ipairs(topNodeChild) do
						local topChildName = topChild:getName()
						local nameTabel = SoraDStringSplit(topChildName, "_")
						if nameTabel[2] == "commonFramTitle" then
							topChild:setPositionY(topChild:getPositionY() + (display.height - self:getPanelOffsetHeight()))
							self:addRechargeADNode(topChild)
							self.isADShow.ADType = 2
							break
						end
					end
				end
			elseif offsetType == "Center" then
				v:setPositionY(v:getPositionY() * scale)
			elseif offsetType == "Bottom" then
			end
		end
	end
end
function basePanel:addRechargeADNode(target)
	local node = SoraDGetChildByName(self, "rechargeTinyPageNode")
	if node == nil then
		node = SoraDCreatePanel("rechargeTinyPageNode")
		node:addTo(target, -1)
	end
	node:setPosition(cc.p(0, RECHARGE_AD_OFFSET_Y))
	if self.isADShow.menuID ~= 0 then
		node:setMyGiftType(self.isADShow.menuID)
	end
	return node
end
function basePanel:deviceFitSize()
end
function basePanel:judgeShowPanelPower()
	local confirmToPop = true
	local topPanelPowerVlaue = SoraDCurrentTopPanelFromManager() and SoraDCurrentTopPanelFromManager().showPanelPowerValue or 1
	if topPanelPowerVlaue == 1 and self.showPanelPowerValue == 1 then
		return confirmToPop
	end
	if topPanelPowerVlaue < self.showPanelPowerValue then
		SoraDRemoveAllPanelFromManager()
	elseif topPanelPowerVlaue > self.showPanelPowerValue then
		confirmToPop = false
	elseif self.showPanelPowerValue == self.showPanelPowerValue then
	end
	return confirmToPop
end
function basePanel:show(parent, zOrder)
	if not self:judgeShowPanelPower() then
		return
	end
	local isFgui = self.isFgui
	parent = parent or display.getRunningScene().panelView
	if parent then
		parent:addChild(self, zOrder or 1)
		SoraDAddPanelToManager(self)
		if isFgui then
		end
	end
	if self.fadeInDelay then
		self:panelFadeIn()
	end
	self:endShow()
	cocosUIManager:afterAddToParent(self)
	return self
end
function basePanel:gameGuide_getTarget(itemName, parameters)
	return SoraDGetChildByName(self, itemName)
end
function basePanel:close(ref, type)
	if type == ccui.TouchEventType.ended then
		self:closePanel()
	end
end
function basePanel:closePanel()
	SoraCollectgarbage(self.__cname)
	if tolua.isnull(self) then
		return
	end
	local isAddToCache = cocosUIManager:recycleInstanceView(self)
	self:removeFromParent(not isAddToCache)
end
function basePanel:endShow()
end
function basePanel:onEnterPanel()
end
function basePanel:onExitPanel()
end
function basePanel:onEnterOther()
	self:onEnterPanel()
end
function basePanel:onExitOther()
	if self.isHaveTextField then
		self:closeKeyBoard()
	end
	self:onExitPanel()
	SoraDRemovePanelFromManager(self)
	if self.needCallBack2SDK then
		userSDKManager.needCallBack2SDK(self.__cname)
	end
	if self.isAddToPopManager then
		SoraDDeleteTopWindow()
	end
end
return basePanel
