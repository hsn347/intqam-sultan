local buildRead = include("buildDescribeRead")
local buildLogic = include("buildLogic")
local cityltCtrl = include("cityltCtrl")
local cityCtrl = SoraDGetCtrl("cityCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local BuildCreatePanel = class("BuildCreatePanel", baseFguiPanel)
function BuildCreatePanel:ctor(...)
	self.super.ctor(self, ...)
	print("BuildCreatePanel:ctor", self.viewName)
	self.tableCurIndex = 1
end
function BuildCreatePanel:onInit()
	print("=======BuildCreatePanel:onInit")
	self.fields.List_build:setItemRenderer(handler(self, self.onBuildRenderer))
	self.fields.List_build:addEventListener(fgui.UIEventType.Scroll, handler(self, self.onScrollItem))
	self.fields.List_build:addEventListener(fgui.UIEventType.ScrollEnd, handler(self, self.onScrollEndItem))
	self.labelDes = self.fields.Text_des
	self.labelCount = self.fields.Text_count
	self.labelNeed = self.fields.Text_need
	self.labelName = self.fields.Com_name
	self.labelCount:setVisible(false)
	self.labelNeed:setVisible(false)
	self.btnBuild = self.fields.Button_build
	self.btnBuild:setTitleText(i18n("common_text_042"))
	self.btnBuild:addClickListener(handler(self, self.createButtonCallFun))
end
function BuildCreatePanel:onShow()
	print("=======BuildCreatePanel:onShow")
	_ENV = "=======BuildCreatePanel:onShow"
	;("=======BuildCreatePanel:onShow").isHideMainUI = true
	SoraDHideCurrentSceneViewAndMainUI("=======BuildCreatePanel:onShow")
	self:setBuildTypeAndData(self.param.buildType, self.param.buildIndex)
	local buildID = self.param.buildID
	if buildID then
		self:selectWheelByBid(buildID)
	end
end
function BuildCreatePanel:setBuildTypeAndData(buildType, buildIndex)
	self.buildType = buildType or 0
	self.buildIndex = buildIndex or 0
	self.tableBuildList = buildLogic.getCanBuildList(self.buildType)
	self:createWheelScrollView()
	local guideStep = SoraDIsGameGuide()
	if guideStep then
		if guideStep == 2003 then
			print("走新手引导步骤 建筑建造")
			buildLogic = "走新手引导步骤 建筑建造"
			;("走新手引导步骤 建筑建造").msg = "MESSAGE_SERVER_GUIDE_STEP_ON"
			;("走新手引导步骤 建筑建造").step = 2004
			SoraDSendMessage("走新手引导步骤 建筑建造")
		elseif guideStep == 2013 then
			buildLogic = "走新手引导步骤 建筑建造"
			;("走新手引导步骤 建筑建造").msg = "MESSAGE_SERVER_GUIDE_STEP_ON"
			;("走新手引导步骤 建筑建造").step = 2014
			SoraDSendMessage("走新手引导步骤 建筑建造")
		end
	end
	if GLOBAL_BUILD_PRE_BID then
		self:selectWheelByBid(GLOBAL_BUILD_PRE_BID)
		GLOBAL_BUILD_PRE_BID = nil
	end
end
function BuildCreatePanel:createButtonCallFun()
	SoraDPlaySound()
	_ENV, _ENV = nil, nil
	;(nil).buildID = self.tableCurBuild
	_ENV, (nil).buildData = self.tableCurRetdata, self.tableCurRetdata
	self.tableCurRetdata.buildType = self.buildType
	;(nil).buildData, (nil).buildType, self.tableCurRetdata.buildIndex = nil, self.tableCurRetdata, self.buildIndex
	;(nil).isFromCreate = true
	uiManager:show("BuildCreateInfo", nil)
end
function BuildCreatePanel:updateView()
	if self.tableCurBuild == nil then
		return
	end
	self.labelDes:setString(buildRead.getBrief(self.tableCurBuild.bid))
	self.labelCount:setVisible(self.buildType == 1)
	self.labelNeed:setVisible(not self.tableCurBuild.iscanbuild)
	self.labelName:setString(buildRead.getName(self.tableCurBuild.bid))
	self.btnBuild:setEnabled(self.tableCurBuild.iscanbuild)
	local _iscanbuild, retdata = buildLogic.isCanBuild(self.tableCurBuild.bid)
	self.tableCurRetdata = retdata
	if not self.tableCurBuild.iscanbuild then
		buildRead = buildRead.getName(self.tableCurBuild.bid)
		buildRead.getName(self.tableCurBuild.bid).name = buildRead.getName(self.tableCurRetdata._retPreCond[1].bid)
		buildRead.getName(self.tableCurBuild.bid).level = tostring(self.tableCurRetdata._retPreCond[1].blv)
		self.labelNeed:setString(i18n("common_text_763", buildRead.getName(self.tableCurBuild.bid)))
	end
	if self.buildType == 1 then
		buildRead = i18n("common_text_763", buildRead.getName(self.tableCurBuild.bid))
		i18n("common_text_763", buildRead.getName(self.tableCurBuild.bid)).cur = cityCtrl:getBuildCount(self.tableCurBuild.bid)
		i18n("common_text_763", buildRead.getName(self.tableCurBuild.bid)).max = cityltCtrl.buildAttr(self.tableCurBuild.bid, BUILD_ATTR.BMAXCOUNT)
		self.labelCount:setString(i18n("common_text_739", i18n("common_text_763", buildRead.getName(self.tableCurBuild.bid))))
	end
	if self.buildIndex == 0 then
		return
	end
	local index = self.buildIndex
	local bid = self.tableCurBuild.bid
	buildRead = i18n("common_text_739", i18n("common_text_763", buildRead.getName(self.tableCurBuild.bid)))
	i18n("common_text_739", i18n("common_text_763", buildRead.getName(self.tableCurBuild.bid))).msg = "MESSAGE_MAINCITYVIEW_ADD_BUILD_PREVIEW"
	i18n("common_text_739", i18n("common_text_763", buildRead.getName(self.tableCurBuild.bid))).index = index
	i18n("common_text_739", i18n("common_text_763", buildRead.getName(self.tableCurBuild.bid))).bid = bid
	SoraDSendMessage(i18n("common_text_739", i18n("common_text_763", buildRead.getName(self.tableCurBuild.bid))))
end
function BuildCreatePanel:wheelScrollBack(buildSingleData, index)
	self.tableCurBuild = buildSingleData
	self.tableCurIndex = index
	self:setBuildSelected(self.tableCurIndex)
	self:updateView()
end
function BuildCreatePanel:setBuildSelected(selectIndex)
	self.fields.List_build:setSelectedIndex(selectIndex - 1)
	local buildItem = self.fields.List_build:getChildAt(selectIndex - 1)
	local scrollPanel = self.fields.List_build:getScrollPane()
	local objPosx = buildItem:getX()
	local objW = buildItem:getContentSize().width
	local scrollW = scrollPanel:getContentSize().width
	scrollPanel:setPercX(objPosx / (scrollW - objW), true)
end
function BuildCreatePanel:selectWheelByBid(bid)
	local curIndex = 1
	for i, v in ipairs(self.tableBuildList) do
		if v.bid == bid then
			curIndex = i
		end
	end
	self.tableCurIndex = curIndex
	self:setBuildSelected(self.tableCurIndex)
end
function BuildCreatePanel:createWheelScrollView()
	local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
	local curbid = mildGuideManager:getVariate(self.__cname, "bid")
	if curbid and self.buildIndex > 0 then
		mildGuideManager:updateIndex(self.buildIndex)
	end
	_UPVALUE3_ = mildGuideManager
	mildGuideManager[1] = self.buildType
	mildGuideManager[2] = curbid
	mildGuideManager[3] = GLOBAL_BUILD_PRE_BID
	dump(mildGuideManager, "self.buildTypecreateWheelScrollView")
	self.fields.List_build:setNumItems(#self.tableBuildList)
	if 0 >= #self.tableBuildList then
		return
	end
	if curbid then
		self:selectWheelByBid(curbid)
	end
	self:onScrollItem()
	self.tableCurIndex = math.min(self.tableCurIndex, #self.tableBuildList)
	self:wheelScrollBack(self.tableBuildList[self.tableCurIndex], self.tableCurIndex)
end
function BuildCreatePanel:onBuildRenderer(index, obj)
	local data = self.tableBuildList[index + 1]
	obj:initData(data)
end
function BuildCreatePanel:onScrollItem()
	local offsetX = self.fields.List_build:getScrollPane():getPositionX()
	local listW = self.fields.List_build:getContentSize().width
	local scrollW = self.fields.List_build:getInnerContainerSize().width
	local centerX = offsetX + listW / 2 - 216
	local children = self.fields.List_build:getChildren()
	for i, buildItem in ipairs(children) do
		local objW = buildItem:getContentSize().width
		local objOffsetX = buildItem:getX() + objW / 2 - centerX
		local ratio = 1.0 - math.abs(objOffsetX) / listW * 0.5
		ratio = math.max(0.01, ratio)
		buildItem:setScale(ratio)
		buildItem:setAlpha(ratio < 0.9 and ratio * 0.8 or ratio)
	end
end
function BuildCreatePanel:onScrollEndItem()
	local midIndex = 0
	local scaleX = 0
	local children = self.fields.List_build:getChildren()
	for i, buildItem in ipairs(children) do
		if scaleX <= buildItem:getScaleX() then
			scaleX = buildItem:getScaleX()
			midIndex = i
		end
	end
	self:wheelScrollBack(self.tableBuildList[midIndex], midIndex)
end
function BuildCreatePanel:onHide(...)
	SoraDRemoveMessageFromTargetByName(self, "MESSAGE_RESOURCE_UPDATE")
	SoraDRemoveMessageFromTargetByName(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK")
	_ENV = self
	self.msg = "MESSAGE_MAINCITYVIEW_OFFSET_BUILD"
	self.offsetType = MAINCITYVIEW_OFFSET_TYPE_RECOVER
	SoraDSendMessage(self)
	_ENV = self
	self.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_PREVIEW"
	self.index = self.buildIndex
	SoraDSendMessage(self)
	_ENV = self
	self.isHideMainUI = false
	SoraDHideCurrentSceneViewAndMainUI(self)
	if SoraDIsGameGuide() == 12001 then
		_ENV = self
		self.msg = "MESSAGE_SERVER_CLOSE_GUIDE"
		SoraDSendMessage(self)
	end
end
function BuildCreatePanel:onMsgBuildQueueCallback(...)
	self:setBuildTypeAndData(self.buildType, self.buildIndex)
end
function BuildCreatePanel:onMsgBuildCreatePoint(target, data)
	if data.bid then
		self:selectWheelByBid(data.bid)
	elseif data.key and data.key == "wheel" then
		self:createWheelGuide()
	end
end
function BuildCreatePanel:onMsgBuildCreatePointHide(target, data)
	if self.wheelGuideEffectNode then
		self.wheelGuideEffectNode:removeFromParent()
		self.wheelGuideEffectNode = nil
	end
end
function BuildCreatePanel:gameGuide_getTarget(itemName, parameters)
	if itemName == "Button_build" then
		return self.fields.Button_build
	elseif itemName == "tent" then
		local curIndex = 1
		for i, v in ipairs(self.tableBuildList) do
			if v.bid == BUILDID.MILITARY_TENT then
				curIndex = i
			end
		end
		local buildItem = self.fields.List_build:getChildAt(curIndex - 1)
		return buildItem
	elseif itemName == "Layout" then
		return self.fields.List_build
	else
		return self.fields[itemName]
	end
	return nil
end
function BuildCreatePanel:createWheelGuide()
	if SoraDIsGameGuide() == 850101 and self.tableCurIndex == 2 then
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_GUIDE_STEP_END"
		;(nil).step = 850101
		SoraDSendMessage(nil)
		return
	end
	local effectNode = display.newNode()
	effectNode:setName("wheelGuideEffectNode")
	effectNode:addTo(self.fields.Node_wheelGuide:displayObject())
	self.wheelGuideEffectNode = effectNode
	local spriteHand = SoraDFingerAction()
	spriteHand:setPosition(cc.p(300, 400))
	spriteHand:setName("spriteHand")
	spriteHand:addTo(effectNode)
	self:createWheelAction()
	self.btnBuild:setEnabled(false)
end
function BuildCreatePanel:createWheelAction()
	if self.wheelGuideEffectNode == nil then
		return
	end
	local spriteHand = self.wheelGuideEffectNode:getChildByName("spriteHand")
	if spriteHand then
		_UPVALUE10_ = "spriteHand"
		;("spriteHand")[1] = cca.callFunc(function(...)
			spriteHand:setPosition(SoraDFPoint(-216, 0, 0))
			spriteHand:setVisible(true)
		end)
		;("spriteHand")[2] = cca.fadeIn(0.2)
		;("spriteHand")[3] = cca.scaleTo(0.2, 1.2)
		;("spriteHand")[4] = cca.scaleTo(0.2, 1)
		;("spriteHand")[5] = cca.delay(0.5)
		;("spriteHand")[6] = cca.moveTo(0.7, 0, 0)
		;("spriteHand")[7] = cca.delay(0.5)
		;("spriteHand")[8] = cca.fadeOut(0.5)
		;("spriteHand")[9] = cca.callFunc(function(...)
			spriteHand:setVisible(false)
		end)
		;("spriteHand")[10] = cca.delay(0.5)
		;("spriteHand")[11] = cca.callFunc(function(...)
			self:createWheelAction()
		end)
		;("spriteHand")[12] = cca.callFunc(function(...)
			self:createWheelAction()
		end)
		local newAction = cca.seq("spriteHand")
		spriteHand:runAction(newAction)
	end
end
return BuildCreatePanel
