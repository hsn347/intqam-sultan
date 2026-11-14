local gametop = gModuleMgr.getObject("gametop")
local pyramidWarCtrl = gametop.playertop_:getModule("pyramidWarCtrl")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local PyramidPlayoffsView = class("pyramidPlayoffsView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("pyramidPlayoffsView")
	end
	return target
end)
function PyramidPlayoffsView:ctor()
	self.groupNodes, _ENV, self.isTurnning = nil, nil, true
	self.nodePagePoint = SoraDGetChildByName(self, "Node_pagePoint")
	self.touchPanel = SoraDGetChildByName(self, "Panel_touch")
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_content")
	SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_pyramidSearch"):setTitle(i18n("common_text_3301"))
	self.touchPanel:setSwallowTouches(false)
	self.touchPanel:addTouchEventListener(handler(self, self.touchPanelClick))
	self.scrollSize = self.scroll:getContentSize()
	self.scrollHeigh = math.max(self.scrollSize.height, 900)
	self.btnRule = SoraDGetChildByName(self, "Button_rule")
	self.btnPrice = SoraDGetChildByName(self, "Button_price")
	self.btnPrice:setTitleText(i18n("common_text_2078"))
	self.btnRule:addTouchEventListener(handler(self, self.touchBtnClick))
	self.btnPrice:addTouchEventListener(handler(self, self.touchBtnClick))
	SoraDAddMessage(self, "MESSAGE_SERVER_PYRAMIDBATTLE_MAINSTATECHANGE", function(...)
		for k, v in pairs(self.groupNodes) do
			if v then
				v:updateView()
			end
		end
	end)
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_REQ_INFO_BACK", handler(self, self.sMsgReqAllianceInfoBack))
	SoraDAddMessage(self, "MESSAGE_SERVER_PYRAMIDBATTLE_ENTERBATTLEFAIL", handler(self, self.closeLoading))
	self:initGroup()
	self:initPagePoint()
	self:initData()
end
function PyramidPlayoffsView:closeLoading(target, redata)
	SoraDCloseLoading(self)
end
function PyramidPlayoffsView:sMsgReqAllianceInfoBack(target, data)
	local alliance = data.alliance
	if data.clientData then
		local from = data.clientData.from
		if from == "pyramidPlayoffsView" then
			SoraDOpenAllianceInfoView(alliance)
		end
	end
	SoraDCloseLoading(self)
end
function PyramidPlayoffsView:initGroup()
	local curGroupKey = pyramidWarCtrl:findPostSeasonKnockoutGroup(allianceMgr:getOwnAid())
	pyramidWarCtrl, self.curPageNum = pyramidWarCtrl, 1
	pyramidWarCtrl.A = 1
	pyramidWarCtrl.B = 2
	pyramidWarCtrl.C = 3
	local pyramidWarCtrl.D, toIndex = 4, pyramidWarCtrl
	if curGroupKey then
		self.curPageNum = toIndex[curGroupKey]
	end
	self.curGroupNode = self:getGroupNode(self.curPageNum)
	self.nextGroupNode = self:getGroupNode(self.curPageNum)
end
function PyramidPlayoffsView:initData()
	self:initView()
end
function PyramidPlayoffsView:initView(...)
	self.scroll:setInnerContainerSize(cc.size(self.scrollSize.width / 2, self.scrollHeigh))
	self.curGroupNode:setPosition(self.scrollSize.width / 2, self.scrollHeigh / 2)
	_ENV = self.scrollSize.width / 2
	;(self.scrollSize.width / 2).count = 4
	;(self.scrollSize.width / 2).intervalWidth = 50
	;(self.scrollSize.width / 2).begin = self.curPageNum
	self.pagePoint:initData(self.scrollSize.width / 2)
end
function PyramidPlayoffsView:initPagePoint(...)
	local pointNode = cc.Node:create()
	pointNode:setPosition(0, 0)
	pointNode:addTo(self.nodePagePoint)
	local imageItemBg = ccui.ImageView:create("frame_lace_09_02.png", ccui.TextureResType.plistType)
	imageItemBg:setName("Image_bg")
	imageItemBg:setPosition(0, 0)
	imageItemBg:addTo(pointNode)
	local imageLight = ccui.ImageView:create("frame_lace_09_01.png", ccui.TextureResType.plistType)
	imageLight:setName("Image_light")
	imageLight:setPosition(0, 0)
	imageLight:addTo(pointNode)
	self.pagePoint = include("commonScrollIndicatorNumber").new(pointNode)
end
function PyramidPlayoffsView:getGroupNode(index)
	local gametop = gModuleMgr.getObject("gametop")
	local pyramidWarCtrl = gametop.playertop_:getModule("pyramidWarCtrl")
	if self.groupNodes[index] then
		return self.groupNodes[index]
	else
		_ENV = self.groupNodes[index]
		self.groupNodes[index][1] = "A"
		self.groupNodes[index][2] = "B"
		self.groupNodes[index][3] = "C"
		local self.groupNodes[index][4], toKey = "D", self.groupNodes[index]
		local ocxMode = SoraDCreateCSBNode("pyramidPlayoffsGroupNode")
		ocxMode:addTo(self.scroll)
		ocxMode:setPositionX(-960)
		ocxMode = include("pyramidPlayoffsGroupNode").new(ocxMode)
		ocxMode:fillBlockInfo(pyramidWarCtrl:getPostSeasonKnockoutMatchInfo(toKey[index]), toKey[index])
		self.groupNodes[index] = ocxMode
		return self.groupNodes[index]
	end
end
function PyramidPlayoffsView:turnPage(foward)
	if not self.isTurnning then
		return
	end
	if foward == 1 then
		self.curPageNum = util.clampf(self.curPageNum + 1, 1, 4)
		self.pagePoint:setCurLight(self.curPageNum)
	elseif foward == -1 then
		self.curPageNum = util.clampf(self.curPageNum - 1, 1, 4)
		self.pagePoint:setCurLight(self.curPageNum)
	end
	self.nextGroupNode = self:getGroupNode(self.curPageNum)
	self.nextGroupNode:setVisible(true)
	self.isTurnning = false
	local turnningDone = cca.callFunc(function()
		if self.curGroupNode ~= self.nextGroupNode then
			self.curGroupNode:setVisible(false)
		end
		self.curGroupNode = self.nextGroupNode
		self.isTurnning = true
	end)
	if self.nextGroupNode == self.curGroupNode then
		self.isTurnning = true
	elseif foward == 1 then
		self.nextGroupNode:setPosition(960, self.scrollHeigh / 2)
		local action0 = cca.moveTo(0.2, 320, self.scrollHeigh / 2)
		local action1 = cca.moveTo(0.2, -320, self.scrollHeigh / 2)
		_UPVALUE1_ = nil
		;(nil)[1] = action0
		self.nextGroupNode:runAction(cca.seq(nil))
		_UPVALUE2_ = cca.seq(nil)
		cca.seq(nil)[1] = action1
		cca.seq(nil)[2] = turnningDone
		self.curGroupNode:runAction(cca.seq(cca.seq(nil)))
	elseif foward == -1 then
		self.nextGroupNode:setPosition(-320, self.scrollHeigh / 2)
		local action0 = cca.moveTo(0.2, 320, self.scrollHeigh / 2)
		local action1 = cca.moveTo(0.2, 960, self.scrollHeigh / 2)
		_UPVALUE1_ = cca.seq(cca.seq(nil))
		cca.seq(cca.seq(nil))[1] = action0
		self.nextGroupNode:runAction(cca.seq(cca.seq(cca.seq(nil))))
		_UPVALUE2_ = cca.seq(cca.seq(cca.seq(nil)))
		cca.seq(cca.seq(cca.seq(nil)))[1] = action1
		cca.seq(cca.seq(cca.seq(nil)))[2] = turnningDone
		self.curGroupNode:runAction(cca.seq(cca.seq(cca.seq(cca.seq(nil)))))
	end
end
function PyramidPlayoffsView:touchBtnClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if target == self.btnRule then
			userSDKManager.showFAQSection(gSDKDef.FAQSectionType.PYRAMID_BATTLE)
		elseif target == self.btnPrice then
			if pyramidWarCtrl.curSeasonType == gSeasonType.PINNACLE_SEASON then
				SoraDCreatePanel("alliancePBLPrizeView"):show()
			else
				SoraDCreatePanel("pyramidPlayoffsPriceView"):show()
			end
		end
	end
end
function PyramidPlayoffsView:touchPanelClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchEndPosition()
		if touchBeganPoint.x - touchmovePoint.x < -30 and math.abs(touchBeganPoint.y - touchmovePoint.y) < 100 then
			print("右移")
			self:turnPage(-1)
		elseif touchBeganPoint.x - touchmovePoint.x > 30 and math.abs(touchBeganPoint.y - touchmovePoint.y) < 100 then
			print("左移")
			self:turnPage(1)
		end
	end
end
return PyramidPlayoffsView
