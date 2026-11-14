local colorPrepare = cc.c3b(0, 190, 30)
local colorActive = cc.c3b(238, 33, 33)
local colorFinish = cc.c3b(230, 180, 110)
local gametop = gModuleMgr.getObject("gametop")
local hegemonCtrl = gametop.playertop_:getModule("hegemonCtrl")
local hegemonRead = include("hegemonRead")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local legendLordWarltCtrl = include("legendLordWarltCtrl")
local hegemonKingView = class("hegemonKingView", function(target)
	local isCreateUI = false
	if isCreateUI then
		local view = include("baseView")
		return view.new(cc.size(0, 0), false)
	else
		if target == nil then
			return SoraDCreateTouchPanel("hegemonKingView")
		end
		if type(target) == "string" then
			return SoraDCreateBasePanel(target)
		end
		return target
	end
end)
function hegemonKingView:ctor()
	self.scaleActTarget = SoraDGetChildByName(self, "Center_Node")
	self:createUI()
	self.Center_Node = SoraDGetChildByName(self, "Center_Node")
	self.commonPopBox_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.img_build_icon = SoraDGetChildByName(self, "img_build_icon")
	self.text_status = SoraDGetChildByName(self, "text_status")
	self.text_time = SoraDGetChildByName(self, "text_time")
	self.text_coordinate = SoraDGetChildByName(self, "text_coordinate")
	self.frame_title_lace_R = SoraDGetChildByName(self, "frame_title_lace_R")
	self.frame_title = SoraDGetChildByName(self, "frame_title")
	self.frame_title_lace_L = SoraDGetChildByName(self, "frame_title_lace_L")
	self.frame_sheer_items_R = SoraDGetChildByName(self, "frame_sheer_items_R")
	self.frame_sheer_items_L = SoraDGetChildByName(self, "frame_sheer_items_L")
	self.frame_sep_line = SoraDGetChildByName(self, "frame_sep_line")
	self.bg_status = SoraDGetChildByName(self, "bg_status")
	self.bg_title = SoraDGetChildByName(self, "bg_title")
	self.ScrollView_Content = SoraDGetChildByName(self, "ScrollView_Content")
	self.text_kingdom_des = SoraDGetChildByName(self, "text_kingdom_des")
	self.btn_jump = SoraDGetChildByName(self, "btn_jump")
	self.btn_jump:addTouchEventListener(handler(self, self.onClickJump))
	_ENV = handler(self, self.onClickJump)
	handler(self, self.onClickJump).build = ""
	self.commonPopBox_bg:setTitleName(i18n("hegemon_text_32", handler(self, self.onClickJump)))
	self.timeHandler = nil
	self.img_build_icon:ignoreContentAdaptWithSize(true)
end
function hegemonKingView:createUI()
	local CCSUICreator = include("CCSUICreator")
end
function hegemonKingView:onClickJump(sender, event)
	if event == ccui.TouchEventType.began then
	elseif event == ccui.TouchEventType.moved then
	elseif event == ccui.TouchEventType.canceled then
	elseif event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local coordinate = self.coordinate
		SoraDGotoWorldMapPoint(coordinate, false, worldMapDefine.LEGENDLORD_KINGDOM_ID)
		self:closePanel()
		SoraDRemoveAllPanelFromManager()
	end
end
function hegemonKingView:init(data)
	dump(data, "hegemonKingView:init", 10)
	local bid = data.bid
	self.bid = bid
	self.activityID = hegemonRead.getActivityIdByBuildID(self.bid)
	self:updateBaseView()
	if hegemonCtrl:getBuildKingdomList(bid) then
		self:initView()
	else
		SoraDShowLoading(self)
		hegemonCtrl:reqBuildKingdomList()
	end
end
function hegemonKingView:updateBaseView()
	local bid = self.bid
	local name = hegemonRead.getName(bid)
	hegemonRead = nil
	;(nil).build = name
	self.commonPopBox_bg:setTitleName(i18n("hegemon_text_32", nil))
	self.frame_title:setString(name)
	local icon = hegemonRead.getIcon(bid)
	self.img_build_icon:loadTexture(icon, ccui.TextureResType.plistType)
	local buildInfo = legendLordWarltCtrl.getLegendLordWarBuildingById(bid)
	hegemonRead = ccui.TextureResType.plistType
	ccui.TextureResType.plistType.x = buildInfo.x
	ccui.TextureResType.plistType.y = buildInfo.y
	local strCoordinate = i18n("common_text_2155", ccui.TextureResType.plistType)
	self.text_coordinate:setString(strCoordinate)
	hegemonRead = self.text_coordinate.setString
	self.text_coordinate.setString.x = buildInfo.x
	self.coordinate, self.text_coordinate.setString.y = self.text_coordinate.setString, buildInfo.y
	if self.timeHandler == nil then
		self:beginTime()
	end
	local param = activityShowCtrl:getParamByID(self.activityID)
	local curState = param.curState
	local strColor = colorFinish
	if curState == ACTIVITY_STATE.PREPARE then
		strStatus = i18n("common_text_4210")
		strColor = colorPrepare
		self.text_time:setVisible(true)
	elseif curState == ACTIVITY_STATE.ACTIVE then
		strStatus = i18n("common_text_343")
		strColor = colorActive
		self.text_time:setVisible(true)
	elseif curState == ACTIVITY_STATE.SETTLE then
		strColor = colorFinish
		strStatus = i18n("common_text_1859")
	else
		strStatus = i18n("common_text_1859")
	end
	self.text_status:setString(strStatus)
	self.text_status:setColor(strColor)
end
function hegemonKingView:beginTime()
	if self.timeHandler then
		SoraDManagerRemoveTimer(self, self.timeHandler)
		self.timeHandler = nil
	end
	self:updateTime()
	self.timeHandler = SoradCreateTimer(self, handler(self, self.updateTime))
end
function hegemonKingView:updateTime()
	local curState = activityShowCtrl:getParamByID(self.activityID).curState
	local textTarget = self.text_time
	local textKey = ""
	if curState == ACTIVITY_STATE.PREPARE or curState == ACTIVITY_STATE.ACTIVE then
		if curState == ACTIVITY_STATE.PREPARE then
			textKey = "common_text_606"
		else
			textKey = "common_text_607"
		end
		local eid = self.activityID
		local eventLeftTime = activityShowCtrl:getTimeInfoByID(eid)
		if eventLeftTime then
			local timerNode = eventLeftTime.timerNode
			if textTarget and timerNode then
				activityShowCtrl = nil
				;(nil).time = SoraDConvertSecondToString(timerNode.timer:getRemainTime())
				textTarget:setString(i18n(textKey, nil))
			end
		end
	else
	end
end
function hegemonKingView:endTime()
	if self.timeHandler then
		SoraDManagerRemoveTimer(self, self.timeHandler)
	end
end
function hegemonKingView:initView()
	local activityId = hegemonRead.getActivityIdByBuildID(self.bid)
	local kingdomList = hegemonCtrl:getBuildKingdomList(self.bid)
	if not kingdomList then
		return
	end
	local kids = kingdomList.kids
	local sortKids = clone(kids)
	table.sort(sortKids, function(a, b)
		return a < b
	end)
	local contentW = self.ScrollView_Content:getContentSize().width
	local colNum = 9
	local xPadding = 10
	local singleW = (contentW - xPadding * 2) / colNum
	local singleH = 40
	local totalNum = #sortKids
	local totalH = math.ceil(totalNum / colNum) * singleH
	local scrollSize = self.ScrollView_Content:getContentSize()
	local maxH = math.max(totalH + 20, scrollSize.height)
	local offsetY = 10
	local textKid
	for i, v in ipairs(sortKids) do
		local xMod = math.fmod(i, colNum)
		local xIndex = xMod == 0 and colNum or xMod
		local xPos = SoraDFIsRA() and contentW - (xIndex - 1) * singleW - singleW / 2 - xPadding or (xIndex - 1) * singleW + singleW / 2 + xPadding
		local yIndex = math.ceil(i / colNum)
		local yPos = maxH - yIndex * singleH + singleH / 2 - offsetY
		if i == 1 then
			textKid = self.text_kingdom_des
		else
			textKid = self.text_kingdom_des:clone()
			textKid:addTo(self.ScrollView_Content)
		end
		textKid:setString("#" .. v)
		textKid:setPosition(cc.p(xPos, yPos))
	end
	self.ScrollView_Content:setInnerContainerSize(cc.size(scrollSize.width, maxH))
end
function hegemonKingView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_HEGEMON_BUILD_KINGDOM_LIST_BACK", handler(self, self.sMsgHandlerKingdomList))
end
function hegemonKingView:sMsgHandlerKingdomList(target, data)
	SoraDCloseLoading(self)
	self:initView()
end
return hegemonKingView
