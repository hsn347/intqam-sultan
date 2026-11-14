local gametop = gModuleMgr.getObject("gametop")
local allianceBWList = gametop.playertop_:getModule("allianceBWList")
local memberMgr = gametop.playertop_:getModule("memberMgr")
local allianceDesRead = include("allianceDesRead")
local allianceQuery = gametop.playertop_:getModule("allianceQuery")
local AllianceBlackWhiteSingle = class("allianceBlackWhiteSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceBlackWhiteSingle")
	end
	return target
end)
function AllianceBlackWhiteSingle:ctor()
	self.scroll = nil
	self.singleIsMoved = false
	self.singleData, _ENV, self.listType = gAllianceBWListType.BLACK, gAllianceBWListType.BLACK, gAllianceBWListType.BLACK
	self.layerSingle = SoraDGetChildByName(self, "Panel_single")
	self.layerSingle:setSwallowTouches(false)
	self.labelName = SoraDGetChildByName(self, "Text_name")
	self.btnDelete = SoraDGetChildByName(self, "Button_delete")
	self.btnDelete:setTitleText(i18n("common_text_697"))
	self.spriteIcon = nil
	self.btnDelete:addTouchEventListener(handler(self, self.btnClickCallBack))
	self.layerSingle:addTouchEventListener(handler(self, self.btnClickAllianceCallBack))
	local member = memberMgr:getOwnMember()
	local rank = member:getProperty("rank")
	self.btnDelete:setVisible(rank >= gAllianceRank.R4)
end
function AllianceBlackWhiteSingle:setScroll(scroll)
	self.scroll = scroll
end
function AllianceBlackWhiteSingle:initData(data)
	self.listType = data.listType
	self.singleData = data.listData
	if self.spriteIcon then
		self.spriteIcon:removeFromParent()
		self.spriteIcon = nil
	end
	self.spriteIcon = SoraDGetAllianceFlagByFid(self.singleData.flag)
	self.spriteIcon:setScale(0.5)
	self.spriteIcon:addTo(self.layerSingle)
	self.spriteIcon:setPosition(SoraDFPoint(540, 66))
	_ENV = SoraDFPoint(540, 66)
	SoraDFPoint(540, 66).abbr = self.singleData.abbr
	SoraDFPoint(540, 66).name = self.singleData.name
	self.labelName:setString(i18n("common_text_186", SoraDFPoint(540, 66)))
end
function AllianceBlackWhiteSingle:btnClickAllianceCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		if not SoraDIsNodeVisibleOnScroll(button, self.scroll) then
			print("node is not on view")
			return
		end
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		SoraDShowLoading(SoraDSearchPanelFromManagerByName("allianceBlackWhiteView"))
		_ENV = SoraDSearchPanelFromManagerByName("allianceBlackWhiteView")
		_ENV, SoraDSearchPanelFromManagerByName("allianceBlackWhiteView").aid = self.singleData.aid, self.singleData.aid
		self.singleData.aid.from = "bwlist"
		allianceQuery:reqAllianceByID(SoraDSearchPanelFromManagerByName("allianceBlackWhiteView"))
	elseif type == ccui.TouchEventType.moved then
		local touchBeganPoint = button:getTouchBeganPosition()
		local touchmovePoint = button:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif type == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
function AllianceBlackWhiteSingle:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		if not SoraDIsNodeVisibleOnScroll(button, self.scroll) then
			print("node is not on view")
			return
		end
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		local notice = self.listType == gAllianceBWListType.BLACK and i18n("common_text_1679") or i18n("common_text_1680")
		_ENV = nil
		;(nil).alliance = self.singleData.name
		;(nil).list = notice
		SoraDShowMsgBox(i18n("common_text_1683", nil), i18n("common_text_054"), nil, function(backType)
			if backType == MSGBOX_CALLBACK_YES then
				allianceBWList:delAllianceBWList(self.singleData.aid, self.listType)
			end
		end)
	elseif type == ccui.TouchEventType.moved then
		local touchBeganPoint = button:getTouchBeganPosition()
		local touchmovePoint = button:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif type == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
return AllianceBlackWhiteSingle
