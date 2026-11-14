local gametop = gModuleMgr.getObject("gametop")
local legendMCtrl = gametop.playertop_:getModule("legendMCtrl")
local legendMDesRead = include("legendMDesRead")
local baseComponent = require("fgui.base.baseComponent")
local SultanLegends = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ChronicleView/SultanLegends", SultanLegends)
function SultanLegends:onInit()
	self.wGet = false
	self.kingsData, legendMDesRead, self.listData, legendMDesRead, self.sIndex = nil, nil, nil, nil, 1
	self.pageType = legendMDesRead.PageType.KINGS
	self.pageTitle = i18n("history_text_34")
	self.fields.List:setItemRenderer(handler(self, self.onItemRederer))
	self.fields.Button_Top:addTouchEventListener(handler(self, self.onClick_btnGoTop))
	self.fields.List:addEventListener(fgui.UIEventType.PullUpRelease, handler(self, self.onPullEnd))
	self.fields.List:addEventListener(fgui.UIEventType.Scroll, handler(self, self.onScrollEnd))
end
function SultanLegends:onChooseClick(curKid)
	SoraDPlaySound()
	self.curKid = curKid
	self.kingsData, _ENV, self.listData, _ENV, self.sIndex = SoraDPlaySound, SoraDPlaySound, SoraDPlaySound, SoraDPlaySound, 1
	self:req4Data(self.sIndex)
	self.fields.List:jumpToTop()
end
function SultanLegends:req4Data(index)
	SoraDShowLoading()
	legendMCtrl:reqKings(index, self.curKid)
end
function SultanLegends:onPullEnd()
	if self.wGet then
		self:req4Data(self.sIndex)
	end
end
function SultanLegends:onScrollEnd()
	local inner = self.fields.List:getInnerContainer()
	local innerHeight = inner:getContentSize().height
	local posY = inner:getPositionY()
	local visible = false
	local scrollSize = self.fields.List:getContentSize()
	if innerHeight > scrollSize.height then
		print("posY", posY, innerHeight, scrollSize.height)
		if posY > scrollSize.height / 2 then
			visible = true
		end
	end
	self.fields.Button_Top:setVisible(visible)
	self.fields.Effect:setVisible(false)
end
function SultanLegends:setPageType(pageType)
	self.pageType = pageType
end
function SultanLegends:getTitle()
	return self.pageTitle
end
function SultanLegends:registerEvent()
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGENDM_KINGS_DATA_BACK", handler(self, self.sMsgKingsDataBack))
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGENDM_KINGDOM_DES_NOTIFY", handler(self, self.sMsgKingdomDesNotify))
end
function SultanLegends:onShow()
	self:req4Data(self.sIndex)
end
function SultanLegends:onItemRederer(index, target)
	target:initData(self.listData[index + 1])
end
function SultanLegends:sMsgKingsDataBack(target, data)
	print("legendMPageKings:sMsgKingsDataBack(target, data)")
	self.sIndex = data.idx
	self.wGet = data.wget
	self.isDataBack = true
	self.tempDataList = data.dataList
	self:initScroll()
end
function SultanLegends:initScroll()
	SoraDCloseLoading()
	if next(self.tempDataList) ~= nil then
		local cpyTbl = clone(self.tempDataList)
		for i, v in ipairs(cpyTbl) do
			table.insert(self.kingsData, v)
		end
		self.listData, _ENV = ipairs(cpyTbl)
		for i, v in ipairs(self.kingsData) do
			v.index = i
			_ENV = v
			v.index = i
			v.data = v
			table.insert(self.listData, v)
		end
		self.fields.List:setNumItems(#self.listData)
	end
	if not self.fingerAct then
		self:checkShowFinger()
		self.fingerAct = true
	end
end
function SultanLegends:sMsgKingdomDesNotify(target, data)
	local resetData = data.resetData
	local uid = data.uid
	for i, v in ipairs(self.kingsData) do
		if v.setType == resetData.setType and v.uid == resetData.uid then
			local isFound = false
			if v.setType == gKingBiographyType.king then
				isFound = true
			elseif v.round == resetData.round then
				isFound = true
			end
			if isFound then
				self.kingsData[i].content = resetData.content
				self.kingsData[i].activeContent = resetData.activeContent
				_ENV = resetData.activeContent
				resetData.activeContent.msg = "MESSAGE_SERVER_LEGENDM_KINGDOM_DES_NOTIFY_SUCCESS"
				resetData.activeContent.resetData = resetData
				resetData.activeContent.uid = uid
				SoraDSendMessage(resetData.activeContent)
				break
			end
		end
	end
end
function SultanLegends:checkShowFinger()
	local inner = self.fields.List:getInnerContainer()
	local innerHeight = inner:getContentSize().height
	local scrollSize = self.fields.List:getContentSize()
	if innerHeight > scrollSize.height then
		_ENV = nil
		;(nil).byUID = true
		if SoraDConfigGet("Game:legendMPageKings:scrollHandTip~bool", nil) == false then
			_ENV = nil
			;(nil).byUID = true
			SoraDConfigSet("Game:legendMPageKings:scrollHandTip~bool", true, nil)
			self:showFingerAction()
		end
	end
end
function SultanLegends:showFingerAction()
	self.fields.Effect:setVisible(true)
	self.fields.Effect:getTransition("t0"):play(-1, 0, 0, -1)
end
function SultanLegends:onClick_btnGoTop()
	SoraDPlaySound()
	self.fields.List:jumpToTop()
end
return SultanLegends
