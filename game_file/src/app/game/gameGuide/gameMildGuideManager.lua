local mildGuideManager = class("mildGuideManager")
local MildGuideConfig = require("app." .. LocalTblPath .. ".config_client.gameMildGuideConfig")
function mildGuideManager:ctor()
	self.pileLine, _UPVALUE0_ = nil, nil
	self.mildParent = nil
	self.mildNewPlayerFun, _UPVALUE0_, self.mildVariate, _UPVALUE0_, self.mildEffectTimer = nil, nil, nil, nil, nil
	self:initNewPlayerQuest()
	self:initEverydayTask()
end
function mildGuideManager:star()
	dump(self.pileLine, "self.pileLine", 10)
	if #self.pileLine > 0 then
		_ENV = self.pileLine
		self.pileLine.msg = "MESSAGE_NEW_PLAYER_QUEST_NOTICE_HAND_CLEAN"
		self.pileLine.needStop = true
		SoraDSendMessage(self.pileLine)
		self:walkOn(table.remove(self.pileLine, 1))
	end
end
function mildGuideManager:isInMildGuide()
	return #self.pileLine > 0 or self.mildParent ~= nil
end
function mildGuideManager:insertPileLine(key, data, isInit)
	if isInit then
		self:clean()
	end
	self:createPileLine(key, data, self.pileLine)
end
function mildGuideManager:updatePanelShow(panelName)
	print("panelName", panelName)
	for i, v in ipairs(self.pileLine) do
		if v.className and v.className == panelName then
			self:deleteRunEffect()
			self:walkOn(v)
			for index = 1, i do
				table.remove(self.pileLine, 1)
			end
			break
		end
	end
end
function mildGuideManager:updateIndex(buildIndex)
	for i, v in ipairs(self.pileLine) do
		if v.index and v.className and v.className == "mainCityView" then
			v.index = buildIndex
			if v.action and v.action.index then
				v.action.index = buildIndex
			end
		end
	end
end
function mildGuideManager:walkOn(stepData)
	dump(stepData, "walkOn")
	if stepData.action then
		self:runStepAction(stepData.action)
	else
	end
	local targetView, targetClass = self:getTargetByData(stepData)
	dump(targetView, "targetView")
	dump(targetClass, "targetClass")
	if targetClass then
		self:drawFingerToTarget(targetClass, stepData)
		if stepData.selTabIndex then
			targetClass.selTabIndex = stepData.selTabIndex
		end
	elseif stepData.again and stepData.again > 0 then
		stepData.again = stepData.again - 1
		SoraDCreateDelayTimer(self, function(...)
			self:walkOn(stepData)
		end, stepData.delayTime)
	end
	if stepData.autoNext then
		self:star()
	end
end
function mildGuideManager:runStepAction(action)
	local className = action.name
	if className == "mainCityView" then
		if action.index then
			_ENV = nil
			;(nil).msg = "MESSAGE_MAINCITYVIEW_GO_TO_BUILD"
			;(nil).buildIndex = action.index
			;(nil).delay = action.delay
			;(nil).isStep = true
			;(nil).isSelected = action.isSelected
			SoraDSendMessage(nil)
		elseif action.bid then
			if action.iid and action.iid < 0 then
				local gametop = gModuleMgr.getObject("gametop")
				local cityCtrl = gametop.playertop_:getModule("cityCtrl")
				local buildList = cityCtrl:getBuildCellList(action.bid)
				for i, v in ipairs(buildList) do
					local buildLv = tonumber(v.info.lv)
					if buildLv == 1 then
						action.iid = tonumber(v.info.iid)
					end
				end
			end
			_ENV = gametop.playertop_:getModule("cityCtrl")
			gametop.playertop_:getModule("cityCtrl").msg = "MESSAGE_MAINCITYVIEW_GO_TO_BUILD"
			gametop.playertop_:getModule("cityCtrl").buildID = action.bid
			gametop.playertop_:getModule("cityCtrl").iid = action.iid
			gametop.playertop_:getModule("cityCtrl").delay = action.delay
			gametop.playertop_:getModule("cityCtrl").isSelected = action.isSelected
			gametop.playertop_:getModule("cityCtrl").isStep = true
			SoraDSendMessage((gametop.playertop_:getModule("cityCtrl")))
		elseif action.move then
			_ENV = gametop.playertop_:getModule("cityCtrl")
			gametop.playertop_:getModule("cityCtrl").msg = "MESSAGE_MAINCITYVIEW_MOVE_CAMERA_TO"
			gametop.playertop_:getModule("cityCtrl").targetPos = action.move
			gametop.playertop_:getModule("cityCtrl").delay = action.delay
			SoraDSendMessage((gametop.playertop_:getModule("cityCtrl")))
		elseif action.jump then
			_ENV = gametop.playertop_:getModule("cityCtrl")
			gametop.playertop_:getModule("cityCtrl").msg = "MESSAGE_MAINSCEN_ONSHOW"
			gametop.playertop_:getModule("cityCtrl").viewType = VIEW_TYPE_CITY
			SoraDSendMessage((gametop.playertop_:getModule("cityCtrl")))
		elseif action.hand then
			_ENV = gametop.playertop_:getModule("cityCtrl")
			gametop.playertop_:getModule("cityCtrl").msg = "MESSAGE_QUEST_NOTICE_SHOW_HAND"
			SoraDSendMessage((gametop.playertop_:getModule("cityCtrl")))
		end
	elseif className == "worldMapView" then
		if action.key then
			if SoraDCurrentSceneShowView("worldMapView"):gameGuide_getTarget("closestResourceFood", action) == nil and action.again and 0 < action.again then
				action.again = action.again - 1
				SoraDCreateDelayTimer(self, function(...)
					self:runStepAction(action)
				end, 0.5)
			end
		elseif action.jump then
			SoraDGotoWorldMapPoint(action.pos)
		end
	elseif className == "msg" then
		SoraDShowMsgTip(action.msg)
	elseif className == "variate" then
		self:setVariate(action.className, action.variate)
	elseif className == "callFunc" then
		local targetView = SoraDCurrentSceneShowView(action.targetName)
		if targetView and targetView.gameGuide_callFunc then
			targetView:gameGuide_callFunc(action.callFunc, action.data)
		end
	elseif className == "viewCallFunc" then
		local callFuncName = action.callFunc
		if callFuncName and type(callFuncName) == "string" then
			local targetView = SoraDSearchPanelFromManagerByName(action.targetName)
			if targetView then
				if targetView[callFuncName] then
					targetView[callFuncName](targetView, action.data)
				else
					print(action.targetName .. " do not have function:" .. callFuncName)
				end
			else
				print("do not find targetView：", action.targetName)
			end
		else
			print("error:viewCallFunc action.callFunc must be string")
		end
	end
end
function mildGuideManager:getTargetByData(stepData)
	if stepData.itemName == nil then
		return
	end
	dump(stepData, "找对象")
	local targetView, targetClass
	if stepData.className == "worldMapView" then
		targetView = SoraDCurrentSceneShowView(stepData.className)
	elseif stepData.className == "mainCityView" then
		targetView = SoraDCurrentSceneShowView(stepData.className)
	elseif stepData.className == "mainUI" then
		targetView = SoraDCurrentMainUI()
	elseif stepData.className == "gameGuideView" then
		targetView = display.getRunningScene():getChildByName(stepData.className)
	else
		local topPanel = SoraDCurrentTopPanelFromManager()
		if topPanel and stepData.className == topPanel.__cname then
			targetView = topPanel
		else
			topPanel = SoraDSearchPanelFromManagerByName(stepData.className)
			if topPanel then
				targetView = topPanel
			else
				print("mildGuideManager:getTargetByData can not find ", stepData.className)
			end
		end
	end
	if targetView and stepData.itemName then
		targetClass = targetView:gameGuide_getTarget(stepData.itemName, stepData)
	end
	return targetView, targetClass
end
function mildGuideManager:drawFingerToTarget(target, stepData)
	self:deleteRunEffect()
	self.mildParent = target
	self.mildParent.effectZOrder = stepData and stepData.z and stepData.z or 0
	self:createEffectNode()
	if stepData.isMild then
		self:showUpgradeEffect()
	else
		self:showFinger(stepData)
	end
	self:bindCallBack()
	if self.mildEffectTimer then
		SoraDManagerRemoveTimer(self, self.mildEffectTimer)
		self.mildEffectTimer = nil
	end
	if stepData and stepData.waitDelay == -1 then
		return
	end
	self.mildEffectTimer = SoraDCreateDelayTimer(self, handler(self, self.deleteRunEffect), stepData and stepData.waitDelay and stepData.waitDelay or 5)
end
function mildGuideManager:createEffectNode()
	local effectNode = display.newNode()
	effectNode:setName("mildEffect")
	if self.mildParent.effectZOrder > 0 then
		print("effectZOrder ", self.mildParent.effectZOrder)
		local curNode = self.mildParent
		for i = 1, self.mildParent.effectZOrder do
			if curNode:getParent() == nil then
				print("is err effectZOrder")
				break
			else
				print("find parent")
				curNode = curNode:getParent()
			end
		end
		local convertPos = curNode:convertToNodeSpace(self.mildParent:convertToWorldSpace(cc.p(0, 0)))
		effectNode:setPosition(convertPos)
		effectNode:addTo(curNode, 1100)
	else
		effectNode:setPosition(cc.p(0, 0))
		effectNode:addTo(self.mildParent, 1100)
	end
end
function mildGuideManager:isMainUIBottomBtn(btnName)
	_UPVALUE0_ = nil
	;(nil).Button_worldCity = true
	;(nil).Button_mail = true
	;(nil).Button_alliance = true
	;(nil).Button_items = true
	local (nil).Button_hero, data = true, nil
	if data[btnName] then
		return true
	end
	return false
end
function mildGuideManager:getEffectNode()
	if self.mildParent.effectZOrder > 0 then
		local curNode = self.mildParent
		for i = 1, self.mildParent.effectZOrder do
			if curNode:getParent() == nil then
				print("is err effectZOrder")
				break
			else
				print("find parent")
				curNode = curNode:getParent()
			end
		end
		return curNode:getChildByName("mildEffect")
	else
		return self.mildParent:getChildByName("mildEffect")
	end
end
function mildGuideManager:bindCallBack()
	function self.mildParent.mildGuideCallBack(target, type)
		if type == ccui.TouchEventType.ended then
			local effectNode = self:getEffectNode()
			if effectNode then
				effectNode:removeFromParent()
			end
			self:deleteRunEffect()
		end
	end
end
function mildGuideManager:getTouchRect()
	local boundingBox = self.mildParent:getBoundingBox()
	local targetSize = cc.size(boundingBox.width, boundingBox.height)
	print("scale", self.mildParent.effectZOrder)
	if self.mildParent.effectZOrder <= 0 then
		local scale = self.mildParent:getParent():getScale()
		scale = scale == 0 and 1 or scale
		print("scale", self.mildParent.effectZOrder, scale)
		targetSize = cc.size(targetSize.width / scale, targetSize.height / scale)
	end
	return targetSize
end
function mildGuideManager:showRoundEffect()
	local effectNode = self:getEffectNode()
	local targetRect = self:getTouchRect()
	local _ENV, _ENV, _ENV, param = nil, nil, self, self
	;(nil).png = "dh_xsyd_01.png"
	;(nil).scale = 2.75
	;(nil).opacity = 178.5
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
	;(nil)[10] = cca.fadeTo(0.5333333333333333, 0.7)
	;(nil)[11] = cca.fadeTo(0.5333333333333333, 0.7)
	;(nil)[12] = cca.fadeTo(0.5333333333333333, 0.7)
	;(nil)[13] = cca.fadeTo(0.5333333333333333, 0.7)
	;(nil)[14] = cca.fadeTo(0.5333333333333333, 0.7)
	_ENV, (nil)[1], (nil).seq = nil, nil, cca.seq(nil)
	;(nil).png = "dh_xsyd_07.png"
	_ENV, (nil)[2], (nil).scale = nil, nil, 2
	;(nil).png = "dh_xsyd_02.png"
	;(nil).scale = 2.4
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
	;(nil)[10] = cca.rotateBy(1.0833333333333333, 540)
	;(nil)[11] = cca.rotateBy(1.0833333333333333, 540)
	;(nil)[12] = cca.rotateBy(1.0833333333333333, 540)
	;(nil)[13] = cca.rotateBy(1.0833333333333333, 540)
	;(nil)[14] = cca.rotateBy(1.0833333333333333, 540)
	_ENV, (nil)[3], (nil).seq = nil, nil, cca.seq(nil)
	;(nil).png = "dh_xsyd_03.png"
	;(nil).scale = 2
	_ENV = nil
	;(nil)[1] = cca.rotateBy(1.0833333333333333, -180)
	;(nil)[2] = cca.rotateBy(1.0833333333333333, -180)
	;(nil)[3] = cca.rotateBy(1.0833333333333333, -180)
	;(nil)[4] = cca.rotateBy(1.0833333333333333, -180)
	;(nil)[5] = cca.rotateBy(1.0833333333333333, -180)
	;(nil)[6] = cca.rotateBy(1.0833333333333333, -180)
	;(nil)[7] = cca.rotateBy(1.0833333333333333, -180)
	;(nil)[8] = cca.rotateBy(1.0833333333333333, -180)
	;(nil)[9] = cca.rotateBy(1.0833333333333333, -180)
	;(nil)[10] = cca.rotateBy(1.0833333333333333, -180)
	;(nil)[11] = cca.rotateBy(1.0833333333333333, -180)
	;(nil)[12] = cca.rotateBy(1.0833333333333333, -180)
	;(nil)[13] = cca.rotateBy(1.0833333333333333, -180)
	;(nil)[14] = cca.rotateBy(1.0833333333333333, -180)
	_ENV, (nil)[4], (nil).seq = nil, nil, cca.seq(nil)
	;(nil).png = "dh_xsyd_07.png"
	;(nil).scale = 2
	;(nil).opacity = 0
	_UPVALUE4_ = nil
	_UPVALUE1_ = cca.rotateBy(1.0833333333333333, -180)
	cca.rotateBy(1.0833333333333333, -180)[1] = cca.scaleTo(0.03333333333333333, 2.1)
	cca.rotateBy(1.0833333333333333, -180)[2] = cca.fadeTo(0.03333333333333333, 0.3)
	cca.rotateBy(1.0833333333333333, -180)[3] = cca.fadeTo(0.03333333333333333, 0.3)
	cca.rotateBy(1.0833333333333333, -180)[4] = cca.fadeTo(0.03333333333333333, 0.3)
	cca.rotateBy(1.0833333333333333, -180)[5] = cca.fadeTo(0.03333333333333333, 0.3)
	cca.rotateBy(1.0833333333333333, -180)[6] = cca.fadeTo(0.03333333333333333, 0.3)
	cca.rotateBy(1.0833333333333333, -180)[7] = cca.fadeTo(0.03333333333333333, 0.3)
	cca.rotateBy(1.0833333333333333, -180)[8] = cca.fadeTo(0.03333333333333333, 0.3)
	cca.rotateBy(1.0833333333333333, -180)[9] = cca.fadeTo(0.03333333333333333, 0.3)
	cca.rotateBy(1.0833333333333333, -180)[10] = cca.fadeTo(0.03333333333333333, 0.3)
	cca.rotateBy(1.0833333333333333, -180)[11] = cca.fadeTo(0.03333333333333333, 0.3)
	_UPVALUE1_ = cca.scaleTo(0.03333333333333333, 2.1)
	cca.scaleTo(0.03333333333333333, 2.1)[1] = cca.scaleTo(0.23333333333333334, 2.3)
	cca.scaleTo(0.03333333333333333, 2.1)[2] = cca.fadeTo(0.23333333333333334, 0.8)
	cca.scaleTo(0.03333333333333333, 2.1)[3] = cca.fadeTo(0.23333333333333334, 0.8)
	cca.scaleTo(0.03333333333333333, 2.1)[4] = cca.fadeTo(0.23333333333333334, 0.8)
	cca.scaleTo(0.03333333333333333, 2.1)[5] = cca.fadeTo(0.23333333333333334, 0.8)
	cca.scaleTo(0.03333333333333333, 2.1)[6] = cca.fadeTo(0.23333333333333334, 0.8)
	cca.scaleTo(0.03333333333333333, 2.1)[7] = cca.fadeTo(0.23333333333333334, 0.8)
	cca.scaleTo(0.03333333333333333, 2.1)[8] = cca.fadeTo(0.23333333333333334, 0.8)
	cca.scaleTo(0.03333333333333333, 2.1)[9] = cca.fadeTo(0.23333333333333334, 0.8)
	cca.scaleTo(0.03333333333333333, 2.1)[10] = cca.fadeTo(0.23333333333333334, 0.8)
	_UPVALUE1_ = cca.scaleTo(0.23333333333333334, 2.3)
	cca.scaleTo(0.23333333333333334, 2.3)[1] = cca.scaleTo(0.4, 2.5)
	cca.scaleTo(0.23333333333333334, 2.3)[2] = cca.fadeTo(0.4, 0)
	cca.scaleTo(0.23333333333333334, 2.3)[3] = cca.fadeTo(0.4, 0)
	cca.scaleTo(0.23333333333333334, 2.3)[4] = cca.fadeTo(0.4, 0)
	cca.scaleTo(0.23333333333333334, 2.3)[5] = cca.fadeTo(0.4, 0)
	cca.scaleTo(0.23333333333333334, 2.3)[6] = cca.fadeTo(0.4, 0)
	cca.scaleTo(0.23333333333333334, 2.3)[7] = cca.fadeTo(0.4, 0)
	cca.scaleTo(0.23333333333333334, 2.3)[8] = cca.fadeTo(0.4, 0)
	cca.scaleTo(0.23333333333333334, 2.3)[9] = cca.fadeTo(0.4, 0)
	;(nil)[1] = cca.delay(0.2)
	;(nil)[2] = cca.spawn(cca.rotateBy(1.0833333333333333, -180))
	;(nil)[3] = cca.spawn((cca.scaleTo(0.03333333333333333, 2.1)))
	;(nil)[4] = cca.spawn((cca.scaleTo(0.23333333333333334, 2.3)))
	;(nil)[5] = cca.delay(0.21666666666666667)
	;(nil)[6] = cca.delay(0.21666666666666667)
	;(nil)[7] = cca.delay(0.21666666666666667)
	;(nil)[8] = cca.delay(0.21666666666666667)
	;(nil)[9] = cca.delay(0.21666666666666667)
	;(nil)[10] = cca.delay(0.21666666666666667)
	;(nil)[11] = cca.delay(0.21666666666666667)
	;(nil)[12] = cca.delay(0.21666666666666667)
	;(nil)[13] = cca.delay(0.21666666666666667)
	;(nil)[14] = cca.delay(0.21666666666666667)
	_ENV, (nil)[5], (nil).seq = nil, nil, cca.seq(nil)
	;(nil).png = "dh_xsyd_04.png"
	;(nil).scale = 1.4
	;(nil).rotation = 70.31
	_UPVALUE6_ = nil
	_UPVALUE1_ = cca.spawn(cca.rotateBy(1.0833333333333333, -180))
	cca.spawn(cca.rotateBy(1.0833333333333333, -180))[1] = cca.scaleTo(0.08333333333333333, 1.55)
	cca.spawn(cca.rotateBy(1.0833333333333333, -180))[2] = cca.fadeTo(0.08333333333333333, 0.9)
	cca.spawn(cca.rotateBy(1.0833333333333333, -180))[3] = cca.fadeTo(0.08333333333333333, 0.9)
	cca.spawn(cca.rotateBy(1.0833333333333333, -180))[4] = cca.fadeTo(0.08333333333333333, 0.9)
	cca.spawn(cca.rotateBy(1.0833333333333333, -180))[5] = cca.fadeTo(0.08333333333333333, 0.9)
	cca.spawn(cca.rotateBy(1.0833333333333333, -180))[6] = cca.fadeTo(0.08333333333333333, 0.9)
	cca.spawn(cca.rotateBy(1.0833333333333333, -180))[7] = cca.fadeTo(0.08333333333333333, 0.9)
	cca.spawn(cca.rotateBy(1.0833333333333333, -180))[8] = cca.fadeTo(0.08333333333333333, 0.9)
	cca.spawn(cca.rotateBy(1.0833333333333333, -180))[9] = cca.fadeTo(0.08333333333333333, 0.9)
	cca.spawn(cca.rotateBy(1.0833333333333333, -180))[10] = cca.fadeTo(0.08333333333333333, 0.9)
	cca.spawn(cca.rotateBy(1.0833333333333333, -180))[11] = cca.fadeTo(0.08333333333333333, 0.9)
	cca.spawn(cca.rotateBy(1.0833333333333333, -180))[12] = cca.fadeTo(0.08333333333333333, 0.9)
	_UPVALUE1_ = cca.scaleTo(0.08333333333333333, 1.55)
	cca.scaleTo(0.08333333333333333, 1.55)[1] = cca.scaleTo(0.16666666666666666, 1.85)
	cca.scaleTo(0.08333333333333333, 1.55)[2] = cca.fadeTo(0.16666666666666666, 0.8)
	cca.scaleTo(0.08333333333333333, 1.55)[3] = cca.fadeTo(0.16666666666666666, 0.8)
	cca.scaleTo(0.08333333333333333, 1.55)[4] = cca.fadeTo(0.16666666666666666, 0.8)
	cca.scaleTo(0.08333333333333333, 1.55)[5] = cca.fadeTo(0.16666666666666666, 0.8)
	cca.scaleTo(0.08333333333333333, 1.55)[6] = cca.fadeTo(0.16666666666666666, 0.8)
	cca.scaleTo(0.08333333333333333, 1.55)[7] = cca.fadeTo(0.16666666666666666, 0.8)
	cca.scaleTo(0.08333333333333333, 1.55)[8] = cca.fadeTo(0.16666666666666666, 0.8)
	cca.scaleTo(0.08333333333333333, 1.55)[9] = cca.fadeTo(0.16666666666666666, 0.8)
	cca.scaleTo(0.08333333333333333, 1.55)[10] = cca.fadeTo(0.16666666666666666, 0.8)
	cca.scaleTo(0.08333333333333333, 1.55)[11] = cca.fadeTo(0.16666666666666666, 0.8)
	_UPVALUE1_ = cca.scaleTo(0.16666666666666666, 1.85)
	cca.scaleTo(0.16666666666666666, 1.85)[1] = cca.scaleTo(0.08333333333333333, 2)
	cca.scaleTo(0.16666666666666666, 1.85)[2] = cca.fadeTo(0.08333333333333333, 0.4)
	cca.scaleTo(0.16666666666666666, 1.85)[3] = cca.fadeTo(0.08333333333333333, 0.4)
	cca.scaleTo(0.16666666666666666, 1.85)[4] = cca.fadeTo(0.08333333333333333, 0.4)
	cca.scaleTo(0.16666666666666666, 1.85)[5] = cca.fadeTo(0.08333333333333333, 0.4)
	cca.scaleTo(0.16666666666666666, 1.85)[6] = cca.fadeTo(0.08333333333333333, 0.4)
	cca.scaleTo(0.16666666666666666, 1.85)[7] = cca.fadeTo(0.08333333333333333, 0.4)
	cca.scaleTo(0.16666666666666666, 1.85)[8] = cca.fadeTo(0.08333333333333333, 0.4)
	cca.scaleTo(0.16666666666666666, 1.85)[9] = cca.fadeTo(0.08333333333333333, 0.4)
	cca.scaleTo(0.16666666666666666, 1.85)[10] = cca.fadeTo(0.08333333333333333, 0.4)
	_UPVALUE1_ = cca.scaleTo(0.08333333333333333, 2)
	cca.scaleTo(0.08333333333333333, 2)[1] = cca.scaleTo(0.08333333333333333, 2.2)
	cca.scaleTo(0.08333333333333333, 2)[2] = cca.fadeTo(0.08333333333333333, 0)
	cca.scaleTo(0.08333333333333333, 2)[3] = cca.fadeTo(0.08333333333333333, 0)
	cca.scaleTo(0.08333333333333333, 2)[4] = cca.fadeTo(0.08333333333333333, 0)
	cca.scaleTo(0.08333333333333333, 2)[5] = cca.fadeTo(0.08333333333333333, 0)
	cca.scaleTo(0.08333333333333333, 2)[6] = cca.fadeTo(0.08333333333333333, 0)
	cca.scaleTo(0.08333333333333333, 2)[7] = cca.fadeTo(0.08333333333333333, 0)
	cca.scaleTo(0.08333333333333333, 2)[8] = cca.fadeTo(0.08333333333333333, 0)
	cca.scaleTo(0.08333333333333333, 2)[9] = cca.fadeTo(0.08333333333333333, 0)
	_UPVALUE1_ = 0.4
	;(0.4)[1] = cca.scaleTo(0.05, 0.8)
	;(0.4)[2] = cca.fadeTo(0.05, 1)
	;(0.4)[3] = cca.fadeTo(0.05, 1)
	;(0.4)[4] = cca.fadeTo(0.05, 1)
	;(0.4)[5] = cca.fadeTo(0.05, 1)
	;(0.4)[6] = cca.fadeTo(0.05, 1)
	;(0.4)[7] = cca.fadeTo(0.05, 1)
	;(nil)[1] = cca.spawn((cca.spawn(cca.rotateBy(1.0833333333333333, -180))))
	;(nil)[2] = cca.spawn((cca.scaleTo(0.08333333333333333, 1.55)))
	;(nil)[3] = cca.spawn((cca.scaleTo(0.16666666666666666, 1.85)))
	;(nil)[4] = cca.spawn((cca.scaleTo(0.08333333333333333, 2)))
	;(nil)[5] = cca.scaleTo(0.5333333333333333, 0.4)
	;(nil)[6] = cca.spawn(0.4)
	;(nil)[7] = cca.scaleTo(0.08333333333333333, 1.4)
	;(nil)[8] = cca.scaleTo(0.08333333333333333, 1.4)
	;(nil)[9] = cca.scaleTo(0.08333333333333333, 1.4)
	;(nil)[10] = cca.scaleTo(0.08333333333333333, 1.4)
	;(nil)[11] = cca.scaleTo(0.08333333333333333, 1.4)
	;(nil)[12] = cca.scaleTo(0.08333333333333333, 1.4)
	;(nil)[13] = cca.scaleTo(0.08333333333333333, 1.4)
	;(nil)[14] = cca.scaleTo(0.08333333333333333, 1.4)
	_ENV, (nil)[6], (nil).seq = nil, nil, cca.seq(nil)
	;(nil).png = "dh_xsyd_05.png"
	;(nil).scale = 0.5
	;(nil).opacity = 0
	_UPVALUE4_ = nil
	_UPVALUE1_ = cca.spawn((cca.scaleTo(0.08333333333333333, 1.55)))
	cca.spawn((cca.scaleTo(0.08333333333333333, 1.55)))[1] = cca.scaleTo(0.16666666666666666, 0.7)
	cca.spawn((cca.scaleTo(0.08333333333333333, 1.55)))[2] = cca.fadeTo(0.16666666666666666, 0.4)
	cca.spawn((cca.scaleTo(0.08333333333333333, 1.55)))[3] = cca.fadeTo(0.16666666666666666, 0.4)
	cca.spawn((cca.scaleTo(0.08333333333333333, 1.55)))[4] = cca.fadeTo(0.16666666666666666, 0.4)
	cca.spawn((cca.scaleTo(0.08333333333333333, 1.55)))[5] = cca.fadeTo(0.16666666666666666, 0.4)
	cca.spawn((cca.scaleTo(0.08333333333333333, 1.55)))[6] = cca.fadeTo(0.16666666666666666, 0.4)
	cca.spawn((cca.scaleTo(0.08333333333333333, 1.55)))[7] = cca.fadeTo(0.16666666666666666, 0.4)
	cca.spawn((cca.scaleTo(0.08333333333333333, 1.55)))[8] = cca.fadeTo(0.16666666666666666, 0.4)
	cca.spawn((cca.scaleTo(0.08333333333333333, 1.55)))[9] = cca.fadeTo(0.16666666666666666, 0.4)
	cca.spawn((cca.scaleTo(0.08333333333333333, 1.55)))[10] = cca.fadeTo(0.16666666666666666, 0.4)
	cca.spawn((cca.scaleTo(0.08333333333333333, 1.55)))[11] = cca.fadeTo(0.16666666666666666, 0.4)
	cca.spawn((cca.scaleTo(0.08333333333333333, 1.55)))[12] = cca.fadeTo(0.16666666666666666, 0.4)
	_UPVALUE1_ = cca.scaleTo(0.16666666666666666, 0.7)
	cca.scaleTo(0.16666666666666666, 0.7)[1] = cca.scaleTo(0.08333333333333333, 0.9)
	cca.scaleTo(0.16666666666666666, 0.7)[2] = cca.fadeTo(0.08333333333333333, 0.6)
	cca.scaleTo(0.16666666666666666, 0.7)[3] = cca.fadeTo(0.08333333333333333, 0.6)
	cca.scaleTo(0.16666666666666666, 0.7)[4] = cca.fadeTo(0.08333333333333333, 0.6)
	cca.scaleTo(0.16666666666666666, 0.7)[5] = cca.fadeTo(0.08333333333333333, 0.6)
	cca.scaleTo(0.16666666666666666, 0.7)[6] = cca.fadeTo(0.08333333333333333, 0.6)
	cca.scaleTo(0.16666666666666666, 0.7)[7] = cca.fadeTo(0.08333333333333333, 0.6)
	cca.scaleTo(0.16666666666666666, 0.7)[8] = cca.fadeTo(0.08333333333333333, 0.6)
	cca.scaleTo(0.16666666666666666, 0.7)[9] = cca.fadeTo(0.08333333333333333, 0.6)
	cca.scaleTo(0.16666666666666666, 0.7)[10] = cca.fadeTo(0.08333333333333333, 0.6)
	cca.scaleTo(0.16666666666666666, 0.7)[11] = cca.fadeTo(0.08333333333333333, 0.6)
	_UPVALUE1_ = cca.scaleTo(0.08333333333333333, 0.9)
	cca.scaleTo(0.08333333333333333, 0.9)[1] = cca.scaleTo(0.23333333333333334, 1.4)
	cca.scaleTo(0.08333333333333333, 0.9)[2] = cca.fadeTo(0.23333333333333334, 0.3)
	cca.scaleTo(0.08333333333333333, 0.9)[3] = cca.fadeTo(0.23333333333333334, 0.3)
	cca.scaleTo(0.08333333333333333, 0.9)[4] = cca.fadeTo(0.23333333333333334, 0.3)
	cca.scaleTo(0.08333333333333333, 0.9)[5] = cca.fadeTo(0.23333333333333334, 0.3)
	cca.scaleTo(0.08333333333333333, 0.9)[6] = cca.fadeTo(0.23333333333333334, 0.3)
	cca.scaleTo(0.08333333333333333, 0.9)[7] = cca.fadeTo(0.23333333333333334, 0.3)
	cca.scaleTo(0.08333333333333333, 0.9)[8] = cca.fadeTo(0.23333333333333334, 0.3)
	cca.scaleTo(0.08333333333333333, 0.9)[9] = cca.fadeTo(0.23333333333333334, 0.3)
	cca.scaleTo(0.08333333333333333, 0.9)[10] = cca.fadeTo(0.23333333333333334, 0.3)
	_UPVALUE1_ = cca.scaleTo(0.23333333333333334, 1.4)
	cca.scaleTo(0.23333333333333334, 1.4)[1] = cca.scaleTo(0.25, 2)
	cca.scaleTo(0.23333333333333334, 1.4)[2] = cca.fadeTo(0.25, 0)
	cca.scaleTo(0.23333333333333334, 1.4)[3] = cca.fadeTo(0.25, 0)
	cca.scaleTo(0.23333333333333334, 1.4)[4] = cca.fadeTo(0.25, 0)
	cca.scaleTo(0.23333333333333334, 1.4)[5] = cca.fadeTo(0.25, 0)
	cca.scaleTo(0.23333333333333334, 1.4)[6] = cca.fadeTo(0.25, 0)
	cca.scaleTo(0.23333333333333334, 1.4)[7] = cca.fadeTo(0.25, 0)
	cca.scaleTo(0.23333333333333334, 1.4)[8] = cca.fadeTo(0.25, 0)
	cca.scaleTo(0.23333333333333334, 1.4)[9] = cca.fadeTo(0.25, 0)
	;(nil)[1] = cca.spawn((cca.spawn((cca.scaleTo(0.08333333333333333, 1.55)))))
	;(nil)[2] = cca.spawn((cca.scaleTo(0.16666666666666666, 0.7)))
	;(nil)[3] = cca.spawn((cca.scaleTo(0.08333333333333333, 0.9)))
	;(nil)[4] = cca.spawn((cca.scaleTo(0.23333333333333334, 1.4)))
	;(nil)[5] = cca.delay(0.35)
	;(nil)[6] = cca.delay(0.35)
	;(nil)[7] = cca.delay(0.35)
	;(nil)[8] = cca.delay(0.35)
	;(nil)[9] = cca.delay(0.35)
	;(nil)[10] = cca.delay(0.35)
	;(nil)[11] = cca.delay(0.35)
	;(nil)[12] = cca.delay(0.35)
	;(nil)[13] = cca.delay(0.35)
	;(nil)[14] = cca.delay(0.35)
	_ENV, (nil)[7], (nil).seq = nil, nil, cca.seq(nil)
	;(nil).plist = "et_xsyd_01.plist"
	_ENV, (nil)[8], (nil).scale = nil, nil, 3.3
	;(nil).png = "dh_xsyd_06.png"
	;(nil).scale = 3.7
	_UPVALUE8_ = nil
	_UPVALUE1_ = 4
	;(4)[1] = cca.scaleTo(0.16666666666666666, 4.25)
	;(4)[2] = cca.fadeTo(0.16666666666666666, 0.5)
	;(4)[3] = cca.fadeTo(0.16666666666666666, 0.5)
	;(4)[4] = cca.fadeTo(0.16666666666666666, 0.5)
	;(4)[5] = cca.fadeTo(0.16666666666666666, 0.5)
	;(4)[6] = cca.fadeTo(0.16666666666666666, 0.5)
	;(4)[7] = cca.fadeTo(0.16666666666666666, 0.5)
	;(4)[8] = cca.fadeTo(0.16666666666666666, 0.5)
	;(4)[9] = cca.fadeTo(0.16666666666666666, 0.5)
	;(4)[10] = cca.fadeTo(0.16666666666666666, 0.5)
	;(4)[11] = cca.fadeTo(0.16666666666666666, 0.5)
	_UPVALUE1_ = cca.scaleTo(0.16666666666666666, 4.25)
	cca.scaleTo(0.16666666666666666, 4.25)[1] = cca.scaleTo(0.16666666666666666, 4.5)
	cca.scaleTo(0.16666666666666666, 4.25)[2] = cca.fadeTo(0.16666666666666666, 0)
	cca.scaleTo(0.16666666666666666, 4.25)[3] = cca.fadeTo(0.16666666666666666, 0)
	cca.scaleTo(0.16666666666666666, 4.25)[4] = cca.fadeTo(0.16666666666666666, 0)
	cca.scaleTo(0.16666666666666666, 4.25)[5] = cca.fadeTo(0.16666666666666666, 0)
	cca.scaleTo(0.16666666666666666, 4.25)[6] = cca.fadeTo(0.16666666666666666, 0)
	cca.scaleTo(0.16666666666666666, 4.25)[7] = cca.fadeTo(0.16666666666666666, 0)
	cca.scaleTo(0.16666666666666666, 4.25)[8] = cca.fadeTo(0.16666666666666666, 0)
	cca.scaleTo(0.16666666666666666, 4.25)[9] = cca.fadeTo(0.16666666666666666, 0)
	cca.scaleTo(0.16666666666666666, 4.25)[10] = cca.fadeTo(0.16666666666666666, 0)
	_UPVALUE1_ = 1.1667
	;(1.1667)[1] = cca.scaleTo(0.03333333333333333, 1.5)
	;(1.1667)[2] = cca.fadeTo(0.03333333333333333, 0.6)
	;(1.1667)[3] = cca.fadeTo(0.03333333333333333, 0.6)
	;(1.1667)[4] = cca.fadeTo(0.03333333333333333, 0.6)
	;(1.1667)[5] = cca.fadeTo(0.03333333333333333, 0.6)
	_UPVALUE1_ = cca.scaleTo(0.03333333333333333, 1.5)
	cca.scaleTo(0.03333333333333333, 1.5)[1] = cca.scaleTo(0.08333333333333333, 3.7)
	cca.scaleTo(0.03333333333333333, 1.5)[2] = cca.fadeTo(0.08333333333333333, 1)
	cca.scaleTo(0.03333333333333333, 1.5)[3] = cca.fadeTo(0.08333333333333333, 1)
	cca.scaleTo(0.03333333333333333, 1.5)[4] = cca.fadeTo(0.08333333333333333, 1)
	;(nil)[1] = cca.scaleTo(0.08333333333333333, 4)
	;(nil)[2] = cca.spawn(4)
	;(nil)[3] = cca.spawn((cca.scaleTo(0.16666666666666666, 4.25)))
	;(nil)[4] = cca.scaleTo(0.36666666666666664, 0.2)
	;(nil)[5] = cca.scaleTo(0.13333333333333333, 0.84)
	;(nil)[6] = cca.scaleTo(0.03333333333333333, 1)
	;(nil)[7] = cca.scaleTo(0.016666666666666666, 1.1667)
	;(nil)[8] = cca.spawn(1.1667)
	;(nil)[9] = cca.spawn((cca.scaleTo(0.03333333333333333, 1.5)))
	;(nil)[10] = cca.spawn((cca.scaleTo(0.03333333333333333, 1.5)))
	;(nil)[11] = cca.spawn((cca.scaleTo(0.03333333333333333, 1.5)))
	;(nil)[12] = cca.spawn((cca.scaleTo(0.03333333333333333, 1.5)))
	;(nil)[13] = cca.spawn((cca.scaleTo(0.03333333333333333, 1.5)))
	;(nil)[14] = cca.spawn((cca.scaleTo(0.03333333333333333, 1.5)))
	;(nil)[9], (nil).seq = nil, cca.seq(nil)
	local actionConfig
	local roundNode = display.newNode()
	roundNode:setPosition(targetRect.width / 2, targetRect.height / 2)
	roundNode:addTo(effectNode, 1)
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
		elseif v.plist then
			table.insert(param, v)
			local et_node = SoraDCreateEffectNode(param)
			et_node:addTo(roundNode, k)
		end
	end
	roundNode:setScale(0.5)
end
function mildGuideManager:showFinger(stepData)
	local effectNode = self:getEffectNode()
	local targetRect = self:getTouchRect()
	local isHideFinger = stepData.isHideFinger or false
	dump(stepData, "======显示手指mildGuideManager===========")
	dump(targetRect, "targetRect")
	if effectNode and not effectNode:getChildByName("finger") then
		local finger = SoraDFingerAction(nil, nil, nil, isHideFinger)
		finger:setName("finger")
		local posX = 0.5 * targetRect.width
		local posY = 0.5 * targetRect.height
		local offsetX = stepData and stepData.offset and stepData.offset.x and stepData.offset.x or 0
		local offsetY = stepData and stepData.offset and stepData.offset.y and stepData.offset.y or 0
		local scaleX = stepData and stepData.scaleX and stepData.scaleX or 1
		local scaleY = stepData and stepData.scaleY and stepData.scaleY or 1
		finger:setScaleX(scaleX)
		finger:setScaleY(scaleY)
		if stepData.className == "mainUI" and stepData.itemName == "topHeadFrame" then
			finger:setRotation(90)
			finger:setPosition(cc.p(posX, posY))
		else
			finger:setRotation(0)
			finger:setPosition(cc.p(posX + offsetX, posY + offsetY))
		end
		finger:addTo(effectNode, 2)
	end
end
function mildGuideManager:showUpgradeEffect()
	local effectNode = self:getEffectNode()
	local et_guide_effect = display.newNode()
	et_guide_effect:addTo(effectNode, 2)
	et_guide_effect:setPosition(cc.p(-6, -6))
	local sprite = display.newSprite("#dh_pyramid_active_01.png")
	sprite:addTo(et_guide_effect, 2)
	sprite:runAction(cc.RepeatForever:create(cca.rotateBy(3, 360)))
	_ENV, _ENV = sprite, sprite.runAction
	sprite.runAction[1], sprite.plist = sprite, "et_xwjyd_01.plist"
	local param1 = sprite.runAction
	local et_node1 = SoraDCreateEffectNode(param1)
	et_node1:addTo(et_guide_effect, 1)
	_ENV, _ENV = et_node1, et_node1.addTo
	et_node1.addTo[1], et_node1.plist = et_node1, "et_xwjyd_02.plist"
	local param2 = et_node1.addTo
	local et_node1 = SoraDCreateEffectNode(param2)
	et_node1:addTo(et_guide_effect, 3)
end
function mildGuideManager:deleteRunEffect(target)
	if target then
		local effect = target:getChildByName("mildEffect")
		if effect then
			effect:removeFromParent()
		end
		target.mildGuideCallBack = nil
	else
		if self.mildParent and not tolua.isnull(self.mildParent) and self.mildParent.mildGuideCallBack then
			local effect = self:getEffectNode()
			if effect then
				effect:removeFromParent()
			end
			self.mildParent.mildGuideCallBack = nil
		end
		self.mildParent = nil
	end
end
function mildGuideManager:setVariate(className, key, value)
	if self.mildVariate[className] == nil then
		self.mildVariate[className], _ENV = nil, nil
	end
	if type(key) == "table" then
		for k, v in pairs(key) do
			if k ~= "className" then
				self.mildVariate[className][k] = v
			end
		end
	else
		self.mildVariate[className][key] = value
	end
end
function mildGuideManager:getVariate(className, key)
	local ret
	if self.mildVariate[className] then
		if key and self.mildVariate[className][key] ~= nil then
			ret = self.mildVariate[className][key]
			self.mildVariate[className][key] = nil
		else
			ret = clone(self.mildVariate[className])
			self.mildVariate[className] = nil
		end
	end
	return ret
end
function mildGuideManager:clean()
	self:deleteRunEffect()
	self.mildVariate, _UPVALUE0_, self.pileLine, _UPVALUE0_ = self.deleteRunEffect, self.deleteRunEffect, self.deleteRunEffect, self.deleteRunEffect
	self.mildParent = nil
end
function mildGuideManager:starMildByEverydayTaskID(tid, data)
	if self.mildEverydayTaskFun and self.mildEverydayTaskFun[tid] then
		return self.mildEverydayTaskFun[tid](data)
	end
end
function mildGuideManager:starMildByNewPlayerQuestID(qid, data)
	if self.mildNewPlayerFun[qid] then
		if qid == gNewPLayerTaskType.POWRE then
			data.bid = 0
			data.lv = 1
		end
		if qid == gNewPLayerTaskType.TRAIN_SOLDIERS then
			data.bid = data.bid or BUILDID.CHARIOT_PLANT
			data.lv = data.lv or 1
		end
		if qid == gNewPLayerTaskType.BUILD_UPGRADE then
			data.lv = data.lv or 1
		end
		return self.mildNewPlayerFun[qid](data)
	end
end
function mildGuideManager:starMildByNewPlayerStringParam(strGuideParam)
	local tbParam = self:splitGuideParam(strGuideParam)
	return self:starMildByNewPlayerQuestID(tbParam.id, tbParam)
end
function mildGuideManager:initNewPlayerQuest()
	_ENV = nil
	;(nil)[gNewPLayerTaskType.BUILD_UPGRADE] = handler(self, self.starToUpgrade)
	;(nil)[gNewPLayerTaskType.TRAIN_SOLDIERS] = handler(self, self.starToTrainArmy)
	;(nil)[gNewPLayerTaskType.COLLECT_RESOURCE] = handler(self, self.starToCollect)
	;(nil)[gNewPLayerTaskType.COLLECT_RESOURCE_START] = handler(self, self.starToCollect)
	;(nil)[gNewPLayerTaskType.RESEARCH_TECHNOLOGY] = handler(self, self.starToStudyTechnology)
	;(nil)[gNewPLayerTaskType.KILL_MONSTER] = handler(self, self.starToKillMonster)
	;(nil)[gNewPLayerTaskType.TIME_REWARD] = handler(self, self.starToWharf)
	;(nil)[gNewPLayerTaskType.LORD_SKILL] = handler(self, self.starToStudySkill)
	;(nil)[gNewPLayerTaskType.EVERYDAY_REWARD] = handler(self, self.starToEveryDayReward)
	;(nil)[gNewPLayerTaskType.ACTIVITY_VIP] = handler(self, self.starToActivateVip)
	;(nil)[gNewPLayerTaskType.UNLOCK_PET] = handler(self, self.starToUnlockPet)
	;(nil)[gNewPLayerTaskType.UNLOCK_AREA] = handler(self, self.starToUnlockPlot)
	;(nil)[gNewPLayerTaskType.OPEN_BUILD_QUEUE] = handler(self, self.starToOpenBuilder)
	;(nil)[gNewPLayerTaskType.JOIN_ALLIANCE] = handler(self, self.starToJoinAllinace)
	;(nil)[gNewPLayerTaskType.HELP_PLAYER] = handler(self, self.starToHelpAlly)
	;(nil)[gNewPLayerTaskType.MAKE_A_WISH] = handler(self, self.starToWish)
	;(nil)[gNewPLayerTaskType.MYSTICAL_STORE] = handler(self, self.starToMysticalStore)
	;(nil)[gNewPLayerTaskType.ALLIANCE_DONATE] = handler(self, self.starToAllianceDonate)
	;(nil)[gNewPLayerTaskType.PYRAMID] = handler(self, self.starToPyramid)
	;(nil)[gNewPLayerTaskType.STUFFWORKSHOP] = handler(self, self.starToFactory)
	;(nil)[gNewPLayerTaskType.EQUIP] = handler(self, self.starToEquip)
	;(nil)[gNewPLayerTaskType.ESCORT] = handler(self, self.starToEscout)
	;(nil)[gNewPLayerTaskType.POWRE] = handler(self, self.starToTrainArmy)
	;(nil)[gNewPLayerTaskType.ALLIANCE_DONATE_POINT] = handler(self, self.starToAllianceDonate)
	;(nil)[gNewPLayerTaskType.HERO_TRIAL] = handler(self, self.starToArmyTrial)
	;(nil)[gNewPLayerTaskType.WAR_TECHNOLOGY] = handler(self, self.starToStudyWarTechnology)
	;(nil)[gNewPLayerTaskType.DRILL_ARENA] = handler(self, self.starToArena)
	;(nil)[gNewPLayerTaskType.QUICK_TO_WORLD] = handler(self, self.starToQuickToWorld)
	;(nil)[gNewPLayerTaskType.RECHARGE_GOLD] = handler(self, self.starToRechargeGold)
	;(nil)[gNewPLayerTaskType.ALLIANCE_HELP] = handler(self, self.starToAllianceHelp)
	;(nil)[gNewPLayerTaskType.COMMON_ACTIVITY_CENTER] = handler(self, self.starToActivity)
	;(nil)[gNewPLayerTaskType.BAG_SHOP_CENTER] = handler(self, self.starToBagShopCenter)
	;(nil)[gNewPLayerTaskType.ALLIANCE_STORE_HOUSE] = handler(self, self.starToAllianceStoreHouse)
	;(nil)[gNewPLayerTaskType.ARENA] = handler(self, self.starToArena)
	;(nil)[gNewPLayerTaskType.BUILD_CAN_UPGRADE] = handler(self, self.starToCanUpgrade)
	;(nil)[gNewPLayerTaskType.ESCORT_WORLD] = handler(self, self.starToEscortWorld)
	;(nil)[gNewPLayerTaskType.EPIC_WAR] = handler(self, self.starToEpicWar)
	;(nil)[gNewPLayerTaskType.HERO_TRAIN] = handler(self, self.starToHeroTrain)
	;(nil)[gNewPLayerTaskType.TROOP_FLAG] = handler(self, self.starToTroopFlag)
	;(nil)[gNewPLayerTaskType.MASTERY_DRAW] = handler(self, self.starToMasteryDraw)
	;(nil)[gNewPLayerTaskType.BUILD_MASTERY] = handler(self, self.starToBuildMastery)
	;(nil)[gNewPLayerTaskType.HARVEST_FARM] = handler(self, self.starToHarvestFarm)
	;(nil)[gNewPLayerTaskType.EPIC_WAR_VERIFY] = handler(self, self.haveVerifyToSkipEpicWar)
	;(nil)[gNewPLayerTaskType.EVIL_PALACE] = handler(self, self.starToEvilPalace)
	;(nil)[gNewPLayerTaskType.ALLIANCE_HUNT] = handler(self, self.starToAllianceHunt)
	;(nil)[gNewPLayerTaskType.TREAT] = handler(self, self.starToHospital)
	;(nil)[gNewPLayerTaskType.RESURGENCE] = handler(self, self.starResurgence)
	;(nil)[gNewPLayerTaskType.OPEN_CHAT] = handler(self, self.starToOpenChat)
	;(nil)[gNewPLayerTaskType.POP_TIP] = handler(self, self.starToPopTip)
	;(nil)[gNewPLayerTaskType.HARVEST_RESOURCE] = handler(self, self.startToHarvestResource)
	;(nil)[gNewPLayerTaskType.ANNALS] = handler(self, self.starToAnnals)
	;(nil)[gNewPLayerTaskType.ACHIEVE_SYSTEM] = handler(self, self.starToAchieveSystem)
	;(nil)[gNewPLayerTaskType.PREMIUM_VIP_MALL] = handler(self, self.starToPreminumVipMall)
	;(nil)[gNewPLayerTaskType.DRESS_SHOP] = handler(self, self.starToDressShop)
	;(nil)[gNewPLayerTaskType.HERO_PRISON] = handler(self, self.starToHeroPrison)
	;(nil)[gNewPLayerTaskType.QUENCHING] = handler(self, self.starToEquip)
	;(nil)[gNewPLayerTaskType.UNLOCK_HERO] = handler(self, self.starToHeroUnlockOneStep)
	;(nil)[gNewPLayerTaskType.UPGRADE_HERO] = handler(self, self.starToHeroUnlockOneStep)
	;(nil)[gNewPLayerTaskType.FEED_HERO] = handler(self, self.starToHeroUnlockOneStep)
	;(nil)[gNewPLayerTaskType.EQUIP_RESET] = handler(self, self.starToEquip)
	;(nil)[gNewPLayerTaskType.ADD_FRIENDS] = handler(self, self.starToAddFriends)
	;(nil)[gNewPLayerTaskType.BUILDSTAR_UPGRADE] = handler(self, self.starToUpgradeStar)
	;(nil)[gNewPLayerTaskType.RADIANCE_TREAT] = handler(self, self.starToRadianceTreat)
	;(nil)[gNewPLayerTaskType.RADIANCE_RES] = handler(self, self.starToRadianceBuilding)
	;(nil)[gNewPLayerTaskType.RADIANCE_BUILDINGS] = handler(self, self.starToRadianceBuilding)
	;(nil)[gNewPLayerTaskType.COMPLETE_ACHIEVEMENT] = handler(self, self.starToAchieventment)
	;(nil)[gNewPLayerTaskType.UNLOCK_QUENCHING] = handler(self, self.starToUnlockQuenching)
	;(nil)[gNewPLayerTaskType.ENDLESS_TREASURE] = handler(self, self.starToEndlessTreasure)
	;(nil)[gNewPLayerTaskType.QUICK_TO_WORLD_GUIDE_MONSTER] = handler(self, self.starToQuickToWorldKillMonster)
	;(nil)[gNewPLayerTaskType.QUICK_TO_WORLD_GUIDE_RESOURCE] = handler(self, self.starToQuickToWorldCollectResource)
	;(nil)[gNewPLayerTaskType.QUICK_TO_WORLD_GUIDE_LOSTRUINS] = handler(self, self.starToQuickToWorldCollectLostRuins)
	;(nil)[gNewPLayerTaskType.QUICK_TO_WORLD_GUIDE_WINDTOWER] = handler(self, self.starToQuickToWorldCollectWindTower)
	;(nil)[gNewPLayerTaskType.QUICK_TO_WORLD_GUIDE_SNOWWOLFLOST] = handler(self, self.starToQuickToWorldSnowWolfLost)
	;(nil)[gNewPLayerTaskType.QUICK_TO_WORLD_GUIDE_ICEDRAGONLOST] = handler(self, self.starToQuickToWorldIcedragonLost)
	;(nil)[gNewPLayerTaskType.QUICK_TO_WORLD_GUIDE_LEGENDOFPEGASUS] = handler(self, self.starToQuickToWorldLegendOfPegasus)
	;(nil)[gNewPLayerTaskType.WEAR_EQUIPMENT] = handler(self, self.starToWearEquipment)
	;(nil)[gNewPLayerTaskType.LUCKY_CARD] = handler(self, self.starToDaylySign)
	;(nil)[gNewPLayerTaskType.DIG_ENDLESS_TREASURE] = handler(self, self.starToEndlessTreasure)
	;(nil)[gNewPLayerTaskType.LEVELUP_RESOURCE_ANY] = handler(self, self.starToUpgradeResource)
	;(nil)[gNewPLayerTaskType.BUILD_ALLIANCE_BUILDING] = handler(self, self.starToBuildAllianceBuilding)
	;(nil)[gNewPLayerTaskType.TO_BUILD_CASTLE_LV2] = handler(self, self.starTobuildCastleLv2)
	;(nil)[gNewPLayerTaskType.TO_GET_CASTLE_LV2] = handler(self, self.starToGetCastleLv2)
	;(nil)[gNewPLayerTaskType.TO_BUILD_MILITARY_TENT] = handler(self, self.starToBuildMilitaryTent)
	;(nil)[gNewPLayerTaskType.TO_BUILD_EXCHANGE_LORDMILITARY] = handler(self, self.starToExchangeLordmilitary)
	;(nil)[gNewPLayerTaskType.TO_BUILD_STATUE_BRAVE] = handler(self, self.starToStatueBrave)
	;(nil)[gNewPLayerTaskType.TO_GOD_ARMS] = handler(self, self.starToGodArms)
	;(nil)[gNewPLayerTaskType.TO_WAR_GEM] = handler(self, self.starToWarGem)
	;(nil)[gNewPLayerTaskType.TO_FOREIGN_PAVILION] = handler(self, self.starToForeignPavilion)
	;(nil)[gNewPLayerTaskType.FINISH_SOLDIER_RUSH] = handler(self, self.starToSoldierRunsh)
	;(nil)[gNewPLayerTaskType.FINISH_COMMAND_HALL_TASK] = handler(self, self.starToCommandHall)
	;(nil)[gNewPLayerTaskType.COMMAND_HALL_ATTACK_CITY] = handler(self, self.starToCommandHall)
	;(nil)[gNewPLayerTaskType.COMMAND_HALL_COMMAND_LV] = handler(self, self.starToCommandHall)
	;(nil)[gNewPLayerTaskType.JOIN_ALLIANCE_BUILDING_BUILD] = handler(self, self.starToAllianceBuildingBuild)
	;(nil)[gNewPLayerTaskType.TO_RECHARGE_MONTH_WEEK] = handler(self, self.starToRechargeMonthWeek)
	;(nil)[gNewPLayerTaskType.TO_FLOWER_VIEW] = handler(self, self.starToSendFlower)
	;(nil)[gNewPLayerTaskType.TO_SUPER_VIP] = handler(self, self.starToSuperVip)
	;(nil)[gNewPLayerTaskType.TO_NEBULA_TECH] = handler(self, self.starToNebulaTech)
	;(nil)[gNewPLayerTaskType.TO_METEORITEMAGIC] = handler(self, self.starToMeteoriteMagic)
	;(nil)[gNewPLayerTaskType.QUICK_TO_WORLD_GUIDE_STRONGHOLD] = handler(self, self.starToQuickToWorldStronghold)
	;(nil)[gNewPLayerTaskType.TO_DIVINEBEAST] = handler(self, self.starToDivineBeast)
	;(nil)[gNewPLayerTaskType.TO_9001547] = handler(self, self.starTo9001547)
	;(nil)[gNewPLayerTaskType.TO_BADGEEXCHANGE] = handler(self, self.starToBadgeexChange)
	self.mildNewPlayerFun, (nil)[gNewPLayerTaskType.QUICK_TO_WORLD_KILL_MONSTER] = nil, handler(self, self.quickToWorldKillMonster)
end
function mildGuideManager:initEverydayTask()
	_ENV = nil
	;(nil)[gEverydayTaskType.COLLECT_FOOD] = handler(self, self.starToWorldAndCollectRes)
	;(nil)[gEverydayTaskType.COLLECT_WOOD] = handler(self, self.starToWorldAndCollectRes)
	;(nil)[gEverydayTaskType.COLLECT_IRON] = handler(self, self.starToWorldAndCollectRes)
	;(nil)[gEverydayTaskType.COLLECT_MITHRIL] = handler(self, self.starToWorldAndCollectRes)
	;(nil)[gEverydayTaskType.ATTACK_MONSTER] = handler(self, self.starToWorldAndKillMonster)
	;(nil)[gEverydayTaskType.UPGRADE_BUILD] = handler(self, self.starToCanUpgrade)
	;(nil)[gEverydayTaskType.RESEARCH_TECHNOLOGY] = handler(self, self.starToStudyTechnology)
	;(nil)[gEverydayTaskType.GIVE_FLOWER] = handler(self, self.starToSendFlower)
	;(nil)[gEverydayTaskType.FORGING_EQUIP] = handler(self, self.starToEquip)
	;(nil)[gEverydayTaskType.MERGE_MATERIAL] = handler(self, self.starToEquip)
	;(nil)[gEverydayTaskType.CURE_SOLDIER] = handler(self, self.starToHospital)
	;(nil)[gEverydayTaskType.TRAIN_ARMY_INFANTRY] = handler(self, self.starToTrainArmy)
	;(nil)[gEverydayTaskType.TRAIN_ARMY_ARCHER] = handler(self, self.starToTrainArmy)
	;(nil)[gEverydayTaskType.TRAIN_ARMY_CAVALRY] = handler(self, self.starToTrainArmy)
	;(nil)[gEverydayTaskType.TRAIN_ARMY_CHARISTS] = handler(self, self.starToTrainArmy)
	;(nil)[gEverydayTaskType.BUILD_TRAP] = handler(self, self.starToTrainArmy)
	;(nil)[gEverydayTaskType.LOGIN_REWARD] = handler(self, self.starToDaylySign)
	;(nil)[gEverydayTaskType.ALLIANCE_HELP] = handler(self, self.starToHelpAlly)
	;(nil)[gEverydayTaskType.ARMY_HELP] = handler(self, self.starToAidAlly)
	;(nil)[gEverydayTaskType.RESOURCE_HELP] = handler(self, self.starToResAidAlly)
	;(nil)[gEverydayTaskType.ALLIANCE_DONATE] = handler(self, self.starToAllianceDonate)
	;(nil)[gEverydayTaskType.TIME_REWARD] = handler(self, self.starToWharf)
	;(nil)[gEverydayTaskType.WISH_RESOURCE] = handler(self, self.starToWish)
	;(nil)[gEverydayTaskType.DISCOUNT_STORE] = handler(self, self.starToMysticalStore)
	;(nil)[gEverydayTaskType.HERO_TRIAL] = handler(self, self.starToArmyTrial)
	;(nil)[gEverydayTaskType.PYRAMID] = handler(self, self.starToPyramid)
	;(nil)[gEverydayTaskType.BADGEEXCHANGE] = handler(self, self.starToBadgeexChange)
	;(nil)[gEverydayTaskType.FEED_PET] = handler(self, self.starToUnlockPet)
	;(nil)[gEverydayTaskType.COST_GOLD] = handler(self, self.starToBagShopCenter)
	;(nil)[gEverydayTaskType.CHALLENGE_ARENA] = handler(self, self.starToArena)
	;(nil)[gEverydayTaskType.EPIC_WAR] = handler(self, self.starToEpicWar)
	;(nil)[gEverydayTaskType.UPGRADESTAR_BUILD] = handler(self, self.starToCanUpgradeStar)
	self.mildEverydayTaskFun, (nil)[gEverydayTaskType.COMMAND_HALL_TASK] = nil, handler(self, self.starToCommandHall)
end
function mildGuideManager:createPileLine(type, data, ret)
	local MildGuideConfig, ret = nil, ret or nil
	if type == MildGuideConfig.PileModel.BuildMove then
		ret = self:buildMove(data, ret)
	elseif type == MildGuideConfig.PileModel.BuildTip then
		ret = self:buildTip(data, ret)
	elseif type == MildGuideConfig.PileModel.IndexMove then
		ret = self:indexMove(data, ret)
	elseif type == MildGuideConfig.PileModel.PanelShow then
		ret = self:panelShow(data, ret)
	elseif type == MildGuideConfig.PileModel.CollectInstance then
		ret = self:getCollectInstance(data, ret)
	elseif type == MildGuideConfig.PileModel.CameraMove then
		ret = self:cameraMove(data, ret)
	end
	return ret
end
function mildGuideManager:getCollectInstance(data, ret)
	local MildGuideConfig, stepRet
	MildGuideConfig, stepRet.type = MildGuideConfig.PileModel.CollectInstance, MildGuideConfig.PileModel.CollectInstance
	MildGuideConfig.PileModel.CollectInstance.name = "worldMapView"
	MildGuideConfig.PileModel.CollectInstance.delay = 1
	MildGuideConfig.PileModel.CollectInstance.key = "closestResourceFood"
	stepRet.action, MildGuideConfig.PileModel.CollectInstance.again = MildGuideConfig.PileModel.CollectInstance, 5
	stepRet.itemName = "closestResourceFood"
	stepRet.className = "worldMapView"
	stepRet.again = 3
	stepRet.delayTime = 1
	table.insert(ret, stepRet)
	return ret
end
function mildGuideManager:panelShow(data, ret)
	local _ENV, stepRet
	stepRet = clone(data)
	stepRet.type = MildGuideConfig.PileModel.PanelShow
	table.insert(ret, stepRet)
	return ret
end
function mildGuideManager:indexMove(data, ret)
	local _ENV, stepRet
	local mainCityFunctions = include("mainCityFunctions")
	stepRet.type = MildGuideConfig.PileModel.IndexMove
	stepRet.className = "mainCityView"
	_ENV, stepRet.index = data.index or mainCityFunctions.getMainCityCanBuildIndex(data.bid), data.index or mainCityFunctions.getMainCityCanBuildIndex(data.bid)
	;(data.index or mainCityFunctions.getMainCityCanBuildIndex(data.bid)).name = "mainCityView"
	;(data.index or mainCityFunctions.getMainCityCanBuildIndex(data.bid)).delay = 0.5
	;(data.index or mainCityFunctions.getMainCityCanBuildIndex(data.bid)).index = stepRet.index
	stepRet.action, (data.index or mainCityFunctions.getMainCityCanBuildIndex(data.bid)).isSelected = data.index or mainCityFunctions.getMainCityCanBuildIndex(data.bid), data.isSelected
	if data.isSelected ~= true then
		stepRet.itemName = "index"
		stepRet.className = "mainCityView"
		stepRet.z = data.z
	end
	table.insert(ret, stepRet)
	return ret
end
function mildGuideManager:buildMove(data, ret)
	local _ENV, stepRet
	local mainCityFunctions = include("mainCityFunctions")
	if not self:needVerify(data) then
		_ENV = data
		data.index = mainCityFunctions.getMainCityCanBuildIndex(data.bid)
		ret = self:indexMove(data, ret)
	else
		stepRet.type = MildGuideConfig.PileModel.BuildMove
		stepRet.bid = data.bid
		_ENV, stepRet.className = data.bid, "mainCityView"
		data.bid.name = "mainCityView"
		data.bid.delay = 0.5
		data.bid.iid = data.iid
		data.bid.bid = data.bid
		stepRet.action, data.bid.isSelected = data.bid, data.isSelected
		stepRet.again = data.again
		stepRet.delayTime = data.delayTime
		if data.isSelected ~= true then
			stepRet.itemName = "build"
			stepRet.className = "mainCityView"
		end
		table.insert(ret, stepRet)
	end
	return ret
end
function mildGuideManager:cameraMove(data, ret)
	local _ENV, stepRet
	local mainCityFunctions = include("mainCityFunctions")
	stepRet.type = MildGuideConfig.PileModel.CameraMove
	_ENV, stepRet.className = MildGuideConfig.PileModel.CameraMove, "mainCityView"
	MildGuideConfig.PileModel.CameraMove.name = "mainCityView"
	MildGuideConfig.PileModel.CameraMove.delay = 0.5
	stepRet.action, MildGuideConfig.PileModel.CameraMove.move = MildGuideConfig.PileModel.CameraMove, mainCityFunctions:getTargetPosByIndex(data.index)
	stepRet.again = data.again
	stepRet.delayTime = data.delayTime
	table.insert(ret, stepRet)
	return ret
end
function mildGuideManager:buildTip(data, ret)
	local MildGuideConfig, stepRet
	local isMild = true
	if data.data.isMild ~= nil then
		isMild = data.data.isMild
	end
	MildGuideConfig = nil
	;(nil).bid = data.data.bid
	;(nil).queuePriority = data.data.queuePriority
	;(nil).isMild = isMild
	self:setVariate("buildTipPanel", nil)
	stepRet.type = MildGuideConfig.PileModel.BuildTip
	stepRet.key = data.data.key
	stepRet.className = "mainCityView"
	stepRet.itemName = "tip"
	stepRet.z = data.z
	stepRet.selTabIndex = data.data.selTabIndex
	table.insert(ret, stepRet)
	return ret
end
function mildGuideManager:needVerify(data)
	local gametop = gModuleMgr.getObject("gametop")
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local queueCtrl = gametop.playertop_:getModule("queueCtrl")
	local guideCtrl = gametop.playertop_:getModule("guideCtrl")
	local ret = false
	if data.bid then
		_ENV = data.bid
		data.bid[BUILDID.LESURE_CENTER] = true
		data.bid[BUILDID.MAGIC_LAMP] = true
		local data.bid[BUILDID.NEWBORN_TREE], config = true, data.bid
		if config[data.bid] then
			return true
		end
		ret = #cityCtrl:getBuildCellList(data.bid) > 0
		if not ret then
			print("建筑不存在")
		end
	elseif data.needCity then
		if SoraDCurrentSceneShowView("mainCityView") == nil then
			_ENV = data.bid
			data.bid.className = "mainCityView"
			_ENV, data.bid.itemName = nil, nil
			;(nil).name = "mainCityView"
			data.bid.action, (nil).jump = nil, true
			self:insertPileLine(MildGuideConfig.PileModel.PanelShow, data.bid)
		end
	elseif data.needHand and include("newPlayerTaskRead").isChapterRealOpen() then
		_ENV = data.bid
		data.bid.className = "mainCityView"
		_ENV, data.bid.itemName = nil, nil
		;(nil).name = "mainCityView"
		data.bid.action, (nil).hand = nil, true
		self:insertPileLine(MildGuideConfig.PileModel.PanelShow, data.bid)
	end
	return ret
end
function mildGuideManager:starToRadianceTreat()
	print("starToRadianceTreat")
	local radianceWarUtil = include("radianceWarUtil")
	local isInCure = radianceWarUtil.isWarHospitalCureing()
	if isInCure then
		local backpackCtrl = SoraDGetCtrl("backpackCtrl")
		local speedUpItemList = backpackCtrl:getSpeedUpItemList(gAbbrSpeedUpType.CURE_WAR)
		if 0 < #speedUpItemList then
			SoraDShowSpeedUpByItemBox(gQueueTypeDef.radiance_war_hostpital_queue)
		else
			SoraDShowSpeedUpByItemBox(gQueueTypeDef.radiance_war_hostpital_queue)
			SoraDShowMsgTip(i18n("brightWar_text_48"))
		end
	else
		uiManager:show("HospitalView"):setLV(nil, gKingdomClassType.radiance)
	end
	return true, true
end
function mildGuideManager:starToRadianceBuilding(data)
	dump(data, "starToRadianceBuilding", 10)
	local _ENV, realData = dump, dump
	if data.id == gNewPLayerTaskType.RADIANCE_RES then
		realData.subMapID = data.bid or math.random(5)
		realData.mapID = gWorldTypeServerDef.mapTypeRadianceWarResource
		realData.minLv = data.minLv
	else
		realData.mapID = data.bid
	end
	_ENV = 10
	;(10).callFunc = "gameGuide_callFunc_JumpToBuilding"
	;(10).data = realData
	self:starToQuickToWorld(10)
end
function mildGuideManager:starToAchieventment(data)
	print("打开成就界面===========")
	_ENV = nil
	;(nil).isToAchi = true
	;(nil).jumpID = 9003015
	uiManager:show("honourWallView", nil)
	return true, true
end
function mildGuideManager:starToBuild(data, notStar)
	if notStar ~= true then
		self:clean()
		_ENV = nil
		;(nil).needCity = true
		self:needVerify(nil)
	end
	local mainCityFunctions = include("mainCityFunctions")
	local index = mainCityFunctions.getMainCityCanBuildIndex(data.bid)
	if 0 < index then
		_ENV = nil
		;(nil).bid = data.bid
		;(nil).z = 1
		self:insertPileLine(MildGuideConfig.PileModel.IndexMove, nil)
		_ENV = nil
		;(nil).bid = data.bid
		self:setVariate("BuildCreatePanel", nil)
	else
		local ret, index, lv = self:checkUnlockArea()
		if ret and index then
			SoraDShowMsgTip(i18n("common_text_4702"))
			_ENV = i18n("common_text_4702")
			i18n("common_text_4702").index = index
			self:insertPileLine(MildGuideConfig.PileModel.IndexMove, i18n("common_text_4702"))
		elseif index then
			_ENV = i18n("common_text_4702")
			i18n("common_text_4702").lv = lv
			SoraDShowMsgTip(i18n("common_text_4703", i18n("common_text_4702")))
			_ENV = i18n("common_text_4703", i18n("common_text_4702"))
			i18n("common_text_4703", i18n("common_text_4702")).index = index
			self:insertPileLine(MildGuideConfig.PileModel.CameraMove, i18n("common_text_4703", i18n("common_text_4702")))
		else
			SoraDShowMsgTip(i18n("common_text_4704"))
			_ENV = i18n("common_text_4704")
			i18n("common_text_4704").index = 1220
			self:insertPileLine(MildGuideConfig.PileModel.CameraMove, i18n("common_text_4704"))
		end
	end
	_ENV = self:checkUnlockArea()
	self:checkUnlockArea().msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TOP_TIP_HAND"
	SoraDSendMessage(self:checkUnlockArea())
	GLOBAL_BUILD_PRE_BID = nil
	if notStar ~= true then
		self:star()
	end
end
function mildGuideManager:checkUnlockArea()
	local ret = false
	local index
	local cityCtrl = SoraDGetCtrl("cityCtrl")
	local cityCell = cityCtrl:getCurCity()
	local openAreaList = cityCell.areaList
	local opengroundinfo = require("app." .. LocalTblPath .. ".config_server.opengroundinfo")
	if table.nums(openAreaList) == table.nums(opengroundinfo) then
		return ret, index
	end
	for _, v in ipairs(opengroundinfo) do
		if not SoraDisInList(v.areaid, openAreaList) then
			ret = SoraDGetCastleLv() >= v.preCond[2]
			index = v.areaid
			lv = v.preCond[2]
			break
		end
	end
	return ret, index, lv
end
function mildGuideManager:starToUpgrade(data)
	self:clean()
	_ENV = nil
	;(nil).needCity = true
	self:needVerify(nil)
	_ENV = nil
	;(nil).bid = data.bid
	if not self:needVerify(nil) or data.lv == 1 and SoraDGetBuildTypeByBid(data.bid) == 1 then
		self:starToBuild(data, true)
	elseif data.lv == 1 then
		_ENV = true
		;(true).bid = data.bid
		;(true).isSelected = true
		self:insertPileLine(MildGuideConfig.PileModel.BuildMove, true)
	end
	if data.lv > 1 then
		local gametop = gModuleMgr.getObject("gametop")
		local cityCtrl = gametop.playertop_:getModule("cityCtrl")
		local iid = 0
		if data.count then
			local buildList = cityCtrl:getBuildCellList(data.bid)
			local tmpIid
			local curLv = 0
			for i, v in ipairs(buildList) do
				local buildLv = tonumber(v.info.lv)
				if buildLv < data.lv then
					if buildLv == data.lv - 1 then
						tmpIid = tonumber(v.info.iid)
						break
					elseif curLv < buildLv then
						curLv = buildLv
						tmpIid = tonumber(v.info.iid)
					end
				end
			end
			if tmpIid == nil then
				self:starToBuild(data, true)
				tmpIid = -1
			end
			iid = tmpIid
		else
			local maxLv, tmpIid = cityCtrl:getBuildMaxLv(data.bid)
			iid = tmpIid
		end
		_ENV = self.starToBuild
		self.starToBuild.bid = data.bid
		self.starToBuild.iid = iid
		self.starToBuild.isSelected = true
		self:insertPileLine(MildGuideConfig.PileModel.BuildMove, self.starToBuild)
		if data.lv > 30 then
			_ENV = self.starToBuild
			self.starToBuild.className = "mainCityView"
			_ENV, self.starToBuild.itemName = data.bid, "tip"
			data.bid.bid = data.bid
			data.bid.key = "OpWar"
			data.bid.queuePriority = true
			self.starToBuild.data, data.bid.delayTime = data.bid, 1
			self:insertPileLine(MildGuideConfig.PileModel.BuildTip, self.starToBuild)
		else
			_ENV = self.starToBuild
			self.starToBuild.className = "mainCityView"
			_ENV, self.starToBuild.itemName = data.bid, "tip"
			data.bid.bid = data.bid
			data.bid.key = "OpUpgrade"
			data.bid.queuePriority = true
			self.starToBuild.data, data.bid.delayTime = data.bid, 1
			self:insertPileLine(MildGuideConfig.PileModel.BuildTip, self.starToBuild)
		end
	end
	self:star()
end
function mildGuideManager:starToUpgradeStar(data)
	local bid = tonumber(data.bid)
	_ENV = nil
	;(nil).bid = bid
	if not self:needVerify(nil) then
		self:starToBuild(data, true)
		return
	end
	self:clean()
	_ENV = data
	data.needCity = true
	self:needVerify(data)
	local iid = tonumber(data.iid)
	if not iid then
		local cityCtrl = SoraDGetCtrl("cityCtrl")
		local __, _iid = cityCtrl:getBuildMaxStarLvEx(bid)
		iid = _iid
	end
	_ENV = bid
	bid.bid = bid
	bid.iid = iid
	bid.isSelected = true
	self:insertPileLine(MildGuideConfig.PileModel.BuildMove, bid)
	_ENV = bid
	bid.className = "mainCityView"
	_ENV, bid.itemName = nil, "tip"
	;(nil).bid = data.bid
	;(nil).key = "OpStarUpgrade"
	bid.data, (nil).queuePriority = nil, true
	self:insertPileLine(MildGuideConfig.PileModel.BuildTip, bid)
	self:star()
end
function mildGuideManager:starToBuildAllianceBuilding()
	self:clean()
	MildGuideConfig = nil
	;(nil).className = "AllianceBuildViewPanel"
	;(nil).itemName = "build"
	;(nil).z = 3
	self:insertPileLine(MildGuideConfig.PileModel.PanelShow, nil)
	self:star()
end
function mildGuideManager:starToChallengeNext(data)
	self:clean()
	MildGuideConfig = nil
	;(nil).className = "SoldierRushChapter"
	;(nil).itemName = "nextGate"
	;(nil).gate = data.gate
	;(nil).waitDelay = 10
	self:insertPileLine(MildGuideConfig.PileModel.PanelShow, nil)
	self:star()
end
function mildGuideManager:starTobuildCastleLv2()
	self:clean()
	local gametop = gModuleMgr.getObject("gametop")
	local newPlayerTaskCtrl = gametop.playertop_:getModule("newPlayerTaskCtrl")
	_ENV = nil
	;(nil).gGuideModule = gGuideModule.TO_BUILD_CASTLE_LV2
	self:setVariate("newPlayerQuestView", nil)
	if not newPlayerTaskCtrl:isTaskFinish(4103101) and newPlayerTaskCtrl:getCurChapterID() == 4103100 then
		_ENV = nil
		;(nil).className = "newPlayerQuestView"
		;(nil).itemName = "buildCastleLv2"
		;(nil).z = 2
		;(nil).qid = 4103101
		self:insertPileLine(MildGuideConfig.PileModel.PanelShow, nil)
	end
	self:star()
end
function mildGuideManager:starToGetCastleLv2()
	self:clean()
	local gametop = gModuleMgr.getObject("gametop")
	local newPlayerTaskCtrl = gametop.playertop_:getModule("newPlayerTaskCtrl")
	_ENV = nil
	;(nil).gGuideModule = gGuideModule.TO_GET_CASTLE_LV2
	self:setVariate("newPlayerQuestView", nil)
	if newPlayerTaskCtrl:isTaskFinish(4103101) and newPlayerTaskCtrl:isTaskRewardCanReceive(4103101) == false and newPlayerTaskCtrl:getCurChapterID() == 4103100 then
		print("领取升级城堡到2级!!!!!!---------")
		_ENV = nil
		;(nil).className = "mainUI"
		;(nil).itemName = "bottomQuestGuide"
		;(nil).z = 2
		;(nil).qid = 4103101
		self:insertPileLine(MildGuideConfig.PileModel.PanelShow, nil)
	end
	self:star()
end
function mildGuideManager:starToBuildMilitaryTent()
	self:clean()
	MildGuideConfig = nil
	;(nil).className = "BuildCreatePanel"
	;(nil).itemName = "tent"
	;(nil).z = 2
	;(nil).bid = 205
	self:insertPileLine(MildGuideConfig.PileModel.PanelShow, nil)
	self:star()
end
function mildGuideManager:starToUpgradeResource(data)
	self:clean()
	_ENV = nil
	;(nil).needCity = true
	self:needVerify(nil)
	_UPVALUE4_ = self.needVerify
	self.needVerify[1] = BUILDID.FARM
	self.needVerify[2] = BUILDID.SAWMILL
	self.needVerify[3] = BUILDID.IRON_MINE
	local self.needVerify[4], resourceBuildID = BUILDID.STEEL, self.needVerify
	local isHaveResourceBuild = false
	for k, v in ipairs(resourceBuildID) do
		_ENV = nil
		;(nil).bid = v
		if self:needVerify(nil) then
			isHaveResourceBuild = true
			break
		end
	end
	if isHaveResourceBuild then
		local gametop = gModuleMgr.getObject("gametop")
		local cityCtrl = gametop.playertop_:getModule("cityCtrl")
		local maxLV = 0
		local bid, iid
		for k, v in ipairs(resourceBuildID) do
			local buildList = cityCtrl:getBuildCellList(v)
			if buildList and next(buildList) then
				for ki, vi in ipairs(buildList) do
					local buildLv = tonumber(vi.info.lv)
					if maxLV < buildLv then
						maxLV = buildLv
						bid = v
						iid = tonumber(vi.info.iid)
					end
				end
			end
		end
		_ENV = nil
		;(nil).bid = bid
		;(nil).iid = iid
		;(nil).isSelected = true
		self:insertPileLine(MildGuideConfig.PileModel.BuildMove, nil)
		_ENV = nil
		;(nil).className = "mainCityView"
		_ENV, (nil).itemName = nil, "tip"
		;(nil).bid = bid
		;(nil).key = "OpUpgrade"
		;(nil).queuePriority = true
		;(nil).data, (nil).delayTime = nil, 1
		self:insertPileLine(MildGuideConfig.PileModel.BuildTip, nil)
	else
		_ENV = buildLv
		buildLv.bid = BUILDID.SAWMILL
		self:starToBuild(buildLv, true)
	end
	self:star()
end
function mildGuideManager:starToStudyTechnology(data)
	self:clean()
	_ENV = nil
	;(nil).needCity = true
	self:needVerify(nil)
	_ENV = self.needVerify
	self.needVerify.bid = BUILDID.COLLEGE
	local self.needVerify.isSelected, moveData = true, self.needVerify
	_ENV = nil
	;(nil).bid = BUILDID.COLLEGE
	if not self:needVerify(nil) then
		_ENV = nil
		;(nil).bid = BUILDID.COLLEGE
		self:starToBuild(nil, true)
	else
		local gametop = gModuleMgr.getObject("gametop")
		local queueCtrl = gametop.playertop_:getModule("queueCtrl")
		if queueCtrl:isNeedReqHelp(gQueueTypeDef.technology_upgrade_queue) then
			moveData.again = 1
			moveData.delayTime = 0.3
		end
	end
	self:insertPileLine(MildGuideConfig.PileModel.BuildMove, moveData)
	_ENV = moveData
	moveData.className = "mainCityView"
	_ENV, moveData.itemName = gQueueTypeDef.technology_upgrade_queue, "tip"
	gQueueTypeDef.technology_upgrade_queue.bid = BUILDID.COLLEGE
	gQueueTypeDef.technology_upgrade_queue.key = "OpResearch"
	moveData.data, gQueueTypeDef.technology_upgrade_queue.queuePriority = gQueueTypeDef.technology_upgrade_queue, true
	self:insertPileLine(MildGuideConfig.PileModel.BuildTip, moveData)
	if data.technologyId and data.technologyId ~= 0 then
		_ENV = moveData
		moveData.className = "collegeView"
		moveData.itemName = "collegeMainSingle"
		moveData.tid = data.technologyId
		moveData.z = 0
		self:insertPileLine(MildGuideConfig.PileModel.PanelShow, moveData)
		_ENV = moveData
		moveData.className = "collegeStudyingView"
		moveData.itemName = "collegeScrollSingle"
		moveData.tid = data.technologyId
		moveData.z = 0
		self:insertPileLine(MildGuideConfig.PileModel.PanelShow, moveData)
	end
	self:star()
end
function mildGuideManager:starToStudyWarTechnology(data)
	self:clean()
	_ENV = nil
	;(nil).needCity = true
	self:needVerify(nil)
	_ENV = nil
	;(nil).bid = BUILDID.MIRACLE
	if not self:needVerify(nil) then
		_ENV = nil
		;(nil).bid = BUILDID.MIRACLE
		self:starToBuild(nil, true)
	end
	_ENV = true
	;(true).bid = BUILDID.MIRACLE
	;(true).isSelected = true
	self:insertPileLine(MildGuideConfig.PileModel.BuildMove, true)
	_ENV = true
	;(true).className = "mainCityView"
	_ENV, (true).itemName = BUILDID.MIRACLE, "tip"
	BUILDID.MIRACLE.bid = BUILDID.MIRACLE
	BUILDID.MIRACLE.key = "OpWarTechnology"
	;(true).data, BUILDID.MIRACLE.queuePriority = BUILDID.MIRACLE, true
	self:insertPileLine(MildGuideConfig.PileModel.BuildTip, true)
	self:star()
end
function mildGuideManager:starToExchangeLordmilitary(data)
	self:clean()
	_ENV = nil
	;(nil).needCity = true
	self:needVerify(nil)
	_ENV = nil
	;(nil).bid = BUILDID.BLACK_SMITH
	if not self:needVerify(nil) then
		SoraDShowMsgTip(i18n("orange_jump_tips_01"))
		return true, true
	end
	_ENV = i18n("orange_jump_tips_01")
	i18n("orange_jump_tips_01").bid = BUILDID.HALL_OF_WAR
	i18n("orange_jump_tips_01").isSelected = true
	self:insertPileLine(MildGuideConfig.PileModel.BuildMove, i18n("orange_jump_tips_01"))
	_ENV = i18n("orange_jump_tips_01")
	i18n("orange_jump_tips_01").className = "mainCityView"
	_ENV, i18n("orange_jump_tips_01").itemName = BUILDID.HALL_OF_WAR, "tip"
	BUILDID.HALL_OF_WAR.bid = BUILDID.HALL_OF_WAR
	BUILDID.HALL_OF_WAR.key = "OpMilitaryPoint"
	i18n("orange_jump_tips_01").data, BUILDID.HALL_OF_WAR.queuePriority = BUILDID.HALL_OF_WAR, true
	self:insertPileLine(MildGuideConfig.PileModel.BuildTip, i18n("orange_jump_tips_01"))
	self:star()
end
function mildGuideManager:starToGodArms(data)
	print("跳转神器引导！！！！！！")
	self:clean()
	if SoraDGetCastleLv() < CASTLE_LV40_LIMITED then
		_ENV = nil
		;(nil).level = 1
		SoraDShowMsgTip(i18n("common_text_4094", nil))
		return
	end
	_ENV = i18n("common_text_4094", nil)
	i18n("common_text_4094", nil).needCity = true
	self:needVerify(i18n("common_text_4094", nil))
	_ENV = i18n("common_text_4094", nil)
	i18n("common_text_4094", nil).bid = BUILDID.BLACK_SMITH
	i18n("common_text_4094", nil).isSelected = true
	self:insertPileLine(MildGuideConfig.PileModel.BuildMove, i18n("common_text_4094", nil))
	_ENV = i18n("common_text_4094", nil)
	i18n("common_text_4094", nil).className = "mainCityView"
	_ENV, i18n("common_text_4094", nil).itemName = BUILDID.BLACK_SMITH, "tip"
	BUILDID.BLACK_SMITH.bid = BUILDID.BLACK_SMITH
	BUILDID.BLACK_SMITH.key = "OpArtifact"
	i18n("common_text_4094", nil).data, BUILDID.BLACK_SMITH.queuePriority = BUILDID.BLACK_SMITH, true
	self:insertPileLine(MildGuideConfig.PileModel.BuildTip, i18n("common_text_4094", nil))
	_ENV = i18n("common_text_4094", nil)
	i18n("common_text_4094", nil).className = "ArtifactView"
	_ENV, i18n("common_text_4094", nil).itemName = BUILDID.BLACK_SMITH, nil
	BUILDID.BLACK_SMITH.name = "viewCallFunc"
	BUILDID.BLACK_SMITH.targetName = "ArtifactView"
	BUILDID.BLACK_SMITH.callFunc = "jumpToWeapon"
	i18n("common_text_4094", nil).action, BUILDID.BLACK_SMITH.data = BUILDID.BLACK_SMITH, data.data
	self:insertPileLine(MildGuideConfig.PileModel.PanelShow, i18n("common_text_4094", nil))
	self:star()
end
function mildGuideManager:starToWarGem(data)
	print("跳转战争宝石引导！！！！！！")
	self:clean()
	_ENV = nil
	;(nil).needCity = true
	self:needVerify(nil)
	_ENV = nil
	;(nil).bid = BUILDID.MIRACLE
	;(nil).isSelected = true
	self:insertPileLine(MildGuideConfig.PileModel.BuildMove, nil)
	_ENV = nil
	;(nil).className = "mainCityView"
	_ENV, (nil).itemName = BUILDID.MIRACLE, "tip"
	BUILDID.MIRACLE.bid = BUILDID.MIRACLE
	BUILDID.MIRACLE.key = "OpWarGem"
	;(nil).data, BUILDID.MIRACLE.queuePriority = BUILDID.MIRACLE, true
	self:insertPileLine(MildGuideConfig.PileModel.BuildTip, nil)
	self:star()
end
function mildGuideManager:starToForeignPavilion(data)
	print("跳转异国馆！！！！！！")
	self:clean()
	_ENV = nil
	;(nil).needCity = true
	self:needVerify(nil)
	_ENV = nil
	;(nil).bid = BUILDID.LESURE_CENTER
	;(nil).isSelected = true
	self:insertPileLine(MildGuideConfig.PileModel.BuildMove, nil)
	_ENV = nil
	;(nil).className = "mainCityView"
	_ENV, (nil).itemName = BUILDID.LESURE_CENTER, "tip"
	BUILDID.LESURE_CENTER.bid = BUILDID.LESURE_CENTER
	BUILDID.LESURE_CENTER.key = "OpForeignPavilion"
	;(nil).data, BUILDID.LESURE_CENTER.queuePriority = BUILDID.LESURE_CENTER, true
	self:insertPileLine(MildGuideConfig.PileModel.BuildTip, nil)
	self:setVariate("ForeignPavilionActivity", "isFromTask", true)
	self:star()
end
function mildGuideManager:starToSoldierRunsh(data)
	print("跳转兵潮！！！")
	self:clean()
	local cityBuildConstDef = include("cityBuildConstDef")
	_ENV = nil
	;(nil).index = cityBuildConstDef.fixedBuildDef.EpicBattle
	self:insertPileLine(MildGuideConfig.PileModel.IndexMove, nil)
	_ENV = nil
	;(nil).className = "SoldierRushChapter"
	;(nil).itemName = nil
	self:insertPileLine(MildGuideConfig.PileModel.PanelShow, nil)
	self:star()
end
function mildGuideManager:starToCommandHall(data)
	print("跳转统率大厅！！！")
	self:clean()
	local cityBuildConstDef = include("cityBuildConstDef")
	_ENV = nil
	;(nil).index = cityBuildConstDef.buildIndexDef.index_CommandHall
	;(nil).z = 1
	self:insertPileLine(MildGuideConfig.PileModel.IndexMove, nil)
	_ENV = nil
	;(nil).className = "CommandHallMain"
	;(nil).itemName = nil
	self:insertPileLine(MildGuideConfig.PileModel.PanelShow, nil)
	self:star()
end
function mildGuideManager:starToAllianceBuildingBuild(data)
	print("跳转建造联盟建筑！！！")
	self:clean()
	SoraDCreateDelayTimer(self, function(...)
		local allianceMgr = SoraDGetCtrl("allianceMgr")
		if allianceMgr:hasJoinAlliance() then
			if GLOBAL_GAME_ALLIANCE_MODE then
				uiManager:show("allianceMainView")
			else
				SoraDCreatePanel("allianceMainView"):show()
			end
		else
			uiManager:show("AllianceJoinView")
		end
	end, 0.1)
	if GLOBAL_GAME_ALLIANCE_MODE then
		_ENV = 0.1
		;(0.1).className = "allianceMainView"
		_ENV, (0.1).itemName = nil, "allianceMenuSingle"
		;(0.1).parameters, (nil).index = nil, ALLIANCE_MAIN_MENU_TYPE.BUILD
		self:insertPileLine(MildGuideConfig.PileModel.PanelShow, 0.1)
	else
		_ENV = 0.1
		;(0.1).className = "allianceMainView"
		_ENV, (0.1).itemName = nil, "allianceMenuSingle"
		;(0.1).parameters, (nil).index = nil, 1
		self:insertPileLine(MildGuideConfig.PileModel.PanelShow, 0.1)
	end
	self:star()
end
function mildGuideManager:starToStatueBrave(data)
	self:clean()
	_ENV = nil
	;(nil).needCity = true
	self:needVerify(nil)
	_ENV = nil
	;(nil).bid = BUILDID.STAR_BRAVE_STATUE
	if not self:needVerify(nil) or not commonCheck.BRAVESTATUS then
		return true, true
	end
	if data.key == "OpWarframeForg" and not commonCheck.WARFRAME then
		return true, true
	end
	_ENV = BUILDID.STAR_BRAVE_STATUE
	BUILDID.STAR_BRAVE_STATUE.bid = BUILDID.STAR_BRAVE_STATUE
	BUILDID.STAR_BRAVE_STATUE.isSelected = true
	self:insertPileLine(MildGuideConfig.PileModel.BuildMove, BUILDID.STAR_BRAVE_STATUE)
	_ENV = BUILDID.STAR_BRAVE_STATUE
	BUILDID.STAR_BRAVE_STATUE.className = "mainCityView"
	_ENV, BUILDID.STAR_BRAVE_STATUE.itemName = BUILDID.STAR_BRAVE_STATUE, "tip"
	BUILDID.STAR_BRAVE_STATUE.bid = BUILDID.STAR_BRAVE_STATUE
	BUILDID.STAR_BRAVE_STATUE.key = data.key
	BUILDID.STAR_BRAVE_STATUE.queuePriority = data.queuePriority
	BUILDID.STAR_BRAVE_STATUE.data, BUILDID.STAR_BRAVE_STATUE.isMild = BUILDID.STAR_BRAVE_STATUE, data.isMild
	self:insertPileLine(MildGuideConfig.PileModel.BuildTip, BUILDID.STAR_BRAVE_STATUE)
	self:star()
end
function mildGuideManager:starToArena(data)
	if worldMapDefine.isInKingdomBattle() then
		SoraDShowMsgTip(i18n("common_text_3302"))
		return true, true
	end
	self:clean()
	_ENV = i18n("common_text_3302")
	i18n("common_text_3302").needCity = true
	self:needVerify(i18n("common_text_3302"))
	_ENV = i18n("common_text_3302")
	i18n("common_text_3302").bid = BUILDID.DRILL_GROUDS
	if not self:needVerify(i18n("common_text_3302")) then
		_ENV = i18n("common_text_3302")
		i18n("common_text_3302").bid = BUILDID.DRILL_GROUDS
		self:starToBuild(i18n("common_text_3302"))
	end
	_ENV = true
	;(true).bid = BUILDID.DRILL_GROUDS
	;(true).isSelected = true
	self:insertPileLine(MildGuideConfig.PileModel.BuildMove, true)
	_ENV = true
	;(true).className = "mainCityView"
	_ENV, (true).itemName = BUILDID.DRILL_GROUDS, "tip"
	BUILDID.DRILL_GROUDS.bid = BUILDID.DRILL_GROUDS
	BUILDID.DRILL_GROUDS.key = "OpArena"
	;(true).data, BUILDID.DRILL_GROUDS.queuePriority = BUILDID.DRILL_GROUDS, true
	self:insertPileLine(MildGuideConfig.PileModel.BuildTip, true)
	self:star()
end
function mildGuideManager:starToWorldAndExplore(data)
	if worldMapDefine.isInWar() then
		SoraDShowMsgTip(i18n("common_text_3302"))
		return true, true
	end
	self:starToQuickToWorld(data)
end
function mildGuideManager:starToWorldAndCollectRes(data)
	if worldMapDefine.isInWar() then
		SoraDShowMsgTip(i18n("common_text_3302"))
		return true, true
	end
	self:clean()
	if SoraDCurrentSceneShowView("worldMapView") == nil then
		_ENV = i18n("common_text_3302")
		i18n("common_text_3302").className = "worldMapView"
		_ENV, i18n("common_text_3302").itemName = i18n("common_text_3302")
		i18n("common_text_3302").name = "worldMapView"
		i18n("common_text_3302").action, i18n("common_text_3302").jump = i18n("common_text_3302")
		self:insertPileLine(MildGuideConfig.PileModel.PanelShow, i18n("common_text_3302"))
	end
	if data.msg then
		_ENV = i18n("common_text_3302")
		i18n("common_text_3302").className = "worldMapView"
		i18n("common_text_3302").itemName = nil
		_ENV, i18n("common_text_3302").autoNext = i18n("common_text_3302")
		i18n("common_text_3302").name = "msg"
		i18n("common_text_3302").action, i18n("common_text_3302").msg = i18n("common_text_3302")
		self:insertPileLine(MildGuideConfig.PileModel.PanelShow, i18n("common_text_3302"))
	end
	_ENV = i18n("common_text_3302")
	i18n("common_text_3302").className = "worldMapView"
	i18n("common_text_3302").itemName = "Button_monsterSearch"
	i18n("common_text_3302").z = 1
	self:insertPileLine(MildGuideConfig.PileModel.PanelShow, i18n("common_text_3302"))
	if data.resid then
		local index = data.resid % 1000 + 1
		if data.resid == 1001 then
			index = 7
		end
		if data.resid == 1027 then
			index = 8
		end
		_ENV = i18n("common_text_3302")
		i18n("common_text_3302").chooseIndex = index
		self:setVariate("worldMapMonsterSearch", i18n("common_text_3302"))
	end
	self:star()
end
function mildGuideManager:starToWorldAndKillMonster(data)
	if worldMapDefine.isInWar() then
		SoraDShowMsgTip(i18n("common_text_3302"))
		return true, true
	end
	self:clean()
	if SoraDCurrentSceneShowView("worldMapView") == nil then
		_ENV = i18n("common_text_3302")
		i18n("common_text_3302").className = "worldMapView"
		_ENV, i18n("common_text_3302").itemName = i18n("common_text_3302")
		i18n("common_text_3302").name = "worldMapView"
		i18n("common_text_3302").action, i18n("common_text_3302").jump = i18n("common_text_3302")
		self:insertPileLine(MildGuideConfig.PileModel.PanelShow, i18n("common_text_3302"))
	end
	if data.msg then
		_ENV = i18n("common_text_3302")
		i18n("common_text_3302").className = "worldMapView"
		i18n("common_text_3302").itemName = nil
		_ENV, i18n("common_text_3302").autoNext = i18n("common_text_3302")
		i18n("common_text_3302").name = "msg"
		i18n("common_text_3302").action, i18n("common_text_3302").msg = i18n("common_text_3302")
		self:insertPileLine(MildGuideConfig.PileModel.PanelShow, i18n("common_text_3302"))
	end
	_ENV = i18n("common_text_3302")
	i18n("common_text_3302").className = "worldMapView"
	i18n("common_text_3302").itemName = "Button_monsterSearch"
	i18n("common_text_3302").z = 1
	self:insertPileLine(MildGuideConfig.PileModel.PanelShow, i18n("common_text_3302"))
	_ENV = i18n("common_text_3302")
	i18n("common_text_3302").chooseIndex = 1
	i18n("common_text_3302").lv = data.lv
	self:setVariate("worldMapMonsterSearch", i18n("common_text_3302"))
	self:star()
end
function mildGuideManager:starToAutoKillMonster()
	if worldMapDefine.isInWar() then
		SoraDShowMsgTip(i18n("common_text_3302"))
		return true, true
	end
	local gametop = gModuleMgr.getObject("gametop")
	local guideCtrl = gametop.playertop_:getModule("guideCtrl")
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	self:clean()
	if SoraDCurrentSceneShowView("mainCityView") then
		_ENV = i18n("common_text_3302")
		i18n("common_text_3302").className = "mainUI"
		i18n("common_text_3302").itemName = "bottomWorldBtn"
		i18n("common_text_3302").z = 3
		self:insertPileLine(MildGuideConfig.PileModel.PanelShow, i18n("common_text_3302"))
	end
	_ENV = i18n("common_text_3302")
	i18n("common_text_3302").className = "worldMapView"
	i18n("common_text_3302").itemName = "Button_monsterSearch"
	i18n("common_text_3302").z = 1
	self:insertPileLine(MildGuideConfig.PileModel.PanelShow, i18n("common_text_3302"))
	_ENV = i18n("common_text_3302")
	i18n("common_text_3302").chooseIndex = 1
	self:setVariate("worldMapMonsterSearch", i18n("common_text_3302"))
	_ENV = i18n("common_text_3302")
	i18n("common_text_3302").className = "worldMapMonsterSearch"
	i18n("common_text_3302").itemName = "Button_autokill"
	i18n("common_text_3302").z = 1
	self:insertPileLine(MildGuideConfig.PileModel.PanelShow, i18n("common_text_3302"))
	self:star()
end
function mildGuideManager:starToKillMonster(data)
	if worldMapDefine.isInWar() then
		SoraDShowMsgTip(i18n("common_text_3302"))
		return true, true
	end
	local gametop = gModuleMgr.getObject("gametop")
	local guideCtrl = gametop.playertop_:getModule("guideCtrl")
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	self:clean()
	if SoraDCurrentSceneShowView("mainCityView") then
		_ENV = i18n("common_text_3302")
		i18n("common_text_3302").className = "mainUI"
		i18n("common_text_3302").itemName = "bottomWorldBtn"
		i18n("common_text_3302").z = 3
		self:insertPileLine(MildGuideConfig.PileModel.PanelShow, i18n("common_text_3302"))
	end
	_ENV = i18n("common_text_3302")
	i18n("common_text_3302").className = "worldMapView"
	i18n("common_text_3302").itemName = "Button_monsterSearch"
	i18n("common_text_3302").z = 1
	self:insertPileLine(MildGuideConfig.PileModel.PanelShow, i18n("common_text_3302"))
	local jumpIndex = 1
	_ENV = i18n("common_text_3302")
	i18n("common_text_3302").chooseIndex = jumpIndex
	i18n("common_text_3302").lv = data and data.lv or 1
	self:setVariate("worldMapMonsterSearch", i18n("common_text_3302"))
	if guideCtrl:isGuideNotCompleted(gGuideModule.SEARCH_MONSTER) then
		_ENV = i18n("common_text_3302")
		i18n("common_text_3302").className = "worldMapMonsterInfo"
		i18n("common_text_3302").itemName = "Button_attack"
		self:insertPileLine(MildGuideConfig.PileModel.PanelShow, i18n("common_text_3302"))
		_ENV = i18n("common_text_3302")
		i18n("common_text_3302").className = "WorldDispatchArmyView"
		i18n("common_text_3302").itemName = "Button_go"
		_ENV, i18n("common_text_3302").z = data and data.lv or 1, 1
		;(data and data.lv or 1).name = "variate"
		_ENV, (data and data.lv or 1).className = i18n("common_text_3302")
		i18n("common_text_3302").action, (data and data.lv or 1).variate, i18n("common_text_3302").isGuide = data and data.lv or 1, i18n("common_text_3302")
		self:insertPileLine(MildGuideConfig.PileModel.PanelShow, i18n("common_text_3302"))
		if SoraDCurrentSceneShowView("mainCityView") then
			_ENV = i18n("common_text_3302")
			i18n("common_text_3302").className = "mainUI"
			i18n("common_text_3302").itemName = "bottomWorldBtn"
			i18n("common_text_3302").z = 3
			self:insertPileLine(MildGuideConfig.PileModel.PanelShow, i18n("common_text_3302"))
		end
		_ENV = i18n("common_text_3302")
		i18n("common_text_3302").className = "mainUI"
		i18n("common_text_3302").itemName = "bottomQuestGuide"
		i18n("common_text_3302").z = 1
		self:insertPileLine(MildGuideConfig.PileModel.PanelShow, i18n("common_text_3302"))
	end
	self:star()
end
function mildGuideManager:starToEscout(data)
	if worldMapDefine.isInWar() then
		SoraDShowMsgTip(i18n("common_text_3302"))
		return true, true
	end
	if data and data.isNewTrial then
		self:clean()
		local ismainCity = SoraDCurrentSceneShowView("mainCityView")
		dump(SoraDCurrentTopPanelNameFromManager(), "最上面的界面")
		if ismainCity then
			_ENV = i18n("common_text_3302")
			i18n("common_text_3302").className = "mainUI"
			i18n("common_text_3302").itemName = "bottomWorldBtn"
			i18n("common_text_3302").z = 3
			self:insertPileLine(MildGuideConfig.PileModel.PanelShow, i18n("common_text_3302"))
		end
		if ismainCity then
			_ENV = i18n("common_text_3302")
			i18n("common_text_3302").gGuideModule = gGuideModule.ESCORT
			self:setVariate("worldMapView", i18n("common_text_3302"))
		end
		_ENV = i18n("common_text_3302")
		i18n("common_text_3302").className = "worldMapView"
		i18n("common_text_3302").itemName = "Button_monsterSearch"
		i18n("common_text_3302").z = 1
		self:insertPileLine(MildGuideConfig.PileModel.PanelShow, i18n("common_text_3302"))
		_ENV = i18n("common_text_3302")
		i18n("common_text_3302").chooseIndex = 2
		self:setVariate("worldMapMonsterSearch", i18n("common_text_3302"))
		_ENV = i18n("common_text_3302")
		i18n("common_text_3302").className = "worldMapMonsterSearch"
		i18n("common_text_3302").itemName = "Button_go"
		i18n("common_text_3302").z = 1
		self:insertPileLine(MildGuideConfig.PileModel.PanelShow, i18n("common_text_3302"))
		_ENV = i18n("common_text_3302")
		i18n("common_text_3302").className = "worldMapView"
		i18n("common_text_3302").itemName = "tipButton_yayun"
		i18n("common_text_3302").z = 1
		self:insertPileLine(MildGuideConfig.PileModel.PanelShow, i18n("common_text_3302"))
		if SoraDCurrentSceneShowView("worldMapView") then
			_ENV = i18n("common_text_3302")
			i18n("common_text_3302").gGuideModule = gGuideModule.ESCORT
			self:setVariate("worldEscortBeginView", i18n("common_text_3302"))
		end
		_ENV = i18n("common_text_3302")
		i18n("common_text_3302").className = "worldEscortBeginView"
		i18n("common_text_3302").itemName = "btn_beginEscort"
		i18n("common_text_3302").z = 1
		self:insertPileLine(MildGuideConfig.PileModel.PanelShow, i18n("common_text_3302"))
		if SoraDCurrentTopPanelNameFromManager() == "worldEscortBeginView" then
			self:clean()
			_ENV = i18n("common_text_3302")
			i18n("common_text_3302").className = "worldEscortBeginView"
			i18n("common_text_3302").itemName = "btn_beginEscort"
			i18n("common_text_3302").z = 1
			self:insertPileLine(MildGuideConfig.PileModel.PanelShow, i18n("common_text_3302"))
		end
		self:star()
	else
		self:clean()
		if SoraDCurrentSceneShowView("mainCityView") then
			_ENV = MildGuideConfig.PileModel.PanelShow
			MildGuideConfig.PileModel.PanelShow.className = "mainUI"
			MildGuideConfig.PileModel.PanelShow.itemName = "bottomWorldBtn"
			MildGuideConfig.PileModel.PanelShow.z = 3
			self:insertPileLine(MildGuideConfig.PileModel.PanelShow, MildGuideConfig.PileModel.PanelShow)
		end
		_ENV = MildGuideConfig.PileModel.PanelShow
		MildGuideConfig.PileModel.PanelShow.className = "worldMapView"
		MildGuideConfig.PileModel.PanelShow.itemName = "Button_monsterSearch"
		MildGuideConfig.PileModel.PanelShow.z = 1
		self:insertPileLine(MildGuideConfig.PileModel.PanelShow, MildGuideConfig.PileModel.PanelShow)
		_ENV = MildGuideConfig.PileModel.PanelShow
		MildGuideConfig.PileModel.PanelShow.chooseIndex = 2
		self:setVariate("worldMapMonsterSearch", MildGuideConfig.PileModel.PanelShow)
		_ENV = MildGuideConfig.PileModel.PanelShow
		MildGuideConfig.PileModel.PanelShow.className = "worldMapMonsterSearch"
		MildGuideConfig.PileModel.PanelShow.itemName = "Button_go"
		MildGuideConfig.PileModel.PanelShow.z = 1
		self:insertPileLine(MildGuideConfig.PileModel.PanelShow, MildGuideConfig.PileModel.PanelShow)
		_ENV = MildGuideConfig.PileModel.PanelShow
		MildGuideConfig.PileModel.PanelShow.className = "worldEscortBeginView"
		MildGuideConfig.PileModel.PanelShow.itemName = "btn_beginEscort"
		MildGuideConfig.PileModel.PanelShow.z = 1
		self:insertPileLine(MildGuideConfig.PileModel.PanelShow, MildGuideConfig.PileModel.PanelShow)
		self:star()
	end
end
function mildGuideManager:starToWharf(data)
	self:clean()
	local cityBuildConstDef = include("cityBuildConstDef")
	_ENV = nil
	;(nil).needCity = true
	self:needVerify(nil)
	_ENV = nil
	;(nil).index = cityBuildConstDef.buildIndexDef.index_Gangkou
	;(nil).z = 1
	self:insertPileLine(MildGuideConfig.PileModel.IndexMove, nil)
	_ENV = nil
	;(nil).className = "timeRewardDetail"
	;(nil).itemName = "Button_getReward"
	self:insertPileLine(MildGuideConfig.PileModel.PanelShow, nil)
	self:star()
end
function mildGuideManager:starToEveryDayReward(data)
	self:clean()
	local cityBuildConstDef = include("cityBuildConstDef")
	_ENV = nil
	;(nil).needCity = true
	self:needVerify(nil)
	_ENV = nil
	;(nil).index = cityBuildConstDef.buildIndexDef.index_HuoChuang
	;(nil).isSelected = true
	self:insertPileLine(MildGuideConfig.PileModel.IndexMove, nil)
	_ENV = nil
	;(nil).className = "mainCityView"
	_ENV, (nil).itemName = cityBuildConstDef.buildIndexDef.index_HuoChuang, "tip"
	cityBuildConstDef.buildIndexDef.index_HuoChuang.bid = cityBuildConstDef.buildIndexDef.index_HuoChuang
	cityBuildConstDef.buildIndexDef.index_HuoChuang.key = "OpDailyReward"
	;(nil).data, cityBuildConstDef.buildIndexDef.index_HuoChuang.queuePriority = cityBuildConstDef.buildIndexDef.index_HuoChuang, true
	self:insertPileLine(MildGuideConfig.PileModel.BuildTip, nil)
	self:star()
end
function mildGuideManager:starToDaylySign(data)
	self:clean()
	local cityBuildConstDef = include("cityBuildConstDef")
	_ENV = nil
	;(nil).needCity = true
	self:needVerify(nil)
	_ENV = nil
	;(nil).index = cityBuildConstDef.buildIndexDef.index_HuoChuang
	;(nil).isSelected = true
	self:insertPileLine(MildGuideConfig.PileModel.IndexMove, nil)
	_ENV = nil
	;(nil).className = "mainCityView"
	_ENV, (nil).itemName = cityBuildConstDef.buildIndexDef.index_HuoChuang, "tip"
	cityBuildConstDef.buildIndexDef.index_HuoChuang.bid = cityBuildConstDef.buildIndexDef.index_HuoChuang
	cityBuildConstDef.buildIndexDef.index_HuoChuang.key = "OpDaylySign"
	;(nil).data, cityBuildConstDef.buildIndexDef.index_HuoChuang.queuePriority = cityBuildConstDef.buildIndexDef.index_HuoChuang, true
	self:insertPileLine(MildGuideConfig.PileModel.BuildTip, nil)
	self:star()
end
function mildGuideManager:starToOccupy(data)
	self:clean()
	MildGuideConfig = nil
	;(nil).className = "worldMapView"
	;(nil).itemName = "tipButton_zhanling"
	;(nil).again = 10
	;(nil).delayTime = 1
	self:insertPileLine(MildGuideConfig.PileModel.PanelShow, nil)
	self:star()
end
function mildGuideManager:starToCollect(data)
	if worldMapDefine.isInWar() then
		SoraDShowMsgTip(i18n("common_text_3302"))
		return true, true
	end
	self:clean()
	if SoraDCurrentSceneShowView("mainCityView") then
		_ENV = i18n("common_text_3302")
		i18n("common_text_3302").className = "mainUI"
		i18n("common_text_3302").itemName = "bottomWorldBtn"
		i18n("common_text_3302").z = 3
		self:insertPileLine(MildGuideConfig.PileModel.PanelShow, i18n("common_text_3302"))
	end
	_ENV = i18n("common_text_3302")
	i18n("common_text_3302").className = "worldMapView"
	i18n("common_text_3302").itemName = "Button_monsterSearch"
	i18n("common_text_3302").z = 1
	self:insertPileLine(MildGuideConfig.PileModel.PanelShow, i18n("common_text_3302"))
	if data and data.resid and data.resid > 0 then
		local index = data.resid % 1000 + 1
		if data.resid == gIDDef.GOLD then
			index = 7
		end
		if data.resid == gIDDef.CRYSTAL then
			index = 8
		end
		_ENV = i18n("common_text_3302")
		i18n("common_text_3302").chooseIndex = index
		self:setVariate("worldMapMonsterSearch", i18n("common_text_3302"))
	else
		_ENV = "worldMapMonsterSearch"
		;("worldMapMonsterSearch").chooseIndex = 3
		self:setVariate("worldMapMonsterSearch", "worldMapMonsterSearch")
	end
	self:star()
end
function mildGuideManager:starToMasteryDraw(data)
	self:clean()
	MildGuideConfig = nil
	;(nil).needCity = true
	self:needVerify(nil)
	MildGuideConfig = nil
	;(nil).index = data.bid
	;(nil).isSelected = true
	self:insertPileLine(MildGuideConfig.PileModel.IndexMove, nil)
	MildGuideConfig = nil
	;(nil).className = "mainCityView"
	MildGuideConfig, (nil).itemName = data.bid, "tip"
	data.bid.bid = data.bid
	data.bid.key = "OpDrawing"
	;(nil).data, data.bid.queuePriority = data.bid, true
	self:insertPileLine(MildGuideConfig.PileModel.BuildTip, nil)
	self:star()
end
function mildGuideManager:starToBuildMastery(data)
	self:clean()
	MildGuideConfig = nil
	;(nil).needCity = true
	self:needVerify(nil)
	MildGuideConfig = nil
	;(nil).index = data.bid
	;(nil).isSelected = true
	self:insertPileLine(MildGuideConfig.PileModel.IndexMove, nil)
	MildGuideConfig = nil
	;(nil).className = "mainCityView"
	MildGuideConfig, (nil).itemName = data.bid, "tip"
	data.bid.bid = data.bid
	data.bid.key = "OpMainMastery"
	;(nil).data, data.bid.queuePriority = data.bid, true
	self:insertPileLine(MildGuideConfig.PileModel.BuildTip, nil)
	self:star()
end
function mildGuideManager:starToHarvestFarm(data)
	self:clean()
	if SoraDCurrentSceneShowView("mainCityView") then
		_ENV = nil
		;(nil).bid = BUILDID.FARM
		;(nil).isSelected = true
		self:insertPileLine(MildGuideConfig.PileModel.BuildMove, nil)
	else
		_ENV = nil
		;(nil).className = "mainUI"
		;(nil).itemName = "bottomWorldBtn"
		;(nil).z = 3
		self:insertPileLine(MildGuideConfig.PileModel.PanelShow, nil)
	end
	self:star()
end
function mildGuideManager:checkArmyBuild(data)
	local focus = data.bid
	if data.bid == 0 then
		local gametop = gModuleMgr.getObject("gametop")
		local cityCtrl = gametop.playertop_:getModule("cityCtrl")
		local armyLogic = include("armyLogic")
		_ENV = "armyLogic"
		;("armyLogic")[1] = BUILDID.CHARIOT_PLANT
		;("armyLogic")[2] = BUILDID.STABLES
		;("armyLogic")[3] = BUILDID.RANGE
		local ("armyLogic")[4], armyBuild = BUILDID.BARRACKS, "armyLogic"
		local _ENV, canTrain = BUILDID.BARRACKS, BUILDID.BARRACKS
		for i, v in ipairs(armyBuild) do
			if data.lv and 1 <= data.lv then
				local maxArmyID = table.remove(armyLogic.getArmyIDListCanTrain(v))
				if maxArmyID then
					local armyMaxLv = armyLogic.getArmyLV(maxArmyID)
					if armyMaxLv >= data.lv then
						canTrain[v] = true
					end
				else
					canTrain[v] = false
				end
			else
				canTrain[v] = true
			end
		end
		if data.bid == 0 then
			local curBuildLv = 0
			for i, v in ipairs(armyBuild) do
				if canTrain[v] then
					if focus == 0 then
						focus = v
					end
					local buildCell = cityCtrl:getBuildCellList(v)[1]
					if buildCell and tonumber(buildCell.info.state) == BUILD_STATE.NORMAL and curBuildLv < tonumber(buildCell.info.lv) then
						focus = v
						curBuildLv = tonumber(buildCell.info.lv)
					end
				end
			end
			if focus == 0 then
				focus = armyBuild[1]
			end
		end
	end
	return focus
end
function mildGuideManager:starToTrainArmy(data)
	print("mildGuideManager:starToTrainArmy(data)---------------")
	dump(data, "data starToTrainArmy", 10)
	self:clean()
	local focusBid = self:checkArmyBuild(data)
	_ENV = 10
	;(10).needCity = true
	self:needVerify(10)
	_ENV = 10
	;(10).bid = focusBid
	if not self:needVerify(10) then
		_ENV = 10
		;(10).bid = focusBid
		self:starToBuild(10, true)
	end
	if data.lv and data.lv >= 1 then
		_ENV = true
		;(true).bid = focusBid
		;(true).lv = data.lv
		self:setVariate("soldiersCampView", true)
	end
	_ENV = true
	;(true).bid = focusBid
	;(true).isSelected = true
	self:insertPileLine(MildGuideConfig.PileModel.BuildMove, true)
	if focusBid == BUILDID.FORTRESS then
		_ENV = true
		;(true).className = "mainCityView"
		;(true).itemName = "tip"
		_ENV, (true).delayTime = data.lv, 1
		data.lv.bid = focusBid
		data.lv.key = "OpBuild"
		data.lv.delayTime = 1
		;(true).data, data.lv.queuePriority = data.lv, true
		self:insertPileLine(MildGuideConfig.PileModel.BuildTip, true)
	else
		_ENV = true
		;(true).className = "mainCityView"
		;(true).itemName = "tip"
		_ENV, (true).delayTime = data.lv, 1
		data.lv.bid = focusBid
		data.lv.key = "OpTrain"
		data.lv.delayTime = 1
		;(true).data, data.lv.queuePriority = data.lv, true
		self:insertPileLine(MildGuideConfig.PileModel.BuildTip, true)
	end
	self:star()
end
function mildGuideManager:starToStudySkill(data)
	self:clean()
	MildGuideConfig = nil
	;(nil).className = "mainUI"
	;(nil).itemName = "topHeadFrame"
	;(nil).z = 3
	self:insertPileLine(MildGuideConfig.PileModel.PanelShow, nil, true)
	MildGuideConfig = nil
	;(nil).className = "lordView"
	;(nil).itemName = "Button_skill"
	;(nil).z = 1
	self:insertPileLine(MildGuideConfig.PileModel.PanelShow, nil)
	self:star()
end
function mildGuideManager:starToAchieveSystem(data)
	self:clean()
	MildGuideConfig = nil
	;(nil).className = "mainUI"
	;(nil).itemName = "topHeadFrame"
	;(nil).z = 3
	self:insertPileLine(MildGuideConfig.PileModel.PanelShow, nil, true)
	MildGuideConfig = nil
	;(nil).className = "lordView"
	;(nil).itemName = "Button_honour"
	self:insertPileLine(MildGuideConfig.PileModel.PanelShow, nil)
	MildGuideConfig = nil
	;(nil).className = "honourWallView"
	;(nil).itemName = "Button_medal"
	self:insertPileLine(MildGuideConfig.PileModel.PanelShow, nil)
	self:star()
end
function mildGuideManager:starToSendFlower(data)
	self:clean()
	MildGuideConfig = nil
	;(nil).className = "mainUI"
	;(nil).itemName = "topHeadFrame"
	;(nil).z = 3
	self:insertPileLine(MildGuideConfig.PileModel.PanelShow, nil, true)
	MildGuideConfig = nil
	;(nil).className = "lordView"
	;(nil).itemName = "Button_flower"
	self:insertPileLine(MildGuideConfig.PileModel.PanelShow, nil)
	self:star()
end
function mildGuideManager:starToActivateVip(data)
	MildGuideConfig = nil
	;(nil).className = "mainUI"
	;(nil).itemName = "Button_vip"
	;(nil).z = 3
	self:insertPileLine(MildGuideConfig.PileModel.PanelShow, nil, true)
	MildGuideConfig = nil
	;(nil).className = "vipCenterView"
	;(nil).itemName = "Button_activeVip"
	self:insertPileLine(MildGuideConfig.PileModel.PanelShow, nil)
	self:star()
end
function mildGuideManager:starToUnlockPet(data)
	self:clean()
	local cityBuildConstDef = include("cityBuildConstDef")
	_ENV = nil
	;(nil).needCity = true
	self:needVerify(nil)
	_ENV = nil
	;(nil).index = cityBuildConstDef.buildIndexDef.index_PetCenter
	;(nil).isSelected = true
	self:insertPileLine(MildGuideConfig.PileModel.IndexMove, nil)
	local _ENV, key = self, data and data.tipKey and data.tipKey or "OpPet"
	self.bid = cityBuildConstDef.buildIndexDef.index_PetCenter
	local self.key, data = key, self
	if key == BOP_NAME.BOP_PET then
		data.selTabIndex = 1
	elseif key == BOP_NAME.BOP_PET_EXCHANGE then
		data.selTabIndex = 2
	end
	_ENV = nil
	;(nil).className = "mainCityView"
	;(nil).itemName = "tip"
	;(nil).data = data
	self:insertPileLine(MildGuideConfig.PileModel.BuildTip, nil)
	self:star()
end
function mildGuideManager:starToUnlockPlot(data)
	self:clean()
	local cityBuildConstDef = include("cityBuildConstDef")
	_ENV = nil
	;(nil).needCity = true
	self:needVerify(nil)
	local index = data.index or cityBuildConstDef.buildIndexDef.index_lock_area_1
	_ENV = nil
	;(nil).index = index
	self:insertPileLine(MildGuideConfig.PileModel.IndexMove, nil)
	self:star()
end
function mildGuideManager:starToOpenBuilder(data)
	MildGuideConfig = nil
	;(nil).className = "mainUI"
	;(nil).itemName = "goldBuilder"
	self:insertPileLine(MildGuideConfig.PileModel.PanelShow, nil, true)
	MildGuideConfig = nil
	;(nil).className = "BuilderActivePop"
	;(nil).itemName = "Button_tool"
	self:insertPileLine(MildGuideConfig.PileModel.PanelShow, nil)
	self:star()
end
function mildGuideManager:starToJoinAllinace(data)
	MildGuideConfig = nil
	;(nil).className = "mainUI"
	;(nil).itemName = "bottomAllianceBtn"
	;(nil).z = 3
	self:insertPileLine(MildGuideConfig.PileModel.PanelShow, nil, true)
	MildGuideConfig = nil
	;(nil).className = "allianceFirstJoinView"
	;(nil).itemName = "Button_join"
	self:insertPileLine(MildGuideConfig.PileModel.PanelShow, nil)
	self:star()
end
function mildGuideManager:starToHelpAlly(data)
	self:clean()
	_ENV = nil
	;(nil).needCity = true
	self:needVerify(nil)
	_ENV = nil
	;(nil).bid = BUILDID.EMBASSY
	if not self:needVerify(nil) then
		_ENV = nil
		;(nil).bid = BUILDID.EMBASSY
		self:starToBuild(nil, true)
	end
	_ENV = true
	;(true).bid = BUILDID.EMBASSY
	;(true).isSelected = true
	self:insertPileLine(MildGuideConfig.PileModel.BuildMove, true)
	_ENV = true
	;(true).className = "mainCityView"
	_ENV, (true).itemName = BUILDID.EMBASSY, "tip"
	BUILDID.EMBASSY.bid = BUILDID.EMBASSY
	BUILDID.EMBASSY.key = "OpHelp"
	;(true).data, BUILDID.EMBASSY.queuePriority = BUILDID.EMBASSY, true
	self:insertPileLine(MildGuideConfig.PileModel.BuildTip, true)
	self:star()
end
function mildGuideManager:starToAidAlly(data)
	MildGuideConfig = nil
	;(nil).className = "mainUI"
	;(nil).itemName = "bottomAllianceBtn"
	;(nil).z = 3
	self:insertPileLine(MildGuideConfig.PileModel.PanelShow, nil, true)
	MildGuideConfig = nil
	;(nil).className = "allianceMainView"
	;(nil).itemName = "Button_member"
	self:insertPileLine(MildGuideConfig.PileModel.PanelShow, nil)
	self:star()
end
function mildGuideManager:starToResAidAlly(data)
	self:clean()
	_ENV = nil
	;(nil).needCity = true
	self:needVerify(nil)
	_ENV = nil
	;(nil).bid = BUILDID.MARKET
	if not self:needVerify(nil) then
		_ENV = nil
		;(nil).bid = BUILDID.MARKET
		self:starToBuild(nil, true)
	end
	_ENV = true
	;(true).bid = BUILDID.MARKET
	;(true).isSelected = true
	self:insertPileLine(MildGuideConfig.PileModel.BuildMove, true)
	_ENV = true
	;(true).className = "mainCityView"
	_ENV, (true).itemName = BUILDID.MARKET, "tip"
	BUILDID.MARKET.bid = BUILDID.MARKET
	BUILDID.MARKET.key = "OpTrade"
	;(true).data, BUILDID.MARKET.queuePriority = BUILDID.MARKET, true
	self:insertPileLine(MildGuideConfig.PileModel.BuildTip, true)
	self:star()
end
function mildGuideManager:starToWish(data)
	self:clean()
	_ENV = nil
	;(nil).needCity = true
	self:needVerify(nil)
	_ENV = nil
	;(nil).bid = BUILDID.WISHING_WELL
	if not self:needVerify(nil) then
		_ENV = nil
		;(nil).bid = BUILDID.WISHING_WELL
		self:starToBuild(nil, true)
	end
	_ENV = true
	;(true).bid = BUILDID.WISHING_WELL
	;(true).isSelected = true
	self:insertPileLine(MildGuideConfig.PileModel.BuildMove, true)
	_ENV = true
	;(true).className = "mainCityView"
	_ENV, (true).itemName = BUILDID.WISHING_WELL, "tip"
	BUILDID.WISHING_WELL.bid = BUILDID.WISHING_WELL
	BUILDID.WISHING_WELL.key = "OpWish"
	;(true).data, BUILDID.WISHING_WELL.queuePriority = BUILDID.WISHING_WELL, true
	self:insertPileLine(MildGuideConfig.PileModel.BuildTip, true)
	self:star()
end
function mildGuideManager:starToEndlessTreasure(data)
	self:clean()
	_ENV = nil
	;(nil).needCity = true
	self:needVerify(nil)
	_ENV = nil
	;(nil).bid = BUILDID.WISHING_WELL
	if not self:needVerify(nil) then
		_ENV = nil
		;(nil).bid = BUILDID.WISHING_WELL
		self:starToBuild(nil, true)
	end
	_ENV = true
	;(true).bid = BUILDID.WISHING_WELL
	;(true).isSelected = true
	self:insertPileLine(MildGuideConfig.PileModel.BuildMove, true)
	_ENV = true
	;(true).className = "mainCityView"
	_ENV, (true).itemName = BUILDID.WISHING_WELL, "tip"
	BUILDID.WISHING_WELL.bid = BUILDID.WISHING_WELL
	;(true).data, BUILDID.WISHING_WELL.key = BUILDID.WISHING_WELL, "OpEndlessTreasure"
	self:insertPileLine(MildGuideConfig.PileModel.BuildTip, true)
	self:star()
end
function mildGuideManager:starToDressShop(data)
	self:clean()
	_ENV = nil
	;(nil).needCity = true
	self:needVerify(nil)
	_ENV = nil
	;(nil).bid = BUILDID.CASTLE
	if not self:needVerify(nil) then
		_ENV = nil
		;(nil).bid = BUILDID.CASTLE
		self:starToBuild(nil, true)
	end
	_ENV = true
	;(true).bid = BUILDID.CASTLE
	;(true).isSelected = true
	self:insertPileLine(MildGuideConfig.PileModel.BuildMove, true)
	_ENV = true
	;(true).className = "mainCityView"
	_ENV, (true).itemName = BUILDID.CASTLE, "tip"
	BUILDID.CASTLE.bid = BUILDID.CASTLE
	BUILDID.CASTLE.key = "OpCityDecorate"
	;(true).data, BUILDID.CASTLE.queuePriority = BUILDID.CASTLE, true
	self:insertPileLine(MildGuideConfig.PileModel.BuildTip, true)
	self:star()
end
function mildGuideManager:starToMysticalStore(data)
	self:clean()
	local cityBuildConstDef = include("cityBuildConstDef")
	_ENV = nil
	;(nil).needCity = true
	self:needVerify(nil)
	_ENV = nil
	;(nil).index = cityBuildConstDef.buildIndexDef.index_Merchant
	;(nil).z = 1
	self:insertPileLine(MildGuideConfig.PileModel.IndexMove, nil)
	self:star()
end
function mildGuideManager:starToPyramid(data)
	self:clean()
	local cityBuildConstDef = include("cityBuildConstDef")
	_ENV = nil
	;(nil).needCity = true
	self:needVerify(nil)
	_ENV = nil
	;(nil).index = cityBuildConstDef.buildIndexDef.index_LeisureCenter
	;(nil).isSelected = true
	self:insertPileLine(MildGuideConfig.PileModel.IndexMove, nil)
	_ENV = nil
	;(nil).className = "mainCityView"
	_ENV, (nil).itemName = cityBuildConstDef.buildIndexDef.index_LeisureCenter, "tip"
	cityBuildConstDef.buildIndexDef.index_LeisureCenter.bid = cityBuildConstDef.buildIndexDef.index_LeisureCenter
	;(nil).data, cityBuildConstDef.buildIndexDef.index_LeisureCenter.key = cityBuildConstDef.buildIndexDef.index_LeisureCenter, "OpPyramid"
	self:insertPileLine(MildGuideConfig.PileModel.BuildTip, nil)
	self:star()
end
function mildGuideManager:starToBadgeexChange(data)
	self:clean()
	local cityBuildConstDef = include("cityBuildConstDef")
	_ENV = nil
	;(nil).needCity = true
	self:needVerify(nil)
	_ENV = nil
	;(nil).index = cityBuildConstDef.buildIndexDef.index_LeisureCenter
	;(nil).isSelected = true
	self:insertPileLine(MildGuideConfig.PileModel.IndexMove, nil)
	_ENV = nil
	;(nil).className = "mainCityView"
	_ENV, (nil).itemName = cityBuildConstDef.buildIndexDef.index_LeisureCenter, "tip"
	cityBuildConstDef.buildIndexDef.index_LeisureCenter.bid = cityBuildConstDef.buildIndexDef.index_LeisureCenter
	;(nil).data, cityBuildConstDef.buildIndexDef.index_LeisureCenter.key = cityBuildConstDef.buildIndexDef.index_LeisureCenter, "OpBadgeBourse"
	self:insertPileLine(MildGuideConfig.PileModel.BuildTip, nil)
	self:star()
end
function mildGuideManager:starToFactory(data)
	self:clean()
	local cityBuildConstDef = include("cityBuildConstDef")
	_ENV = nil
	;(nil).needCity = true
	self:needVerify(nil)
	_ENV = nil
	;(nil).index = cityBuildConstDef.buildIndexDef.index_Material_WorkShop
	;(nil).z = 1
	self:insertPileLine(MildGuideConfig.PileModel.IndexMove, nil)
	self:star()
end
function mildGuideManager:starToEpicWar(data)
	self:clean()
	local cityBuildConstDef = include("cityBuildConstDef")
	_ENV = nil
	;(nil).needCity = true
	self:needVerify(nil)
	_ENV = nil
	;(nil).index = cityBuildConstDef.buildIndexDef.index_EpicBattle
	self:insertPileLine(MildGuideConfig.PileModel.IndexMove, nil)
	self:star()
end
function mildGuideManager:starToAnnals(data)
	self:clean()
	local cityBuildConstDef = include("cityBuildConstDef")
	_ENV = nil
	;(nil).needCity = true
	self:needVerify(nil)
	_ENV = nil
	;(nil).index = cityBuildConstDef.buildIndexDef.index_Monument
	self:insertPileLine(MildGuideConfig.PileModel.IndexMove, nil)
	self:star()
end
function mildGuideManager:haveVerifyToSkipEpicWar(data)
	self:clean()
	local cityBuildConstDef = include("cityBuildConstDef")
	_ENV = nil
	;(nil).needCity = true
	self:needVerify(nil)
	if data.chapterID and data.stageID then
		_ENV = nil
		;(nil).chapterID = data.chapterID
		;(nil).stageID = data.stageID
		self:setVariate("epicBattleLevelView", nil)
		_ENV = nil
		;(nil).className = "epicBattleLevelView"
		;(nil).itemName = "epicBattleLevelSingle"
		;(nil).index = data.stageID % 100
		;(nil).z = 5
		self:insertPileLine(MildGuideConfig.PileModel.PanelShow, nil)
	else
		_ENV = nil
		;(nil).index = cityBuildConstDef.buildIndexDef.index_EpicBattle
		self:insertPileLine(MildGuideConfig.PileModel.IndexMove, nil)
	end
	self:star()
end
function mildGuideManager:starToEvilPalace(data)
	self:clean()
	local gametop = gModuleMgr.getObject("gametop")
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	local eventState = activityShowCtrl:getStateByID(gActivityTimeActivityID.MONSTERPALACE_ACTIVITY)
	if eventState == gActivityState.OPEN then
		local cityCtrl = gametop.playertop_:getModule("cityCtrl")
		if cityCtrl:getBuildMaxLv(BUILDID.CASTLE) < CASTLE_LV6_LIMITED then
			_ENV = nil
			;(nil).lv = CASTLE_LV6_LIMITED
			SoraDShowMsgTip(i18n("common_text_2749", nil), "icon_activity_9001040.png")
			limit = true
		else
			SoraDCreateDelayTimer(self, function(...)
				uiManager:show("evilPalaceReadyView")
			end, 0.1)
		end
	elseif eventState == gActivityState.PREPARE then
		SoraDShowMsgTip(i18n("common_text_608"))
	elseif eventState == gActivityState.CLOSE then
		SoraDShowMsgTip(i18n("common_text_2486"))
	end
	self:star()
	return true, true
end
function mildGuideManager:starToAllianceHunt(data)
	if worldMapDefine.inInCrossWar() then
		SoraDShowMsgTip(i18n("common_text_3302"))
		return true, true
	end
	self:clean()
	_ENV = i18n("common_text_3302")
	i18n("common_text_3302").className = "mainUI"
	i18n("common_text_3302").itemName = "bottomAllianceBtn"
	i18n("common_text_3302").z = 3
	self:insertPileLine(MildGuideConfig.PileModel.PanelShow, i18n("common_text_3302"))
	if GLOBAL_GAME_ALLIANCE_MODE then
		_ENV = i18n("common_text_3302")
		i18n("common_text_3302").className = "allianceMainView"
		i18n("common_text_3302").itemName = "allianceMenuSingle"
		i18n("common_text_3302").index = ALLIANCE_MAIN_MENU_TYPE.HUNT
		self:insertPileLine(MildGuideConfig.PileModel.PanelShow, i18n("common_text_3302"))
	else
		_ENV = i18n("common_text_3302")
		i18n("common_text_3302").className = "allianceMainView"
		i18n("common_text_3302").itemName = "allianceMenuSingle"
		i18n("common_text_3302").index = ALLIANCE_MAIN_MENU_TYPE.HUNT
		i18n("common_text_3302").z = 5
		self:insertPileLine(MildGuideConfig.PileModel.PanelShow, i18n("common_text_3302"))
	end
	self:star()
end
function mildGuideManager:starToTroopFlag(data)
	self:clean()
	_ENV = nil
	;(nil).needCity = true
	self:needVerify(nil)
	local cityBuildConstDef = include("cityBuildConstDef")
	_ENV = nil
	;(nil).index = cityBuildConstDef.buildIndexDef.index_TroopFlag
	;(nil).z = 1
	self:insertPileLine(MildGuideConfig.PileModel.IndexMove, nil)
	self:star()
end
function mildGuideManager:starToHeroTrain(data)
	self:clean()
	_ENV = nil
	;(nil).needCity = true
	self:needVerify(nil)
	_ENV = nil
	;(nil).bid = BUILDID.HERO_TRAIN_GROUND
	if not self:needVerify(nil) then
		_ENV = nil
		;(nil).bid = BUILDID.HERO_TRAIN_GROUND
		self:starToBuild(nil, true)
	end
	_ENV = true
	;(true).bid = BUILDID.HERO_TRAIN_GROUND
	;(true).isSelected = true
	self:insertPileLine(MildGuideConfig.PileModel.BuildMove, true)
	_ENV = true
	;(true).className = "mainCityView"
	_ENV, (true).itemName = BUILDID.HERO_TRAIN_GROUND, "tip"
	BUILDID.HERO_TRAIN_GROUND.bid = BUILDID.HERO_TRAIN_GROUND
	BUILDID.HERO_TRAIN_GROUND.key = "OpTrainHall"
	;(true).data, BUILDID.HERO_TRAIN_GROUND.queuePriority = BUILDID.HERO_TRAIN_GROUND, true
	self:insertPileLine(MildGuideConfig.PileModel.BuildTip, true)
	self:star()
end
function mildGuideManager:starToHeroPrison(data)
	self:clean()
	MildGuideConfig = nil
	;(nil).needCity = true
	self:needVerify(nil)
	MildGuideConfig = nil
	;(nil).bid = BUILDID.HERO_PRISON
	;(nil).isSelected = true
	self:insertPileLine(MildGuideConfig.PileModel.BuildMove, nil)
	MildGuideConfig = nil
	;(nil).className = "mainCityView"
	MildGuideConfig, (nil).itemName = BUILDID.HERO_PRISON, "tip"
	BUILDID.HERO_PRISON.bid = BUILDID.HERO_PRISON
	BUILDID.HERO_PRISON.key = "OpPrison"
	;(nil).data, BUILDID.HERO_PRISON.queuePriority = BUILDID.HERO_PRISON, true
	self:insertPileLine(MildGuideConfig.PileModel.BuildTip, nil)
	self:star()
end
function mildGuideManager:starToAllianceDonate(data)
	if worldMapDefine.isInKingdomBattle() then
		SoraDShowMsgTip(i18n("common_text_3302"))
		return true, true
	end
	_ENV = i18n("common_text_3302")
	i18n("common_text_3302").className = "mainUI"
	i18n("common_text_3302").itemName = "bottomAllianceBtn"
	i18n("common_text_3302").z = 3
	self:insertPileLine(MildGuideConfig.PileModel.PanelShow, i18n("common_text_3302"))
	if GLOBAL_GAME_ALLIANCE_MODE then
		_ENV = i18n("common_text_3302")
		i18n("common_text_3302").className = "allianceMainView"
		i18n("common_text_3302").itemName = "allianceMenuSingle"
		i18n("common_text_3302").index = ALLIANCE_MAIN_MENU_TYPE.SCIENCE
		self:insertPileLine(MildGuideConfig.PileModel.PanelShow, i18n("common_text_3302"))
	else
		_ENV = i18n("common_text_3302")
		i18n("common_text_3302").className = "allianceMainView"
		i18n("common_text_3302").itemName = "allianceMenuSingle"
		i18n("common_text_3302").index = ALLIANCE_MAIN_MENU_TYPE.SCIENCE
		i18n("common_text_3302").z = 5
		self:insertPileLine(MildGuideConfig.PileModel.PanelShow, i18n("common_text_3302"))
	end
	self:star()
end
function mildGuideManager:starToUnlockQuenching(data)
	self:clean()
	MildGuideConfig = nil
	;(nil).needCity = true
	self:needVerify(nil)
	MildGuideConfig = nil
	;(nil).bid = BUILDID.BLACK_SMITH
	;(nil).isSelected = true
	self:insertPileLine(MildGuideConfig.PileModel.BuildMove, nil)
	MildGuideConfig = nil
	;(nil).className = "mainCityView"
	MildGuideConfig, (nil).itemName = BUILDID.BLACK_SMITH, "tip"
	BUILDID.BLACK_SMITH.bid = BUILDID.BLACK_SMITH
	BUILDID.BLACK_SMITH.key = "OpArtifact"
	;(nil).data, BUILDID.BLACK_SMITH.queuePriority = BUILDID.BLACK_SMITH, true
	self:insertPileLine(MildGuideConfig.PileModel.BuildTip, nil)
	self:star()
end
function mildGuideManager:starToEquip(data)
	self:clean()
	MildGuideConfig = nil
	;(nil).needCity = true
	self:needVerify(nil)
	MildGuideConfig = nil
	;(nil).bid = BUILDID.BLACK_SMITH
	;(nil).isSelected = true
	self:insertPileLine(MildGuideConfig.PileModel.BuildMove, nil)
	data.id = data.id ~= nil and data.id or data.questType
	if data.id then
		if data.id == 4 then
			MildGuideConfig = nil
			;(nil).className = "mainCityView"
			MildGuideConfig, (nil).itemName = BUILDID.BLACK_SMITH, "tip"
			BUILDID.BLACK_SMITH.bid = BUILDID.BLACK_SMITH
			BUILDID.BLACK_SMITH.key = "OpStoragebox"
			;(nil).data, BUILDID.BLACK_SMITH.queuePriority = BUILDID.BLACK_SMITH, true
			self:insertPileLine(MildGuideConfig.PileModel.BuildTip, nil)
		elseif data.id == 56 then
			MildGuideConfig = nil
			;(nil).className = "mainCityView"
			MildGuideConfig, (nil).itemName = BUILDID.BLACK_SMITH, "tip"
			BUILDID.BLACK_SMITH.bid = BUILDID.BLACK_SMITH
			BUILDID.BLACK_SMITH.key = "OpArtifact"
			;(nil).data, BUILDID.BLACK_SMITH.queuePriority = BUILDID.BLACK_SMITH, true
			self:insertPileLine(MildGuideConfig.PileModel.BuildTip, nil)
		else
			MildGuideConfig = nil
			;(nil).className = "mainCityView"
			MildGuideConfig, (nil).itemName = BUILDID.BLACK_SMITH, "tip"
			BUILDID.BLACK_SMITH.bid = BUILDID.BLACK_SMITH
			BUILDID.BLACK_SMITH.key = "OpForging"
			;(nil).data, BUILDID.BLACK_SMITH.queuePriority = BUILDID.BLACK_SMITH, true
			self:insertPileLine(MildGuideConfig.PileModel.BuildTip, nil)
			if data.id == 1 then
				MildGuideConfig = nil
				;(nil).className = "smithyView"
				;(nil).itemName = "Top_Button_forge"
				self:insertPileLine(MildGuideConfig.PileModel.PanelShow, nil)
			elseif data.id == 2 then
				MildGuideConfig = nil
				;(nil).className = "smithyView"
				;(nil).itemName = "Button_intensify"
				self:insertPileLine(MildGuideConfig.PileModel.PanelShow, nil)
			elseif data.id == 3 or data.id == 21 then
				MildGuideConfig = nil
				;(nil).className = "smithyView"
				;(nil).itemName = "Center_Button_baptize"
				self:insertPileLine(MildGuideConfig.PileModel.PanelShow, nil)
			end
		end
	else
		MildGuideConfig = nil
		;(nil).className = "mainCityView"
		MildGuideConfig, (nil).itemName = BUILDID.BLACK_SMITH, "tip"
		BUILDID.BLACK_SMITH.bid = BUILDID.BLACK_SMITH
		BUILDID.BLACK_SMITH.key = "OpForging"
		;(nil).data, BUILDID.BLACK_SMITH.queuePriority = BUILDID.BLACK_SMITH, true
		self:insertPileLine(MildGuideConfig.PileModel.BuildTip, nil)
	end
	self:star()
end
_ENV, _UPVALUE6_, mildGuideManager.starToAddFriends = LocalTblPath, function(self, data)
	self:clean()
	local cityBuildConstDef = include("cityBuildConstDef")
	_ENV = nil
	;(nil).index = cityBuildConstDef.OtherBuildDef.LeisureCenter
	;(nil).z = 1
	self:insertPileLine(MildGuideConfig.PileModel.IndexMove, nil)
	_ENV = nil
	;(nil).className = "mainCityView"
	_ENV, (nil).itemName = cityBuildConstDef.OtherBuildDef.LeisureCenter, "tip"
	cityBuildConstDef.OtherBuildDef.LeisureCenter.bid = 30001
	;(nil).data, cityBuildConstDef.OtherBuildDef.LeisureCenter.key = cityBuildConstDef.OtherBuildDef.LeisureCenter, "OpFriend"
	self:insertPileLine(MildGuideConfig.PileModel.BuildTip, nil)
	self:star()
end, function(self, data)
	self:clean()
	local cityBuildConstDef = include("cityBuildConstDef")
	_ENV = nil
	;(nil).index = cityBuildConstDef.OtherBuildDef.LeisureCenter
	;(nil).z = 1
	self:insertPileLine(MildGuideConfig.PileModel.IndexMove, nil)
	_ENV = nil
	;(nil).className = "mainCityView"
	_ENV, (nil).itemName = cityBuildConstDef.OtherBuildDef.LeisureCenter, "tip"
	cityBuildConstDef.OtherBuildDef.LeisureCenter.bid = 30001
	;(nil).data, cityBuildConstDef.OtherBuildDef.LeisureCenter.key = cityBuildConstDef.OtherBuildDef.LeisureCenter, "OpFriend"
	self:insertPileLine(MildGuideConfig.PileModel.BuildTip, nil)
	self:star()
end
LocalTblPath.className = "mainUI"
LocalTblPath.itemName = "Button_event"
LocalTblPath.z = 3
_ENV, LocalTblPath.done = ".config_client.gameMildGuideConfig", false
;(".config_client.gameMildGuideConfig").className = "EventCenterView"
;(".config_client.gameMildGuideConfig").itemName = "eventCenterSingle"
;(".config_client.gameMildGuideConfig").z = 3
;(".config_client.gameMildGuideConfig").eid = gActivityTimeActivityID.HERO_TRIAL
_ENV, (".config_client.gameMildGuideConfig").done = gActivityTimeActivityID.HERO_TRIAL, false
gActivityTimeActivityID.HERO_TRIAL.className = "heroTrialView"
gActivityTimeActivityID.HERO_TRIAL.itemName = "challengeBtn"
gActivityTimeActivityID.HERO_TRIAL.z = 3
_ENV, gActivityTimeActivityID.HERO_TRIAL.done = nil, false
;(nil).className = "heroTrialArea"
;(nil).itemName = "challenge"
;(nil).z = 3
_ENV, (nil).done = nil, false
;(nil).className = "heroTrialMapView"
;(nil).itemName = "challenge"
;(nil).z = 4
_ENV, (nil).done = nil, false
;(nil).className = "heroTrialLevelInfo"
;(nil).itemName = "Button_attack"
;(nil).z = 0
;(nil).done = false
;(function(self, data)
	self:clean()
	local cityBuildConstDef = include("cityBuildConstDef")
	_ENV = nil
	;(nil).index = cityBuildConstDef.OtherBuildDef.LeisureCenter
	;(nil).z = 1
	self:insertPileLine(MildGuideConfig.PileModel.IndexMove, nil)
	_ENV = nil
	;(nil).className = "mainCityView"
	_ENV, (nil).itemName = cityBuildConstDef.OtherBuildDef.LeisureCenter, "tip"
	cityBuildConstDef.OtherBuildDef.LeisureCenter.bid = 30001
	;(nil).data, cityBuildConstDef.OtherBuildDef.LeisureCenter.key = cityBuildConstDef.OtherBuildDef.LeisureCenter, "OpFriend"
	self:insertPileLine(MildGuideConfig.PileModel.BuildTip, nil)
	self:star()
end)[1] = LocalTblPath
;(function(self, data)
	self:clean()
	local cityBuildConstDef = include("cityBuildConstDef")
	_ENV = nil
	;(nil).index = cityBuildConstDef.OtherBuildDef.LeisureCenter
	;(nil).z = 1
	self:insertPileLine(MildGuideConfig.PileModel.IndexMove, nil)
	_ENV = nil
	;(nil).className = "mainCityView"
	_ENV, (nil).itemName = cityBuildConstDef.OtherBuildDef.LeisureCenter, "tip"
	cityBuildConstDef.OtherBuildDef.LeisureCenter.bid = 30001
	;(nil).data, cityBuildConstDef.OtherBuildDef.LeisureCenter.key = cityBuildConstDef.OtherBuildDef.LeisureCenter, "OpFriend"
	self:insertPileLine(MildGuideConfig.PileModel.BuildTip, nil)
	self:star()
end)[2] = ".config_client.gameMildGuideConfig"
;(function(self, data)
	self:clean()
	local cityBuildConstDef = include("cityBuildConstDef")
	_ENV = nil
	;(nil).index = cityBuildConstDef.OtherBuildDef.LeisureCenter
	;(nil).z = 1
	self:insertPileLine(MildGuideConfig.PileModel.IndexMove, nil)
	_ENV = nil
	;(nil).className = "mainCityView"
	_ENV, (nil).itemName = cityBuildConstDef.OtherBuildDef.LeisureCenter, "tip"
	cityBuildConstDef.OtherBuildDef.LeisureCenter.bid = 30001
	;(nil).data, cityBuildConstDef.OtherBuildDef.LeisureCenter.key = cityBuildConstDef.OtherBuildDef.LeisureCenter, "OpFriend"
	self:insertPileLine(MildGuideConfig.PileModel.BuildTip, nil)
	self:star()
end)[3] = gActivityTimeActivityID.HERO_TRIAL
;(function(self, data)
	self:clean()
	local cityBuildConstDef = include("cityBuildConstDef")
	_ENV = nil
	;(nil).index = cityBuildConstDef.OtherBuildDef.LeisureCenter
	;(nil).z = 1
	self:insertPileLine(MildGuideConfig.PileModel.IndexMove, nil)
	_ENV = nil
	;(nil).className = "mainCityView"
	_ENV, (nil).itemName = cityBuildConstDef.OtherBuildDef.LeisureCenter, "tip"
	cityBuildConstDef.OtherBuildDef.LeisureCenter.bid = 30001
	;(nil).data, cityBuildConstDef.OtherBuildDef.LeisureCenter.key = cityBuildConstDef.OtherBuildDef.LeisureCenter, "OpFriend"
	self:insertPileLine(MildGuideConfig.PileModel.BuildTip, nil)
	self:star()
end)[4] = nil
;(function(self, data)
	self:clean()
	local cityBuildConstDef = include("cityBuildConstDef")
	_ENV = nil
	;(nil).index = cityBuildConstDef.OtherBuildDef.LeisureCenter
	;(nil).z = 1
	self:insertPileLine(MildGuideConfig.PileModel.IndexMove, nil)
	_ENV = nil
	;(nil).className = "mainCityView"
	_ENV, (nil).itemName = cityBuildConstDef.OtherBuildDef.LeisureCenter, "tip"
	cityBuildConstDef.OtherBuildDef.LeisureCenter.bid = 30001
	;(nil).data, cityBuildConstDef.OtherBuildDef.LeisureCenter.key = cityBuildConstDef.OtherBuildDef.LeisureCenter, "OpFriend"
	self:insertPileLine(MildGuideConfig.PileModel.BuildTip, nil)
	self:star()
end)[5] = nil
local (function(self, data)
	self:clean()
	local cityBuildConstDef = include("cityBuildConstDef")
	_ENV = nil
	;(nil).index = cityBuildConstDef.OtherBuildDef.LeisureCenter
	;(nil).z = 1
	self:insertPileLine(MildGuideConfig.PileModel.IndexMove, nil)
	_ENV = nil
	;(nil).className = "mainCityView"
	_ENV, (nil).itemName = cityBuildConstDef.OtherBuildDef.LeisureCenter, "tip"
	cityBuildConstDef.OtherBuildDef.LeisureCenter.bid = 30001
	;(nil).data, cityBuildConstDef.OtherBuildDef.LeisureCenter.key = cityBuildConstDef.OtherBuildDef.LeisureCenter, "OpFriend"
	self:insertPileLine(MildGuideConfig.PileModel.BuildTip, nil)
	self:star()
end)[6], armyTrialList = nil, function(self, data)
	self:clean()
	local cityBuildConstDef = include("cityBuildConstDef")
	_ENV = nil
	;(nil).index = cityBuildConstDef.OtherBuildDef.LeisureCenter
	;(nil).z = 1
	self:insertPileLine(MildGuideConfig.PileModel.IndexMove, nil)
	_ENV = nil
	;(nil).className = "mainCityView"
	_ENV, (nil).itemName = cityBuildConstDef.OtherBuildDef.LeisureCenter, "tip"
	cityBuildConstDef.OtherBuildDef.LeisureCenter.bid = 30001
	;(nil).data, cityBuildConstDef.OtherBuildDef.LeisureCenter.key = cityBuildConstDef.OtherBuildDef.LeisureCenter, "OpFriend"
	self:insertPileLine(MildGuideConfig.PileModel.BuildTip, nil)
	self:star()
end
function mildGuideManager:starToArmyTrial(data)
	if worldMapDefine.isInKingdomBattle() then
		SoraDShowMsgTip(i18n("common_text_3302"))
		return true, true
	end
	if data and data.isNewTrial then
		self:starToArmyTrialInActivity(data)
	else
		self:starToActivity(data)
	end
end
function mildGuideManager:starToArmyTrialInActivity(data)
	self:clean()
	MildGuideConfig = nil
	;(nil).className = "mainUI"
	;(nil).itemName = "Button_event"
	;(nil).z = 3
	;(nil).done = false
	self:insertPileLine(MildGuideConfig.PileModel.PanelShow, nil)
	MildGuideConfig = nil
	;(nil).chooseId = gActivityTimeActivityID.HERO_TRIAL
	self:setVariate("EventCenterView", nil)
	MildGuideConfig = nil
	;(nil).className = "EventCenterView"
	;(nil).itemName = "eventCenterSingle"
	;(nil).z = 3
	;(nil).scaleX = 1.5
	;(nil).scaleY = 1.5
	;(nil).offset = cc.p(0, 20)
	;(nil).eid = gActivityTimeActivityID.HERO_TRIAL
	;(nil).done = false
	self:insertPileLine(MildGuideConfig.PileModel.PanelShow, nil)
	MildGuideConfig = nil
	;(nil).className = "EventCenterView"
	;(nil).itemName = "eventCenterSingle"
	;(nil).z = 3
	;(nil).scaleX = 1.5
	;(nil).scaleY = 1.5
	;(nil).offset = cc.p(0, 20)
	;(nil).eid = gActivityTimeActivityID.HERO_TRIAL
	;(nil).done = false
	self:insertPileLine(MildGuideConfig.PileModel.PanelShow, nil)
	MildGuideConfig = nil
	;(nil).className = "heroTrialView"
	;(nil).itemName = "challengeBtn"
	;(nil).z = 3
	;(nil).done = false
	self:insertPileLine(MildGuideConfig.PileModel.PanelShow, nil)
	MildGuideConfig = nil
	;(nil).className = "heroTrialArea"
	;(nil).itemName = "challenge"
	;(nil).z = 3
	;(nil).done = false
	self:insertPileLine(MildGuideConfig.PileModel.PanelShow, nil)
	MildGuideConfig = nil
	;(nil).className = "heroTrialMapView"
	;(nil).itemName = "challenge"
	;(nil).z = 2
	;(nil).done = false
	self:insertPileLine(MildGuideConfig.PileModel.PanelShow, nil)
	MildGuideConfig = nil
	;(nil).className = "heroTrialLevelInfo"
	;(nil).itemName = "Button_attack"
	;(nil).z = 0
	;(nil).done = false
	self:insertPileLine(MildGuideConfig.PileModel.PanelShow, nil)
	self:star()
end
function mildGuideManager:starToActivity(data)
	self:clean()
	local waityDelay = data and data.waitDelay or nil
	MildGuideConfig = nil
	;(nil).className = "mainUI"
	;(nil).itemName = "Button_event"
	;(nil).z = 3
	;(nil).waityDelay = waityDelay
	self:insertPileLine(MildGuideConfig.PileModel.PanelShow, nil, true)
	self:star()
	return true, false
end
function mildGuideManager:starToBagShopCenter(data)
	self:clean()
	MildGuideConfig = nil
	;(nil).className = "mainUI"
	;(nil).itemName = "bottomItemsBtn"
	;(nil).z = 3
	self:insertPileLine(MildGuideConfig.PileModel.PanelShow, nil, true)
	MildGuideConfig = nil
	;(nil).className = "bagView"
	;(nil).itemName = "Button_shop"
	;(nil).z = 3
	self:insertPileLine(MildGuideConfig.PileModel.PanelShow, nil)
	self:star()
end
function mildGuideManager:jumpToServerLevelBuild(data)
	self:clean()
	MildGuideConfig = nil
	;(nil).className = "worldMapView"
	;(nil).itemName = nil
	MildGuideConfig, (nil).autoNext = SoraDCurrentSceneShowView("worldMapView") ~= nil, SoraDCurrentSceneShowView("worldMapView") ~= nil
	;(SoraDCurrentSceneShowView("worldMapView") ~= nil).name = "worldMapView"
	;(SoraDCurrentSceneShowView("worldMapView") ~= nil).jump = true
	;(nil).action, (SoraDCurrentSceneShowView("worldMapView") ~= nil).pos = SoraDCurrentSceneShowView("worldMapView") ~= nil, cc.p(600, 604)
	self:insertPileLine(MildGuideConfig.PileModel.PanelShow, nil)
	MildGuideConfig = nil
	;(nil).className = "worldMapView"
	;(nil).itemName = "serverLevelBuild"
	;(nil).again = 5
	;(nil).delayTime = 1
	;(nil).offset = cc.p(120, 20)
	self:insertPileLine(MildGuideConfig.PileModel.PanelShow, nil)
	self:star()
end
function mildGuideManager:starToQuickToWorld(data)
	self:clean()
	if SoraDCurrentSceneShowView("worldMapView") == nil then
		_ENV = nil
		;(nil).className = "worldMapView"
		_ENV, (nil).itemName = nil, nil
		;(nil).name = "worldMapView"
		;(nil).action, (nil).jump = nil, true
		self:insertPileLine(MildGuideConfig.PileModel.PanelShow, nil)
	end
	if data.msg then
		_ENV = nil
		;(nil).className = "worldMapView"
		_ENV, (nil).itemName = nil, nil
		;(nil).name = "msg"
		;(nil).action, (nil).msg = nil, data.msg
		self:insertPileLine(MildGuideConfig.PileModel.PanelShow, nil)
	end
	if data.callFunc then
		_ENV = nil
		;(nil).className = "worldMapView"
		_ENV, (nil).itemName = nil, nil
		;(nil).name = "callFunc"
		;(nil).targetName = "worldMapView"
		;(nil).callFunc = data.callFunc
		;(nil).action, (nil).data = nil, data.data
		self:insertPileLine(MildGuideConfig.PileModel.PanelShow, nil)
	end
	self:star()
end
function mildGuideManager:starToQuickToWorldKillMonster(data)
	self:clean()
	if SoraDCurrentSceneShowView("worldMapView") == nil then
		_ENV = nil
		;(nil).className = "worldMapView"
		_ENV, (nil).itemName = nil, nil
		;(nil).name = "worldMapView"
		;(nil).action, (nil).jump = nil, true
		self:insertPileLine(MildGuideConfig.PileModel.PanelShow, nil)
	end
	_ENV = nil
	;(nil).chooseIndex = data.chooseIndex or 1
	self:setVariate("worldMapMonsterSearch", nil)
	if data.activityID then
		_ENV = nil
		;(nil).activityID = data.activityID
		self:setVariate("worldMapMonsterSearch", nil)
	end
	_ENV = nil
	;(nil).className = "worldMapView"
	;(nil).itemName = "Button_monsterSearch"
	;(nil).z = 1
	self:insertPileLine(MildGuideConfig.PileModel.PanelShow, nil)
	self:star()
end
function mildGuideManager:quickToWorldKillMonster(data)
	self:clean()
	if SoraDCurrentSceneShowView("worldMapView") == nil then
		_ENV = nil
		;(nil).className = "worldMapView"
		_ENV, (nil).itemName = nil, nil
		;(nil).name = "worldMapView"
		;(nil).action, (nil).jump = nil, true
		self:insertPileLine(MildGuideConfig.PileModel.PanelShow, nil)
	end
	_ENV = nil
	_ENV, (nil).className = nil, "worldMapView"
	;(nil).name = "callFunc"
	;(nil).targetName = "worldMapView"
	_ENV, (nil).callFunc = nil, "gameGuide_callFunc_openMonsterSearch"
	;(nil).action, (nil).data, (nil).chooseIndex = nil, nil, data.chooseIndex or 1
	self:insertPileLine(MildGuideConfig.PileModel.PanelShow, nil)
	_ENV = nil
	;(nil).chooseIndex = data.chooseIndex or 1
	self:setVariate("worldMapMonsterSearch", nil)
	self:star()
end
function mildGuideManager:starToQuickToWorldCollectResource(data)
	self:clean()
	if SoraDCurrentSceneShowView("worldMapView") == nil then
		_ENV = nil
		;(nil).className = "worldMapView"
		_ENV, (nil).itemName = nil, nil
		;(nil).name = "worldMapView"
		;(nil).action, (nil).jump = nil, true
		self:insertPileLine(MildGuideConfig.PileModel.PanelShow, nil)
	end
	_ENV = nil
	;(nil).className = "worldMapView"
	;(nil).itemName = "Button_monsterSearch"
	;(nil).z = 1
	self:insertPileLine(MildGuideConfig.PileModel.PanelShow, nil)
	_ENV = nil
	;(nil).chooseIndex = 3
	self:setVariate("worldMapMonsterSearch", nil)
	self:star()
end
function mildGuideManager:starToQuickToWorldCollectLostRuins(data)
	self:clean()
	if SoraDCurrentSceneShowView("worldMapView") == nil then
		_ENV = nil
		;(nil).className = "worldMapView"
		_ENV, (nil).itemName = nil, nil
		;(nil).name = "worldMapView"
		;(nil).action, (nil).jump = nil, true
		self:insertPileLine(MildGuideConfig.PileModel.PanelShow, nil)
	end
	_ENV = nil
	;(nil).className = "worldMapView"
	;(nil).itemName = "Button_monsterSearch"
	;(nil).z = 1
	self:insertPileLine(MildGuideConfig.PileModel.PanelShow, nil)
	_ENV = nil
	;(nil).chooseIndex = 15
	self:setVariate("worldMapMonsterSearch", nil)
	self:star()
end
function mildGuideManager:starToQuickToWorldCollectWindTower(data)
	self:clean()
	if SoraDCurrentSceneShowView("worldMapView") == nil then
		_ENV = nil
		;(nil).className = "worldMapView"
		_ENV, (nil).itemName = nil, nil
		;(nil).name = "worldMapView"
		;(nil).action, (nil).jump = nil, true
		self:insertPileLine(MildGuideConfig.PileModel.PanelShow, nil)
	end
	_ENV = nil
	;(nil).className = "worldMapView"
	;(nil).itemName = "Button_monsterSearch"
	;(nil).z = 1
	self:insertPileLine(MildGuideConfig.PileModel.PanelShow, nil)
	_ENV = nil
	;(nil).chooseIndex = 16
	self:setVariate("worldMapMonsterSearch", nil)
	self:star()
end
function mildGuideManager:starToQuickToWorldSnowWolfLost(data)
	self:clean()
	if SoraDCurrentSceneShowView("worldMapView") == nil then
		_ENV = nil
		;(nil).className = "worldMapView"
		_ENV, (nil).itemName = nil, nil
		;(nil).name = "worldMapView"
		;(nil).action, (nil).jump = nil, true
		self:insertPileLine(MildGuideConfig.PileModel.PanelShow, nil)
	end
	_ENV = nil
	;(nil).className = "worldMapView"
	;(nil).itemName = "Button_monsterSearch"
	;(nil).z = 1
	self:insertPileLine(MildGuideConfig.PileModel.PanelShow, nil)
	_ENV = nil
	;(nil).chooseIndex = 20
	self:setVariate("worldMapMonsterSearch", nil)
	self:star()
end
function mildGuideManager:starToQuickToWorldIcedragonLost(data)
	self:clean()
	if SoraDCurrentSceneShowView("worldMapView") == nil then
		_ENV = nil
		;(nil).className = "worldMapView"
		_ENV, (nil).itemName = nil, nil
		;(nil).name = "worldMapView"
		;(nil).action, (nil).jump = nil, true
		self:insertPileLine(MildGuideConfig.PileModel.PanelShow, nil)
	end
	_ENV = nil
	;(nil).className = "worldMapView"
	;(nil).itemName = "Button_monsterSearch"
	;(nil).z = 1
	self:insertPileLine(MildGuideConfig.PileModel.PanelShow, nil)
	_ENV = nil
	;(nil).chooseIndex = 22
	self:setVariate("worldMapMonsterSearch", nil)
	self:star()
end
function mildGuideManager:starToQuickToWorldLegendOfPegasus(data)
	self:clean()
	if SoraDCurrentSceneShowView("worldMapView") == nil then
		_ENV = nil
		;(nil).className = "worldMapView"
		_ENV, (nil).itemName = nil, nil
		;(nil).name = "worldMapView"
		;(nil).action, (nil).jump = nil, true
		self:insertPileLine(MildGuideConfig.PileModel.PanelShow, nil)
	end
	_ENV = nil
	;(nil).className = "worldMapView"
	;(nil).itemName = "Button_monsterSearch"
	;(nil).z = 1
	self:insertPileLine(MildGuideConfig.PileModel.PanelShow, nil)
	_ENV = nil
	;(nil).chooseIndex = 23
	self:setVariate("worldMapMonsterSearch", nil)
	self:star()
end
function mildGuideManager:starToQuickToWorldStronghold(data)
	self:clean()
	if SoraDCurrentSceneShowView("worldMapView") == nil then
		_ENV = nil
		;(nil).className = "worldMapView"
		_ENV, (nil).itemName = nil, nil
		;(nil).name = "worldMapView"
		;(nil).action, (nil).jump = nil, true
		self:insertPileLine(MildGuideConfig.PileModel.PanelShow, nil)
	end
	local pos = include("allianceStrongholdMineRead").getShortestPosByType(SoraDGetCtrl("cityCtrl"):getCurCityPos(), tonumber(data.level))
	print(pos, "starToQuickToWorldStronghold")
	_ENV = tonumber(data.level)
	_ENV, tonumber(data.level).className = tonumber(data.level)
	tonumber(data.level).name = "callFunc"
	tonumber(data.level).targetName = "worldMapView"
	_ENV, tonumber(data.level).callFunc = tonumber(data.level)
	tonumber(data.level).action, tonumber(data.level).data, tonumber(data.level).pos = tonumber(data.level)
	self:insertPileLine(MildGuideConfig.PileModel.PanelShow, tonumber(data.level))
	self:star()
end
function mildGuideManager:starToWearEquipment(data)
	self:clean()
	MildGuideConfig = nil
	;(nil).className = "mainUI"
	;(nil).itemName = "topHeadFrame"
	;(nil).z = 3
	self:insertPileLine(MildGuideConfig.PileModel.PanelShow, nil)
	self:star()
end
function mildGuideManager:starToHeroUpgrade(data)
	self:clean()
	MildGuideConfig = nil
	;(nil).className = "newHeroDetailView"
	;(nil).itemName = "feedHeroEXP"
	;(nil).z = 3
	self:insertPileLine(MildGuideConfig.PileModel.PanelShow, nil)
	self:star()
end
function mildGuideManager:starToHeroUpQuality(data)
	self:clean()
	MildGuideConfig = nil
	;(nil).className = "mainUI"
	;(nil).itemName = "bottomHeroBtn"
	;(nil).z = 3
	;(nil).waitDelay = 15
	;(nil).again = 5
	;(nil).delayTime = 5
	self:insertPileLine(MildGuideConfig.PileModel.PanelShow, nil)
	MildGuideConfig = nil
	;(nil).className = "newHeroListView"
	;(nil).itemName = "heroListCanUpHero"
	;(nil).z = 1
	self:insertPileLine(MildGuideConfig.PileModel.PanelShow, nil)
	MildGuideConfig = nil
	;(nil).className = "newHeroDetailView"
	;(nil).itemName = "Button_upgrade"
	;(nil).z = 2
	self:insertPileLine(MildGuideConfig.PileModel.PanelShow, nil)
	self:star()
end
function mildGuideManager:starToHeroUnlockQuality(data)
	self:clean()
	MildGuideConfig = nil
	;(nil).className = "newHeroListView"
	;(nil).itemName = "heroListUnlockHero"
	;(nil).z = 1
	;(nil).heroID = data and data.heroID
	self:insertPileLine(MildGuideConfig.PileModel.PanelShow, nil)
	MildGuideConfig = nil
	;(nil).className = "newHeroDetailView"
	;(nil).itemName = "chipItem"
	;(nil).z = 1
	self:insertPileLine(MildGuideConfig.PileModel.PanelShow, nil)
	self:star()
end
function mildGuideManager:starToHeroClick(data)
	self:clean()
	MildGuideConfig = nil
	;(nil).className = "newHeroListView"
	;(nil).itemName = "heroListClick"
	;(nil).z = 1
	;(nil).heroID = data and data.heroID
	self:insertPileLine(MildGuideConfig.PileModel.PanelShow, nil)
	self:star()
end
function mildGuideManager:starToHeroUnlockOneStep(data)
	self:clean()
	MildGuideConfig = nil
	;(nil).className = "mainUI"
	;(nil).itemName = "bottomHeroBtn"
	;(nil).z = 3
	;(nil).waitDelay = 15
	;(nil).again = 5
	;(nil).delayTime = 5
	self:insertPileLine(MildGuideConfig.PileModel.PanelShow, nil)
	self:star()
end
function mildGuideManager:starToRechargeGold(data)
	self:clean()
	MildGuideConfig = nil
	;(nil).className = "mainUI"
	;(nil).itemName = "Button_gold"
	;(nil).z = 3
	self:insertPileLine(MildGuideConfig.PileModel.PanelShow, nil, true)
	self:star()
end
function mildGuideManager:starToRechargeMonthWeek(data)
	self:clean()
	MildGuideConfig = nil
	;(nil).className = "mainUI"
	;(nil).itemName = "Button_gold"
	;(nil).z = 3
	self:insertPileLine(MildGuideConfig.PileModel.PanelShow, nil, true)
	MildGuideConfig = nil
	;(nil).className = "rechargeView"
	;(nil).itemName = "rechargeMonth"
	;(nil).z = 1
	self:insertPileLine(MildGuideConfig.PileModel.PanelShow, nil)
	self:star()
end
function mildGuideManager:starToSuperVip(data)
	self:clean()
	_ENV = nil
	;(nil).needCity = true
	self:needVerify(nil)
	local cityBuildConstDef = include("cityBuildConstDef")
	_ENV = nil
	;(nil).index = cityBuildConstDef.fixedBuildDef.HuoChuang
	;(nil).isSelected = true
	self:insertPileLine(MildGuideConfig.PileModel.IndexMove, nil)
	_ENV = nil
	;(nil).className = "mainCityView"
	_ENV, (nil).itemName = cityBuildConstDef.fixedBuildDef.HuoChuang, "tip"
	cityBuildConstDef.fixedBuildDef.HuoChuang.bid = cityBuildConstDef.fixedBuildDef.HuoChuang
	cityBuildConstDef.fixedBuildDef.HuoChuang.key = "OpExclusiveVip"
	;(nil).data, cityBuildConstDef.fixedBuildDef.HuoChuang.queuePriority = cityBuildConstDef.fixedBuildDef.HuoChuang, true
	self:insertPileLine(MildGuideConfig.PileModel.BuildTip, nil)
	self:star()
end
function mildGuideManager:starToNebulaTech(data)
	self:clean()
	_ENV = nil
	;(nil).needCity = true
	self:needVerify(nil)
	_ENV = nil
	;(nil).bid = BUILDID.NEBULA_PALACE
	if not self:needVerify(nil) then
		return true, true
	end
	_ENV = BUILDID.NEBULA_PALACE
	BUILDID.NEBULA_PALACE.bid = BUILDID.NEBULA_PALACE
	BUILDID.NEBULA_PALACE.isSelected = true
	self:insertPileLine(MildGuideConfig.PileModel.BuildMove, BUILDID.NEBULA_PALACE)
	_ENV = BUILDID.NEBULA_PALACE
	BUILDID.NEBULA_PALACE.className = "mainCityView"
	_ENV, BUILDID.NEBULA_PALACE.itemName = BUILDID.NEBULA_PALACE, "tip"
	BUILDID.NEBULA_PALACE.bid = BUILDID.NEBULA_PALACE
	BUILDID.NEBULA_PALACE.data, BUILDID.NEBULA_PALACE.key = BUILDID.NEBULA_PALACE, "OpNebulaTechnology"
	self:insertPileLine(MildGuideConfig.PileModel.BuildTip, BUILDID.NEBULA_PALACE)
	self:star()
end
function mildGuideManager:starToMeteoriteMagic(data)
	self:clean()
	_ENV = nil
	;(nil).needCity = true
	self:needVerify(nil)
	_ENV = nil
	;(nil).bid = BUILDID.NEBULA_PALACE
	if not self:needVerify(nil) then
		return true, true
	end
	_ENV = BUILDID.NEBULA_PALACE
	BUILDID.NEBULA_PALACE.bid = BUILDID.NEBULA_PALACE
	BUILDID.NEBULA_PALACE.isSelected = true
	self:insertPileLine(MildGuideConfig.PileModel.BuildMove, BUILDID.NEBULA_PALACE)
	_ENV = BUILDID.NEBULA_PALACE
	BUILDID.NEBULA_PALACE.className = "mainCityView"
	_ENV, BUILDID.NEBULA_PALACE.itemName = BUILDID.NEBULA_PALACE, "tip"
	BUILDID.NEBULA_PALACE.bid = BUILDID.NEBULA_PALACE
	BUILDID.NEBULA_PALACE.data, BUILDID.NEBULA_PALACE.key = BUILDID.NEBULA_PALACE, "OpMeteorMagic"
	self:insertPileLine(MildGuideConfig.PileModel.BuildTip, BUILDID.NEBULA_PALACE)
	self:star()
end
function mildGuideManager:starToDivineBeast(data)
	self:clean()
	MildGuideConfig = nil
	;(nil).needCity = true
	self:needVerify(nil)
	MildGuideConfig = nil
	;(nil).bid = BUILDID.NEWBORN_TREE
	;(nil).isSelected = true
	self:insertPileLine(MildGuideConfig.PileModel.BuildMove, nil)
	MildGuideConfig = nil
	;(nil).className = "mainCityView"
	MildGuideConfig, (nil).itemName = BUILDID.NEWBORN_TREE, "tip"
	BUILDID.NEWBORN_TREE.bid = BUILDID.NEWBORN_TREE
	;(nil).data, BUILDID.NEWBORN_TREE.key = BUILDID.NEWBORN_TREE, "OpNewbornTreeBeast"
	self:insertPileLine(MildGuideConfig.PileModel.BuildTip, nil)
	self:star()
end
function mildGuideManager:starTo9001547(data)
	self:clean()
	MildGuideConfig = nil
	;(nil).needCity = true
	self:needVerify(nil)
	MildGuideConfig = nil
	;(nil).bid = BUILDID.NEWBORN_TREE
	;(nil).isSelected = true
	self:insertPileLine(MildGuideConfig.PileModel.BuildMove, nil)
	local key = data.key or BOP_NAME.BOP_NEWBORN_BEAST_CANYON
	MildGuideConfig = BUILDID.NEWBORN_TREE
	BUILDID.NEWBORN_TREE.className = "mainCityView"
	MildGuideConfig, BUILDID.NEWBORN_TREE.itemName = nil, "tip"
	;(nil).bid = BUILDID.NEWBORN_TREE
	BUILDID.NEWBORN_TREE.data, (nil).key = nil, key
	self:insertPileLine(MildGuideConfig.PileModel.BuildTip, BUILDID.NEWBORN_TREE)
	self:star()
end
function mildGuideManager:starToAllianceHelp(data)
	self:clean()
	MildGuideConfig = nil
	;(nil).needCity = true
	self:needVerify(nil)
	MildGuideConfig = nil
	;(nil).bid = BUILDID.EMBASSY
	;(nil).isSelected = true
	self:insertPileLine(MildGuideConfig.PileModel.BuildMove, nil)
	MildGuideConfig = nil
	;(nil).className = "mainCityView"
	MildGuideConfig, (nil).itemName = BUILDID.EMBASSY, "tip"
	BUILDID.EMBASSY.bid = BUILDID.EMBASSY
	;(nil).data, BUILDID.EMBASSY.key = BUILDID.EMBASSY, "OpHelp"
	self:insertPileLine(MildGuideConfig.PileModel.BuildTip, nil)
	self:star()
end
function mildGuideManager:starToAllianceStoreHouse(data)
	self:clean()
	_ENV = nil
	;(nil).needCity = true
	self:needVerify(nil)
	_ENV = nil
	;(nil).bid = BUILDID.DEPOT
	if not self:needVerify(nil) then
		_ENV = nil
		;(nil).bid = BUILDID.DEPOT
		self:starToBuild(nil, true)
	end
	_ENV = true
	;(true).bid = BUILDID.DEPOT
	;(true).isSelected = true
	self:insertPileLine(MildGuideConfig.PileModel.BuildMove, true)
	_ENV = true
	;(true).className = "mainCityView"
	_ENV, (true).itemName = BUILDID.DEPOT, "tip"
	BUILDID.DEPOT.bid = BUILDID.DEPOT
	BUILDID.DEPOT.key = "OpAllianceTreasure"
	;(true).data, BUILDID.DEPOT.queuePriority = BUILDID.DEPOT, true
	self:insertPileLine(MildGuideConfig.PileModel.BuildTip, true)
	self:star()
end
function mildGuideManager:starToHospital(data)
	self:clean()
	_ENV = nil
	;(nil).needCity = true
	self:needVerify(nil)
	_ENV = nil
	;(nil).bid = BUILDID.HOSTPITAL
	if not self:needVerify(nil) then
		_ENV = nil
		;(nil).bid = BUILDID.HOSTPITAL
		self:starToBuild(nil, true)
	end
	_ENV = true
	;(true).bid = BUILDID.HOSTPITAL
	;(true).isSelected = true
	self:insertPileLine(MildGuideConfig.PileModel.BuildMove, true)
	_ENV = true
	;(true).className = "mainCityView"
	_ENV, (true).itemName = BUILDID.HOSTPITAL, "tip"
	BUILDID.HOSTPITAL.bid = BUILDID.HOSTPITAL
	BUILDID.HOSTPITAL.key = "OpHeal"
	;(true).data, BUILDID.HOSTPITAL.queuePriority = BUILDID.HOSTPITAL, true
	self:insertPileLine(MildGuideConfig.PileModel.BuildTip, true)
	self:star()
end
function mildGuideManager:starToPreminumVipMall(data)
	self:clean()
	_ENV = nil
	;(nil).needCity = true
	self:needVerify(nil)
	local cityBuildConstDef = include("cityBuildConstDef")
	_ENV = nil
	;(nil).index = cityBuildConstDef.fixedBuildDef.HuoChuang
	;(nil).isSelected = true
	self:insertPileLine(MildGuideConfig.PileModel.IndexMove, nil)
	_ENV = nil
	;(nil).className = "mainCityView"
	_ENV, (nil).itemName = cityBuildConstDef.fixedBuildDef.HuoChuang, "tip"
	cityBuildConstDef.fixedBuildDef.HuoChuang.bid = cityBuildConstDef.fixedBuildDef.HuoChuang
	cityBuildConstDef.fixedBuildDef.HuoChuang.key = "OpPremiumVipMall"
	;(nil).data, cityBuildConstDef.fixedBuildDef.HuoChuang.queuePriority = cityBuildConstDef.fixedBuildDef.HuoChuang, true
	self:insertPileLine(MildGuideConfig.PileModel.BuildTip, nil)
	self:star()
end
function mildGuideManager:starResurgence(data)
	self:clean()
	local cityBuildConstDef = include("cityBuildConstDef")
	_ENV = nil
	;(nil).needCity = true
	self:needVerify(nil)
	local key = data.key or "OpResuscitate"
	_ENV = nil
	;(nil).index = cityBuildConstDef.fixedBuildDef.ResurrectionHall
	;(nil).isSelected = true
	self:insertPileLine(MildGuideConfig.PileModel.IndexMove, nil)
	_ENV = nil
	;(nil).className = "mainCityView"
	_ENV, (nil).itemName = cityBuildConstDef.fixedBuildDef.ResurrectionHall, "tip"
	cityBuildConstDef.fixedBuildDef.ResurrectionHall.bid = cityBuildConstDef.fixedBuildDef.ResurrectionHall
	cityBuildConstDef.fixedBuildDef.ResurrectionHall.key = key
	;(nil).data, cityBuildConstDef.fixedBuildDef.ResurrectionHall.queuePriority = cityBuildConstDef.fixedBuildDef.ResurrectionHall, true
	self:insertPileLine(MildGuideConfig.PileModel.BuildTip, nil)
	self:star()
end
function mildGuideManager:starToOpenChat(data)
	dump(data, "mildGuideManager:starToOpenChat(data)")
	local chatChannel = data.chatChannel
	local panel = SoraDSearchPanelFromManagerByName("chatView")
	if panel then
		panel:removeFromParent()
	end
	panel = SoraDCreatePanel("chatView")
	panel:show()
	_ENV = nil
	;(nil).chatChannel = tonumber(chatChannel)
	panel:init(nil)
	return true, true
end
function mildGuideManager:starToPopTip(data)
	SoraDRemoveAllPanelFromManager()
	return true, true
end
function mildGuideManager:startToHarvestResource(data)
	SoraDRemoveAllPanelFromManager()
	_ENV = nil
	;(nil).msg = "MESSAGE_MAINCITYVIEW_MOVETO_BUILDBYBID"
	;(nil).goOuterCity = true
	SoraDGoToMainCityAndSendMsg(nil)
	return true, true
end
function mildGuideManager:starToEscortWorld()
	if worldMapDefine.inInCrossWar() then
		SoraDShowMsgTip(i18n("common_text_3302"))
		return true, true
	end
	local worldMapFunction = include("worldMapFunction")
	return worldMapFunction.GotoEscort(nil, true)
end
function mildGuideManager:starToCanUpgradeStar(...)
	local questCtrl = SoraDGetCtrl("questCtrl")
	local quest = questCtrl:getPerformingGuideQuest()
	if quest then
		local questltCtrl = gModuleMgr.sharedMgr("questltCtrl")
		local questID = quest.questID
		local questType = questltCtrl:getQuestType(questID)
		if gQuestType.UPGRADESTAR_BUILDING == questType then
			questltCtrl:jumpToFinishedById(questID)
			return true
		end
	end
	local cityCtrl = SoraDGetCtrl("cityCtrl")
	local bid, iid = cityCtrl:getCanUpgradeStarBuild()
	if bid then
		_ENV = nil
		;(nil).bid = bid
		;(nil).iid = iid
		self:starMildByNewPlayerQuestID(gNewPLayerTaskType.BUILDSTAR_UPGRADE, nil)
		return true
	end
	SoraDShowMsgTip(i18n("Glory_text_32"), nil)
	return false
end
function mildGuideManager:starToCanUpgrade()
	local gametop = gModuleMgr.getObject("gametop")
	local questCtrl = gametop.playertop_:getModule("questCtrl")
	local questltCtrl = gModuleMgr.sharedMgr("questltCtrl")
	local quest = questCtrl:getPerformingGuideQuest()
	if quest == nil then
		SoraDShowMsgTip(i18n("common_text_845"), nil, button)
		return false
	end
	local questID = quest.questID
	local questType = questltCtrl:getQuestType(questID)
	if gQuestType.BUILD_BUILDING == questType or gQuestType.UPGRADE_BUILDING == questType then
		questltCtrl:jumpToFinishedById(questID)
		return true
	else
		SoraDShowMsgTip(i18n("common_text_845"), nil, button)
		return false
	end
	do return end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local cityBuildMgr = include("cityBuildMgr")
	local buildLogic = include("buildLogic")
	local castleCell = cityCtrl:getBuildCellList(BUILDID.CASTLE)[1]
	local castleLv = cityCtrl:getBuildMaxLv(BUILDID.CASTLE)
	local function findCanUpgrade(buildCell)
		if buildCell and tonumber(buildCell.info.state) == BUILD_STATE.NORMAL then
			local _iscanbuild, retdata = buildLogic.isCanUpgrade(buildCell.info.bid, buildCell.info.iid)
			if retdata and tonumber(buildCell.info.lv) < castleLv or tonumber(buildCell.info.bid) == BUILDID.CASTLE and not buildLogic.buildLvIsFull(BUILDID.CASTLE, buildCell.info.iid) then
				if retdata._retPreCond then
					for i, v in ipairs(retdata._retPreCond) do
						if not v.isreach then
							local preCell = cityCtrl:getBuildCellList(v.bid)[1]
							local jumpCell = findCanUpgrade(preCell)
							if jumpCell then
								return jumpCell
							else
								break
							end
						end
					end
				end
				return buildCell
			else
				return nil
			end
		else
			return castleCell
		end
	end
	local canUpgradeBuild = findCanUpgrade(castleCell)
	if canUpgradeBuild == nil then
		canUpgradeBuild = castleCell
	end
	_ENV = castleCell
	castleCell.msg = "MESSAGE_MAINCITYVIEW_OFFSET_BUILD_TIP_HAND"
	castleCell.offsetType = MAINCITYVIEW_OFFSET_TYPE_BUILD_TIP_HAND
	castleCell.bid = tonumber(canUpgradeBuild.info.bid)
	local castleCell.iid, data = nil, castleCell
	SoraDGotoCityBuild(data)
end
function mildGuideManager:starToAllianceShop(data)
	self:clean()
	if GLOBAL_GAME_ALLIANCE_MODE then
		_ENV = nil
		;(nil).className = "allianceMainView"
		;(nil).itemName = "allianceMenuSingle"
		;(nil).index = ALLIANCE_MAIN_MENU_TYPE.STORE
		self:insertPileLine(MildGuideConfig.PileModel.PanelShow, nil)
	else
		_ENV = nil
		;(nil).className = "allianceMainView"
		;(nil).itemName = "allianceMenuSingle"
		;(nil).index = ALLIANCE_MAIN_MENU_TYPE.STORE
		;(nil).z = 5
		self:insertPileLine(MildGuideConfig.PileModel.PanelShow, nil)
	end
	self:star()
end
function mildGuideManager:starToUpgradeMagicLamp(data)
	self:clean()
	_ENV = nil
	;(nil).needCity = true
	self:needVerify(nil)
	local bid = BUILDID.MAGIC_LAMP
	_ENV = nil
	;(nil).bid = bid
	;(nil).isSelected = true
	self:insertPileLine(MildGuideConfig.PileModel.BuildMove, nil)
	_ENV = nil
	;(nil).className = "mainCityView"
	_ENV, (nil).itemName = nil, "tip"
	;(nil).bid = bid
	;(nil).key = "OpMagicLamp"
	;(nil).data, (nil).queuePriority = nil, false
	self:insertPileLine(MildGuideConfig.PileModel.BuildTip, nil)
	self:star()
end
function mildGuideManager:createNoticeLine(data)
	self:createNoticeNode()
	if self.noticeBg then
		self.noticeBg.noticeData = data
		self:showNotice()
	end
end
function mildGuideManager:noticeClick(ref, type)
	if type == ccui.TouchEventType.ended and self.noticeBg and self.noticeBg.isOnlyGirl then
		self:hiddleNotice()
		self:showNotice()
	end
end
function mildGuideManager:showNotice()
	if self.noticeBg then
		local noticeData = table.remove(self.noticeBg.noticeData, 1)
		if noticeData and noticeData.img then
			if noticeData.img == "girl" then
				self.noticeBg.noticeNPC.spriteGirl:setVisible(false)
				self.noticeBg.noticeNPC.actGirl:setVisible(true)
			else
				if noticeData.img == "lord" then
					local gametop = gModuleMgr.getObject("gametop")
					local lordSpineDef = include("lordSpineDef")
					local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
					local lordLocalData = include("lordLocalData")
					local info = lordSpineDef.getLordSpineInfo(lordInfoCtrl:getBaseInfo().imageId)
					if info then
						self.noticeBg.noticeNPC.spriteGirl:setVisible(false)
						self.noticeBg.noticeNPC.spine = sp.SkeletonAnimation:create(info.json, info.atlas, 1)
						local offset = info.offset or cc.p(0, 0)
						self.noticeBg.noticeNPC.spine:setPosition(cc.p(320 + offset.x, 70 + offset.y))
						self.noticeBg.noticeNPC.spine:setAnimation(0, "animation", true)
						self.noticeBg.noticeNPC.spine:addTo(self.noticeBg.noticeNPC.panelCut, 1)
					else
						self.noticeBg.noticeNPC.spriteGirl:setVisible(true)
						self.noticeBg.noticeNPC.spriteGirl:setSpriteFrame(lordLocalData.getPortrait(lordInfoCtrl:getBaseInfo().imageId))
					end
				else
					self.noticeBg.noticeNPC.spriteGirl:setVisible(true)
					self.noticeBg.noticeNPC.spriteGirl:setSpriteFrame(noticeData.img)
				end
				self.noticeBg.noticeNPC.spriteGirl:setAnchorPoint(noticeData.ap and SoraDFAP(noticeData.ap) or cc.p(0.5, 0))
				self.noticeBg.noticeNPC.spriteGirl:setPosition(noticeData.spos and noticeData.spos or cc.p(320, 80))
				self.noticeBg.noticeNPC.actGirl:setVisible(false)
			end
			self.noticeBg.noticeNPC.spriteGirl:setScale(1)
			self.noticeBg.noticeNPC.node:setVisible(true)
			self.noticeBg.noticeNPC.spriteNotice:setVisible(true)
			self.noticeBg.noticeNPC.labelNotice:setString(noticeData.str)
			local posY = 120 + display.iPhoneXBottom - self.adjustBoxDown
			self.noticeBg.noticeNPC.node:setPositionY(posY)
			self:showGirlAction()
			self.noticeBg.isOnlyGirl = false
			_UPVALUE1_ = 80
			;(80)[1] = cc.DelayTime:create(1.0)
			;(80)[2] = cc.CallFunc:create(function()
				self.noticeBg.isOnlyGirl = true
			end)
			;(80)[3] = cc.CallFunc:create(function()
				self.noticeBg.isOnlyGirl = true
			end)
			;(80)[4] = cc.CallFunc:create(function()
				self.noticeBg.isOnlyGirl = true
			end)
			;(80)[5] = cc.CallFunc:create(function()
				self.noticeBg.isOnlyGirl = true
			end)
			;(80)[6] = cc.CallFunc:create(function()
				self.noticeBg.isOnlyGirl = true
			end)
			self.noticeBg:runAction(transition.sequence(80))
		else
			self.noticeBg:removeFromParent()
			self.noticeBg = nil
			if noticeData and noticeData.callback then
				noticeData.callback()
			end
		end
	end
end
function mildGuideManager:showGirlAction()
	local noticeNPC = self.noticeBg.noticeNPC
	noticeNPC.arrow:stopAllActions()
	noticeNPC.arrow:setPositionX(self.arrX)
	noticeNPC.spriteNotice:setOpacity(0)
	self.blackSheer:setOpacity(0)
	self.blackSheer1:setOpacity(0)
	local posY = 120 + display.iPhoneXBottom - self.adjustBoxDown
	noticeNPC.spriteNotice:setPosition(cc.p(320, posY - 29))
	_UPVALUE1_ = cc.p(320, posY - 29)
	cc.p(320, posY - 29)[1] = cca.fadeIn(0.333)
	cc.p(320, posY - 29)[2] = cca.moveTo(0.333 * self.adjustactionSpeed, 320, posY)
	cc.p(320, posY - 29)[3] = cca.moveTo(0.333 * self.adjustactionSpeed, 320, posY)
	cc.p(320, posY - 29)[4] = cca.moveTo(0.333 * self.adjustactionSpeed, 320, posY)
	cc.p(320, posY - 29)[5] = cca.moveTo(0.333 * self.adjustactionSpeed, 320, posY)
	cc.p(320, posY - 29)[6] = cca.moveTo(0.333 * self.adjustactionSpeed, 320, posY)
	noticeNPC.spriteNotice:runAction(cca.spawn(cc.p(320, posY - 29)))
	self.blackSheer:runAction(cca.fadeIn(0.367 * self.adjustactionSpeed))
	self.blackSheer1:runAction(cca.fadeIn(0.367 * self.adjustactionSpeed))
	_UPVALUE1_ = cca.fadeIn(0.367 * self.adjustactionSpeed)
	cca.fadeIn(0.367 * self.adjustactionSpeed)[1] = cca.moveTo(0.5, self.arrX + 15, 35)
	cca.fadeIn(0.367 * self.adjustactionSpeed)[2] = cca.moveTo(0.5, self.arrX, 35)
	cca.fadeIn(0.367 * self.adjustactionSpeed)[3] = cca.moveTo(0.5, self.arrX, 35)
	cca.fadeIn(0.367 * self.adjustactionSpeed)[4] = cca.moveTo(0.5, self.arrX, 35)
	cca.fadeIn(0.367 * self.adjustactionSpeed)[5] = cca.moveTo(0.5, self.arrX, 35)
	noticeNPC.arrow:runAction(cca.repeatForever(cca.seq(cca.fadeIn(0.367 * self.adjustactionSpeed))))
	noticeNPC.node:setPosition(cc.p(90, noticeNPC.node:getPositionY()))
	noticeNPC.node:runAction(cc.EaseCircleActionOut:create(cca.moveTo(0.5 * self.adjustactionSpeed, 0, noticeNPC.node:getPositionY())))
	SoraDGetChildByName(noticeNPC.actGirl, "Girl"):setOpacity(0)
	_UPVALUE1_ = cc.EaseCircleActionOut:create(cca.moveTo(0.5 * self.adjustactionSpeed, 0, noticeNPC.node:getPositionY()))
	cc.EaseCircleActionOut:create(cca.moveTo(0.5 * self.adjustactionSpeed, 0, noticeNPC.node:getPositionY()))[1] = cc.EaseSineOut:create(cca.fadeTo(0.417 * self.adjustactionSpeed, 0.4))
	cc.EaseCircleActionOut:create(cca.moveTo(0.5 * self.adjustactionSpeed, 0, noticeNPC.node:getPositionY()))[2] = cca.fadeTo(0.083 * self.adjustactionSpeed, 1)
	cc.EaseCircleActionOut:create(cca.moveTo(0.5 * self.adjustactionSpeed, 0, noticeNPC.node:getPositionY()))[3] = cca.fadeTo(0.083 * self.adjustactionSpeed, 1)
	cc.EaseCircleActionOut:create(cca.moveTo(0.5 * self.adjustactionSpeed, 0, noticeNPC.node:getPositionY()))[4] = cca.fadeTo(0.083 * self.adjustactionSpeed, 1)
	cc.EaseCircleActionOut:create(cca.moveTo(0.5 * self.adjustactionSpeed, 0, noticeNPC.node:getPositionY()))[5] = cca.fadeTo(0.083 * self.adjustactionSpeed, 1)
	cc.EaseCircleActionOut:create(cca.moveTo(0.5 * self.adjustactionSpeed, 0, noticeNPC.node:getPositionY()))[6] = cca.fadeTo(0.083 * self.adjustactionSpeed, 1)
	SoraDGetChildByName(noticeNPC.actGirl, "Girl"):runAction(cca.seq(cc.EaseCircleActionOut:create(cca.moveTo(0.5 * self.adjustactionSpeed, 0, noticeNPC.node:getPositionY()))))
end
function mildGuideManager:createNoticeNode()
	if self.noticeBg == nil then
		self.adjustOffsetY = 25
		self.adjustGirlOffsetY = 20
		self.adjustBoxDown = 6
		self.adjustactionSpeed = 0.8333333333333334
		local baseView = include("baseView")
		local bgView = baseView.new(display.realSize, false)
		bgView:setName("mildGuideNotice")
		self.noticeBg = bgView
		self.noticeBg:ignoreAnchorPointForPosition(false)
		self.noticeBg:setAnchorPoint(cc.p(0.5, 0.5))
		self.noticeBg:setPosition(cc.p(display.cx, display.rcy))
		self.noticeBg:setBackGround(76.5)
		self.noticeBg:addTouchEventListener(handler(self, self.noticeClick))
		function self.noticeBg.onExitOther(...)
			gModuleMgr.sharedMgr("mildGuideManager").noticeBg = nil
		end
		self.noticeBg:addTo(display.getRunningScene().panelView, 1)
		local blackSheer = display.newSprite("#frame_sheer_items.png", 0, 0)
		blackSheer:setContentSize(329, 640)
		blackSheer:setRotation(-90)
		blackSheer:addTo(self.noticeBg)
		blackSheer:setPosition(320, 164.5)
		blackSheer:setName("sheerBlack")
		self.blackSheer = blackSheer
		local blackSheer1 = display.newSprite("#frame_sheer_items.png", 0, 0)
		blackSheer1:setContentSize(329, 640)
		blackSheer1:setRotation(-90)
		blackSheer1:addTo(self.noticeBg)
		blackSheer1:setPosition(320, 164.5)
		blackSheer1:setName("sheerBlack")
		self.blackSheer1 = blackSheer1
		local _ENV, noticeNPC = blackSheer1.setName, blackSheer1.setName
		local noticeBgX = SoraDFIsRA() and 320 or 320
		self.arrX = 550 + self.adjustOffsetY
		noticeNPC.spriteNotice = ccui.ImageView:create("frame_xsyd_dhk.png", ccui.TextureResType.plistType)
		noticeNPC.spriteNotice:setPosition(cc.p(noticeBgX, display.cy - self.adjustBoxDown))
		noticeNPC.spriteNotice:addTo(self.noticeBg, 2)
		_ENV = noticeNPC.spriteNotice
		noticeNPC.spriteNotice.text = ""
		noticeNPC.spriteNotice.size = 20
		noticeNPC.spriteNotice.color = cc.c3b(68, 35, 17)
		noticeNPC.spriteNotice.align = cc.TEXT_ALIGNMENT_CENTER
		noticeNPC.spriteNotice.valign = cc.VERTICAL_TEXT_ALIGNMENT_CENTER
		noticeNPC.spriteNotice.dimensions = cc.size(560, 120)
		noticeNPC.spriteNotice.x = 320 + self.adjustOffsetY * 2
		noticeNPC.spriteNotice.y = 115
		noticeNPC.labelNotice = display.newTTFLabel(noticeNPC.spriteNotice)
		noticeNPC.labelNotice:addTo(noticeNPC.spriteNotice)
		local arr = display.newSprite("#icon_xsyd_tg.png", self.arrX, 35)
		arr:addTo(noticeNPC.spriteNotice)
		arr:setPositionX(self.arrX)
		arr:stopAllActions()
		_UPVALUE1_ = 17
		;(17)[1] = cca.moveTo(0.5, self.arrX + 15, 35)
		;(17)[2] = cca.moveTo(0.5, self.arrX, 35)
		;(17)[3] = cca.moveTo(0.5, self.arrX, 35)
		;(17)[4] = cca.moveTo(0.5, self.arrX, 35)
		;(17)[5] = cca.moveTo(0.5, self.arrX, 35)
		arr:runAction(cca.repeatForever(cca.seq(17)))
		noticeNPC.arrow = arr
		noticeNPC.node = display.newNode()
		noticeNPC.node:addTo(self.noticeBg, 1)
		noticeNPC.spriteGirl = display.newSprite("#icon_merchant.png")
		noticeNPC.spriteGirl:setFlippedX(not SoraDFIsRA())
		noticeNPC.spriteGirl:addTo(noticeNPC.node)
		noticeNPC.spriteGirl:setVisible(false)
		noticeNPC.actGirl = SoraDCreateGuideNPC(1.2, cc.p(320, 70 + self.adjustGirlOffsetY), false, cc.size(500, 500), cc.p(240, 0))
		noticeNPC.actGirl:addTo(noticeNPC.node)
		noticeNPC.actGirl:setVisible(false)
		noticeNPC.node:setVisible(false)
		noticeNPC.spriteNotice:setVisible(false)
		noticeNPC.panelCut = ccui.Layout:create()
		noticeNPC.panelCut:setContentSize(cc.size(640, 960))
		noticeNPC.panelCut:setClippingEnabled(true)
		noticeNPC.panelCut:setTouchEnabled(false)
		noticeNPC.panelCut:setAnchorPoint(cc.p(0, 0))
		noticeNPC.panelCut:addTo(noticeNPC.node, 1)
		noticeNPC.panelCut:setPosition(0, 0)
		self.noticeBg.noticeNPC = noticeNPC
		self.noticeNPC = noticeNPC
		self:fitHieghtView()
	end
	self:hiddleNotice()
end
function mildGuideManager:fitHieghtView()
	if display.width / display.height <= 0.5633802816901409 then
		return
	end
	if not self.originSize then
		self.originSize = self.noticeNPC.spriteNotice:getContentSize()
	end
	local scale = self.originSize.width / 640
	self.noticeNPC.spriteNotice:ignoreContentAdaptWithSize(false)
	self.noticeNPC.spriteNotice:setScale9Enabled(false)
	self.noticeNPC.spriteNotice:setContentSize(cc.size(self.originSize.width / scale, self.originSize.height))
	self.noticeNPC.labelNotice:setWidth(self.noticeNPC.labelNotice:getWidth() / scale)
	self.arrX = 500
	self.noticeNPC.labelNotice:setPositionX(320)
	self.noticeNPC.arrow:stopAllActions()
	self.noticeNPC.arrow:setPositionX(self.arrX)
	_UPVALUE1_ = cc.size(self.originSize.width / scale, self.originSize.height)
	cc.size(self.originSize.width / scale, self.originSize.height)[1] = cca.moveTo(0.5, self.arrX + 15, 35)
	cc.size(self.originSize.width / scale, self.originSize.height)[2] = cca.moveTo(0.5, self.arrX, 35)
	cc.size(self.originSize.width / scale, self.originSize.height)[3] = cca.moveTo(0.5, self.arrX, 35)
	cc.size(self.originSize.width / scale, self.originSize.height)[4] = cca.moveTo(0.5, self.arrX, 35)
	cc.size(self.originSize.width / scale, self.originSize.height)[5] = cca.moveTo(0.5, self.arrX, 35)
	self.noticeNPC.arrow:runAction(cca.repeatForever(cca.seq(cc.size(self.originSize.width / scale, self.originSize.height))))
end
_ENV, mildGuideManager.hiddleNotice = function(self)
	if self.noticeBg and self.noticeBg.noticeNPC then
		local girlX = SoraDFIsRA() and -200 or 850
		local noticeX = SoraDFIsRA() and 890 or -250
		if self.noticeBg.noticeNPC.node:isVisible() then
			if self.noticeBg.noticeNPC.spine then
				self.noticeBg.noticeNPC.spine:removeFromParent()
				self.noticeBg.noticeNPC.spine = nil
			end
			self.noticeBg.noticeNPC.node:setVisible(false)
			self.noticeBg.noticeNPC.spriteNotice:setVisible(false)
		end
	end
end, function(self)
	if self.noticeBg and self.noticeBg.noticeNPC then
		local girlX = SoraDFIsRA() and -200 or 850
		local noticeX = SoraDFIsRA() and 890 or -250
		if self.noticeBg.noticeNPC.node:isVisible() then
			if self.noticeBg.noticeNPC.spine then
				self.noticeBg.noticeNPC.spine:removeFromParent()
				self.noticeBg.noticeNPC.spine = nil
			end
			self.noticeBg.noticeNPC.node:setVisible(false)
			self.noticeBg.noticeNPC.spriteNotice:setVisible(false)
		end
	end
end
;(function(self)
	if self.noticeBg and self.noticeBg.noticeNPC then
		local girlX = SoraDFIsRA() and -200 or 850
		local noticeX = SoraDFIsRA() and 890 or -250
		if self.noticeBg.noticeNPC.node:isVisible() then
			if self.noticeBg.noticeNPC.spine then
				self.noticeBg.noticeNPC.spine:removeFromParent()
				self.noticeBg.noticeNPC.spine = nil
			end
			self.noticeBg.noticeNPC.node:setVisible(false)
			self.noticeBg.noticeNPC.spriteNotice:setVisible(false)
		end
	end
end).id = true
;(function(self)
	if self.noticeBg and self.noticeBg.noticeNPC then
		local girlX = SoraDFIsRA() and -200 or 850
		local noticeX = SoraDFIsRA() and 890 or -250
		if self.noticeBg.noticeNPC.node:isVisible() then
			if self.noticeBg.noticeNPC.spine then
				self.noticeBg.noticeNPC.spine:removeFromParent()
				self.noticeBg.noticeNPC.spine = nil
			end
			self.noticeBg.noticeNPC.node:setVisible(false)
			self.noticeBg.noticeNPC.spriteNotice:setVisible(false)
		end
	end
end).bid = true
;(function(self)
	if self.noticeBg and self.noticeBg.noticeNPC then
		local girlX = SoraDFIsRA() and -200 or 850
		local noticeX = SoraDFIsRA() and 890 or -250
		if self.noticeBg.noticeNPC.node:isVisible() then
			if self.noticeBg.noticeNPC.spine then
				self.noticeBg.noticeNPC.spine:removeFromParent()
				self.noticeBg.noticeNPC.spine = nil
			end
			self.noticeBg.noticeNPC.node:setVisible(false)
			self.noticeBg.noticeNPC.spriteNotice:setVisible(false)
		end
	end
end).iid = true
local (function(self)
	if self.noticeBg and self.noticeBg.noticeNPC then
		local girlX = SoraDFIsRA() and -200 or 850
		local noticeX = SoraDFIsRA() and 890 or -250
		if self.noticeBg.noticeNPC.node:isVisible() then
			if self.noticeBg.noticeNPC.spine then
				self.noticeBg.noticeNPC.spine:removeFromParent()
				self.noticeBg.noticeNPC.spine = nil
			end
			self.noticeBg.noticeNPC.node:setVisible(false)
			self.noticeBg.noticeNPC.spriteNotice:setVisible(false)
		end
	end
end).lv, paramNumTypeTb = true, function(self)
	if self.noticeBg and self.noticeBg.noticeNPC then
		local girlX = SoraDFIsRA() and -200 or 850
		local noticeX = SoraDFIsRA() and 890 or -250
		if self.noticeBg.noticeNPC.node:isVisible() then
			if self.noticeBg.noticeNPC.spine then
				self.noticeBg.noticeNPC.spine:removeFromParent()
				self.noticeBg.noticeNPC.spine = nil
			end
			self.noticeBg.noticeNPC.node:setVisible(false)
			self.noticeBg.noticeNPC.spriteNotice:setVisible(false)
		end
	end
end
function mildGuideManager:splitGuideParam(strGuideParam)
	local sepC = ","
	if string.find(strGuideParam, ";") then
		sepC = ";"
	end
	local paramArray = string.split(strGuideParam, sepC)
	if paramArray == nil then
		paramNumTypeTb = strGuideParam
		paramArray, strGuideParam[1] = strGuideParam, strGuideParam
	end
	local _ENV, tbParam = strGuideParam, strGuideParam
	for i, v in ipairs(paramArray) do
		local t = string.split(v, ":")
		if paramNumTypeTb[t[1]] then
			tbParam[t[1]] = tonumber(t[2])
		else
			tbParam[t[1]] = t[2]
		end
	end
	return tbParam
end
function mildGuideManager:commonTaskJump(taskId, data)
	local eventQuestRead = include("eventQuestRead")
	local guideId = eventQuestRead.getGuideId(taskId)
	local tbParam = self:splitGuideParam(guideId)
	if not next(tbParam) then
		local taskDes = eventQuestRead.getDesNew(taskId)
		SoraDShowMsgTip(taskDes)
		return
	end
	if tbParam.id == gNewPLayerTaskType.TO_ForeginPGame_4 then
		local foreignPavilionRead = include("foreignPavilionRead")
		local gameType = foreignPavilionRead.gameTypes.TOWERDEFEND
		_ENV = nil
		;(nil).gameType = gameType
		;(nil).isInStory = true
		;(nil).gameSource = data.gameSource
		uiManager:show("ForeginPGameStart", nil)
		return
	end
	if tbParam.id == gNewPLayerTaskType.POP_TIP then
		local taskDes = eventQuestRead.getDesNew(taskId)
		SoraDShowMsgTip(taskDes)
	end
	local ret, notNeedClose = self:starMildByNewPlayerStringParam(guideId)
	if not notNeedClose then
		SoraDRemoveAllPanelFromManager()
	end
end
return mildGuideManager
