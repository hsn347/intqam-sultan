local WorldMapKingdomCityOfficialManagerView = class("worldMapKingdomCityOfficialManagerView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("worldMapKingdomCityOfficialManagerView")
	end
	return target
end)
function WorldMapKingdomCityOfficialManagerView:ctor()
	self.resTest = nil
	self.isSelf = false
	self.windowTitle = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_kingManager")
	self.scroll = SoraDGetChildByName(self, "Bottom_Size_ScrollView_pageList")
	self.btnChangeName = SoraDGetChildByName(self, "Top_Button_changeName")
	self.nodeHead = SoraDGetChildByName(self, "Top_Node_head")
	self.btnChangeName:addTouchEventListener(handler(self, self.btnChangeNameClick))
	SoraDGetChildByName(self, "Image_bg"):setFillType(1)
	self.windowTitle:setTitleColor(cc.c3b(255, 200, 100))
	SoraDSetTextWidthHeight(self.windowTitle:returnTitle(), cc.size(250, 50))
	self.btnChangeName:setTitleText(i18n("common_text_363"))
	_UPVALUE6_ = self.btnChangeName.setTitleText
	self.btnChangeName.setTitleText[1] = "MESSAGE_SERVER_KINGDOMWAR_KINGDOMPALACE_CHANGED"
	self.btnChangeName.setTitleText[2] = "MESSAGE_SERVER_KINGDOMWAR_FLAG_CHANGED"
	self.btnChangeName.setTitleText[3] = "MESSAGE_SERVER_KINGDOMWAR_KINGDOMNAME_CHANGED"
	self.btnChangeName.setTitleText[4] = "MESSAGE_LORDINFO_UPDATE_BASE"
	self.btnChangeName.setTitleText[5] = "MESSAGE_SERVER_KINGDOMWAR_OFFICIAL_ADD"
	local self.btnChangeName.setTitleText[6], msgList = "MESSAGE_SERVER_KINGDOMWAR_OFFICIAL_SUB", self.btnChangeName.setTitleText
	for _, v in ipairs(msgList) do
		SoraDAddMessage(self, v, handler(self, self.refreshView))
	end
	SoraDAddMessage(self, "MESSAGE_SERVER_KINGDOMWAR_RESRATE_CHANGED", handler(self, self.resChangeFunc))
	SoraDAddMessage(self, "MESSAGE_SERVER_KINGDOMWAR_KINGDOMUSR_CHANGED", handler(self, self.judgeIsKing))
end
function WorldMapKingdomCityOfficialManagerView:judgeIsKing(target, redata)
	if SoraDClickFromKingManager() or SoraDIsSelfKing() or SoraDIsSelfQueen() then
		SoraDRemoveAllAfterPanelFromManager(self)
	else
		self:refreshView()
	end
end
function WorldMapKingdomCityOfficialManagerView:resChangeFunc(target, redata)
	local gametop = gModuleMgr.getObject("gametop")
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	SoraDGotoWorldMapPoint(cityCtrl:getCurCityPos(), false)
	self:removeFromParent()
end
function WorldMapKingdomCityOfficialManagerView:refreshView(...)
	self:reqData()
end
function WorldMapKingdomCityOfficialManagerView:initView()
	local gametop = gModuleMgr.getObject("gametop")
	local KWKingdomCtrl = gametop.playertop_:getModule("KWKingdomCtrl")
	if SoraDClickFromKingManager() then
		if KWKingdomCtrl:canChangeKingdomName() then
			self.btnChangeName:setVisible(true)
		else
			self.btnChangeName:setVisible(false)
		end
		_ENV = nil
		;(nil).kid = KWKingdomCtrl:getKingdomName(true)
		self.windowTitle:setTitle(i18n("common_text_342", nil))
	else
		self.btnChangeName:setVisible(false)
		self.windowTitle:setTitle(i18n("common_text_686"))
	end
	local nodeHead = SoraDCreatePanel("worldMapKingdomCityOfficialManagerHead")
	nodeHead:initData()
	nodeHead:setPosition(0, 0)
	nodeHead:addTo(self.nodeHead)
	local sSize = self.scroll:getContentSize()
	self.scroll:setPositionY(self.nodeHead:getPositionY() - nodeHead:getHeigh())
	self.scroll:setContentSize(cc.size(sSize.width, self.scroll:getPositionY()))
	local mainNode = cc.Node:create()
	local nodeGoodPerson = SoraDCreatePanel("worldMapKingdomCityOfficialManagerPerson")
	nodeGoodPerson:initData(false)
	local nodeBadPerson = SoraDCreatePanel("worldMapKingdomCityOfficialManagerPerson")
	nodeBadPerson:initData(true)
	nodeGoodPerson:setPosition(0, 0)
	nodeBadPerson:setPosition(0, nodeGoodPerson:getPositionY() - nodeGoodPerson:getHeigh())
	nodeGoodPerson:setScroll(self.scroll)
	nodeBadPerson:setScroll(self.scroll)
	nodeGoodPerson:addTo(mainNode)
	nodeBadPerson:addTo(mainNode)
	local sH = nodeGoodPerson:getHeigh() + nodeBadPerson:getHeigh()
	if SoraDClickFromKingManager() then
		local nodeResBalence = SoraDCreatePanel("worldMapKingdomCityOfficialManagerResBalence")
		nodeResBalence:setPosition(0, nodeBadPerson:getPositionY() - nodeBadPerson:getHeigh())
		nodeResBalence:addTo(mainNode)
		nodeResBalence:setScroll(self.scroll)
		sH = sH + nodeResBalence:getHeigh()
	end
	local sSize = self.scroll:getContentSize()
	self.scroll:setInnerContainerSize(cc.size(sSize.width, sH + 0))
	mainNode:setPosition(0, sH)
	mainNode:addTo(self.scroll)
	self:reqData()
end
function WorldMapKingdomCityOfficialManagerView:reqData()
	local gametop = gModuleMgr.getObject("gametop")
	local KWKingdomCtrl = gametop.playertop_:getModule("KWKingdomCtrl")
	KWKingdomCtrl:getOfficialData(SoraDClickFromKingManager() or SoraDIsLookMyKingdom(), true)
end
function WorldMapKingdomCityOfficialManagerView:btnChangeNameClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("worldMapKingdomCityChangeNamePop"):show()
	end
end
function WorldMapKingdomCityOfficialManagerView:onExitPanel(...)
	worldMapDefine.kingdomStatusManager = false
end
return WorldMapKingdomCityOfficialManagerView
