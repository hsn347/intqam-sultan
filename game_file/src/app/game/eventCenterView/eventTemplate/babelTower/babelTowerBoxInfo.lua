local babelTowerRead = gModuleMgr.sharedMgr("babelTowerRead")
local babelTowerBoxInfo = class("babelTowerBoxInfo", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateTouchPanel(target)
	end
	return target or SoraDCreateTouchPanel("babelTowerBoxInfo")
end)
function babelTowerBoxInfo:ctor(properties)
	self.canClick = true
	self.node = SoraDGetChildByName(self, "Center_Node")
	self.nodeCommonPopBox = SoraDGetExtendChildFromCCSByName(self.node, "CCS_commonPopBox_bg")
	self.textTip = SoraDGetChildByName(self.node, "Text_Tip")
	self.textTip:setString(i18n("Promise_Summit_text_05"))
	self.panelInside = SoraDGetChildByName(self, "Panel_Inside")
	self.panelOutside = SoraDGetChildByName(self, "Panel_Outside")
	self.nodeAward = SoraDGetChildByName(self.node, "Node_Award")
	self.btnLeft = SoraDGetChildByName(self, "Center_Button_Left")
	self.btnLeft:addTouchEventListener(handler(self, self.btnLeftClick))
	self.btnRight = SoraDGetChildByName(self, "Center_Button_Right")
	self.btnRight:addTouchEventListener(handler(self, self.btnRightClick))
end
function babelTowerBoxInfo:initData(floor)
	self.maxNum = babelTowerRead:getTowerNum()
	floor = math.min(self.maxNum, floor)
	self.curPage = floor * 0.1
	babelTowerRead = nil
	;(nil).num = self.curPage * 10
	self.nodeCommonPopBox:setTitleName(i18n("Promise_Summit_text_17", nil))
	babelTowerRead = i18n("Promise_Summit_text_17", nil)
	i18n("Promise_Summit_text_17", nil).num = self.curPage * 10
	self.textTip:setString(i18n("Promise_Summit_text_05", i18n("Promise_Summit_text_17", nil)))
	self:initAwardNode(self.panelInside)
end
function babelTowerBoxInfo:initAwardNode(parent)
	_UPVALUE2_ = babelTowerRead
	babelTowerRead[1] = "id"
	babelTowerRead[2] = "count"
	self.reward = serviceFunctions.tableFormat(babelTowerRead:getBoxReward(self.curPage * 10), babelTowerRead)
	local nodeAward = SoraDGetChildByName(parent, "Node_Award")
	nodeAward:removeAllChildren()
	if next(self.reward) then
		for i, v in ipairs(self.reward) do
			local single = include("commonItemAward").new()
			single:setScale(0.9)
			single:setOwnView(self)
			single:setPosition(0, 0)
			single:addTo(nodeAward)
			single:initData(v.id, v.count)
		end
	end
	SoraDautoSortPos(nodeAward, 4, 1, cc.size(100, 100), SoraDFIsRA())
end
function babelTowerBoxInfo:btnLeftClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.canClick then
			self.canClick = false
			self:getLookLv(SoraDFIsRA(), false)
		end
	end
end
function babelTowerBoxInfo:btnRightClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.canClick then
			self.canClick = false
			self:getLookLv(not SoraDFIsRA(), true)
		end
	end
end
local maxPage = 10
function babelTowerBoxInfo:getLookLv(isAdd, tureRight)
	self.curPage = self.curPage + (isAdd and 1 or -1)
	self.curPage = self.curPage <= 0 and maxPage or self.curPage
	self.curPage = self.curPage > maxPage and 1 or self.curPage
	local curLookLv = SoraDFIsRA() and maxPage - self.curPage + 1 or self.curPage
	print("curLookLv", curLookLv, self.curPage)
	maxPage = nil
	;(nil).num = self.curPage * 10
	self.nodeCommonPopBox:setTitleName(i18n("Promise_Summit_text_17", nil))
	maxPage = i18n("Promise_Summit_text_17", nil)
	i18n("Promise_Summit_text_17", nil).num = self.curPage * 10
	self.textTip:setString(i18n("Promise_Summit_text_05", i18n("Promise_Summit_text_17", nil)))
	self:initAwardNode(self.panelOutside)
	local posY = 85
	local posX = 837
	if tureRight then
		self.panelOutside:setPositionX(posX)
		transition.execute(self.panelOutside, cca.moveTo(0.2, 287, posY))
		transition.execute(self.panelInside, cca.moveTo(0.2, -posX, posY))
	else
		self.panelOutside:setPositionX(-posX)
		transition.execute(self.panelOutside, cca.moveTo(0.2, 287, posY))
		transition.execute(self.panelInside, cca.moveTo(0.2, posX, posY))
	end
	maxPage = cca.moveTo(0.2, posX, posY)
	cca.moveTo(0.2, posX, posY).delay = 0.3
	cca.moveTo(0.2, posX, posY).onComplete = function()
		self.panelOutside, self.panelInside = self.panelInside, self.panelOutside
		self.canClick = true
	end
	transition.execute(self, nil, cca.moveTo(0.2, posX, posY))
	return curLookLv
end
return babelTowerBoxInfo
