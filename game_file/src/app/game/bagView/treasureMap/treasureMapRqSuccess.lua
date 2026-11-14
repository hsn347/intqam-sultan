local collectSalaryRead = include("collectSalaryRead")
local itemDesRead = include("itemDesRead")
local collectSalaryCtrl = SoraDGetCtrl("collectSalaryCtrl")
local timeLimitedItemCtrl = SoraDGetCtrl("timeLimitedItemCtrl")
local treasureMapRqSuccess = class("treasureMapRqSuccess", function(target)
	return target or SoraDCreateTouchPanel("treasureMapRqSuccess")
end)
local MaxNum = 5
_ENV, _ENV, _UPVALUE5_ = nil, nil, function(target)
	return target or SoraDCreateTouchPanel("treasureMapRqSuccess")
end
;(nil).x = -210
_ENV, (nil)[5], (nil).y = nil, nil, 105
;(nil).x = -213
_ENV, _ENV, (nil)[4], (nil).y = nil, nil, nil, 83
;(nil).x = -120
_ENV, (nil)[5], (nil).y = nil, nil, -60
;(nil).x = -70
_ENV, _ENV, (nil)[4], (nil).y = nil, nil, nil, -65
;(nil).x = 10
_ENV, (nil)[5], (nil).y = nil, nil, 45
;(nil).x = 72.0
_ENV, _ENV, (nil)[4], (nil).y = nil, nil, nil, 67
;(nil).x = 113
_ENV, (nil)[5], (nil).y = nil, nil, -21
;(nil).x = 224.0
_ENV, _ENV, (nil)[4], (nil).y = nil, nil, nil, -68
;(nil).x = 224.0
;(nil)[5], (nil).y = nil, -68
_UPVALUE20_, _ENV, (function(target)
	return target or SoraDCreateTouchPanel("treasureMapRqSuccess")
end)[1] = nil, nil, nil
_UPVALUE20_, _ENV, (function(target)
	return target or SoraDCreateTouchPanel("treasureMapRqSuccess")
end)[2] = nil, nil, nil
_UPVALUE20_, _ENV, (function(target)
	return target or SoraDCreateTouchPanel("treasureMapRqSuccess")
end)[3] = nil, nil, nil
_UPVALUE20_, _ENV, (function(target)
	return target or SoraDCreateTouchPanel("treasureMapRqSuccess")
end)[4] = nil, nil, nil
local _UPVALUE20_, _ENV, (function(target)
	return target or SoraDCreateTouchPanel("treasureMapRqSuccess")
end)[5], posXY = nil, nil, nil, function(target)
	return target or SoraDCreateTouchPanel("treasureMapRqSuccess")
end
_UPVALUE19_, (nil)[5], (nil)[1] = nil, nil, cc.p(-185.47, 84)
_UPVALUE19_, (nil)[5], (nil)[2] = nil, nil, cc.p(-171.55, 64.65)
_UPVALUE19_, (nil)[5], (nil)[3] = nil, nil, cc.p(-167.09, 45.12)
_UPVALUE19_, (nil)[5], (nil)[4] = nil, nil, cc.p(-166.17, 20.98)
_UPVALUE19_, (nil)[5], (nil)[5] = nil, nil, cc.p(-164.37, -2.92)
_UPVALUE19_, (nil)[5], (nil)[6] = nil, nil, cc.p(-161.87, -25.25)
_UPVALUE19_, (nil)[5], (nil)[7] = nil, nil, cc.p(-152.27, -43.15)
_UPVALUE19_, (nil)[5], (nil)[8] = nil, nil, cc.p(-86.6, -49.72)
_UPVALUE19_, (nil)[5], (nil)[9] = nil, nil, cc.p(-64.91, -39.5)
_UPVALUE19_, (nil)[5], (nil)[10] = nil, nil, cc.p(-47.05, -28.36)
_UPVALUE19_, (nil)[5], (nil)[11] = nil, nil, cc.p(-28.72, -15.54)
_UPVALUE19_, (nil)[5], (nil)[12] = nil, nil, cc.p(-13.42, 4.78)
_UPVALUE19_, (nil)[5], (nil)[13] = nil, nil, cc.p(-4.52, 19.97)
_UPVALUE19_, (nil)[5], (nil)[14] = nil, nil, cc.p(28.68, 63.13)
_UPVALUE19_, (nil)[5], (nil)[15] = nil, nil, cc.p(50.13, 71.95)
_UPVALUE19_, (nil)[5], (nil)[16] = nil, nil, cc.p(77.15, 67.25)
_UPVALUE19_, (nil)[5], (nil)[17] = nil, nil, cc.p(94.77, 49.03)
_UPVALUE19_, (nil)[5], (nil)[18] = nil, nil, cc.p(102.41, 27.3)
_UPVALUE19_, (nil)[5], (nil)[19] = nil, nil, cc.p(106.52, 7.62)
_UPVALUE19_, (nil)[5], (nil)[20] = nil, nil, cc.p(109.89, -52.19)
_UPVALUE19_, (nil)[5], (nil)[21] = nil, nil, cc.p(117.28, -74.21)
_UPVALUE19_, (nil)[5], (nil)[22] = nil, nil, cc.p(136.6, -92.7)
_UPVALUE19_, (nil)[5], (nil)[23] = nil, nil, cc.p(167.51, -103.46)
_UPVALUE19_, (nil)[5], (nil)[24] = nil, nil, cc.p(198.7, -99.32)
_UPVALUE19_, (nil)[5], (nil)[25] = nil, nil, cc.p(198.7, -99.32)
_UPVALUE19_, (nil)[5], (nil)[26] = nil, nil, cc.p(198.7, -99.32)
_ENV, (nil)[4], (nil)[1] = nil, nil, cc.p(-172.6, 81.49)
_ENV, (nil)[4], (nil)[2] = nil, nil, cc.p(-152.72, 74.69)
_ENV, (nil)[4], (nil)[3] = nil, nil, cc.p(-140.73, 59.24)
_ENV, (nil)[4], (nil)[4] = nil, nil, cc.p(-139.81, 36.36)
_ENV, (nil)[4], (nil)[5] = nil, nil, cc.p(-139.58, 14.97)
_ENV, (nil)[4], (nil)[6] = nil, nil, cc.p(-141.16, -7.05)
_ENV, (nil)[4], (nil)[7] = nil, nil, cc.p(-136.26, -28.4)
_ENV, (nil)[4], (nil)[8] = nil, nil, cc.p(-124.58, -46.58)
_ENV, (nil)[4], (nil)[9] = nil, nil, cc.p(-107.29, -57.39)
_ENV, (nil)[4], (nil)[10] = nil, nil, cc.p(-41.77, -46.32)
_ENV, (nil)[4], (nil)[11] = nil, nil, cc.p(-21.06, -35.08)
_ENV, (nil)[4], (nil)[12] = nil, nil, cc.p(-2.55, -21.95)
_ENV, (nil)[4], (nil)[13] = nil, nil, cc.p(11.34, -5.88)
_ENV, (nil)[4], (nil)[14] = nil, nil, cc.p(22.51, 9.09)
_ENV, (nil)[4], (nil)[15] = nil, nil, cc.p(34.27, 27.59)
_ENV, (nil)[4], (nil)[16] = nil, nil, cc.p(50.71, 46.1)
_ENV, (nil)[4], (nil)[17] = nil, nil, cc.p(102.2, 59.59)
_ENV, (nil)[4], (nil)[18] = nil, nil, cc.p(118.53, 39.84)
_ENV, (nil)[4], (nil)[19] = nil, nil, cc.p(130.4, 18.96)
_ENV, (nil)[4], (nil)[20] = nil, nil, cc.p(137.05, -5.62)
_ENV, (nil)[4], (nil)[21] = nil, nil, cc.p(141.03, -29.93)
_ENV, (nil)[4], (nil)[22] = nil, nil, cc.p(154.21, -51.5)
_ENV, (nil)[4], (nil)[23] = nil, nil, cc.p(175.27, -63.17)
_ENV, (nil)[4], (nil)[24] = nil, nil, cc.p(175.27, -63.17)
_ENV, (nil)[4], (nil)[25] = nil, nil, cc.p(175.27, -63.17)
_ENV, (nil)[4], (nil)[26] = nil, nil, cc.p(175.27, -63.17)
local pointPos
;(nil).COMPOSE_SUCCESS = 1
local (nil).USE_SUCCESS, VIEW_TYPE = 2, nil
function treasureMapRqSuccess:ctor()
	self.posTbl, _ENV = nil, nil
	self.basePanel = SoraDGetChildByName(self, "basePanel")
	self.frameTitle = SoraDGetChildByName(self, "frame_title")
	self.frameTitle:ignoreContentAdaptWithSize(true)
	self.textItemName = SoraDGetChildByName(self, "Text_ItemName")
	self.textItemInfo = SoraDGetChildByName(self, "Text_Get")
	self.textExplain = SoraDGetChildByName(self, "Text_Explain")
	self.btnSure = SoraDGetChildByName(self, "Button_Sure")
	self.btnSure:setTitleText(i18n("common_text_204"))
	self.btnSure:addTouchEventListener(handler(self, self.btnClickSure))
	self.iconBox = SoraDGetChildByName(self, "icon_Box")
	self.mapNode = SoraDGetChildByName(self, "Node_Map")
	self.centerNode = SoraDGetChildByName(self, "Center_Node")
	self.iconBox:setVisible(false)
	self.frameXuanz = SoraDGetChildByName(self, "G_xuanz")
	self.frameXuanz:setRotation(0)
	_UPVALUE1_ = handler(self, self.btnClickSure)
	handler(self, self.btnClickSure)[1] = cca.rotateTo(8, 180)
	handler(self, self.btnClickSure)[2] = cca.rotateTo(8, 360)
	handler(self, self.btnClickSure)[3] = cca.rotateTo(8, 360)
	handler(self, self.btnClickSure)[4] = cca.rotateTo(8, 360)
	self.frameXuanz:runAction(cca.repeatForever(cca.seq(handler(self, self.btnClickSure))))
	SoraDMixtureGLONEByParent(self.centerNode)
	local loop = true
	local cssFileName = "treasureMapRqSuccess"
	local cssFilePath = getCCSPath(cssFileName)
	local action = cc.CSLoader:createTimeline(cssFilePath)
	action:gotoFrameAndPlay(0, loop)
	self:runAction(action)
end
function treasureMapRqSuccess:initMapNode(num)
	local iconPos = SoraDGetChildByName(self.mapNode, "single_Pos_1")
	local iconPoint = SoraDGetChildByName(self.mapNode, "Image_Point")
	self.posTbl[1] = iconPos
	for i = 1, num - 1 do
		local itemPos = self.posTbl[i]
		if not itemPos then
			itemPos = self.posTbl[1]:clone()
			itemPos:addTo(self.mapNode)
			itemPos:setName("single_Pos_" .. i)
			self.posTbl[i] = itemPos
		end
		itemPos:setPosition(posXY[i][num].x, posXY[i][num].y)
		itemPos:setVisible(true)
	end
	if self.viewType == VIEW_TYPE.USE_SUCCESS then
		for i, v in ipairs(pointPos[num]) do
			local pointSingle = iconPoint:clone()
			pointSingle:addTo(self.mapNode)
			pointSingle:setPosition(v)
			pointSingle:setVisible(false)
			posXY = nil
			;(nil)[1] = cca.delay((0 + i * 3) / 60)
			;(nil)[2] = cca.callFunc(function()
				pointSingle:setVisible(true)
			end)
			;(nil)[3] = cca.callFunc(function()
				pointSingle:setVisible(true)
			end)
			pointSingle:runAction(cca.seq(nil))
		end
	end
end
function treasureMapRqSuccess:btnClickSure(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local layer = SoraDCreatePanel("treasureMapTask")
		local isLimitedItem = timeLimitedItemCtrl:getNewLimitedTime(self.tressureMapID)
		_ENV, _ENV = nil, nil
		;(nil).dataFromItem, (nil).isLimitedItem = nil, isLimitedItem
		layer:initData(self.tressureMapID, nil)
		layer:show()
		self:close(self, type)
	end
end
function treasureMapRqSuccess:initData(viewType, tressureMapID)
	self.tressureMapID = tressureMapID
	local num = collectSalaryRead.getFragmentNumsByID(tressureMapID)
	self.viewType = viewType
	self:initMapNode(num)
	self.textItemInfo:setVisible(viewType == VIEW_TYPE.COMPOSE_SUCCESS)
	self.textItemName:setVisible(viewType == VIEW_TYPE.COMPOSE_SUCCESS)
	self.textExplain:setVisible(viewType == VIEW_TYPE.COMPOSE_SUCCESS)
	self.btnSure:setVisible(viewType == VIEW_TYPE.COMPOSE_SUCCESS)
	self.basePanel:setVisible(viewType == VIEW_TYPE.COMPOSE_SUCCESS)
	self.textItemInfo:setString(i18n("hero_ceremony_text_08"))
	self.textItemName:setString(itemDesRead.getName(tressureMapID))
	self.textItemName:setColor(itemDesRead.getColor(tressureMapID))
	self.textExplain:setString(i18n("treasuremap_text_21"))
	local lang = SoraDGetDefaultLanguage()
	if lang ~= "ar" and lang ~= "en" and lang ~= "ko" then
		lang = "en"
	end
	if viewType == VIEW_TYPE.COMPOSE_SUCCESS then
		self.frameTitle:loadTexture("frame_title_congratulation_" .. lang .. ".png", ccui.TextureResType.plistType)
	else
		self.frameTitle:loadTexture("frame_wzsx_open_" .. lang .. ".png", ccui.TextureResType.plistType)
	end
end
function treasureMapRqSuccess:onExitPanel()
	if self.viewType == VIEW_TYPE.USE_SUCCESS then
		local isInUseLimitedItem = timeLimitedItemCtrl:getNewInUseLimitedItem(self.tressureMapID)
		print("isInUseLimitedItem ==", isInUseLimitedItem, self.tressureMapID)
		local layer = SoraDCreatePanel("treasureMapTask")
		VIEW_TYPE, VIEW_TYPE = nil, nil
		;(nil).dataFromItem, (nil).isInUseLimitedItem = nil, isInUseLimitedItem
		layer:initData(self.tressureMapID, nil)
		layer:show()
	end
end
return treasureMapRqSuccess
